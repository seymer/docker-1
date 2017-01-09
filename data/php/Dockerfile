#
# Reference https://www.howtoforge.com/tutorial/how-to-install-php-7-on-debian/
# Author: Maycon Brito
#
FROM debian:latest

RUN apt-get update \
	&& apt-get install build-essential \
		wget \
		aptitude \
		nano \
		autoconf \
		unzip \
		pkg-config -y

RUN mkdir ~/src \
	&& cd ~/src \
	&& wget -O php.tar.gz http://br1.php.net/get/php-7.1.0.tar.gz/from/this/mirror \
	&& tar zxvf php.tar.gz \
	&& cd php-7.1.0/ \
	&& apt-get install libfcgi-dev libfcgi0ldbl libjpeg62-turbo-dbg libmcrypt-dev \
		 libssl-dev libc-client2007e libc-client2007e-dev libxml2-dev libbz2-dev \
		 libcurl4-openssl-dev libjpeg-dev libpng12-dev libfreetype6-dev \
		 libkrb5-dev libpq-dev libxml2-dev libxslt1-dev -y \
	&& ln -s /usr/lib/libc-client.a /usr/lib/x86_64-linux-gnu/libc-client.a \
	&& ./configure --prefix=/opt/php-7.1 --with-pdo-pgsql --with-zlib-dir \
		--with-freetype-dir --enable-mbstring --with-libxml-dir=/usr --enable-soap \
		--enable-calendar --with-curl --with-mcrypt --with-zlib --with-gd --with-pgsql \
		--disable-rpath --enable-inline-optimization --with-bz2 --with-zlib --enable-sockets \
		--enable-sysvsem --enable-sysvshm --enable-pcntl --enable-mbregex --enable-exif \
		--enable-bcmath --with-mhash --enable-zip --with-pcre-regex --with-pdo-mysql \
		--with-mysqli --with-mysql-sock=/var/run/mysqld/mysqld.sock --with-jpeg-dir=/usr \
		--with-png-dir=/usr --enable-gd-native-ttf --with-openssl --with-fpm-user=www-data \
		--with-fpm-group=www-data --with-libdir=/lib/x86_64-linux-gnu --enable-ftp --with-imap \
		--with-imap-ssl --with-kerberos --with-gettext --with-xmlrpc --with-xsl --enable-opcache\
		--enable-fpm \
	&& make \
	&& make install \
	&& cp /usr/local/src/php7-build/php-7.1.0/php.ini-production /opt/php-7.1/lib/php.ini \
	&& cp /opt/php-7.1/etc/php-fpm.conf.default /opt/php-7.1/etc/php-fpm.conf \
		cp /opt/php-7.1/etc/php-fpm.d/www.conf.default /opt/php-7.1/etc/php-fpm.d/www.conf \
	&& sed -i '17s/;*//' /opt/php-7.1/etc/php-fpm.conf \
	&& sed -i '24s/;*//' /opt/php-7.1/etc/php-fpm.conf \
	&& sed -i '36s/9000*/8999/' /opt/php-7.1/etc/php-fpm.d/www.conf \

RUN tee /etc/init.d/php-7.1-fpm <<- EOF
#! /bin/sh
### BEGIN INIT INFO
# Provides:          php-7.1-fpm
# Required-Start:    $all
# Required-Stop:     $all
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts php-7.1-fpm
# Description:       starts the PHP FastCGI Process Manager daemon
### END INIT INFO
php_fpm_BIN=/opt/php-7.1/sbin/php-fpm
php_fpm_CONF=/opt/php-7.1/etc/php-fpm.conf
php_fpm_PID=/opt/php-7.1/var/run/php-fpm.pid
php_opts="--fpm-config $php_fpm_CONF"
wait_for_pid () {
        try=0
        while test $try -lt 35 ; do
                case "$1" in
                        'created')
                        if [ -f "$2" ] ; then
                                try=''
                                break
                        fi
                        ;;
                        'removed')
                        if [ ! -f "$2" ] ; then
                                try=''
                                break
                        fi
                        ;;
                esac
                echo -n .
                try=`expr $try + 1`
                sleep 1
        done
}
case "$1" in
        start)
                echo -n "Starting php-fpm "
                $php_fpm_BIN $php_opts
                if [ "$?" != 0 ] ; then
                        echo " failed"
                        exit 1
                fi
                wait_for_pid created $php_fpm_PID
                if [ -n "$try" ] ; then
                        echo " failed"
                        exit 1
                else
                        echo " done"
                fi
        ;;
        stop)
                echo -n "Gracefully shutting down php-fpm "
                if [ ! -r $php_fpm_PID ] ; then
                        echo "warning, no pid file found - php-fpm is not running ?"
                        exit 1
                fi
                kill -QUIT `cat $php_fpm_PID`
                wait_for_pid removed $php_fpm_PID
                if [ -n "$try" ] ; then
                        echo " failed. Use force-exit"
                        exit 1
                else
                        echo " done"
                       echo " done"
                fi
        ;;
        force-quit)
                echo -n "Terminating php-fpm "
                if [ ! -r $php_fpm_PID ] ; then
                        echo "warning, no pid file found - php-fpm is not running ?"
                        exit 1
                fi
                kill -TERM `cat $php_fpm_PID`
                wait_for_pid removed $php_fpm_PID
                if [ -n "$try" ] ; then
                        echo " failed"
                        exit 1
                else
                        echo " done"
                fi
        ;;
        restart)
                $0 stop
                $0 start
        ;;
        reload)
                echo -n "Reload service php-fpm "
                if [ ! -r $php_fpm_PID ] ; then
                        echo "warning, no pid file found - php-fpm is not running ?"
                        exit 1
                fi
                kill -USR2 `cat $php_fpm_PID`
                echo " done"
        ;;
        *)
                echo "Usage: $0 {start|stop|force-quit|restart|reload}"
                exit 1
        ;;
esac
EOF

RUN chmod 755 /etc/init.d/php-7.1-fpm \
	&& insserv php-7.1-fpm \
	&& /etc/init.d/php-7.1-fpm start \
	&& tee /lib/systemd/system/php-7.1-fpm.service <<- 'EOF'
		[Unit]
		Description=The PHP 7.1 FastCGI Process Manager
		After=network.target

		[Service]
		Type=simple
		PIDFile=/opt/php-7.1/var/run/php-fpm.pid
		ExecStart=/opt/php-7.1/sbin/php-fpm --nodaemonize --fpm-config /opt/php-7.1/etc/php-fpm.conf
		ExecReload=/bin/kill -USR2 $MAINPID

		[Install]
		WantedBy=multi-user.target

		EOF \
	&& systemctl enable php-7.1-fpm.service \
	&& systemctl daemon-reload \
	&& systemctl start php-7.1-fpm.service

RUN tee nano /opt/php-7.1/lib/php.ini <<- 'EOF'
	zend_extension=opcache.so
	EOF \
		&& cd /opt/php-7.1/bin \
		&&  ./php --version

RUN apt-get install libmemcached-dev -y\
&& mkdir -p /usr/local/src/php7-build/php-memcache \
&& cd /usr/local/src/php7-build/php-memcache \
&& wget https://github.com/php-memcached-dev/php-memcached/archive/php7.zip \
&& unzip php7.zip \
&& cd php-memcached-php7 \
&& /opt/php-7.1/bin/phpize \
&& ./configure --with-php-config=/opt/php-7.1/bin/php-config \
&& make \
&& make install \
&& echo "extension=memcached.so" >> /opt/php-7.1/lib/php.ini
















