mkdir -p /u01/app/oracle/oradata
chmod 777 /u01/app/oracle/oradata

docker run -d --name oracle19db \
-p 1521:1521 \
-e ORACLE_SID=MONGO \
-e ORACLE_PDB=MONGOPDB \
-e ORACLE_PWD=Oracle123 \
-v /u01/app/oracle/oradata:/opt/oracle/oradata \
banglamon/oracle193db:19.3.0-ee


mkdir -p ${HOME}/oradata/
chmod 777 ${HOME}/oradata

podman search docker.io/neo365/oracle19c-ko 
podman pull docker.io/neo365/oracle19c-ko 
podman run -d                              \
           --name oracle19c-ko             \
           --network bridge                \
           -p 1521:1521                    \
           -e ORACLE_SID=ORCL              \
           -e ORACLE_PWD=oraclepassword    \
           -e ORACLE_CHARACTERSET=UTF8     \
           -v ${HOME}/oradata/:/opt/oracle/oradata \
               neo365/oracle19c-ko 


sudo socat TCP-LISTEN:1521,fork TCP:10.88.0.x:1521
sudo socat TCP-LISTEN:1521,fork TCP:localhost:1521
sudo iptables -t nat -A PREROUTING -p tcp --dport 1521 -j DNAT --to-destination 127.0.0.1:1521

podman network inspect podman
podman inspect oracle19c-ko | grep IPAddress
podman inspect oracle19c-ko | grep Network
podman exec -it oracle19c-ko lsnrctl status


podman logs -f oracle19c-ko

podman start oracle19c-ko 
podman stop oracle19c-ko 

podman exec -it oracle19c-ko /bin/bash
sqlplus / as sysdba
sqlplus '/as sysdba'
select name from v$database;
show con_name
show pdbs

create user docker identified by "docker123";
grant connect, resource to docker;
alter user docker quota unlimited on users;

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

