# Configuración de la aplicación.

Para configurar la aplicación, se debe crear un archivo llamado ``env.local`` en cada uno de los directorios (traefik, php, commons) con las variables de entorno que se deseen configurar.

## Variables de entorno

Antes de iniciar la construcción de cada docker debes cambiar el nombre de cada proyecto.

``PROJECT_NAME=NOMBRE_DEL_PROYECTO``

``PROJECT_BASE_URL=URL_BASE_SERVER (ej: wilodev.localhost)  ``

#### Ruta de los volumenes
Este apartado es donde se almacena el contenido de los volumenes (archivos, directorios,etc) que se utilizan en la aplicación.

``PATH_BASE=PATH_SERVER``

#### Versiones, Tag y Url
Este apartado es donde se almacena el nombre del contenedor, imagen y url que usaremos en el navegador para acceder al servicio.

Como ejemplo ponemos el servicio de adminer, este servicio nos permite tener en el navegador un acceso gráfico a las bases de datos de la aplicación.

``ADMINER_TAG=NOMBRE_DEL_CONTENEDOR``
``ADMINER_VERSION=VERSION_DE_LA_IMAGEN``
``ADMINER_URL=PREFIJO_URL_SERVER``

## Certificados SSL / HTTPS

Todas los servicios estan configurados de forma que se pueda acceder a ellos con https, pero antes de iniciar la construcción de cada docker debes configurar el certificado SSL.

#### Instalación de certificados
Para seguir los videos debemos instalar el servicio de mkcert, este servicio nos permite generar certificados SSL.

[Mkcert GitHub](https://github.com/FiloSottile/mkcert)

Cuando ya tienes configurado todo como en el repositorio de github, debes ejecutar el siguiente comando para generar el certificado SSL.

``cd traefik/config/certs/ && mkcert "*.wilodev.localhost" localhost wilodev.localhost 127.0.0.1 ::1``

Recuerda que el dominio interno es lo que tenemos configurado en el archivo  ``env.local`` en la variables de entorno ``PROJECT_BASE_URL``.

**NOTA: Eliminar el archivo ssl.txt después de generar el certificado.**

## Construcción de Docker

Después de configurar todo lo anterior, debemos iniciar la construcción de cada docker.

### Traefik

Es un proxy inverso y balanceador de carga que se integra nativamente con Docker y Kubernetes.

En este caso debemos acceder a la carpeta de traefik y ejecutar la construcción.

**NOTA para generar estos datos usar esta web:** <https://hostingcanada.org/htpasswd-generator/>

``cd traefik/ && docker-compose up -d``

Al terminar la construcción del docker podemos ingresar al navegador y verificar que el servicio esta funcionando.

<https://traefik.wilodev.localhost>

Con esta URL nos pedirá un usuario y contraseña que esta en el archivo ``.env.local`` de la carpeta traefik.

### Commons

En este apartado es donde ejecutaremos todos los servicios que usaremos entre las diferentes aplicaciones.

En este caso debemos acceder a la carpeta de commons y ejecutar la construcción.

``cd commons/ && docker-compose up -d``

Al terminar la construcción del docker podemos ingresar al navegador y verificar que el servicio esta funcionando.

<https://adminer.wilodev.localhost>
<https://pma.wilodev.localhost>

**NOTA: En la carpeta config podremos cambiar la configuración la cuota de subida y el archivo bashrc, El .bashrc es un script que se ejecuta cada vez que se inicia una nueva sesión de terminal**

### Symfony

En este apartado es donde ejecutaremos el serivicio de php 8 con soporte para symfony

En este caso debemos acceder a la carpeta de php y ejecutar la construcción.

``cd php/symfony/ && docker-compose up -d``

Al terminar la construcción del docker podemos ingresar al navegador y verificar que el servicio esta funcionando.

<https://shop.wilodev.localhost>

**NOTA: En la carpeta config podremos cambiar la configuración la cuota de subida, archivo de configuración del apache2, el archivo xdebug y el archivo bashrc, El .bashrc es un script que se ejecuta cada vez que se inicia una nueva sesión de terminal**

## Balancer

Para poder ejecutar multiples instancias de un contenedor podemos usar un balancer.

Si se desea probar el escalamiento de alguno de los servicio solo deben usar el balancer.

``docker-compose up -d --scale nombre servicio (sy6)=numero de veces a escalar``

Ejemplo:

``docker-compose up -d --scale sy6=5``

Con esto escalas a 5 servicios del server de sy6 es decir cada petición realizada a este servicio se redirecciona (5 servidores creados).