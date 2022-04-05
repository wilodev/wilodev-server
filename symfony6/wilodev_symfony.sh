#!/bin/bash
# -*- ENCODING: UTF-8 -*-
source .env;
# Accedemos a la ruta indicada en las variables de entorno
# Se comprueba que el directorio no esta creado
if [[ ! -e $PATH_BASE/ ]]; then
    # Se crea el directorio del proyecto
    mkdir $PATH_BASE
elif [[ ! -d $PATH_BASE/ ]]; then
    echo "$PATH_BASE directorio creado" 1>&2
fi
# Se comprueba que el directorio no esta creado
if [[ ! -e $PATH_BASE/$PROJECT_NAME/ ]]; then
    # Se crea el directorio del proyecto
    mkdir $PATH_BASE/$PROJECT_NAME
elif [[ ! -d $PATH_BASE/$PROJECT_NAME ]]; then
    echo "$PATH_BASE/$PROJECT_NAME directorio creado" 1>&2
fi
# Se comprueba que el directorio no esta creado
if [[ ! -e $PATH_BASE/$PROJECT_NAME/$DOCKER_NAME/ ]]; then
    # Se crea el directorio del contenedor del proyecto
    mkdir $PATH_BASE/$PROJECT_NAME/$DOCKER_NAME/
elif [[ ! -d $PATH_BASE/$PROJECT_NAME/$DOCKER_NAME ]]; then
    echo "$PATH_BASE/$PROJECT_NAME/$DOCKER_NAME directorio creado" 1>&2
fi
# Se realiza la copia del docker al directorio del proyecto docker
# Se realiza la copia del archivo de variables de entorno.
sudo cp -R .env ./docker
# Se realiza la copia de los archivos para crear un docker custom para el proyecto con symfony 6
sudo cp -R ./docker/ $PATH_BASE/$PROJECT_NAME/$DOCKER_NAME/
# Ejecutamos el archivo del docker y construir el contenedor del proyecto
cd $PATH_BASE/$PROJECT_NAME/$DOCKER_NAME && docker-compose up -d
# Movemos el contenido de la subcarpera docker a la carpeta del proyecto para dejar el proyecto final
# mv $PATH_BASE/$PROJECT_NAME/ $PATH_BASE/
# # Borramos el directorio anterior (subproyecto)
# rm -rf $PATH_BASE/$PROJECT_NAME/$PROJECT_NAME
exit