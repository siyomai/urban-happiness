#!/bin/bash

set -e

echo "=== Arch Linux Post-Installation Setup ==="
echo "Setting up leftwm, polybar, feh, picom, alacritty, and firefox..."

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

# Install packages from official repositories
echo "Installing required packages from official repositories..."
sudo pacman -S --needed --noconfirm \
    polybar \
    feh \
    picom \
    alacritty \
    firefox \
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
    xorg-xrandr \
    xorg-server \
    xorg-xinit \
    mesa

# Install AUR packages
echo "Installing AUR packages..."
yay -S --needed --noconfirm leftwm

# Configure VirtualBox settings
echo "Configuring VirtualBox settings..."
sudo systemctl enable vboxservice.service

# Add user to vboxsf group for shared folders
sudo usermod -a -G vboxsf $USER

# Create VirtualBox modules load configuration
echo 'vboxguest
vboxsf
vboxvideo' | sudo tee /etc/modules-load.d/virtualbox.conf

# Create config directories
echo "Creating configuration directories..."
mkdir -p ~/.config/leftwm/themes/basic
mkdir -p ~/.config/polybar
mkdir -p ~/.config/alacritty
mkdir -p ~/.config/picom
mkdir -p ~/.config/rofi
mkdir -p ~/Pictures/wallpapers

# Copy configuration files
echo "Copying configuration files..."
cp config/leftwm/config.ron ~/.config/leftwm/
cp config/leftwm/themes.ron ~/.config/leftwm/
cp config/leftwm/themes/basic/* ~/.config/leftwm/themes/basic/
cp config/polybar/config.ini ~/.config/polybar/
cp config/alacritty/alacritty.yml ~/.config/alacritty/
cp config/picom/picom.conf ~/.config/picom/
cp config/rofi/config.rasi ~/.config/rofi/

# Configure lightdm
echo "Configuring lightdm..."
sudo systemctl enable lightdm.service

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

# VirtualBox specific validations
echo "Performing VirtualBox compatibility checks..."

# Check if running in VirtualBox
if lspci | grep -i virtualbox > /dev/null; then
    echo "✓ VirtualBox detected"
else
    echo "⚠ Warning: VirtualBox not detected, some features may not work optimally"
fi

# Check video memory
echo "Please ensure VirtualBox VM has:"
echo "  - At least 128MB video memory"
echo "  - 3D acceleration enabled"
echo "  - Guest Additions installed"

echo "=== Setup Complete! ==="
echo "Please reboot and select 'LeftWM' from the login screen."
echo "LightDM has been enabled and configured."
echo "System configured for 1440p resolution (2560x1440)."
echo ""
echo "VirtualBox Setup Checklist:"
echo "1. VM Settings → Display → Video Memory: 128MB+"
echo "2. VM Settings → Display → Enable 3D Acceleration"
echo "3. View Menu → Auto-resize Guest Display"
echo "4. After reboot, press Host+F to enter fullscreen"
