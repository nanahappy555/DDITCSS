2022-0425-02)�ܺ�����(OUTER JOIN)  --���򿡴� �ǵ��� ���� ����� ��. =>���տ�����
  - �ڷ��� ������ ���� ���̺��� �������� �����ϴ� ����
  - �ڷᰡ ������ ���̺� NULL ���� �߰��Ͽ� ���� ����
  - �ܺ����� ������'(+)'�� �ڷᰡ ���� �ʿ� �߰�
  - �������� �� �ܺ������� �ʿ��� ��� ���ǿ� '(+)'�� ����ؾ���
  - ���ÿ� �� ���̺��� �ٸ� �� ���̺�� �ܺ����ε� �� ����.
    �� A,B,C ���̺��� �ܺ����ο� �����ϰ� A�� �������� B�� Ȯ��ǰ� ���εǰ�,
    ���ÿ� C�� �������� B�� Ȯ��Ǵ� �ܺ������� ���ȵ�(A=B(+) AND C=B(+))
    --(A=B(+) AND C=B(+)) ���ȵ�.
    --(100=50 => 100 AND 1000=50 =>1000) ==>100���� 1000���� ��ȣ�ؼ� �ȵ�
    --(A=B(+) AND B=C(+)) �� ������. A�� �������� B�� Ȯ��=> �� ����� �������� C�� Ȯ��
  -**�Ϲ����ǰ� �ܺ����������� ���ÿ�AND �����ϴ� �ܺ������� �������ΰ���� ��ȯ��=>ANSI�ܺ������̳� ���������� �ذ�** --��������&�ܺ����� ���� ���°� ����
   --��ǥ���� ��� �ܺ������� �ʿ��� �κп��� '(+)' �� ��ߵ� �Ⱦ��� ������������ ��ȯ
  (�Ϲݿܺ����� �������)
  SELECT �÷�List
    FROM ���̺��1 [��Ī1],���̺��2 [��Ī2][,...]
   WHERE ��������(+);
          :
  (ANSI�ܺ����� �������)
  SELECT �÷�List
    FROM ���̺��1 [��Ī1]
    LEFT|RIGHT|FULL OUTER JOIN ���̺��2 [��Ī2] ON (�������� [AND �Ϲ�����])
          :
  [WHERE �Ϲ�����];
   . LEFT : FROM���� ����� ���̺��� �ڷ��� ������ JOIN���� ���̺��� �ڷẸ�� ���� ���      --�ܺ�������ü�� �߾Ⱦ��ϱ� �ܿ��� ��..
   . RIGHT : FROM���� ����� ���̺��� �ڷ��� ������ JOIN���� ���̺��� �ڷẸ�� ���� ���
   . FULL : FROM���� ����� ���̺�� JOIN���� ���̺��� �ڷᰡ ���� ������ ��� 
   --ex) ������̺� ���� DEPARTMENT_ID NULL���� 12��, DEPARTMENTS���̺� ���� NULL�� ���� 27���� ����
   
   
��뿹)��ǰ���̺��� ��� �з��� ��ǰ�� ���� ��ȸ�Ͻÿ� --"���" ->�ƿ��� ����,���̺�2���ʿ� "~��"->GROUP BY
--��ǰ���̺�PROD(��ǰ74��) & �з��� �Ǿ� ������ ��ǰ�� ���� ��쵵 ���� �� ����LPROD(���� 9����)
    1.��ǰ���̺��� ���� �з��ڵ��� ���� �ߺ��� ���� �����ϰ� ��ȸ�Ͻÿ� DISTINCT ->���� 6����
    SELECT DISTINCT PROD_LGU
      FROM PROD;
    2. �з��� ��ǰ�� �� : ��->�Ϲ��÷� ��->COUNT
    SELECT LPROD_GU AS �з��ڵ�,
           COUNT(PROD_ID) AS "��ǰ�� ��" --����,Ư������@_���� ����ϰ� ���� ���� �ֵ���ǥ
      FROM LPROD A, PROD B
     WHERE A.LPROD_GU=B.PROD_LGU(+) --�з��ڵ带 �������� 
     GROUP BY LPROD_GU
     ORDER BY 1;
    --9������ �������� P401~P403�� PROD���̺� ����. �ٵ� ��ǰ�� 1�� ����
    --COUNT�� (*)�� ���� �����NULL�� 3�ٵ� ��ǰ���� �ν��ؼ� 1�� ī��Ʈ��
    --COUNT(PROD_ID)�⺻Ű�� ����ߵ� -> 0���� ����


��뿹) ������̺��� ��� �μ��� ������� ��ձ޿��� ��ȸ�Ͻÿ�
       ��, ��ձ޿��� ������ ����� ��.
       --HR.EMPLOYEES
       SELECT DISTINCT DEPARTMENT_ID
         FROM HR.EMPLOYEES;
      (�Ϲ� OUTER JOIN) ==>������
       SELECT B.DEPARTMENT_ID AS �μ��ڵ�,
              B.DEPARTMENT_NAME AS �μ���,
              COUNT(A.EMPLOYEE_ID) AS �����,
              ROUND(AVG(A.SALARY)) AS ��ձ޿�
         FROM HR.employees A, HR.departments B, 
        WHERE A.DEPARTMENT_ID(+)=B.DEPARTMENT_ID(+)
        GROUP BY B.DEPARTMENT_ID,B.DEPARTMENT_NAME
        ORDER BY 1;
       (ANSI OUTER JOIN) ==>�°� ����
       SELECT B.DEPARTMENT_ID AS �μ��ڵ�,
              B.DEPARTMENT_NAME AS �μ���,
              COUNT(A.EMPLOYEE_ID) AS �����,
              ROUND(AVG(A.SALARY)) AS ��ձ޿�
         FROM HR.employees A
         FULL OUTER JOIN HR.departments B ON (A.DEPARTMENT_ID=B.DEPARTMENT_ID)
        GROUP BY B.DEPARTMENT_ID,B.DEPARTMENT_NAME
        ORDER BY 1;


��뿹)��ٱ������̺��� 2020�� 6�� ��� ȸ���� �����հ踦 ���Ͻÿ�  --��ٱ���CART ���ȸ��MEMBER ������������ ���� 0������ ���
      (�Ϲ� OUTER JOIN) =>(+)�� Ȯ���� �� ���� �Ϲ��������� 6������ȸ���� �߷����� ������ ��� ȸ���� ������ ����
      SELECT C.MEM_ID AS ȸ����ȣ,  --������ �� ��� CART(������ ȸ��)<MEMBER(���ȸ��)
             C.MEM_NAME AS ȸ����,
             SUM(A.CART_QTY*B.PROD_PRICE) AS ���űݾ��հ�
        FROM CART A, PROD B, MEMBER C      
       WHERE A.CART_PROD=B.PROD_ID  --CART�� PROD�� �ܺ������� �ؾ��ұ�? �ش��ǰ�� �ܰ��� ���ϱ� ���ѰŶ� ��� ǰ���� �ܰ��� �ʿ����. �ܺ�����X
         AND C.MEM_ID=A.CART_MEMBER(+)--CART�� MEMBER�� �ܺ������� �ؾ��ұ�? ��� ȸ���� ������ �ʿ��ؼ� �ܺ����� �ʿ�
         AND A.CART_NO LIKE '202006%'
       GROUP BY C.MEM_ID,C.MEM_NAME;  
       
      (ANSI OUTER JOIN)   
      SELECT C.MEM_ID AS ȸ����ȣ,  --������ �� ��� CART(������ ȸ��)<MEMBER(���ȸ��)
             C.MEM_NAME AS ȸ����,
             NVL(SUM(A.CART_QTY*B.PROD_PRICE),0) AS ���űݾ��հ�
        FROM CART A
       RIGHT OUTER JOIN MEMBER C ON(A.CART_MEMBER=C.MEM_ID) --������غ�..��ü ȸ�������� ��¥�� ���ʿ��ؼ� �Ϲ�����X)
        LEFT OUTER JOIN PROD B ON(B.PROD_ID=A.CART_PROD AND --��ǰ�ڵ���غ�..A,B�� �ƿ��������� ����� C�� �����ϴµ� A,B���� ����� C���� �� �����ϱ� LEFT
             A.CART_NO LIKE '202006%')    --��ǰ �ܰ� �� 2020��6�� �����͸� �ʿ��ϴϱ� AND�� �Ϲ�����
    -- WHERE A.CART_NO LIKE '202006%' �̷��� WHERE���� ���� ���� ������ ���� ������� 6�������ͷ� �����ϴϱ� NULL���� ���� ȸ������ ������� 6���� ������        
       GROUP BY C.MEM_ID,C.MEM_NAME
       ORDER BY 1; 
--**�̷��� ����ϸ� ���� �� ����!
-- ���� A JOIN C => �������� �����Ͱ� �� �����ϱ� RIGHT
-- ���� (A JOIN C) JOIN B => ������ �����Ͱ� �� �����ϱ� LEFT
-- ���� �� �����ϸ� FULL
     
      (��������) (��������(CART<PROD)<MEMBER)�ܺ����� ������ ���� CART---PROD---MEMBER �����͸���
      ��������: 2020�� 6�� ȸ���� �Ǹ����� --CART�� PROD�� ��������. MEMBER�ʿ����
      --MEMBER�ʿ����
      SELECT A.CART_MEMBER AS AID,
             SUM(A.CART_QTY*B.PROD_PRICE) AS ASUM
        FROM CART A,PROD B
       WHERE A.CART_PROD=B.PROD_ID --�ܰ��� �������� ���� JOIN��Ŵ
         AND A.CART_NO LIKE '202006%'
       GROUP BY A.CART_MEMBER;
       
      ��������: ������������� MEMBER ���̿� �ܺ�����
      SELECT TB.MEM_ID AS ȸ����ȣ,
             TB.MEM_NAME AS ȸ����,
             NVL(TA.ASUM,0) AS �����հ�
        FROM (SELECT A.CART_MEMBER AS AID,
                    SUM(A.CART_QTY*B.PROD_PRICE) AS ASUM
               FROM CART A,PROD B
              WHERE A.CART_PROD=B.PROD_ID
                AND A.CART_NO LIKE '202006%'
              GROUP BY A.CART_MEMBER) TA,
             MEMBER TB
       WHERE TA.AID(+)=TB.MEM_ID--������ �÷� �ʿ�. AID�� MEM_ID
       ORDER BY 1;
**REMIND**       
--��������: ���ǿ� �´� ���ʿ� �� �ִ� ������ ����� �������� ����
--�ܺ�����: ���� ������ ���� �ʾƵ� ������. => NULL�� ���� ���Խ��Ѽ� ���� �ʰ� ���� ũ��� ������
      
      