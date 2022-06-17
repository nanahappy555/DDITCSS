2022-0502-01) 
1. VIEW
  - 테이블과 유사한 객체
  - '기존의 테이블이나 뷰에 대한 SELECT문의 결과 집합'에 이름을 부여한 객체 -- 이름이 부여되면 저장됨. 저장되면 다시 불러쓸수있다.
  - 필요한 정보가 여러 테이블에 분산 되어 있는 경우
  - 테이블의 모든 자료를 제공하지 않고 특정 결과만 제공하는 경우(보안)
  
  (사용형식)
  CREATE [OR REPLACE] VIEW 뷰이름[(컬럼list)] -- CREATE OR REPLACE 이렇게 항상 세트라고 생각하자 생략하지말고 
  AS                                         --컬럼list 뷰에서 사용할 컬럼명 ->안쓰면?  1.SELECT문에서 사용된 컬럼별칭이 VIEW의 컬럼명 2.(별칭이 없으면) SELECT문에서 사용된 컬럼명이 VIEW의 컬럼명
    SELECT 문
    [WITH READ ONLY]    --이것은 뷰에 대한 옵션! 둘 중 하나만 사용 가능.. 
    [WITH CHECK OPTION] --이것은 뷰에 대한 옵션! 둘 중 하나만 사용 가능.. 
    
    . 'REPLACE' : 이미 존재하는 뷰인 경우 대체
    . 'WITH READ ONLY' : 읽기전용 뷰 생성 --DML명령이 가능...//VIEW를 수정해도 원본테이블은 수정X // 이걸 안쓰면 뷰에서 수정하면 원본테이블에서도 수정됨(연동)
    . 'WITH CHECK OPTION' : 뷰를 생성하는 SELECT문의 조건을 위배하는 DML명령을 뷰에서 실행할때 오류발생 --DML명령이 아예 금지
    --EX)마일리지3000이상회원 조건으로 VIEW를 만들었는데 마일리지를 써서 500이 된 회원은 뷰에서 삭제돼야하지만 VIEW에서 제거되지않게함

사용예) 회원테이블에서 마일리지가 3000이상인 회원의 회원번호,회원명,직업,마일리지로 구성된 뷰를 생성하시오.
       CREATE OR REPLACE VIEW V_MEM01 (MMID, MNAME, MJOB, MILE)--CREATE OR REPLACE 새로 생성 또는 이미 존재한다면 대치하세요(덮어쓰세요
       AS
        SELECT MEM_ID,      --여기서부터
               MEM_NAME,
               MEM_JOB,
               MEM_MILEAGE
          FROM MEMBER
         WHERE MEM_MILEAGE >= 3000      --여기까지 만들어지는 테이블이 VIEW V_MEM_01
사용예)생성된 뷰(V_MEM01)에서 'c001'회원의 마일리지를 2500으로 변경 --신용환
    UPDATE V_MEM01
       SET MILE=2500
     WHERE MMID='c001';    
   --  => 뷰 조건 (마일3000이상)을 만족하지 못해서 뷰에서 신용환이 탈락됨
   --  => 뷰를 변경했는데 원본도 같이 변경됐음.
     
    SELECT MEM_ID,MEM_NAME,MEM_MILEAGE
      FROM MEMBER
     WHERE MEM_ID='g001';  --송경희 마일 800
     
    UPDATE MEMBER
       SET MEM_MILEAGE=3800
     WHERE MEM_ID='g001';  --송경희의 마일 3800으로 업뎃   

    SELECT * FROM V_MEM01;  --송경희가 뷰 V_MEM01에 새로 추가됐음    

사용예) 회원테이블에서 마일리지가 3000이상인 회원의 회원번호,회원명,직업,마일리지로 구성된 뷰를 읽기전용으로 생성하시오. 
       CREATE OR REPLACE VIEW V_MEM01 (MMID, MNAME, MJOB, MILE)--CREATE OR REPLACE 새로 생성 또는 이미 존재한다면 대치하세요(덮어쓰세요
       AS
        SELECT MEM_ID,      
               MEM_NAME,
               MEM_JOB,
               MEM_MILEAGE
          FROM MEMBER
         WHERE MEM_MILEAGE >= 3000
         WITH READ ONLY; --뷰를 READ ONLY로

    SELECT * FROM V_MEM01;         

사용예)생성된 뷰(V_MEM01)에서 'g001'회원의 마일리지를 800으로 변경 --송경희 마일 현재 3800
    UPDATE V_MEM01  --VIEW업뎃
       SET MILE=800
     WHERE MMID='g001'; 
   --  ==> READ ONLY때문에 오류남
   
    UPDATE MEMBER   --원본테이블업뎃
       SET MEM_MILEAGE=800
     WHERE MEM_ID='g001';    
    -- ==>1행업데이트
        ==>VIEW에서도 송경희가 사라짐
        
사용예) 회원테이블에서 마일리지가 3000이상인 회원의 회원번호,회원명,직업,마일리지로 구성된 뷰를 WITH CHECK OPTION으로 생성하시오. 
       CREATE OR REPLACE VIEW V_MEM01 (MMID, MNAME, MJOB, MILE)--CREATE OR REPLACE 새로 생성 또는 이미 존재한다면 대치하세요(덮어쓰세요
       AS
        SELECT MEM_ID,      
               MEM_NAME,
               MEM_JOB,
               MEM_MILEAGE
          FROM MEMBER
         WHERE MEM_MILEAGE >= 3000
         WITH CHECK OPTION; --뷰를 WITH CHECK OPTION로        

사용예) 생성된 뷰에서 이혜나회원(e001)의 마일리지를 2500으로 변경   --원래 6500
    UPDATE V_MEM01
       SET MILE=2500
     WHERE MMID='e001';
   --  ==> WITH CHECK OPTION때문에 오류남 (뷰의 WHERE절 마일3000이상과 위배되는 내용이라서)     

사용예) 신용환 회원('c001')마일리지를 MEMBER테이블에서 3500으로 변경 
    UPDATE MEMBER
       SET MEM_MILEAGE=3500
     WHERE MEM_ID='c001';
  -- ==>원본테이블은 언제나 변경가능 
  
사용예) 오철희 회원('k001')마일리지를 뷰에서 4700으로 변경 
    UPDATE V_MEM01
       SET MILE=4700
     WHERE MMID='k001';
  -- ==>1행 업데이트 성공 (뷰의 WHERE절 마일3000이상 조건에 위배되지 않음)
  
  --현재 V_MEM01에는 7명의 회원이 있음
    UPDATE MEMBER
       SET MEM_MILEAGE=2500
     WHERE MEM_ID='k001';
  -- ==>1행 업데이트 성공
  --V_MEM01에는 6명의 회원이 있음     