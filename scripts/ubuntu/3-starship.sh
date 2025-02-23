echo '---'
echo 'Installing starship'
echo '---'
STARSHIP_VER="v1.22.1"
STARSHIP_URL="https://github.com/starship/starship/releases/download/${STARSHIP_VER}/starship-x86_64-unknown-linux-gnu.tar.gz"
wget "$STARSHIP_URL" -O ~/.local/bin/starship.tar.gz
tar -xzf ~/.local/bin/starship.tar.gz -C ~/.local/bin
rm ~/.local/bin/starship.tar.gz
