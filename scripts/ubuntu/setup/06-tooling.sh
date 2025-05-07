echo '---'
echo 'Installing stylua'
echo '---'

if command -v stylua &> /dev/null
then
	echo "Skipping: stylua already installed"
	exit 0
fi

STYLUA_VER="v2.0.2"
STYLUA_URL="https://github.com/JohnnyMorganz/StyLua/releases/download/${STYLUA_VER}/stylua-linux-x86_64.zip"
wget "$STYLUA_URL" -O ~/.local/bin/stylua.zip
unzip ~/.local/bin/stylua.zip -d ~/.local/bin
rm ~/.local/bin/stylua.zip

echo '---'
echo 'Installing efm-langserver'
echo '---'

if command -v efm-langserver &> /dev/null
then
	echo "Skipping: efm-langserver already installed"
	exit 0
fi

EFM_VER="v0.0.54"
EFM_URL="https://github.com/mattn/efm-langserver/releases/download/$EFM_VER/efm-langserver_${EFM_VER}_linux_amd64.tar.gz"
wget "$EFM_URL" -O ~/.local/bin/efm-langserver.tar.gz
tar -xzf ~/.local/bin/efm-langserver.tar.gz -C ~/.local/bin
rm ~/.local/bin/efm-langserver.tar.gz
mv ~/.local/bin/efm-langserver_${EFM_VER}_linux_amd64/efm-langserver ~/.local/bin
rm -rf ~/.local/bin/efm-langserver_${EFM_VER}_linux_amd64

echo '---'
echo 'Installing deno'
echo '---'

if command -v deno &> /dev/null
then
	echo "Skipping: deno already installed"
	exit 0
fi

curl -fsSL https://deno.land/install.sh | sh -s -- --yes --no-modify-path

echo '---'
echo 'Install lua-language-server'
echo '---'

if command -v lua-language-server &> /dev/null
then
	echo "Skipping: lua-language-server already installed"
	exit 0
fi

LUA_LANGUAGE_SERVER_VER="3.13.6"
asdf plugin add lua-language-server
asdf install lua-language-server $LUA_LANGUAGE_SERVER_VER
asdf set -u lua-language-server $LUA_LANGUAGE_SERVER_VER
