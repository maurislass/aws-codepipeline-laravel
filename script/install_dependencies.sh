#!/bin/bash

# Exit on error
set -o errexit -o pipefail

echo "---------------------------------------> Update apt-get <---------------------------------------"
# Update apt-get
apt-get update -y
apt-get upgrade -y

echo "---------------------------------------> Install Git & Curl <---------------------------------------"
# Install packages
apt-get install -y curl
apt-get install -y git

echo "---------------------------------------> Remove current apache & php <---------------------------------------"
# Remove current apache & php
apt-get -y remove httpd* php*

echo "---------------------------------------> Install Apache <---------------------------------------"
# Install Apache 2.4
apt-get -y install apache2
echo "---------------------------------------> Install PHP 7.1 <---------------------------------------"
# Install PHP 7.1
apt -y install software-properties-common
add-apt-repository ppa:ondrej/php
apt-get update
apt -y install php7.4
#apt-get install -y php71 php71-cli php71-fpm php71-mysql php71-xml php71-curl php71-opcache php71-pdo php71-gd php71-pecl-apcu php71-mbstring php71-imap php71-pecl-redis php71-mcrypt php71-mysqlnd mod24_ssl
php -v
echo "---------------------------------------> Apache Settings <---------------------------------------"
# Allow URL rewrites
#PPPPP sed -i 's#AllowOverride None#AllowOverride All#' /etc/apache2/conf/httpd.conf

# Change apache document root
mkdir -p /var/www/html/public
#PPPPP    sed -i 's#DocumentRoot "/var/www/html"#DocumentRoot "/var/www/html/public"#' /etc/apache2/conf/httpd.conf

# Change apache directory index
#PPPPP  sed -e 's/DirectoryIndex.*/DirectoryIndex index.html index.php/' -i /etc/apache2/conf/httpd.conf


echo "---------------------------------------> Install Composer <---------------------------------------"
# Get Composer, and install to /usr/local/bin
if [ ! -f "/usr/local/bin/composer" ]; then
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php composer-setup.php --install-dir=/usr/bin --filename=composer
    php -r "unlink('composer-setup.php');"
else
    /usr/local/bin/composer self-update --stable --no-ansi --no-interaction
fi

echo "---------------------------------------> Enable Apache <---------------------------------------"
# Setup apache to start on boot
systemctl stop apache2
systemctl enable apache2


echo "---------------------------------------> Install Python <---------------------------------------"
apt-get install python3 -y


# Ensure aws-cli is installed and configured
if [ ! -f "/usr/bin/aws" ]; then
    echo "---------------------------------------> Instal AWS Cli <---------------------------------------"
    curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
    echo "---------------------------------------> Unzip AWS Cli <---------------------------------------"
    unzip awscli-bundle.zip -A
    echo "---------------------------------------> Install AWS Cli <---------------------------------------"
    ./awscli-bundle/install -b /usr/bin/aws
fi

# Ensure AWS Variables are available
if [[ -z "$AWS_ACCOUNT_ID" || -z "$AWS_DEFAULT_REGION " ]]; then
    echo "AWS Variables Not Set.  Either AWS_ACCOUNT_ID or AWS_DEFAULT_REGION"
fi
