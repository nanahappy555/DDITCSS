2022-0426-01)집합연산자 -- 많이 씀 중요
 - SQL연산의 *결과*를 데이터 *집합(set)*이라고도 함
 - 이런 집합들 사이의 연산을 수행하기 위한 연산자를 집합연산자라 함
 - UNION, UNION ALL, INTERSECT, MINUS 가 제공
 - 집합연산자로 연결되는 각 SELECT문의 SELECT절의 ***컬럼의 갯수,순서,타입이 일치해야함*** --타입같으면 같은 컬럼은 아니라도 됨
 - ORDER BY 절은 맨 마지막 SELECT문에만 사용 가능
 - 출력은 첫번째 SELECT문의 SELECT절이 기준이 됨

∪ 교집합 A∪B A CUP B
∩ 합집합 A∩B A CAP B
--UNION : 집합 전체 & 중복배제
--UNION ALL : 집합 전체 & 중복포함. 두번,세번 중복된 갯수만큼 출력
--INTERSECT : 교집합. 공통부분만 출력
--MINUS : 차집합. 뭐를 앞에 쓰냐에 따라 결과가 달라짐. ex)4월에만 판매된 것. 4월-5678910월...
--SELECT결과=집합SET
 
(사용형식)
    SELECT 컬럼LIST       --기준
      FROM 테이블명
    [WHERE 조건]
    UNION|UNION ALL|INTERSECT|MINUS
    SELECT 컬럼LIST
      FROM 테이블명
    [WHERE 조건]
        :
    UNION|UNION ALL|INTERSECT|MINUS
    SELECT 컬럼LIST
      FROM 테이블명
    [WHERE 조건]
    [ORDER BY 컬럼명|컬럼index [ASC|DESC],...];

 1. UNION
  - 중복을 허락하지 않은 합집합의 결과를 반환
  - 각 SELECT문의 결과를 모두 포함
  
사용예)회원테이블에서 20대 여성회원과 충남거주회원의 회원번호, 회원명, 직업, 마일리지를 조회하시오.
      --20대 여성회원 - 거주지 상관X
      --충남거주회원 - 나이성별상관X
    1.20대 여성회원의 회원번호, 회원명, 직업, 마일리지  --11명
    (첫번째 SET)
    SELECT MEM_ID AS 회원번호,
           MEM_NAME AS 회원명,
           MEM_JOB AS 직업,
           MEM_MILEAGE AS 마일리지
      FROM MEMBER
     WHERE (EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM MEM_BIR))
            BETWEEN 20 AND 29
       AND SUBSTR(MEM_REGNO2,1,1) IN('2', '4');
    2.충남거주회원의 회원번호, 회원명, 직업, 마일리지   --3명
    (두번째 SET)
    SELECT MEM_ID AS 회원번호,
           MEM_NAME AS 회원명,
           MEM_JOB AS 직업,
           MEM_MILEAGE AS 마일리지
      FROM MEMBER
     WHERE MEM_ADD1 LIKE '충남%';
    3. 20대 여성 & 충남거주회원 (중복제외) --결과 13개 = 1명은 20대 여성이고 충남거주회원이다     
     SELECT MEM_ID AS 회원번호,
           MEM_NAME AS 회원명,
           MEM_JOB AS 직업,
           MEM_MILEAGE AS 마일리지
      FROM MEMBER
     WHERE (EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM MEM_BIR))
            BETWEEN 20 AND 29
       AND SUBSTR(MEM_REGNO2,1,1) IN('2', '4')
UNION
    SELECT MEM_ID AS 회원번호,
           MEM_NAME AS 회원명,
           MEM_JOB AS 직업,
           MEM_MILEAGE AS 마일리지
      FROM MEMBER
     WHERE MEM_ADD1 LIKE '충남%'
     ORDER BY 1;
     
 2. INTERSECT
  - 교집합(공통부분)의 결과 반환
사용예)회원테이블에서 20대 여성회원과 충남거주회원 중
     마일리지가 2000이상인 회원의 회원번호, 회원명, 직업, 마일리지를 조회하시오.  
     --20대 여성회원 UNION 충남거주회원 INTERSECT 마일리지>=2000
     SELECT MEM_ID AS 회원번호,
           MEM_NAME AS 회원명,
           MEM_JOB AS 직업,
           MEM_MILEAGE AS 마일리지
      FROM MEMBER
     WHERE (EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM MEM_BIR))
            BETWEEN 20 AND 29
       AND SUBSTR(MEM_REGNO2,1,1) IN('2', '4')
UNION
    SELECT MEM_ID AS 회원번호,
           MEM_NAME AS 회원명,
           MEM_JOB AS 직업,
           MEM_MILEAGE AS 마일리지
      FROM MEMBER
     WHERE MEM_ADD1 LIKE '충남%'
INTERSECT
    SELECT MEM_ID AS 회원번호,
           MEM_NAME AS 회원명,
           MEM_JOB AS 직업,
           MEM_MILEAGE AS 마일리지
      FROM MEMBER
     WHERE MEM_MILEAGE>=2000
     ORDER BY 1;

 3. UNION ALL
  - 중복을 허락하여 합집합의 결과를 반환
  - 각 SELECT문의 결과를 모두 포함(중복 포함)
사용예) --집합연산자를 통해 계층형쿼리 형태로 만드는 것.
    1)DEPTS테이블에서 PARENT_ID가 NULL인 자료의 부서코드,부서명,상위부서코드,레벨을 조회하시오
      단,상위부서코드는 0이고 레벨은 1이다 --레벨:의사컬럼=시스템에서 제공하는 컬럼 계층형쿼리는 Oracle에만 있음 많이사용
    SELECT DEPARTMENT_ID,
           DEPARTMENT_NAME,
           0 AS PARENT_ID, --레벨 의사컬럼 ROWNUM
           1 AS LEVELS
      FROM HR.DEPTS
     WHERE PARENT_ID IS NULL; --**NULL 비교는 =부등호로 할 수 없다.
    2)DEPTS테이블에서 NULL인 상위부서코드의 부서코드를 상위부서코드로 가진 부서의 부서코드, 부서명, 상위부서코드, 레벨을 조회하시오.
      단, 레벨은 2이고 부서명은 왼쪽에 4칸의 공백을 삽입 후 부서명 출력.  --LPAD RPAD
      --whrer절 총무기획부(=상위부서코드가 NULL)의 부서코드를 상위부서코드로 가지고 있는 부서=>총무기획부에 1차적으로 소속된 부서
      --LPAD(' ', 4*(2-1))라고 쓴 이유. 왜 2-1? 
      --2가 상수가 아닌 LEVEL2임. 
      -- -1을 쓰는 이유는 오라클은 0이 아닌 1부터 카운팅 되고 레벨1은 0칸공백인데 0칸공백이라고 하고싶어도 4*0으로 표현할수없다
    SELECT B.DEPARTMENT_ID,
           LPAD(' ', 4*(2-1))||B.DEPARTMENT_NAME AS DEPARTMENT_NAME, --2레벨일때는 4칸공백, 1레벨일때는 0칸공백. 얘는 계층형쿼리를 흉내낸거임
           B.PARENT_ID AS PARENT_ID,                                 --(1레벨-1)*4=0 0칸공백 (2레벨-1)*4=4 4칸공백 (3레벨-1)*4=8 8칸공백
           2 AS LEVELS
      FROM HR.DEPTS A, HR.DEPTS B --SELF JOIN A:상위부서가 NULL인 총무기획부-부서코드(=10) / B:총무기획부가 부모인 모든부서정보-부서코드
     WHERE A.PARENT_ID IS NULL --상위부서가 NULL인 총무기획부-부서코드(=10)=1개 B는 조건이 없어서 27개가 다 해당됨
       AND B.PARENT_ID=A.DEPARTMENT_ID; --->A테이블 1개와 B테이블의 27개 행의 부모부서코드를 다 비교함

    3)결합
(결합) 계층형 쿼리가 아니고 일반쿼리 썼을 때
    SELECT DEPARTMENT_ID,
           DEPARTMENT_NAME, --LPAD를 쓸 필요가 없음 공백이 0개니까
           NVL(PARENT_ID,0) AS PARENT_ID, --NVL안쓰고 PARENT_ID AS PARENT_ID라고 쓰면 NULL나옴
           1 AS LEVELS
      FROM HR.DEPTS
     WHERE PARENT_ID IS NULL
UNION ALL     
    SELECT B.DEPARTMENT_ID,
           LPAD(' ', 4*(2-1))||B.DEPARTMENT_NAME AS DEPARTMENT_NAME, --4*(1레벨-1) =1레벨0칸공백 4*(2레벨-1) =2레벨4칸공백 오라클은 0부터 카운트할수없음
           B.PARENT_ID AS PARENT_ID,
           2 AS LEVELS
      FROM HR.DEPTS A, HR.DEPTS B
     WHERE A.PARENT_ID IS NULL
       AND B.PARENT_ID=A.DEPARTMENT_ID;        
       
       
    4) 3개의 쿼리를 계층형 쿼리 형태로 SORT(소트)    0공백4공백8공백  
    SELECT DEPARTMENT_ID,
           DEPARTMENT_NAME,
           NVL(PARENT_ID,0) AS PARENT_ID, --NVL안쓰고 PARENT_ID AS PARENT_ID라고 쓰면 NULL나옴
           1 AS LEVELS,
           PARENT_ID||DEPARTMENT_ID AS TEMP --1.추가 컬럼 결과 10 10 10 10 (FROM절 테이블의 부모||자신
      FROM HR.DEPTS
     WHERE PARENT_ID IS NULL
UNION ALL     
    SELECT B.DEPARTMENT_ID,
           LPAD(' ', 4*(2-1))||B.DEPARTMENT_NAME AS DEPARTMENT_NAME,
           B.PARENT_ID AS PARENT_ID,
           2 AS LEVELS,
           B.PARENT_ID||B.DEPARTMENT_ID AS TEMP --2.추가 컬럼 결과 1020 1020 1020 (B의 부모||B자신
      FROM HR.DEPTS A, HR.DEPTS B
     WHERE A.PARENT_ID IS NULL
       AND B.PARENT_ID=A.DEPARTMENT_ID
UNION ALL       
    SELECT C.DEPARTMENT_ID,
           LPAD(' ', 4*(3-1))||C.DEPARTMENT_NAME AS DEPARTMENT_NAME,
           C.PARENT_ID AS PARENT_ID,
           3 AS LEVELS,
           B.PARENT_ID||C.PARENT_ID||C.DEPARTMENT_ID AS TEMP --3.추가 컬럼 1030210 1030220 1030230 (B의부모||C의부모||C자신
      FROM HR.DEPTS A, HR.DEPTS B, HR.DEPTS C
     WHERE A.PARENT_ID IS NULL
       AND B.PARENT_ID=A.DEPARTMENT_ID
       AND C.PARENT_ID=B.DEPARTMENT_ID
     ORDER BY 5;          
--1.2.3.을 추가해준 결과 TEMP컬럼을 기준으로 정렬되어 계층형 쿼리같은 형태가 된다.


**계층형쿼리
  - 계층적 구조를 지닌 테이블의 내용을 출력할 때 사용
  - 트리구조를 이용한 방식
  (사용형식)
  SELECT 컬럼 list
    FROM 테이블명
   START WITH 조건 --루트(root)노드 지정  --PARENT_ID IS NULL --루트노드를 지정하지 않으면 모든 노드가 루트노드가 된다.
   CONNECT BY NOCYCLE|PRIOR 계층구조 조건 --계층구조가 어떤식으로 연결 되었는지 설정
** CONNECT BY PRIOR 자식컬럼 = 부모컬럼 : 부모에서 자식으로 트리구성(TOP DOWN)
   CONNECT BY PRIOR 부모컬럼 = 자식컬럼 : 자식에서 부모로 트리구성(BOTTOM UP)
** PRIOR 사용위치에 따른 방향
   CONNECT BY PRIOR 컬럼1 = 컬럼2
                    <----------
   CONNECT BY 컬럼1 = PRIOR 컬럼2
                    ---------->
**계층형 쿼리 확장
   CONNECT_BY_ROOT 컬럼명 : 루트노드 찾기
   CONNECT_BY_ISCYCLE : 중복참조값 찾기
   CONNECT_BY_ISLEAF : 단말노드 찾기 --어떤게 제일 마지막 노드인지
   
   SELECT DEPARTMENT_ID AS 부서코드,
          LPAD(' ',4*(LEVEL-1))||DEPARTMENT_NAME AS 부서명, 4*(1레벨-1)=4*0=0 공백0개
          LEVEL AS 레벨
     FROM HR.DEPTS
    START WITH PARENT_ID IS NULL
    CONNECT BY PRIOR DEPARTMENT_ID=PARENT_ID --PRIOR:부모설정연산자 부모를 식별하는데 사용되는 조건 앞에 붙는다. 부모의 DEPARTMENT_ID가 자식의 PARENT_ID가 서로 같다.
 -- CONNECT BY PRIOR PARENT_ID = DEPARTMENT_ID;
    ORDER SIBLINGS BY DEPARTMENT_NAME; --숫자X 해당컬럼명을 기준으로 정렬



사용예)장바구니테이블에서 4월과 6월에 판매된 모든 상품정보를 중복되지 않게 조회하시오.
      Alias는 상품번호, 상품명,판매수량이며 상품번호 순으로 출력하시오.
--SUM을 써서 같은 품목끼리는 판매수량을 더한 값을 보여줌 (똑같은 품목이 여러줄 출력되는 것을 없앰.
--UNION을 써서 4월과 6월에 같은 품목 같은 수량이 판매됐다면 제거함
      SELECT A.CART_PROD AS 상품번호,
             B.PROD_NAME AS 상품명,
             SUM(A.CART_QTY) AS 판매수량
        FROM CART A, PROD B
       WHERE A.CART_PROD=B.PROD_ID
         AND A.CART_NO LIKE '202004%'
       GROUP BY A.CART_PROD,B.PROD_NAME
UNION
      SELECT A.CART_PROD AS 상품번호,
             B.PROD_NAME AS 상품명,
             SUM(A.CART_QTY) AS 판매수량
        FROM CART A, PROD B
       WHERE A.CART_PROD=B.PROD_ID
         AND A.CART_NO LIKE '202006%'
       GROUP BY A.CART_PROD,B.PROD_NAME
       ORDER BY 1;     
      
사용예)장바구니테이블에서 4월에도 판매되고 6월에 판매된 모든 상품정보를 조회하시오.
      Alias는 상품번호, 상품명이며 상품번호 순으로 출력하시오.
--판매수량을 출력 안하는 이유: 4월과 6월에 같은품목이 같은 수량 판매된 적이 없어서 수량까지 출력하면 결과가 아무것도 나오지 않는다.      
      SELECT A.CART_PROD AS 상품번호,
             B.PROD_NAME AS 상품명
        FROM CART A, PROD B
       WHERE A.CART_PROD=B.PROD_ID
         AND A.CART_NO LIKE '202004%'
INTERSECT
      SELECT A.CART_PROD AS 상품번호,
             B.PROD_NAME AS 상품명
        FROM CART A, PROD B
       WHERE A.CART_PROD=B.PROD_ID
         AND A.CART_NO LIKE '202006%'
       ORDER BY 1;     
      
사용예)장바구니테이블에서 4월과 6월에 판매된 상품 중 6월에만 판매된 상품정보를 조회하시오.
      Alias는 상품번호, 상품명,판매수량이며 상품번호 순으로 출력하시오.
      SELECT A.CART_PROD AS 상품번호,
             B.PROD_NAME AS 상품명,
             SUM(A.CART_QTY) AS 판매수량
        FROM CART A, PROD B
       WHERE A.CART_PROD=B.PROD_ID
         AND A.CART_NO LIKE '202004%'
       GROUP BY A.CART_PROD,B.PROD_NAME
UNION
      SELECT A.CART_PROD AS 상품번호,
             B.PROD_NAME AS 상품명,
             SUM(A.CART_QTY) AS 판매수량
        FROM CART A, PROD B
       WHERE A.CART_PROD=B.PROD_ID
         AND A.CART_NO LIKE '202006%'
       GROUP BY A.CART_PROD,B.PROD_NAME 
MINUS
      SELECT A.CART_PROD AS 상품번호,
             B.PROD_NAME AS 상품명,
             SUM(A.CART_QTY) AS 판매수량
        FROM CART A, PROD B
       WHERE A.CART_PROD=B.PROD_ID
         AND A.CART_NO LIKE '202004%'
       GROUP BY A.CART_PROD,B.PROD_NAME
       ORDER BY 1;