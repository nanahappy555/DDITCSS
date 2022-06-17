2022-0504-01)-- FOR 제일 많이 씀
2.반복문 --LOOP,WHILE은 횟수모를때 FOR은 횟수와 조건을 다 알 때
  - LOOP, WHILE, FOR문이 제공됨 --WHILE과 FOR문은 모두 LOOP문을 가지고 있다
  - 주로 커서를 사용하기 위하여 반복문이 필요 --WHILE은 조건이 맞으면 반복 LOOP문은 조건이 맞으면 반복종료
  1) LOOP
   . 기본적인 반복문으로 *무한루프* 제공
   (사용형식)
   LOOP
     반복처리문;
     [EXIT WHEN 조건;] --자바의 BREAK와 같은 역할
   END LOOP;
   - '조건'이 참일때 반복문을 벗어남(END LOOP 다음 명령 수행)

사용예)구구단의 6단을 출력하시오.
    DECLARE
      V_CNT NUMBER:=1;
    BEGIN
      LOOP
        dbms_output.put_line('6 * '||V_CNT||' = '||(6*V_CNT); --6*1 = 6 으로 출려
        EXIT WHEN V_CNT >= 9;
        V_CNT:=V_CNT+1;
      END LOOP;
    END;      
    
사용예)사원테이블에서 직무코드가 'SA_REP'인 사원정보를 익명블록을 사용하여 출력하시오 
     출력할 내용은 사원번호,사원명,입사일이다. --출력할 내용은 변수로 써야됨
     --아래 두줄은 커서(뷰)에 들어갈 내용 --커서 프로세스 1.만드는 과정 2.OPEN 3.FETCH(.=.READ) 4.CLOSE
        DECLARE --변수 선언
          V_EID HR.employees.EMPLOYEE_ID%TYPE;
          V_ENAME HR.employees.EMP_NAME%TYPE;
          V_HDATE DATE;
          CURSOR CUR_EMP01 IS --커서가 갖는 속성: NOTFOUND(더이상 데이터가 없으면 참, 있으면 거짓)/FOUND (데이터가 있으면 참, 없으면 거짓)/FETCH
            SELECT EMPLOYEE_ID,EMP_NAME,HIRE_DATE
              FROM HR.employees
             WHERE JOB_ID='SA_REP';
         BEGIN 
           OPEN CUR_EMP01; --오픈공정
           LOOP
             FETCH CUR_EMP01 INTO V_EID,V_ENAME,V_HDATE; --첫줄부터 차례대로 읽어온다, 남아있는 자료가 있는지 없는지는 패치를 수행해봐야 알수있음
             EXIT WHEN CUR_EMP01%NOTFOUND;
             DBMS_OUTPUT.PUT_LINE('사원번호 : '||V_EID);
             DBMS_OUTPUT.PUT_LINE('사원명 : '||V_ENAME);
             DBMS_OUTPUT.PUT_LINE('입사일 : '||V_HDATE);
             DBMS_OUTPUT.PUT_LINE('----------------');
             
           END LOOP;
           CLOSE CUR_EMP01;
         END;
     
  2) WHILE문 --잘안씀
   . 조건을 판단하여 반복을 진행할지 여부를 판단하는 반복문
   (사용형식)
   WHILE 조건 LOOP
     반복처리문(들);
  END LOOP;
  - '조건'이 참이면 반복을 수행하고 거짓이면 반복문을 벗어남
사용예)구구단의 6단을 출력하시오(WHILE문 사용)  
     DECLARE
       V_CNT NUMBER:=1;
     BEGIN
       WHILE V_CNT<=9 LOOP --반복을 실행되기 위해 남아있는지 아닌지 알아야됨-> WHILE문 밖에서 FETCH(체크함)가 나와야함. 근데 WHILE문 안쪽에도 FETCH가 있어야 반복이 가능함
         dbms_output.put_line('6* '||V_CNT||' = '||6*V_CNT);
         V_CNT:=V_CNT+1; 
       END LOOP;
     END;
     
사용예)사원테이블에서 직무코드가 'SA_MAN'인 사원정보를 익명블록을 사용하여 출력하시오 
    DECLARE
      V_EID HR.employees.EMPLOYEE_ID%TYPE;
      V_ENAME HR.employees.EMP_NAME%TYPE;
      V_HDATE DATE;
      CURSOR CUR_EMP02 IS
         SELECT EMPLOYEE_ID,EMP_NAME,HIRE_DATE
           FROM HR.employees
          WHERE JOB_ID='SA_MAN';
    BEGIN --제일먼저 오픈. FETCH에서 가져옴. FOUND라 루프 돌고 다시 FETCH두번째사람불러옴.
      OPEN CUR_EMP02; 
      FETCH CUR_EMP02 INTO V_EID,V_ENAME,V_HDATE;
      WHILE CUR_EMP02%FOUND  LOOP
        DBMS_OUTPUT.PUT_LINE('사원번호 : '||V_EID);
        DBMS_OUTPUT.PUT_LINE('사원명 : '||V_ENAME);
        DBMS_OUTPUT.PUT_LINE('입사일 : '||V_HDATE);
        DBMS_OUTPUT.PUT_LINE('----------------');
        FETCH CUR_EMP02 INTO V_EID,V_ENAME,V_HDATE; --맨 마지막에 FETCH 시켜줘야됨.
      END LOOP;
      CLOSE CUR_EMP02;
    END;
    
  3) FOR문 --커서와 가장 궁합이 좋음   반복횟수 모를때만 와일, 루프문
   . 수행횟수가 중요하거나 알고 있는 경우 사용
   (일반적 FOR문 사용형식) --REVERSE역순으로 돌릴때
    FOR 인덱스 IN [REVERSE] 초기값..최종값 LOOP  --시작..최종. 무조건~~~1씩 증가됨. 종료조건이 필요없음. 최종값까지 도달하면 알아서 종료.
      반복처리명령문(들);
    END LOOP;
    
   (CURSOR용 FOR문 사용형식) --REVERSE역순으로 돌릴때
    FOR 레코드명 IN 커서명|커서선언|커서용SELECT문 LOOP  --시작..최종. 무조건~~~1씩 증가됨. 종료조건이 필요없음. 최종값까지 도달하면 알아서 종료.
      커서처리문
    END LOOP;    
     . '커서명|커서선언|커서용SELECT문' : 커서를 선언부에서 선언한 경우 커서명을 기술,
       in-line 형식으로 커서의 SELECT 문을 직접 기술 가능
     . OPEN, FETCH, CLOSE문을 사용하지 않음
     . 커서내의 컬럼의 참조는 '레코드명.커서컬럼명' 형식
     
사용예)구구단의 6단을 출력하시오(FOR문 사용)  
    DECLARE
    BEGIN
      FOR I IN 1..9 LOOP
      dbms_output.put_line('6 * '||I||' = '||I*6);
      END LOOP;
    END;
    
    DECLARE
    BEGIN
      FOR I IN REVERSE 1..9 LOOP --6*9부터 6*1까지 역순으로 출력
      dbms_output.put_line('6 * '||I||' = '||I*6);
      END LOOP;
    END;
    
사용예)사원테이블에서 직무코드가 'SA_MAN'인 사원정보를 익명블록을 사용하여 출력하시오 
    DECLARE
      CURSOR CUR_EMP03 IS
         SELECT EMPLOYEE_ID,EMP_NAME,HIRE_DATE
           FROM HR.employees
          WHERE JOB_ID='SA_MAN';
    BEGIN 
      FOR REC IN CUR_EMP03 LOOP
        DBMS_OUTPUT.PUT_LINE('사원번호 : '||REC.EMPLOYEE_ID);
        DBMS_OUTPUT.PUT_LINE('사원명 : '||REC.EMP_NAME);
        DBMS_OUTPUT.PUT_LINE('입사일 : '||REC.HIRE_DATE);
        DBMS_OUTPUT.PUT_LINE('----------------');
      END LOOP;
    END;    
    
 (더짧게..)
    DECLARE
    BEGIN 
      FOR REC IN (SELECT EMPLOYEE_ID,EMP_NAME,HIRE_DATE
                    FROM HR.employees
                   WHERE JOB_ID='SA_MAN')
      LOOP
        DBMS_OUTPUT.PUT_LINE('사원번호 : '||REC.EMPLOYEE_ID);
        DBMS_OUTPUT.PUT_LINE('사원명 : '||REC.EMP_NAME);
        DBMS_OUTPUT.PUT_LINE('입사일 : '||REC.HIRE_DATE);
        DBMS_OUTPUT.PUT_LINE('----------------');
      END LOOP;
    END;    