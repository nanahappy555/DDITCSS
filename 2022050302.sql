2022-0503-02)분기문과 반복문
1.분기문
 - 개발언어의 분기문과 같은 기능제공
 - IF문, CASE WHEN 문 등이 제공
 --CASE WHEN은 자바의 SWITCH와 같다고 보면 됨
 1)IF문 --자바랑 달리 조건문에 괄호가 없고(써도됨..) {}대신 THEN이 존재
  - 조건분기문
   (사용형식1) IF ELSE END IF
   IF 조건문 THEN
      명령문1;
   [ELSE 
      명령문2;]
   END IF; --오라클에는 {}를 안써서 END IF; 로 블록을 끝냄

   (사용형식2) 병렬IF(라고 샘이 이름붙임)
   IF 조건문 THEN
      명령문1;
   ELSIF 조건문2 THEN
      명령문2;
        :
   ELSE
      명령문n;
   END IF;  
   
   (사용형식3) 중첩if 메스티드중첩 --참일때만 중첩으로
   IF 조건문 THEN
     IF 조건문2 THEN
        명령문1;
         :
     END IF;
   ELSE
      명령문n;
      
사용예) 다음 사원을 사원테이블에 저장하는 익명블록을 작성하시오
       저장하기 전에 해당 이름의 직원의 존재 유무를 판단하여
       같은 이름이 있으면 갱신을, 없으면 삽입을 수행하시오.
       사원번호는 가장 큰 사원번호 다음 번호로 지정한다.
       사원명: 홍길동, 입사일: 오늘, 직무코드 : IT_PROG
    DECLARE
      V_EID HR.EMPLOYEES.EMPLOYEE_ID%TYPE;     --사원번호를 저장하는 변수
      V_CNT NUMBER:=0; -- 해당 사원정보의 존재유무 판단
    BEGIN
      SELECT COUNT(*) INTO V_CNT   --이름이 홍길동인 행을 세어라
        FROM HR.EMPLOYEES
       WHERE EMP_NAME='홍길동';
       --V_CNT = 0 => 홍길동이 존재하지 않으면~
       IF V_CNT = 0 THEN
         SELECT MAX(EMPLOYEE_ID)+1 INTO V_EID  --제일 큰 사원번호 다음 번호를 V_EID에 넣어줌
           FROM HR.employees;
         INSERT INTO HR.employees(EMPLOYEE_ID,EMP_NAME,JOB_ID,HIRE_DATE) --'NULL이 아님'컬럼을 전부 써 줌.컬럼명 안써주면 모든 컬럼에 값 집어넣게 됨..
           VALUES(V_EID,'홍길동','IT_PROG',SYSDATE);
      ELSE  --홍길동이 존재하면
        UPDATE HR.employees
           SET HIRE_DATE=SYSDATE,
               JOB_ID='IT_PROG'
         WHERE EMP_NAME='홍길동';
      END IF;
      COMMIT;
    END;
    
    SELECT * FROM HR.employees;
    
2. CASE WHEN 문
  - 다중 분기명령(자바의 SWITCH CASE문과 유사) --자바에 있는 BREAK가 없음
  (사용형식1)
  CASE WHEN 조건1 THEN
            명령1;
       WHEN 조건2 THEN
            명령2;
             :
      [ELSE
            명령n;]
  END CASE;        --
  
  (사용형식2)
  CASE 조건1 WHEN 값1 THEN
                 명령1;
            WHEN 값2 THEN
                 명령2;
        :
 [ELSE
                 명령n;]
  END CASE;  
  
사용예)회원테이블에서 마일리지를 조회하여
      0~2000 : 'Beginner'
      2001~5000 : 'Normal'
      5000~     : 'Excellent' 를 비고에 출력하시오
      출력은 회원명, 마일리지, 비고이다.
    DECLARE
      CURSOR CUR_MEM02  IS  --왜 커서를..? 한사람이 아니라 회원수만큼 출력해야해서 CURSOR를 써서 반복. 커서를 안쓰면 SELECT문에 의해서 제공되는 데이터는 24개임 근데 INTO절 변수는 한번에 하나밖에 못받는다. 수용할 수 없음. 그래서 24개를 다 받되 한번에 하나씩 받기 위해 사용하는 것이 커서
        SELECT MEM_NAME, MEM_MILEAGE FROM MEMBER; --모든 회원이 대상이라 조건절X
      V_RES VARCHAR2(200); --결과값이 들어갈 장소 이름마일리지비고를 한번에
    BEGIN
      FOR REC IN CUR_MEM02 LOOP --REC레코드네임이 첫번째 출을 가르키고 있음. 커서로 루프를 돌리세요 . //FOR문쓰면 OPEN FETCH CLOSE 안써도됨
         CASE WHEN REC.MEM_MILEAGE < 2001 THEN
                   V_RES:=RPAD(REC.MEM_NAME,10)|| --(왼쪽정렬오른쪽에공백)
                          LPAD(REC.MEM_MILEAGE,7)||'Beginner';
              WHEN REC.MEM_MILEAGE < 5001 THEN
                   V_RES:=RPAD(REC.MEM_NAME,10)||
                          LPAD(REC.MEM_MILEAGE,7)||'Normal';     
              ELSE V_RES:=RPAD(REC.MEM_NAME,10)||
                          LPAD(REC.MEM_MILEAGE,7)||'Excellent';    
         END CASE;                      
          DBMS_OUTPUT.put_line(V_RES); --DBMS출력
          DBMS_OUTPUT.put_line('--------------------------');
      END LOOP;
    END;