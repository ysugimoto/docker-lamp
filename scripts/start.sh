#!bin/bash

# application environment variables
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=
MEMCACHE_URL=localhost

chmod -R 777 /var/www/kamimado-hair/storage

/usr/bin/mysql_install_db

service nginx start
service mysqld start
service sshd start
service php56-php-fpm start
service memcached start

vmstat 3
