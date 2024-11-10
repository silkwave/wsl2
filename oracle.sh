mkdir -p /home/silkwave/oradata/
chmod 777 /home/silkwave/oradata

podman search docker.io/neo365/oracle19c-ko 
podman pull docker.io/neo365/oracle19c-ko 
podman run -d --name oracle19c-ko          \
           -p 1521:1521                    \
           -e ORACLE_SID=ORCL              \
           -e ORACLE_PWD=oraclepassword    \
           -e ORACLE_CHARACTERSET=UTF8     \
           -v /home/silkwave/oradata/:/opt/oracle/oradata \
           neo365/oracle19c-ko 

podman logs -f oracle19c-ko

podman start oracle19c-ko 
podman stop oracle19c-ko 

podman exec -it oracle19c-ko /bin/bash
sqlplus / as sysdba


CREATE USER silkwave IDENTIFIED BY oraclepassword;
GRANT ALL PRIVILEGES TO silkwave;
GRANT DBA TO silkwave;
ALTER USER silkwave IDENTIFIED BY 1234;

desc V$SERVICES;
SELECT NAME FROM V$SERVICES;

ALTER USER sys IDENTIFIED BY new_password;
ALTER USER system IDENTIFIED BY new_password;

sqlplus / as sysdba
ALTER USER silkwave IDENTIFIED BY 1234;

