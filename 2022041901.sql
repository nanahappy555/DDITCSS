2022-0419-01)�����Լ� �߿�!
 - �ڷḦ �׷�ȭ�ϰ� �׷쳻���� �հ�,�ڷ��,���,�ִ�,�ּ� ���� ���ϴ� �Լ�
 - ****SUM, AVG, COUNT, MAX, MIN �� ������****
 - SELECT ���� �׷��Լ��� �Ϲ� �÷��� ���� ���� ��� �ݵ�� GROUP BY���� ����Ǿ�� ��.
 --��׷��� SELECT���� �� ���ߵ�
 --����� �������� ���� ��µǱ� ������ ������ ������� �θ�
(�������)
    SELECT �÷���1,
          [�÷���2,...]
           �����Լ�
      FROM ���̺��
    [WHERE ����]
    [GROUP BY �÷���1[,�÷���2...]]
   [HAVING ����]
   [ORDER BY �ε���|�÷��� [ASC|DESC][,...]]
     . GROUP BY ���� ���� �÷����� ���ʿ��� ����� ������� ��з�, �Һз��� ���� �÷���
       --SELECT���� ���� �÷��� �� �� ������ ���� �� ����~
     . HAVING ���� : �����Լ��� ������ �ο��� ���
     
 1.SUM(col)
  - �� �׷� ���� 'col'�÷��� ����� ���� ��� ���Ͽ� ��ȯ
 2.AVG(col)  
  - �� �׷� ���� 'col'�÷��� ����� ���� ����� ��ȯ
 3.COUNT(*|col)
  - �� �׷� ���� ���� ���� ��ȯ
  - '*'�� ����ϸ� NULL���� �ϳ��� ������ ���
  - �÷����� ����ϸ� �ش� �÷��� ���� NULL�� �ƴ� ������ ��ȯ
 4.MAX(col),MIN(col)
  - �� �׷� ���� 'col'�÷��� ����� �� �� �ִ밪�� �ּҰ��� ���Ͽ� ��ȯ 
***�����Լ��� �ٸ� �����Լ��� ������ �� ����***
EX) 2020/5 ����� �հ� ���� �ְ����ȸ��?
    �ְ����MAX(������հ� SUM)  �̷��� �� �� ����

��뿹)������̺��� ��ü����� �޿��հ踦 ���Ͻÿ�
��뿹)������̺��� ��ü����� ��ձ޿��� ���Ͻÿ�
--��ü���->�Ϲ��÷��� ����->GROUP BY�� ����
    SELECT SUM(SALARY) AS �޿��հ�,
           ROUND(AVG(SALARY)) AS ��ձ޿�,
           MAX(SALARY) AS �ִ�޿�,
           MIN(SALARY) AS �ּұ޿�,
           COUNT(*) AS �����
      FROM HR.employees;

--�Ϲ��Լ��� �����Լ��� ���� ���θ� �����ϴ� ����--���డ��
--�����Լ������� �Ұ���
    SELECT AVG(TO_NUMBER(SUBSTR(PROD_ID,2,3)))
      FROM PROD;

��뿹)������̺��� �μ��� �޿��հ踦 ���Ͻÿ�
��뿹)������̺��� �μ��� ��ձ޿��� ���Ͻÿ�
��뿹)������̺��� �μ��� �ִ�޿����� ���Ͻÿ�
��뿹)������̺��� �μ��� �ּұ޿����� ���Ͻÿ�
-- *�μ�*�� : �� �տ� �ٴ� ���� �����÷� ->�ݵ�� GROUP BY��(�׷��� ��������)
    SELECT DEPARTMENT_ID AS �μ��ڵ�, --�Ϲ��÷�.�����÷�.*�μ���* ��з�
           EMP_NAME AS �����, --�Ϲ��÷� �Һз�
           SUM(SALARY) AS �޿��հ�, --�����Լ�����
           ROUND(AVG(SALARY)) AS ��ձ޿� --����
           COUNT(EMPLOYEE_ID) AS �����, --�����Լ�
           MAX(SALARY) AS �ִ�޿� --�����Լ�
      FROM HR.employees
     GROUP BY DEPARTMENT_ID,EMP_NAME --�μ��ڵ�� �з��� �� �̸����� �з�
     ORDER BY 1;  
--������ ������ ������� �з������� �� �� ����. 
--�̸��� �ߺ��Ǵ� ���� ��� 107���� ������ 107���� �з���

��뿹)������̺��� �μ��� ��ձ޿��� 6000�̻��� �μ��� ��ȸ�Ͻÿ�
    SELECT DEPARTMENT_ID AS �μ��ڵ�, 
           ROUND(AVG(SALARY)) AS ��ձ޿�
      FROM HR.employees
     GROUP BY DEPARTMENT_ID
    HAVING AVG(SALARY)>=6000
     ORDER BY 1;  

��뿹)��ٱ������̺��� 2020�� 5�� ȸ���� ���ż����հ踦 ��ȸ�Ͻÿ�
    SELECT CART_MEMBER AS ȸ����,
           CART_NO AS ���Ź�ȣ,
           SUM(CART_QTY) AS ���ż����հ�
      FROM CART
     WHERE CART_NO LIKE '202005%'
     GROUP BY CART_MEMBER,CART_NO
     ORDER BY 1;

��뿹)�������̺�(buyprod)���� 2020�� ��ݱ�(1~6��) ����,��ǰ�� �������踦 ��ȸ�Ͻÿ�
--�������� �׷칭��, ��ǰ���� �׷� ���� ->�׷���2�� ��׷�:�� �ұ׷�:��ǰ
--select **���� �ٴ� �ֵ��� ����ߵ�, ��ǰ�ڵ�
--���� : where 2020�� �ڷ�� �����ؾߵ�
     --BUY_DATE AS �� =>�Ϻ��� ���
     --1.�ս��� ����
     SELECT EXTRACT(MONTH FROM BUY_DATE) AS ��,
            BUY_PROD AS ��ǰ�ڵ�,
            SUM(BUY_QTY) AS �����հ�,
            SUM(BUY_QTY*BUY_COST) AS ���Աݾ��հ�
       FROM BUYPROD
      WHERE BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200630')       
      GROUP BY EXTRACT(MONTH FROM BUY_DATE),BUY_PROD --�Լ���������!!
      ORDER BY 1,2;

��뿹)�������̺�(buyprod)���� 2020�� ��ݱ�(1~6��) ���� �������踦 ��ȸ�ϵ�
      ���Աݾ��� 1��� �̻��� ���� ��ȸ�Ͻÿ�.
--**��:�÷������ؾߵ�
--HAVING��: �����Լ��� ����� �÷��� ������ �ɰ� ���� �� GROUP BY ���Ŀ� ����.
     SELECT EXTRACT(MONTH FROM BUY_DATE) AS ��,
            SUM(BUY_QTY) AS �����հ�,
            SUM(BUY_QTY*BUY_COST) AS ���Աݾ��հ�
       FROM BUYPROD
      WHERE BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200630')       
      GROUP BY EXTRACT(MONTH FROM BUY_DATE)
     HAVING SUM(BUY_QTY*BUY_COST) >= 100000000 
      ORDER BY 1 ; --���� �����̶� ASC����
      
      
��뿹)ȸ�����̺��� ���� ��� ���ϸ����� ��ȸ�Ͻÿ�
    SELECT CASE WHEN SUBSTR(MEM_REGNO2,1,1)='1' OR
                     SUBSTR(MEM_REGNO2,1,1)='3' THEN '����ȸ��'
                ELSE '����ȸ��' END AS ����,
           ROUND(AVG(MEM_MILEAGE)) AS ��ո��ϸ���
      FROM MEMBER
     GROUP BY CASE WHEN SUBSTR(MEM_REGNO2,1,1)='1' OR
                     SUBSTR(MEM_REGNO2,1,1)='3' THEN '����ȸ��'
              ELSE '����ȸ��' END;
     
��뿹)ȸ�����̺��� ���ɴ뺰 ��ո��ϸ����� ��ȸ�Ͻÿ�
--���ɴ� ���ϴ� ��
1.���� : (���� ��¥���� ���� ���� - ���Ͽ��� ���� ����)
2.���ɴ� : TRUNC(����,-1)
    SELECT TRUNC(EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM MEM_BIR),-1) AS ���ɴ�,
           ROUND(AVG(MEM_MILEAGE)) AS ��ո��ϸ���
      FROM MEMBER
     GROUP BY TRUNC(EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM MEM_BIR),-1)
     ORDER BY 1;

��뿹)ȸ�����̺��� �������� ��ո��ϸ����� ��ȸ�Ͻÿ�
    SELECT SUBSTR(MEM_ADD1,1,2) AS ������,
           ROUND(AVG(MEM_MILEAGE)) AS ��ո��ϸ���
      FROM MEMBER
     GROUP BY SUBSTR(MEM_ADD1,1,2);

��뿹)�������̺�(buyprod)���� 2020�� ��ݱ�(1~6��) ��ǰ�� �������踦 ��ȸ�ϵ�
      �ݾ� ���� ���� 5�� ��ǰ�� ��ȸ�Ͻÿ�.
--1.��ݱ� �������踦 ���� 
--2. ��-> �� ���
  SELECT BUY_PROD AS ��ǰ�ڵ�,
         SUM(BUY_QTY) AS �����հ�,
         SUM(BUY_QTY*BUY_COST) AS ���Աݾ��հ�
    FROM BUYPROD
   WHERE BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200630')
   GROUP BY BUY_PROD
   ORDER BY 3 DESC; 
--3. ��� 74���� ���� 5����
--4. *������ ���ݼ� ������ ���ȣ*�� ����. �̹� �����ϴ� ���ȣROWNUM (�ǻ��÷�)
--5. ROWNUM<=5 =>����WHERE => ������ �������� AND�� ����
--6. 5���� �ϸ� Ʋ�� ����̴�. 
--ORDER BY�� �����Ų �� ����5���� �̾ƾ� ��
--���� ���� FROM-WHERE-GROUPBY-SELECT-ORDERBY
--7.4������ ����� A���̺�� ����ϰ� FROM���� ����, WHERE���ǵ� FROM���� �ɸ�
--�����Ǿ����� �÷���(AS BID)�� �������� ���. �ѱ��� ������������
SELECT A.BID AS ��ǰ�ڵ�,
       A.QSUM AS �����հ�,
       A.CSUM AS ���Աݾ��հ�
  FROM (SELECT BUY_PROD AS BID,
               SUM(BUY_QTY) AS QSUM,
               SUM(BUY_QTY*BUY_COST) AS CSUM
          FROM BUYPROD
         WHERE BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200630')
         GROUP BY BUY_PROD
         ORDER BY 3 DESC) A
 WHERE ROWNUM<=5;          

 
 5. ROLLUP�� CUBE 
 --GROUP BY���� ����� �� �� ����
 --(�߾Ⱦ�)CUBE : �÷������� ���հ����Ѽ� 2^n���� �����ȯ
  1) ROLLUP
   - GROUP BY �� �ȿ� ����Ͽ� ������ ������ ����� ��ȯ
   (�������)
    GROUP BY ROLLUP(�÷���1,[,�÷���2,...,�÷���n])
    . �÷���1,�÷���2,...,�÷���n�� (���� ��������)�������� �׷챸���Ͽ�
      �׷��Լ� ������ �� �����ʿ� ����� �÷����� �ϳ��� ������ �������� �׷챸��,
      ���������� ��ü(���� ��������) �հ� ��ȯ --GROUP BY�� ���� ��������� �����ϴ� ��������°��� �����̶�� ���� �ƴ�
    . n���� �÷��� ���� ��� n+1������ �����ȯ

(��뿹)��ٱ������̺��� 2020�� ����,ȸ����,��ǰ�� �Ǹż������踦��ȸ�Ͻÿ�.
 (GROUP BY ���)
-- GROUP BY���� �����Լ��� ������ ���� �÷� 3�� �� ��
--=> 205���� ��
    SELECT SUBSTR(CART_NO,5,2) AS ��,
           CART_MEMBER AS ȸ����ȣ,
           CART_PROD AS ��ǰ�ڵ�,
           SUM(CART_QTY) AS �Ǹż�������
      FROM CART
     WHERE SUBSTR(CART_NO,1,4)='2020' --���ڿ��̶� =��
     GROUP BY SUBSTR(CART_NO,5,2),CART_MEMBER,CART_PROD
     ORDER BY 1;
     
 (ROLLUP�� ���)    
    SELECT SUBSTR(CART_NO,5,2) AS ��,
           CART_MEMBER AS ȸ����ȣ,
           CART_PROD AS ��ǰ�ڵ�,
           SUM(CART_QTY) AS �Ǹż�������
      FROM CART
     WHERE SUBSTR(CART_NO,1,4)='2020'
     GROUP BY ROLLUP(SUBSTR(CART_NO,5,2),CART_MEMBER,CART_PROD)
     ORDER BY 1;  
     --GROUP BY�� ���� �÷�����3�� + 1 
     --����ȸ������ǰ��-����ȸ����-����-��ü����
     --1)����ȸ������ǰ�� 4�� ȸ��a001 ��ǰp10100001 4��ȸ��a001����ǰp10100001�Ǹż�������
     --2)����ȸ���� 4�� ȸ��a001 ��ǰNULL 4��ȸ��a001���Ǹż������� 28(5+16+7=��ü����28)
     --3)���� 4�� ȸ��NULL ��ǰNULL 4����üȸ���Ǹż������� 347
     --4)��ü ��NULL ȸ��NULL ��ǰNULL 2020����ü�Ǹż������� 1035
     
 **�κ� ROLLUP
  . �׷��� �з� ���� �÷��� ROLLUP�� ��(GROUP BY �� ��)�� ����� ��츦
    �κ� ROLLUP�̶�� ��
  . ex) GROUP BY �÷���1, ROLLUP(�÷���2,�÷���3)�� ���
       =>�÷���1,�÷���2,�÷���3 ��ΰ� ����� ����
         �÷���1,�÷���2�� �ݿ��� ����
         �÷���1 �� �ݿ��� ����
 (�κ� ROLLUP�� ���)    
    SELECT SUBSTR(CART_NO,5,2) AS ��,
           CART_MEMBER AS ȸ����ȣ,
           CART_PROD AS ��ǰ�ڵ�,
           SUM(CART_QTY) AS �Ǹż�������
      FROM CART
     WHERE SUBSTR(CART_NO,1,4)='2020'
     GROUP BY CART_PROD, ROLLUP(SUBSTR(CART_NO,5,2),CART_MEMBER)
     ORDER BY 1;         
   --GROUP BY CART_PROD, ROLLUP(...) CART_PROD��ǰ�ڵ�� �׻� ������ ��  

  2) CUBE --�ʹ� �پ��� ����� �� �Ⱦ�
  - GROUP BY�� �ȿ��� ���(ROLLUP�� ����)
  - ���������� ����
  - CUBE���� ����� �÷����� ���� ������ ��츶�� �����ȯ(2��n�¼� ��ŭ�� �����ȯ)
  (�������)
   GROUP BY CUBE(�÷���1....�÷���n);

 (CUBE ���)
--3���� �÷� -> 2^3=8��
--1ABC 2AB 3AC 4BC 5A 6B 7C 8x
--�� ȸ�� ��ǰ
--1�´�����, 2���� ȸ����ȣ, 3���� ��ǰ�ڵ�, 4ȸ����ȣ�� ��ǰ�ڵ�, 5.����, 6ȸ����ȣ��, 7��ǰ�ڵ常, 8��ü
    SELECT SUBSTR(CART_NO,5,2) AS ��,
           CART_MEMBER AS ȸ����ȣ,
           CART_PROD AS ��ǰ�ڵ�,
           SUM(CART_QTY) AS �Ǹż�������
      FROM CART
     WHERE SUBSTR(CART_NO,1,4)='2020'
     GROUP BY CUBE(SUBSTR(CART_NO,5,2),CART_MEMBER,CART_PROD)
     ORDER BY 1;  