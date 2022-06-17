2022 - 0413 - 01)함수
 - 모든 사용자들이 공통의 목적으로 사용하도록 미리 프로그래밍되어 컴파일한 후 실행 가능한 형태로 저장된 모듈 --API
 - 문자열, 숫자, 날짜, 형변환, 집계(그룹)함수가 제공
1. 문자열함수
  1)CONCAT(c1,c2) --잘안씀 가독성 떨어져서. 주함수명(매개변수,매개변수) c=char 반드시 매개변수 2개가 있어야 함
   - 주어진 두 문자열 c1과 c2를 결합하여 새로운 문자열을 반환
   - 문자열 결합 연산자 '||'와 같은 기능
   --함수는 함수를 포함할 수 있다. CONCAT((X,Y),Z);
 (사용예)회원테이블에서 2000년 이후 출생한 회원정보를 조회하시오
        Alias는 회원번호,회원명,주민번호,주소이다.
        주민번호는 xxxxxx-xxxxxxx형식으로 주소는 기본주소와 상세주소가 공백 하나를 추가하여 연결할것
        SELECT MEM_ID AS 회원번호,
               MEM_NAME AS 회원명,
               CONCAT(CONCAT(MEM_REGNO1,'-'),MEM_REGNO1) AS 주민번호,   --함수를 포함하는 함수
               CONCAT(MEM_ADD1,' ') AS 주소
          FROM MEMBER
         WHERE SUBSTR(MEM_REGNO2,1,1) IN('3','4');
         
 2)LOWER(c1), UPPER(c1), INITCAP(c1)  --원래는 대소문자 구별 안하는데 ''작은따옴표로 묶이면 아스키코드값으로 변환 아스키코드는 대소문자구별되어있어서 이때만 구별됨
  . LOWER(c1) : 주어진 문자열 c1의 문자를 모두 소문자로 변환
  . UPPER(c1) : 주어진 문자열 c2의 문자를 모두 대문자로 변환
  . INITCAP(c1) : c1 내의 문자 중 단어의 첫 문자만 대문자로 변환 --예)미국식 이름
   --찾으려는 비교대상의 값이 대문자인 경우 이 함수를 이용하면 데이터베이스의 원본에서의 원하는 데이터서치 가능
   사용예)회원테이블에서 회원번호'F001'회원정보를 조회하시오
        Alias는 회원번호, 회원명, 주소, 마일리지이다
        
        SELECT MEM_ID AS 회원번호, 
               MEM_NAME AS 회원명, 
               MEM_ADD1||' '||MEM_ADD2 AS 주소, 
               MEM_MILEAGE AS 마일리지
        
        FROM MEMBER
        
        WHERE UPPER(MEM_ID)='F001';  --내가 찾는 데이터가 소문자인지 대문자인지 모를때 f001 결과1개출력
      --WHERE UPPER(MEM_ID)='f001'; --이렇게 하면 위에 목록만 나오고 결과가 안나온다
        
       -------------------------------------------------------------------
 
        SELECT EMPLOYEE_ID as origin,
               LOWER(FIRST_NAME)||' '||UPPER(LAST_NAME) as 소대,
               LOWER(FIRST_NAME||' '||LAST_NAME) as 소,
               INITCAP(LOWER(FIRST_NAME||' '||LAST_NAME)) as 첫대,
               EMP_NAME
          FROM hr.employees;   
          
          
 3)LPAD(c1,N[,c2]), RPAD(c1,N[,c2])    --엘패드,알패드 공백에 채워지는 걸 패딩된다고 한다 / 특정문자열을 들쑥날쑥하게 출력하거나(계층형:레벨이 분류된 쿼리..오라클에서만 제공하는 문법)빈공간을 왼쪽에 만드는 L, 오른쪽에 만들면 R
  . LPAD(c1,N[,c2]) : n자리에 주어진 문자열 c1을 채우고 남는 왼쪽공간에 c2 문자열을 채움, c2가 생략되면 공백이 채워짐
  . RPAD(c1,N[,c2]) : n자리에 주어진 문자열 c1을 채우고 남는 오른쪽공간에 c2 문자열을 채움, c2가 생략되면 공백이 채워짐  
  
  사용예)
       SELECT '1,000,000',
              LPAD('1,000,000',15,'*'),
              RPAD('1,000,000',15,'*')
         FROM DUAL;
        ---------------------------------------------------------
  
  --몰라도 되고 설명만 읽어보기      
 사용예) 기간(년과 월)을 입력 받아 매출액 기준 상위 5개 제품의 매출집계를 구하는 프로시져를 작성하시오 --RPAD를 보여주는 예, 식 다몰라도 됨
        CREATE OR REPLACE PROCEDURE PROC_CALCULATE( ---반환값이 없는 함수
            P_PERIOD VARCHAR2)
        IS
            CURSOR CUR_TOP5 IS                      ---커서를 만들었다
              SELECT TA.CID AS TID, TA.CSUM AS TSUM ---
                FROM (SELECT A.CARK_PROD AS CID,
                           SUM(A.CART_QTY*B.PROD_PRICE) AS CSUM
                       FROM CART A, PRDO B
                      WHERE A.CART_PROD=B.PROD_ID
                        AND A.CART_NO LIKE P_PERIOD||'%'
                       GROUP AY A.CART_PRDO
                      ORDER BY 2 DESC) TA
               WHERE ROWNUM<=5;
        V_PNAME PROD.PROD_NAME%TYPE;
        V_PES VARCHAR2(100);
    BEGIN
        FOR REC IN CUR_TOP5 LOOP
          SELECT PROD_NAME INTO v_PNAME
            FROM PROD
            WHERE PROD_ID=REC.TID;
        V_REC:=REC.TID||'   '||RPAD(V_PNAME,30)||TO_CHAR(TSUM,'99,999,999'); 
        DBMS_OUTPUT.PUT_LINE(V_RES);
    END LOOP;
  END;
  
  EXECUTE PROC_CALCULATE('202007');      --나중에 계층형쿼리 하겠습니다 RPAD를 보여주기 위한 예시였습니다~
 
 
 4) LTRIM(c1 [,c2]), RTRIM(c1 [,c2])  --문자열을 찾아 삭제하기 위해 쓰임..고정길이 CHAR로 저장하면 
  - LTRIM(c1 [,c2]) : c1 문자열에서 왼쪽 시작위치에서 c2문자열 찾아 같은 문자열이 있으면 삭제, c2가 생략되면 왼쪽 공백을 제거
  - RTRIM(c1 [,c2]) : c1 문자열에서 오른쪽 시작위치에서 c2문자열 찾아 같은 문자열이 있으면 삭제, c2가 생략되면 오른쪽 공백을 제거 
  
  (사용예)
    SELECT LTRIM('PERSIMMON BANNA APPLE', 'ER'),-- ER로 시작되는 문자가 없어서 / PER은 삭제되지 않음
           LTRIM('PERSIMMON BANNA APPLE', 'PE'),
           LTRIM('   PERSIMMON BANNA APPLE')
      FROM DUAL;
      
    SELECT RTRIM('...ORACLE...','.'),
           RTRIM('...OR...OR...','OR...'),   --OR이 없어도 ...는 일치하니까 ...는 지움
           RTRIM('...          '), --오른쪽 공백 삭제
           RTRIM('...          ') AS "C" --오른쪽 공백 삭제 & "C"의 길이에 맞춰서 ...만 남음
      FROM DUAL;       
      
 5) TRIM(c1)    --무효한 공백 : 데이터 나오기 전, 데이터 끝난 후 존재하는 공백=무의미/ 유효한 공백 : 데이터 중간에 나오는 공백은 반드시 존재해야하는 공백
    - c1문자열 왼쪽과 오른쪽에 있는 모든 공백을 제거
    - 다만 문자열 내부의 공백은 제거하지 못함. (REPLACE로 제거)
  (사용예)
   SELECT TRIM('     QWER    '),
          TRIM('  무궁화 꽃이 피었습니다!!   ')
     FROM DUAL;
  (사용예시) 오늘이 2020년 4월 1일이라고 할때 장바구니테이블의 장바구니번호(CART_NO)를 생성하시오.
  --YYYYMMDD00000(날짜8자+로그인순서5) 중 9번째 글자(로그인5)부터 나머지를 다 뗌 (함수) -> 숫자로 변환->제일 큰 값을 구함-> +1 -> 다섯자리 문자/열로 변환 -> 합쳐 ->20200401 00004공백이 생김(변환오차)
   SELECT TO_CHAR(SYSDATE,'YYYYMMDD')||
          TRIM(TO_CHAR(MAX(TO_NUMBER(SUBSTR(CART_NO, 9))) +1, '00000'))     --SUBSTR(**,9)9번째 글자부터 나머지 다 / '00000'은 유효숫자(자리수)
     FROM CART
    WHERE CART_NO LIKE TO_CHAR(SYSDATE,'YYYYMMDD')||'%';  -- %이후의 모든 문자열을 허용 / LIKE로 출력되니까 문자임.=>숫자변환필요 => SELECT절에 TO_NUMBER로 캐스팅
   
    SELECT TO_CHAR(SYSDATE,'YYYYMMDD')||
          TRIM(TO_CHAR(MAX(TO_NUMBER(SUBSTR(CART_NO, 9))) +1, '00000'))   --형변환을 직접한 것 
          MAX(CART_NO)+1   --편법 자동형변환.AUTOCASTING. 덧셈이 되려면 앞 뒤 데이터가 형이 같아야 함. 
     FROM CART             --JAVA와 다르게 ORACLE은 문자+숫자 => 숫자+숫자 숫자 우선으로 캐스팅됨 => 숫자로 구성되게 만들면 형변환이 편하다..
    WHERE CART_NO LIKE TO_CHAR(SYSDATE,'YYYYMMDD')||'%'; 

 6) SUBSTR(c,m[,n]) --가장 많이 쓰임
  - 주어진 문자열 c에서 m번째에서 n개의 문자열을 추출하여 반환
  - n이 생략되면 m번째 이후의 모든 문자열을 추출하여 반환
  - m은 1부터 시작함(0이 기술되면 1로 간주)
  - m이 음수이면 오른쪽부터 처리됨
  - n보다 남은 문자 수가 작은 경우 n이 생략된 경우와 동일 --나머지 모든 문자열 추출
  (사용예)
   SELECT SUBSTR('나보기가 역겨워 가실때에는', 5,6) AS COL1,
          SUBSTR('나보기가 역겨워 가실때에는', 5) AS COL2,
          SUBSTR('나보기가 역겨워 가실때에는', 0,6) AS COL3, --0 =>1
          SUBSTR('나보기가 역겨워 가실때에는', 5,30) AS COL4, --n을 안 쓴 것과 같음 ('***',5)
          SUBSTR('나보기가 역겨워 가실때에는', -5,6) AS COL5
     FROM DUAL;           
  
  (사용예)회원테이블에서 거주지별 회원수를 조회하시오. --거주지 별로 모으고(묶음) -> 행의 갯수 COUNT =>회원수
         Alias는 거주지, 회원수이다.
    SELECT SUBSTR(MEM_ADD1,1,2) AS 거주지,
           COUNT(*) AS 회원수
      FROM  MEMBER
     GROUP BY SUBSTR(MEM_ADD1,1,2);  --특정컬럼 기준으로 합계
     
 7) REPLACE(c1,c2[,c3])  치환 --자주 쓰진 않지만 다른거보단 자주 씀.. 폰번호 01012345678/010.1234.5678/010-1234-5678같은 데이터의 형식을 통일하려고 할 때 사ㅛㅇ
  - 문자열 c1에서 c2문자열을 찾아 c3문자열로 치환
  - c3문자열이 생략되면 찾은 c2문자열을 삭제함
  - c3가 생략되고 c2를 공백으로 기술하면 단어 내부의 공백을 제거함
  (사용예)
    SELECT MEM_NAME,
           REPLACE(MEM_NAME,'이','리') --내부에 있는 모든 이를 리로 바꿈 EX) 이쁜이->리쁜리
      FROM MEMBER;
      
    SELECT PROD_NAME,
           REPLACE(PROD_NAME,'삼보','SAMBO'), --상품명에서 삼보를 찾아서 영문자SAMBO로 바꿔라
           REPLACE(PROD_NAME,'삼보'), --삼보를 찾아서 지우세요
           REPLACE(PROD_NAME,' ') --공백 찾아서 지우세요
      FROM PROD;   

  (사용예)회원테이블에서 '대전'에 거주하는 회원들의 기본주소의 광역시명칭을 모두 '대전광역시'로 통일시키시오.
    SELECT MEM_NAME AS 회원명,
           MEM_ADD1 AS 원본주소,
      CASE WHEN SUBSTR(MEM_ADD1,1,3)='대전시' THEN
                REPLACE(MEM_ADD1,SUBSTR(MEM_ADD1,1,3),'대전광역시 ') --'대전시'TRUE '대전광역시 '로 변환
           WHEN SUBSTR(MEM_ADD1,1,5)!='대전광역시' THEN              
                REPLACE(MEM_ADD1,SUBSTR(MEM_ADD1,1,2),'대전광역시 ') --'대전시'FALSE '대전광역시'FALSE(!대전광역시TRUE) => '대전'TRUE '대전광역시 '로 변환
           ELSE            --'대전시'FALSE '대전'FALSE => '대전광역시'TRUE 그대로 출력
                MEM_ADD1
           END AS 기본주소        -- CASE문이 출력되는 컬럼명을 기본주소라고 명명
      FROM MEMBER
     WHERE MEM_ADD1 LIKE '대전%'; --대전으로 시작하는 모든 컬럼을 출력한다
     
 8) INSTR(c1,c2[m[,n]]) --많이쓰진않음
    - 주어진 c1문자열에서 c2문자열이 처음 나온 위치를 반환 --C1에서 C2찾기
    - m은 시작위치를 나타내며 --m매개변수 검사위치를 지정함
    - n은 반복 되어진 횟수 
  (사용예) --index변화x
   SELECT INSTR('APPLEBANANAPERSIMMON','L') AS COL1,
          INSTR('APPLEBANANAPERSIMMON','A',3) AS COL1,
          INSTR('APPLEBANANAPERSIMMON','A',3,2) AS COL1, --3번째 글자부터 2번째 나오는 A의 위치
          INSTR('APPLEBANANAPERSIMMON','A',-3) AS COL1 -- 결과 11 = 뒤에서부터 세었으나 결과위치는 앞에서부터 세서 11번째글자임
     FROM DUAL;
     
 9) LENGTHB(c1), LENGTH(c1)
  - 주어진 문자열의 길이를 BYTE수로(LENGTHB), 글자수로(LENGTH)로 반환 --대용량은 LENGTHB못씀
  
  --SUBSTR을 가장 많이 쓰고 나머지는 그다지 많이 쓰지 않음
 