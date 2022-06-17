2022-0412-01)연산자
1. 연산자의 종류
 - 산술연산자, 관계연산자, 논리연산자,  기타연산자
 1)산술연산자
  . 사칙연산자(+,-,*,/)

사용예) 사원테이블(HR계정의 EMPLOYESS)에서 사원들의 지급액을 계산하여 출력하시오  --WHERE절 필요없음. 조건이 없어서. (급여가 NN원 이상인 사람만 보너스 지급해라
        보너스=급여(SALARY)의 30%
        지급액=급여+보너스
        Alias는 사원번호,사원명,급여,보너스,지급액이며 지급액이 많은 직원부터 출력하시오.
    SELECT EMPLOYEE_ID AS 사원번호,
           FIRST_NAME||' '||LAST_NAME AS 사원명,
           SALARY AS 급여,
           ROUND(SALARY*0.3) AS 보너스,  
           SALARY+ROUND(SALARY*0.3) AS 지급액
    FROM HR.employees-- 다른 계정에 있는거면 계정명 써줘야 함 계정명.테이블명
    ORDER BY 5 DESC; --5는 컬럼인덱스. 지급액 써야하는 줄인데 다 쓰면 오류날수있어서 5번째줄을 참조한다는 뜻
    
사용예)매입테이블(BUYPROD)에서 2020년 2월 일자별 매입집계를 조회하시오. -- **별 -> 집계함수그룹함수 사용 '2020년2월'조건(WHERE)
     Alias는 일자, 매입수량합계, 매입금액합계이며 일자순으로 출력하시오.
 SELECT BUY_DATE AS 일자,  --같은 날짜끼리 모음
        SUM(BUY_QTY) AS 매입수량합계, --같은 날짜끼리 수량 다 더함
        SUM(BUY_QTY*BUY_COST) AS 매입금액합계 --다섯개의 수량X단가
   FROM BUYPROD  --이 테이블에서 자료 꺼낼것임
  WHERE BUY_DATE BETWEEN TO_DATE('20200201') AND  --20200201부터
         LAST_DAY(TO_DATE('20200201')) -- **LAST_DAY 주어진 데이터 월의 마지막날을 찾아주는 함수
GROUP BY BUY_DATE -- GROUP BY 뒤에 기술된 컬럼 기준으로 집계를 내는데 사용 
ORDER BY 1; --어센딩이 기본(오름차순) 생략됨


    SELECT 238474*23766432675234/347864678
    FROM DUAL; --DUAL 가상테이블
    
2)관계연산자
 . 조건식을 구성할때 사용됨 --WHERE
 . 데이터의 대소관계를 판단하며 결과는 true,false이다. --두가지만 있음
 . >, <, >=, <=, =, !=(<>)  -- != 혹은 <> 둘 다 사용가능
 . WHERE 절의 조건식과 표현식(CASE WHEN THEN)의 조건식에 사용 --CASE WHEN THEN=조건식
 
 사용예) 상품테이블(PROD)에서 판매가(PROD_PRICE)가 200000만원 이상인 상품을 조회하시오.
        Alias는 상품코드,상품명, 매입가격, 판매가격이며 상품코드 순으로 출력할 것.
    1.  SELECT 상품코드,상품명, 매입가격, 판매가격
          FROM PROD
         WHERE PROD_PRICE>=200000
         ORDER BY 1; --상품코드니까 1번
         
    2.  SELECT PROD_ID AS 상품코드,
             PROD_NAME AS 상품명, 
             PROD_COST AS 매입가격,
            PROD_PRICE AS 판매가격
          FROM PROD
         WHERE PROD_PRICE>=200000
         ORDER BY 1; --상품코드니까 1번         
        
 사용예)회원테이블(MEMBER)에서 마일리지가 5000이상인 회원정보를 조회하시오.
       Alias는 회원번호, 회원명, 마일리지, 구분이며 '구분'난에는 '여성회원' 또는 '남성회원'을 출력할것. --구분컬럼은 없음! 내가 찾아줘야됨
       SELECT MEM_ID AS 회원번호,
             MEM_NAME AS 회원명,
             MEM_MILEAGE AS 마일리지,
             MEM_REGNO1||'-'||MEM_REGNO2 AS 주민번호,
             CASE WHEN SUBSTR(MEM_REGNO2,1,1)='1' OR 
                       SUBSTR(MEM_REGNO2,1,1)='3' THEN  --THEN그렇다면 남성회원
                       '남성회원' 
                  ELSE  --반대->2이거나 4
                       '여성회원' 
             END AS 구분 --이 CASE를 구분이라고 이름 붙이겠다
        FROM MEMBER 
       WHERE MEM_MILEAGE>=5000;
       
3)논리연산자
 - 두 개 이상의 조건식의 평가(AND, OR)나 또는 특정 조건식의 부정(NOT)의 결과를 반환 --NOT은 토글(한영키처럼 누를때마다 반전되는거). 데이터가 하나인 단항연산자.
 - 진리표
 --------------------------------
  입력값             출력값
  X    Y         AND   OR                            --0OFF 1ON
---------------------------------
  0    0          0     0
  0    1          0     1             AND일때는 둘 다 1이어야 1 EX)직렬
  1    0          0     1             OR일때는 둘 중 하나만 1이어도 1 EX)병렬
  1    1          1     1
  
  - 연산순서는 NOT->AND->OR --뭐부터 실행되는가. 괄호로 순서바꿀수있음
  
사용예)회원테이블에서 회원의 출생년도를 추출하여 윤년과 평년을 구별하여 출력하시오. --모든 회원 대상이라 WHERE조건절 없음
     Alias는 회원번호,회원이름,출생년월일, 비고
     **윤년 = 4의 배수이며 100의 배수가 아니거나 400배의 배수가 되는 해  --이며 AND ~거나OR
     ----MOD 나머지를 구하는 함수, EXTRACT특정정보추출
     
     SELECT MEM_ID AS 회원번호,
            MEM_NAME AS 회원이름,
            MEM_BIR AS 출생년월일,
            CASE WHEN (MOD(EXTRACT(YEAR FROM MEM_BIR),4)=0) AND (MOD(EXTRACT(YEAR FROM MEM_BIR),100)!=0) OR
                      (MOD(EXTRACT(YEAR FROM MEM_BIR),400)=0)THEN
                      '윤년'
                 ELSE
                      '평년'
            END AS 비고
       FROM MEMBER;


**사원테이블에 EMP_NAME VARCHAR2(80)컬럼을 추가하고 FIRST_NAME과 LAST_NAME을 결합하여 EMP_NAME에 저장하시오
    1)컬럼을 추가 & 결합
    ALTER TABLE HR.employees
      ADD EMP_NAME VARCHAR2(80);
    
    UPDATE HR.employees
       SET EMP_NAME=FIRST_NAME||' '||LAST_NAME;
       
       COMMIT;
       
    SELECT * FROM HR.employees;  
                                                    
사용예)사원테이블에서 10부서에서 50번부서에 속한 사원정보를 조회하시오  --10~50 -> BETWEEN연산자
      Alias는 사원번호,사원명,부서번호,입사일,직책코드이며 부서번호순으로 출력하시오.
      SELECT EMPLOYEE_ID AS 사원번호,
             EMP_NAME AS 사원명,
             DEPARTMENT_ID AS 부서번호,
             HIRE_DATE AS 입사일,
             JOB_ID AS 직책코드
        FROM HR.employees
       WHERE DEPARTMENT_ID>=10 AND DEPARTMENT_ID<=50  -- DEPARTMENT_ID BETWEEN 10 AND 50 --이렇게 코드 써도됨
       ORDER BY 3; --부서번호순으로 출력하라고 했으니 3번째줄을 지정함
       
       
사용예)장바구니테이블(CART)에서 2020년 6월 제품별 판매수량집계를 조회하시오.
      출력은 제품코드, 제품명, 판매수량합계, 판매금액합계이며 판매금액이 많은 순으로 출력하시오.
      -- 1.CART 테이블에는 제품명이 없음! 단가가 없음! -> 다른 테이블 PROD에서 가져와야함
      SELECT A.CART_PROD AS 제품코드,
             B.PROD_NAME AS 제품명,
             SUM(A.CART_QTY) AS 판매수량합계,
             SUM(A.CART_QTY*B.PROD_PRICE) AS 판매금액합계 --수량X단가
        FROM CART A,PROD B                 --CART 테이블 별칭 A. 테이블은 AS필요없음 (설명노션)
       WHERE A.CART_PROD=B.PROD_ID   --JOIN조건 (나중에 다시 함)
        AND /*1번*/ SUBSTR(A.CART_NO,1,8)>='20200601' AND
             SUBSTR(A.CART_NO,1,8)>='20200630' 
             /*--2번 SUBSTR*SUBSTR(A.CART_NO,1,6)='203006'
             /*3번 A.CART_NO LIKE'202006%' */      -- GROUP BY 뒤에 기술된 컬럼 기준으로 집계를 내는데 사용
      GROUP BY A.CART_PROD,B.PROD_NAME    --집계함수와 컬럼 같이 사용?반드시필요함...왜? 집계함수절은 SELECT절을 잘봐야
      ORDER BY 4 DESC; --4번째줄을 많->작 출력