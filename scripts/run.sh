#!/bin/bash

# application environment variables
DB_HOST=$DB_HOST
DB_USER=$DB_USER
DB_PASSWORD=$DB_PASSWORD
MEMCACHE_URL=$MEMCACHE_URL
ENV_NAME=${ENV_NAME:=staging}

# PATH
PROJECT_DIR='/data/www/app.hair.cm'
APP_INI_1='/data/www/app.hair.cm/data/1/application/configs/application.ini'
APP_INI_INTERNAL='/data/www/app.hair.cm/data/internal/application/configs/application.ini'
HTACCESS_1='/data/www/app.hair.cm/htdocs/1/.htaccess'
HTACCESS_INTERNAL='/data/www/app.hair.cm/htdocs/internal/.htaccess'
APPLICATION_ENV_CLI_1='/data/www/app.hair.cm/data/1/bin/application_env.php'
APPLICATION_ENV_CLI_INTERNAL='/data/www/app.hair.cm/data/internal/bin/application_env.php'

# create directory & change permission
mkdir -p /data/www/app.hair.cm/data/1/data/cache
mkdir -p /data/www/app.hair.cm/data/internal/data/cache
mkdir -p /data/www/app.hair.cm/data/1/data/uploading
mkdir -p /data/www/app.hair.cm/data/1/data/failed/photographs
chmod -R 777 /data/www/app.hair.cm/data/1/logs > /dev/null 2>&1
chmod -R 777 /data/www/app.hair.cm/data/1/data > /dev/null 2>&1
chmod -R 777 /data/www/app.hair.cm/data/internal/logs > /dev/null 2>&1
chmod -R 777 /data/www/app.hair.cm/data/internal/data > /dev/null 2>&1
chmod -R 777 /data/www/app.hair.cm/data/1/data/uploading > /dev/null 2>&1
chmod -R 777 /data/www/app.hair.cm/data/1/data/failed/photographs > /dev/null 2>&1

# replace settings
sed -i "s/ENV_NAME/$ENV_NAME/" $HTACCESS_1 $HTACCESS_INTERNAL
sed -i "s/ENV_NAME/$ENV_NAME/" $APPLICATION_ENV_CLI_1 $APPLICATION_ENV_CLI_INTERNAL

# Execute supervisord
mkdir -p /var/log/supervisor && chmod -R 777 /var/log/supervisor
supervisord -n
