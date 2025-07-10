# Arch Linux LeftWM Setup

A complete post-installation setup script for Arch Linux with LeftWM tiling window manager, designed for VirtualBox environments.

## What This Script Does

This script configures a minimal, modern desktop environment with:
- **LeftWM** - Tiling window manager
- **Polybar** - Status bar
- **Alacritty** - Terminal emulator
- **Picom** - Compositor for transparency and effects
- **Feh** - Wallpaper management
- **Brave** - Web browser
- **LightDM** - Display manager
- **Rofi** - Application launcher
- **Dunst** - Notification daemon

## Prerequisites

### System Requirements
- Fresh Arch Linux installation (base system)
- Internet connection
- User with sudo privileges
- VirtualBox Guest Additions (for VM users)

### Before Running the Script

1. **Complete Base Arch Installation**
   ```bash
   # Ensure you have completed the basic Arch installation:
   # - Bootloader installed (GRUB/systemd-boot)
   # - Network configured
   # - User account created with sudo access
   ```

2. **Install Essential Packages**
   ```bash
   sudo pacman -S --needed git base-devel
   ```

3. **VirtualBox Configuration** (if using VM)
   - Set VM display to at least 128MB video memory
   - Enable 3D acceleration in VM settings
   - Install VirtualBox Guest Additions (handled by script)
   - Configure VM display resolution to 2560x1440

4. **Clone This Repository**
   ```bash
   git clone <repository-url>
   cd urban-happiness
   ```

## Installation

### Quick Start
```bash
chmod +x setup.sh
./setup.sh
```

### What the Script Will Do

1. **Cleanup Phase**
   - Remove existing desktop environments (GNOME, KDE, XFCE, etc.)
   - Remove conflicting display managers
   - Clean orphaned packages

2. **Installation Phase**
   - Install yay AUR helper
   - Update system packages
   - Install LeftWM and required components
   - Install fonts and utilities

3. **Configuration Phase**
   - Copy all configuration files
   - Configure LightDM display manager
   - Set up 1440p resolution persistence
   - Download sample wallpaper

4. **Service Setup**
   - Enable LightDM service
   - Enable VirtualBox services
   - Create LeftWM desktop session entry

## Post-Installation

### First Boot
1. Reboot the system: `sudo reboot`
2. At the login screen, select "LeftWM" session
3. Log in with your user credentials

### Key Bindings (Default)
- `Super + Return` - Open terminal (Alacritty)
- `Super + d` - Application launcher (Rofi)
- `Super + b` - Open Brave browser
- `Super + q` - Close window
- `Super + Space` - Change layout
- `Super + 1-9` - Switch to workspace
- `Super + Shift + 1-9` - Move window to workspace
- `Super + h/l` - Switch between workspaces
- `Super + j/k` - Focus window up/down

### Customization

#### Wallpapers
- Add wallpapers to `~/Pictures/wallpapers/`
- Edit `~/.config/leftwm/themes/basic/up` to change wallpaper

#### Polybar
- Configuration: `~/.config/polybar/config.ini`
- Restart: `pkill polybar && polybar main &`

#### LeftWM
- Configuration: `~/.config/leftwm/config.ron`
- Reload: `Super + Shift + r`

#### Terminal (Alacritty)
- Configuration: `~/.config/alacritty/alacritty.yml`

#### Compositor (Picom)
- Configuration: `~/.config/picom/picom.conf`

## Troubleshooting

### Resolution Issues
```bash
# Check available resolutions
xrandr

# Manually set resolution
xrandr --output Virtual-1 --mode 2560x1440 --rate 60
```

### Services Not Starting
```bash
# Check service status
systemctl status lightdm
systemctl status vboxservice

# Restart services
sudo systemctl restart lightdm
```

### LeftWM Not Loading
```bash
# Check LeftWM logs
journalctl -u leftwm

# Restart LeftWM
Super + Shift + r
```

### Missing Packages
```bash
# Install missing AUR packages with yay
yay -S package-name

# Check for updates
yay -Syu
```

## File Structure

```
urban-happiness/
├── setup.sh                           # Main setup script
├── README.md                          # This file
├── config/
│   ├── leftwm/
│   │   ├── config.ron                 # LeftWM configuration
│   │   ├── themes.ron                 # Theme settings
│   │   └── themes/basic/
│   │       ├── up                     # Theme startup script
│   │       └── down                   # Theme shutdown script
│   ├── polybar/
│   │   └── config.ini                 # Polybar configuration
│   ├── alacritty/
│   │   └── alacritty.yml              # Terminal configuration
│   └── picom/
│       └── picom.conf                 # Compositor configuration
```

## Support

For issues or customization help:
1. Check LeftWM documentation: https://github.com/leftwm/leftwm
2. Arch Wiki: https://wiki.archlinux.org/
3. Create an issue in this repository

## Notes

- This script is optimized for VirtualBox environments
- 1440p resolution is configured by default
- Script removes existing desktop environments - use with caution
- Backup important configurations before running
