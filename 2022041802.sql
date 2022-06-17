2022-0418-02)형 변환 함수
 - 함수가 사용된 위치에서 *일시적으로* 데이터타입의 형을 변환 시킴 --하드디스크의 데이터는 수정되지 않음
 - TO_CHAR, TO_DATE, TO_NUMBER, CAST 이 제공
 1)CAST(expr AS type명) --제일 안 씀
  . 'expr'의 데이터타입을 'type'으로 변환
 사용예) SELECT '홍길동',
               CAST('홍길동' AS CHAR(20)), --문자열의 기본타입 VARCHAR2 20자고정길이로 바꿔주기위한 형변환
               CAST('20200418' AS DATE)
          FROM DUAL;
          
    SELECT MAX(CAST(CART_NO AS NUMBER))+1 --숫자로변환하고 그 중 제일 큰 값 구해서 +1
      FROM CART
     WHERE CART_NO LIKE '20200507%' --20200507자료에서~
     --20200507날짜에 N+1번째로 접속한 사람의 CART데이터 추가하는거

2) TO_CHAR(c), TO_CHAR(d | n [,fmt])   --고정길이/ 대용량 =>가변길이VARCHAR2로
  - 주어진 문자열을 문자열로 변환(단, c의 타입이 CHAR OR CLOB인 경우
    VARCHAR2로 변환하는 경우만 허용  --VARCHAR2에서 VARCAHR2로는 안됨
  - 주어진 날짜(d) 또는 숫자(n)을 정의된 형식(fmt)으로 변환 --형식지정은 안해도됨.옵션
  - 날짜관련 형식문자
----------------------------------------------------------------------
  FORMAT문자       의미         사용예
----------------------------------------------------------------------
  AD, BC          서기        SELECT TO_CHAR(SYSDATE, 'AD') FROM DUAL; --서기. BC,AD모두 SYSDATE기준이라 서기
  CC,YEAR         세기,년도    SELECT TO_CHAR(SYSDATE, 'CC YEAR') FROM DUAL; --21 TWENTY TWENTY-TWO.
  YYYY,YYY,YY,Y   년도        SELECT TO_CAHR(SYSDATE,'YYYY YYY YY Y') --2022 022 22 2.
                              FROM DUAL;
  Q               분기        SELECT TO_CHAR(SYSDATE, 'Q') FROM DUAL;  --n분기 쿼터
  MM,RM(로만식     월          SELECT TO_CHAR(SYSDATE, 'YY:MM:RM') FROM DUAL; --04 로마식4
  MONTH,MON       월          SELECT TO_CHAR(SYSDATE, 'YY:MONTH MON') FROM DUAL; --4월 4월
  W,WW,IW         주차        SELECT TO_CHAR(SYSDATE, 'W WW IW') FROM DUAL; --지금 현재 이번달몇주차인지/WW요번해1/1부터 주차수
  DD,DDD,J        일차        SELECT TO_CHAR(SYSDATE, 'DD DDD J') FROM DUAL; --일 이번달들어며칠째/365일 단위 1/1부터지금까지 경과일수/Julian년호(율리우스 년호로 -4712년 1월 1일을 기점으로 계산하는 책력)-천문학에 주로 사용
  DAY,DY,D        요일        SELECT TO_CHAR(SYSDATE, 'DAY DY D') FROM DUAL; --요일 화요일/화/요일의인덱스값 일1월2화3수4목5금6토7
  AM,PM          오전/오후     SELECT TO_CHAR(SYSDATE, 'AM A.M.') FROM DUAL; --AM을 쓰든 PM을 쓰든 주어진시간에 맞춰 오전/오후 나옴
  A.M., P.M.
  HH,HH12,HH24    시간       SELECT TO_CHAR(SYSDATE, 'HH HH12 HH24') FROM DUAL; --HH=HH12 12시간 단위 / HH24 24시간단위
  MI               분        SELECT TO_CHAR(SYSDATE, 'HH24:MI') FROM DUAL; -- 24시간:분
  SS, SSSSS        초        SELECT TO_CHAR(SYSDATE, 'SS SSSSS') FROM DUAL; --SS초 SSS오늘 0시0분0초에서부터 지금까지를 초단위로 표시(하루는 86400초)
  "문자열"        사용자정의    SELECT TO_CHAR(SYSDATE, 'YYYY"년" MM"월" DD"일"') FROM DUAL;
                 형식문자열  --잘안씀.. 형식문자열 날짜 숫자 있음 //사용자가 지정한 형식으로 나옴
----------------------------------------------------------------------

  - 숫자관련 형식문자
----------------------------------------------------------------------
  FORMAT문자    의미         
----------------------------------------------------------------------
    9        출력형식의 자리설정, 유효숫자인 경우 숫자를 출력하고
             무효의 0인 경우 공백처리   --나인모드
    0        출력형식의 자리설정, 유효숫자인 경우 숫자를 출력하고
             무표의 0인 경우 0을 출력
    $,L      화폐기호 출력 --(달러,LOCATE) 한국이라 원화로 나옴
    PR       원본자료가 음수인 경우 "-"부호 대신 "< >"안에 숫자 출력 --맨뒤에 PR
    ,(Comma) 3자리마다 자리점 표시
    . (Dot)  소숫점 출력
----------------------------------------------------------------------   
사용예)
    SELECT TO_CHAR(12345, '999999'), --공백12345
           TO_CHAR(12345, '999,999.99'), --공백12,345.00
           TO_CHAR(12345.786, '000,000.0'), --공백012,345.8 반올림
           TO_CHAR(12345, '0,000,000'), --0,012,345
           TO_CHAR(-12345, '99,999PR'), --<12,345>
           TO_CHAR(12345, 'L99,999'), -- 원화12,345(우측정렬)
           TO_CHAR(12345, '$99999') FROM DUAL; --달러12345좌측정렬

 3) TO_NUMBER(c [,fmt])
  - 주어진 *문자열* 자료 c를 fmt 형식의 숫자로 변환
  
  사용예) --거꾸로 생각하기. 어떻게 써서 숫자가 이렇게 됐나?
         --TO_NUMBER를 통해 원본을 출력할건데 콤마 뒤로는 원본의 형식을 지정해줌
    SELECT TO_NUMBER('12345'),       -- 결과:12345 '12,345'는 잘못된 형태 '12345'가 맞음
           TO_NUMBER('12,345','99,999'), --결과:12345 나인모드로 형식지정
           TO_NUMBER('<1234>','9999PR'), --결과:-1234 음수-> <> PR
           TO_NUMBER('$12,234.00','$99,999.99')*1100 --결과:12234*1100=13457400 *1100은원화로계산
      FROM DUAL;      

 4) TO_DATE(c [,fmt])
  - 주어진 *문자열* 자료 c를 fmt 형식의 날짜로 변환

  사용예)
   SELECT TO_DATE('20200405'),
          TO_DATE('220405'),       --실행안됨 설정에 날짜는 YYYYMMDD로 설정해놔서 되게 하려면 YY라고 형식을 지정해줘야됨
          TO_DATE('220405','YYMMDD')
     FROM DUAL;  
     
     