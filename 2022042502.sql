2022-0425-02)외부조인(OUTER JOIN)  --요즘에는 되도록 쓰지 말라고 함. =>집합연산자
  - 자료의 종류가 많은 테이블을 기준으로 수행하는 조인
  - 자료가 부족한 테이블에 NULL 행을 추가하여 조인 수행
  - 외부조인 연산자'(+)'는 자료가 적은 쪽에 추가
  - 조인조건 중 외부조인이 필요한 모든 조건에 '(+)'를 기술해야함
  - 동시에 한 테이블이 다른 두 테이블과 외부조인될 수 없다.
    즉 A,B,C 테이블이 외부조인에 참여하고 A를 기준으로 B가 확장되고 조인되고,
    동시에 C를 기준으로 B가 확장되는 외부조인은 허용안됨(A=B(+) AND C=B(+))
    --(A=B(+) AND C=B(+)) 허용안됨.
    --(100=50 => 100 AND 1000=50 =>1000) ==>100인지 1000인지 모호해서 안됨
    --(A=B(+) AND B=C(+)) 는 가능함. A를 기준으로 B가 확장=> 그 결과를 기준으로 C가 확장
  -**일반조건과 외부조인조건이 동시에AND 존재하는 외부조인은 내부조인결과가 반환됨=>ANSI외부조인이나 서브쿼리로 해결** --서브쿼리&외부조인 같이 쓰는게 안전
   --대표성이 없어서 외부조인이 필요한 부분에는 '(+)' 다 써야됨 안쓰면 내부조인으로 반환
  (일반외부조인 사용형식)
  SELECT 컬럼List
    FROM 테이블명1 [별칭1],테이블명2 [별칭2][,...]
   WHERE 조인조건(+);
          :
  (ANSI외부조인 사용형식)
  SELECT 컬럼List
    FROM 테이블명1 [별칭1]
    LEFT|RIGHT|FULL OUTER JOIN 테이블명2 [별칭2] ON (조인조건 [AND 일반조건])
          :
  [WHERE 일반조건];
   . LEFT : FROM절에 기술된 테이블의 자료의 종류가 JOIN절의 테이블의 자료보다 많은 경우      --외부조인자체를 잘안쓰니까 외우지 마..
   . RIGHT : FROM절에 기술된 테이블의 자료의 종류가 JOIN절의 테이블의 자료보다 적은 경우
   . FULL : FROM절에 기술된 테이블과 JOIN절의 테이블의 자료가 서로 부족할 경우 
   --ex) 사원테이블에 사용된 DEPARTMENT_ID NULL포함 12개, DEPARTMENTS테이블에 가면 NULL이 없고 27개가 있음
   
   
사용예)상품테이블에서 모든 분류별 상품의 수를 조회하시오 --"모든" ->아우터 조인,테이블2개필요 "~별"->GROUP BY
--상품테이블PROD(상품74개) & 분류는 되어 있지만 상품이 없는 경우도 있을 수 있음LPROD(종류 9가지)
    1.상품테이블에서 사용된 분류코드의 수를 중복된 것을 제외하고 조회하시오 DISTINCT ->종류 6가지
    SELECT DISTINCT PROD_LGU
      FROM PROD;
    2. 분류별 상품의 수 : 별->일반컬럼 수->COUNT
    SELECT LPROD_GU AS 분류코드,
           COUNT(PROD_ID) AS "상품의 수" --공백,특수문자@_까지 출력하고 싶을 때는 쌍따옴표
      FROM LPROD A, PROD B
     WHERE A.LPROD_GU=B.PROD_LGU(+) --분류코드를 기준으로 
     GROUP BY LPROD_GU
     ORDER BY 1;
    --9가지가 나오지만 P401~P403은 PROD테이블에 없음. 근데 상품수 1로 나옴
    --COUNT에 (*)를 쓰면 빈공간NULL값 3줄도 상품수로 인식해서 1로 카운트됨
    --COUNT(PROD_ID)기본키를 써줘야됨 -> 0으로 나옴


사용예) 사원테이블에서 모든 부서별 사원수와 평균급여를 조회하시오
       단, 평균급여는 정수만 출력할 것.
       --HR.EMPLOYEES
       SELECT DISTINCT DEPARTMENT_ID
         FROM HR.EMPLOYEES;
      (일반 OUTER JOIN) ==>오류남
       SELECT B.DEPARTMENT_ID AS 부서코드,
              B.DEPARTMENT_NAME AS 부서별,
              COUNT(A.EMPLOYEE_ID) AS 사원수,
              ROUND(AVG(A.SALARY)) AS 평균급여
         FROM HR.employees A, HR.departments B, 
        WHERE A.DEPARTMENT_ID(+)=B.DEPARTMENT_ID(+)
        GROUP BY B.DEPARTMENT_ID,B.DEPARTMENT_NAME
        ORDER BY 1;
       (ANSI OUTER JOIN) ==>맞게 나옴
       SELECT B.DEPARTMENT_ID AS 부서코드,
              B.DEPARTMENT_NAME AS 부서별,
              COUNT(A.EMPLOYEE_ID) AS 사원수,
              ROUND(AVG(A.SALARY)) AS 평균급여
         FROM HR.employees A
         FULL OUTER JOIN HR.departments B ON (A.DEPARTMENT_ID=B.DEPARTMENT_ID)
        GROUP BY B.DEPARTMENT_ID,B.DEPARTMENT_NAME
        ORDER BY 1;


사용예)장바구니테이블에서 2020년 6월 모든 회원별 구매합계를 구하시오  --장바구니CART 모든회원MEMBER 구매하지않은 고객은 0원으로 출력
      (일반 OUTER JOIN) =>(+)로 확장이 된 다음 일반조건으로 6월구매회원이 추려지기 때문에 모든 회원이 나오지 않음
      SELECT C.MEM_ID AS 회원번호,  --많은쪽 걸 써라 CART(구매한 회원)<MEMBER(모든회원)
             C.MEM_NAME AS 회원명,
             SUM(A.CART_QTY*B.PROD_PRICE) AS 구매금액합계
        FROM CART A, PROD B, MEMBER C      
       WHERE A.CART_PROD=B.PROD_ID  --CART와 PROD는 외부조인을 해야할까? 해당상품의 단가를 구하기 위한거라 모든 품목의 단가가 필요없음. 외부조인X
         AND C.MEM_ID=A.CART_MEMBER(+)--CART와 MEMBER는 외부조인을 해야할까? 모든 회원의 정보가 필요해서 외부조인 필요
         AND A.CART_NO LIKE '202006%'
       GROUP BY C.MEM_ID,C.MEM_NAME;  
       
      (ANSI OUTER JOIN)   
      SELECT C.MEM_ID AS 회원번호,  --많은쪽 걸 써라 CART(구매한 회원)<MEMBER(모든회원)
             C.MEM_NAME AS 회원명,
             NVL(SUM(A.CART_QTY*B.PROD_PRICE),0) AS 구매금액합계
        FROM CART A
       RIGHT OUTER JOIN MEMBER C ON(A.CART_MEMBER=C.MEM_ID) --멤버기준비교..전체 회원수에는 날짜가 불필요해서 일반조건X)
        LEFT OUTER JOIN PROD B ON(B.PROD_ID=A.CART_PROD AND --상품코드기준비교..A,B를 아우터조인한 결과와 C를 조인하는데 A,B조인 결과가 C보다 더 많으니까 LEFT
             A.CART_NO LIKE '202006%')    --상품 단가 중 2020년6월 데이터만 필요하니까 AND로 일반조건
    -- WHERE A.CART_NO LIKE '202006%' 이렇게 WHERE절을 따로 쓰면 조인이 끝난 결과에서 6월데이터로 제한하니까 NULL값을 가진 회원들이 사라져서 6개의 결과출력        
       GROUP BY C.MEM_ID,C.MEM_NAME
       ORDER BY 1; 
--**이렇게 기억하면 쉬울 것 같음!
-- 기준 A JOIN C => 오른쪽이 데이터가 더 많으니까 RIGHT
-- 기준 (A JOIN C) JOIN B => 왼쪽이 데이터가 더 많으니까 LEFT
-- 양쪽 다 부족하면 FULL
     
      (서브쿼리) (내부조인(CART<PROD)<MEMBER)외부조인 데이터 적음 CART---PROD---MEMBER 데이터많음
      서브쿼리: 2020년 6월 회원별 판매집계 --CART와 PROD의 내부조인. MEMBER필요없음
      --MEMBER필요없음
      SELECT A.CART_MEMBER AS AID,
             SUM(A.CART_QTY*B.PROD_PRICE) AS ASUM
        FROM CART A,PROD B
       WHERE A.CART_PROD=B.PROD_ID --단가를 가져오기 위해 JOIN시킴
         AND A.CART_NO LIKE '202006%'
       GROUP BY A.CART_MEMBER;
       
      메인쿼리: 서브쿼리결과와 MEMBER 사이에 외부조인
      SELECT TB.MEM_ID AS 회원번호,
             TB.MEM_NAME AS 회원명,
             NVL(TA.ASUM,0) AS 구매합계
        FROM (SELECT A.CART_MEMBER AS AID,
                    SUM(A.CART_QTY*B.PROD_PRICE) AS ASUM
               FROM CART A,PROD B
              WHERE A.CART_PROD=B.PROD_ID
                AND A.CART_NO LIKE '202006%'
              GROUP BY A.CART_MEMBER) TA,
             MEMBER TB
       WHERE TA.AID(+)=TB.MEM_ID--공통의 컬럼 필요. AID와 MEM_ID
       ORDER BY 1;
**REMIND**       
--내부조인: 조건에 맞는 양쪽에 다 있는 정보만 남기고 나머지는 버림
--외부조인: 서로 조건이 맞지 않아도 가져옴. => NULL값 행을 삽입시켜서 많은 쪽과 같은 크기로 맞춰줌
      
      