2022-0411-02)데이터 검색문(SELECT 문)
    - SQL명령 중 가장 많이 사용되는 명령
    - 자료 검색을 위한 명령
    (사용형식) --SELECT FROM WHERE의 구성 SELECT(필수절)화면에 출력할 컬럼 FROM(필수절) WHERE몇개의 행 출력할지 조건
             --실행순서 FROM->WHERE->SELECT
     SELECT *|[DISTINCT]컬럼명 [AS 별칭][,] --*ALL 혹은 컬럼명 / DISTINCT중복배제하고하나만나오게. 대표하나만붙이기
            컬럼명 [AS 별칭][,] --제목줄을 만들기 위해 사용한다(서브프로그램을 쓰면 참조용)
                :
            컬럼명 [AS 별칭] --별칭에 특문 추가되면 반드시 쌍따옴표
      FROM 테이블명 --테이블과 뷰만 올 수 있다
    [WHERE 조건] --행을 제어
    [GROUP BY 컬럼명[,컬럼명,...]]
   [HAVING 조건]
    [ORDER BY 컬럼인덱스|컬럼명 [ASC|DESC][,컬럼인덱스|컬럼명 [ASC|DESC],...]]]; --ASC오름차순 DESC내림차순 생략하면 오름차순기본 첫번째걸로 정렬됐으면 두번째부터는 무시

(사용예) 회원테이블에서 회원번호,회원명,주소를 조회하시오. --전체회원조회->WHERE절 X  주소에는 기본주소상세주소 있으니까 필요컬럼4개
    SELECT MEM_ID AS 회원번호,
          MEM_NAME AS 회원명,
          MEM_ADD1||' '||MEM_ADD2 AS 주   소 -- ||=자바의 + (연결연산자)/ 주   소 <-주 뒤에 SELECT절이 끝났다고 생각-> FROM이 안와서오류발생 해결방법: "주   소"
      FROM MEMBER;
    
(사용예) 회원테이블에서 '대전'에 거주하는 회원번호,회원명,주소를 조회하시오.  
    SELECT MEM_ID AS 회원번호,
          MEM_NAME AS 회원명,
          MEM_ADD1||' '||MEM_ADD2 AS "주   소" 
      FROM MEMBER
  WHERE MEM_ADD1 LIKE '대전%'; --와일드카드 대칭문자열. '대전' 뒤에는 무슨 글자가 와도 상관없다는 뜻 TRUE
  
(사용예) 회원테이블에서 '대전'에 거주하는 여성회원의 회원번호,회원명,주소를 조회하시오.
    SELECT MEM_ID AS 회원번호,
          MEM_NAME AS 회원명,
          MEM_ADD1||' '||MEM_ADD2 AS "주   소" 
      FROM MEMBER
  WHERE MEM_ADD1 LIKE '대전%'                   --AND 대전이고, 여성이면 두가지 조건을 모두 만족해야함
    AND SUBSTR(MEM_REGNO2,1,1) IN('2','4');    --OR 대전이거나 여성이면. 
    --SUBSTR부분문자열 추출 (원본,시작위치값,글자수) IN('글자','글자'); 2이거나 또는 4 -> TRUE
    
(사용예) 회원테이블에서 회원들의 거주지역(광역시도)을 조회하시오. --DISTINCT 중복배제 중요
    SELECT DISTINCT SUBSTR(MEM_ADD1,1,2) AS 거주지
        FROM MEMBER;