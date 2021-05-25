#!/bin/bash

ConfigDataBase () {
      {
        echo "<?php"; \
        echo "class DB extends DBmysql {"; \
        echo "   public \$dbhost     = \"${MARIADB_HOST}\";"; \
        echo "   public \$dbport     = \"${MARIADB_PORT}\";"; \
        echo "   public \$dbuser     = \"${MARIADB_USER}\";"; \
        echo "   public \$dbpassword = \"${MARIADB_PASSWORD}\";"; \
        echo "   public \$dbdefault  = \"${MARIADB_DATABASE}\";"; \
        echo "}"; \
        echo ; 
      } > /var/www/glpi/config/config_db.php

}

# START FPM SERVICE
/usr/sbin/php-fpm -c /etc/php/fpm

# ADD FILE TO DATABASE
ConfigDataBase

# CONFIGURE DATABASE IN GLPI
/usr/bin/php /var/www/glpi/bin/console db:install \
  --reconfigure \
  --no-interaction \
  --db-host=${MARIADB_HOST} \
  --db-port=${MARIADB_PORT} \
  --db-name=${MARIADB_DATABASE} \
  --db-user=${MARIADB_USER} \
  --db-password=${MARIADB_PASSWORD} \

# REMOVE INSTALLATION FILE
rm /var/www/glpi/install/install.php  

# START NGINX SERVICE
nginx -g 'daemon off;'