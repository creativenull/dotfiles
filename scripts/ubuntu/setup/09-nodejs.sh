echo '---'
echo 'Installing nodejs'
echo '---'

if command -v node &> /dev/null
then
	echo "Skipping: node already installed"
	exit 0
fi

NODE_VER="22.15.0"
asdf plugin add nodejs
asdf install nodejs $NODE_VER
asdf set -u nodejs $NODE_VER
