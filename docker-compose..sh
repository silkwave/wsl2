==================================
dockerfiles
==================================
FROM jupyter/datascience-notebook:latest
# Declare root as user 
USER root
# Update Ubuntu 
RUN sed -i 's/archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list && sed -i 's/security.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list
# Install Nanum for Korean Font 
RUN apt-get update && apt-get -y upgrade && apt-get install -y fonts-nanum* && fc-cache -fv && rm -fr ~/.cache/matplotlib

==================================
docker-compose.yml
==================================
version: '3'
#
services:
#
    jupyter-ds:
      build:
        context: .
        dockerfile: ./dockerfiles/dockerfile-jupyter
      user: root
      environment:
        - GRANT_SUDO=yes
        - JUPYTER_ENABLE_LAB=yes
        - JUPYTER_TOKEN={YOUR-PASSWORD}
      volumes:
        - /mnt/c/Users/{YOUR-DIR}:/home/jovyan/github-anari
      ports:
        - "8888:8888"
      container_name: "jupyter-ds"
# End of yml
=================================
sudo docker-compose -f /mnt/{YOUR DIR}/docker-jupyter.yml -p "jupyter-ds" up -d
