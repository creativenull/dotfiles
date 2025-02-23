echo '---'
echo 'Installing jetbrains mono nerdfonts'
echo '---'
mkdir -p ~/.fonts
JETBRAINS_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/JetBrainsMono.zip"
wget "$JETBRAINS_URL" -O ~/.fonts/JetBrainsMono.zip
unzip ~/.fonts/JetBrainsMono.zip -d ~/.fonts
rm ~/.fonts/JetBrainsMono.zip
