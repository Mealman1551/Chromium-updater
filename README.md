# Chromium Auto-Updater and Installer for Linux

[![License](https://img.shields.io/badge/License-GPL%20v3-blue.svg?style=plastic)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Linux-purple.svg?style=plastic)](#)
[![Status](https://img.shields.io/badge/Develpment-Active-success.svg?style=plastic)](#)
[![Shell Script](https://img.shields.io/badge/Language-Bash-89e051.svg?style=plastic)](#)


This script automatically downloads and installs the latest official **Chromium** build for Linux from the [Chromium Snapshot Builds](https://commondatastorage.googleapis.com/chromium-browser-snapshots/index.html). It also creates a `.desktop` launcher for easier access from your application menu.

## Features

- Automatically fetches the latest Chromium build
- Gracefully shuts down any running Chromium instance
- Extracts and installs Chromium to `~/chromium`
- Keeps user data (`user-data` folder) intact across updates
- Creates a `.desktop` file for launching Chromium from the menu
- Uses `--no-sandbox` if your system disables unprivileged user namespaces

## Requirements

Make sure the following tools are installed on your system:

- `wget`
- `unzip`

Install them using your package manager, for example on Debian/Ubuntu:

```bash
sudo apt update
sudo apt install wget unzip
```
## Usage

Download or clone this repository.

Run the script:
```bash
chmod +x chromium.sh
```
```bash
./chromium.sh
```
### Launch Chromium:

From your application menu

Or from terminal:
```bash
~/chromium/chrome --user-data-dir=~/chromium/user-data
```
## Security Note

If your system disables unprivileged user namespaces (common on newer Ubuntu versions and AppArmor-based setups), the script will configure Chromium to launch with the --no-sandbox flag.

This is not secure for general browsing. Use it only for development, testing, or isolated environments.

For more details, see:

[Chromium AppArmor User Namespace Restrictions](https://chromium.googlesource.com/chromium/src/+/main/docs/security/apparmor-userns-restrictions.md)

[Chromium SUID Sandbox Development Info](https://chromium.googlesource.com/chromium/src/+/main/docs/linux/suid_sandbox_development.md)

### Notes

Chromium will be installed in ~/chromium

Your user data is stored in ~/chromium/user-data

The .desktop file will be placed in ~/.local/share/applications/chromium.desktop

#### License

This scipt is licensed under the GNU GPL v3

---

##### Made with ❤️ by Mealman1551

###### &copy; 2025 Mealman1551
