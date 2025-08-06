{ config, pkgs, lib, ... }:

{
	imports = [ ./hardware-configuration.nix ];

	nix.gc.automatic = true;
	nix.gc.dates = "weekly";
	nix.settings.experimental-features = [ "nix-command" "flakes" ];

	system.stateVersion = "25.05";

	boot.loader.grub.enable = true;
	boot.loader.grub.device = "/dev/sda";

	networking.hostName = "nullmachine";
	networking.networkmanager.enable = true;

	virtualisation.vmware.guest.enable = true;

	time.timeZone = "America/Port_of_Spain";
	i18n.defaultLocale = "en_US.UTF-8";

	services.xserver.enable = true;
	services.xserver.displayManager.gdm.enable = true;
	services.xserver.desktopManager.gnome.enable = true;
	services.xserver.xkb = { layout = "us"; variant = ""; };
	systemd.services."getty@tty1".enable = false;
	systemd.services."autovt@tty1".enable = false;

	hardware.pulseaudio.enable = false;
	security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
	};

	nixpkgs.config.allowUnfree = true;

	environment.systemPackages = with pkgs; [
		# Core
		bat
		cmake
		curl
		fastfetch
		firefox
		gcc
		git
		kitty
		lsd
		openssl
		ripgrep
		starship
		tree
		unzip
		vivaldi
		wget
		wl-clipboard
		zellij
		zip
		zsh

		# Editor
		diff-so-fancy
		efm-langserver
		lua-language-server
		neovim
		stylua
		tree-sitter
		vim

		# Development
		deno
		nodejs_22
		php84Packages.composer
		(php84.withExtensions ({ enabled, all }:
			enabled ++ [
				all.ctype
				all.curl
				all.dom
				all.fileinfo
				all.filter
				all.gd
				all.imagick
				all.intl
				all.mbstring
				all.opcache
				all.openssl
				all.pdo
				all.pdo_mysql
				all.session
				all.sodium
				all.tokenizer
				all.xdebug
				all.zip
			]))
		(python312.withPackages (py: [
			py.pip
			py.wheel
			py.setuptools
			py.pynvim
		]))

		# UI
		bibata-cursors
		tela-icon-theme

		# GNOME Desktop
		gnome-tweaks
		gnomeExtensions.blur-my-shell
		gnomeExtensions.dash-to-dock
		gnomeExtensions.paperwm
		gnomeExtensions.tophat

		# Niri WM
		fuzzel
		mako
		niri
		waybar
	];

	fonts.packages = with pkgs; [
		nerd-fonts.jetbrains-mono
		inter
	];

	services.mysql = {
		enable = true;
		package = pkgs.mysql80;
		ensureUsers = [
			{
				name = "creativenull";
				ensurePermissions = {
					"*.*" = "ALL PRIVILEGES";
				};
			}
		];
	};

	users.users.creativenull = {
		isNormalUser = true;
		description = "CreativeNull";
		extraGroups = [ "networkmanager" "wheel" ];
		shell = pkgs.zsh;
	};

	programs.zsh.enable = true;
	programs.firefox.enable = true;
	programs.neovim.enable = true;
	programs.neovim.defaultEditor = true;
	programs.niri.enable = true;

	programs.dconf = {
		enable = true;
		profiles.user.databases = [{
			settings = {
				"org/gnome/desktop/interface" = {
					color-scheme = "prefer-dark";
					cursor-theme = "Bibata-Modern-Classic";
					icon-theme = "Tela-dark";
				};
				"org/gnome/desktop/peripherals/keyboard" = {
					delay = lib.gvariant.mkUint32 250;
					repeat-interval = lib.gvariant.mkUint32 15;
				};
				"org/gnome/desktop/input-sources" = {
					xkb-options = [ "caps:escape_shifted_capslock" ];
				};
				"org/gnome/desktop/background" = {
					show-desktop-icons = false;
				};
				"org/gnome/shell" = {
					favorite-apps = [ "kitty.desktop" "vivaldi-stable.desktop" ];
				};
			};
		}];
	};
}
