2022-0406-01)����� ����
 - ����Ŭ ����� ����
 (�������)
  CREATE USER ������ IDENTIFIED BY ��ȣ;
  CREATE USER LHR91 IDENTIFIED BY java;
  
 - ���Ѽ���
 (�������)
   GRANT ���Ѹ�[,���Ѹ�,...] TO ������;
   GRANT CONNECT, RESOURCE, DBA TO LHR91;
   
** HR���� Ȱ��ȭ
ALTER USER HR ACCOUNT UNLOCK;

ALTER USER HR IDENTIFIED BY java;