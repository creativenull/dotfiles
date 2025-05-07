echo '---'
echo 'Installing asdf'
echo '---'

ASDF_VER="v0.16.7"
ASDF_URL="https://github.com/asdf-vm/asdf/releases/download/${ASDF_VER}/asdf-${ASDF_VER}-linux-amd64.tar.gz"
asdf_install() {
	wget "$ASDF_URL" -O ~/.local/bin/asdf.tar.gz
	tar -xzf ~/.local/bin/asdf.tar.gz -C ~/.local/bin
	rm ~/.local/bin/asdf.tar.gz
	export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
}

if command -v asdf &> /dev/null
then
	read -p "asdf: already installed. Reinstall? [y/N] " reinstall

	if [ "$reinstall" = "y" ]; then
		asdf_install
	else
		echo "Skipping: asdf already installed"
	fi
else
	asdf_install
fi
