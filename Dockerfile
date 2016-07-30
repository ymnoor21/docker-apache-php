FROM ubuntu:14.04.4
MAINTAINER Yamin Noor <ymnoor21@gmail.com>
ENV DEBIAN_FRONTEND=noninteractive

# Set timezone
RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/America/Los_Angeles /etc/localtime

# install necessary python softwares
RUN apt-get update
RUN apt-get dist-upgrade -y
RUN apt-get -y install python-software-properties
RUN apt-get -y install software-properties-common

# install apache2
RUN apt-get -y update && apt-get install -y apache2

# enable apache rewrite module
RUN a2enmod rewrite

# Config before adding php 5.6 / php 7.0 repo
RUN apt-get -y update \
    && apt-get install -y language-pack-en-base \
    && export LC_ALL=en_US.UTF-8 \
    && export LANG=en_US.UTF-8

# add php repo
RUN LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php

# install php5.6 and php7.0
RUN LC_ALL=en_US.UTF-8 \
    apt-get -y update \
 	&& apt-get install -y php5.6 php7.0 php5.6-mcrypt php5.6-mbstring php5.6-curl php5.6-cli php5.6-mysql php5.6-gd php5.6-intl php5.6-xsl php5.6-memcache php5.6-memcached php5.6-mongo php5.6-redis php5.6-imagick php5.6-apcu php5.6-json

# disable php7.0, enable php5.6 and restart apache
RUN a2dismod php7.0 \
	&& a2enmod php5.6 \
	&& service apache2 restart

RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php/5.6/apache2/php.ini
RUN sed -i "s/post_max_size = .*$/post_max_size = 50M/" /etc/php/5.6/apache2/php.ini
RUN sed -i "s/upload_max_filesize = .*$/upload_max_filesize = 50M/" /etc/php/5.6/apache2/php.ini

# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

# symlink php5.6 cli
RUN ln -sfn /usr/bin/php5.6 /etc/alternatives/php

# Expose apache.
EXPOSE 80

# Update the default apache site with the config we created.
ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf

# By default start up apache in the foreground, override with /bin/bash for interative.
CMD /usr/sbin/apache2ctl -D FOREGROUND
