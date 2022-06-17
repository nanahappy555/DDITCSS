사용예)2020 4월 거래처별 매입금액을 조회하시오. --BUYER BUYPROD(매입) PROD
      Alias는 거래처코드,거래처명,매입금액합계 --거래처는 13군데 중 4월달 매입발생 6군데
      --BUYPROD에 데이터가 들어갈 때 똑같은 PROD_ID가 있는지 PROD테이블을 검사하고 INSERT됨. 
      --이 때 PROD테이블에 상품코드가 있는지 먼저 확인하고 없으면 저장되지 않음.
      (일반조인)
      SELECT A.BUYER_ID AS 거래처코드,
             A.BUYER_NAME AS 거래처명,
             SUM(B.BUY_QTY*B.BUY_COST) AS 매입금액합계
        FROM BUYER A, BUYPROD B, PROD C
       WHERE A.BUYER_ID=C.PROD_BUYER    
         AND B.BUY_PROD=C.PROD_ID
         AND B.BUY_DATE BETWEEN TO_DATE('20200401') AND TO_DATE('20200430')
       GROUP BY A.BUYER_ID, A.BUYER_NAME
       ORDER BY 1;
       --총 13중 4월 거래처 6개. 나머지 7개는 NULL
       --OUTER JOIN 에서는 더 많은쪽을 써야 NULL의 갯수가 줄어든다
       --이건 OUTER JOIN에서 다시 설명
      (ANSI 조인)
      SELECT A.BUYER_ID AS 거래처코드,
             A.BUYER_NAME AS 거래처명,
             SUM(B.BUY_QTY*B.BUY_COST) AS 매입금액합계
        FROM BUYER A
       INNER JOIN PROD C ON(A.BUYER_ID=C.PROD_BUYER) --FROM절에 적힌 테이블과 첫번째 INNER JOIN에 적힌 테이블은 직접 조인되어야함
       INNER JOIN BUYPROD B ON(B.BUY_PROD=C.PROD_ID AND B.BUY_DATE BETWEEN TO_DATE('20200401') AND TO_DATE('20200430'))
       GROUP BY A.BUYER_ID, A.BUYER_NAME
       ORDER BY 1;       
       
      
사용예)2020 4월 거래처별 매출금액을 조회하시오. --BUYER CART(매출) PROD
      Alias는 거래처코드,거래처명,매출금액합계
      (일반조인)
      SELECT A.BUYER_ID AS 거래처코드,
             A.BUYER_NAME AS 거래처명,
             SUM(B.CART_QTY*C.PROD_PRICE) AS 매출금액합계
        FROM BUYER A, CART B, PROD C
       WHERE A.BUYER_ID=C.PROD_BUYER    
         AND B.CART_PROD=C.PROD_ID
         AND B.CART_NO LIKE '202004%'
       GROUP BY A.BUYER_ID, A.BUYER_NAME
       ORDER BY 1;  
     
      (ANSI 조인)
      SELECT A.BUYER_ID AS 거래처코드,
             A.BUYER_NAME AS 거래처명,
             SUM(B.CART_QTY*C.PROD_PRICE) AS 매출금액합계
        FROM BUYER A
       INNER JOIN PROD C ON(A.BUYER_ID=C.PROD_BUYER)
       INNER JOIN CART B ON(B.CART_PROD=C.PROD_ID AND B.CART_NO LIKE '202004%') --AND 뒤가 일반조건
       GROUP BY A.BUYER_ID, A.BUYER_NAME
       ORDER BY 1;      
      
사용예)2020 4월 거래처별 매입/매출금액을 조회하시오.
      Alias는 거래처코드,거래처명,매입금액합계,매출금액합계
     (일반)
      SELECT A.BUYER_ID AS 거래처코드,
             A.BUYER_NAME AS 거래처명,
             SUM(B.BUY_QTY*D.PROD_COST) AS 매입금액합계,
             SUM(C.CART_QTY*D.PROD_PRICE) AS 매출금액합계
        FROM BUYER A, BUYPROD B, CART C, PROD D
       WHERE A.BUYER_ID=D.PROD_BUYER --(조인조건)거래처 코드 추출   
         AND B.BUY_PROD=D.PROD_ID --(조인조건)매입단가 추출
         AND C.CART_PROD=D.PROD_ID --(조인조건)매출단가 추출
         AND B.BUY_DATE BETWEEN TO_DATE('20200401') AND TO_DATE('20200430') --(일반조건)
         AND C.CART_NO LIKE '202004%' --(일반조건)
       GROUP BY A.BUYER_ID, A.BUYER_NAME
       ORDER BY 1;   
    --결과가 6개만 나오는 이유: INNER JOIN은 매입6개, 매출12개 중
    --겹치는 6개의 결과만 나오고 나머지 6개는 *버림*  
    --ANSI로도 해결안되고 서브쿼리를 사용해야 됨.
     (ANSI)
      SELECT A.BUYER_ID AS 거래처코드,
             A.BUYER_NAME AS 거래처명,
             SUM(B.BUY_QTY*D.PROD_COST) AS 매입금액합계,
             SUM(C.CART_QTY*D.PROD_PRICE) AS 매출금액합계
        FROM BUYER A       --FROM절에 PROD가 온다면 BUYER,BUYPROD,CART모두 직접JOIN되므로 바로 다음에 셋 다 올 수 있음
       INNER JOIN PROD D ON (A.BUYER_ID=D.PROD_BUYER)
       INNER JOIN BUYPROD B ON(B.BUY_PROD=D.PROD_ID AND
             B.BUY_DATE BETWEEN TO_DATE('20200401') AND TO_DATE('20200430'))
       INNER JOIN CART C ON(C.CART_PROD=D.PROD_ID AND C.CART_NO LIKE '202004%')
       GROUP BY A.BUYER_ID, A.BUYER_NAME
       ORDER BY 1;   
    --결과가 6개만 나오는 이유: INNER JOIN은 매입6개, 매출12개 중
    --겹치는 6개의 결과만 나오고 나머지 6개는 *버림*  
    --ANSI로도 해결안되고 서브쿼리를 사용해야 됨.
    
    (해결 : 서브쿼리+외부조인)
    SELECT TB.CID AS 거래처코드,     --메인쿼리//매입보다 매출결과에 나오는 거래처갯수가 더 많아서 많은 쪽으로 씀
           TB.CNAME AS 거래처명,           --//적은쪽인 TA.BID을 쓰면 매입에 없는 거래처 6군데는 NULL값이 나옴
           NVL(TA.BSUM,0) AS 매입금액합계,
           NVL(TB.CSUM,0) AS 매출금액합계
      FROM (SELECT B.PROD_BUYER AS BID,     --서브쿼리
                   SUM(A.BUY_QTY*B.PROD_COST) AS BSUM   --영문명 쓰는 이유:참조할것이다. 한글오류잘남
              FROM BUYPROD A, PROD B, BUYER C
             WHERE A.BUY_DATE BETWEEN TO_DATE('20200401') AND TO_DATE('20200430')
               AND A.BUY_PROD=B.PROD_ID
               AND C.BUYER_ID=B.PROD_BUYER    
             GROUP BY C.BUYER_ID) TA,
           (SELECT A.BUYER_ID AS CID,
                   A.BUYER_NAME AS CNAME,
                   SUM(B.CART_QTY*C.PROD_PRICE) AS CSUM
              FROM BUYER A, CART B, PROD C
             WHERE B.CART_PROD=C.PROD_ID
               AND C.PROD_BUYER=A.BUYER_ID
               AND B.CART_NO LIKE '202004%'
             GROUP BY A.BUYER_ID, A.BUYER_NAME) TB                  
    WHERE TA.BID(+)=TB.CID --외부조인조건//데이터 적은 쪽에 (+)를 써줌 확장해달라는뜻.
    ORDER BY 1;

사용예)사원테이블에서 사원의 평균급여보다 더 많은 급여를 받는 사원을 조회하시오.
      Alias는 사원번호,사원명,부서코드,급여
      SELECT A.EMPLOYEE_ID AS 사원번호,
             A.EMP_NAME AS 사원명,
             A.DEPARTMENT_ID AS 부서코드,
             A.SALARY AS 급여
        FROM HR.employees A,
            (SELECT AVG(SALARY) AS BSAL  --평균
               FROM HR.employees) B     --SELECT절에서 일반컬럼이 없으면 GROUP BY절 X
       WHERE A.SALARY>B.BSAL  --SALARY를 평균과 비교했을 때 더 크면 출력 // Non Equi-Join (조인조건)
       ORDER BY 3;
    --결과 51명 (부서코드가 NULL인 사람이 1명있음)   
    --부서명을 출력한다->   DEPARTMENTS 테이블 필요 -> 조인조건까지 다 쓰면 NULL컬럼은 지워지면서 결과 50명
