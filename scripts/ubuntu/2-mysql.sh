echo '---'
echo 'Install mysql-server'
echo '---'
sudo apt-get install -y mysql-server

# Secure the MySQL installation (remove anonymous users, disallow remote root login, etc.)
mysql_secure_installation <<EOF

n # Change the password? No
n # Remove anonymous users? Yes
y # Disallow root login remotely? Yes
y # Remove test database and access to it? Yes
y # Reload privilege tables now? Yes
EOF

# Login to MySQL and create the user and grant privileges
sudo mysql <<EOF
CREATE USER 'creativenull'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON *.* TO 'creativenull'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF
