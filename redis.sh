# Redis Podman 이미지 다운로드
podman pull redis

# Redis 컨테이너 실행 (기본 포트 6379로 실행)
# `--name redis`: 컨테이너 이름을 'redis'로 설정
# `-p 6379:6379`: 호스트의 6379 포트를 컨테이너의 6379 포트에 연결
# `-d`: 백그라운드에서 컨테이너 실행
podman run --name redis -p 6379:6379 -d redis

# 실행 중인 Redis 컨테이너 내부로 bash 쉘로 접속
podman exec -it redis bash

# Redis CLI를 사용하여 Redis 서버에 접속 (호스트 127.0.0.1, 포트 6379)
redis-cli -h 127.0.0.1 -p 6379

# Key-Value 저장 및 조회
SET mykey "Hello Redis"  # 'mykey'에 "Hello Redis" 문자열 데이터 저장
GET mykey                # 'mykey'의 값 조회
DEL mykey                # 'mykey' 삭제

# 데이터 만료 시간 설정
SET session "user123"      # 'session' 키에 "user123" 값 저장
EXPIRE session 60          # 'session' 키의 만료 시간을 60초로 설정
TTL session                # 'session' 키의 남은 만료 시간 (초 단위) 조회

# 여러 개의 Key-Value 저장 및 조회
MSET key1 "value1" key2 "value2" # 'key1'에 "value1", 'key2'에 "value2"를 한 번에 저장
MGET key1 key2                   # 'key1'과 'key2'의 값을 한 번에 조회

# 데이터 구조별 명령어 (문자열)
SET user "John Doe"              # 'user' 키에 "John Doe" 문자열 저장
GET user                         # 'user' 키의 값 조회
APPEND user " is a developer"   # 'user' 키의 값에 " is a developer" 문자열 추가
GET user                         # 변경된 'user' 키의 값 조회

# Hash (해시) 데이터 구조
HSET user:1001 name "Alice" # 'user:1001' 해시에 'name' 필드와 "Alice" 값 저장
HSET user:1001 age 25       # 'user:1001' 해시에 'age' 필드와 25 값 저장
HGET user:1001 name         # 'user:1001' 해시에서 'name' 필드의 값 조회
HGETALL user:1001           # 'user:1001' 해시의 모든 필드와 값 조회

# List (리스트) 데이터 구조
LPUSH tasks "Task 1" # 'tasks' 리스트의 왼쪽에 "Task 1" 추가
LPUSH tasks "Task 2" # 'tasks' 리스트의 왼쪽에 "Task 2" 추가 (리스트: ["Task 2", "Task 1"])
LRANGE tasks 0 -1    # 'tasks' 리스트의 모든 요소 조회 (인덱스 0부터 마지막까지)
LPOP tasks           # 'tasks' 리스트의 왼쪽에서 요소 하나 제거 및 반환

# Set (집합) 데이터 구조
SADD myset "Apple"   # 'myset' 집합에 "Apple" 추가
SADD myset "Banana"  # 'myset' 집합에 "Banana" 추가
SADD myset "Orange"  # 'myset' 집합에 "Orange" 추가
SMEMBERS myset       # 'myset' 집합의 모든 멤버 조회

# Sorted Set (정렬된 집합) 데이터 구조
ZADD leaderboard 100 "Player1" # 'leaderboard' 정렬된 집합에 점수 100으로 "Player1" 추가
ZADD leaderboard 200 "Player2" # 'leaderboard' 정렬된 집합에 점수 200으로 "Player2" 추가
ZRANGE leaderboard 0 -1 WITHSCORES # 'leaderboard' 정렬된 집합의 모든 멤버와 점수 조회
ZRANK leaderboard "Player1"    # 'leaderboard' 정렬된 집합에서 "Player1"의 랭크 조회

# 서버 정보 확인
INFO # Redis 서버에 대한 다양한 정보 (서버, 클라이언트, 메모리, 영속성 등) 조회

# 모든 키 조회
KEYS * # 현재 데이터베이스의 모든 키 조회

# 데이터 삭제
FLUSHALL  # Redis 서버의 모든 데이터베이스에 있는 모든 키 삭제
FLUSHDB   # 현재 선택된 데이터베이스의 모든 키 삭제

# Redis 종료
QUIT # Redis 서버 연결 종료
