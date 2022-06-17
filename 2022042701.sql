2022-0427-01)서브쿼리 
    - SQL문 안에 존재하는 또 다른 SQL문 --서브쿼리를 포함하고 있는 쿼리는 메인쿼리
    - SQL문장 안에 보조로 사용되는 중간결과를 반환하는 SQL문
    - 알려지지 않은 조건에 근거한 값들을 검색하는 SELECT문에 사용
    - 서브쿼리는 검색문(SELECT)뿐만 아니라 DML(INSERT,UPDATE,DELETE)문에서도 사용됨
    - 서브쿼리는 '()'안에 기술되어야 함(단, INSERT문에 사용되는 SUBQUERY는 제외)
    - 서브쿼리는 반드시 연산자 오른쪽에 기술해야함 --연산자를 쓴다...? =>WHERE절
    - 단일 결과 반환 서브쿼리(단일행 연산자:>,<.>=,<=,=,!=) --양쪽 결과 하나씩이어야됨. 단일과 다중을 비교하면 오류남
      vs 복수 결과 반환 서브쿼리(복수행 연산자: IN ALL, ANY, SOME, EXISTS) 
    - 연관성 있는 서브쿼리 vs 연관성 없는 서브쿼리 --대부분 연관성有(JOIN)
    - 일반서브쿼리 vs in-line 서브쿼리 vs 중첩서브쿼리
    --서브쿼리 위치. 별로 중요하지 않음. 결과만 나오면 정답.
    SELECT절 일반서브쿼리
    FROM절 in-line 서브쿼리 OR in-line view 서브쿼리 in-line 서브쿼리는 반드시 독립 실행 되어야 한다
    WHERE절 중첩서브쿼리
    
    --결과가 하나가 오냐 여러개가 오냐에 따라 단일행,다중행 서브쿼리
    --결과는 메인쿼리에만 출력되고 서브쿼리는 중간결과, 사용해야할 쿼리를 만들어내는 것
    
    --어떤부분이 메인쿼리를 담당하고 어떤부분이 서브쿼리를 담당할 것인지를 생각한다.
    
 1. 연관성 없는 서브쿼리 
  - 메인쿼리의 테이블과 서브쿼리의 테이블이 조인으로 연결되지 않은 경우
사용예)사원테이블에서 사원들의 평균급여보다 많은 급여를 받는 사원을 조회하시오.
     Alias는 사원번호,사원명,부서명,급여
( 메인쿼리 : 사원들의 사원번호,사원명,부서명,급여를 조회 )
    SELECT A.EMPLOYEE_ID AS 사원번호,
           A.EMP_NAME AS 사원명,
           B.DEPARTMENT_NAME AS 부서명,
           A.SALARY AS 급여
      FROM HR.employees A,HR.departments B
     WHERE A.DEPARTMENT_ID=B.DEPARTMENT_ID
       AND A.SALARY>(평균급여);
( 서브쿼리 : 평균급여 )
  SELECT AVG(SALARY)
    FROM HR.employees
    
(결합)  
  SELECT A.EMPLOYEE_ID  AS 사원번호,
         A.EMP_NAME AS 사원명,
         B.DEPARTMENT_NAME AS 부서명,
         A.SALARY AS 급여
    FROM HR.EMPLOYEES A,HR.DEPARTMENTS B 
   WHERE A.DEPARTMENT_ID=B.DEPARTMENT_ID
     AND A.SALARY>(SELECT AVG(SALARY)
                     FROM HR.employees);
    --이 테이블은 몇번 실행될까? 사원수만큼 실행됨. 10만명이 있다면 첫번째 사람과 서브쿼리의 평균계산 후 비교. 두번째사람과 서브쿼리 평균계산 후 비교... 10만번해야됨
    --10만번 실행하는것보다 한번만 실행하고 결과만 계속 갖다쓰는게 빠르다

(평균급여 출력)  
  SELECT A.EMPLOYEE_ID  AS 사원번호,
         A.EMP_NAME AS 사원명,
         B.DEPARTMENT_NAME AS 부서명,
         A.SALARY AS 급여,
         (SELECT ROUND(AVG(SALARY))
            FROM HR.EMPLOYEES) AS 평균급여
    FROM HR.EMPLOYEES A,HR.DEPARTMENTS B 
   WHERE A.DEPARTMENT_ID=B.DEPARTMENT_ID
     AND A.SALARY>(SELECT AVG(SALARY)
                     FROM HR.employees);  
    --이 테이블은 몇번 실행될까? WHERE절에 있는 서브쿼리 107번(사원수) + 평균급여가 만족되는 결과 50(=인출되는결과50행) = 157번 실행됨

(in-line view 서브쿼리)  --근데 얘는 조인되니까 연관성 있는 서브쿼리임!
  SELECT A.EMPLOYEE_ID  AS 사원번호,
         A.EMP_NAME AS 사원명,
         B.DEPARTMENT_NAME AS 부서명,
         A.SALARY AS 급여,
         ROUND(C.ASAL) AS 평균급여  --조인사용됨
    FROM HR.EMPLOYEES A,HR.DEPARTMENTS B,
         (SELECT AVG(SALARY) AS ASAL --평균. // 서브쿼리의 컬럼은 출력용이 아닌 참조용이라 별칭을 영어로 써준다(오라클영어최적화)
                     FROM HR.employees) C --테이블 총 3개
   WHERE A.DEPARTMENT_ID=B.DEPARTMENT_ID
     AND A.SALARY>C.ASAL; 
  --이 테이블은 몇 번 실행될까? C테이블=서브쿼리는 딱 한번 실행됨.
  
 2. 연관성 있는 서브쿼리  
  - 메인쿼리와 서브쿼리가 조인으로 연결된 경우
  - 대부분의 서브쿼리
  
사용예)직무변동테이블(JOB_HISTORY)과 부서테이블의 부서번호가 같은 자료를 조회하시오.  
      Alias는 부서번호,부서명 이다.
      SELECT A.DEPARTMENT_ID AS 부서번호, 
             A.DEPARTMENT_NAME AS 부서명
        FROM HR.departments A
       WHERE A.DEPARTMENT_ID=(SELECT DEPARTMENT_ID
                                FROM HR.JOB_HISTORY B
                               WHERE B.DEPARTMENT_ID=A.DEPARTMENT_ID);   
    --single-row subquery returns more than one row 
    --하나의 행이 반환되어져야할 곳에 사용된 서브쿼리에서 여러개의 행이 반환돼서 실행할수없음
    --A.DEPARTMENT_ID 1개 VS 서브쿼리 여러개 비교라서 =연산자를 쓸 수 없음
    (해결) 근데 억지로 서브쿼리 쓴거고 조인만 써도 됨~
    (IN 연산자 이용)
      SELECT A.DEPARTMENT_ID AS 부서번호, 
             A.DEPARTMENT_NAME AS 부서명
        FROM HR.departments A
       WHERE A.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID       --IN =ANY =SOME 오른쪽에 있는 결과가 하나라도 같으면 성립
                                   FROM HR.JOB_HISTORY);  --<조인됐음.연관성있는쿼리
    --FROM절 실행-> HR.departments 메모리에 갖다놓음 ->조건절실행-> A.DEPARTMENT_ID 메모리에 갖다놓음 ->메모리에 HR.departments이미 있으니까 서브쿼리 안에서 HR.departments를 사용할 수 있음 (=A.DEPARTMENT_ID)
    (EXISTS 연산자 이용) EXISTS 다음에 나온 서브쿼리의 결과가 1행이라도 있으면 열은 무슨 열이 와도 참. 테이블에 없는 열이 와도 상관없음. 데이터가 없을 때 거짓
      SELECT A.DEPARTMENT_ID AS 부서번호, 
             A.DEPARTMENT_NAME AS 부서명
        FROM HR.departments A
       WHERE EXISTS (SELECT 1 --출력이 있나 없나가 중요해서 DEPARTMENT_ID가 아닌 *를 써도 실행됨 
                       FROM HR.JOB_HISTORY B
                      WHERE B.DEPARTMENT_ID=A.DEPARTMENT_ID);    
                    --그래서 EXISTS쓸때 서브쿼리의 셀렉트절은 보통 1을 씀.
                    --B.DEPARTMENT_ID=A.DEPARTMENT_ID서로 같은 컬럼이 있으면 보통 1을 씀. 이 1은 아무 의미 없음. 그냥 출력만 되면 참이니까.
                    --참이면 바깥쪽 메인쿼리가 실행되어 출력됨

사용예)2020년 5월 판매된 상품별 판매집계 중 금액기준 상위 3개 상품 판매집계정보를 조회하시오.
    Alias 상품코드,상품명,거래처명,판매금액합계
    --메인쿼리와 서브쿼리를 나눠서 생각해보자...
(메인쿼리:금액 기준 상위 3개 상품에 대한 상품코드,상품명,거래처명,판매금액합계를 출력)
    SELECT 상품코드,상품명,거래처명,판매금액합계
      FROM PROD A,BUYER C
     WHERE A.PROD_ID --상위 3개 상품의 제품코드
     
(서브쿼리:판매금액기준으로 판매정보 추출)
    SELECT A.CART_PROD AS CID, --CID는 상품코드
          SUM(A.CART_QTY*B.PROD_PRICE) AS CSUM
      FROM CART A, PROD B
     WHERE A.CART_PROD=B.PROD_ID
       AND A.CART_NO LIKE '2020050%' --LIKE는 문자열
     GROUP BY A.CART_PROD
     ORDER BY 3 DSEC;

(결합)   
  SELECT C.CID AS 상품코드,
         C.CNAME AS 상품명,
         B.BUYER_NAME AS 거래처명,
         C.CSUM AS 판매금액합계
    FROM PROD A, BUYER B,
         (SELECT A.CART_PROD AS CID,
                 B.PROD_NAME AS CNAME,
                 SUM(A.CART_QTY*B.PROD_PRICE) AS CSUM
            FROM CART A, PROD B
           WHERE A.CART_PROD=B.PROD_ID
             AND A.CART_NO LIKE '202005%'
           GROUP BY A.CART_PROD,B.PROD_NAME
           ORDER BY 3 DESC) C
   WHERE A.PROD_ID=C.CID
     AND A.PROD_BUYER=B.BUYER_ID
     AND ROWNUM<=3;   
      
사용예)2020년 상반기에 구매액기준 1000만원 이상을 구매한 회원정보를
      조회하시오.
      Alias는 회원번호,회원명,직업, 구매액, 마일리지
1. (메인쿼리:회원정보 조회. 회원번호,회원명,직업, 구매액, 마일리지
        조건:2020년 상반기에 구매액기준 1000만원 이상을 구매한 회원) =서브쿼리
        SELECT A.MEM_ID AS 회원번호,
               A.MEM_NAME AS 회원명,
               A.MEM_JOB AS 직업,
               B.(????) AS 구매액,
               A.MEM_MILEAGE AS 마일리지
          FROM MEMBER A,
              (1000만원 이상 구매한 회원)B =서브쿼리
         WHERE A.MEM_ID =B.CART_MEMBER      
2. (서브쿼리:2020년 상반기에 구매액기준 1000만원 이상을 구매한 회원) --서브쿼리를 구성할 때는 전체 구조를 봐야함. A와 B(서브쿼리)에 공통컬럼이 반드시 있어야 함
    --1. Q.서브쿼리의 SELECT절에는 뭐가 나올까?
    --   A.고객번호(A테이블과 조인.A와 B에 동시에 존재하는 공통컬럼이어야함)
    --2. 회원별 구매금액 합계>=1000만원
        SELECT A.CART_MEMBER AS BID,
               SUM(A.CART_QTY*B.PROD_PRICE) AS BSUM
          FROM CART A, PROD B --단가를 가져오기 위해 JOIN
         WHERE A.CART_PROD=B.PROD_ID
           AND SUBSTR(A.CART_NO,1,6) BETWEEN '202001' AND '202006'--LIKE안되는 이유 범위가 있어서 안됨. 그리고 날짜 8자 자르면 TO_DATE로 캐스팅까지 해줘야해서 번거로움
         GROUP BY A.CART_MEMBER
        HAVING SUM(A.CART_QTY*B.PROD_PRICE) >=10000000; --집계함수????? WHERE못쓰고 HAVING절 쓴다
        
3. (결합-inline-view서브쿼리) 서브쿼리 실행된 결과만 B(from절)에 걸림. 그래서 똑같은 별칭을 써도 상관없음    
        SELECT A.MEM_ID AS 회원번호,
               A.MEM_NAME AS 회원명,
               A.MEM_JOB AS 직업,
               B.BSUM AS 구매액,
               A.MEM_MILEAGE AS 마일리지
          FROM MEMBER A,                                        --Q. BID나 BSUM같은 컬럼 별칭을 쓴느 이유?
              (SELECT A.CART_MEMBER AS BID,                     --   만약 서브쿼리에 A.CART_MEMBER가 아닌 CART_MEMBER라고만 썼으면 별칭을 써줄 필요가 없다.
                     SUM(A.CART_QTY*B.PROD_PRICE) AS BSUM       --   A.CART_MEMBER라고 썼는데 별칭이 없으면 메인쿼리에서 B.A.CART_MEMBER라고 써줘야하고 그럼 에러가 난다.
                 FROM CART A, PROD B --단가를 가져오기 위해 JOIN
                WHERE A.CART_PROD=B.PROD_ID
                      AND SUBSTR(A.CART_NO,1,6) BETWEEN '202001' AND '202006'--LIKE안되는 이유 범위가 있어서 안됨. 그리고 날짜 8자 자르면 TO_DATE로 캐스팅까지 해줘야해서 번거로움
                GROUP BY A.CART_MEMBER
               HAVING SUM(A.CART_QTY*B.PROD_PRICE) >=10000000)B --=서브쿼리
         WHERE A.MEM_ID =B.BID;

4. (결합-중첩서브쿼리) --WHERE절은 테이블생성이 아닌 비교하고 사라져서 SELECT절에서 참조할 수 없음 (앞에도 나온내용같음..찾아서 정리)
        SELECT A.MEM_ID AS 회원번호,
               A.MEM_NAME AS 회원명,
               A.MEM_JOB AS 직업,
       --      B.BSUM AS 구매액,
               A.MEM_MILEAGE AS 마일리지
          FROM MEMBER A   
         WHERE A.MEM_ID IN(SELECT B.BID --=으로 쓰면 1개VS 8개라서 또 오류남 => IN으로 써줌
                             FROM (SELECT A.CART_MEMBER AS BID,     --중첩 서브쿼리 SUM은 컬럼으로 출력이 안됨
                                         SUM(A.CART_QTY*PROD_PRICE) --근데 왜 SUM햇냐? 구매액 합계 1000만원 이상인 사람을 찾아야해서 필요한 컬럼임.
                                     FROM CART A,PROD 
                                    WHERE A.CART_PROD=PROD_ID
                                      AND SUBSTR(A.CART_NO,1,6) BETWEEN '202001' AND '202006'
                                    GROUP BY A.CART_MEMBER
                                   HAVING SUM(A.CART_QTY*PROD_PRICE)>=10000000)B )  
                     
    --single-row subquery returns more than one row 
    --하나의 행이 반환되어져야할 곳에 사용된 서브쿼리에서 여러개의 행이 반환돼서 실행할수없음
    --1개 VS 서브쿼리 2개 컬럼 비교라서 =연산자를 쓸 수 없음   
    -- => 서브쿼리를 하나 더 써줘야됨