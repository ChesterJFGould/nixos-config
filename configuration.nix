# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
# TODO:
#   pywal xresources template

{ config, lib, pkgs, ... }:

let
  localPkgs = {
    hello-world = (import ./hello-world/hello-world.nix { pkgs = pkgs; });
    dwm = (import ./dwm/dwm.nix { pkgs = pkgs; });
    st = (import ./st/st.nix { pkgs = pkgs; });
    dmenu = (import ./dmenu/dmenu.nix { pkgs = pkgs; });
    dwmblocks = (import ./dwmblocks/dwmblocks.nix { pkgs = pkgs; });
    pywal = import ./pywal/pywal.nix {
      lib = lib;
      buildPythonPackage = pkgs.python3Packages.buildPythonPackage;
      fetchPypi = pkgs.python3Packages.fetchPypi;
      imagemagick = pkgs.imagemagick;
      feh = pkgs.feh;
      isPy3k = true;
    };
  };
in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "chesters-laptop"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Vancouver";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.displayManager.startx.enable = true;
  services.xserver.displayManager.startx.generateScript = true;
  services.xserver.displayManager.startx.extraCommands =
    ''
    ${pkgs.sxhkd}/bin/sxhkd -c ${./sxhkd/sxhkdrc}&
    ${localPkgs.dwmblocks}/bin/dwmblocks &
    ${localPkgs.pywal}/bin/wal -i ${./wallpapers}
    exec ${localPkgs.dwm}/bin/dwm
    '';

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.options = "terminate:ctrl_alt_bksp";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = false;
    # pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.chester = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
    hashedPassword = "$y$j9T$SjI9be12pEd883KNnzLir1$hlwl1etaE.KMJnGMCfSZ5A9NYxgjoWf5wfRzHX2BOS5";
  };

  programs.firefox.enable = true;
  
  programs.bash.promptInit =
    ''
    PS1='\[\033[1;32m\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\$\[\033[0m\] '
    '';
  programs.bash.interactiveShellInit =
    ''
    set -o vi
    (cat ~/.cache/wal/sequences &)
    '';
  programs.bash.shellAliases = {
    v = "vis";
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    vis
    firefox
    usbutils
    pciutils
    localPkgs.hello-world
    localPkgs.st
    localPkgs.dmenu
    racket
    xdo
    xdotool
    bsdgames
    networkmanager_dmenu
    networkmanagerapplet
    cacert
    vscodium
    jre21_minimal
    z3
    boogie
    xclip
    localPkgs.pywal
    python314
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # Cannot use this since using flakes to configure system
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}

