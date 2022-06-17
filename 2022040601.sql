2022-0406-01)사용자 생성
 - 오라클 사용자 생성
 (사용형식)
  CREATE USER 유저명 IDENTIFIED BY 암호;
  CREATE USER LHR91 IDENTIFIED BY java;
  
 - 권한설정
 (사용형식)
   GRANT 권한명[,권한명,...] TO 유저명;
   GRANT CONNECT, RESOURCE, DBA TO LHR91;
   
** HR계정 활성화
ALTER USER HR ACCOUNT UNLOCK;

ALTER USER HR IDENTIFIED BY java;