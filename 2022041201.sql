2022-0412-01)������
1. �������� ����
 - ���������, ���迬����, ��������,  ��Ÿ������
 1)���������
  . ��Ģ������(+,-,*,/)

��뿹) ������̺�(HR������ EMPLOYESS)���� ������� ���޾��� ����Ͽ� ����Ͻÿ�  --WHERE�� �ʿ����. ������ ���. (�޿��� NN�� �̻��� ����� ���ʽ� �����ض�
        ���ʽ�=�޿�(SALARY)�� 30%
        ���޾�=�޿�+���ʽ�
        Alias�� �����ȣ,�����,�޿�,���ʽ�,���޾��̸� ���޾��� ���� �������� ����Ͻÿ�.
    SELECT EMPLOYEE_ID AS �����ȣ,
           FIRST_NAME||' '||LAST_NAME AS �����,
           SALARY AS �޿�,
           ROUND(SALARY*0.3) AS ���ʽ�,  
           SALARY+ROUND(SALARY*0.3) AS ���޾�
    FROM HR.employees-- �ٸ� ������ �ִ°Ÿ� ������ ����� �� ������.���̺��
    ORDER BY 5 DESC; --5�� �÷��ε���. ���޾� ����ϴ� ���ε� �� ���� ���������־ 5��°���� �����Ѵٴ� ��
    
��뿹)�������̺�(BUYPROD)���� 2020�� 2�� ���ں� �������踦 ��ȸ�Ͻÿ�. -- **�� -> �����Լ��׷��Լ� ��� '2020��2��'����(WHERE)
     Alias�� ����, ���Լ����հ�, ���Աݾ��հ��̸� ���ڼ����� ����Ͻÿ�.
 SELECT BUY_DATE AS ����,  --���� ��¥���� ����
        SUM(BUY_QTY) AS ���Լ����հ�, --���� ��¥���� ���� �� ����
        SUM(BUY_QTY*BUY_COST) AS ���Աݾ��հ� --�ټ����� ����X�ܰ�
   FROM BUYPROD  --�� ���̺��� �ڷ� ��������
  WHERE BUY_DATE BETWEEN TO_DATE('20200201') AND  --20200201����
         LAST_DAY(TO_DATE('20200201')) -- **LAST_DAY �־��� ������ ���� ���������� ã���ִ� �Լ�
GROUP BY BUY_DATE -- GROUP BY �ڿ� ����� �÷� �������� ���踦 ���µ� ��� 
ORDER BY 1; --����� �⺻(��������) ������


    SELECT 238474*23766432675234/347864678
    FROM DUAL; --DUAL �������̺�
    
2)���迬����
 . ���ǽ��� �����Ҷ� ���� --WHERE
 . �������� ��Ұ��踦 �Ǵ��ϸ� ����� true,false�̴�. --�ΰ����� ����
 . >, <, >=, <=, =, !=(<>)  -- != Ȥ�� <> �� �� ��밡��
 . WHERE ���� ���ǽİ� ǥ����(CASE WHEN THEN)�� ���ǽĿ� ��� --CASE WHEN THEN=���ǽ�
 
 ��뿹) ��ǰ���̺�(PROD)���� �ǸŰ�(PROD_PRICE)�� 200000���� �̻��� ��ǰ�� ��ȸ�Ͻÿ�.
        Alias�� ��ǰ�ڵ�,��ǰ��, ���԰���, �ǸŰ����̸� ��ǰ�ڵ� ������ ����� ��.
    1.  SELECT ��ǰ�ڵ�,��ǰ��, ���԰���, �ǸŰ���
          FROM PROD
         WHERE PROD_PRICE>=200000
         ORDER BY 1; --��ǰ�ڵ�ϱ� 1��
         
    2.  SELECT PROD_ID AS ��ǰ�ڵ�,
             PROD_NAME AS ��ǰ��, 
             PROD_COST AS ���԰���,
            PROD_PRICE AS �ǸŰ���
          FROM PROD
         WHERE PROD_PRICE>=200000
         ORDER BY 1; --��ǰ�ڵ�ϱ� 1��         
        
 ��뿹)ȸ�����̺�(MEMBER)���� ���ϸ����� 5000�̻��� ȸ�������� ��ȸ�Ͻÿ�.
       Alias�� ȸ����ȣ, ȸ����, ���ϸ���, �����̸� '����'������ '����ȸ��' �Ǵ� '����ȸ��'�� ����Ұ�. --�����÷��� ����! ���� ã����ߵ�
       SELECT MEM_ID AS ȸ����ȣ,
             MEM_NAME AS ȸ����,
             MEM_MILEAGE AS ���ϸ���,
             MEM_REGNO1||'-'||MEM_REGNO2 AS �ֹι�ȣ,
             CASE WHEN SUBSTR(MEM_REGNO2,1,1)='1' OR 
                       SUBSTR(MEM_REGNO2,1,1)='3' THEN  --THEN�׷��ٸ� ����ȸ��
                       '����ȸ��' 
                  ELSE  --�ݴ�->2�̰ų� 4
                       '����ȸ��' 
             END AS ���� --�� CASE�� �����̶�� �̸� ���̰ڴ�
        FROM MEMBER 
       WHERE MEM_MILEAGE>=5000;
       
3)��������
 - �� �� �̻��� ���ǽ��� ��(AND, OR)�� �Ǵ� Ư�� ���ǽ��� ����(NOT)�� ����� ��ȯ --NOT�� ���(�ѿ�Űó�� ���������� �����Ǵ°�). �����Ͱ� �ϳ��� ���׿�����.
 - ����ǥ
 --------------------------------
  �Է°�             ��°�
  X    Y         AND   OR                            --0OFF 1ON
---------------------------------
  0    0          0     0
  0    1          0     1             AND�϶��� �� �� 1�̾�� 1 EX)����
  1    0          0     1             OR�϶��� �� �� �ϳ��� 1�̾ 1 EX)����
  1    1          1     1
  
  - ��������� NOT->AND->OR --������ ����Ǵ°�. ��ȣ�� �����ٲܼ�����
  
��뿹)ȸ�����̺��� ȸ���� ����⵵�� �����Ͽ� ����� ����� �����Ͽ� ����Ͻÿ�. --��� ȸ�� ����̶� WHERE������ ����
     Alias�� ȸ����ȣ,ȸ���̸�,��������, ���
     **���� = 4�� ����̸� 100�� ����� �ƴϰų� 400���� ����� �Ǵ� ��  --�̸� AND ~�ų�OR
     ----MOD �������� ���ϴ� �Լ�, EXTRACTƯ����������
     
     SELECT MEM_ID AS ȸ����ȣ,
            MEM_NAME AS ȸ���̸�,
            MEM_BIR AS ��������,
            CASE WHEN (MOD(EXTRACT(YEAR FROM MEM_BIR),4)=0) AND (MOD(EXTRACT(YEAR FROM MEM_BIR),100)!=0) OR
                      (MOD(EXTRACT(YEAR FROM MEM_BIR),400)=0)THEN
                      '����'
                 ELSE
                      '���'
            END AS ���
       FROM MEMBER;


**������̺� EMP_NAME VARCHAR2(80)�÷��� �߰��ϰ� FIRST_NAME�� LAST_NAME�� �����Ͽ� EMP_NAME�� �����Ͻÿ�
    1)�÷��� �߰� & ����
    ALTER TABLE HR.employees
      ADD EMP_NAME VARCHAR2(80);
    
    UPDATE HR.employees
       SET EMP_NAME=FIRST_NAME||' '||LAST_NAME;
       
       COMMIT;
       
    SELECT * FROM HR.employees;  
                                                    
��뿹)������̺��� 10�μ����� 50���μ��� ���� ��������� ��ȸ�Ͻÿ�  --10~50 -> BETWEEN������
      Alias�� �����ȣ,�����,�μ���ȣ,�Ի���,��å�ڵ��̸� �μ���ȣ������ ����Ͻÿ�.
      SELECT EMPLOYEE_ID AS �����ȣ,
             EMP_NAME AS �����,
             DEPARTMENT_ID AS �μ���ȣ,
             HIRE_DATE AS �Ի���,
             JOB_ID AS ��å�ڵ�
        FROM HR.employees
       WHERE DEPARTMENT_ID>=10 AND DEPARTMENT_ID<=50  -- DEPARTMENT_ID BETWEEN 10 AND 50 --�̷��� �ڵ� �ᵵ��
       ORDER BY 3; --�μ���ȣ������ ����϶�� ������ 3��°���� ������
       
       
��뿹)��ٱ������̺�(CART)���� 2020�� 6�� ��ǰ�� �Ǹż������踦 ��ȸ�Ͻÿ�.
      ����� ��ǰ�ڵ�, ��ǰ��, �Ǹż����հ�, �Ǹűݾ��հ��̸� �Ǹűݾ��� ���� ������ ����Ͻÿ�.
      -- 1.CART ���̺��� ��ǰ���� ����! �ܰ��� ����! -> �ٸ� ���̺� PROD���� �����;���
      SELECT A.CART_PROD AS ��ǰ�ڵ�,
             B.PROD_NAME AS ��ǰ��,
             SUM(A.CART_QTY) AS �Ǹż����հ�,
             SUM(A.CART_QTY*B.PROD_PRICE) AS �Ǹűݾ��հ� --����X�ܰ�
        FROM CART A,PROD B                 --CART ���̺� ��Ī A. ���̺��� AS�ʿ���� (������)
       WHERE A.CART_PROD=B.PROD_ID   --JOIN���� (���߿� �ٽ� ��)
        AND /*1��*/ SUBSTR(A.CART_NO,1,8)>='20200601' AND
             SUBSTR(A.CART_NO,1,8)>='20200630' 
             /*--2�� SUBSTR*SUBSTR(A.CART_NO,1,6)='203006'
             /*3�� A.CART_NO LIKE'202006%' */      -- GROUP BY �ڿ� ����� �÷� �������� ���踦 ���µ� ���
      GROUP BY A.CART_PROD,B.PROD_NAME    --�����Լ��� �÷� ���� ���?�ݵ���ʿ���...��? �����Լ����� SELECT���� �ߺ���
      ORDER BY 4 DESC; --4��°���� ��->�� ���