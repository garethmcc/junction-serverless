#!/usr/bin/env bash
echo "***PROVISION START***"
echo "*** CREATING SWAP ***"
sudo dd if=/dev/zero of=/swapfile bs=1M count=1000
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
swapon --show

echo "* Setting mysql root password *";
debconf-set-selections <<< 'mysql-server mysql-server/root_password password abc123'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password abc123'
echo "* Running update check *"
apt-get update
apt-get upgrade
echo "* Installing MySQL *"
apt-get install -y mysql-server curl git

echo * Install NodeJS  *
apt-get install python-software-properties
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
apt-get update
apt-get install -y nodejs

echo "* Install npm modules *"
npm install serverless@1.20 sequelize-cli@3.0 mocha@4.0 typescript@2.6 -g
cd /vagrant && npm install

echo "*Setting Mysql up *"
sed -i '43s/.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
sed -i '39s/.*/#skip-external-locking/' /etc/mysql/mysql.conf.d/mysqld.cnf

service mysql restart

echo "* Creating database and building tables *"
mysql -uroot -pabc123 -e "CREATE USER 'expat_user'@'%' IDENTIFIED BY 'abc123'"
mysql -uroot -pabc123 -e "GRANT ALL PRIVILEGES ON * . * TO 'expat_user'@'%'"
mysql -uroot -pabc123 -e "CREATE DATABASE expat_explore_data_store"

echo "**SETUP ENV VARIABLES**"
echo "DB_LOCAL_DATABASE=expat_explore_data_store" >> /etc/environment
echo "DB_LOCAL_USERNAME=expat_user" >> /etc/environment
echo "DB_LOCAL_PASSWORD=abc123" >> /etc/environment
echo "DB_LOCAL_HOST=localhost" >> /etc/environment
echo "NODE_ENV=local" >> /etc/environment
echo "local_MEMCACHE=127.0.0.1" >> /etc/environment
echo "HTTP_TEST_URI=http://[vagrant IP Address]" >> /etc/environment

echo "* Running migrations *"
cd /vagrant && sequelize db:migrate

echo "Opening port 80 for testing"
apt-get -y install ufw
ufw allow 80/tcp

service mysql restart
echo "export PS1=\"serverless-framework:\\w:\\u# \"" >> /root/.bashrc
echo " *** To test http endpoints run 'sls offline start --host [vagrant IP Address] --port 80 --stage local' ***"
echo "*** PROVISION FINISHED ***"