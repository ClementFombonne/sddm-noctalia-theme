#!/bin/bash

# SDDM Noctalia Theme Uninstallation Script
# This script removes the Noctalia SDDM theme from your system

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

check_installation() {
    if [[ ! -d "$INSTALL_DIR" ]]; then
        print_error "Theme is not installed at $INSTALL_DIR"
        exit 1
    fi
    print_success "Found theme installation at $INSTALL_DIR"
}

remove_theme() {
    print_info "Removing theme from $INSTALL_DIR..."
    rm -rf "$INSTALL_DIR"
    print_success "Theme removed successfully"
}

update_sddm_config() {
    print_info "SDDM configuration:"
    print_warning "If you set this theme in your SDDM configuration, you should update it."
    print_info "Check the following files:"
    print_info "  - /etc/sddm.conf"
    print_info "  - /etc/sddm.conf.d/*.conf"
    print_info ""
    print_info "Update or comment out the line: Current=${THEME_NAME}"
    echo ""
    
    # Offer to automatically update configuration files
    local config_files=()
    
    if [[ -f /etc/sddm.conf ]] && grep -q "Current=${THEME_NAME}" /etc/sddm.conf; then
        config_files+=("/etc/sddm.conf")
    fi
    
    if [[ -d /etc/sddm.conf.d ]]; then
        while IFS= read -r -d '' file; do
            if grep -q "Current=${THEME_NAME}" "$file"; then
                config_files+=("$file")
            fi
        done < <(find /etc/sddm.conf.d -name "*.conf" -type f -print0)
    fi
    
    if [[ ${#config_files[@]} -gt 0 ]]; then
        print_warning "Found references to this theme in:"
        for file in "${config_files[@]}"; do
            print_info "  - $file"
        done
        echo ""
        read -p "Would you like to comment out these references? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            for file in "${config_files[@]}"; do
                # Backup the file
                cp "$file" "${file}.backup-$(date +%Y%m%d-%H%M%S)"
                print_success "Created backup of $file"
                
                # Comment out the Current line with this theme
                # Note: THEME_NAME is a constant without special regex characters, so no escaping needed
                sed -i "s/^Current=${THEME_NAME}/#Current=${THEME_NAME}/" "$file"
                print_success "Commented out theme reference in $file"
            done
        fi
    fi
}

list_backups() {
    print_info "Checking for backups..."
    local backup_pattern="/usr/share/sddm/themes/${THEME_NAME}.backup-*"
    local found_backups=()
    
    # Safely collect existing backup directories
    shopt -s nullglob
    for dir in $backup_pattern; do
        if [[ -d "$dir" ]]; then
            found_backups+=("$dir")
        fi
    done
    shopt -u nullglob
    
    if [[ ${#found_backups[@]} -gt 0 ]]; then
        print_info "Found backup directories:"
        for dir in "${found_backups[@]}"; do
            print_info "  - $dir"
        done
        echo ""
        read -p "Would you like to remove all backup directories? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            for dir in "${found_backups[@]}"; do
                rm -rf "$dir"
                print_success "Removed $dir"
            done
        fi
    fi
}

# Main uninstallation process
main() {
    echo ""
    echo "========================================"
    echo "  Noctalia SDDM Theme Uninstallation"
    echo "========================================"
    echo ""
    
    check_root
    check_installation
    
    echo ""
    read -p "Are you sure you want to uninstall the Noctalia SDDM theme? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Uninstallation cancelled"
        exit 0
    fi
    
    remove_theme
    update_sddm_config
    list_backups
    
    echo ""
    print_success "Uninstallation complete!"
    echo ""
    print_info "Don't forget to restart the SDDM service:"
    print_info "  sudo systemctl restart sddm"
    echo ""
}

main "$@"
