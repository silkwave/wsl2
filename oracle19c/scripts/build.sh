podman build --format docker -t oracle19c-ko-prod .


podman run -d \
  --name oracle19c-ko \
  --network host \
  --shm-size=2g \
  --restart=always \
  -v ${HOME}/oradata:/opt/oracle/oradata:Z \
  oracle19c-ko-prod

podman logs -f oracle19c-ko  

podman stop oracle19c-ko

podman rm oracle19c-ko  

# 병렬 성능 테스트용 힌트 추가
INSERT /*+ APPEND */ INTO BOARD (TITLE, CONTENT)
SELECT
    '병렬테스트 ' || LEVEL,
    RPAD('대용량', 2000, '*')
FROM dual
CONNECT BY LEVEL <= 100000;

COMMIT;

# 현재 락 확인 쿼리
SELECT
    s.sid,
    s.serial#,
    s.username,
    l.type,
    l.lmode,
    l.request
FROM v$lock l
JOIN v$session s ON l.sid = s.sid;