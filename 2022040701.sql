2022-0407-
1. DML 명령
    1. 테이블 생성명령(CREATE TABLE)
    - 오라클에서 사용될 테이블을 생성
    (사용형식)
    CREATE TABLE 테이블명(
        컬럼명 데이터 타입[(크기)] [NOT NULL] [DEFAULT 값] [,]
                 :
        컬럼명 데이터 타입[(크기)] [NOT NULL] [DEFAULT 값] [,]
         [CONSTRAINT 기본키인덱스명 PRIMARY KEY(컬럼명[,컬럼명,...]) [,]]
         [CONSTRAINT 외래키인덱스명 FOREIGN KEY(컬럼명[,컬럼명,...])
            REFERENCES 테이블명(컬럼명[,컬럼명,...])[,]]
         [CONSTRAINT 외래키인덱스명 FOREIGN KEY(컬럼명[,컬럼명,...])
            REFERENCES 테이블명(컬럼명[,컬럼명,...])[,]];
        . '테이블명', 컬럼명, 인덱스명 : 사용자정의단어를 사용
        . 'NOT NULL'이 기술된 컬럼은 데이터 삽입시 생략 불가능
        . 'DEFAULT 값' :사용자가 데이터를 입력하지 않은 경우 자동으로 삽입되는 값
        . '기본키인덱스명','외래키인덱스명','테이블명'은 중복되어서는 안됨
        . '테이블명(컬럼명[,컬럼명,...])[,]]': 부모테이블명 및 부모테이블에서 사용된 컬럼명
    
 사용예)테이블명세1의 테이블들을 생성하시오.
 
    CREATE TABLE GOODS(
        GOOD_ID CHAR(4) NOT NULL, --기본키, NOT NULL 생략가능
        GOOD_NAME VARCHAR2(50),
        PRICE NUMBER(8),
        CONSTRAINT pk_goods PRIMARY KEY(GOOD_ID));
        
    CREATE TABLE CUSTS(
        CUST_ID CHAR(4) NOT NULL,
        CUST_NAME VARCHAR2(50),
        ADDRESS VARCHAR2(100),
        CONSTRAINT PK_CUSTS PRIMARY KEY(CUST_ID));
        
    CREATE TABLE ORDERS(
        ORDER_ID CHAR(11),
        ORDER_DATE DATE DEFAULT SYSDATE, --디폴트값을 입력하지 않으면 자동으로 시스템 날짜 입력됨
        CUST_ID CHAR(4),
        ORDER_AMT NUMBER(10) DEFAULT 0, --사용자가 입력하지 않으면 0으로 들어감
        CONSTRAINT PK_ORDER PRIMARY KEY(ORDER_ID), --기본키 PK_ORDER(이름)는 컬럼ORDER_ID
        CONSTRAINT FK_ORDER_CUST FOREIGN KEY(CUST_ID) --외래키 FK_ORDER_CUST(이름)는 컬럼CUST_ID
            REFERENCES CUSTS(CUST_ID)); --부모테이블 CUSTS의 컬럼CUST_ID를 참조해서 자식테이블 ORDERS의 컬럼CUST_ID를 생성
            
    CREATE TABLE GOOD_ORDERS(
        ORDER_ID CHAR(11),
        GOOD_ID CHAR(4),
        ORDER_QTY NUMBER(3),
        CONSTRAINT PK_GORD PRIMARY KEY(ORDER_ID,GOOD_ID),
        CONSTRAINT FK_GORD_ORDER FOREIGN KEY(ORDER_ID)
            REFERENCES ORDERS(ORDER_ID),
        CONSTRAINT FK_GORD_GOODS FOREIGN KEY(GOOD_ID)
            REFERENCES GOODS(GOOD_ID)); --FK_GORD_ORDER와 FK_GORD_GOOD는 참조하는 부모테이블이 달라서 따로 써줌
            
2. INSERT 명령
    - 생성된 테이블에 새로운 자료를 입력
    (사용형식)
        INSERT INTO 테이블명[(컬럼명[,컬럼명,...])]
            VALUES(값1[,값2,...]);
        . '테이블명[(컬럼명[,컬럼명,...])]'; '컬럼명'이 생략되고 테이블명만 기술되면
          테이블의 모든 컬럼에 입력될 데이터를 순서에 맞추어 기술해야함(갯수 및 순서 일치)
        . '(컬럼명[,컬럼명,...])':입력할 데이터에 해당하는 컬럼만 기술, 
          단, NOT NULL 컬럼은 생략 할 수 없음 --NULLABLE : YES(=NOT NULL)
          
사용예)다음 자료를 GOODS테이블에 저장하시오
     상품코드    상품명     가격
-------------------------------------
        P101     볼펜     500
        P102    마우스  15000
        P103    연필      300
        P104   지우개    1000
        P201   A4용지   7000
        
    INSERT INTO GOODS VALUES('p101','볼펜',500); --행 삽입
    INSERT INTO GOODS(good_id,GOOD_NAME,PRICE)
        VALUES('p102','마우스',15000);
    INSERT INTO GOODS(good_id,GOOD_NAME,PRICE)
        VALUES('p103','연필',300);
        

        
    SELECT * FROM GOODS; --행이 제대로 삽입됐는지 확인
    
사용예)고객테이블(CUSTS)에 다음자료를 입력하시오
    고객번호    고객명 주소
-----------------------------------
    a001     홍길동    대전시 중구 계룡로 846
    a002     이인수    서울시 성북구 장위1동 66
    
    INSERT INTO CUSTS VALUES('a001','홍길동','대전시 중구 계룡로 846');
    INSERT INTO CUSTS(CUST_ID, ADDRESS)
        VALUES('a001','서울시 성북구 장위1동 66');
    INSERT INTO CUSTS(CUST_ID, ADDRESS)
        VALUES('a001','홍길동','서울시 성북구 장위1동 66'); --컬럼명 갯수보다 값의 갯수가 더 많음
    INSERT INTO CUSTS(CUST_ID, ADDRESS)
        VALUES('a001', '서울시 성북구 장위1동 66'); --기본키가 중복됐음
    
    SELECT * FROM CUSTS;
    
사용예)오늘 홍길동 고객이 로그인 했을 경우 주문테이블에 해당 사항을 입력하시오 --ORDER_ID 11자리, CUST_ID 4자리
     INSERT INTO ORDERS(ORDER_ID,CUST_ID)     
        VALUES('20220407001','a001');
        
    SELECT * FROM ORDERS;    
    
사용예)오늘 홍길동 고객이 다음과 같이 구매했을 때 구매상품테이블(GOOD_ORDER)에 자료를 저장하시오.
        구매번호       상품번호     수량
    -----------------------------------
        20220407001     p101    5
        20220407001     p102    10
        20220407001     p103    2
        
    INSERT INTO GOOD_ORDERS
        VALUES('20220407001','p101',5);
    INSERT INTO GOOD_ORDERS    
        VALUES('20220407001','P102',10);
    INSERT INTO GOOD_ORDERS
        VALUES('20220407001','P103',2);   
        
    UPDATE GOODS
       SET PRICE=15000
    WHERE GOOD_ID='P102';
        
    UPDATE ORDERS
        SET ORDER_AMT=ORDER_AMT+(SELECT ORDER_QTY*PRICE  --이전금액과 합계가 되어야함
                                 FROM GOOD_ORDERS A, GOODS B
                                 WHERE A.GOOD_ID=B.GOOD_ID
                                 AND ORDER_ID='20220407001')
                                 AND A.GOOD_ID='p103')
        WHERE ORDER_ID='20220407001';     
        
        SELECT * FROM ORDERS;
        SELECT * FROM GOOD_ORDERS; --모든 열(*)을 모든 행(WHERE관련)과 출력하라
        UPDATE ORDERS
            SET ORDER_AMT=0;
        
3. UPDATE 명령 
    - 이미 테이블에 존재하는 자료를 수정할 때 사용 --이미 존재하는 자료 변경
    (사용형식)
    UPDATE 테이블명
       SET 컬럼명=값[,]
           컬럼명=값[,]     
              :
           컬럼명=값[,]
    [WHERE 조건];       --그 테이블의 행에 관련. WHERE을 안쓰면 모든 행을 변경해버림
    
 --1. 확인을 위해 필요한 데이터만 출력하기    
    SELECT PROD_NAME AS 상품명, --PROD_NAME을 상품명이라고 할것이다
           PROD_COST AS 매입단가 -- ~ 매입단가라고 할거이다
    FROM PROD;  --(여기까지는)PROD테이블에 상품명과 매입단가라 이름 붙은 모든 행을 출력하세요
    
 --2. UPDATE를 이용해서 자료 수정    
사용예) 상품테이블에서 분료코드가 'P101'에 속한 상품의 매입가격을 10%인상하시오.
    UPDATE PROD
       SET PROD_COST=PROD_COST+ROUND(PROD_COST*0.1)
       WHERE PROD_LGU='P101';  --LGU분류코드  -> 분류코드가 p101인 6개 행만 업데이트 

    ROLLBACK; --