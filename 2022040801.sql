2022-0408-01)
��뿹)������̺�(HR���� EMPLOYEES���̺�)���� ��� ����� �޿���
     15% �λ��Ͽ� �����Ͻÿ�.
     
COMMIT;     
ROLLBACK;

    SELECT FIRST_NAME, SALARY
        FROM HR.employees;
        
    UPDATE HR.employees
        SET SALARY=SALARY+ROUND(SALARY*0.15); --SET �������� �÷��� ROUND �ݿø�? ��� ����̴ϱ� WHERE�� �ʿ�X
        
4. DELETE ��� --�θ�� ������� UPDATE DELETE �Ұ���. �ڽ��� ���� �־�Ф� -> �ڽĸ��� ������Ʈ ���� �θ� ������Ʈ Ȥ�� �ڽ�DEL,�θ�DEL
    - ���ʿ��� �ڷḦ ���̺��� ����
    (�������)
    DELETE FROM ���̺�� --�� ������ �����Ǵ°Ŷ� �÷����� �ʿ����. ���̺��� �����ְ� ���빰�� ������.
     [WHERE ����] --�������� �����Ǹ� ��� ���� ������

��뿹)
--    DELETE FROM PROD; --PROD���̺��� ����ϴ� �ڽ� ���̺��� �����ؼ� �������� ����.
    DELETE FROM CARTS; --īƮ�� �� ���� ������
    ROLLBACK;  --�ǵ���
     
5. ����Ŭ ������Ÿ��
    - ����Ŭ ���� ������ Ÿ���� ������������
    - ���ڿ�, ����, ��¥, 2�� ������Ÿ�� ����
    1) ���ڿ� �ڷ���
     - ����Ŭ�� ���ڿ� �ڷ�� ' '�� ���
     - ���ڿ� �ڷ����� CHAR, VARCHAR, VARCHAR2, NVARCHAR, NVARCHAR2, --CHAR�ܿ��� �� �������� CHAR VARCHAR2 CLOB�� ��
     LONG, CLOB, NCLOB���� ���� -- LONG�� ���� �Ⱦ� CLOBĳ���Ͷ���������Ʈ �� ��
     (1) CHAR
        . �������� ���ڿ� �ڷ� ����
        . �ִ� 2000byte ���� ���尡�� --�ѱ� 666�ڱ���. 
        . �������� ������ ������ ������ ������ pedding, �������� ������ error --PEDDING ����
        . �⺻Ű�� ������ �ڷ�(�ֹι�ȣ ��)���忡 �ַ� ��� --Ű���� �����̴ϱ�
        (��뿹)
        �÷��� CHAR(ũ��[byte|char]) --�����ϸ� BYTE  |���������� ��������ȣ �� �� �ϳ� ������ �� �ִٴ� �� byte����Ʈ�� char���ڼ�
         . 'ũ��[byte|char]' : 'ũ��'�� ������ ���� byte���� char(���ڼ�)������ ����. �����ϸ� byte�� ����) --default�� byte��
         . �ѱ� �ѱ��ڴ� 3byte�� ����Ǹ� CHAR(2000CHAR)�� ����Ǿ��� ������ ��ü ������ 2000BYTE�� �ʰ��� �� ���� --�ѱ��� ��/��/���� ���� 1BYTE������
��뿹)
    CREATE TABLE TEMP01(
        COL1 CHAR(20),          --20byte
        COL2 CHAR(20 BYTE),     --20byte
        COL3 CHAR(20 CHAR));    --20char
        
    INSERT INTO TEMP01 VALUES('������ �߱�','������ �߱�','������ �߱�');
    
    SELECT * FROM TEMP01;
    
    SELECT LENGTHB(COL1), --LENGTH BYTE ���̸� BYTE�� ��Ÿ���ÿ�
           LENGTHB(COL2),
           LENGTHB(COL3) --30BYTE�� ������ ����= (�ѱ�5����15BYTE+����1BYTE) 16BYTE + (20CHAR-6CHAR(��������)=14CHAR=14BYTE) = 30BYTE
      FROM TEMP01;       
         
     (2) VARCHAR2
        . �������� ���ڿ� �ڷḦ ���� (�������� ���̸�ŭ ����ϰ� ���°����� �ݳ�)
        . �ִ� 4000byte���� ���� ���� --�ѱ� 1334����
        . VARCHAR�� ���� ���
        . NVARCHAR �� NVARCHAR2�� ���� ǥ���ڵ��� UTF-8, UTF-16������� �����͸� ���ڵ��Ͽ� ����
    (�������)
        �÷��� VARCHAR2(ũ��[BYTE|CHAR]) --�����ϸ� BYTE�� ����
    (��뿹)
        CREATE TABLE TEMP02(
            COL1 VARCHAR2(100),
            COL2 VARCHAR2(100 BYTE),
            COL3 VARCHAR2(100 CHAR),
            COL4 CHAR(100));
            
        INSERT INTO TEMP02
            VALUES('IL POSTINO', 'IL POSTINO', 'IL POSTINO', 'IL POSTINO');
        
        SELECT * FROM TEMP02;
        
     (3) LONG --(���ݱ��� ����� �� �ڷᰡ ������)������ �Ǵµ� ���� �ߴܵ�. 
        . �������� ������ ����
        . �ִ� 2GB ���� ���� ����
        . �� ���̺� �ϳ��� LONGŸ�� �÷��� ��� --�̰Ŷ����� �Ⱦ��Ե���.
        . CLOB(Character Large OBjects)�� ��� ���׷��̵� �� --LARGE OBJECTS ��뷮
        . SELECT ���� SELECT ��, UPDATE ���� SET ��, INSERT ���� VALUES ������ ��� ����
        . �Ϻ� �Լ������� ���� �� ����
    (�������)
     �÷��� LONG
    (��뿹)
     CREATE TABLE TEMP03(   --LONG�÷��� �����̺� �ϳ��� �� �� �ִµ� LONG�� �ΰ��� �����߻�
      COL1 LONG,
      COL2 VARCHAR2(4000));
      
    INSERT INTO TEMP03 
        VALUES('BANNA APPLE PERSIMMON','BANNA APPLE PERSIMMON');
        
    SELECT * FROM TEMP03;    
    
    SELECT SUBSTR(COL2,7,5) --SUBSTR ���꽺Ʈ�� 7��°���ں��� 5����
        FROM TEMP03;  --LONGŸ���� �ʹ� Ŀ�� ���꽺Ʈ���� �Ǵ��ϱⰡ �����
        
     (4) CLOB
        . �������� ������ ����
        . �ִ� 4GB���� ó�� ����
        . �� ���̺� ���� ���� CLOB�ڷ�Ÿ���� �÷� ��� ����
        . �Ϻ� ����� DBMS_LOB API�� ������ �޾ƾ� ��� ���� 
    (�������)
     �÷��� CLOG;
    (��뿹)
     CREATE TABLE TEMP04(
        COL1 LONG,
        COL2 CLOB,
        COL3 CLOB,
        COL4 VARCHAR2(4000));
        
    INSERT INTO TEMP04
        VALUES ('','������ �߱� ���� 846','������ �߱� ���� 846','������ �߱� ���� 846'); --''=NULL
        
    SELECT * FROM TEMP04;    
    
    SELECT DBMS_LOB.GETLENGTH(COL2), --
            DBMS_LOB.GETLENGTH(COL3),--CLOB�� �ִ� 4GB�� BYTE�� �ʹ� Ŀ�� LENGTHB�δ� X. ���ڼ� üũ�� �����ϴ�
            LENGTHB(COL4) --VARCHAR2�� BYTEüũ ����
      FROM TEMP04;    
      
    SELECT SUBSTR(COL2,5,2), --�߱�
            DBMS_LOB.SUBSTR(COL2,5,2),--���� �߱�
            SUBSTR(COL4,5,2) --�߱�
      FROM TEMP04; 