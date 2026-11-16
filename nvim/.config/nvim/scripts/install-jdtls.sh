#!/usr/bin/env bash
# Install a pinned jdtls (Eclipse JDT Language Server) outside Mason.
#
# Why: jdtls 1.63+ needs Java 25. 1.61.0 runs on Java 21, and Mason cannot pin it
# (the registry URL has a build timestamp baked in), so Mason would keep upgrading it.
#
# Installs to ${XDG_DATA_HOME:-~/.local/share}/nvim/jdtls/<version>, which is where
# ftplugin/java.lua looks. To change version, update VERSION, BUILD and SHA256 here
# and JDTLS_VERSION in ftplugin/java.lua.

set -euo pipefail

VERSION="1.61.0"
BUILD="202609031315"
SHA256="338e7e73d61836651ba2453919a0d34fa763eb4e7c03342092309bffb8934c64"

FILE="jdt-language-server-${VERSION}-${BUILD}.tar.gz"
URL="${JDTLS_URL:-https://download.eclipse.org/jdtls/milestones/${VERSION}/${FILE}}"
LOMBOK_URL="${LOMBOK_URL:-https://projectlombok.org/downloads/lombok.jar}"

TARGET="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/jdtls/${VERSION}"

for tool in curl tar sha256sum; do
  command -v "$tool" >/dev/null || { echo "missing required tool: $tool" >&2; exit 1; }
done

if [[ -e "$TARGET" ]]; then
  echo "jdtls ${VERSION} is already installed at ${TARGET}"
  exit 0
fi

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

echo "Downloading ${FILE} ..."
curl -fL --progress-bar -o "$tmp/$FILE" "$URL"

echo "Verifying checksum ..."
echo "${SHA256}  ${tmp}/${FILE}" | sha256sum --check --status \
  || { echo "checksum mismatch for ${FILE}, not installing" >&2; exit 1; }

mkdir -p "$tmp/extract"
tar -xzf "$tmp/$FILE" -C "$tmp/extract"

# Lombok is optional (ftplugin/java.lua loads it only if present). It is not pinned:
# it is a javac agent that stays backwards compatible, and a failure here is not fatal.
if ! curl -fsSL -o "$tmp/extract/lombok.jar" "$LOMBOK_URL"; then
  echo "warning: could not download lombok.jar, continuing without it" >&2
  rm -f "$tmp/extract/lombok.jar"
fi

mkdir -p "$(dirname "$TARGET")"
mv "$tmp/extract" "$TARGET"
echo "Installed jdtls ${VERSION} to ${TARGET}"
