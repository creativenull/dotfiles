echo '---'
echo 'Installing starship'
echo '---'

if command -v starship &> /dev/null
then
	echo "Skipping: starship already installed"
	exit 0
fi

STARSHIP_VER="v1.22.1"
STARSHIP_URL="https://github.com/starship/starship/releases/download/${STARSHIP_VER}/starship-x86_64-unknown-linux-gnu.tar.gz"
wget "$STARSHIP_URL" -O ~/.local/bin/starship.tar.gz
tar -xzf ~/.local/bin/starship.tar.gz -C ~/.local/bin
rm ~/.local/bin/starship.tar.gz

echo '---'
echo 'Installing kitty'
echo '---'

curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
mkdir -p ~/.local/share/applications
cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
echo 'kitty.desktop' > ~/.config/xdg-terminals.list
