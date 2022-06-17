2022-0512-01)트리거(TRIGGER)
+ COMMIT ROLLBACK 쓸 수 없음
+ 특정 이벤트가 발생되기 전 혹은 발생된 후 자동적으로 호출되어 실행되는 일종의 PROCEDURE
 --프로시저 반환값X 함수 반환값O
고객이 구매 INSERT 후 반드시 재고변경UPDATE 프로시저가 생겨야 함 
=> 1.무언가 *이벤트*가 발생되고 프로시저를 만들어야 함
   2. 어느 *타이밍*에 트리거가 작동될 것 인가
--TRIGGER는 사이클이 되어 무한으로 돌아갈 위험성이 높다. => 여건을 엄격하게 제한함.
+ 트리거를 사용할 때 주의할 점
1. **테이블 상태가 변화되고, 내가 확인을 끝냈으면 바로 COMMIT을 해줘야 됨.** MUTABLE?
2. **트리거(DML명령에 의해서 다른 테이블에 변화가 발생)
주문 주문상세가 가지고 있어야 됨
회원이 주문을 함. 주문번호가 만들어짐. 주문상세에 10개가 들어가서 금액이 주문테이블에 들어감.
주문상세가서 다 지움. 그 주문번호에 해당되는 주문을 지움 주문테이블에서도 지워야됨
서로서로 영향. 사이클 발생을 막기 위한 오류가 IMMUTABLE =>행단위 테이블에서만 발생

(사용형식)
CREATE OR REPLACE TRIGGER 트리거명(TG_...)
    BEFORE|AFTER    INSERT|UPDATE|DELETE ON 테이블명
    [FOR EACH ROW]
    [WHEN 조건]
  [DECLARE]
    변수, 상수, 커서 선언
  BEGIN
    트리거 본문(TRIGGER BODY)
  END;
+ `BEFORE|AFTER` : 트리거의 본문이 실행되는 시점(이벤트 발생 전|발생 후) 대부분 AFTER
    EX) 보너스를 계산하기 전에 영업실적인 NULL인 사람의 영업실적 데이터를 0으로 변환하라(BEFORE)
+ `INSERT|UPDATE|DELETE` : 트리거의 발생 원인, `OR`로 조합 사용할 수 있음
    **트리거 본문에서 테이블명을 할 수 없다.(테이블 데이터 수정 불가능)**
+ `FOR EACH ROW` : 행단위 트리거인 경우 기술. 생략되면 문장단위 트리거
    의사레코드
    :NEW 새로운 자료/행을 지칭
    :OLD 이미 존재하고 있는 자료를 지칭할 때 (꺼내쓸 수 있음
+ `WHEN 조건` : 트리거가 실행되면서 지켜야할 조건. 조건에 맞는 데이터만 트리거 실행. 행단위 트리거에서만 사용가능.


(사용예)다음 조건에 맞는 사원테이블(EMPT)을 HR계정의 사원테이블로부터 구조와 데이터를 가져와 생성하시오.
컬럼 : 사원번호(EID), 사원명(ENAME), 급여(SAL), 부서코드(DEPTID), 영업실적(COM_PCT)

CREATE TABLE EMPT(EID,ENAME,SAL,DEPTID,COM_PCT) AS
        SELECT EMPLOYEE_ID,EMP_NAME,SALARY,DEPARTMENT_ID,COMMISSION_PCT
          FROM HR.employees
         WHERE SALARY<=6000;
    SELECT * FROM EMPT;
    
(트리거 사용예)다음 데이터를 EMPT테이블에 저장하고 저장이 끝난 후
'새로운 사원정보가 추가 되었습니다'라는 메시지를 출력하는 트리거를 작성하시오 
=>한명이 추가될때마다 할 필요는 없고 `저장이 끝난 후`출력. 문장단위 트리거
[자료]
사원명     급여  부서코드  영업실적코드
----------------------------------------
홍길동     5500    80      0.25

1.트리거 작성
CREATE OR REPLACE TRIGGER TG_EMP_INSERT
        AFTER INSERT ON EMPT
    BEGIN
        DBMS_OUTPUT.PUT_LINE('새로운 사원정보가 추가 되었습니다');
    END;

Q. 새로운 자료가 INSERT 되었음이 프로그램이 인식되는 단계는 언제?
INSERT되고 COMMIT되거나 SELECT문을 사용했을 때

2.DEPT에 자료 삽입(서브쿼리)
INSERT INTO EMPT
    SELECT MAX(EID)+1,'홍길동',5500,80,0.25 FROM EMPT; 
COMMIT;    

INSERT INTO EMPT
    SELECT MAX(EID)+1,'강감찬',5800,50,NULL FROM EMPT;

3.실행결과
새로운 사원정보가 추가 되었습니다
1 행 이(가) 삽입되었습니다.

------------------------------------------------------------------------
(사용예)사원테이블에서 115,126,132번 사원을 퇴직처리하시오.
퇴직하는 사원정보는 사원테이블(EMPT)에서 삭제하시오.
--퇴직자 정보를 먼저 삭제하면 퇴직자테이블에 정보를 넣을 수 없음.
-- =>퇴직자테이블에 먼저 정보를 입력하고 사원테이블에서 삭제해야됨. => BEFORE트리거
삭제 전에 퇴직하는 사원정보를 퇴직자테이블(EM_RETIRE)에 저장하시오.
1. 삭제 전에 퇴직하는 사원정보를 퇴직자테이블(EM_RETIRE)에 저장하는 트리거
CREATE OR REPLACE TRIGGER tg_remove_empt
        BEFORE DELETE ON EMPT
        FOR EACH ROW --3명=>행단위트리거
    DECLARE
        V_EID empt.eid%TYPE;
        V_DID empt.deptid%TYPE;
    BEGIN --OLD:의사레코드
        V_EID:=(:OLD.EID);
        V_DID:=(:OLD.DEPTID);
        
        INSERT INTO EM_RETIRE
            VALUES(V_EID,V_DID,SYSDATE);
    END;

2. 퇴직자 자료 삭제
DELETE
  FROM EMPT
 WHERE EID IN (115,126,132);
 
3. EMPT테이블을 확인해보면 115,126,132사원이 삭제되고
EM_RETIRE테이블을 확인해보면 115,126,132사원이 저장됐음.
--------------------------------------------------------
