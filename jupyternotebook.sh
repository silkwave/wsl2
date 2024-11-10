mkdir ~/jupyternotebook
chmod 777 ~/jupyternotebook # 권한을 주지 않으면 403 error 발생 (root에서 만들기 때문)
cd ~/jupyternotebook
======================================================
# PWD는 현재 디렉토리라는 의미
docker와 docker-compose 설치 및 실행을 끝마치고
vi docker-compose.yaml 를 하여 아래와 같은 .yaml 파일을 생성합니다

version:                "3"
services:
  datascience-notebook:
      image:            jupyter/datascience-notebook
      user: root
      environment:
        - GRANT_SUDO=yes
        - JUPYTER_ENABLE_LAB=yes
        - JUPYTER_TOKEN=1234      
      volumes:
        - ${PWD}/data:/home/jovyan/work:rw
      ports:
        - 8888:8888
      container_name:   ds

docker pull jupyter/tensorflow-notebook
podman pull jupyter/tensorflow-notebook

version:                "3"
services:
  datascience-notebook:
      image:            jupyter/tensorflow-notebook
      user: root
      environment:
        - GRANT_SUDO=yes
        - JUPYTER_ENABLE_LAB=yes
        - JUPYTER_TOKEN=1234      
      volumes:
        - ${PWD}/data:/home/jovyan/work:rw
      ports:
        - 8888:8888
      container_name:   ts      

docker-compose up -d   
docker-compose logs

podman-compose up -d   
podman-compose logs

======================================================

docker run -p 8888:8888 \
           -e JUPYTER_ENABLE_LAB=yes \
           -e JUPYTER_TOKEN=docker \
           --name jupyter \
           -d jupyter/datascience-notebook:latest

# Jupyter notebook Container 실행
docker exec -it ts bash
docker run -it python:3.8-alpine 
docker run -d -p 8888:8888 python:3.8-alpine jupyter lab --no-browser --allow-root
conda install cudatoolkit

$ pip install jupyterlab
$ jupyter lab password
## 패스워드 설정
$ jupyter lab --no-browser --allow-root

======================================================

 3. jupyterlab 접속
위에 설정된대로  http://8888:  8888 입력하면 아래와 같은 웹에 접속할 수 있으며 token은 logs에 나온 값을 입력하면 된다.

Jupyter notebook 비밀번호 생성
ipython
>> from notebook.auth import passwd
>> passwd()
>> 비밀번호 입력
>> 비밀번호 재입력
# 출력된 비밀번호를 따로 저장 
>> exit
