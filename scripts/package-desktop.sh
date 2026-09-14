#!/usr/bin/env bash
# Build a self-contained, clickable Rabitah app image on Linux or macOS.
# The matching OS must build its own image; use the GitHub workflow for all platforms.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
API_URL="${RABITAH_API_BASE_URL:-https://rabitah-projectm-production.up.railway.app/api/v1}"
FRONTEND="$ROOT/Rabitah-Frontend"
OUTPUT="$ROOT/dist"
INPUT="$(mktemp -d)"
trap 'rm -rf "$INPUT"' EXIT

cd "$ROOT"
mvn -q -pl Rabitah-Frontend -am -DskipTests package
cp "$FRONTEND/target/Rabitah.jar" "$INPUT/"
cp "$FRONTEND"/target/desktop-libs/*.jar "$INPUT/"

mkdir -p "$OUTPUT"
rm -rf "$OUTPUT/Rabitah" "$OUTPUT/Rabitah.app"

OS="$(uname -s)"
ICON="$FRONTEND/src/main/resources/com/rabitah/frontend/images/rabitah-app-icon-round-v1.png"
OPTIONS=(--type app-image --input "$INPUT" --name Rabitah --main-jar Rabitah.jar
  --main-class com.rabitah.frontend.RabitahLauncher --dest "$OUTPUT" --app-version 1.0.0
  --vendor "Rabitah" --description "Rabitah campus platform" --java-options "-Drabitah.api=$API_URL")

if [[ "$OS" == "Linux" ]]; then
  OPTIONS+=(--icon "$ICON")
elif [[ "$OS" == "Darwin" ]]; then
  ICONSET="$INPUT/rabitah.iconset"
  MAC_ICON="$INPUT/rabitah.icns"
  mkdir -p "$ICONSET"
  sips -z 16 16 "$ICON" --out "$ICONSET/icon_16x16.png" >/dev/null
  sips -z 32 32 "$ICON" --out "$ICONSET/icon_16x16@2x.png" >/dev/null
  sips -z 32 32 "$ICON" --out "$ICONSET/icon_32x32.png" >/dev/null
  sips -z 64 64 "$ICON" --out "$ICONSET/icon_32x32@2x.png" >/dev/null
  sips -z 128 128 "$ICON" --out "$ICONSET/icon_128x128.png" >/dev/null
  sips -z 256 256 "$ICON" --out "$ICONSET/icon_128x128@2x.png" >/dev/null
  sips -z 256 256 "$ICON" --out "$ICONSET/icon_256x256.png" >/dev/null
  sips -z 512 512 "$ICON" --out "$ICONSET/icon_256x256@2x.png" >/dev/null
  sips -z 512 512 "$ICON" --out "$ICONSET/icon_512x512.png" >/dev/null
  sips -z 1024 1024 "$ICON" --out "$ICONSET/icon_512x512@2x.png" >/dev/null
  iconutil -c icns "$ICONSET" -o "$MAC_ICON"
  OPTIONS+=(--icon "$MAC_ICON")
elif [[ "$OS" != "Darwin" ]]; then
  echo "Run this script on Linux or macOS. On Windows use scripts/package-desktop.ps1."
  exit 1
fi

jpackage "${OPTIONS[@]}"
echo "Built clickable app image: $OUTPUT"
