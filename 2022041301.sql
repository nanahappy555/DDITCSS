2022 - 0413 - 01)�Լ�
 - ��� ����ڵ��� ������ �������� ����ϵ��� �̸� ���α׷��ֵǾ� �������� �� ���� ������ ���·� ����� ��� --API
 - ���ڿ�, ����, ��¥, ����ȯ, ����(�׷�)�Լ��� ����
1. ���ڿ��Լ�
  1)CONCAT(c1,c2) --�߾Ⱦ� ������ ��������. ���Լ���(�Ű�����,�Ű�����) c=char �ݵ�� �Ű����� 2���� �־�� ��
   - �־��� �� ���ڿ� c1�� c2�� �����Ͽ� ���ο� ���ڿ��� ��ȯ
   - ���ڿ� ���� ������ '||'�� ���� ���
   --�Լ��� �Լ��� ������ �� �ִ�. CONCAT((X,Y),Z);
 (��뿹)ȸ�����̺��� 2000�� ���� ����� ȸ�������� ��ȸ�Ͻÿ�
        Alias�� ȸ����ȣ,ȸ����,�ֹι�ȣ,�ּ��̴�.
        �ֹι�ȣ�� xxxxxx-xxxxxxx�������� �ּҴ� �⺻�ּҿ� ���ּҰ� ���� �ϳ��� �߰��Ͽ� �����Ұ�
        SELECT MEM_ID AS ȸ����ȣ,
               MEM_NAME AS ȸ����,
               CONCAT(CONCAT(MEM_REGNO1,'-'),MEM_REGNO1) AS �ֹι�ȣ,   --�Լ��� �����ϴ� �Լ�
               CONCAT(MEM_ADD1,' ') AS �ּ�
          FROM MEMBER
         WHERE SUBSTR(MEM_REGNO2,1,1) IN('3','4');
         
 2)LOWER(c1), UPPER(c1), INITCAP(c1)  --������ ��ҹ��� ���� ���ϴµ� ''��������ǥ�� ���̸� �ƽ�Ű�ڵ尪���� ��ȯ �ƽ�Ű�ڵ�� ��ҹ��ڱ����Ǿ��־ �̶��� ������
  . LOWER(c1) : �־��� ���ڿ� c1�� ���ڸ� ��� �ҹ��ڷ� ��ȯ
  . UPPER(c1) : �־��� ���ڿ� c2�� ���ڸ� ��� �빮�ڷ� ��ȯ
  . INITCAP(c1) : c1 ���� ���� �� �ܾ��� ù ���ڸ� �빮�ڷ� ��ȯ --��)�̱��� �̸�
   --ã������ �񱳴���� ���� �빮���� ��� �� �Լ��� �̿��ϸ� �����ͺ��̽��� ���������� ���ϴ� �����ͼ�ġ ����
   ��뿹)ȸ�����̺��� ȸ����ȣ'F001'ȸ�������� ��ȸ�Ͻÿ�
        Alias�� ȸ����ȣ, ȸ����, �ּ�, ���ϸ����̴�
        
        SELECT MEM_ID AS ȸ����ȣ, 
               MEM_NAME AS ȸ����, 
               MEM_ADD1||' '||MEM_ADD2 AS �ּ�, 
               MEM_MILEAGE AS ���ϸ���
        
        FROM MEMBER
        
        WHERE UPPER(MEM_ID)='F001';  --���� ã�� �����Ͱ� �ҹ������� �빮������ �𸦶� f001 ���1�����
      --WHERE UPPER(MEM_ID)='f001'; --�̷��� �ϸ� ���� ��ϸ� ������ ����� �ȳ��´�
        
       -------------------------------------------------------------------
 
        SELECT EMPLOYEE_ID as origin,
               LOWER(FIRST_NAME)||' '||UPPER(LAST_NAME) as �Ҵ�,
               LOWER(FIRST_NAME||' '||LAST_NAME) as ��,
               INITCAP(LOWER(FIRST_NAME||' '||LAST_NAME)) as ù��,
               EMP_NAME
          FROM hr.employees;   
          
          
 3)LPAD(c1,N[,c2]), RPAD(c1,N[,c2])    --���е�,���е� ���鿡 ä������ �� �е��ȴٰ� �Ѵ� / Ư�����ڿ��� �龦�����ϰ� ����ϰų�(������:������ �з��� ����..����Ŭ������ �����ϴ� ����)������� ���ʿ� ����� L, �����ʿ� ����� R
  . LPAD(c1,N[,c2]) : n�ڸ��� �־��� ���ڿ� c1�� ä��� ���� ���ʰ����� c2 ���ڿ��� ä��, c2�� �����Ǹ� ������ ä����
  . RPAD(c1,N[,c2]) : n�ڸ��� �־��� ���ڿ� c1�� ä��� ���� �����ʰ����� c2 ���ڿ��� ä��, c2�� �����Ǹ� ������ ä����  
  
  ��뿹)
       SELECT '1,000,000',
              LPAD('1,000,000',15,'*'),
              RPAD('1,000,000',15,'*')
         FROM DUAL;
        ---------------------------------------------------------
  
  --���� �ǰ� ���� �о��      
 ��뿹) �Ⱓ(��� ��)�� �Է� �޾� ����� ���� ���� 5�� ��ǰ�� �������踦 ���ϴ� ���ν����� �ۼ��Ͻÿ� --RPAD�� �����ִ� ��, �� �ٸ��� ��
        CREATE OR REPLACE PROCEDURE PROC_CALCULATE( ---��ȯ���� ���� �Լ�
            P_PERIOD VARCHAR2)
        IS
            CURSOR CUR_TOP5 IS                      ---Ŀ���� �������
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
  
  EXECUTE PROC_CALCULATE('202007');      --���߿� ���������� �ϰڽ��ϴ� RPAD�� �����ֱ� ���� ���ÿ����ϴ�~
 
 
 4) LTRIM(c1 [,c2]), RTRIM(c1 [,c2])  --���ڿ��� ã�� �����ϱ� ���� ����..�������� CHAR�� �����ϸ� 
  - LTRIM(c1 [,c2]) : c1 ���ڿ����� ���� ������ġ���� c2���ڿ� ã�� ���� ���ڿ��� ������ ����, c2�� �����Ǹ� ���� ������ ����
  - RTRIM(c1 [,c2]) : c1 ���ڿ����� ������ ������ġ���� c2���ڿ� ã�� ���� ���ڿ��� ������ ����, c2�� �����Ǹ� ������ ������ ���� 
  
  (��뿹)
    SELECT LTRIM('PERSIMMON BANNA APPLE', 'ER'),-- ER�� ���۵Ǵ� ���ڰ� ��� / PER�� �������� ����
           LTRIM('PERSIMMON BANNA APPLE', 'PE'),
           LTRIM('   PERSIMMON BANNA APPLE')
      FROM DUAL;
      
    SELECT RTRIM('...ORACLE...','.'),
           RTRIM('...OR...OR...','OR...'),   --OR�� ��� ...�� ��ġ�ϴϱ� ...�� ����
           RTRIM('...          '), --������ ���� ����
           RTRIM('...          ') AS "C" --������ ���� ���� & "C"�� ���̿� ���缭 ...�� ����
      FROM DUAL;       
      
 5) TRIM(c1)    --��ȿ�� ���� : ������ ������ ��, ������ ���� �� �����ϴ� ����=���ǹ�/ ��ȿ�� ���� : ������ �߰��� ������ ������ �ݵ�� �����ؾ��ϴ� ����
    - c1���ڿ� ���ʰ� �����ʿ� �ִ� ��� ������ ����
    - �ٸ� ���ڿ� ������ ������ �������� ����. (REPLACE�� ����)
  (��뿹)
   SELECT TRIM('     QWER    '),
          TRIM('  ����ȭ ���� �Ǿ����ϴ�!!   ')
     FROM DUAL;
  (��뿹��) ������ 2020�� 4�� 1���̶�� �Ҷ� ��ٱ������̺��� ��ٱ��Ϲ�ȣ(CART_NO)�� �����Ͻÿ�.
  --YYYYMMDD00000(��¥8��+�α��μ���5) �� 9��° ����(�α���5)���� �������� �� �� (�Լ�) -> ���ڷ� ��ȯ->���� ū ���� ����-> +1 -> �ټ��ڸ� ����/���� ��ȯ -> ���� ->20200401 00004������ ����(��ȯ����)
   SELECT TO_CHAR(SYSDATE,'YYYYMMDD')||
          TRIM(TO_CHAR(MAX(TO_NUMBER(SUBSTR(CART_NO, 9))) +1, '00000'))     --SUBSTR(**,9)9��° ���ں��� ������ �� / '00000'�� ��ȿ����(�ڸ���)
     FROM CART
    WHERE CART_NO LIKE TO_CHAR(SYSDATE,'YYYYMMDD')||'%';  -- %������ ��� ���ڿ��� ��� / LIKE�� ��µǴϱ� ������.=>���ں�ȯ�ʿ� => SELECT���� TO_NUMBER�� ĳ����
   
    SELECT TO_CHAR(SYSDATE,'YYYYMMDD')||
          TRIM(TO_CHAR(MAX(TO_NUMBER(SUBSTR(CART_NO, 9))) +1, '00000'))   --����ȯ�� ������ �� 
          MAX(CART_NO)+1   --��� �ڵ�����ȯ.AUTOCASTING. ������ �Ƿ��� �� �� �����Ͱ� ���� ���ƾ� ��. 
     FROM CART             --JAVA�� �ٸ��� ORACLE�� ����+���� => ����+���� ���� �켱���� ĳ���õ� => ���ڷ� �����ǰ� ����� ����ȯ�� ���ϴ�..
    WHERE CART_NO LIKE TO_CHAR(SYSDATE,'YYYYMMDD')||'%'; 

 6) SUBSTR(c,m[,n]) --���� ���� ����
  - �־��� ���ڿ� c���� m��°���� n���� ���ڿ��� �����Ͽ� ��ȯ
  - n�� �����Ǹ� m��° ������ ��� ���ڿ��� �����Ͽ� ��ȯ
  - m�� 1���� ������(0�� ����Ǹ� 1�� ����)
  - m�� �����̸� �����ʺ��� ó����
  - n���� ���� ���� ���� ���� ��� n�� ������ ���� ���� --������ ��� ���ڿ� ����
  (��뿹)
   SELECT SUBSTR('�����Ⱑ ���ܿ� ���Ƕ�����', 5,6) AS COL1,
          SUBSTR('�����Ⱑ ���ܿ� ���Ƕ�����', 5) AS COL2,
          SUBSTR('�����Ⱑ ���ܿ� ���Ƕ�����', 0,6) AS COL3, --0 =>1
          SUBSTR('�����Ⱑ ���ܿ� ���Ƕ�����', 5,30) AS COL4, --n�� �� �� �Ͱ� ���� ('***',5)
          SUBSTR('�����Ⱑ ���ܿ� ���Ƕ�����', -5,6) AS COL5
     FROM DUAL;           
  
  (��뿹)ȸ�����̺��� �������� ȸ������ ��ȸ�Ͻÿ�. --������ ���� ������(����) -> ���� ���� COUNT =>ȸ����
         Alias�� ������, ȸ�����̴�.
    SELECT SUBSTR(MEM_ADD1,1,2) AS ������,
           COUNT(*) AS ȸ����
      FROM  MEMBER
     GROUP BY SUBSTR(MEM_ADD1,1,2);  --Ư���÷� �������� �հ�
     
 7) REPLACE(c1,c2[,c3])  ġȯ --���� ���� ������ �ٸ��ź��� ���� ��.. ����ȣ 01012345678/010.1234.5678/010-1234-5678���� �������� ������ �����Ϸ��� �� �� ��ˤ�
  - ���ڿ� c1���� c2���ڿ��� ã�� c3���ڿ��� ġȯ
  - c3���ڿ��� �����Ǹ� ã�� c2���ڿ��� ������
  - c3�� �����ǰ� c2�� �������� ����ϸ� �ܾ� ������ ������ ������
  (��뿹)
    SELECT MEM_NAME,
           REPLACE(MEM_NAME,'��','��') --���ο� �ִ� ��� �̸� ���� �ٲ� EX) �̻���->���۸�
      FROM MEMBER;
      
    SELECT PROD_NAME,
           REPLACE(PROD_NAME,'�ﺸ','SAMBO'), --��ǰ���� �ﺸ�� ã�Ƽ� ������SAMBO�� �ٲ��
           REPLACE(PROD_NAME,'�ﺸ'), --�ﺸ�� ã�Ƽ� ���켼��
           REPLACE(PROD_NAME,' ') --���� ã�Ƽ� ���켼��
      FROM PROD;   

  (��뿹)ȸ�����̺��� '����'�� �����ϴ� ȸ������ �⺻�ּ��� �����ø�Ī�� ��� '����������'�� ���Ͻ�Ű�ÿ�.
    SELECT MEM_NAME AS ȸ����,
           MEM_ADD1 AS �����ּ�,
      CASE WHEN SUBSTR(MEM_ADD1,1,3)='������' THEN
                REPLACE(MEM_ADD1,SUBSTR(MEM_ADD1,1,3),'���������� ') --'������'TRUE '���������� '�� ��ȯ
           WHEN SUBSTR(MEM_ADD1,1,5)!='����������' THEN              
                REPLACE(MEM_ADD1,SUBSTR(MEM_ADD1,1,2),'���������� ') --'������'FALSE '����������'FALSE(!����������TRUE) => '����'TRUE '���������� '�� ��ȯ
           ELSE            --'������'FALSE '����'FALSE => '����������'TRUE �״�� ���
                MEM_ADD1
           END AS �⺻�ּ�        -- CASE���� ��µǴ� �÷����� �⺻�ּҶ�� ���
      FROM MEMBER
     WHERE MEM_ADD1 LIKE '����%'; --�������� �����ϴ� ��� �÷��� ����Ѵ�
     
 8) INSTR(c1,c2[m[,n]]) --���̾�������
    - �־��� c1���ڿ����� c2���ڿ��� ó�� ���� ��ġ�� ��ȯ --C1���� C2ã��
    - m�� ������ġ�� ��Ÿ���� --m�Ű����� �˻���ġ�� ������
    - n�� �ݺ� �Ǿ��� Ƚ�� 
  (��뿹) --index��ȭx
   SELECT INSTR('APPLEBANANAPERSIMMON','L') AS COL1,
          INSTR('APPLEBANANAPERSIMMON','A',3) AS COL1,
          INSTR('APPLEBANANAPERSIMMON','A',3,2) AS COL1, --3��° ���ں��� 2��° ������ A�� ��ġ
          INSTR('APPLEBANANAPERSIMMON','A',-3) AS COL1 -- ��� 11 = �ڿ������� �������� �����ġ�� �տ������� ���� 11��°������
     FROM DUAL;
     
 9) LENGTHB(c1), LENGTH(c1)
  - �־��� ���ڿ��� ���̸� BYTE����(LENGTHB), ���ڼ���(LENGTH)�� ��ȯ --��뷮�� LENGTHB����
  
  --SUBSTR�� ���� ���� ���� �������� �״��� ���� ���� ����
 