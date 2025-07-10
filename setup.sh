#!/bin/bash

set -e

echo "=== Arch Linux Post-Installation Setup ==="
echo "Setting up leftwm, polybar, feh, picom, alacritty, and brave..."

# Remove existing desktop environments
echo "Removing existing desktop environments..."
sudo pacman -Rns --noconfirm gnome gnome-extra 2>/dev/null || true
sudo pacman -Rns --noconfirm kde-applications kdebase-meta 2>/dev/null || true
sudo pacman -Rns --noconfirm xfce4 xfce4-goodies 2>/dev/null || true
sudo pacman -Rns --noconfirm lxde lxde-common 2>/dev/null || true
sudo pacman -Rns --noconfirm mate mate-extra 2>/dev/null || true
sudo pacman -Rns --noconfirm cinnamon 2>/dev/null || true
sudo pacman -Rns --noconfirm budgie-desktop 2>/dev/null || true
sudo pacman -Rns --noconfirm deepin deepin-extra 2>/dev/null || true
sudo pacman -Rns --noconfirm i3-wm i3blocks i3status i3lock 2>/dev/null || true

# Remove common display managers
echo "Removing existing display managers..."
sudo systemctl disable gdm.service 2>/dev/null || true
sudo systemctl disable sddm.service 2>/dev/null || true
sudo systemctl disable lxdm.service 2>/dev/null || true
sudo pacman -Rns --noconfirm gdm sddm lxdm 2>/dev/null || true

# Clean orphaned packages
echo "Cleaning orphaned packages..."
sudo pacman -Rns $(pacman -Qtdq) --noconfirm 2>/dev/null || true

# Install yay AUR helper
echo "Installing yay AUR helper..."
if ! command -v yay &> /dev/null; then
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ~
    rm -rf /tmp/yay
    echo "yay installed successfully"
else
    echo "yay already installed"
fi

# Update system
echo "Updating system packages..."
sudo pacman -Syu --noconfirm

# Install packages
echo "Installing required packages..."
sudo pacman -S --needed --noconfirm \
    leftwm \
    polybar \
    feh \
    picom \
    alacritty \
    brave-bin \
    git \
    base-devel \
    wget \
    unzip \
    ttf-font-awesome \
    ttf-dejavu \
    noto-fonts \
    nitrogen \
    rofi \
    dunst \
    lightdm \
    lightdm-gtk-greeter \
    virtualbox-guest-utils \
    xorg-xrandr

# Create config directories
echo "Creating configuration directories..."
mkdir -p ~/.config/leftwm/themes/basic
mkdir -p ~/.config/polybar
mkdir -p ~/.config/alacritty
mkdir -p ~/.config/picom
mkdir -p ~/Pictures/wallpapers

# Copy configuration files
echo "Copying configuration files..."
cp config/leftwm/config.ron ~/.config/leftwm/
cp config/leftwm/themes.ron ~/.config/leftwm/
cp config/leftwm/themes/basic/* ~/.config/leftwm/themes/basic/
cp config/polybar/config.ini ~/.config/polybar/
cp config/alacritty/alacritty.yml ~/.config/alacritty/
cp config/picom/picom.conf ~/.config/picom/

# Configure lightdm
echo "Configuring lightdm..."
sudo systemctl enable lightdm.service
sudo systemctl enable vboxservice.service

# Create leftwm desktop entry
sudo mkdir -p /usr/share/xsessions
sudo tee /usr/share/xsessions/leftwm.desktop > /dev/null <<EOF
[Desktop Entry]
Name=LeftWM
Comment=A tiling window manager
Exec=leftwm
Type=XSession
EOF

# Configure 1440p resolution persistence
echo "Configuring 1440p resolution..."
mkdir -p ~/.config/autostart

# Create xrandr autostart for resolution
tee ~/.config/autostart/resolution.desktop > /dev/null <<EOF
[Desktop Entry]
Type=Application
Name=Set Resolution
Exec=xrandr --output Virtual-1 --mode 2560x1440 --rate 60
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
EOF

# Create .xprofile for display manager
tee ~/.xprofile > /dev/null <<EOF
#!/bin/sh
# Set 1440p resolution on login
xrandr --output Virtual-1 --mode 2560x1440 --rate 60 2>/dev/null || true
EOF

chmod +x ~/.xprofile

# Make scripts executable
chmod +x ~/.config/leftwm/themes/basic/up
chmod +x ~/.config/leftwm/themes/basic/down

# Download a sample wallpaper
echo "Setting up wallpaper..."
if [ ! -f ~/Pictures/wallpapers/default.jpg ]; then
    wget -O ~/Pictures/wallpapers/default.jpg "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=2560&h=1440&fit=crop" || echo "Wallpaper download failed, please add manually"
fi

echo "=== Setup Complete! ==="
echo "Please reboot and select 'LeftWM' from the login screen."
echo "LightDM has been enabled and configured."
echo "System configured for 1440p resolution (2560x1440)."
echo "Make sure to set your VirtualBox display to 2560x1440 in VM settings."
