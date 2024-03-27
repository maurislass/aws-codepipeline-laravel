#!/bin/bash

echo "---------------------------------------> Clone Github repository <---------------------------------------"
# Clonning repository
echo "---------------------------------------> Clone Github repository - Validating if /www/html exists <---------------------------------------"
if [ ! -f "/var/www/html" ]; then
  echo "---------------------------------------> Clone Github repository - Cleaning /var/www folder <---------------------------------------"
  rm -rf /var/www/html/*
fi

echo "---------------------------------------> Clone Github repository - Cloning repository <---------------------------------------"
cd "/var/www/html"
git init
git config --global init.defaultBranch master
GIT_TOKEN="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"
git remote set-url origin "https://github.com/maurislass/Aqui-Ahora-V2.git"

echo " GIT_TOKEN ---> $GIT_TOKEN}"
CI_REPOSITORY_URL="https://titosobabas:$GIT_TOKEN@github.com/maurislass/Aqui-Ahora-V2.git"
echo " CI_REPOSITORY_URL ---> $CI_REPOSITORY_URL"
git pull $CI_REPOSITORY_URL

#https://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@github.com/maurislass/Aqui-Ahora-V2.git


# Enter html directory
echo "---------------------------------------> Getting to html folder <---------------------------------------"
cd /var/www/html/

echo "---------------------------------------> Creating laravel folders <---------------------------------------"
# Create cache and chmod folders
mkdir -p /var/www/html/bootstrap/cache
mkdir -p /var/www/html/storage/framework/sessions
mkdir -p /var/www/html/storage/framework/views
mkdir -p /var/www/html/storage/framework/cache
mkdir -p /var/www/html/public/files/

echo "---------------------------------------> Installing composer <---------------------------------------"
# Install dependencies
export COMPOSER_ALLOW_SUPERUSER=1
composer install -d /var/www/html/

echo "---------------------------------------> Creating .env <---------------------------------------"
# Copy configuration from /var/www/.env, see README.MD for more information
#cp /var/www/.env /var/www/html/.env

echo "---------------------------------------> Migrate tables <---------------------------------------"
# Migrate all tables
php /var/www/html/artisan migrate

echo "---------------------------------------> Cleaning Laravel project <---------------------------------------"
# Clear any previous cached views
php /var/www/html/artisan config:clear
php /var/www/html/artisan cache:clear
php /var/www/html/artisan view:clear

# Optimize the application
php /var/www/html/artisan config:cache
php /var/www/html/artisan optimize
#php /var/www/html/artisan route:cache

echo "---------------------------------------> Changing laravel permissions folders <---------------------------------------"
# Change rights
chmod 777 -R /var/www/html/bootstrap/cache
chmod 777 -R /var/www/html/storage
chmod 777 -R /var/www/html/public/files/

echo "---------------------------------------> Up and running Laravel project <---------------------------------------"
# Bring up application
php /var/www/html/artisan up
