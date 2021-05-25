FROM centos:7

RUN mkdir /var/www /var/www/glpi

RUN mkdir /run/php-fpm

ENV VERSION 9.5.5

ENV GLPI_LANG es_MX

ENV MARIADB_HOST 192.168.1.215

ENV MARIADB_PORT 3306

ENV MARIADB_DATABASE empresa1

ENV MARIADB_USER empresa1

ENV MARIADB_PASSWORD itcom2020.,

ENV PLUGINS all

RUN yum -y install epel-release yum-utils

RUN yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm

RUN yum-config-manager --enable remi-php74

RUN yum -y install nginx

RUN yum -y install \
    php \
    php-fpm \
    php-common \
    php-mcrypt \
    php-cli \
    php-gd \
    php-mysqlnd \
    php-json \
    php-mbstring \
    php-mysqli \
    php-session \
    php-gd \
    php-curl \
    php-domxml \
    php-imap \
    php-ldap \
    php-openssl \
    php-opcache \
    php-apcu \
    php-xmlrpc \
    php-intl \
    php-zip \
    php-pear-CAS \
    php-ZendFramework-Cache-Backend-Apc \
    php-sodium \
    php-pecl-zip \
    && yum -y clean all

VOLUME [ "/var/www/glpi/files", "/var/www/glpi/plugins" ]

EXPOSE 80 443

COPY ./config/nginx-site.conf /etc/nginx/conf.d/default.conf

COPY ./scripts/entrypoint.sh /entrypoint.sh

#RUN echo "<?php phpinfo(); ?>" >> /var/www/glpi/index.php
ADD https://github.com/glpi-project/glpi/releases/download/9.5.5/glpi-9.5.5.tgz /tmp/

#
RUN tar -zxf /tmp/glpi-9.5.5.tgz -C /tmp/ \
	&& mv /tmp/glpi/* /var/www/glpi/ \
	&& chown -R root /var/www/glpi/ \
	&& rm -rf /tmp/glpi-9.5.5.tgz

RUN chmod +x /entrypoint.sh

CMD /entrypoint.sh