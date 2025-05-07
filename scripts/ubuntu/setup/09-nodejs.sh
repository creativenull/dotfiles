echo '---'
echo 'Installing nodejs'
echo '---'

NODE_VER="22.15.0"
nodejs_install() {
	asdf plugin add nodejs
	asdf install nodejs $NODE_VER
	asdf set -u nodejs $NODE_VER
}

if command -v node &> /dev/null
then
	read -p "node: already installed. Reinstall? [y/N] " reinstall

	if [ "$reinstall" = "y" ]; then
		nodejs_install
	else
		echo "Skipping: node already installed"
	fi
else
	nodejs_install
fi
