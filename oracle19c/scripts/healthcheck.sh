#!/bin/bash

echo "SELECT 1 FROM dual;" | sqlplus -s sys/${ORACLE_PWD}@localhost:1521/${ORACLE_SID} as sysdba | grep 1 > /dev/null

if [ $? -eq 0 ]; then
  exit 0
else
  exit 1
fi