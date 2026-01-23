# Installation Guide for SDDM Noctalia Theme

This guide provides detailed installation instructions for the Noctalia SDDM theme on standard Linux distributions.

## Prerequisites

- **SDDM**: The Simple Desktop Display Manager must be installed
- **Qt6**: SDDM must be compiled with Qt6 support (most modern distributions)
- **Root access**: Installation requires sudo/root privileges

## Quick Install

```bash
git clone https://github.com/ClementFombonne/sddm-noctalia-theme.git
cd sddm-noctalia-theme
sudo ./install.sh
sudo systemctl restart sddm
```

## Detailed Installation Steps

### 1. Install SDDM (if not already installed)

**Arch Linux / Manjaro:**
```bash
sudo pacman -S sddm
sudo systemctl enable sddm
```

**Ubuntu / Debian:**
```bash
sudo apt install sddm
sudo systemctl enable sddm
```

**Fedora:**
```bash
sudo dnf install sddm
sudo systemctl enable sddm
```

**openSUSE:**
```bash
sudo zypper install sddm
sudo systemctl enable sddm
```

### 2. Clone and Install Theme

```bash
# Clone the repository
git clone https://github.com/ClementFombonne/sddm-noctalia-theme.git
cd sddm-noctalia-theme

# Run the installation script
sudo ./install.sh
```

The installation script will:
- Verify SDDM is installed
- Check for Qt6 support
- Backup any existing installation
- Copy theme files to `/usr/share/sddm/themes/sddm-noctalia-theme`
- Offer to configure SDDM automatically

### 3. Configure SDDM

If you didn't let the installation script configure SDDM automatically, do it manually:

**Option A: Edit /etc/sddm.conf**
```bash
sudo nano /etc/sddm.conf
```

Add or modify:
```ini
[Theme]
Current=sddm-noctalia-theme
```

**Option B: Create configuration file in /etc/sddm.conf.d/**
```bash
sudo mkdir -p /etc/sddm.conf.d
sudo nano /etc/sddm.conf.d/theme.conf
```

Add:
```ini
[Theme]
Current=sddm-noctalia-theme
```

### 4. Apply Changes

```bash
sudo systemctl restart sddm
```

**Warning:** This will log you out of your current session!

## Customization

After installation, customize the theme by editing:
```bash
sudo nano /usr/share/sddm/themes/sddm-noctalia-theme/Commons/Settings.conf
```

See the main [README.md](README.md) for configuration options.

## Uninstallation

To remove the theme:

```bash
cd sddm-noctalia-theme
sudo ./uninstall.sh
```

The uninstallation script will:
- Remove the theme files
- Offer to update SDDM configuration
- Optionally remove backup directories

## Manual Installation

If you prefer not to use the installation script:

```bash
# Copy theme to SDDM themes directory
sudo cp -r sddm-noctalia-theme /usr/share/sddm/themes/

# Set proper permissions
sudo chown -R root:root /usr/share/sddm/themes/sddm-noctalia-theme
sudo find /usr/share/sddm/themes/sddm-noctalia-theme -type d -exec chmod 755 {} \;
sudo find /usr/share/sddm/themes/sddm-noctalia-theme -type f -exec chmod 644 {} \;

# Configure SDDM (as described above)
# Then restart SDDM
sudo systemctl restart sddm
```

## Troubleshooting

### Theme not showing

1. Verify installation:
   ```bash
   ls -la /usr/share/sddm/themes/sddm-noctalia-theme
   ```

2. Check SDDM configuration:
   ```bash
   grep -r "Current" /etc/sddm.conf /etc/sddm.conf.d/ 2>/dev/null
   ```

3. Test SDDM:
   ```bash
   sudo sddm --test-mode --debug
   ```

### Qt6 issues

Verify your SDDM version supports Qt6:
```bash
sddm --version
ldd $(which sddm) | grep -i qt
```

If you see Qt5 instead of Qt6, you may need to update SDDM or install a Qt6-compiled version.

### Permission issues

Reset permissions:
```bash
sudo chown -R root:root /usr/share/sddm/themes/sddm-noctalia-theme
sudo find /usr/share/sddm/themes/sddm-noctalia-theme -type d -exec chmod 755 {} \;
sudo find /usr/share/sddm/themes/sddm-noctalia-theme -type f -exec chmod 644 {} \;
```

### Check logs

View SDDM logs:
```bash
journalctl -u sddm -b 0
# or
sudo cat /var/log/sddm.log
```

## NixOS Users

For NixOS, you can use the flake provided in the repository.

### 1. Add the flake to your inputs

In your `flake.nix` add:
```nix
{
  inputs = {
    # ... other inputs
    noctalia.url = "github:ClementFombonne/sddm-noctalia-theme";
  };

  outputs = { self, nixpkgs, noctalia, ... }: {
    nixosConfigurations.myHost = nixpkgs.lib.nixosSystem {
      modules = [
        ./configuration.nix
        noctalia.nixosModules.default
      ];
    };
  };
}
```

### 2. Enable the theme in your configuration

In your `configuration.nix` (or other configuration module) add:
```nix
{
  services.displayManager.sddm.noctalia = {
    enable = true;
  };
}
```
> No need to enable sddm manually, the module does it for you.

### 3. Configure SDDM and the theme

**SDDM**: The SDDM can still be configured using the standard nix way. However you should
not try to disable sddm or overwrite the theme option as it might break the flake.
```nix
{
  services.displayManager.sddm = { 
    enableHidpi = true;
    wayland.enable = false; # the X11 version of sddm often yields better result.
    noctalia = {
        enable = true;
        background = ../../assets/wallpaper.png; # relative to the configuration file location
        colorScheme = "Catppuccin";
    }
  }
}
```

**Theme**: The theme comes with some customization that can be enabled through nix.
To enable an option simply add:
```nix
{
  services.displayManager.sddm.noctalia = {
    enable = true;
    background = ../../assets/wallpaper.png; # relative to the configuration file location
    colorScheme = "Catppuccin";
  }
}
```

See the main [README.md](README.md) for more configuration options.

## Support

For issues, questions, or contributions, please visit the [GitHub repository](https://github.com/ClementFombonne/sddm-noctalia-theme).
