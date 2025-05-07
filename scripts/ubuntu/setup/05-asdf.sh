echo '---'
echo 'Installing asdf'
echo '---'

if command -v asdf &> /dev/null
then
	echo "Skipping: asdf already installed"
	exit 0
fi

ASDF_VER="v0.16.7"
ASDF_URL="https://github.com/asdf-vm/asdf/releases/download/${ASDF_VER}/asdf-${ASDF_VER}-linux-amd64.tar.gz"
wget "$ASDF_URL" -O ~/.local/bin/asdf.tar.gz
tar -xzf ~/.local/bin/asdf.tar.gz -C ~/.local/bin
rm ~/.local/bin/asdf.tar.gz
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
