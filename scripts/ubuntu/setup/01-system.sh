echo '---'
echo 'Installing core packages'
echo '---'

pkgs=(
	autoconf
	bat
	build-essential
	cmake
	curl
	gnome-shell-extension-manager
	gnome-tweaks
	ripgrep
	software-properties-common
	unzip
	vim
	wget
	zip
	zsh
)

for pkg in "${pkgs[@]}"; do
	sudo apt install -y "$pkg"
done

snaps=(
	vivaldi
)

for snap in "${snaps[@]}"; do
	sudo snap install --stable "$snap"
done

echo '---'
echo 'Installing lsd'
echo '---'

if command -v lsd &> /dev/null
then
	echo "Skipping: lsd already installed"
	exit 0
fi

LSD_VER="v1.1.5"
LSD_URL="https://github.com/lsd-rs/lsd/releases/download/${LSD_VER}/lsd-${LSD_VER}-x86_64-unknown-linux-gnu.tar.gz"
wget "$LSD_URL" -O ~/.local/bin/lsd.tar.gz
tar -xzf ~/.local/bin/lsd.tar.gz -C ~/.local/bin
rm ~/.local/bin/lsd.tar.gz
mv -v ~/.local/bin/lsd-${LSD_VER}-x86_64-unknown-linux-gnu/lsd ~/.local/bin
rm -rf ~/.local/bin/lsd-${LSD_VER}-x86_64-unknown-linux-gnu
