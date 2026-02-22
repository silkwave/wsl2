FROM docker.io/neo365/oracle19c-ko:latest

LABEL maintainer="production"
LABEL description="Oracle 19c Korean with docker user + healthcheck"

ENV ORACLE_SID=ORCL \
    ORACLE_PWD=oraclepassword \
    ORACLE_CHARACTERSET=AL32UTF8

USER root

# 스크립트 디렉토리
RUN mkdir -p /opt/oracle/scripts/startup \
    && chown -R oracle:oinstall /opt/oracle/scripts

# 사용자 생성 SQL
COPY init/init.sql /opt/oracle/scripts/startup/

# Healthcheck 스크립트
COPY scripts/healthcheck.sh /opt/oracle/healthcheck.sh
RUN chmod +x /opt/oracle/healthcheck.sh

VOLUME ["/opt/oracle/oradata"]

EXPOSE 1521 5500

# HEALTHCHECK 설정
HEALTHCHECK --interval=30s --timeout=10s --start-period=5m --retries=5 \
  CMD /opt/oracle/healthcheck.sh || exit 1

USER oracle