DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM dba_users WHERE username = 'DOCKER';

    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'CREATE USER docker IDENTIFIED BY "docker123"';
        EXECUTE IMMEDIATE 'GRANT CONNECT, RESOURCE TO docker';
        EXECUTE IMMEDIATE 'ALTER USER docker QUOTA UNLIMITED ON USERS';
    END IF;
END;
/

-- ==========================================
-- BOARD 테이블이 없을 때만 생성
-- ==========================================
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM user_tables
    WHERE table_name = 'BOARD';

    IF v_count = 0 THEN
        EXECUTE IMMEDIATE '
            CREATE TABLE BOARD (
                ID          NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                TITLE       VARCHAR2(200) NOT NULL,
                CONTENT     CLOB NOT NULL,
                CREATED_AT  DATE DEFAULT SYSDATE NOT NULL
            )
        ';
    END IF;
END;
/
-- ==========================================
-- 샘플 데이터가 없을 경우만 INSERT
-- ==========================================
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM BOARD;

    IF v_count = 0 THEN
        INSERT INTO BOARD (TITLE, CONTENT)
        VALUES ('첫 번째 게시글', 'Oracle 19c Docker 환경 테스트입니다.');

        INSERT INTO BOARD (TITLE, CONTENT)
        VALUES ('두 번째 게시글', '샘플 데이터입니다.');

        INSERT INTO BOARD (TITLE, CONTENT)
        VALUES ('세 번째 게시글', 'CLOB 컬럼 테스트.');

        COMMIT;
    END IF;
END;
/

DECLARE
    v_total_count   NUMBER;
    v_batch_size    NUMBER := 1000;   -- 커밋 단위
    v_limit         NUMBER := 50000;  -- 생성 건수 (조절 가능)
BEGIN
    -- 현재 데이터 개수 확인
    SELECT COUNT(*) INTO v_total_count FROM BOARD;

    IF v_total_count < v_limit THEN
        FOR i IN 1 .. v_limit LOOP
            INSERT INTO BOARD (TITLE, CONTENT)
            VALUES (
                '테스트 게시글 ' || i,
                RPAD('락 테스트용 대량 데이터 ', 2000, '*')
            );

            -- 배치 커밋
            IF MOD(i, v_batch_size) = 0 THEN
                COMMIT;
            END IF;
        END LOOP;

        COMMIT;
    END IF;
END;
/