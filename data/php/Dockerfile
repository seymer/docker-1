#
# Reference https://www.howtoforge.com/tutorial/how-to-install-php-7-on-debian/
# Author: Maycon Brito
#
FROM debian:latest

RUN apt-get update \
	&& apt-get install \
        build-essential \
		wget \
		aptitude \
		nano \
		autoconf \
		unzip \
		curl \
		libfcgi-dev \
		libfcgi0ldbl \
		libjpeg62-turbo-dbg \
		libmcrypt-dev \
		libssl-dev \
		libc-client2007e \
		libc-client2007e-dev \
		libxml2-dev \
		libbz2-dev \
		libcurl4-openssl-dev \
		libjpeg-dev \
		libpng12-dev \
		libfreetype6-dev \
		libkrb5-dev \
		libpq-dev \
		libxml2-dev \
		libxslt1-dev -y \
		pkg-config -y

RUN mkdir -p /opt/php-7.1 \
	&& mkdir -p /usr/local/src/php7-build \
	&& cd /usr/local/src/php7-build \
	&& wget -O php.tar.gz http://br1.php.net/get/php-7.1.0.tar.gz/from/this/mirror \
	&& tar zxvf php.tar.gz \
	&& cd php-7.1.0/ \
	&& ln -sf /usr/lib/libc-client.a /usr/lib/x86_64-linux-gnu/libc-client.a \
	&& ./configure --prefix=/opt/php-7.1 --with-pdo-pgsql --with-zlib-dir \
		--with-freetype-dir --enable-mbstring --with-libxml-dir=/usr --enable-soap \
		--enable-calendar --with-curl --with-mcrypt --with-zlib --with-gd --with-pgsql \
		--disable-rpath --enable-inline-optimization --with-bz2 --with-zlib --enable-sockets \
		--enable-sysvsem --enable-sysvshm --enable-pcntl --enable-mbregex --enable-exif \
		--enable-bcmath --with-mhash --enable-zip --with-pcre-regex --with-pdo-mysql \
		--with-mysqli --with-mysql-sock=/var/run/mysqld/mysqld.sock --with-jpeg-dir=/usr \
		--with-png-dir=/usr --enable-gd-native-ttf --with-openssl --with-fpm-user=www-data \
		--with-fpm-group=www-data --with-libdir=/lib/x86_64-linux-gnu --enable-ftp --with-imap \
		--with-imap-ssl --with-kerberos --with-gettext --with-xmlrpc --with-xsl \
		--enable-opcache --enable-fpm \
	&& make \
	&& make install

RUN apt-get install libmemcached-dev -y \
	&& mkdir -p /usr/local/src/php7-build/php-memcache \
	&& cd /usr/local/src/php7-build/php-memcache \
	&& wget https://github.com/php-memcached-dev/php-memcached/archive/php7.zip \
	&& unzip php7.zip \
	&& cd php-memcached-php7 \
	&& /opt/php-7.1/bin/phpize \
	&& ./configure --with-php-config=/opt/php-7.1/bin/php-config \
	&& make \
	&& make install

RUN cp /usr/local/src/php7-build/php-7.1.0/php.ini-production /opt/php-7.1/lib/php.ini

COPY www.conf /opt/php-7.1/etc/php-fpm.d/www.conf

COPY etc.php-fpm.conf /opt/php-7.1/etc/php-fpm.conf

COPY init.d.php-7.1-fpm /etc/init.d/php-7.1-fpm

RUN chmod 755 /etc/init.d/php-7.1-fpm \
	&& insserv php-7.1-fpm

COPY php-7.1-fpm.service /lib/systemd/system/php-7.1-fpm.service

RUN chmod 644 /lib/systemd/system/php-7.1-fpm.service \
	&& systemctl enable php-7.1-fpm.service

# RUN && systemctl daemon-reload \
	# && systemctl start php-7.1-fpm.service

COPY php.ini /opt/php-7.1/lib/php.ini

RUN echo "export PATH=$PATH:/opt/php-7.1/bin" >> ~/.bashrc \
	&& . ~/.bashrc \
	&& ln -sf /opt/php-7.1/bin/php /usr/bin/php \
	&& ln -sf /opt/php-7.1/sbin/php-fpm /usr/bin/php-fpm

RUN apt-get install re2c file apt-utils -y

RUN mkdir -p /opt/libssh2/ \
	&& cd /usr/local/src/ \
	&& wget -O libssh2.tar.gz https://libssh2.org/download/libssh2-1.8.0.tar.gz \
	&& tar zxvf libssh2.tar.gz \
	&& cd libssh2-1.8.0/ \
	&& ./configure --prefix=/opt/libssh2/ \
	&& make \
	&& make install

RUN mkdir -p /opt/ssh2/ \
	&& cd /usr/local/src/ \
	&& wget -O ssh2.tgz https://pecl.php.net/get/ssh2-1.0.tgz \
	&& tar zxvf ssh2.tgz \
	&& cd ssh2-1.0/ \
	&& /opt/php-7.1/bin/phpize \
	&& ./configure \
		--with-php-config=/opt/php-7.1/bin/php-config \
		--prefix=/opt/ssh2/ \
		--with-ssh2=/opt/libssh2/ \
	&& make \
	&& make install

# RUN php -v \
	# && /etc/init.d/php-7.1-fpm start

EXPOSE 9000
CMD ["php-fpm"]
