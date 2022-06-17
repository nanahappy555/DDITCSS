2022-0511-01) EXCEPTION
SET SERVEROUTPUT ON;
--콘솔창에 DBMS결과를 출력하기 위한 코드
/*
오라클 스케줄러 사용하기!

스케줄러란?
- 특정한 시간이 되면 자동적으로 질의(query)명령이 실행되도록 하는 방법
*/
SELECT *
FROM   MEMBER
WHERE  MEM_ID = 'a001';

UPDATE MEMBER
SET    MEM_MILEAGE = MEM_MILEAGE + 10
WHERE  MEM_ID = 'a001';
/
SELECT MEM_ID, MEM_MILEAGE
FROM   MEMBER
WHERE  MEM_ID = 'a001';
/
EXEC USP_UP_MEMBER_MIL;
/
--PROCEDURE로 만들기
CREATE OR REPLACE PROCEDURE USP_UP_MEMBER_MIL
IS
BEGIN
    UPDATE MEMBER
    SET    MEM_MILEAGE = MEM_MILEAGE + 10
    WHERE  MEM_ID = 'a001';
END;
/

--스케쥴 생성 (익명블록)
DECLARE
    --스케줄JOB의 고유한 아이디. 임의의 숫자
    V_JOB NUMBER(5);
BEGIN
    DBMS_JOB.SUBMIT(
        V_JOB, --JOB아이디
        'USP_UP_MEMBER_MIL;', --실행할 PROCEDURE 작업
        SYSDATE, --최초 작업을 실행할 시간
        'SYSDATE + (1/1440)', --1분마다
        FALSE --파싱(구문분석, 의미분석)여부
    );
    DBMS_OUTPUT.PUT_LINE('JOB_IS ' || TO_CHAR(V_JOB));
    COMMIT;
END;
/

--스케줄러에 등록된 작업을 조회
SELECT * FROM USER_JOBS;
/
--스케줄러에서 작업 삭제
BEGIN
    DBMS_JOB.REMOVE(1);
END;
/    
SELECT SYSDATE,
       TO_CHAR(SYSDATE + (1/1440),'YYYY-MM-DD HH24:MI:SS'), --1분 뒤
       TO_CHAR(SYSDATE + (1/24),'YYYY-MM-DD HH24:MI:SS'), --한시간 뒤
       TO_CHAR(SYSDATE + 1,'YYYY-MM-DD HH24:MI:SS') --1일 뒤
FROM   DUAL;       
/

/*
EXCEPTION
 - PL/SQL에서 ERROR가 발생하면 EXCEPTION이 발생되고
  해당블록을 중지하며 예외처리부분으로 이동함
예외유형
 - 정의된 예외
   PL/SQL에서 자주 발생하는 ERROR를 미리 정의함
   선언할 필요가 없고 서버에서 암시적으로 발생함
   1) NO_DATA_FOUND : 결과없음
   2) TOO_MANY_ROWS : 여러행 리턴
   3) DUP_VAL_ON_INDEX : 데이터 중복 오류 (P.K/U.K)
   4) VALUE_ERROR : 값 할당 및 변환 시 오류
   5) INVALID_NUMBER : 숫자로 변환이 안됨 EX)TO_NUMBER('개똥이') 
   6) NOT_LOGGED_ON : DB에 접속이 안되었는데 실행
   7) LOGIN_DENIED : 잘못된 사용자 / 잘못된 비밀번호
   8) ZERO_DIVIDE : 0으로 나눔
   9) INVALID_CURSOR : 열리지 않은 커서에 접근
   
 - 정의되지 않은 예외
   기타 표준 ERROR
   선언을 해야 하며 서버에서 일시적으로 발생
 
 - 사용자 정의 예외
   프로그래머가 정한 조건에 만족하지 않을 경우 발생
   선언을 해야 하고, 명시적으로 RAISE문을 사용하여 발생
*/
/--DBMS결과를 콘솔창에 출력하는 명령
SET SERVEROUTPUT ON;
/
DECLARE
    V_NAME VARCHAR2(20);
BEGIN
    SELECT LPROD_NM + 10 INTO V_NAME
    FROM   LPROD
    WHERE  LPROD_GU = 'P201';
    dbms_output.put_line('분류형: ' || V_NAME);
    
    EXCEPTION --NO_DATE_FOUND 너무 자주 발생하는 오류라 이름을 정해둠
        WHEN NO_DATA_FOUND THEN --ORA-01403
             DBMS_OUTPUT.put_line('해당 정보가 없습니다.');
        WHEN TOO_MANY_ROWS THEN--TOO_MANY_ROWS ORA-01422
             DBMS_OUTPUT.put_line('한개 이상의 값이 나왔습니다.');     
        WHEN OTHERS THEN     
             DBMS_OUTPUT.put_line('기타 에러 : ' || SQLERRM);    --SQLERRM 에러메세지
    
END;
/

--정의되지 않은 예외
DECLARE
    --EXCEPTION 타입의 exp_reference 변수 선언
    exp_reference EXCEPTION;
    --EXCEPTION_INIT를 통해 예외이름과 오류번호를 컴파일러에게 등록함
    PRAGMA EXCEPTION_INIT(exp_reference, -2292);
BEGIN
    --ORA-02292 오류 발생
    --
    DELETE FROM LPROD WHERE LPROD_GU='P101';
    DBMS_OUTPUT.PUT_LINE('분류 삭제');
    EXCEPTION
        WHEN exp_reference THEN
            DBMS_OUTPUT.PUT_LINE('삭제 불가');
END;
/

SELECT *
FROM   USER_CONSTRAINTS
WHERE  CONSTRAINT_NAME = 'FR_BUYER_LGU';
/
-----------------------------------------------------------------------------------------

--사용자 정의 예외

--블록지정 후 스크립트 실행 아이콘
ACCEPT p_lgu PROMPT '등록하려는 분류코드 입력:' --프롬프트(입력창)로 받은 값이 p_lgu변수로 들어감
DECLARE
    --EXCEPTION 타입의 exp_reference 변수 선언
    exp_lprod_gu EXCEPTION;
    v_lgu VARCHAR2(10) := UPPER('&p_lgu'); --주소로 찾아감 => 프롬프트에 입력한 'p101'로 치환됨 => UPPER로 대문자 P101로 변환
BEGIN
    DBMS_OUTPUT.PUT_LINE(V_LGU || '는 등록 가능');
END;

--p_lgu : CPU가 메모리를 찾아갈 때 주소로 찾아가는 경우가 있고 p_lgu이름으로 찾아가는 경우가 있다
--&p_lgu는 주소로 찾아가는 것
/

--P101이 이미 있어서 등록 못하게 막아야겠어!!!!!!!!!!! --오라클 시스템 오류가 아님
SELECT LPROD_GU FROM LPROD;
/
ACCEPT p_lgu PROMPT '등록하려는 분류코드 입력:' 
DECLARE
    --EXCEPTION 타입의 exp_reference 변수 선언
    exp_lprod_gu EXCEPTION;
    v_lgu VARCHAR2(10) := UPPER('&p_lgu'); 
BEGIN
    IF v_lgu IN ('P101', 'P102', 'P201', 'P202') THEN --v_lgu가 IN (괄호 안)에 들어있는 값들 중 하나라도 일치하면
        --실행부에서 RAISE문장으로 명시적으로 exp_lprod_gu라는 EXCEPTION을 발생함
        RAISE exp_lprod_gu;
    END IF;
    DBMS_OUTPUT.PUT_LINE(V_LGU || '는 등록 가능');
    
    EXCEPTION
        WHEN exp_lprod_gu THEN
            DBMS_OUTPUT.PUT_LINE(v_lgu  || '는 이미 등록된 코드입니다.');
END;

/
Q. v_lgu라는 변수를 왜 선언해야할까?
1.
ACCEPT p_lgu PROMPT '등록하려는 분류코드 입력:' => DECLARE 밖에 있어서 DECLARE안에서 p_lgu라는 변수를 인식하지 못함
&p_lgu라는 주소를 사용하려면 반드시 v_lgu라는 변수를 선언해야함

2. v_lgu를 선언하지 않고 UPPER('&p_lgu')를 계속 사용하면 정상적으로 실행됨
ACCEPT p_lgu PROMPT '등록하려는 분류코드 입력:' 
DECLARE
    --EXCEPTION 타입의 exp_reference 변수 선언
    exp_lprod_gu EXCEPTION;
    --v_lgu VARCHAR2(10) := UPPER('&p_lgu'); 변수를 선언하지 않고 해보려고 주석처리!
BEGIN
    IF UPPER('&p_lgu') IN ('P101', 'P102', 'P201', 'P202') THEN --v_lgu가 IN (괄호 안)에 들어있는 값들 중 하나라도 일치하면
        --실행부에서 RAISE문장으로 명시적으로 exp_lprod_gu라는 EXCEPTION을 발생함
        RAISE exp_lprod_gu;
    END IF;
    DBMS_OUTPUT.PUT_LINE(UPPER('&p_lgu') || '는 등록 가능');
    
    EXCEPTION
        WHEN exp_lprod_gu THEN
            DBMS_OUTPUT.PUT_LINE(UPPER('&p_lgu')  || '는 이미 등록된 코드입니다.');
END;
/
---------------------------------------------------------------------------------
사용예)
1)
--DEPARTMENT 테이블에 학과코드를 '컴공',
--학과명을 '컴퓨터공학과', 전화번호를 '765-4100'
--으로 INSERT해보자
INSERT INTO DEPARTMENT(DEPT_ID, DEPT_NAME, DEPT_TEL)
    VALUES('컴공', '컴퓨터공학과', '765-4100');
    
2)
--constraint
오류 보고 -
ORA-00001: unique constraint (LHR91.DEPARTMENT_PK) violated
--오류에 있는 DEPARTMENT의 PK를 확인 => 이미 있는 id
SELECT *
FROM   USER_CONSTRAINTS
WHERE  CONSTRAINT_NAME = 'DEPARTMENT_PK';

3) EXCEPTION처리
--
/
DECLARE
BEGIN
    INSERT INTO DEPARTMENT(DEPT_ID, DEPT_NAME, DEPT_TEL)
    VALUES('컴공', '컴퓨터공학과', '765-4100');
    COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.put_line('<중복된 인덱스 예외 발생!>');
        WHEN OTHERS THEN --그 외 오류
            NULL;
END;
/
---------------------------------------------------------------------------------
사용예)
COURSE 테이블의 과목코드가 'L1031'에 대하여
추가 수강료(COURSE_FEES)를 '삼만원'으로 수정해보자
[숫자형 데이터타입의 오류 발생]
1.확인 먼저
    SELECT COURSE_ID,
           COURSE_FEES
    FROM   COURSE
    WHERE COURSE_ID = 'L1031';
2. 업데이트쎄대여  =>   ORA-01722: invalid number (숫자로 변환이 안됨)
    UPDATE COURSE
    SET COURSE_FEES = '삼만원'
    WHERE COURSE_ID = 'L1031';
/
DECLARE
BEGIN
    UPDATE COURSE
    SET COURSE_FEES = '삼만원'
    WHERE COURSE_ID = 'L1031';
    COMMIT;
    EXCEPTION
        WHEN invalid_number THEN
            DBMS_OUTPUT.PUT_LINE('<잘못된 숫자 예외 발생!>');
        WHEN OTHERS THEN
            NULL;
END;
/

----------------------------------------------------------------------------------
사용예) SG_SCORES 테이블에 저장된 SCORE 컬럼의 점수가
100점이 초과되는 값이 있는지 조사하는 블록을 작성해보자
단, 100점 초과시 OVER_SCORE 예외를 선언해보자
[사용자 정의 예외로 처리해보자]

0. 100점을 초과하는 컬럼 추가
/
INSERT INTO SG_SCORES(STUDENT_ID, COURSE_ID, SCORE, SCORE_ASSIGNED)
VALUES('A1701','L0013',107,'2010/12/29');
/
1. 점수를 확인하는 SELECT문
/
SELECT STUDENT_ID, COURSE_ID, SCORE, SCORE_ASSIGNED
FROM SG_SCORES
WHERE SCORE > 100;
/
2.
--반복문을 사용하여 SCORE가 100을 초과하면
--그 SCORE값을 V_SCORE변수에 넣고
--RAISE OVER_SCORE;를 수행함[예외메세지 : 107점으로 100점을 초과합니다]
-----

-----내가 푼 거
--결과는 105하나만 나옴
/
DECLARE
    OVER_SCORE EXCEPTION;
    V_SCORE SG_SCORES.SCORE%TYPE;
BEGIN 
    FOR V_ROW IN (SELECT T.SCORE 
                    FROM (SELECT SCORE
                            FROM SG_SCORES
                           WHERE SCORE > 100) T
    ) LOOP
        IF V_ROW.SCORE > 100 THEN
        RAISE OVER_SCORE;
        END IF;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('100점을 초과하지 않습니다');
    EXCEPTION 
        WHEN OVER_SCORE THEN
            DBMS_OUTPUT.PUT_LINE('100점을 초과합니다');
END;
