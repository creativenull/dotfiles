echo '---'
echo 'Installing starship'
echo '---'

STARSHIP_VER="v1.22.1"
STARSHIP_URL="https://github.com/starship/starship/releases/download/${STARSHIP_VER}/starship-x86_64-unknown-linux-gnu.tar.gz"
starship_install() {
	wget "$STARSHIP_URL" -O ~/.local/bin/starship.tar.gz
	tar -xzf ~/.local/bin/starship.tar.gz -C ~/.local/bin
	rm ~/.local/bin/starship.tar.gz
}

if command -v starship &> /dev/null
then
	read -p "starship: already installed. Reinstall? [y/N] " reinstall

	if [ "$reinstall" = "y" ]; then
		starship_install
	else
		echo "Skipping"
	fi
else
	starship_install
fi

echo '---'
echo 'Installing kitty'
echo '---'

kitty_install() {
	curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
	ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
	mkdir -p ~/.local/share/applications
	cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
	cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
	sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
	sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
	echo 'kitty.desktop' > ~/.config/xdg-terminals.list
}

if command -v kitty &> /dev/null
then
	read -p "kitty: already installed. Reinstall? [y/N] " reinstall

	if [ "$reinstall" = "y" ]; then
		kitty_install
	else
		echo "Skipping"
	fi
else
	kitty_install
fi

echo '---'
echo 'Installing diff-so-fancy'
echo '---'

if command -v diff-so-fancy &> /dev/null
then
	echo "Skipping: diff-so-fancy already installed"
else
	sudo add-apt-repository ppa:aos1/diff-so-fancy
	sudo apt update
	sudo apt install diff-so-fancy
fi
