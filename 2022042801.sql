2022-04-28-01)SUBQUERY와 DML명령
1. INSERT 문에서 서브쿼리 사용
  - INSERT INTO 문에 서브쿼리를 사용하면 VALUES절이 생략됨
  - 사용되는 서브쿼리는 '( )'를 생략하고 기술함
(사용형식)
    INSERT INTO 테이블명[(컬럼명[,컬럼명,...])] --컬럼명을 생략하면 모든 컬럼에 값을 지정해야됨.
        서브쿼리;
        . '테이블명( )'에 기술된 컬럼의 갯수,순서,타입과
          서브쿼리 SELECT문의 SELECT절의 컬럼의 갯수,순서,타입은 반드시 일치해야 함
        
사용예) 재고수불테이블의 년도에는 '2020'을 상품코드에는 상품테이블의 모든 상품코드를 입력하시오.
    INSERT INTO REMAIN(REMAIN_YEAR,PROD_ID)
        SELECT '2020', PROD_ID
          FROM PROD;
          
    SELECT *  FROM REMAIN;    --REMAIN_DATE가 (null)로 나오면 정상임
    
    DELETE FROM REMAIN;  --REMAIN_DATE를 오늘 날짜로 넣어버려서 한번 다 삭제함 ㅠㅠ. . . . .

--입고량이 추가되면 UPDATE    
2. UPDATE 문에서 서브쿼리 사용
(사용형식)
    UPDATE 테이블명 [별칭]
       SET (컬럼명[,컬럼명,...])=(서브쿼리)
    [WHERE 조건];   --변경시킬 테이블에서 변경시킬 행. 생략하면 변경시킬 테이블을 모두 변경

    예시)   **실행하지말것**
    UPDATE MEMBER
       SET MEM_NAME='홍길동', --변경할 값이 여러개면 컬럼도 여러번 써야함
           MEM_BIR=TO_DATE('20011230') 
           
    --변경할 값이 여러개면 컬럼도 여러번 써야함
    --그럼 서브쿼리도 여러번 써야하나..?
    --
    
사용예)재고수불테이블(REAMAIN)에 기초재고를 설정하시오.    
      기초재고는 상품테이블의 적정재고량으로 하며 날짜는 2020년1월1일로 설정
      --3개 동시에 변경됨 기초재고,기말재고,날짜
      --원래대로 하면 서브쿼리를 세번 써야됨
    UPDATE REMAIN A
       SET (A.REMAIN_J_00,A.REMAIN_J_99,A.REMAIN_DATE)=
           (SELECT A.REMAIN_J_00+B.PROD_PROPERSTOCK,
                   A.REMAIN_J_99+B.PROD_PROPERSTOCK,
                   TO_DATE('20200101')
              FROM PROD B
             WHERE A.PROD_ID=B.PROD_ID) --서브쿼리 WHERE절은 변경시킬 값을 선택
     WHERE A.REMAIN_YEAR='2020'; --업데이트문에 걸리는 WHERE절은 변경할 데이터를 선택할 때
     
**여기까지 자료이월작업**     
자료 이월 작업이 필요한 이유?
제때 돈을 못내거나 못받는 미수금이 있을 수 있음.
선금을 주고 품목은 아직 못받은 미지급품이 있을 수 있음
해가 넘어가면 그 자료를 그대로 받아와야함.

사용예) 2020년 1월 제품별 매입수량을 조회하여 재고수불테이블을 변경하시오
    (메인쿼리)
     UPDATE REMAIN A
        SET (A.REMAIN_I, A.REMAIN_J_99, A.REMAIN_DATE)=  --누적시켜야 한다 ==추가 UPDATE&SET 한세트
            (서브쿼리1)
      WHERE A.REMAIN_YEAR='2020'
        AND A.PROD_ID IN(서브쿼리2);--인덱스를 신경써야한다/ 기본키는 자동으로 인덱스가 만들어진다/ WHERE절에서 모든 기본키의 언급이 반드시 있어야 한다
        
    (서브쿼리1:2020년 1월 제품별 매입수량)
     SELECT BUY_PROD,
            SUM(BUY_QTY)      
       FROM BUYPROD
      WHERE BUY_DATE BETWEEN TO_DATE ('20200101') AND TO_DATE('20200131')
      GROUP BY BUY_PROD;
      
    (서브쿼리2:2020년 1월 매입상품조회)
    
    (결합) 메인쿼리+서브쿼리1
     UPDATE REMAIN A
        SET (A.REMAIN_I, A.REMAIN_J_99, A.REMAIN_DATE)=  --UPDATE되어질 컬럼들
            (SELECT A.REMAIN_I+B.BSUM,A.REMAIN_J_99+B.BSUM,TO_DATE('20200201') --1월달에 있는거 + 2월에 새로 입고된 값 누적해야해서 + /출고면 1월-2월출고/ '20200201' 2월1일에 1월달 재고를 정리했다고 가정하고 2/1로 쓴거임
               FROM (SELECT BUY_PROD AS BID, --서브쿼리를 바로쓰면 매입수량만 나오는게 아니라 코드까지 같이나오기때문에 서브쿼리를 한번 더 쓴다(합계만 필요하니까 FROM절에 기술해서 맨먼저 실행 후 사라지는 걸 이용)
                            SUM(BUY_QTY) AS BSUM     
                       FROM BUYPROD
                      WHERE BUY_DATE BETWEEN TO_DATE ('20200101') AND TO_DATE('20200131')
                      GROUP BY BUY_PROD) B
              WHERE A.PROD_ID=B.BID)     
      WHERE A.REMAIN_YEAR='2020' --바깥쪽 WHERE절에 조건 기술 안하면 모든행이 변경된다
        AND A.PROD_ID IN(서브쿼리2);
        
    (서브쿼리2:2020년 1월 매입상품 조회) --39건 상품코드만
     SELECT DISTINCT BUY_PROD --DISTINCT 중복상품안나오게. 몇번팔렸나 상관없이 '종류'를 알기위해
       FROM BUYPROD
      WHERE BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200131');


(결합
     UPDATE REMAIN A
        SET (A.REMAIN_I, A.REMAIN_J_99, A.REMAIN_DATE)=  --UPDATE되어질 컬럼들
            (SELECT A.REMAIN_I+B.BSUM,A.REMAIN_J_99+B.BSUM,TO_DATE('20200201') --1월달에 있는거 + 2월에 새로 입고된 값 누적해야해서 + /출고면 1월-2월출고/ '20200201' 2월1일에 1월달 재고를 정리했다고 가정하고 2/1로 쓴거임
               FROM (SELECT BUY_PROD AS BID, --서브쿼리를 바로쓰면 매입수량만 나오는게 아니라 코드까지 같이나오기때문에 서브쿼리를 한번 더 쓴다(합계만 필요하니까 FROM절에 기술해서 맨먼저 실행 후 사라지는 걸 이용)
                            SUM(BUY_QTY) AS BSUM     
                       FROM BUYPROD
                      WHERE BUY_DATE BETWEEN TO_DATE ('20200101') AND TO_DATE('20200131')
                      GROUP BY BUY_PROD) B
              WHERE A.PROD_ID=B.BID)     
      WHERE A.REMAIN_YEAR='2020' --바깥쪽 WHERE절에 조건 기술 안하면 모든행이 변경된다
        AND A.PROD_ID IN(SELECT DISTINCT BUY_PROD
                           FROM BUYPROD
                          WHERE BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200131'));
    SELECT * FROM REMAIN;
    

사용예) 2020년 2월부터 4월까지 제품별 매입수량을 조회하여 재고수불테이블을 변경하시오   
     UPDATE REMAIN A
        SET (A.REMAIN_I, A.REMAIN_J_99, A.REMAIN_DATE)=  --UPDATE되어질 컬럼들
            (SELECT A.REMAIN_I+B.BSUM,A.REMAIN_J_99+B.BSUM,TO_DATE('20200430') --4월 30일에 재고를 정리했다고 가정
               FROM (SELECT BUY_PROD AS BID, --서브쿼리를 바로쓰면 매입수량만 나오는게 아니라 코드까지 같이나오기때문에 서브쿼리를 한번 더 쓴다(합계만 필요하니까 FROM절에 기술해서 맨먼저 실행 후 사라지는 걸 이용)
                            SUM(BUY_QTY) AS BSUM     
                       FROM BUYPROD
                      WHERE BUY_DATE BETWEEN TO_DATE ('20200201') AND TO_DATE('20200430')
                      GROUP BY BUY_PROD) B
              WHERE A.PROD_ID=B.BID)     
      WHERE A.REMAIN_YEAR='2020' --바깥쪽 WHERE절에 조건 기술 안하면 모든행이 변경된다
        AND A.PROD_ID IN(SELECT DISTINCT BUY_PROD
                           FROM BUYPROD
                          WHERE BUY_DATE BETWEEN TO_DATE('20200201') AND TO_DATE('20200430'));
    SELECT * FROM REMAIN;
    COMMIT;
    
--근데 재고파악은 물건이 팔릴때마다 재고가 줄어들어야해서 시간마다 재고갱신이 되어야함. 우리는 한달단위로 하고 있음 ㅋㅋ
--판매가 발생되어 재고가 변경되는 순간 변경되어야함 =>트리거를 쓰면 똑같이 UPDATE문을 쓰지만 자료를 자동으로 받아옴
사용예)2020년 4월 장바구니테이블에서 판매수량을 조회하여 재고수불테이블을 갱신하시오.  --제일 중요한 거 **수량**
     (메인쿼리)
     (서브쿼리1:2020년 4월 제품별 매출수량)
     SELECT CART_PROD AS BID,
                            SUM(CART_QTY) AS BSUM     
                       FROM CART
                      WHERE SUBSTR(CART_NO,1,8) LIKE '20200401'
                      GROUP BY CART_PROD;
                      
    (결합)                  
     UPDATE REMAIN A
        SET (A.REMAIN_O, A.REMAIN_J_99, A.REMAIN_DATE)=  --UPDATE되어질 컬럼들
            (SELECT A.REMAIN_O+B.BSUM,A.REMAIN_J_99-B.BSUM,TO_DATE('20200430') --매출량은 기존출고량+새로운출고량, 기말재고는 재고-매출수량
               FROM (SELECT CART_PROD AS BID,
                            SUM(CART_QTY) AS BSUM     
                       FROM CART
                      WHERE SUBSTR(CART_NO,1,8) LIKE'202004%'
                      GROUP BY CART_PROD) B
              WHERE A.PROD_ID=B.BID)     
      WHERE A.REMAIN_YEAR='2020'
        AND A.PROD_ID IN(SELECT DISTINCT CART_PROD
                           FROM CART
                          WHERE SUBSTR(CART_NO,1,8) LIKE'202004%');
    SELECT * FROM REMAIN;
    COMMIT;     
    
    집계를 내서 판매량 -> 
    재고를 변경
    
트리거 자동입출고모듈
**재고갱신을 위한 트리거
  - 입고발생시 자동으로 재고조정

CREATE OR REPLACE TRIGGER TG_INPUT
    AFTER INSERT ON BUYPROD --인서트 된 이후에 알아서 실행됨
    FOR EACH ROW
DECLARE
    V_QTY NUMBER:=0;
    V_PROD PROD.PROD_ID%TYPE;
    V_DATE DATE:=(:NEW.BUY_DATE);
BEGIN
    V_QTY:=(:NEW.BUY_QTY);
    V_PROD:=(:NEW.BUY_PROD); --BUY_PROD에 들어오는 새로운자료NEW
    
    UPDATE REMAIN A
       SET A.REMAIN_I=A.REMAIN_I+V_QTY,
           A.REMAIN_J_99=A.REMAIN_J_99+V_QTY,
           A.REMAIN_DATE=V_DATE
     WHERE A.PROD_ID=V_PROD;
     EXCEPTION WHEN OTHERS THEN --발생된 모든 오류를 걸러내주는 출력명령
       DBMS_OUTPUT.PUT_LINE('예외발생 : '||SQLERRM);  --SQLERRM : SQL에러메세지
END;

**상품코드 'P101000001' 상품 50개를 오늘날짜에 매입한다
  (매입단가는 210000원)
  재고상황          기 입 출 현
  2020  P10100001 33 38 5 66 2020/0430
  
  INSERT INTO BUYPROD
    VALUES(SYSDATE,'P101000001',50,210000);
    
  SELECT * FROM BUYPROD    
  
**서브쿼리를 이용한 테이블생성
  - CREATE TABLE 명령과 서브쿼리를 사용하여 테이블을 생성하고 해당되는 값을 복사할 수 잇음. --테스트용 샘으로 데이터를 가져온 임시테이블 만듦
  - 제약사항은 복사(생성)되지 않음
  (사용형식)
  CREATE TABLE 테이블명[(컬럼명[,컬럼명,...])]  --컬럼명 생략하면 입력한 테이블과 같은 컬럼명 전부 출력
    AS (서브쿼리);      --서브쿼리의 결과를 위에 쓴 컬럼명의 결과로 받아서 테이블이 생성됨
  (사용예) 재고수불테이블의 모든 데이터를 포함하여 새로운테이블을 생성하시오.
          테이블명은 TEMP_REMAIN이다.
  CREATE TABLE TEMP_REMAIN
    AS (SELECT * FROM REMAIN); --기본키,외래키는 복사가 안 됨. 행단위로 값만 복사해옴
    
  SELECT * FROM TEMP_REMAIN;
  
3. DELETE문에서 서브쿼리 사용
  ** DELETE문의 사용형식
    DELETE FROM 테이블명 //행 단위로 처리/
    [WHERE]조건;
    
(사용예)TEMP_REMAIN테이블에서 2020년 7월에 판매된 상품과 같은 코드의 자료를 삭제하시오
    (서브쿼리: 2020년 7월에 판매된 상품)
     SELECT DISTINCT CART_PROD --상품코드가 중복되지 않게 조회
       FROM CART
      WHERE CART_NO LIKE '202007%'
      
    DELETE FROM TEMP_REMAIN A
     WHERE REMAIN_YEAR='2020'
       AND A.PROD_ID IN(SELECT DISTINCT CART_PROD  ---- =은 단일행 서브쿼리에 사용되어지는 관계연산자이다, 서브쿼리의 결과가 20개라 =대신 IN 사용
                          FROM CART
                         WHERE CART_NO LIKE '202007%');
                         
                         
                         
                         
                         
                         
                         
                         SELECT A.CART_PROD AS 제품코드,
             B.PROD_NAME AS 제품명,
             SUM(A.CART_QTY) AS 판매수량합계,
             SUM(A.CART_QTY*B.PROD_PRICE) AS 판매금액합계 --수량*단가
        FROM CART A,PROD B                 --CART 테이블 별칭 A. 테이블은 AS필요없음 (설명노션)
       WHERE A.CART_PROD=B.PROD_ID   --JOIN조건
        AND /*1번*/ SUBSTR(A.CART_NO,1,8)>='20200601' AND
             SUBSTR(A.CART_NO,1,8)>='20200630' 
             /*--2번 SUBSTR*SUBSTR(A.CART_NO,1,6)='203006'
             /*3번 A.CART_NO LIKE'202006%' */ -- GROUP BY 뒤에 기술된 컬럼 기준으로 집계를 내는데 사용
      GROUP BY A.CART_PROD,B.PROD_NAME 
      ORDER BY 4 DESC; 