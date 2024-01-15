FROM ubuntu:20.04
ENV DEBIAN_FRONTEND noninteractive

LABEL AUTHOR="Ale Ulate <me@codingale.dev>"

# update and install packages
RUN apt-get -qq update \
        && apt-get -qq upgrade -y \
        && apt-get -qq install software-properties-common \
        && add-apt-repository ppa:ondrej/php \
        && apt-get -qq install -y apache2 php7.4 php7.4-mysql php7.4-sqlite php7.4-curl php7.4-intl php7.4-xdebug

# setting apache env vars
ENV APACHE_CONFDIR /etc/apache2
ENV APACHE_ENVVARS $APACHE_CONFDIR/envvars
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_PID_FILE $APACHE_RUN_DIR/apache2.pid
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_LOG_DIR /var/log/apache2
ENV LANG C
RUN mkdir -p $APACHE_RUN_DIR $APACHE_LOCK_DIR $APACHE_LOG_DIR

# redirect logs to stdout and stderr
RUN find "$APACHE_CONFDIR" -type f -exec sed -ri ' \
        s!^(\s*CustomLog)\s+\S+!\1 /proc/self/fd/1!g; \
        s!^(\s*ErrorLog)\s+\S+!\1 /proc/self/fd/2!g; \
        ' '{}' ';'

# adding assets
ADD assets/ /assets/

EXPOSE 80

ENTRYPOINT ["/assets/entrypoint.sh"]
