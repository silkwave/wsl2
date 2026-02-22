# --- 오라클 데이터 디렉토리 설정 ---
# 오라클 데이터베이스를 위한 디렉토리 생성 및 권한 설정
mkdir -p /u01/app/oracle/oradata ${HOME}/oradata/
chmod 777 /u01/app/oracle/oradata ${HOME}/oradata/

# --- Podman을 이용한 오라클 컨테이너 관리 ---
# Podman을 사용하여 'neo365/oracle19c-ko' 이미지 검색 및 다운로드
podman search docker.io/neo365/oracle19c-ko
podman pull docker.io/neo365/oracle19c-ko

# 기존 컨테이너 제거 후 새 오라클 19c 컨테이너 백그라운드 실행
podman rm -f oracle19c-ko
podman run -d \
  --name oracle19c-ko \
  --network host \
  --privileged \
  --shm-size=2g \
  -e ORACLE_SID=ORCL \
  -e ORACLE_PWD=oraclepassword \
  -e ORACLE_CHARACTERSET=AL32UTF8 \
  -v ${HOME}/oradata:/opt/oracle/oradata \
  neo365/oracle19c-ko


# 'oracle19c-ko' 컨테이너 시작/중지
podman start oracle19c-ko
podman stop oracle19c-ko

# 'oracle19c-ko' 컨테이너 내부로 bash 쉘로 접속 및 로그 확인
podman exec -it oracle19c-ko /bin/bash
podman logs -f oracle19c-ko

# --- 방화벽 (UFW) 설정 ---
# 시스템 패키지 업데이트 및 UFW 설치
sudo apt update
sudo apt install ufw -y

# UFW 기본 정책 및 오라클, SSH 포트 허용
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp
sudo ufw allow 1521/tcp
sudo ufw allow 5500/tcp
sudo ufw enable

# --- 네트워크 및 컨테이너 정보 확인 ---
# 1521 포트를 사용하는 네트워크 소켓 상태 확인
ss -lntp | grep 1521
# Podman 네트워크 및 컨테이너 IP, 리스너 상태 확인
podman network inspect podman
podman inspect oracle19c-ko | grep IPAddress
podman inspect oracle19c-ko | grep Network
podman exec -it oracle19c-ko lsnrctl status

# --- SQL Plus를 이용한 데이터베이스 관리 ---
# SQL Plus를 SYSDBA 권한으로 접속 (두 가지 방식)
sqlplus / as sysdba
sqlplus '/as sysdba'

# 데이터베이스 정보 조회
select name from v$database; # 현재 데이터베이스 이름
show con_name             # 현재 컨테이너 데이터베이스(CDB) 이름
show pdbs                 # 플러그형 데이터베이스(PDB) 목록 조회
desc V$SERVICES;          # V$SERVICES 뷰 구조 설명
SELECT NAME FROM V$SERVICES; # V$SERVICES 뷰에서 서비스 이름 조회

# --- 사용자 계정 관리 ---
# 'docker' 사용자 생성 및 권한 설정
create user docker identified by "docker123";
grant connect, resource to docker;
GRANT DBA TO docker;
alter user docker quota unlimited on users;
ALTER USER docker IDENTIFIED BY docker123;

# 'silkwave' 사용자 생성 및 권한 설정
CREATE USER silkwave IDENTIFIED BY oraclepassword;
GRANT ALL PRIVILEGES TO silkwave;
GRANT DBA TO silkwave;
ALTER USER silkwave IDENTIFIED BY 1234;

# 시스템 사용자 비밀번호 변경 (예시)
ALTER USER sys IDENTIFIED BY new_password;
ALTER USER system IDENTIFIED BY new_password;
# 'silkwave' 사용자 비밀번호 변경 (SYSDBA 권한으로)
sqlplus / as sysdba
ALTER USER silkwave IDENTIFIED BY 1234;
