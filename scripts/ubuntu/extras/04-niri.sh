#!/usr/bin/env bash

# Check if an agrument uninstall is passed then run uninstall otherwise run install
if [ "$1" == "uninstall" ]; then
    echo '=> Uninstalling niri'

	sudo rm -fv /usr/local/bin/niri
	sudo rm -fv /usr/local/bin/niri-session
	sudo rm -fv /usr/share/wayland-sessions/niri.desktop
	sudo rm -fv /usr/share/xdg-desktop-portal/niri-portals.conf
	sudo rm -fv /etc/systemd/user/niri.service
	sudo rm -fv /etc/systemd/user/niri-shutdown.target
	sudo rm -fv /etc/dinit.d/user/niri
	sudo rm -fv /etc/dinit.d/user/niri-shutdown

	# Remove deps
	sudo nala remove -y mako-notifier fuzzel swaylock

	exit 0
fi

echo '=> Installing niri'

sudo nala install -y gcc clang libudev-dev libgbm-dev libxkbcommon-dev libegl1-mesa-dev libwayland-dev libinput-dev \
	libdbus-1-dev libsystemd-dev libseat-dev libpipewire-0.3-dev libpango1.0-dev libdisplay-info-dev

NIRI_VER="v25.05.1"
git clone --depth 1 --branch $NIRI_VER https://github.com/YaLTeR/niri.git ~/.builds/niri
cd ~/.builds/niri
cargo build --release

if [ -f ~/.builds/niri/target/release/niri ]; then
	sudo cp -v ~/.builds/niri/target/release/niri /usr/local/bin/
	sudo cp -v ~/.builds/niri/resources/niri-session /usr/local/bin
	sudo cp -v ~/.builds/niri/resources/niri.desktop /usr/share/wayland-sessions
	sudo cp -v ~/.builds/niri/resources/niri-portals.conf /usr/share/xdg-desktop-portal

    sudo mkdir -p /etc/systemd/user
	sudo cp -v ~/.builds/niri/resources/niri.service /etc/systemd/user
	sudo cp -v ~/.builds/niri/resources/niri-shutdown.target /etc/systemd/user

	sudo mkdir -p /etc/dinit.d/user
	sudo cp -v ~/.builds/niri/resources/dinit/niri /etc/dinit.d/user
	sudo cp -v ~/.builds/niri/resources/dinit/niri-shutdown /etc/dinit.d/user

	# Install deps
	sudo nala install -y mako-notifier fuzzel swaylock
fi
