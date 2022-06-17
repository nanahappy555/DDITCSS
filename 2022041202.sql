4)기타연산자
    (1) IN 연산자   --OR쓰면 길고 복잡한데 IN은 간단해서 많이 쓰임     >,<를 못 씀. =이 포함되어있어서
     - 불연속적이거나 규칙성이 없는 자료를 비교할때 사용
     - OR연산자, =ANY, =SOME연산자로 변환가능
     - IN 연산자에는 '='기능이 내포됨
    (사용형식)
     expr IN(값1, 값2,...값n) --또는 expr=값1 또는 expr=값2 ...
        - 'expr'(수식)을 평가한 결과가 '값1' ~ '값n' 중 어느 하나와 일치하면 결과로 참(true)을 반환
        
(사용예) 사원테이블에서 20번, 70번, 90번, 110번 부서에 근무하는 사원을 조회하시오 --한사람이 한 부서에만 소속될 수 있으니 중복X
        Alias는 사원번호,사원명,부서번호,급여이다.
        
    (OR 연산자 사용)    
        SELECT EMPLOYEE_ID AS 사원번호,
               EMP_NAME AS 사원명,
               DEPARTMENT_ID AS 부서번호,
               SALARY AS 급여
          FROM HR.employees
         WHERE DEPARTMENT_ID=20
            OR DEPARTMENT_ID=70
            OR DEPARTMENT_ID=90
            OR DEPARTMENT_ID=110;
            
    (IN 연산자 사용)        
        SELECT EMPLOYEE_ID AS 사원번호,
               EMP_NAME AS 사원명,
               DEPARTMENT_ID AS 부서번호,
               SALARY AS 급여
          FROM HR.employees
         WHERE DEPARTMENT_ID IN(20, 70,90,110);
         
    (=ANY(=SOME) 연산자 사용)        
        SELECT EMPLOYEE_ID AS 사원번호,
               EMP_NAME AS 사원명,
               DEPARTMENT_ID AS 부서번호,
               SALARY AS 급여
          FROM HR.employees
         WHERE DEPARTMENT_ID =ANY(20,70,90,110);    --SOME과 ANY에는 =기능이 없어서 =를 써줘야함.
        --     DEPARTMENT_ID =SOME(20,70,90,110);     같은결과나옴
        

    (2) ANY, SOME 연산자   -- (= 포함된게 IN) ANY와 SOME은 완전히 같음
        - 등호(=)의 기능이 포함되지 않은 IN연산자와 같은 기능 수행
    (사용형식)                --관계연산자 >< >=<=
     expr  관게연산자ANY(SOME)(값1,...값)   --ALL제일 큰 값 보다 더 크면 참
  
  
    (사용예)회원테이블에서 직업이 공무원인 회원들의 마일리지보다 많은 마일리지를 보유한 회원들을 조회하시오. --직업이 공무원인 회원들의 (제일 작은)마일리지
           Alias는 회원번호, 회원명, 직업, 마일리지
 순서1.  SELECT MEM_MILEAGE        --1700/900/2200/3200 **보다 크거나 **보다 크거나... 큰 -> ~거나=또는=OR ->900보다 크면 ㅇㅋ
        FROM MEMBER                --3200보다 클려면 ALL
        WHERE MEM_JOB='공무원';
     
    2.  SELECT MEM_ID AS 회원번호,   -- FROM1 WHERE2 SELECT3 (ORDER BY4) 실행순서
               MEM_NAME AS 회원명,
               MEM_JOB AS 직업,
               MEM_MILEAGE AS 마일리지
          FROM MEMBER                            
         WHERE MEM_MILEAGE >ANY(1700,900,2200,3200) -- >ANY(값) 'ANY에 있는 값보다 큰' 이 참이면 SELECT절 실행
         ORDER BY 4;                                -- >=이 아니라서 900은 포함되지 않음
         
         -- <ANY(값) 라고 쓰면 1700보다 작거나 OR 900보다 작거나 OR 2200보다 작거나 OR 3200보다 작거나 => 3200보다 작으면 출력
         -- >ANY(값) 라고 쓰면 1700보다 크거나 OR 900보다 크거나 OR 2200보다 크거나 OR 3200보다 크거나 => 900보다 크면 출력

실제로는 이렇게 사용한다.
(SUBQUERY)
    1. SELECT MEM_ID AS 회원번호,   -- FROM1 WHERE2 SELECT3 (ORDER BY4) 실행순서
               MEM_NAME AS 회원명,
               MEM_JOB AS 직업,
               MEM_MILEAGE AS 마일리지
          FROM MEMBER                            
         WHERE MEM_MILEAGE >ANY(SELECT MEM_MILEAGE        
                                  FROM MEMBER                
                                 WHERE MEM_JOB='공무원')
         ORDER BY 4; 
        
        
    (3) ALL 연산자
     - ALL다음에 기술된 값들 모두를 만족시킬때만 조건이 참(TRUE)을 반환
    (사용형식)
      expr 관계연산자 ALL(값,....,값n)
    (사용예)회원테이블에서 직업이 공무원인 회원들 중 가장 많은 마일리지를 보유한 회원보다 더 많은 마일리지를 보유한 회원들을 조회하시오. 
        Alias는 회원번호, 회원명, 직업, 마일리지                       ----직업이 공무원인 회원들의 (제일 작은)마일리지
        
        SELECT MEM_ID AS 회원번호,
               MEM_NAME AS 회원명,
               MEM_JOB AS 직업,
               MEM_MILEAGE AS 마일리지
          FROM MEMBER
         WHERE MEM_MILEAGE >ALL(SELECT MEM_MILEAGE      --1700보다 크고 AND 900보다 크고 AND 2200보다 크고 AND 3200보다 큼 => 3200보다 큼
                                  FROM MEMBER
                                 WHERE MEM_JOB='공무원')
         ORDER BY 4;  
         
    (4) BETWEEN  --굉장히 많이 씀  
      - 제시된 자료의 범위를 지정할 때 사용
      - AND 연산자와 같은 기능
      - 모든 데이터 타입에 사용 가능 숫자,날짜 다 가능
    (사용형식)
     expr BETWEEN 하한값  AND  상한값  --하한값부터 상한값까지
     . '하한값'과 '상한값'의 타입은 동일해야 함
     
    (사용예)상품테이블에서 매입가격이 100000원~200000원 사이의 상품을 조회하시오
           Alias는 상품코드, 상품명, 매입가, 매출가이며, 매입가순으로 출력   --매입가격->매입집계낼때
           SELECT PROD_ID AS 상품코드,
                  PROD_NAME AS 상품명,
                  PROD_COST AS 매입가,
                  PROD_PRICE AS 매출가
             FROM PROD
            WHERE PROD_COST BETWEEN 100000 AND 200000   -- 논리연산자로 하는 법 WHERE PROD_COST>=100000 AND PROD_COST<=200000
            ORDER BY 3;                                 
    (사용예)사원테이블에서 2006년~2007년 사이에 입사한 사원들을 조회하시오
           Alias는 사원번호,사원명,입사일,부서코드이며 입사일 순으로 출력
           SELECT EMPLOYEE_ID AS 사원번호,
                  EMP_NAME AS 사원명,
                  HIRE_DATE AS 입사일,
                  DEPARTMENT_ID AS 부서코드
             FROM HR.employees
            WHERE HIRE_DATE BETWEEN TO_DATE('20060101') AND TO_DATE('20071231')
            ORDER BY 3;
           
    (사용예)상품의 분류코드가 'P100'번대('P101'-'P199')인 상품을 거래하는 거래처정보를 조회하시오.  
           Alias는 거래처코드,거래처명,주소,분류코드
           SELECT BUYER_ID AS 거래처코드,
                  BUYER_NAME AS 거래처명,
                  BUYER_ADD1||' '||BUYER_ADD2 AS 주소,
                  BUYER_LGU AS 분류코드
             FROM BUYER
            WHERE BUYER_LGU BETWEEN 'P101' AND 'P199'
            ORDER BY 4;
     
      
    (5) LIKE 연산자      --문자열 비교(날짜,숫자X). 비교대상도 문자열.
      - 패턴을 비교하는 연산자
      - 와일드카드(패턴비교문자열) : '%'와 '_'이 사용되어 패턴을 구성함 
    (사용형식)
    expr LIKE '패턴문자열'
1) '%' : '%'이 사용된 위치에서 이후의 모든 문자열을 허용
    ex) SNAME LIKE '김%' => SNAME의 값이 '김'으로 시작하는 모든 값과 대응됨
        SNAME LIKE '%김%' => SNAME의 값이 '김'이 있는 모든 값과 대응됨  
        SNAME LIKE '%김' => SNAME의 값이 '김'으로 끝나는 모든 값과 대응됨
1) '_' : '_'이 사용된 위치에서 하나의 문자와 허용
    ex) SNAME LIKE '김_' => SNAME의 값이 2글자이며 '김'으로 시작하는 문자열과 대응됨
        SNAME LIKE '_김_' => SNAME의 값 중 3글자로 구성된 값 중 중간의 글자가 '김'인 데이터와 대응됨  
        SNAME LIKE '_김' => SNAME의 값 중 2글자이며 '김'으로 끝나는 문자열과 대응됨        
        
  (사용예) 장바구니테이블(CART)에서 2020년 6월에 판매된 자료를 조회하시오
          Alias는 판매일자, 상품코드, 판매수량이며 판매일 순으로 출력하시오.
          SELECT SUBSTR(CART_NO,1,8) AS 판매일자, 
                 CART_PROD AS 상품코드,
                 CART_QTY AS 판매수량
            FROM CART
           WHERE CART_NO LIKE '202006%'  --202006 뒤로 어떤 값이 와도 상관없음
           ORDER BY 1;
          
  (사용예) 매입테이블(BUYPROD)에서 2020년 6월에 매입된 자료를 조회하시오
          Alias는 구매일자, 상품코드, 구매수량, 구매액이며 구매일 순으로 출력하시오.  
          SELECT BUY_DATE AS 구매일자,
                 BUY_PROD AS 상품코드,
                 BUY_QTY AS 구매수량,
                 BUY_COST*BUY_COST AS 구매액
            FROM BUYPROD                                     --BUY_DATE컬럼의 타입은 DATE라 LIKE를 쓸수X
           WHERE BUY_DATE BETWEEN TO_DATE('20200601') AND TO_DATE('20200630') --LIKE '2020/06%'로 적으니 문자열로 인식했지만 이렇게 쓰면 위험 ㅠㅠ
           ORDER BY 1;
          
  (사용예) 회원테이블에서 충남에 거주하는 회원을 조회하시오.
          Alias는 회원번호, 회원명, 주소, 마일리지
          SELECT MEM_ID AS 회원번호,
                 MEM_NAME AS 회원명,
                 MEM_ADD1||' '||MEM_ADD2 AS 주소,
                 MEM_MILEAGE AS 마일리지
            FROM MEMBER
           WHERE MEM_ADD1 LIKE '충남%';        