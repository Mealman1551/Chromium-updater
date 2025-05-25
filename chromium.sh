#!/bin/bash

set -e

INSTALL_DIR="$HOME/chromium"
USERDATA_DIR="$INSTALL_DIR/user-data"
ZIP_PATH="$HOME/Downloads/chromium.zip"
TMP_DIR="$HOME/Downloads/chromium_tmp"
echo "#############################################"
echo "# Chromium Automatic downloader and updater #"
echo "#############################################"
echo ""
echo "→ Checking for required tools..."
if ! command -v wget &> /dev/null || ! command -v unzip &> /dev/null; then
    echo "Error: wget and unzip are required but not installed."
    echo "Please install them and try again."
    exit 1
fi
echo "→ Required tools are available."
echo ""

mkdir -p "$INSTALL_DIR"
mkdir -p "$USERDATA_DIR"

echo "→ Closing Chromium (If active)..."
pkill -f "$INSTALL_DIR/chrome" 2>/dev/null || true

echo "→ Receiving latest build..."
BUILD=$(wget -qO- https://commondatastorage.googleapis.com/chromium-browser-snapshots/Linux_x64/LAST_CHANGE)
ZIP_URL="https://commondatastorage.googleapis.com/chromium-browser-snapshots/Linux_x64/$BUILD/chrome-linux.zip"

echo "→ Downloading Chromium (build $BUILD)..."
wget -q -O "$ZIP_PATH" "$ZIP_URL"

echo "→ Preparing temporary directory..."
rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"

echo "→ Unzipping Chromium..."
unzip -q "$ZIP_PATH" -d "$TMP_DIR"

echo "→ Deleting old Chromium without deleting user-data..."
find "$INSTALL_DIR" -mindepth 1 -not -name "user-data" -exec rm -rf {} +

echo "→ Installing new Chromium..."
shopt -s dotglob
mv "$TMP_DIR/chrome-linux/"* "$INSTALL_DIR/"
shopt -u dotglob

echo "→ Downloading Chromium SVG icon..."
wget -q -O "$INSTALL_DIR/chromium_icon.svg" "https://upload.wikimedia.org/wikipedia/commons/2/28/Chromium_Logo.svg"

echo "→ Cleaing up..."
rm -rf "$ZIP_PATH" "$TMP_DIR"

echo "Chromium is updated/installed in $INSTALL_DIR"
echo ""

if ! unshare --user --mount echo test &>/dev/null; then
    echo "    Warning: Your system does not support unprivileged user namespaces."
    echo "    Chromium will only start with --no-sandbox, which is less secure."
    echo "    See: https://chromium.googlesource.com/chromium/src/+/main/docs/security/apparmor-userns-restrictions.md"
    echo ""
fi

echo "→ Creating .desktop file..."

DESKTOP_FILE="$HOME/.local/share/applications/chromium.desktop"

cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=Chromium
Exec=$INSTALL_DIR/chrome --user-data-dir=$USERDATA_DIR --no-sandbox
Comment=Chromium Web Browser
Terminal=false
Icon=$INSTALL_DIR/chromium_icon.svg
Type=Application
Categories=Network;WebBrowser;
EOF

chmod +x "$DESKTOP_FILE"

echo "Launcher created: $DESKTOP_FILE"
echo "Chromium is ready to use."
echo ""
echo "Start Chromium via:"
echo "$INSTALL_DIR/chrome --user-data-dir=$USERDATA_DIR"
