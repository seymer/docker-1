FROM php:5.6-fpm
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        libssh2-1 \
        libssh2-1-dev \
        freetds-dev

RUN ln -sf /usr/lib/x86_64-linux-gnu/libsybdb.a /usr/lib/

RUN pecl install ssh2-0.13 \
	&& docker-php-ext-enable ssh2

RUN docker-php-ext-install -j$(nproc) iconv \
    	json \
    	mbstring \
    	mcrypt \
    	mssql \
    	mysqli \
    	pdo \
    	pdo_dblib \
    	pdo_mysql \
    	zip \
    && docker-php-ext-configure gd \
    	--with-freetype-dir=/usr/include/ \
    	--with-jpeg-dir=/usr/include/ \
    	--with-mssql \
    && docker-php-ext-install -j$(nproc) gd

COPY php.ini /usr/local/etc/php/