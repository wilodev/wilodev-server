# Aplicación en Php 8.1 para Infinyti que se basa en Wilo Dock
# Repositorio de Php 8.1
FROM php:fpm-buster
# Propietario
LABEL maintainer="wperez@cintanegra.net @wilodev"
LABEL name="infinyti-dock"
LABEL version="1"
# Asignar los argumentos
ARG PROJECT_NAME
ARG GIT_EMAIL
ARG GIT_USERNAME
# Instanlando dependencias para Infinyti
RUN apt-get update && apt-get install -y    \
git 					                              \
libpng-dev 				                          \
libonig-dev 			                          \
libxml2-dev 			                          \
libzip-dev                                  \
bzip2                                       \
libfreetype6-dev                            \
libjpeg62-turbo-dev                         \
libmcrypt-dev                               \
libpng-dev                                  \
libicu-dev                                  \
libpq-dev                                   \
libxpm-dev                                  \
libvpx-dev 	                                \
nano                                        \
coreutils                                   \
util-linux                                  \
openssl                                     \
libssl-dev                                  \
locales                                     \
ca-certificates                             \
ssh                                         \
wget                                        \
patch                                       \
sudo                                        \
vim                                         \
curl                                        \
zsh                                         \
gcc                                         \
g++                                         \
unzip
# Limpiando la cache
RUN apt-get  clean && rm -rf /var/lib/apt/lists/*
# Instalando las extenciones de php
RUN pecl install xdebug 						                   \
&& docker-php-ext-enable xdebug 				               \
&& docker-php-ext-install zip 					               \
&& docker-php-ext-install -j$(nproc) gd 		           \
&& docker-php-ext-install -j$(nproc) intl 	           \
&& docker-php-ext-install -j$(nproc) zip 		           \
&& docker-php-ext-install -j$(nproc) pgsql 	           \
&& docker-php-ext-install -j$(nproc) pdo_pgsql 	       \
&& docker-php-ext-install -j$(nproc) pdo_mysql 	       \
&& docker-php-ext-install -j$(nproc) exif 		         \
&& docker-php-ext-configure gd
# Instalando composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
# Creamos el usuario pasado como argumento desde el docker-compose.yml
# Añadimos el usuario para la aplicación
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www
RUN usermod -aG sudo www
RUN mkdir -p /home/.composer
# Configuramos las variables
ENV NVM_DIR /root/nvm
ENV NODE_VERSION 17.7.2
ENV NVM_VERSION v0.39.1
# Crear la carpeta de nvm
RUN mkdir -p $NVM_DIR
RUN chmod -R 777 $NVM_DIR
RUN touch $NVM_DIR/test.text
# Creación de Alias personalizados
# Si se quiere poner más alias solo modifica el archivo ./config/.bashrc
COPY ./config/.bashrc /root/.bashrc
# Instalamos el manejador nvm
RUN curl --silent -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh | bash
# Añadimos node y npm al path de comandos
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH
RUN ["/bin/bash", "-s", "$NVM_DIR/nvm.sh"]
RUN chmod -R 777 $NVM_DIR/nvm.sh
RUN /root/nvm/nvm.sh install $NODE_VERSION
RUN /root/nvm/nvm.sh alias default $NODE_VERSION
RUN /root/nvm/nvm.sh use default
# Comprobamos las versiones de node y npm
RUN node -v
RUN npm -v
# Actualiamos el paquete npm
RUN npm i -g npm
# Comprobamos la nueva versión de npm
RUN npm -v
# Agreamos symfony
RUN echo 'deb [trusted=yes] https://repo.symfony.com/apt/ /' | sudo tee /etc/apt/sources.list.d/symfony-cli.list
RUN apt update
RUN apt install symfony-cli
# Añadimos la configuración de git
RUN git config --global user.email "${GIT_EMAIL}"
RUN git config --global user.name "${GIT_USERNAME}"
# Añadimos el directorio de trabajo
WORKDIR /var/www/public/${PROJECT_NAME}
# # Cambiamos los permisos de los archivos y su propietario
# COPY --chown=www:www . /var/www/public
# Lanzamos el servicio
CMD ["php-fpm"]