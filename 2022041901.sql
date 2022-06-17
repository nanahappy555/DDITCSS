2022-0419-01)집계함수 중요!
 - 자료를 그룹화하고 그룹내에서 합계,자료수,평균,최대,최소 값을 구하는 함수
 - ****SUM, AVG, COUNT, MAX, MIN 이 제공됨****
 - SELECT 절에 그룹함수가 일반 컬럼과 같이 사용된 경우 반드시 GROUP BY절에 기술되어야 함.
 --↑그래서 SELECT절을 잘 봐야됨
 --결과가 여러개의 행이 출력되기 때문에 다중행 쿼리라고 부름
(사용형식)
    SELECT 컬럼명1,
          [컬럼명2,...]
           집계함수
      FROM 테이블명
    [WHERE 조건]
    [GROUP BY 컬럼명1[,컬럼명2...]]
   [HAVING 조건]
   [ORDER BY 인덱스|컬럼명 [ASC|DESC][,...]]
     . GROUP BY 절에 사용된 컬럼명은 왼쪽에서 기술된 순서대로 대분류, 소분류의 기준 컬럼명
       --SELECT절에 없는 컬럼명도 쓸 수 있지만 보통 잘 없음~
     . HAVING 조건 : 집계함수에 조건이 부여된 경우
     
 1.SUM(col)
  - 각 그룹 내의 'col'컬럼에 저장된 값을 모두 합하여 반환
 2.AVG(col)  
  - 각 그룹 내의 'col'컬럼에 저장된 값의 평균을 반환
 3.COUNT(*|col)
  - 각 그룹 내의 행의 수를 반환
  - '*'를 사용하면 NULL값도 하나의 행으로 취급
  - 컬럼명을 기술하면 해당 컬럼의 값이 NULL이 아닌 갯수를 반환
 4.MAX(col),MIN(col)
  - 각 그룹 내의 'col'컬럼에 저장된 값 중 최대값과 최소값을 구하여 반환 
***집계함수는 다른 집계함수를 포함할 수 없다***
EX) 2020/5 매출액 합계 기준 최고매출회원?
    최고매출MAX(매출액합계 SUM)  이렇게 쓸 수 없음

사용예)사원테이블에서 전체사원의 급여합계를 구하시오
사용예)사원테이블에서 전체사원의 평균급여를 구하시오
--전체사원->일반컬럼이 없음->GROUP BY절 없음
    SELECT SUM(SALARY) AS 급여합계,
           ROUND(AVG(SALARY)) AS 평균급여,
           MAX(SALARY) AS 최대급여,
           MIN(SALARY) AS 최소급여,
           COUNT(*) AS 사원수
      FROM HR.employees;

--일반함수와 집계함수가 각각 서로를 포함하는 예시--실행가능
--집계함수끼리는 불가능
    SELECT AVG(TO_NUMBER(SUBSTR(PROD_ID,2,3)))
      FROM PROD;

사용예)사원테이블에서 부서별 급여합계를 구하시오
사용예)사원테이블에서 부서별 평균급여를 구하시오
사용예)사원테이블에서 부서별 최대급여액을 구하시오
사용예)사원테이블에서 부서별 최소급여액을 구하시오
-- *부서*별 : 별 앞에 붙는 것이 기준컬럼 ->반드시 GROUP BY절(그룹의 결정기준)
    SELECT DEPARTMENT_ID AS 부서코드, --일반컬럼.기준컬럼.*부서별* 대분류
           EMP_NAME AS 사원명, --일반컬럼 소분류
           SUM(SALARY) AS 급여합계, --집계함수사용됨
           ROUND(AVG(SALARY)) AS 평균급여 --집게
           COUNT(EMPLOYEE_ID) AS 사원수, --집계함수
           MAX(SALARY) AS 최대급여 --집계함수
      FROM HR.employees
     GROUP BY DEPARTMENT_ID,EMP_NAME --부서코드로 분류한 뒤 이름으로 분류
     ORDER BY 1;  
--실행은 되지만 사원명은 분류기준이 될 수 없음. 
--이름은 중복되는 값이 없어서 107명이 있으면 107개로 분류됨

사용예)사원테이블에서 부서별 평균급여가 6000이상인 부서를 조회하시오
    SELECT DEPARTMENT_ID AS 부서코드, 
           ROUND(AVG(SALARY)) AS 평균급여
      FROM HR.employees
     GROUP BY DEPARTMENT_ID
    HAVING AVG(SALARY)>=6000
     ORDER BY 1;  

사용예)장바구니테이블에서 2020년 5월 회원별 구매수량합계를 조회하시오
    SELECT CART_MEMBER AS 회원명,
           CART_NO AS 구매번호,
           SUM(CART_QTY) AS 구매수량합계
      FROM CART
     WHERE CART_NO LIKE '202005%'
     GROUP BY CART_MEMBER,CART_NO
     ORDER BY 1;

사용예)매입테이블(buyprod)에서 2020년 상반기(1~6월) 월별,제품별 매입집계를 조회하시오
--월단위로 그룹묶고, 제품별로 그룹 묶기 ->그룹핑2번 대그룹:월 소그룹:제품
--select **별이 붙는 애들이 와줘야됨, 제품코드
--조건 : where 2020년 자료로 제한해야됨
     --BUY_DATE AS 월 =>일별로 출력
     --1.먼스를 추출
     SELECT EXTRACT(MONTH FROM BUY_DATE) AS 월,
            BUY_PROD AS 제품코드,
            SUM(BUY_QTY) AS 수량합계,
            SUM(BUY_QTY*BUY_COST) AS 매입금액합계
       FROM BUYPROD
      WHERE BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200630')       
      GROUP BY EXTRACT(MONTH FROM BUY_DATE),BUY_PROD --함수까지같이!!
      ORDER BY 1,2;

사용예)매입테이블(buyprod)에서 2020년 상반기(1~6월) 월별 매입집계를 조회하되
      매입금액이 1억원 이상인 월만 조회하시오.
--**별:컬럼생성해야됨
--HAVING절: 집계함수가 적용된 컬럼에 조건을 걸고 싶을 때 GROUP BY 이후에 쓴다.
     SELECT EXTRACT(MONTH FROM BUY_DATE) AS 월,
            SUM(BUY_QTY) AS 수량합계,
            SUM(BUY_QTY*BUY_COST) AS 매입금액합계
       FROM BUYPROD
      WHERE BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200630')       
      GROUP BY EXTRACT(MONTH FROM BUY_DATE)
     HAVING SUM(BUY_QTY*BUY_COST) >= 100000000 
      ORDER BY 1 ; --월별 정렬이라서 ASC생략
      
      
사용예)회원테이블에서 성별 평균 마일리지를 조회하시오
    SELECT CASE WHEN SUBSTR(MEM_REGNO2,1,1)='1' OR
                     SUBSTR(MEM_REGNO2,1,1)='3' THEN '남성회원'
                ELSE '여성회원' END AS 성별,
           ROUND(AVG(MEM_MILEAGE)) AS 평균마일리지
      FROM MEMBER
     GROUP BY CASE WHEN SUBSTR(MEM_REGNO2,1,1)='1' OR
                     SUBSTR(MEM_REGNO2,1,1)='3' THEN '남성회원'
              ELSE '여성회원' END;
     
사용예)회원테이블에서 연령대별 평균마일리지를 조회하시오
--연령대 구하는 법
1.나이 : (오늘 날짜에서 연도 추출 - 생일에서 연도 추출)
2.연령대 : TRUNC(나이,-1)
    SELECT TRUNC(EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM MEM_BIR),-1) AS 연령대,
           ROUND(AVG(MEM_MILEAGE)) AS 평균마일리지
      FROM MEMBER
     GROUP BY TRUNC(EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM MEM_BIR),-1)
     ORDER BY 1;

사용예)회원테이블에서 거주지별 평균마일리지를 조회하시오
    SELECT SUBSTR(MEM_ADD1,1,2) AS 거주지,
           ROUND(AVG(MEM_MILEAGE)) AS 평균마일리지
      FROM MEMBER
     GROUP BY SUBSTR(MEM_ADD1,1,2);

사용예)매입테이블(buyprod)에서 2020년 상반기(1~6월) 제품별 매입집계를 조회하되
      금액 기준 상위 5개 제품만 조회하시오.
--1.상반기 매입집계를 구함 
--2. 많-> 적 출력
  SELECT BUY_PROD AS 제품코드,
         SUM(BUY_QTY) AS 수량합계,
         SUM(BUY_QTY*BUY_COST) AS 매입금액합계
    FROM BUYPROD
   WHERE BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200630')
   GROUP BY BUY_PROD
   ORDER BY 3 DESC; 
--3. 결과 74개중 상위 5개만
--4. *순위는 가격순 정렬한 행번호*와 같다. 이미 존재하는 행번호ROWNUM (의사컬럼)
--5. ROWNUM<=5 =>조건WHERE => 조건이 여러개면 AND로 연결
--6. 5까지 하면 틀린 결과이다. 
--ORDER BY를 실행시킨 뒤 상위5개를 뽑아야 함
--실행 순서 FROM-WHERE-GROUPBY-SELECT-ORDERBY
--7.4까지의 결과를 A테이블로 명명하고 FROM절에 넣음, WHERE조건도 FROM절에 걸림
--참조되어지는 컬럼명(AS BID)은 영문으로 써라. 한글은 오류날수있음
SELECT A.BID AS 제품코드,
       A.QSUM AS 수량합계,
       A.CSUM AS 매입금액합계
  FROM (SELECT BUY_PROD AS BID,
               SUM(BUY_QTY) AS QSUM,
               SUM(BUY_QTY*BUY_COST) AS CSUM
          FROM BUYPROD
         WHERE BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200630')
         GROUP BY BUY_PROD
         ORDER BY 3 DESC) A
 WHERE ROWNUM<=5;          

 
 5. ROLLUP과 CUBE 
 --GROUP BY절을 벗어나면 쓸 수 없음
 --(잘안씀)CUBE : 컬럼명으로 조합가능한수 2^n가지 집계반환
  1) ROLLUP
   - GROUP BY 절 안에 사용하여 레벨별 집계의 결과를 반환
   (사용형식)
    GROUP BY ROLLUP(컬럼명1,[,컬럼명2,...,컬럼명n])
    . 컬럼명1,컬럼명2,...,컬럼명n을 (가장 하위레벨)기준으로 그룹구성하여
      그룹함수 수행한 후 오른쪽에 기술된 컬럼명을 하나씩 제거한 기준으로 그룹구성,
      마지막으로 전체(가장 상위레벨) 합계 반환 --GROUP BY와 동일 모든조건을 만족하는 한종류라는거지 한줄이라는 뜻이 아님
    . n개의 컬럼이 사용된 경우 n+1종류의 집계반환

(사용예)장바구니테이블에서 2020년 월별,회원별,제품별 판매수량집계를조회하시오.
 (GROUP BY 사용)
-- GROUP BY절에 집계함수가 사용되지 않은 컬럼 3개 다 씀
--=> 205개의 행
    SELECT SUBSTR(CART_NO,5,2) AS 월,
           CART_MEMBER AS 회원번호,
           CART_PROD AS 제품코드,
           SUM(CART_QTY) AS 판매수량집계
      FROM CART
     WHERE SUBSTR(CART_NO,1,4)='2020' --문자열이라서 =비교
     GROUP BY SUBSTR(CART_NO,5,2),CART_MEMBER,CART_PROD
     ORDER BY 1;
     
 (ROLLUP절 사용)    
    SELECT SUBSTR(CART_NO,5,2) AS 월,
           CART_MEMBER AS 회원번호,
           CART_PROD AS 제품코드,
           SUM(CART_QTY) AS 판매수량집계
      FROM CART
     WHERE SUBSTR(CART_NO,1,4)='2020'
     GROUP BY ROLLUP(SUBSTR(CART_NO,5,2),CART_MEMBER,CART_PROD)
     ORDER BY 1;  
     --GROUP BY에 쓰인 컬럼갯수3개 + 1 
     --월별회원별제품별-월별회원별-월별-전체집계
     --1)월별회원별제품별 4월 회원a001 제품p10100001 4월회원a001의제품p10100001판매수량집계
     --2)월별회원별 4월 회원a001 제품NULL 4월회원a001의판매수량집계 28(5+16+7=전체집계28)
     --3)월별 4월 회원NULL 제품NULL 4월전체회원판매수량집계 347
     --4)전체 월NULL 회원NULL 제품NULL 2020년전체판매수량집계 1035
     
 **부분 ROLLUP
  . 그룹을 분류 기준 컬럼이 ROLLUP절 밖(GROUP BY 절 안)에 기술된 경우를
    부분 ROLLUP이라고 함
  . ex) GROUP BY 컬럼명1, ROLLUP(컬럼명2,컬럼명3)인 경우
       =>컬럼명1,컬럼명2,컬럼명3 모두가 적용된 집계
         컬럼명1,컬럼명2가 반영된 집계
         컬럼명1 만 반영된 집계
 (부분 ROLLUP절 사용)    
    SELECT SUBSTR(CART_NO,5,2) AS 월,
           CART_MEMBER AS 회원번호,
           CART_PROD AS 제품코드,
           SUM(CART_QTY) AS 판매수량집계
      FROM CART
     WHERE SUBSTR(CART_NO,1,4)='2020'
     GROUP BY CART_PROD, ROLLUP(SUBSTR(CART_NO,5,2),CART_MEMBER)
     ORDER BY 1;         
   --GROUP BY CART_PROD, ROLLUP(...) CART_PROD제품코드는 항상 기준이 됨  

  2) CUBE --너무 다양한 결과라 잘 안씀
  - GROUP BY절 안에서 사용(ROLLUP과 동일)
  - 레벨개념이 없음
  - CUBE내에 기술된 컬럼들의 조합 가능한 경우마다 집계반환(2의n승수 만큼의 집계반환)
  (사용형식)
   GROUP BY CUBE(컬럼명1....컬럼명n);

 (CUBE 사용)
--3가지 컬럼 -> 2^3=8개
--1ABC 2AB 3AC 4BC 5A 6B 7C 8x
--월 회원 제품
--1셋다적용, 2월과 회원번호, 3월과 제품코드, 4회원번호와 제품코드, 5.월만, 6회원번호만, 7제품코드만, 8전체
    SELECT SUBSTR(CART_NO,5,2) AS 월,
           CART_MEMBER AS 회원번호,
           CART_PROD AS 제품코드,
           SUM(CART_QTY) AS 판매수량집계
      FROM CART
     WHERE SUBSTR(CART_NO,1,4)='2020'
     GROUP BY CUBE(SUBSTR(CART_NO,5,2),CART_MEMBER,CART_PROD)
     ORDER BY 1;  