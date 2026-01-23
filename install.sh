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
    # Check for Qt6 libraries (more reliable than checking development tools).
    # Note: `ldconfig -p` may not be available or may require special permissions on some systems.
    # In that case, this check will effectively be skipped and the directory checks below act as a fallback.
    if ldconfig -p 2>/dev/null | grep -q "libQt6Core" || \
       [[ -d /usr/lib/qt6 ]] || [[ -d /usr/lib64/qt6 ]] || \
       [[ -d /usr/lib/x86_64-linux-gnu/qt6 ]]; then
        print_success "Qt6 libraries detected"
    else
        print_warning "Qt6 libraries not detected in common locations"
        print_warning "This theme requires SDDM compiled with Qt6 support"
        print_warning "Please ensure your SDDM installation supports Qt6"
    fi
}

backup_existing() {
    if [[ -d "$INSTALL_DIR" ]]; then
        print_warning "Existing installation found at $INSTALL_DIR"
        local backup_dir="${INSTALL_DIR}${BACKUP_SUFFIX}"
        print_info "Creating backup at $backup_dir"
        cp -r "$INSTALL_DIR" "$backup_dir"
        rm -rf "$INSTALL_DIR"
        print_success "Backup created"
    fi
}

install_theme() {
    print_info "Installing theme to $INSTALL_DIR..."
    
    # Create parent directory if it doesn't exist
    mkdir -p "$(dirname "$INSTALL_DIR")"
    
    # Create theme directory
    mkdir -p "$INSTALL_DIR"
    
    # Copy theme files selectively
    # Note: This list should be updated if new essential files/directories are added to the theme
    for item in Assets Commons Helpers Widgets Main.qml metadata.desktop qmldir LICENSE; do
        if [[ -e "$SCRIPT_DIR/$item" ]]; then
            cp -r "$SCRIPT_DIR/$item" "$INSTALL_DIR/"
        fi
    done
    
    # Verify essential files were copied
    if [[ ! -f "$INSTALL_DIR/Main.qml" ]] || [[ ! -d "$INSTALL_DIR/Commons" ]] || [[ ! -f "$INSTALL_DIR/metadata.desktop" ]]; then
        print_error "Failed to copy essential theme files"
        rm -rf "$INSTALL_DIR"
        exit 1
    fi
    
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
            # Note: THEME_NAME is a constant without special regex characters, so no escaping needed
            if grep -q "^\[Theme\]" /etc/sddm.conf; then
                # Check if Current exists in Theme section
                if sed -n '/^\[Theme\]/,/^\[/p' /etc/sddm.conf | grep -q "^Current="; then
                    # Update existing Current line using double quotes for variable expansion
                    sed -i "/^\[Theme\]/,/^\[/ { /^Current=/ s|^Current=.*|Current=${THEME_NAME}|; }" /etc/sddm.conf
                else
                    # Add Current line after [Theme] line
                    sed -i "/^\[Theme\]/a Current=${THEME_NAME}" /etc/sddm.conf
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
