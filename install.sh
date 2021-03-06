#!/bin/bash

echo "###########################################################################################################################"
echo "############################### STEP ONE DEVELOPMENT WITH APACHE2 #########################################################"
echo "###########################################################################################################################"
sleep 3


echo "###########################################################################################################################"
echo "== Are you Root??? =="
sudo su
echo "###########################################################################################################################"
sleep 3


echo "###########################################################################################################################"
echo "== Update the Mashine !!!!! ==" 
sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get dist-upgrade -y && sudo apt-get autoremove -y 
echo "###########################################################################################################################"
sleep 3


echo "###########################################################################################################################"
echo "== Setting up repo and in a few seconds you have to hit ENTER ==" 
sudo apt-get install python-software-properties
sudo add-apt-repository ppa:ondrej/php
sudo apt-get update 
echo "###########################################################################################################################"
sleep 3


echo "###########################################################################################################################"
echo "== Install Dependency's !!! ==" 
sleep 5sudo 
sudo apt-get install -y apache2 mysql-server mysql-client libapache2-mod-php7.0 php7.0 php7.0-mcrypt php7.0-mbstring php7.0-gnupg php7.0-mysql php7.0-gmp php7.0-curl php7.0-bcmath php7.0-gd php7.0-fpm git curl git mcrypt curl unzip atool subversion 
echo "###########################################################################################################################"


echo "###########################################################################################################################"
echo "== Change Directory.. ==" 
cd /var/www/
# sudo git clone https://github.com/annularis/shop
sudo chown www-data:www-data -Rv shop
cd shop/install
echo "###########################################################################################################################"
sleep 3 


echo "###########################################################################################################################"
echo "== Enable a2enmod and restart apache / nginx..  =="
sudo a2enmod rewrite
sudo service apache2 restart
echo "###########################################################################################################################"
sleep 3


echo "###########################################################################################################################"
echo "== Install Bitcoin maybe you have to change version.. =="
cd /tmp
sudo wget https://bitcoin.org/bin/bitcoin-core-0.17.1/bitcoin-0.17.1-x86_64-linux-gnu.tar.gz
sudo aunpack bitcoin-0.17.1-x86_64-linux-gnu.tar.gz
cd bitcoin-0.17.1
sudo cp bin/* /usr/local/bin/
echo "###########################################################################################################################"
sleep 3


echo "###########################################################################################################################"
echo "== Start bitcoin... =="
sudo bitcoind -daemon -testnet -rpcport="7530" -rpcuser="bitcoinuser" -rpcpassword="bitcoinpass"
echo "###########################################################################################################################"
sleep 3


echo "###########################################################################################################################"
echo "##################### CHECK AFTER INSTALL #################################################################################"
echo "###########################################################################################################################"
echo "== Setup Apache2...  =="
echo "=== Check after install if settings are correct.. ==="
echo "# change AllowOverride All for /var/www "
echo "## sudo nano /etc/apache2/apache2.conf "
echo "# change DocumentRoot to /var/www/shop "
echo "## sudo nano /etc/apache2/sites-enabled/000-default.conf "
echo "###########################################################################################################################"
sleep 3



echo "###########################################################################################################################"
echo "Setting up 'AllowOverride All' for /var/www"
sudo sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride all/' /etc/apache2/apache2.conf
sudo service apache2 restart
echo "###########################################################################################################################"
sleep 2



echo "###########################################################################################################################"
echo "== Setting up Apache2 DocumentRoot.. =="
echo " check if still root.. "
sudo su
sudo grep -q "shop" /etc/apache2/sites-enabled/000-default.conf; then
sudo sed -i 's#/var/www/html#/var/www/shop#' /etc/apache2/sites-enabled/000-default.conf
echo "###########################################################################################################################"
sleep 2



echo "###########################################################################################################################"
echo "== Setup mysql database =="
# mysql database
sudo mysql
sudo mysql -e "CREATE DATABASE annularis;"
sudo mysql -e "CREATE USER annularis IDENTIFIED BY 'password';"
sudo mysql -e "GRANT ALL PRIVILEGES ON annularis.* TO annularis@localhost IDENTIFIED BY 'password';"
echo "###########################################################################################################################"
sleep 3


echo "###########################################################################################################################"
echo "##################### CHECK AFTER INSTALL #################################################################################"
echo "###########################################################################################################################"
echo "== Setup Database and Bitcoin.conf after Install this script..  =="
echo "# setup's for Annularis config's.. "
echo " sudo nano /var/www/shop/install/config/database.php  "
echo " sudo nano /var/www/shop/install/config/bitcoin.php  "
echo "Database Name = "annularis" "
echo "Database User = "annularis" "
echo "Database Host = "localhost" "

echo "Database Password = "password" "
echo "Bitcoinuser = "bitcoinuser" "
echo "Bitcoin Password = "bitcoinpass" "
echo "Bitcoin IP = "127.0.0.1" "
echo "###########################################################################################################################"
sleep 3


echo "###########################################################################################################################"
echo "##################### CHECK AFTER INSTALL #################################################################################"
echo "###########################################################################################################################"
echo " copy htaccess.sample to .htaccess setup show setup instruction's "
echo "# comment out 'RewriteBase /shop' "
echo " if you want to use Apache as hidden service server add onion url to .htaccess";
echo "## sudo nano .htaccess "

cd /var/www/shop
sudo cp htaccess.sample .htaccess
echo "###########################################################################################################################"
sleep 3


echo "###########################################################################################################################"
echo " Change Permissions of "config Files" "
sudo touch /var/www/shop/application/config/database.php && sudo chmod 777 /var/www/shop/application/config/database.php
sudo touch /var/www/shop/application/config/bitcoin.php && sudo chmod 777 /var/www/shop/application/config/bitcoin.php
sudo touch /var/www/shop/application/config/config.php && sudo chmod 777 /var/www/shop/application/config/config.php
echo "###########################################################################################################################"










echo "###########################################################################################################################"
echo "################################ STEP 2 NGINX HIDDEN_SERVICE ##############################################################"
echo "###########################################################################################################################"
echo " setting up nginx.. "
sudo service apache2 stop
sudo apt-get install nginx

echo " Prepare Annularis executor.. "
# prepare annularis executor user
sudo groupadd annularis
sudo useradd -g annularis annularis

echo "###########################################################################################################################"
echo "###########################################################################################################################"
echo " php7.0-fpm settings.. "
sudo cp /etc/php/7.0/fpm/pool.d/www.conf /etc/php/7.0/fpm/pool.d/annularis.conf
sudo nano /etc/php/7.0/fpm/pool.d/annularis.conf
echo " ## edit as following "
echo " # [annularis] "
echo " # user = annularis "
echo " # group = annularis "
echo " # listen = /var/run/php/php7.0-fpm-annularis.sock "
echo " # listen.owner = www-data "
echo " # listen.group = www-data "
echo " # php_admin_value[disable_functions] = exec,passthru,shell_exec,system "
echo " # php_admin_flag[allow_url_fopen] = off "

echo " set opache.ini "
sudo nano /etc/php/7.0/fpm/conf.d/10-opcache.ini
## edit as following
# opcache.enable=0

echo " Restart php7.0-fpm "
# restart php-fpm
sudo service php7.0-fpm restart

echo "###########################################################################################################################"
echo "###########################################################################################################################"
echo " Nginx setting's "
# nginx settting
cd /var/www/shop
sudo cp annularis-nginx.conf /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/annularis-nginx.conf /etc/nginx/sites-enabled/
service nginx restart
echo " scroll up and check every settings where you see '##' "

# Install repo's for ToR 
# deb http://deb.torproject.org/torproject.org xenial main
# deb-src http://deb.torproject.org/torproject.org xenial main
sudo nano /etc/apt/sources.list

# now add GpG Key's
gpg --keyserver keys.gnupg.net --recv A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89
gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | sudo apt-key add -

# update again
sudo apt-get update

# Install Tor with Keyring
sudo apt-get install tor deb.torproject.org-keyring

# save tor settings
sudo cp /etc/tor/torrc /etc/tor/OLD.torrc

# setup the tor config
sudo nano /etc/tor/torrc

# uncomment these two lines
HiddenServiceDir /var/lib/tor/hidden_service/
HiddenServicePort 80 127.0.0.1:80


# Restart Tor
sudo service tor restart

# showing hostname
sudo cat /var/lib/tor/hidden_service/hostname

# resstart nginx
sudo service nginx restart

# changing nginx root and servername
server {
	listen 127.0.0.1:80;
	root /var/www/shop/;
	index index.html;
	server_name testp7e2ctestppizgn.onion;
  
# restart
sudo service resart nginx && sudo service restart php7.0-fpm && sudo service restart tor














