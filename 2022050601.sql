2022-0506-01)CURSOR문
--2005년도 및 상품별 총 입고수량을 출력하는 커서
SET SERVEROUTPUT ON;
--콘솔창에 DBMS결과를 출력하기 위한 코드

DECLARE
    --SCALAR일반변수
    V_BUY_PROD VARCHAR2(10);
    V_QTY NUMBER(10);
    --2020년도 상품별 매입수량의 합
    CURSOR CUR IS --셀렉한 뷰에 이름붙이기
    SELECT BUY_PROD, SUM(BUY_QTY)
      FROM BUYPROD
     WHERE BUY_DATE LIKE '2020%' --% WILDCARD
     GROUP BY BUY_PROD
     ORDER BY BUY_PROD;
BEGIN
    --메모리 할당(올라감) = 바인드
    OPEN CUR;
    --페따출 페치:이동하고 따:커서에 있는지 없는지 따지고 출:출력한다
    --다음 행으로 이동, 행이 존재하는지 체크
    --페
    FETCH CUR INTO V_BUY_PROD, V_QTY; --한번쓸때마다 이동
    --따(FOUND:데이터존재? / NOTFOUND:데이터없는지? / ROWCOUNT : 행의 수)
    WHILE(CUR%FOUND) LOOP
        DBMS_OUTPUT.PUT_LINE(V_BUY_PROD ||', ' || V_QTY);--출
        FETCH CUR INTO V_BUY_PROD, V_QTY;--페 ('따'로돌아감
    END LOOP;    
    --사용중인메모리반환(필수)
    CLOSE CUR;
END; 
    
--회원테이블에서 회원명과 마일리지를 출력해보자
--단, 직업이 '주부'인 회원만 출력하고 회원명으로 오름차순 정렬해보자
--ALIAS: MEM_NAME, MEM_MILEAGE

    SELECT MEM_NAME, MEM_MILEAGE
      FROM MEMBER
     WHERE MEM_JOB='주부'
     ORDER BY MEM_NAME;
     
--CUR이름의 CURSOR를 정의하고 익명블록으로 표현해보자
/
DECLARE     
    V_NAME MEMBER.MEM_NAME%TYPE; --REFERENCE변수
    V_MILE NUMBER(10); --SCALAR변수
    CURSOR CUR IS
        SELECT MEM_NAME, MEM_MILEAGE
          FROM MEMBER
         WHERE MEM_JOB='주부'
         ORDER BY MEM_NAME;     
BEGIN
    OPEN CUR;
    LOOP
        FETCH CUR INTO V_NAME, V_MILE; --페
        EXIT WHEN CUR%NOTFOUND; --따 ( CUR데이터가 없어지면 종료)
        DBMS_OUTPUT.PUT_LINE(CUR%ROWCOUNT || ', ' || V_NAME || ', ' || V_MILE); --출
    END LOOP;
    CLOSE CUR;

END;
/


/
DECLARE     
    V_NAME MEMBER.MEM_NAME%TYPE; --REFERENCE변수
    V_MILE NUMBER(10); --SCALAR변수
    CURSOR CUR(V_JOB VARCHAR2) IS --매개변수로 받음
        SELECT MEM_NAME, MEM_MILEAGE
          FROM MEMBER
         WHERE MEM_JOB = V_JOB
         ORDER BY MEM_NAME;     
BEGIN
    OPEN CUR('주부'); --매개변수 던짐
    LOOP
        FETCH CUR INTO V_NAME, V_MILE; --페
        EXIT WHEN CUR%NOTFOUND; --따 ( CUR데이터가 NOTFOUND면 종료)
        DBMS_OUTPUT.PUT_LINE(CUR%ROWCOUNT || ', ' || V_NAME || ', ' || V_MILE); --출
    END LOOP;
    CLOSE CUR;

END;
/

--직업을 입력받아서 FOR LOOP를 이용하는 CURSOR
/
DECLARE     
    CURSOR CUR(V_JOB VARCHAR2) IS --매개변수로 받음
        SELECT MEM_NAME, MEM_MILEAGE
          FROM MEMBER
         WHERE MEM_JOB = V_JOB
         ORDER BY MEM_NAME;     
BEGIN
    --FOR LOOP
    --FOR문으로 반복하는 동안 커서를 *자동으로 OPEN*하고
    --모든 행이 처리되면 *자동으로 커서를 CLOSE*함
    --REC : 자동선언 묵시적 변수
    FOR REC IN CUR('학생') LOOP
        DBMS_OUTPUT.PUT_LINE(CUR%ROWCOUNT || ', ' || REC.MEM_NAME || ', ' || REC.MEM_MILEAGE);
    END LOOP;

END;
/

/--서브쿼리를 이용해서 처리

BEGIN
    --FOR LOOP
    --FOR문으로 반복하는 동안 커서를 *자동으로 OPEN*하고
    --모든 행이 처리되면 *자동으로 커서를 CLOSE*함
    --REC : 자동선언 묵시적 변수
    FOR REC IN (SELECT MEM_NAME, MEM_MILEAGE
                  FROM MEMBER
                 WHERE MEM_JOB = '학생'
                 ORDER BY MEM_NAME) LOOP
        DBMS_OUTPUT.PUT_LINE(REC.MEM_NAME || ', ' || REC.MEM_MILEAGE);
    END LOOP;

END;
/

--CURSOR문제
--2020년도 회원별 판매금액(판매가*구매수량)의 합계
--CURSOR와 FOR문을 통해 출력해보자
--ALIAS : MEM_ID, MEM_NAME, SUM_AMT
--출력예시 : a001, 김은대, 2000
--          b001, 이쁜이, 1750
--                  :
(오라클 일반조인)
     SELECT A.MEM_ID,
            A.MEM_NAME,
            SUM(C.PROD_SALE * B.CART_QTY) AS OUT_AMT
       FROM MEMBER A, CART B, PROD C
      WHERE CART_NO LIKE '2020%'
        AND A.MEM_ID = B.CART_MEMBER --내부조인
        AND B.CART_PROD = C.PROD_ID
      GROUP BY A.MEM_ID, A.MEM_NAME
      ORDER BY 1;
      
 (ANSI INNER JOIN)
     SELECT A.MEM_ID, A.MEM_NAME, SUM(C.PROD_SALE * B.CART_QTY) AS OUT_AMT
       FROM PROD C
      INNER JOIN CART B ON (B.CART_PROD = C.PROD_ID)
      INNER JOIN MEMBER A ON (A.MEM_ID = B.CART_MEMBER)
      WHERE  B.CART_NO LIKE '2020%'
      GROUP BY A.MEM_ID, A.MEM_NAME
      ORDER BY 1;
      
 /
 DECLARE
    CURSOR CUR IS
        SELECT A.MEM_ID, A.MEM_NAME, SUM(C.PROD_SALE * B.CART_QTY) AS SUM_AMT
           FROM CART B
                 INNER JOIN PROD C ON (B.CART_PROD = C.PROD_ID)
                 INNER JOIN MEMBER A ON (A.MEM_ID = B.CART_MEMBER)
          WHERE  B.CART_NO LIKE '2020%'
          GROUP BY A.MEM_ID, A.MEM_NAME
          ORDER BY 1;
 BEGIN --FOR문에서 OPEN CLOSE는 필요없음
    FOR REC IN CUR LOOP
        IF MOD(CUR%ROWCOUNT,2) = 1 THEN --홀수만
        dbms_output.put_line(CUR%ROWCOUNT || ', ' || REC.MEM_ID || ', ' || REC.MEM_NAME || ', ' || REC.SUM_AMT);
        END IF; --IF문 닫기
    END LOOP;
 END;
 /
 
 
1. Stored procedure
 --STORED(오라클 서버의 캐시공간에 미리 저장된) PROCEDURE
 --업데이트 쎄대여 업데이트는 강력하다 몇만명을 빠르게 실행가능
 1)업데이트문사용
 1-1)원하는 데이터 확인
 --확인부터 하고 업데이트해야됨
 SELECT PROD_ID, PROD_TOTALSTOCK
 FROM PROD
 WHERE PROD_ID = 'P101000001';
 1-2)직접 업데이트 --위험!
 --업데이트
 UPDATE PROD
 --쎄
 SET PROD_TOTALSTOCK = PROD_TOTALSTOCK + 10
 --대여
 WHERE PROD_ID = 'P101000001';
 
 2)PROCEDURE 이용
 2-1) PROCEDURE생성
 /--PROCEDURE은 실행이 아니라 컴파일 해서 서버의 캐쉬공간에 넣어주는 것. 업데이트 되지 않음
CREATE OR REPLACE PROCEDURE USP_PROD_TOTALSTOCK_UPDATE --REPLACE:PROCEDURE재정의
IS
BEGIN
    UPDATE PROD
    SET PROD_TOTALSTOCK = PROD_TOTALSTOCK + 10
    WHERE PROD_ID = 'P101000001';
    DBMS_OUTPUT.put_line('업데이트 성공!');
    COMMIT;
END;
 /
 2-2)EXCU실행
--EXECUTE USP_PROD_TOTALSTOCK_UPDATE;  
--PROCEDURE 실행문구 프로시저에 만들어놨다가 익스큐트를 실행해야 테이블에 데이터가 들어감
EXEC USP_PROD_TOTALSTOCK_UPDATE;
/
2-3)SELECT문을 통해 결과 확인
 SELECT PROD_ID, PROD_TOTALSTOCK
 FROM PROD
 WHERE PROD_ID = 'P101000001';


