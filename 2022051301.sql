2022-0513-01)생성된 테이블(tbl_good, customer)에 자료 삽입

|상품정보|
|---|---|---|
|상품번호|이름|가격|
|p101|진라면|1200|
|p102|신라면|1500|
|p103|두부|2500|
|p104|김치(200g)|1750|

INSERT INTO TBL_GOOD VALUES('p101','진라면',1200);
INSERT INTO TBL_GOOD VALUES('p102','신라면',1500);
INSERT INTO TBL_GOOD VALUES('p103','두부',2500);
INSERT INTO TBL_GOOD VALUES('p104','김치(200g)',1750);
SELECT * FROM TBL_GOOD;
COMMIT;

|고객정보|
|---|---|---|
|고객번호|이름|주소|
|2201|이진우|서울시 성북구 장위동 100|
|2210|장유진|대전시 대덕구 대덕대로 1555|
|2205|손두진|청주시 청원구 강내 102|
INSERT INTO CUSTOMER VALUES('2201','이진우','서울시 성북구 장위동 100');
INSERT INTO CUSTOMER VALUES('2210','장유진','대전시 대덕구 대덕대로 1555');
INSERT INTO CUSTOMER VALUES('2205','손두진','청주시 청원구 강내 102');
SELECT * FROM CUSTOMER;
COMMIT;

사용예)회원이 상품을 구매할 경우 구매상품(ORDER_GOOD)테이블에 구매정보가 기록되어야 한다.
이때 구매테이블의 내용(AMOUNT)이 자동으로 갱신될 수 있는 트리거를 작성하시오.
--ORDER수량*단가
--사용자가 로그인하면 주문테이블이 한줄이 자동으로 들어가야됨
--그럼 필요한 것은? 주문번호. 내가 타이핑할 수 없음.
--주문번호 생성함수를 만들면 됨. 프로시저는 반환값이 없어 적절하지 않음
--주문번호 생성 -> 구매상품에 담으면 구매번호도 따라와야함

프로시저와 함수의 사용처 차이
+ SELECT, WHERE절에서 써야될 것은 함수로 (함수는 반환데이터가 있음. 반환데이터를 사용함)
+ 프로시저는 독립적으로 실행. EXEC
OUT매개변수를 사용하면 변수를 선언해서 써야됨=>다른 블록에서 변수를 만들어주고 

1)주문번호 생성함수 --완벽하지 않으니 나중에 참고하자
CREATE OR REPLACE FUNCTION FN_CREATE_ORDER_NUMBER
--매개변수가 필요없어서 매개변수 생략
    --반환되는 데이터 타입
    RETURN NUMBER
IS  --변수선언
    V_ONUM TBL_ORDER.ORDERNUM%TYPE; --생성할 주문번호
    V_FLAG NUMBER:=0; --오늘날짜에 로그인한 회원의 수를 셀 플레그 변수 
BEGIN
    --1.오늘 날짜로 주문을 한 회원이 있는지 확인
    SELECT COUNT(*) --주문을 한 회원 세어보기
      FROM TBL_ORDER
     WHERE TRUNC(ODATE)=TRUNC(SYSDATE); --ODATE(시분초까지 저장됐음)와 SYSDATE가 시간이 안맞아서 시간을 삭제함
         --TO_CHAR(ODATE,'YYYYMMDD')=TO_CHAR(SYSDATE,'YYYYMMDD'); --날짜가 오늘날짜와 같은 날짜인 조건
    --2. 세어본 뒤 IF에 따라 결과 출력 
    IF V_FLAG=0 THEN --접속고객0명- 오늘 날짜를 YYYYMMDD형식으로 바꾸어서 001을 붙임 (카트번호)
        V_ONUM :=TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDD')||TRIM('001'));
    ELSE --접속고객 있으면 -  오늘 날짜 자료중에(WHERE) 가장 큰 주문번호에 1을 더해서 V_ONUM에 만들어라
        SELECT MAX(ORDERNUM)+1 INTO V_ONUM
          FROM TBL_ORDER
         WHERE ODATE=SYSDATE;
    END IF;
    --실제 반환하는 데이터
    RETURN V_ONUM;
END;
/

1-2) 데이터를 넣어보자 --INSERT UPDATE DELETE한 뒤 COMMIT 해줘야 여러명이서 할 때 문제가 안생김.
INSERT INTO TBL_ORDER VALUES (20220513003,SYSDATE,20000,'2210'); 
COMMIT;

SELECT FN_CREATE_ORDER_NUMBER FROM DUAL;
--------------------------------------
**의사레코드**

ORDER_GOOD에 자료 2개가 삽입
:NEW --삽입된 자료를 가르키는 의사레코드
ex) :NEW.GOOD_ID --삽입된 자료의 상품번호
첫번째 줄 읽고 자동으로 두번째 줄로  넘어감
:NEW는 INSERT와 UPDATE가 발생했을 때만 유효

EMPLOYEE에서 퇴사처리할 사원을 삭제할 때
:OLD --기존의 자료를 가르키는 의사레코드
ex) :OLD.EMPLOYEE_ID --퇴사처리할 사원의 아이디
:OLD는 DELETE와 UPDATE가 발생했을 때만 유효 (삭제할 자료를 가르키거나, 업뎃할 자료를 가르킬 때)


--------------------------------------
2)트리거 생성
구매상품 테이블에 INSERT가 발생하면 AFTER 구매 테이블에 금액 UPDATE
CREATE OR REPLACE TRIGGER TG_UPDATE_ORDER
    AFTER INSERT ON ORDER_GOOD --타이밍
    FOR EACH ROW
DECLARE
    V_GID tbl_good.good_id%TYPE; --상품코드
    V_AMT NUMBER:=0; --단가 * 수량 곱해서 잠깐 보관할 변수
    V_PRICE NUMBER:=0; --해당상품의 단가
BEGIN --트리거 본문(ORDER_GOOD에 INSERT된 후 AMOUNT를 업데이트 하기)
    V_GID:=(:NEW.GOOD_ID); --새롭게 입력되는 값을 변수 V_GID에 넣음
    
    SELECT GOOD_PRICE INTO V_PRICE --상품테이블에서 판매가를 찾아서 V_PRICE에 넣음
      FROM TBL_GOOD
     WHERE GOOD_ID=V_GID;
     
    V_AMT:=V_PRICE*(:NEW.ORDER_QTY); --V_PRICE와 새로 삽입된 구매물건의 수량을 곱해서 구매금액산출
    
    UPDATE TBL_ORDER
       SET AMOUNT=AMOUNT+V_AMT --여러상품을 구매하기 때문에 기존AMOUNT에 단일상품의 금액을 추가해야됨
     WHERE ORDERNUM=(:NEW.ORDERNUM);--구매번호가 같으면 AMOUNT 업데이트
     --트리거 커밋/롤백 X
END;

3)테스트 --아까 만들어둔 함수를 사용
'손두진'접속
INSERT INTO TBL_ORDER
VALUES (FN_CREATE_ORDER_NUMBER,SYSDATE,0,'2205'); --FN_CREATE_ORDER_NUMBER : 만들어 둔 함수 호출
COMMIT;

4)신라면 5개, 김치 2개 구입
INSERT INTO ORDER_GOOD
프로시저를 만드는 이유?
트리거는 사이클이 발생하고,
프로시저 아니면 다른 테이블에 있는 데이터를 내 테이블에서 쓸 방법이 조인뿐임
조인으로 얻은 값은 보관할 방법이 없어서 프로시저씀.
/
--오더넘버를 찾으려면 CID를 알아야 됨 (CID에 해당하는 오더넘버를 찾기 위해)
CREATE OR REPLACE PROCEDURE PROC_INSERT_ORDER
(P_CID IN CUSTOMER.CID%TYPE, P_GID IN tbl_good.good_id%TYPE, P_SU IN NUMBER)
IS
    V_ORDER_NUM tbl_order.ordernum%TYPE;
BEGIN --고객번호와 날짜가 같았을 때 고객에게 부여된 주문번호를 찾아라
    SELECT T.ORDERNUM INTO V_ORDER_NUM
      FROM TBL_ORDER
     WHERE TRUNC(ODATE)=TRUNC(SYSDATE) 
       AND CID=P_CID;
       
    INSERT INTO ORDER_GOOD
        VALUES (P_GID,V_ORDER_NUM,P_SU);
    COMMIT;    
END;
/
EXEC PROC_INSERT_ORDER('2205','p102',5); --라면 삼
EXEC PROC_INSERT_ORDER('2205','p104',2);
/
Q. BEGIN에서 주문번호를 찾는데
고객이 여러번 접속했으면 주문번호가 여러개라 다중행이 되니까 오류가 남
제일 마지막 주문번호(정렬해서 ROWNUM 1)만 쓰면 됨 ->BEGIN에 서브쿼리

/1.서브쿼리작성/
SELECT T.ORDERNUM INTO V_ORDER_NUM
  FROM (SELECT ORDERNUM,
               CID
          FROM TLB_ORDER
         WHERE TRUNC(ODATE)=TRUNC(SYSDATE)
           AND CID='2210'
         ORDER BY 1 DESC ) T
 WHERE ROWNUM=1;
/2.결합/
CREATE OR REPLACE PROCEDURE PROC_INSERT_ORDER
(P_CID IN CUSTOMER.CID%TYPE, P_GID IN tbl_good.good_id%TYPE, P_SU IN NUMBER)
IS
    V_ORDER_NUM tbl_order.ordernum%TYPE;
BEGIN
    SELECT T.ORDERNUM INTO V_ORDER_NUM
      FROM (SELECT ORDERNUM,
                   CID
              FROM TLB_ORDER
             WHERE TRUNC(ODATE)=TRUNC(SYSDATE)
               AND CID='2210'
             ORDER BY 1 DESC ) T
     WHERE ROWNUM=1
       AND TRUNC(ODATE)=TRUNC(SYSDATE) 
       AND CID=P_CID;
       
    INSERT INTO ORDER_GOOD
        VALUES (P_GID,V_ORDER_NUM,P_SU);
    COMMIT;    
END;
/