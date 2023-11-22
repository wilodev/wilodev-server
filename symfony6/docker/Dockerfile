# Aplicación en Php 8.1 para Symfony con base Wilodev que se basa en Wilo Dock
# Repositorio de Php 8.1
FROM php:8.1-rc-fpm
# Propietario
LABEL maintainer="wperez@cintanegra.net @wilodev"
LABEL name="wilodev-server"
LABEL version="1"
# Asignar los argumentos
ARG PROJECT_NAME
ARG GIT_EMAIL
ARG GIT_USERNAME
# Extensiones
RUN apt-get update && apt-get install -y                    \
    curl 					                                \
    git 					                                \
    libpng-dev 				                                \
    libonig-dev 			                                \
    libxml2-dev 			                                \
    libxslt-dev 			                                \
    libzip-dev                                              \
    bzip2                                                   \
    libfreetype6-dev                                        \
    libjpeg62-turbo-dev                                     \
    libmcrypt-dev                                           \
    libpng-dev                                              \
    libicu-dev 								                \
    libpq-dev 								                \
    libxpm-dev 								                \
    libvpx-dev 	                                            \
    librabbitmq-dev 							            \
    libsasl2-dev 								            \
    libssh-dev                                              \
    nano                                                    \
    coreutils             	                                \
    util-linux            	                                \
    openssl               	                                \
    libssl-dev            	                                \
    locales               	                                \
    ca-certificates       	                                \
    ssh                   	                                \
    wget                  	                                \
    patch                 	                                \
    sudo                  	                                \
    vim                   	                                \
    curl                  	                                \
    zsh                   	                                \
    gcc               		                                \
    g++               		                                \
    zip
RUN pecl install xdebug
RUN docker-php-ext-enable xdebug 				            \
    && docker-php-ext-install zip 					        \
    && docker-php-ext-install -j$(nproc) gd 		        \
    && docker-php-ext-install -j$(nproc) intl 	            \
    && docker-php-ext-install -j$(nproc) zip 		        \
    && docker-php-ext-install -j$(nproc) pdo_mysql 	        \
    && docker-php-ext-install -j$(nproc) pdo_pgsql 	        \
    && docker-php-ext-install -j$(nproc) exif               \
    && docker-php-ext-install -j$(nproc) simplexml          \
    && docker-php-ext-install -j$(nproc) session		    \
    && docker-php-ext-install -j$(nproc) iconv
RUN docker-php-ext-install -j$(nproc) ctype
RUN pecl install -o -f redis \
    && docker-php-ext-enable redis
RUN docker-php-ext-configure gd
RUN docker-php-ext-install bcmath
RUN pecl install amqp \
    && docker-php-ext-enable amqp
# Instala y configura Bun.sh
RUN curl -fsSL https://bun.sh/install | bash
# Creación de Alias personalizados
# Si se quiere poner más alias solo modifica el archivo ./config/.bashrc
COPY ./config/.bashrc /root/.bashrc
# Instala Composer 2.5.8
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=2.6.5
# Instala el CLI de Symfony
RUN curl -sS https://get.symfony.com/cli/installer | bash
RUN export PATH="$HOME/.symfony5/bin:$PATH"
RUN mv /root/.symfony5/bin/symfony /usr/local/bin/symfony
# Se copia los archivos de configuración.
COPY ./config/local.ini /usr/local/etc/php/conf.d/local.ini
COPY ./config/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
COPY ./config/xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Se incrementa el tamaño de los archivos que se pueden subir
RUN echo "upload_max_filesize = 10000M" >> /usr/local/etc/php/php.ini
RUN echo "post_max_size = 10000M" >> /usr/local/etc/php/php.ini
# Se incrementa el tiempo de ejecución de los scripts
RUN echo "max_execution_time = 300000" >> /usr/local/etc/php/php.ini
RUN echo "max_input_time = 300000" >> /usr/local/etc/php/php.ini
# Instala y configura Psalm
RUN composer require --dev vimeo/psalm
# Instala y configura php-cs-fixer de Symfony
RUN composer require --dev friendsofphp/php-cs-fixer
# Instala y configura phpstan
RUN composer require --dev phpstan/phpstan
# Instala y configura phpunit
RUN composer require --dev phpunit/phpunit
# Se añade de forma global git
RUN  git config --global user.email "${GIT_EMAIL}"
RUN git config --global user.name "${GIT_USERNAME}"
# Configura el servidor web Nginx
# Aquí debes incluir las configuraciones necesarias de Nginx para exponer la web
# Puedes copiar un archivo de configuración desde tu proyecto Symfony o crear uno específico para Docker
# Establece el directorio de trabajo en el directorio del proyecto Symfony
WORKDIR /var/www/public/${PROJECT_NAME}
# Expón el puerto 80 para el servidor web Nginx
EXPOSE 9000
# Comando por defecto al iniciar el contenedor
# Puedes configurarlo para que inicie el servidor web de Nginx o para ejecutar otros comandos según tus necesidades
CMD ["php-fpm"]
