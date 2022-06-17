2022-0411-01)
 ** 숫자형 자료의 표현 범위 : 1.0E130 ~ 9.999..99 E-125
 
 ** 정밀도<스케일인 경우
    . 희귀한 경우
    . 정밀도 : 0이 아닌 유효숫자의 갯수
    . 스케일 - 정밀도 : 소숫점 이후에 존재해야할 '0'의 갯수
    사용예)
    -------------------------------------------------
    입력값      선언           기억되는 값            
    -------------------------------------------
    0.2345  NUMBER(4,5)      오류  --5-4=1 
    1.2345  NUMBER(3,5)        오류 정밀도 0이 아닌 유효숫자 5개인데 3개 적혀있어서 틀림
    0.0345  NUMBER(3,4)        0.0345 유효숫자3개 4-3=1 0의 갯수 1개 
    0.0026789  NUMBER(3,5)     0.00268 유효숫자3개??
    
 4. 날짜 타입 --크기 지정X
  - 날짜 및 시간에 관한 자료 저장 (년,월,일,시,분,초)
  - 덧셈과 뺄셈을 대상이 될 수 있음
  - DATE, TIMESTAMP타입이 제공됨
  (1) DATE 타입
    . 표준 날짜타입
    (사용형식)
    컬럼명 DATE
    
    (사용예)
    CREATE TABLE TEMP05(
    COL1 DATE,
    COL2 DATE,
    COL3 DATE);
    ** SYSDATE 함수 : 시스템이 제공하는 날짜자료 제공
    INSERT INTO TEMP05 VALUES(SYSDATE,SYSDATE-30, TO_DATE('20190411')+365); --TO_DATE주어진 문자열을 날짜로 바꾸시오.형식에 맞춰야 변환됨(YYYYMMDD)
    SELECT * FROM TEMP05; --시간은 저장됐으나 표현이 안 된 상태
    
    SELECT TO_CHAR(COL1, 'YYYYMMDD HH24:MI:SS') AS 컬럼1,
           TO_CHAR(COL2, 'YYYYMMDD HH24:MI:SS') AS 컬럼2,
           TO_CHAR(COL3, 'YYYYMMDD HH24:MI:SS') AS 컬럼3
    FROM TEMP05;      
    
    ** 날짜자료 - 날짜자료 => 경과된 일수 출력 --MOD 나머지를 구하는 함수 trunc(DT)시간절사
    SELECT MOD((TRUNC(SYSDATE) - (TO_DATE('00010101'))-1),7)  
    FROM DUAL; --00010101 서기1년1월1일 -1하는 이유 오늘 날짜 안지났으니까/ 7로 나눠서 나머지가 1이면 월요일
               --테이블은 프롬절에 작성해야하는데, 이 경우 특정 테이블을 불러오는게 아니라서 DUAL가상테이블 이용해서 SELECT절만 연산하는 것임
    
  (2) TIMESTAMP 타입
    . 시간대역(TIME ZONE 정보) 정보 제공
    . 아주 정교한 시간정보(10억분의 1초) 제목
    (사용형식)
     컬럼명 TIMESTAMP --시간대역 정보 없음
     컬럼명 TIMESTAMP WITH TIME ZONE --시간대역 정보 포함
     컬럼명 TIMESTAMP WITH LOCAL TIME ZONE --로컬서버가 설치된 시간대역정보로 TIMESTAMP와 같이 시간대역 정보 없음
     (사용예)
     CREATE TABLE TEMP06(
        COL1 TIMESTAMP,
        COL2 TIMESTAMP WITH TIME ZONE,
        COL3 TIMESTAMP WITH LOCAL TIME ZONE);
        
    INSERT INTO TEMP06 VALUES(SYSDATE,SYSDATE,SYSDATE);
    SELECT * FROM TEMP06;
    
 5. 이진자료 타입
    - BLOB, BFILE, RAW, 등이 제공됨
    
    (1)RAW
        . 비교적 적은 규모의 이진자료 저장
        . 인덱스 처리 가능
        . 오라클에서 데이터 해석이나 변환을 제공하지 않음 --다른 응용프로그램에서 변환해야함
        . 최대 2000BYTE까지 저장 가능 --용량작음
        . 16진수와 2진수 저장 가능 --16진법ABCDEF
    (사용형식)
     컬럼명 RAW(크기)
    (사용예)
    CREATE TABLE TEMP07(
        COL1 RAW(1000),
        COL2 RAW(1000));
        
    INSERT INTO TEMP07
        VALUES(HEXTORAW('A5FC'),'1010010111111100'); --1010 A 0101 5 1111 F 1100 C
    SELECT * FROM TEMP07;

    (2)BFILE
        . 이진자료 저장
        . 원본파일은 데이터베이스 밖에 저장하고 데이터베이스에는 경로(Path)만 저장
        . 경로 객체(DIRECTORY) 필요
        . 4GB까지 저장 가능
    (사용형식)
     컬럼명 BFILE
      - 디렉토리 객체의 별칭(Alias)는 30BYTE, 파일명은 256BYTE까지 가능
    **그림파일 저장순서
     0)테이블 생성
      CREATE TABLE TEMP08(
        COL1 BFILE);
        
     1)그림파일 저장
      
     2)디렉토리객체 생성 --경로,파일명 절대경로 C:\\ , 상대경로 .나 ..부모
      CREATE DIRECTORY 디렉토리별칭  AS '절대경로';
      CREATE DIRECTORY TEST_DIR   AS 'D:\WORK\Oracle';
      
     3)데이터 삽입
      INSERT INTO TEMP08 
        VALUES(BFILENAME('TEST_DIR', 'sample.jpg')); --BFILENAME함수
        
     SELECT * FROM TEMP08;    

    (3)BLOB
        . 이진자료 저장
        . 원본 이진자료를 데이터테이블 안에 저장
        . 4GB까지 저장 가능
    (사용형식)
     컬럼명 BLOB
     
    **그림파일 저장순서
     0)테이블생성
      CREATE TABLE TEMP09(
        COL1 BLOB);
        
     1)익명블록(PL/SQL)작성 PL절차적언어/SQL
      DECLARE  --선언부
       L_DIR VARCHAR2(20):='TEST_DIR';
       L_FILE VARCHAR2(30):='sample.jpg';
       L_BFILE BFILE;
       L_BLOB BLOB;
      BEGIN  
       INSERT INTO TEMP09(COL1) VALUES(EMPTY_BLOB()) --EMPTY로 컬럼 지움
            RETURN COL1 INTO L_BLOB; --L_BLOB 값을 COL1에 할당하라
       L_BFILE:=BFILENAME(L_DIR,L_FILE);    
       DBMS_LOB.FILEOPEN(L_BFILE,DBMS_LOB.FILE_READONLY); --B_FILE에 있는 데이터를 READONLY로 열어라
       DBMS_LOB.LOADFROMFILE(L_BLOB,L_BFILE,DBMS_LOB.GETLENGTH(L_BFILE)); --B_FILE이 가지고 잇는 길이를 정해서 B_FILE에 있는 데이터를 꺼내 BOLB=DB안에저장
       DBMS_LOB.FILECLOSE(L_BFILE);
        
      COMMIT;
     END;
     
     SELECT * FROM TEMP09;
     
 DROP TABLE TEMP01;
 DROP TABLE TEMP02;
 DROP TABLE TEMP03;
 DROP TABLE TEMP04;
 DROP TABLE TEMP05;
 DROP TABLE TEMP06;
 DROP TABLE TEMP07;
 DROP TABLE TEMP08;
 DROP TABLE TEMP09;

 DROP TABLE GOOD_ORDERS;
 DROP TABLE ORDERS;
 DROP TABLE GOODS;
 
 DROP TABLE CUSTS;
 
 COMMIT;