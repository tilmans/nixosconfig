# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./wlan.nix
    ];

  # Use the gummiboot efi boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixAir"; # Define your hostname.
  networking.firewall.enable = true;
  # networking.networkmanager.enable = true;

  # Select internationalisation properties.
  #i18n = {
  #  consoleFont = "Lat2-Terminus16";
  #  consoleKeyMap = "de";
  #  defaultLocale = "de_DE.UTF-8";
  #};

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
   wget dmenu i3status i3 i3lock thunderbird firefox atom
   synergy skype slack vim exfat rxvt 
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # services.quassel.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    # layout = "de";
    xkbOptions = "eurosign:e";
    #windowManager.i3.enable = true;    

    synaptics = {
      enable = true;
      twoFingerScroll = true;
      tapButtons = true;
      additionalOptions = ''
        Option "RBCornerButton" "3"
        Option "TapButton2" "3"
      '';
      accelFactor = "0.001";
      buttonsMap = [ 1 3 2 ];
    };

    displayManager.auto.enable = true;
    displayManager.auto.user = "tilman";
    displayManager.sessionCommands = with pkgs; ''
    #  #xrdb -merge /etc/X11/Xresources
    #  #xrdb -merge /home/tschlenk/.Xresources
      xsetroot -solid "#333333"
      synclient TapButton2=3
      synclient AccelFactor=0.01
      i3
    '';
  };

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.kdm.enable = true;
  # services.xserver.desktopManager.kde4.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.tschlenk = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    uid = 1000;
  };

  users.extraUsers.tilman = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    uid = 1001;
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.03";

  nixpkgs.config = {
    allowUnfree = true;
  };

#  services.redshift.enable = true;  
}
