2022-0421-01)
SELECT LEVEL,--�ǻ��÷�(Pseudo Column) �ý��ۿ��� �����ϴ� �÷�
       DEPARTMENT_ID AS �μ��ڵ�,
       LPAD(' ',4*(LEVEL-1))||DEPARTMENT_NAME AS �μ���,
       PARENT_ID AS �����μ��ڵ�,
       CONNECT_BY_ISLEAF
  FROM DEPTS
 START WITH PARENT_ID IS NULL
 CONNECT BY  PRIOR DEPARTMENT_ID=PARENT_ID;
 --�ڽĿ� �ش�Ǵ°� �θ� = �ڿ� ����
 NOCYCLE
 --���� �ؿ� �ִ� ������ TERMINAL/LEAF
 --�θ� ������ SI...??
 --
 ------------------------------------------------------------------------------------
2022-0422-01)TABLE JOIN
  - ������ DB�� ���� �ٽ� ���
  - �������� ���̺� ���̿� �����ϴ� ���踦 �̿��� ����
  - ����ȭ�� �����ϸ� ���̺��� ���ҵǰ� �ʿ��� �ڷᰡ �������� ���̺�
    �л� ����� ��� ����ϴ� ���� 
  - JOIN�� ����
   . �Ϲ����� vs ANSI JOIN  -- // �̱�ǥ������ȸ���� ���� ����ǥ��
   . INNER JOIN vs OUTER JOIN   --���� �´°͸� // ���� ���� �� �������� ����� ���� �� O
   . Equi-Join vs Non Equi-Join  --���� ���ǿ� = ������ ��� // =���X
   . ��Ÿ(Cartesian Product, self Join,...etc)    -- �Ұ����ҋ������ ����ؼ��� �ȵ� // 
 -�������
  SELECT �÷�list
    FROM ���̺��1 [��ĥ1],���̺��2 [��Ī2][,���̺��3 [��Ī3],...]  --���� ���ε� ���� ���̺�� �� �� // ��Ī: ������
   WHERE ��������  -- (���̺�n-1��)
   [AND �Ϲ�����]
  . ���̺� ��Ī�� �������� ���̺� ������ �÷����� �����ϰ� �ش� �÷��� �����ϴ� ���  --�ݵ�� ������ �÷���
    �ݵ�� ���Ǿ�� ��
  . ���Ǵ� ���̺��� n�� �϶� ���������� ��� n-1�� �̻��̾�� ��
  . ���������� �� ���̺� ���� ������ �÷��� �����

 1. Cartesian Product
  - ���������� ���ų� ���������� �߸��� ��� �߻�  --���ǽ��� �߸� ���
  - �־��� ���(���������� ���� ���) A���̺�(a�� b��)�� B���̺�(c�� d��)��
    Cartesian Product�� �����ϸ� ����� a*c��, b+d���� ��ȯ
  - ANSI������ CROSS JOIN�̶�� �ϸ� �ݵ�� �ʿ��� ��찡 �ƴϸ� �������� ���ƾ��ϴ�
    JOIN�̴�.
    
    (�������-�Ϲ�����)
SELECT �÷�list
 FROM ���̺��1 [��Ī1],���̺��2 [��Ī2][,���̺��3 [��Ī],...]
 
    (�������-ANSI����)
SELECT �÷�list
 FROM ���̺��1 [��Ī1] -- ���̺�� ������ �ϳ�
 CROSS JOIN ���̺��2;  --������ ���� �տ�  // ON ������ ��������
 
 
 ��뿹)
  SELECT COUNT(*)
 FROM PROD;
 
  SELECT COUNT(*)
 FROM CART;
 
  SELECT COUNT(*)
 FROM BUYPROD;
 
 
 SELECT COUNT(*)
 FROM PROD A,CART B, BUYPROD C;
 
 
 SELECT COUNT(*)
 FROM PROD A
 CROSS JOIN CART B
 CROSS JOIN BUYPROD C;  --�Ƚ� ������ ���������� ��� ����
 
 2.Equi Join     --�Ƚ����ο����� �̳����� ���
  - ���� ���ǿ� '='�����ڰ� ���� �������� ��κ��� ������ �̿� ���Եȴ�.
  - �������� ���̺� �����ϴ� ������ �÷����� ��� �򰡿� ���� ����
  (�Ϲ� ���� �������)
  SELECT �÷�list
   FROM ���̺�1 ��Ī, ���̺�2 ��Ī[,���̺�3 ��Ī3,...]  --������ ���̺� �ΰ� �̻� ��� //���� ���̺� ���� ���ε� ��Ī�� �ٸ���
   WHERE ��������    --�������ǿ�' = '������ ��� : Equi����
  
  (ANSI ���� �������) 
   SELECT �÷�list
   FROM ���̺�1 ��Ī1  --**���̺� �� �ϳ�
   INNER JOIN ���̺�2 ��Ī2 ON(�������� [AND �Ϲ�����])
   (INNER JOIN ���̺�3 ��Ī3 ON(�������� [AND �Ϲ�����])   --�ش� ���̺��� �����ϴ� ����    // ���̺�1�� 2�� �ݵ�� �����÷��� �־����
          :                                                                        //���̺�3�� 1,2 �� �ϳ��� ������ ������ ��
   [WHERE �Ϲ�����]  --��� ���̺� ���� �����ϴ� ����                                     //���̺� 1~3�� 4���̺��� ������ ������ ��
    . 'AND �Ϲ�����' : ON ���� ����� �Ϲ������� �ش� INNER JOIN ���� ����
      ���ο� �����ϴ� ���̺� ���ѵ� ����
    . 'WHERE �Ϲ�����': ��� ���̺� ����Ǿ�� �ϴ� ���Ǳ��

��뿹)2020�� 1�� ��ǰ�� �������踦 ��ȸ�Ͻÿ�.   --> �Ϲ�����: 2020�� 1��
  Alias�� ��ǰ�ڵ�,��ǰ��,���Աݾ��հ��̸� ��ǰ�ڵ������ ���
  
  (�Ϲ� JOIN)
  SELECT A.BUY_PROD AS ��ǰ�ڵ�,
         B.PROD_NAME AS ��ǰ��,
         SUM(BUY_QTY*PROD_COST) AS ���Աݾ��հ�
    FROM BUYPROD A,PROD B
  WHERE A.BUY_PROD=B.PROD_ID --��������
    AND A.BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200131')
    GROUP BY A.BUY_PROD,B.PROD_NAME            --�����Լ� ���� ���� ���
    ORDER BY 1;
    
 (ANSI JOIN)
  SELECT A.BUY_PROD AS ��ǰ�ڵ�,
         B.PROD_NAME AS ��ǰ��,
         SUM(A.BUY_QTY) AS ����,
         SUM(A.BUY_QTY*B.PROD_COST) AS ���Աݾ��հ�
    FROM BUYPROD A
   INNER JOIN PROD B ON(A.BUY_PROD=B.PROD_ID) --��������    //�̳�����->����
          AND A.BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200131')
    GROUP BY A.BUY_PROD,B.PROD_NAME           
    ORDER BY 1;

��뿹)��ǰ���̺��� �ǸŰ��� 50���� �̻��� ��ǰ�� ��ȸ�Ͻÿ�.
 Alias�� ��ǰ�ڵ�,��ǰ��,�з���,�ŷ�ó��,�ǸŰ����̰� �ǸŰ����� ū ��ǰ������ ����Ͻÿ�.
 (�Ϲ�)
    SELECT A.PROD_ID AS ��ǰ�ڵ�,
           A.PROD_NAME AS ��ǰ��,
           B.LPROD_NM AS �з���,      --�з����̺�
           C.BUYER_NAME AS �ŷ�ó��,
           A.PROD_PRICE AS �ǸŰ���
    FROM PROD A, LPROD B, BUYER C 
    WHERE A.PROD_LGU=B.LPROD_GU --�з��� ��� ����
    AND A.PROD_BUYER=C.BUYER_ID --�ŷ�ó�� ���
    AND A.PROD_PRICE>=500000    --�Ϲ�����
    ORDER BY 5 DESC;
   
   (�Ƚ�) 
     SELECT A.PROD_ID AS ��ǰ�ڵ�,
           A.PROD_NAME AS ��ǰ��,
           B.LPROD_NM �з���,
           C.BUYER_NAME AS �ŷ�ó��,
           A.PROD_PRICE AS �ǸŰ���
    FROM  PROD A
    INNER JOIN BUYER B ON (A.PROD_BUYER=B.BUYER_ID)  --�ŷ�ó��(������ ����)
    INNER JOIN LPROD C ON (A.PROD_LGU=C.LPROD_GU)     --�з���
    WHERE APROD_PRICE>=500000  --
    ORDER BY 5 DESC;

 
��뿹)2020�� ��ݱ� �ŷ�ó�� �Ǹſ����踦 ���Ͻÿ�. --BUYER
    Alias�� �ŷ�ó�ڵ�,�ŷ�ó��,�Ǹž��հ� --����(CART)*�ܰ�(PROD)
    --�ŷ�ó���� ��ǰ�ϴ� ��ǰ�� �󸶳� �ȷȴ��� �˷��� BUYER�� CART�� ���� �Ǿ�� �ϴµ� �����÷��� ����
    --�߰��ٸ��� �Ǵ� ���̺�(PROD)�� �ʿ���.
    --�ش�Ⱓ���� �Ǹŵ� ��ǰ �ڵ�� ��ǰ�ڵ峢�� �� -> �ܰ�, �ŷ�ó�ڵ�
    --�ܰ�-�ܰ�*����, �ŷ�ó�ڵ�-�ŷ�ó���̺�� ��
    SELECT A.BUYER_ID AS �ŷ�ó�ڵ�,
           A.BUYER_NAME AS �ŷ�ó��,
           SUM(B.CART_QTY*C.PROD_PRICE) AS �Ǹž��հ�
      FROM BUYER A, CART B, PROD C
     WHERE SUBSTR(B.CART_NO,1,6) BETWEEN '202001' AND '202006' --(�Ϲ�����)�Ǹ����ڸ� �����ؾ��ϴϱ� CART�� ���õ�  
       AND B.CART_PROD=C.PROD_ID --(��������) �ܰ�����
       AND A.BUYER_ID=C.PROD_BUYER --(��������) �ŷ�ó����
     GROUP BY A.BUYER_ID, A.BUYER_NAME
     ORDER BY 1;
     
��뿹)HR�������� �̱� �̿��� ������ ��ġ�� �μ��� �ٹ��ϴ� ��������� ��ȸ�Ͻÿ�.
     Alias�� �����ȣ,�����,�μ���,�����ڵ�,�ּ� --�ּ�=�ٹ����ּ�
     --�̱��� �����ڵ�� 'US'�̴�
     --DEPARTMENTS(��)->(��)LOCATIONS(��)->(��)COUNTRIES
     --�����ڵ�� COUNTRIES�� �⺻Ű���� COUNTRIES���� ������ �ʹ� �־ 
     --LOCATIONS�� COUNTRY_ID�� ������ (�ռҸ��� �𸣰����� �𵨸� ���� ��....)
     SELECT A.EMPLOYEE_ID AS �����ȣ,
            A.EMP_NAME AS �����,
            B.DEPARTMENT_NAME AS �μ���,
            A.JOB_ID AS �����ڵ�,
            C.STREET_ADDRESS||' '||C.CITY||', '||C.STATE_PROVINCE AS �ּ�
       FROM HR.employees A, HR.departments B, HR.locations C
      WHERE C.COUNTRY_ID != 'US' --�Ϲ�����
        AND A.DEPARTMENT_ID=B.DEPARTMENT_ID --��������(�μ�����)
        AND B.LOCATION_ID=C.LOCATION_ID --��������(�ش�μ��� ��ġ�ڵ�� �ּҸ� �����ϱ� ���� ��������)
      ORDER BY 1;
    --�����Լ��� ������ �ʾұ� ������ GROUP BY���� ���� ������  

p301���� 90%
UPDATE PROD
       SET PROD_PRICE = PROD_COST
     WHERE PROD_LGU ='P301';
COMMIT;
