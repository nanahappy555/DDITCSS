2022-0421-01)
SELECT LEVEL,--의사컬럼(Pseudo Column) 시스템에서 제공하는 컬럼
       DEPARTMENT_ID AS 부서코드,
       LPAD(' ',4*(LEVEL-1))||DEPARTMENT_NAME AS 부서명,
       PARENT_ID AS 상위부서코드,
       CONNECT_BY_ISLEAF
  FROM DEPTS
 START WITH PARENT_ID IS NULL
 CONNECT BY  PRIOR DEPARTMENT_ID=PARENT_ID;
 --자식에 해당되는게 부모 = 뒤에 오면
 NOCYCLE
 --제일 밑에 있는 데이터 TERMINAL/LEAF
 --부모가 같으면 SI...??
 --
 ------------------------------------------------------------------------------------
2022-0422-01)TABLE JOIN
  - 관계형 DB의 가장 핵심 기능
  - 복수개의 테이블 사이에 존재하는 관계를 이용한 연산
  - 정규화를 수행하면 테이블이 분할되고 필요한 자료가 복수개의 테이블에
    분산 저장된 경우 사용하는 연산 
  - JOIN의 종류
   . 일반조인 vs ANSI JOIN  -- // 미국표준위원회에서 정한 국제표준
   . INNER JOIN vs OUTER JOIN   --조건 맞는것만 // 조건 많은 쪽 기준으로 빈공간 만들 수 O
   . Equi-Join vs Non Equi-Join  --조인 조건에 = 연산자 사용 // =사용X
   . 기타(Cartesian Product, self Join,...etc)    -- 불가피할떄말고는 사용해서는 안됨 // 
 -사용형식
  SELECT 컬럼list
    FROM 테이블명1 [별칠1],테이블명2 [별칭2][,테이블명3 [별칭3],...]  --셀프 조인도 같은 테이블명 두 번 // 별칭: 간단히
   WHERE 조인조건  -- (테이블n-1개)
   [AND 일반조건]
  . 테이블 별칭은 복수개의 테이블에 동일한 컬럼명이 존재하고 해당 컬럼을 참조하는 경우  --반드시 동일한 컬럼명
    반드시 사용되어야 함
  . 사용되는 테이블이 n개 일때 조인조건은 적어도 n-1개 이상이어야 함
  . 조인조건은 두 테이블에 사용된 공통의 컬럼을 사용함

 1. Cartesian Product
  - 조인조건이 없거나 조인조건이 잘못된 경우 발생  --조건식이 잘못 기술
  - 최악의 경우(조인조건이 없는 경우) A테이블(a행 b열)과 B테이블(c행 d열)이
    Cartesian Product를 수행하면 결과는 a*c행, b+d열을 반환
  - ANSI에서는 CROSS JOIN이라고 하며 반드시 필요한 경우가 아니면 수행하지 말아야하는
    JOIN이다.
    
    (사용형식-일반조인)
SELECT 컬럼list
 FROM 테이블명1 [별칭1],테이블명2 [별칭2][,테이블명3 [별칭],...]
 
    (사용형식-ANSI조인)
SELECT 컬럼list
 FROM 테이블명1 [별칭1] -- 테이블명 무조건 하나
 CROSS JOIN 테이블명2;  --조인의 종류 앞에  // ON 다음에 조인조건
 
 
 사용예)
  SELECT COUNT(*)
 FROM PROD;
 
  SELECT COUNT(*)
 FROM CART;
 
  SELECT COUNT(*)
 FROM BUYPROD;
 
 
 SELECT COUNT(*)
 FROM PROD A,CART B, BUYPROD C;
 
 
 SELECT COUNT(*)
 FROM PROD A
 CROSS JOIN CART B
 CROSS JOIN BUYPROD C;  --안시 조인은 순차적으로 계속 조인
 
 2.Equi Join     --안시조인에서는 이너조인 사용
  - 조인 조건에 '='연산자가 사용된 조인으로 대부분의 조인이 이에 포함된다.
  - 복수개의 테이블에 존재하는 공통의 컬럼값의 동등성 평가에 의한 조인
  (일반 조인 사용형식)
  SELECT 컬럼list
   FROM 테이블1 별칭, 태이블2 별칭[,테이블3 별칭3,...]  --조인이 테이블 두개 이상 사용 //같은 테이블 셀프 조인도 별칭은 다르게
   WHERE 조인조건    --조인조건에' = '연산자 사용 : Equi조인
  
  (ANSI 조인 사용형식) 
   SELECT 컬럼list
   FROM 테이블1 별칭1  --**테이블 딱 하나
   INNER JOIN 테이블2 별칭2 ON(조인조건 [AND 일반조건])
   (INNER JOIN 테이블3 별칭3 ON(조인조건 [AND 일반조건])   --해당 테이블이 만족하는 조건    // 테이블1과 2는 반드시 공통컬럼이 있어야함
          :                                                                        //테이블3과 1,2 중 하나가 공통이 있으면 됨
   [WHERE 일반조건]  --모든 테이블 동시 만족하는 조건                                     //테이블 1~3과 4테이블이 공통이 있으면 됨
    . 'AND 일반조건' : ON 절에 기술된 일반조건은 해당 INNER JOIN 절애 의해
      조인에 참여하는 테이블에 국한된 조건
    . 'WHERE 일반조건': 모든 테이블에 적용되어야 하는 조건기술

사용예)2020년 1월 제품별 매입집계를 조회하시오.   --> 일반조건: 2020년 1월
  Alias는 제품코드,제품명,매입금액합계이며 제품코드순으로 출력
  
  (일반 JOIN)
  SELECT A.BUY_PROD AS 제품코드,
         B.PROD_NAME AS 제품명,
         SUM(BUY_QTY*PROD_COST) AS 매입금액합계
    FROM BUYPROD A,PROD B
  WHERE A.BUY_PROD=B.PROD_ID --조인조건
    AND A.BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200131')
    GROUP BY A.BUY_PROD,B.PROD_NAME            --집계함수 제외 전원 기술
    ORDER BY 1;
    
 (ANSI JOIN)
  SELECT A.BUY_PROD AS 제품코드,
         B.PROD_NAME AS 제품명,
         SUM(A.BUY_QTY) AS 수량,
         SUM(A.BUY_QTY*B.PROD_COST) AS 매입금액합계
    FROM BUYPROD A
   INNER JOIN PROD B ON(A.BUY_PROD=B.PROD_ID) --조인조건    //이너조인->웨어
          AND A.BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200131')
    GROUP BY A.BUY_PROD,B.PROD_NAME           
    ORDER BY 1;

사용예)상품테이블에서 판매가가 50만원 이상인 제품을 조회하시오.
 Alias는 상품코드,상품명,분류명,거래처명,판매가격이고 판매가격이 큰 상품순으로 출력하시오.
 (일반)
    SELECT A.PROD_ID AS 상품코드,
           A.PROD_NAME AS 상품명,
           B.LPROD_NM AS 분류명,      --분류테이블
           C.BUYER_NAME AS 거래처명,
           A.PROD_PRICE AS 판매가격
    FROM PROD A, LPROD B, BUYER C 
    WHERE A.PROD_LGU=B.LPROD_GU --분류명 출력 위해
    AND A.PROD_BUYER=C.BUYER_ID --거래처명 출력
    AND A.PROD_PRICE>=500000    --일반조건
    ORDER BY 5 DESC;
   
   (안시) 
     SELECT A.PROD_ID AS 상품코드,
           A.PROD_NAME AS 상품명,
           B.LPROD_NM 분류명,
           C.BUYER_NAME AS 거래처명,
           A.PROD_PRICE AS 판매가격
    FROM  PROD A
    INNER JOIN BUYER B ON (A.PROD_BUYER=B.BUYER_ID)  --거래처명(종류로 따짐)
    INNER JOIN LPROD C ON (A.PROD_LGU=C.LPROD_GU)     --분류명
    WHERE APROD_PRICE>=500000  --
    ORDER BY 5 DESC;

 
사용예)2020년 상반기 거래처별 판매역집계를 구하시오. --BUYER
    Alias는 거래처코드,거래처명,판매액합계 --수량(CART)*단가(PROD)
    --거래처에서 납품하는 제품이 얼마나 팔렸는지 알려면 BUYER와 CART가 조인 되어야 하는데 공통컬럼이 없음
    --중간다리가 되는 테이블(PROD)이 필요함.
    --해당기간동안 판매된 상품 코드로 상품코드끼리 비교 -> 단가, 거래처코드
    --단가-단가*수량, 거래처코드-거래처테이블과 비교
    SELECT A.BUYER_ID AS 거래처코드,
           A.BUYER_NAME AS 거래처명,
           SUM(B.CART_QTY*C.PROD_PRICE) AS 판매액합계
      FROM BUYER A, CART B, PROD C
     WHERE SUBSTR(B.CART_NO,1,6) BETWEEN '202001' AND '202006' --(일반조건)판매일자를 제한해야하니까 CART와 관련됨  
       AND B.CART_PROD=C.PROD_ID --(조인조건) 단가추출
       AND A.BUYER_ID=C.PROD_BUYER --(조인조건) 거래처추출
     GROUP BY A.BUYER_ID, A.BUYER_NAME
     ORDER BY 1;
     
사용예)HR계정에서 미국 이외의 국가에 위치한 부서에 근무하는 사원정보를 조회하시오.
     Alias는 사원번호,사원명,부서명,직무코드,주소 --주소=근무지주소
     --미국의 국가코드는 'US'이다
     --DEPARTMENTS(자)->(부)LOCATIONS(자)->(부)COUNTRIES
     --국가코드는 COUNTRIES의 기본키지만 COUNTRIES까지 가려면 너무 멀어서 
     --LOCATIONS의 COUNTRY_ID를 참조함 (먼소린지 모르겠으면 모델링 보면 됨....)
     SELECT A.EMPLOYEE_ID AS 사원번호,
            A.EMP_NAME AS 사원명,
            B.DEPARTMENT_NAME AS 부서명,
            A.JOB_ID AS 직무코드,
            C.STREET_ADDRESS||' '||C.CITY||', '||C.STATE_PROVINCE AS 주소
       FROM HR.employees A, HR.departments B, HR.locations C
      WHERE C.COUNTRY_ID != 'US' --일반조건
        AND A.DEPARTMENT_ID=B.DEPARTMENT_ID --조인조건(부서추출)
        AND B.LOCATION_ID=C.LOCATION_ID --조인조건(해당부서의 위치코드와 주소를 추출하기 위한 조인조건)
      ORDER BY 1;
    --집계함수가 사용되지 않았기 때문에 GROUP BY절을 쓰면 오류남  

p301가격 90%
UPDATE PROD
       SET PROD_PRICE = PROD_COST
     WHERE PROD_LGU ='P301';
COMMIT;
