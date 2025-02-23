echo '---'
echo 'Install mysql-server'
echo '---'
MYSQL_PWD=password
echo "mysql-server mysql-server/root_password password $MYSQL_PWD" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password $MYSQL_PWD" | debconf-set-selections
echo "mysql-server mysql-server/start_on_boot boolean true" | debconf-set-selections
sudo apt-get install -y mysql-server
