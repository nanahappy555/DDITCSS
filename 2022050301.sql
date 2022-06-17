2022-0503-01) PL/SQL(Procedual Language SQL) --지금까지는 구조적
  - 표준 spl을 확장 --한계점보완
  - 절차적 언어의 특징을 포함(비교, 반복, 변수, 상수 등)
  - 미리 구성된 모듈을 컴파일하여 서버에 저장하고 필요시 호출실행 --미리 특정한 결과를 반환/출력할 수 있는 모듈을 미리 만들어둠
  - 모듈화/캡슐화
  - Anonymous Block, Stored Procedure, User Defined Function, Trigger, Package 등이 제공됨
  --Anonymous Block: 익명블록. 저장X->호출X. 1회성. PL/SQL의 가장 기본적인
  --Stored Procedure: 흔히 Procedure프로시저 라고 함. 함수와 같이 공부해야됨. 자바의 VOID가 Procedure. 반환값이 없으면 독립실행
  --User Defined Function: 사용자가 자기의 업무에 맞는 결과를 내보내기 위해 사용자가 만들어둔 함수. 자바의 반환타입메서드
  --Trigger: 자동호출실행
  --Package: 작은 프로젝트 할때는X 선언부와 실행부(BODY)가 분리되어있음.
  --문제점
  --표준적인 문법x 각 DBMS마다 문법이 다름. (표준 SQL은 ANSI가 있음)
  --별도의 메모리 필요
  
1. Anonymous Block 익명블록 
  - 가장 기본적인 pl/sql 구조 제공
  - 선언영역과 실행영역으로 구분
  - 저장되지 않음 --다시 불러쓸 수 있는 컴파일된 코드가 저장X 계속 재실행 시켜야됨.
  (사용형식)
    DECLARE
     선언부(1변수,2상수,3커서 선언) -- 1~3만 올 수 있음
    BEGIN
     실행부(비지니스 로직 처리를 위한 SQL문) --지금까지 한 SQL명령
     [EXCEPTION  --
        예외처리부
     ]
    END;

사용예)충남에 거주하는 회원들이 2020년 5월 구매실적을 조회하시오. --충남에 거주 회원-커서
--변수는 한번에 하나만 저장됨.
--표준SQL에서는 SELECT FROM WHERE // PL/SQL에서는 SELECT INTO FROM WHERE
--SELECT는 여러 행을 출력. 변수는 한번에 하나만 저장되기 때문에 저장할수없음
--차례대로 저장하려고(사용목적0
--커서=뷰
--출력OPEN 출력끝나면 CLOSE
--커서를 쓰면 한줄씩 꺼내읽기 가능
변수 : VARIABLE  이름 : V_...
매개변수 : PARAMETER 이름 : P_...
    DECLARE --변수선언
    V_MID MEMBER.MEM_ID%TYPE; --회원번호
    V_MNAME MEMBER.MEM_NAME%TYPE; --회원이름
    V_AMT NUMBER:=0;  --구매금액합계
    CURSOR CUR_MEM IS --커서가 한줄씩 읽어온다 ==VIEW와 같음 SELECT문의 결과=CURSOR
      SELECT MEM_ID,MEM_NAME        --3행2열이 나옴. 3사람의 두가지 컬럼
        FROM MEMBER
       WHERE MEM_ADD1 LIKE '충남%';
  BEGIN
    OPEN CUR_MEM; --커서를 열어
    LOOP --반복. 3명이니까 3번 반복
      FETCH CUR_MEM INTO V_MID, V_MNAME;  --커서를 읽어오는 명령 FETCH. CUR_MEM을 불러와서 INTO에 저장 V_MID, V_MNAME
      EXIT WHEN CUR_MEM%NOTFOUND; -- EXIT WHEN 언제까지 읽어올 것인가? CUR_MEM%NOTFOUND 자료가 없을때까지 NOT FOUND까지 NOT FOUND가 TRUE면 EXIT
      SELECT SUM(B.PROD_PRICE*A.CART_QTY) INTO V_AMT --자료가 있을 때.  SELECT에서 나온 결과는 3개인데  INTO로 받으려면 1개밖에 못받음. 그래서 CURSOR를 써야함
        FROM CART A, PROD B
       WHERE A.CART_PROD=B.PROD_ID
         AND A.CART_NO LIKE '202005%'
         AND A.CART_MEMBER=V_MID;
        DBMS_OUTPUT.PUT_LINE('회원번호 : '||V_MID);  --자바의 SYSO와 비슷
        DBMS_OUTPUT.PUT_LINE('회원명 : '||V_MNAME);
        DBMS_OUTPUT.PUT_LINE('구매합계 : '||V_AMT);
        DBMS_OUTPUT.PUT_LINE('--------------------');
    END LOOP;  --3번 반복하고 CURSOR NOTFOUND가 TRUE가 되어서 CLOSE로 종료
    CLOSE CUR_MEM;
  END;
  
  1)변수와 상수
   - BEGIN ~ END 블록에서 사용할 변수 및 상수 선언
   (선언형식)
   변수명  [CONSTANT] 데이터타입|참조타입 [:=초기값]; --CONSTANT를 쓰면 상수 안쓰면 변수
   . 변수의 종류
    - SCLAR 변수 : 하나의 값을 저장하는 일반적 변수
    - 참조형 변수 : 해당 테이블의 행(ROW)나 컬럼(COLUMN)의 타입과 크기를 참조하는 변수 --한 행 전체를 참조
    - BIND변수 : 파라미터로 넘겨지는 값을전달하기 위한 변수 --매개변수PARAMETER 
그냥이렇게외우장   --변수가 NUMBER 타입인 경우 초기화시킨다.
그냥이렇게외우장    --상수인 경우 초기화시킨다
   . 상수 선언은 CONSTANT 예약어를 사용하며 이때 반드시 초기값을 설정해야 함 --자바의 FINAL
   . 데이터 타입
     - SQL에서 사용하는 자료타입
     - PLS_INTEGER, BINARY_INTEGER -> 4 byte 정수 --자바의 INT -21억~21억 너무 작아서 잘 안씀
     - BOOLEAN 사용 가능  --잘..안..씀... 오라클의 BOOLEAN에서는 TURE, FALSE, NULL을 저장
   . 숫자형 변수는 사용전 반드시 초기화
   . 참조형
    - 열참조 : 테이블명.컬럼명%TYPE --해당테이블의 해당열과 똑같은 타입,크기로 변수지정
    --가지고 와야할 데이터는 그 열의 타입과 크기를 알고 있으니 내가 안열어봐도됨.
    - 행참조 : 테이블명%ROWTYPE
    --한 행에 여러개의 열 존재. 그 열을 

사용예)키보드로 년도와 월을 입력 받아 해당 기간동안 가장 많은 매익금액을 기록한 상품을 매입정보를 조회하시오.
1.키보드로 년도와 월을 입력받아 --ACCEPT == 자바의 SCANNER 
    ACCEPT P_PERIOD PROMPT '기간(년도/월) 입력 : '  --세미콜론 X
    --입력된 값이 자동으로 내 쿼리 안에 들어와 P_PERIOD 변수에 '문자열'로 저장됨
    
    ACCEPT P_PERIOD PROMPT '기간(년도/월) 입력 : ' --일이 없으니까 일을 추가해줘야
    DECLARE --S_DATE(시작일 START) E_DATE(종료일 END) 
      S_DATE DATE := TO_DATE(&P_PERIOD||'01'); --시작일자 // &P_PERIOD **키보드로 입력받은 P_PERIOD ** 의 값을 꺼내오는 문법
      E_DATE DATE := LAST_DAY(S_DATE);
    BEGIN
      dbms_output.put_line(S_DATE);
    END;
    
2.해당 기간동안 가장 많은 매익금액을 기록한 상품
    ACCEPT P_PERIOD PROMPT '기간(년도/월) 입력 : ' --일이 없으니까 일을 추가해줘야
    DECLARE --S_DATE(시작일 START) E_DATE(종료일 END) 
      S_DATE DATE := TO_DATE(&P_PERIOD||'01'); --시작일자 // &P_PERIOD **키보드로 입력받은 P_PERIOD ** 의 값을 꺼내오는 문법
      E_DATE DATE := LAST_DAY(S_DATE);
      V_PID PROD.PROD_ID%TYPE;  --PROD_ID의 타입과 크기를 모르지만 PROD테이블의 PROD_ID열을 참조하면 됨
      V_PNAME PROD.PROD_NAME%TYPE;
      V_AMT NUMBER :=0; --숫자는 초기화.....
    BEGIN
      SELECT TA.BID, TA.BNAME, TA.BSUM INTO V_PID, V_PNAME, V_AMT --이렇게 할당하세요
        FROM (SELECT B.BUY_PROD AS BID, 
                     A.PROD_NAME AS BNAME, 
                     SUM(A.PROD_COST*B.BUY_QTY) AS BSUM
                FROM PROD A, BUYPROD B
               WHERE B.BUY_DATE BETWEEN S_DATE AND E_DATE
                 AND A.PROD_ID=B.BUY_PROD
               GROUP BY B.BUY_PROD, A.PROD_NAME
               ORDER BY 3 DESC) TA
       WHERE ROWNUM=1; --제일 많은 금액 하나니까 ROWNUM이 1번인거만 뽑으면 됨. --ROWNUM을 ()안에 쓰면 실행순서 때문에 1선택해서 합을 구하는거라 아무 의미없게됨           
       DBMS_OUTPUT.PUT_LINE('제품코드 : '|| V_PID);
       DBMS_OUTPUT.PUT_LINE('제품명 : '|| V_PNAME);
       DBMS_OUTPUT.PUT_LINE('매입금액합계 : '|| V_AMT);
       
    END;
    

   --난수
사용예)임의의 부서코드를 선택하여 해당부서에 가장 먼저 입사한 사원정보를 조회하시오.
      Alias는 사원번호,사원명,부서명,직무코드,입사일
    DECLARE
      V_EID HR.employees.EMPLOYEE_ID%TYPE;
      V_ENAME HR.employees.EMP_NAME%TYPE;
      V_DNAME HR.departments.DEPARTMENT_NAME%TYPE;
      V_JOBID HR.employees.JOB_ID%TYPE;
      V_HDATE DATE;
      V_DID HR.employees.DEPARTMENT_ID%TYPE:=TRUNC(dbms_random.value(10,110),-1); --임의로 생성한 부서코드가 들어감
    BEGIN
      SELECT TA.EID, TA.ENAME, TA.DNAME, TA.JID, TA.HDATE 
        INTO V_EID, V_ENAME, V_DNAME, V_JOBID, V_HDATE
        FROM (SELECT A.EMPLOYEE_ID AS EID,
                     A.EMP_NAME AS ENAME,
                     B.DEPARTMENT_NAME AS DNAME,
                     A.JOB_ID AS JID,
                     A.HIRE_DATE AS HDATE
                FROM HR.employees A, HR.departments B
               WHERE A.DEPARTMENT_ID=V_DID
                 AND A.DEPARTMENT_ID=B.DEPARTMENT_ID
               ORDER BY 5 ) TA
       WHERE ROWNUM=1;         
        DBMS_OUTPUT.PUT_LINE('사원번호 : '||V_EID);
        DBMS_OUTPUT.PUT_LINE('사원명 : '||V_ENAME);
        DBMS_OUTPUT.PUT_LINE('부서명 : '||V_DNAME);
        DBMS_OUTPUT.PUT_LINE('직무코드 : '||V_JOBID);
        DBMS_OUTPUT.PUT_LINE('입사일 : '||V_HDATE);
    END;
    
    난수
      TRUNC(dbms_random.value(10,110),-1) --(초기값,최소값) 10~110에서 랜덤값 10 11 12 13 14 이렇게 나오니까 10단위로 나오게 TRUNC함수 (ASDF,-1) 1자리 버릴것