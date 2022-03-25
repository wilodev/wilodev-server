# Aplicación en Php 8.1 para Symfony con base Infinyti
# Repositorio de Php 8.1
FROM php:8.1.3RC1-apache-buster
# Propietario
LABEL maintainer="wperez@cintanegra.net @wilodev"
LABEL name="infinyti-server"
LABEL version="1"
# Asignar los argumentos
ARG PROJECT_SY_NAME
ARG GIT_EMAIL
ARG GIT_USERNAME
# Instanlando dependencias para Infinyti / Symfony
RUN apt-get update && apt-get install -y    \
git 					                    \
libpng-dev 				                    \
libonig-dev 			                    \
libxml2-dev 			                    \
libzip-dev 									\
bzip2 										\
libfreetype6-dev 							\
libjpeg62-turbo-dev 						\
libmcrypt-dev 								\
libpng-dev 									\
libicu-dev 								    \
libpq-dev 								    \
libxpm-dev 								    \
libvpx-dev 	                                \
nano				                    	\
coreutils             	                    \
util-linux            	                    \
openssl               	                    \
libssl-dev            	                    \
locales               	                    \
ca-certificates       	                    \
ssh                   	                    \
wget                  	                    \
patch                 	                    \
sudo                  	                    \
vim                   	                    \
curl                  	                    \
zsh                   	                    \
gcc               		                    \
g++               		                    \
unzip
# Limpiando la cache
RUN apt-get  clean && rm -rf /var/lib/apt/lists/*
# Instalando las extenciones de php
RUN pecl install xdebug 						        \
&& docker-php-ext-enable xdebug 				        \
&& docker-php-ext-install zip 					        \
&& docker-php-ext-install -j$(nproc) gd 		        \
&& docker-php-ext-install -j$(nproc) intl 	            \
&& docker-php-ext-install -j$(nproc) zip 		        \
&& docker-php-ext-install -j$(nproc) pgsql 	            \
&& docker-php-ext-install -j$(nproc) pdo_pgsql 	        \
&& docker-php-ext-install -j$(nproc) pdo_mysql 	        \
&& docker-php-ext-install -j$(nproc) exif 		        \
&& docker-php-ext-configure gd

# Instalando composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
# Creamos el usuario pasado como argumento desde el docker-compose.yml
#RUN useradd -G www-data,root -u $uid -d /home/
RUN mkdir -p /home/.composer
# Creación de Alias personalizados
# Si se quiere poner más alias solo modifica el archivo ./config/.bashrc
COPY ./config/.bashrc /root/.bashrc
# Configuramos las variables
ENV NVM_DIR /root/nvm
ENV NODE_VERSION 17.7.2
ENV NVM_VERSION v0.39.1

# Crear la carpeta de nvm
RUN mkdir $NVM_DIR
RUN chmod -R 777 $NVM_DIR
RUN touch $NVM_DIR/test.text
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
# Añadimos el directorio de trabajo
WORKDIR /var/www/html
# Agreamos symfony
# RUN curl -sS https://get.symfony.com/cli/installer | bash
RUN echo 'deb [trusted=yes] https://repo.symfony.com/apt/ /' | sudo tee /etc/apt/sources.list.d/symfony-cli.list
RUN apt update
RUN apt install symfony-cli
# # Creamos el enalce de symfony
# RUN mv /root/.symfony/bin/symfony /usr/local/bin/symfony
# Añadimos la configuración de git
RUN git config --global user.email "${GIT_EMAIL}"
RUN git config --global user.name "${GIT_USERNAME}"
# Activamos el Rewrite
RUN a2enmod rewrite
# Cambiamos el server name
RUN echo "ServerName localhost" | tee /etc/apache2/conf-available/fqdn.conf && a2enconf fqdn
# Reiniciamos el servicio de apache2
RUN service apache2 restart
# Lanzamos el servicio
CMD ["apache2-foreground"]