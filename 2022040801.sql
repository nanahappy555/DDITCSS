2022-0408-01)
사용예)사원테이블(HR계정 EMPLOYEES테이블)에서 모든 사원의 급여를
     15% 인상하여 변경하시오.
     
COMMIT;     
ROLLBACK;

    SELECT FIRST_NAME, SALARY
        FROM HR.employees;
        
    UPDATE HR.employees
        SET SALARY=SALARY+ROUND(SALARY*0.15); --SET 변경대상의 컬럼명 ROUND 반올림? 모든 사원이니까 WHERE절 필요X
        
4. DELETE 명령 --부모는 마음대로 UPDATE DELETE 불가능. 자식이 쓰고 있어서ㅠㅠ -> 자식먼저 업데이트 이후 부모 업데이트 혹은 자식DEL,부모DEL
    - 불필요한 자료를 테이블에서 삭제
    (사용형식)
    DELETE FROM 테이블명 --행 단위로 삭제되는거라 컬럼명이 필요없음. 테이블은 남아있고 내용물만 삭제됨.
     [WHERE 조건] --조건절이 생략되면 모든 행이 삭제됨

사용예)
--    DELETE FROM PROD; --PROD테이블을 사용하는 자식 테이블이 존재해서 삭제되지 않음.
    DELETE FROM CARTS; --카트의 행 전부 삭제됨
    ROLLBACK;  --되돌림
     
5. 오라클 데이터타입
    - 오라클 문자 데이터 타입은 존재하지않음
    - 문자열, 숫자, 날짜, 2진 데이터타입 제공
    1) 문자열 자료형
     - 오라클의 문자열 자료는 ' '에 기술
     - 문자열 자료형은 CHAR, VARCHAR, VARCHAR2, NVARCHAR, NVARCHAR2, --CHAR외에는 다 가변길이 CHAR VARCHAR2 CLOB만 씀
     LONG, CLOB, NCLOB등이 제공 -- LONG은 이제 안씀 CLOB캐릭터라지오브젝트 를 씀
     (1) CHAR
        . 고정길이 문자열 자료 저장
        . 최대 2000byte 까지 저장가능 --한글 666자까지. 
        . 기억공간이 남으면 오른쪽 공간에 공백이 pedding, 기억공간이 적으면 error --PEDDING 삽입
        . 기본키나 고정된 자료(주민번호 등)저장에 주로 사용 --키값이 고정이니까
        (사용예)
        컬럼명 CHAR(크기[byte|char]) --생략하면 BYTE  |내려놓음바 파이프기호 둘 중 하나 선택할 수 있다는 뜻 byte바이트수 char글자수
         . '크기[byte|char]' : '크기'로 지정된 값이 byte인지 char(글자수)인지를 결정. 생략하면 byte로 간주) --default는 byte다
         . 한글 한글자는 3byte에 저장되며 CHAR(2000CHAR)로 선언되었다 할지라도 전체 공간은 2000BYTE를 초과할 수 없음 --한글은 초/중/종성 각각 1BYTE차지함
사용예)
    CREATE TABLE TEMP01(
        COL1 CHAR(20),          --20byte
        COL2 CHAR(20 BYTE),     --20byte
        COL3 CHAR(20 CHAR));    --20char
        
    INSERT INTO TEMP01 VALUES('대전시 중구','대전시 중구','대전시 중구');
    
    SELECT * FROM TEMP01;
    
    SELECT LENGTHB(COL1), --LENGTH BYTE 길이를 BYTE로 나타내시오
           LENGTHB(COL2),
           LENGTHB(COL3) --30BYTE로 나오는 이유= (한글5글자15BYTE+공백1BYTE) 16BYTE + (20CHAR-6CHAR(공백포함)=14CHAR=14BYTE) = 30BYTE
      FROM TEMP01;       
         
     (2) VARCHAR2
        . 가변길이 문자열 자료를 저장 (데이터의 길이만큼 사용하고 남는공간은 반납)
        . 최대 4000byte까지 저장 가능 --한글 1334글자
        . VARCHAR와 동일 기능
        . NVARCHAR 및 NVARCHAR2는 국제 표준코드인 UTF-8, UTF-16방식으로 데이터를 인코딩하여 저장
    (사용형식)
        컬럼명 VARCHAR2(크기[BYTE|CHAR]) --생략하면 BYTE로 간주
    (사용예)
        CREATE TABLE TEMP02(
            COL1 VARCHAR2(100),
            COL2 VARCHAR2(100 BYTE),
            COL3 VARCHAR2(100 CHAR),
            COL4 CHAR(100));
            
        INSERT INTO TEMP02
            VALUES('IL POSTINO', 'IL POSTINO', 'IL POSTINO', 'IL POSTINO');
        
        SELECT * FROM TEMP02;
        
     (3) LONG --(지금까지 만들어 둔 자료가 있으니)실행은 되는데 개선 중단됨. 
        . 가변길이 데이터 저장
        . 최대 2GB 까지 저장 가능
        . 한 테이블에 하나의 LONG타입 컬럼만 사용 --이거때문에 안쓰게됐음.
        . CLOB(Character Large OBjects)로 기능 업그레이드 됨 --LARGE OBJECTS 대용량
        . SELECT 문의 SELECT 절, UPDATE 문의 SET 절, INSERT 문의 VALUES 절에서 사용 가능
        . 일부 함수에서는 사용될 수 없음
    (사용형식)
     컬럼명 LONG
    (사용예)
     CREATE TABLE TEMP03(   --LONG컬럼은 한테이블에 하나만 쓸 수 있는데 LONG이 두개라 오류발생
      COL1 LONG,
      COL2 VARCHAR2(4000));
      
    INSERT INTO TEMP03 
        VALUES('BANNA APPLE PERSIMMON','BANNA APPLE PERSIMMON');
        
    SELECT * FROM TEMP03;    
    
    SELECT SUBSTR(COL2,7,5) --SUBSTR 서브스트링 7번째글자부터 5글자
        FROM TEMP03;  --LONG타입은 너무 커서 서브스트링을 판단하기가 어려움
        
     (4) CLOB
        . 가변길이 데이터 저장
        . 최대 4GB까지 처리 가능
        . 한 테이블에 여러 개의 CLOB자료타입의 컬럼 사용 가능
        . 일부 기능은 DBMS_LOB API의 지원을 받아야 사용 가능 
    (사용형식)
     컬럼명 CLOG;
    (사용예)
     CREATE TABLE TEMP04(
        COL1 LONG,
        COL2 CLOB,
        COL3 CLOB,
        COL4 VARCHAR2(4000));
        
    INSERT INTO TEMP04
        VALUES ('','대전시 중구 계룡로 846','대전시 중구 계룡로 846','대전시 중구 계룡로 846'); --''=NULL
        
    SELECT * FROM TEMP04;    
    
    SELECT DBMS_LOB.GETLENGTH(COL2), --
            DBMS_LOB.GETLENGTH(COL3),--CLOB는 최대 4GB라 BYTE가 너무 커서 LENGTHB로는 X. 글자수 체크는 가능하다
            LENGTHB(COL4) --VARCHAR2는 BYTE체크 가능
      FROM TEMP04;    
      
    SELECT SUBSTR(COL2,5,2), --중구
            DBMS_LOB.SUBSTR(COL2,5,2),--전시 중구
            SUBSTR(COL4,5,2) --중구
      FROM TEMP04; 