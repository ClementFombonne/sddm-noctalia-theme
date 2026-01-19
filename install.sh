#!/bin/bash

# SDDM Noctalia Theme Installation Script
# This script installs the Noctalia SDDM theme to your system

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
THEME_NAME="sddm-noctalia-theme"
INSTALL_DIR="/usr/share/sddm/themes/${THEME_NAME}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_SUFFIX=".backup-$(date +%Y%m%d-%H%M%S)"

# Functions
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        print_error "This script must be run as root (use sudo)"
        exit 1
    fi
}

check_sddm() {
    if ! command -v sddm &> /dev/null; then
        print_error "SDDM is not installed on your system"
        print_info "Please install SDDM first using your package manager:"
        print_info "  - Arch/Manjaro: sudo pacman -S sddm"
        print_info "  - Ubuntu/Debian: sudo apt install sddm"
        print_info "  - Fedora: sudo dnf install sddm"
        print_info "  - openSUSE: sudo zypper install sddm"
        exit 1
    fi
    print_success "SDDM is installed"
}

check_qt6() {
    print_info "Checking for Qt6 support..."
    if command -v qmake6 &> /dev/null || command -v qmake &> /dev/null; then
        print_success "Qt6 appears to be available"
    else
        print_warning "Qt6 development tools not detected"
        print_warning "This theme requires SDDM compiled with Qt6 support"
        print_warning "Please ensure your SDDM installation supports Qt6"
    fi
}

backup_existing() {
    if [[ -d "$INSTALL_DIR" ]]; then
        print_warning "Existing installation found at $INSTALL_DIR"
        local backup_dir="${INSTALL_DIR}${BACKUP_SUFFIX}"
        print_info "Creating backup at $backup_dir"
        mv "$INSTALL_DIR" "$backup_dir"
        print_success "Backup created"
    fi
}

install_theme() {
    print_info "Installing theme to $INSTALL_DIR..."
    
    # Create parent directory if it doesn't exist
    mkdir -p "$(dirname "$INSTALL_DIR")"
    
    # Copy theme files
    cp -r "$SCRIPT_DIR" "$INSTALL_DIR"
    
    # Remove git files and installation scripts from the installation
    rm -rf "$INSTALL_DIR/.git" "$INSTALL_DIR/.gitignore"
    rm -f "$INSTALL_DIR/install.sh" "$INSTALL_DIR/uninstall.sh"
    
    # Set proper permissions
    chown -R root:root "$INSTALL_DIR"
    find "$INSTALL_DIR" -type d -exec chmod 755 {} \;
    find "$INSTALL_DIR" -type f -exec chmod 644 {} \;
    
    print_success "Theme installed successfully"
}

configure_sddm() {
    print_info "SDDM configuration:"
    print_info "To use this theme, edit your SDDM configuration file:"
    print_info ""
    print_info "  Option 1: Edit /etc/sddm.conf (if it exists)"
    print_info "  Option 2: Create /etc/sddm.conf.d/theme.conf"
    print_info ""
    print_info "Add or modify the following section:"
    echo -e "${YELLOW}"
    echo "  [Theme]"
    echo "  Current=${THEME_NAME}"
    echo -e "${NC}"
    print_info "Make sure to comment out any other 'Current' theme setting."
    print_info ""
    
    # Check if sddm.conf exists and offer to configure
    if [[ -f /etc/sddm.conf ]]; then
        read -p "Would you like to automatically update /etc/sddm.conf? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            # Backup sddm.conf
            cp /etc/sddm.conf /etc/sddm.conf.backup-$(date +%Y%m%d-%H%M%S)
            print_success "Created backup of /etc/sddm.conf"
            
            # Update or add Theme section
            if grep -q "^\[Theme\]" /etc/sddm.conf; then
                # Theme section exists, update Current value
                sed -i '/^\[Theme\]/,/^\[/ s/^Current=.*/Current='"${THEME_NAME}"'/' /etc/sddm.conf
                # If Current doesn't exist in Theme section, add it
                if ! grep -A5 "^\[Theme\]" /etc/sddm.conf | grep -q "^Current="; then
                    sed -i '/^\[Theme\]/a Current='"${THEME_NAME}" /etc/sddm.conf
                fi
            else
                # Theme section doesn't exist, add it
                echo "" >> /etc/sddm.conf
                echo "[Theme]" >> /etc/sddm.conf
                echo "Current=${THEME_NAME}" >> /etc/sddm.conf
            fi
            print_success "Updated /etc/sddm.conf"
        fi
    elif [[ -d /etc/sddm.conf.d ]]; then
        read -p "Would you like to create /etc/sddm.conf.d/theme.conf? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            cat > /etc/sddm.conf.d/theme.conf <<EOF
[Theme]
Current=${THEME_NAME}
EOF
            print_success "Created /etc/sddm.conf.d/theme.conf"
        fi
    else
        read -p "Would you like to create /etc/sddm.conf? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            cat > /etc/sddm.conf <<EOF
[Theme]
Current=${THEME_NAME}
EOF
            print_success "Created /etc/sddm.conf"
        fi
    fi
}

# Main installation process
main() {
    echo ""
    echo "======================================"
    echo "  Noctalia SDDM Theme Installation"
    echo "======================================"
    echo ""
    
    check_root
    check_sddm
    check_qt6
    backup_existing
    install_theme
    configure_sddm
    
    echo ""
    print_success "Installation complete!"
    echo ""
    print_info "Theme location: $INSTALL_DIR"
    print_info "Configuration file: $INSTALL_DIR/Commons/Settings.conf"
    echo ""
    print_info "You can now customize the theme by editing the configuration file."
    print_info "After configuring SDDM, restart the SDDM service:"
    print_info "  sudo systemctl restart sddm"
    echo ""
}

main "$@"
