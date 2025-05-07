#!/usr/bin/env bash

echo '---'
echo 'Installing MySQL server'
echo '---'

if command -v mysql &> /dev/null
then
	echo "Skipping: mysql already installed"
	exit 0
fi

sudo apt install mysql-server mysql-client -y
sudo mysql_secure_installation <<EOF

n # Change the password? No
n # Remove anonymous users? Yes
y # Disallow root login remotely? Yes
y # Remove test database and access to it? Yes
y # Reload privilege tables now? Yes
EOF

# Login to MySQL and create the user and grant privileges
sudo mysql <<EOF
CREATE USER 'creativenull'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON *.* TO 'creativenull'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF
