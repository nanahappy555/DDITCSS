2022-0426-01)���տ����� -- ���� �� �߿�
 - SQL������ *���*�� ������ *����(set)*�̶�� ��
 - �̷� ���յ� ������ ������ �����ϱ� ���� �����ڸ� ���տ����ڶ� ��
 - UNION, UNION ALL, INTERSECT, MINUS �� ����
 - ���տ����ڷ� ����Ǵ� �� SELECT���� SELECT���� ***�÷��� ����,����,Ÿ���� ��ġ�ؾ���*** --Ÿ�԰����� ���� �÷��� �ƴ϶� ��
 - ORDER BY ���� �� ������ SELECT������ ��� ����
 - ����� ù��° SELECT���� SELECT���� ������ ��

�� ������ A��B A CUP B
�� ������ A��B A CAP B
--UNION : ���� ��ü & �ߺ�����
--UNION ALL : ���� ��ü & �ߺ�����. �ι�,���� �ߺ��� ������ŭ ���
--INTERSECT : ������. ����κи� ���
--MINUS : ������. ���� �տ� ���Ŀ� ���� ����� �޶���. ex)4������ �Ǹŵ� ��. 4��-5678910��...
--SELECT���=����SET
 
(�������)
    SELECT �÷�LIST       --����
      FROM ���̺��
    [WHERE ����]
    UNION|UNION ALL|INTERSECT|MINUS
    SELECT �÷�LIST
      FROM ���̺��
    [WHERE ����]
        :
    UNION|UNION ALL|INTERSECT|MINUS
    SELECT �÷�LIST
      FROM ���̺��
    [WHERE ����]
    [ORDER BY �÷���|�÷�index [ASC|DESC],...];

 1. UNION
  - �ߺ��� ������� ���� �������� ����� ��ȯ
  - �� SELECT���� ����� ��� ����
  
��뿹)ȸ�����̺��� 20�� ����ȸ���� �泲����ȸ���� ȸ����ȣ, ȸ����, ����, ���ϸ����� ��ȸ�Ͻÿ�.
      --20�� ����ȸ�� - ������ ���X
      --�泲����ȸ�� - ���̼������X
    1.20�� ����ȸ���� ȸ����ȣ, ȸ����, ����, ���ϸ���  --11��
    (ù��° SET)
    SELECT MEM_ID AS ȸ����ȣ,
           MEM_NAME AS ȸ����,
           MEM_JOB AS ����,
           MEM_MILEAGE AS ���ϸ���
      FROM MEMBER
     WHERE (EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM MEM_BIR))
            BETWEEN 20 AND 29
       AND SUBSTR(MEM_REGNO2,1,1) IN('2', '4');
    2.�泲����ȸ���� ȸ����ȣ, ȸ����, ����, ���ϸ���   --3��
    (�ι�° SET)
    SELECT MEM_ID AS ȸ����ȣ,
           MEM_NAME AS ȸ����,
           MEM_JOB AS ����,
           MEM_MILEAGE AS ���ϸ���
      FROM MEMBER
     WHERE MEM_ADD1 LIKE '�泲%';
    3. 20�� ���� & �泲����ȸ�� (�ߺ�����) --��� 13�� = 1���� 20�� �����̰� �泲����ȸ���̴�     
     SELECT MEM_ID AS ȸ����ȣ,
           MEM_NAME AS ȸ����,
           MEM_JOB AS ����,
           MEM_MILEAGE AS ���ϸ���
      FROM MEMBER
     WHERE (EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM MEM_BIR))
            BETWEEN 20 AND 29
       AND SUBSTR(MEM_REGNO2,1,1) IN('2', '4')
UNION
    SELECT MEM_ID AS ȸ����ȣ,
           MEM_NAME AS ȸ����,
           MEM_JOB AS ����,
           MEM_MILEAGE AS ���ϸ���
      FROM MEMBER
     WHERE MEM_ADD1 LIKE '�泲%'
     ORDER BY 1;
     
 2. INTERSECT
  - ������(����κ�)�� ��� ��ȯ
��뿹)ȸ�����̺��� 20�� ����ȸ���� �泲����ȸ�� ��
     ���ϸ����� 2000�̻��� ȸ���� ȸ����ȣ, ȸ����, ����, ���ϸ����� ��ȸ�Ͻÿ�.  
     --20�� ����ȸ�� UNION �泲����ȸ�� INTERSECT ���ϸ���>=2000
     SELECT MEM_ID AS ȸ����ȣ,
           MEM_NAME AS ȸ����,
           MEM_JOB AS ����,
           MEM_MILEAGE AS ���ϸ���
      FROM MEMBER
     WHERE (EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM MEM_BIR))
            BETWEEN 20 AND 29
       AND SUBSTR(MEM_REGNO2,1,1) IN('2', '4')
UNION
    SELECT MEM_ID AS ȸ����ȣ,
           MEM_NAME AS ȸ����,
           MEM_JOB AS ����,
           MEM_MILEAGE AS ���ϸ���
      FROM MEMBER
     WHERE MEM_ADD1 LIKE '�泲%'
INTERSECT
    SELECT MEM_ID AS ȸ����ȣ,
           MEM_NAME AS ȸ����,
           MEM_JOB AS ����,
           MEM_MILEAGE AS ���ϸ���
      FROM MEMBER
     WHERE MEM_MILEAGE>=2000
     ORDER BY 1;

 3. UNION ALL
  - �ߺ��� ����Ͽ� �������� ����� ��ȯ
  - �� SELECT���� ����� ��� ����(�ߺ� ����)
��뿹) --���տ����ڸ� ���� ���������� ���·� ����� ��.
    1)DEPTS���̺��� PARENT_ID�� NULL�� �ڷ��� �μ��ڵ�,�μ���,�����μ��ڵ�,������ ��ȸ�Ͻÿ�
      ��,�����μ��ڵ�� 0�̰� ������ 1�̴� --����:�ǻ��÷�=�ý��ۿ��� �����ϴ� �÷� ������������ Oracle���� ���� ���̻��
    SELECT DEPARTMENT_ID,
           DEPARTMENT_NAME,
           0 AS PARENT_ID, --���� �ǻ��÷� ROWNUM
           1 AS LEVELS
      FROM HR.DEPTS
     WHERE PARENT_ID IS NULL; --**NULL �񱳴� =�ε�ȣ�� �� �� ����.
    2)DEPTS���̺��� NULL�� �����μ��ڵ��� �μ��ڵ带 �����μ��ڵ�� ���� �μ��� �μ��ڵ�, �μ���, �����μ��ڵ�, ������ ��ȸ�Ͻÿ�.
      ��, ������ 2�̰� �μ����� ���ʿ� 4ĭ�� ������ ���� �� �μ��� ���.  --LPAD RPAD
      --whrer�� �ѹ���ȹ��(=�����μ��ڵ尡 NULL)�� �μ��ڵ带 �����μ��ڵ�� ������ �ִ� �μ�=>�ѹ���ȹ�ο� 1�������� �Ҽӵ� �μ�
      --LPAD(' ', 4*(2-1))��� �� ����. �� 2-1? 
      --2�� ����� �ƴ� LEVEL2��. 
      -- -1�� ���� ������ ����Ŭ�� 0�� �ƴ� 1���� ī���� �ǰ� ����1�� 0ĭ�����ε� 0ĭ�����̶�� �ϰ�; 4*0���� ǥ���Ҽ�����
    SELECT B.DEPARTMENT_ID,
           LPAD(' ', 4*(2-1))||B.DEPARTMENT_NAME AS DEPARTMENT_NAME, --2�����϶��� 4ĭ����, 1�����϶��� 0ĭ����. ��� ������������ �䳻������
           B.PARENT_ID AS PARENT_ID,                                 --(1����-1)*4=0 0ĭ���� (2����-1)*4=4 4ĭ���� (3����-1)*4=8 8ĭ����
           2 AS LEVELS
      FROM HR.DEPTS A, HR.DEPTS B --SELF JOIN A:�����μ��� NULL�� �ѹ���ȹ��-�μ��ڵ�(=10) / B:�ѹ���ȹ�ΰ� �θ��� ���μ�����-�μ��ڵ�
     WHERE A.PARENT_ID IS NULL --�����μ��� NULL�� �ѹ���ȹ��-�μ��ڵ�(=10)=1�� B�� ������ ��� 27���� �� �ش��
       AND B.PARENT_ID=A.DEPARTMENT_ID; --->A���̺� 1���� B���̺��� 27�� ���� �θ�μ��ڵ带 �� ����

    3)����
(����) ������ ������ �ƴϰ� �Ϲ����� ���� ��
    SELECT DEPARTMENT_ID,
           DEPARTMENT_NAME, --LPAD�� �� �ʿ䰡 ���� ������ 0���ϱ�
           NVL(PARENT_ID,0) AS PARENT_ID, --NVL�Ⱦ��� PARENT_ID AS PARENT_ID��� ���� NULL����
           1 AS LEVELS
      FROM HR.DEPTS
     WHERE PARENT_ID IS NULL
UNION ALL     
    SELECT B.DEPARTMENT_ID,
           LPAD(' ', 4*(2-1))||B.DEPARTMENT_NAME AS DEPARTMENT_NAME, --4*(1����-1) =1����0ĭ���� 4*(2����-1) =2����4ĭ���� ����Ŭ�� 0���� ī��Ʈ�Ҽ�����
           B.PARENT_ID AS PARENT_ID,
           2 AS LEVELS
      FROM HR.DEPTS A, HR.DEPTS B
     WHERE A.PARENT_ID IS NULL
       AND B.PARENT_ID=A.DEPARTMENT_ID;        
       
       
    4) 3���� ������ ������ ���� ���·� SORT(��Ʈ)    0����4����8����  
    SELECT DEPARTMENT_ID,
           DEPARTMENT_NAME,
           NVL(PARENT_ID,0) AS PARENT_ID, --NVL�Ⱦ��� PARENT_ID AS PARENT_ID��� ���� NULL����
           1 AS LEVELS,
           PARENT_ID||DEPARTMENT_ID AS TEMP --1.�߰� �÷� ��� 10 10 10 10 (FROM�� ���̺��� �θ�||�ڽ�
      FROM HR.DEPTS
     WHERE PARENT_ID IS NULL
UNION ALL     
    SELECT B.DEPARTMENT_ID,
           LPAD(' ', 4*(2-1))||B.DEPARTMENT_NAME AS DEPARTMENT_NAME,
           B.PARENT_ID AS PARENT_ID,
           2 AS LEVELS,
           B.PARENT_ID||B.DEPARTMENT_ID AS TEMP --2.�߰� �÷� ��� 1020 1020 1020 (B�� �θ�||B�ڽ�
      FROM HR.DEPTS A, HR.DEPTS B
     WHERE A.PARENT_ID IS NULL
       AND B.PARENT_ID=A.DEPARTMENT_ID
UNION ALL       
    SELECT C.DEPARTMENT_ID,
           LPAD(' ', 4*(3-1))||C.DEPARTMENT_NAME AS DEPARTMENT_NAME,
           C.PARENT_ID AS PARENT_ID,
           3 AS LEVELS,
           B.PARENT_ID||C.PARENT_ID||C.DEPARTMENT_ID AS TEMP --3.�߰� �÷� 1030210 1030220 1030230 (B�Ǻθ�||C�Ǻθ�||C�ڽ�
      FROM HR.DEPTS A, HR.DEPTS B, HR.DEPTS C
     WHERE A.PARENT_ID IS NULL
       AND B.PARENT_ID=A.DEPARTMENT_ID
       AND C.PARENT_ID=B.DEPARTMENT_ID
     ORDER BY 5;          
--1.2.3.�� �߰����� ��� TEMP�÷��� �������� ���ĵǾ� ������ �������� ���°� �ȴ�.


**����������
  - ������ ������ ���� ���̺��� ������ ����� �� ���
  - Ʈ�������� �̿��� ���
  (�������)
  SELECT �÷� list
    FROM ���̺��
   START WITH ���� --��Ʈ(root)��� ����  --PARENT_ID IS NULL --��Ʈ��带 �������� ������ ��� ��尡 ��Ʈ��尡 �ȴ�.
   CONNECT BY NOCYCLE|PRIOR �������� ���� --���������� ������� ���� �Ǿ����� ����
** CONNECT BY PRIOR �ڽ��÷� = �θ��÷� : �θ𿡼� �ڽ����� Ʈ������(TOP DOWN)
   CONNECT BY PRIOR �θ��÷� = �ڽ��÷� : �ڽĿ��� �θ�� Ʈ������(BOTTOM UP)
** PRIOR �����ġ�� ���� ����
   CONNECT BY PRIOR �÷�1 = �÷�2
                    <----------
   CONNECT BY �÷�1 = PRIOR �÷�2
                    ---------->
**������ ���� Ȯ��
   CONNECT_BY_ROOT �÷��� : ��Ʈ��� ã��
   CONNECT_BY_ISCYCLE : �ߺ������� ã��
   CONNECT_BY_ISLEAF : �ܸ���� ã�� --��� ���� ������ �������
   
   SELECT DEPARTMENT_ID AS �μ��ڵ�,
          LPAD(' ',4*(LEVEL-1))||DEPARTMENT_NAME AS �μ���, 4*(1����-1)=4*0=0 ����0��
          LEVEL AS ����
     FROM HR.DEPTS
    START WITH PARENT_ID IS NULL
    CONNECT BY PRIOR DEPARTMENT_ID=PARENT_ID --PRIOR:�θ��������� �θ� �ĺ��ϴµ� ���Ǵ� ���� �տ� �ٴ´�. �θ��� DEPARTMENT_ID�� �ڽ��� PARENT_ID�� ���� ����.
 -- CONNECT BY PRIOR PARENT_ID = DEPARTMENT_ID;
    ORDER SIBLINGS BY DEPARTMENT_NAME; --����X �ش��÷����� �������� ����



��뿹)��ٱ������̺��� 4���� 6���� �Ǹŵ� ��� ��ǰ������ �ߺ����� �ʰ� ��ȸ�Ͻÿ�.
      Alias�� ��ǰ��ȣ, ��ǰ��,�Ǹż����̸� ��ǰ��ȣ ������ ����Ͻÿ�.
--SUM�� �Ἥ ���� ǰ�񳢸��� �Ǹż����� ���� ���� ������ (�Ȱ��� ǰ���� ������ ��µǴ� ���� ����.
--UNION�� �Ἥ 4���� 6���� ���� ǰ�� ���� ������ �Ǹŵƴٸ� ������
      SELECT A.CART_PROD AS ��ǰ��ȣ,
             B.PROD_NAME AS ��ǰ��,
             SUM(A.CART_QTY) AS �Ǹż���
        FROM CART A, PROD B
       WHERE A.CART_PROD=B.PROD_ID
         AND A.CART_NO LIKE '202004%'
       GROUP BY A.CART_PROD,B.PROD_NAME
UNION
      SELECT A.CART_PROD AS ��ǰ��ȣ,
             B.PROD_NAME AS ��ǰ��,
             SUM(A.CART_QTY) AS �Ǹż���
        FROM CART A, PROD B
       WHERE A.CART_PROD=B.PROD_ID
         AND A.CART_NO LIKE '202006%'
       GROUP BY A.CART_PROD,B.PROD_NAME
       ORDER BY 1;     
      
��뿹)��ٱ������̺��� 4������ �Ǹŵǰ� 6���� �Ǹŵ� ��� ��ǰ������ ��ȸ�Ͻÿ�.
      Alias�� ��ǰ��ȣ, ��ǰ���̸� ��ǰ��ȣ ������ ����Ͻÿ�.
--�Ǹż����� ��� ���ϴ� ����: 4���� 6���� ����ǰ���� ���� ���� �Ǹŵ� ���� ��� �������� ����ϸ� ����� �ƹ��͵� ������ �ʴ´�.      
      SELECT A.CART_PROD AS ��ǰ��ȣ,
             B.PROD_NAME AS ��ǰ��
        FROM CART A, PROD B
       WHERE A.CART_PROD=B.PROD_ID
         AND A.CART_NO LIKE '202004%'
INTERSECT
      SELECT A.CART_PROD AS ��ǰ��ȣ,
             B.PROD_NAME AS ��ǰ��
        FROM CART A, PROD B
       WHERE A.CART_PROD=B.PROD_ID
         AND A.CART_NO LIKE '202006%'
       ORDER BY 1;     
      
��뿹)��ٱ������̺��� 4���� 6���� �Ǹŵ� ��ǰ �� 6������ �Ǹŵ� ��ǰ������ ��ȸ�Ͻÿ�.
      Alias�� ��ǰ��ȣ, ��ǰ��,�Ǹż����̸� ��ǰ��ȣ ������ ����Ͻÿ�.
      SELECT A.CART_PROD AS ��ǰ��ȣ,
             B.PROD_NAME AS ��ǰ��,
             SUM(A.CART_QTY) AS �Ǹż���
        FROM CART A, PROD B
       WHERE A.CART_PROD=B.PROD_ID
         AND A.CART_NO LIKE '202004%'
       GROUP BY A.CART_PROD,B.PROD_NAME
UNION
      SELECT A.CART_PROD AS ��ǰ��ȣ,
             B.PROD_NAME AS ��ǰ��,
             SUM(A.CART_QTY) AS �Ǹż���
        FROM CART A, PROD B
       WHERE A.CART_PROD=B.PROD_ID
         AND A.CART_NO LIKE '202006%'
       GROUP BY A.CART_PROD,B.PROD_NAME 
MINUS
      SELECT A.CART_PROD AS ��ǰ��ȣ,
             B.PROD_NAME AS ��ǰ��,
             SUM(A.CART_QTY) AS �Ǹż���
        FROM CART A, PROD B
       WHERE A.CART_PROD=B.PROD_ID
         AND A.CART_NO LIKE '202004%'
       GROUP BY A.CART_PROD,B.PROD_NAME
       ORDER BY 1;