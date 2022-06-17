2022-0502-02) 
2. SEQUENCE
  - 연속적으로 증가(또는 감소)되는 값을 반환하는 객체
  - 특정 테이블에 종속되지 않음 
  - 기본키로 설정할 특정 항목이 없는 경우 주로 사용 --인조키 (MEM_ID인조키 주민등록번호기본키. 근데 주민번호를 기본키로 쓸 수 없으니까 인조키를 만드는것)
   (사용형식)
   CREATE SEQUENCE 시퀀스명  --시퀀스명은 보통 SEQ_로 시작
     [START WITH n]  -- 시작값 n부터 생성 // 생략하면 초기값 MINVALUE, 초기값을 생략하면 1
     [INCREMENT BY n] --증가 감소값(n), 양수 증가, 음수 감소
     [MAXVALUE n|NOMAXVALUE] --최종값 설정, 기본은 NOMAXVALUE이며 10^27
     [MINVALUE n|NOMINVALUE] --최소값 설정, 기본은 NOMINVALUE이며 값은 1임
     [CYCLE|NOCYCLE] : --최종/최소 값까지 도달한 후 다시 생성할지 여부(기본은 NOCYCLE이며 1임)  //다시만들면 CYCLE 다시안만들면 NOCYCLE(기본)
     [CACHE n|NOCACHE] : --생성된 순서값을 캐쉬메모리에 저장할 것인지 여부, 기본은 CACHE 20(20개만들어놓고쓴다.계속 20개만)  //CACHE=주기억장치와CPU사이의고속의작은메모리
     [ORDER|NOORDER] : --정의된대로 생성의 보장여부, 기본은 NOORDER //명령. 보증조건이 없는경우 NOORDER
     
 ** 시퀀스 사용이 제한되는 곳
  . SELECT, UPDATE, DELETE 문의 SUBQUERY
  . VIEW 를 대상으로하는 QUERY
  . DISTINCT 가 사용된 SELECT 문
  . GROUP BY, ORDER BY절이 사용된 SELECT 문
  . 집합연산자에 사용된 SELECT 문
  . SELECT 문의 WHERE 절
  
  . INSERT 문 VALUES 절에 보통 사용
 ** 시퀀스에 사용되는 의사컬럼
   시퀀스명.CURRVAL   : 시퀀스객체의 현재값 -- 현재값을 참조하세요 과거의 값은 참조불가능    커런트벨류
   시퀀스명.NEXTVAL   : 시퀀스객체의 다음값 -- 다음값을 생성하세요
   ** 시퀀스가 생성되고 첫 번째 수행해야할 명령은 반드시 NEXTVAL --처음 CURRVAL를 하면 아무값도안나옴 주소값만 가지고 있음.  1. NEXTVAL, 2.CURRVAL 하고나면 CURR결과는 초기값이 나옴
   --여러사람이 같이 사용하면 잘못될수있음.
   --과거값은 참조불가능해서 NEXTVAL를 막 쓰면 현재값을 못구할수이씀 NEXTVAL는 한군데서만 해야됨...
   
   DROP 시퀀스 시퀀스명 --시퀀스 삭제
사용예)분류테이블에 사용할 시퀀스를 생성하시오
      시작값은 10이고 1씩 증가해야함
    CREATE SEQUENCE SEQ_LPROD
     START WITH 10;
     
    SELECT SEQ_LPROD.CURRVAL FROM DUAL;  --테이블이 불필요     
    --sequence CURRVAL has been selected before sequence NEXTVAL
    --정의가 되어있지않은 값이다. 시퀀스를 생성 후 처음은 NEXTVAL을 써야됨
    SELECT SEQ_LPROD.NEXTVAL FROM DUAL;
    SELECT SEQ_LPROD.CURRVAL FROM DUAL; -- 10
    SELECT SEQ_LPROD.NEXTVAL FROM DUAL; -- 11  다시 10을 가져오고싶으면? REPLACE를 할 수 없으니까 시퀀스를 삭제해야됨
    
    DROP SEQUENCE SEQ_LPROD;

사용예) 다음자료를 분류테이블에 저장하시오
    [자료]
     LPROD_ID    LPROD_GU    LPROD_NM
   ---------------------------------------
    시퀀스사용       P501        농산물
    시퀀스사용       P502        수산물
    시퀀스사용       P503        임산물    
    
    INSERT INTO LPROD
      VALUES(SEQ_LPROD.NEXTVAL, 'P501', '농산물'); --10
    INSERT INTO LPROD
      VALUES(SEQ_LPROD.NEXTVAL, 'P502', '수산물');  --11
    INSERT INTO LPROD
      VALUES(SEQ_LPROD.NEXTVAL, 'P503', '임산물');  --12  


3. SYNONYM(동의어) --테이블/컬럼 별칭(AS)과 다른 점: 효과를 발휘하는 범위 AS는 해당쿼리에서만 적용되고 해당쿼리를 벗어나면 안쓰임
    - 오라클에서 사용되는 객체에 부여한 또 다른 이름   --사용자 테이블 인덱스 등등 다 사용가능. 어디에서나 쓸 수 있음.
    - 긴 객체명이나 사용하기 어려운 객체명을 사용하기 쉽고 기억하기 쉬운 이름으로 사용
    --EX) HR.employees -> EMP
    (사용형식)    
    CREATE OR REPLACE SYNONYM 별칭 FOR 객체명;
     . '객체명'을 '별칭'으로 또 다른 이름 부여

사용예)HR게정의 사원테이블과 부서테이블을 EMP, DEPT로 별칭(동의어)을 부여하시오.
    CREATE OR REPLACE SYNONYM EMP FOR HR.employees; --원래 이름도 쓰고 별칭(동의어)도 쓴다
    
    SELECT * FROM EMP;
    
    CREATE OR REPLACE SYNONYM DEPT FOR HR.departments;
    
    SELECT * FROM DEPT;
    
4. INDEX
  - 테이블에 저장된 자료를 효율적으로 검색하기위한 기술
  - 오라클서버는 사용자로부터 검색명령이 입력되면 전체를 대상으로 검색(FULL SCAN)할지 또는 인덱스스캔(INDEX SCAN)을 할지 결정함
  - 인덱스가 필요한 컬럼 --컬럼마다 다 인덱스를 만들어두면 찾는건 빠르지만... 인덱스는 계속변경됨. 데이터삽입삭제업데이트가 발생되면 인덱스가 계속 최신상태로 유지하기 위해 재구성됨. 여기에 시간이 많이 걸림.
   . 자주 검색하는 컬럼
   . WHERE 절에서 '='연산자로 특정 자료를 검색할 경우
   . 기본키 --기본키는 사용자가 기본키를 설정하면 자동으로 인덱스가 만들어짐
   . SORT(ORDER BY)나 JOIN연산에 자주 사용되는 컬럼
   --기본키 두개가 쓰인 복합키로 인덱스를 이용할때는 기본키를 두개 다 써야됨
  - 인덱스의 종류
   . Unique / Non-unique  -- 유니크:인덱스로 만드는 값이 유일한 값 EX)기본키 NULL도 데이터로 취급해서 1번허용(기본키는NULL비허용) / 논-유니크:중복허용
   . Single / Composite  --인덱스1개 / 2개이상 COMPOSITE
   . Normal / Bitmap / Function-Based 
   --노말이 가장 
   --노말:일반적인 B-TREE Balance tree 양쪽DEPTH가 같?비슷?/ 인덱스가 만들어지는데 동원된 컬럼의 값과 컬럼이 저장된 ROW ID(물리적값)으로 주소가 만들어짐
   --비트맵: BIT BINARY MAPPING 컬럼의 값과 ROW ID값에 대응되는 2진수로 만든다
   --펑션-베이스드(함수기반인덱스): 인덱스를 구성하는 컬럼에 펑션이 사용됏을경우(SUBSTR,TRIM...등) 그 함수를 그대로 사용해서 검색하는 것이 가장 빠르고 효율적
   
   (사용형식) --다 생략하면 Normal
    CREATE [UNIQUE|BITMAP] INDEX 인덱스명
     ON 테이블(컬럼명[,컬럼명...] [ASC|DESC]);
    . 'ASC|DESC' : 오름차순 또는 내림차순으로 인덱스 생성
                    기본은 ASC

사용예)
    CREATE INDEX IDX_MEM_NAME
      ON MEMBER(MEM_NAME); --멤버테이블의 이름컬럼으로 인덱스 생성
      
    SELECT * FROM MEMBER
     WHERE MEM_NAME='육평회'; --지금은 데이터가 적어서 인덱스 유무의 시간차가 너무 미미하다 0.001초 차이
    
    DROP INDEX IDX_MEM_NAME; --인덱스 삭제     
    
    COMMIT;
    DB튜닝 - 시간이 지나고도 빠르게만들어줌 돈이 많이 듦....
    
사용예)
    CREATE INDEX IDX_PROD     
      ON PROD(SUBSTR(PROD_ID,1,5)||SUBSTR(PROD_ID,9)); --1번째에서 5글자와, 9번째부터 나머지 다
    --함수기반 인덱스를 사용할 때는 함수를 그대로 사용해서 검색하는 것이 가장 빠르고 효율적
    SELECT * FROM PROD
     WHERE SUBSTR(PROD_ID,1,5)||SUBSTR(PROD_ID,9)='P202013'

 ** 인덱스의 재구성**   --자동으로 재구성되기까지 일정 텀이 지나야 자동 실행되는데 그걸 기다리기 싫을 때 하는 명령
  - 인덱스를 다른 테이블스페이스로 이동시키는 경우
  - 데이터테이블이 이동된 경우
  - 삽입삭제가 다수 발생된 직후
    ALTER 인덱스명 REBUILD;