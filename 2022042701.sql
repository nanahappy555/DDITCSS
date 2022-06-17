2022-0427-01)�������� 
    - SQL�� �ȿ� �����ϴ� �� �ٸ� SQL�� --���������� �����ϰ� �ִ� ������ ��������
    - SQL���� �ȿ� ������ ���Ǵ� �߰������ ��ȯ�ϴ� SQL��
    - �˷����� ���� ���ǿ� �ٰ��� ������ �˻��ϴ� SELECT���� ���
    - ���������� �˻���(SELECT)�Ӹ� �ƴ϶� DML(INSERT,UPDATE,DELETE)�������� ����
    - ���������� '()'�ȿ� ����Ǿ�� ��(��, INSERT���� ���Ǵ� SUBQUERY�� ����)
    - ���������� �ݵ�� ������ �����ʿ� ����ؾ��� --�����ڸ� ����...? =>WHERE��
    - ���� ��� ��ȯ ��������(������ ������:>,<.>=,<=,=,!=) --���� ��� �ϳ����̾�ߵ�. ���ϰ� ������ ���ϸ� ������
      vs ���� ��� ��ȯ ��������(������ ������: IN ALL, ANY, SOME, EXISTS) 
    - ������ �ִ� �������� vs ������ ���� �������� --��κ� ��������(JOIN)
    - �Ϲݼ������� vs in-line �������� vs ��ø��������
    --�������� ��ġ. ���� �߿����� ����. ����� ������ ����.
    SELECT�� �Ϲݼ�������
    FROM�� in-line �������� OR in-line view �������� in-line ���������� �ݵ�� ���� ���� �Ǿ�� �Ѵ�
    WHERE�� ��ø��������
    
    --����� �ϳ��� ���� �������� ���Ŀ� ���� ������,������ ��������
    --����� ������������ ��µǰ� ���������� �߰����, ����ؾ��� ������ ������ ��
    
    --��κ��� ���������� ����ϰ� ��κ��� ���������� ����� �������� �����Ѵ�.
    
 1. ������ ���� �������� 
  - ���������� ���̺�� ���������� ���̺��� �������� ������� ���� ���
��뿹)������̺��� ������� ��ձ޿����� ���� �޿��� �޴� ����� ��ȸ�Ͻÿ�.
     Alias�� �����ȣ,�����,�μ���,�޿�
( �������� : ������� �����ȣ,�����,�μ���,�޿��� ��ȸ )
    SELECT A.EMPLOYEE_ID AS �����ȣ,
           A.EMP_NAME AS �����,
           B.DEPARTMENT_NAME AS �μ���,
           A.SALARY AS �޿�
      FROM HR.employees A,HR.departments B
     WHERE A.DEPARTMENT_ID=B.DEPARTMENT_ID
       AND A.SALARY>(��ձ޿�);
( �������� : ��ձ޿� )
  SELECT AVG(SALARY)
    FROM HR.employees
    
(����)  
  SELECT A.EMPLOYEE_ID  AS �����ȣ,
         A.EMP_NAME AS �����,
         B.DEPARTMENT_NAME AS �μ���,
         A.SALARY AS �޿�
    FROM HR.EMPLOYEES A,HR.DEPARTMENTS B 
   WHERE A.DEPARTMENT_ID=B.DEPARTMENT_ID
     AND A.SALARY>(SELECT AVG(SALARY)
                     FROM HR.employees);
    --�� ���̺��� ��� ����ɱ�? �������ŭ �����. 10������ �ִٸ� ù��° ����� ���������� ��հ�� �� ��. �ι�°����� �������� ��հ�� �� ��... 10�����ؾߵ�
    --10���� �����ϴ°ͺ��� �ѹ��� �����ϰ� ����� ��� ���پ��°� ������

(��ձ޿� ���)  
  SELECT A.EMPLOYEE_ID  AS �����ȣ,
         A.EMP_NAME AS �����,
         B.DEPARTMENT_NAME AS �μ���,
         A.SALARY AS �޿�,
         (SELECT ROUND(AVG(SALARY))
            FROM HR.EMPLOYEES) AS ��ձ޿�
    FROM HR.EMPLOYEES A,HR.DEPARTMENTS B 
   WHERE A.DEPARTMENT_ID=B.DEPARTMENT_ID
     AND A.SALARY>(SELECT AVG(SALARY)
                     FROM HR.employees);  
    --�� ���̺��� ��� ����ɱ�? WHERE���� �ִ� �������� 107��(�����) + ��ձ޿��� �����Ǵ� ��� 50(=����Ǵ°��50��) = 157�� �����

(in-line view ��������)  --�ٵ� ��� ���εǴϱ� ������ �ִ� ����������!
  SELECT A.EMPLOYEE_ID  AS �����ȣ,
         A.EMP_NAME AS �����,
         B.DEPARTMENT_NAME AS �μ���,
         A.SALARY AS �޿�,
         ROUND(C.ASAL) AS ��ձ޿�  --���λ���
    FROM HR.EMPLOYEES A,HR.DEPARTMENTS B,
         (SELECT AVG(SALARY) AS ASAL --���. // ���������� �÷��� ��¿��� �ƴ� �������̶� ��Ī�� ����� ���ش�(����Ŭ��������ȭ)
                     FROM HR.employees) C --���̺� �� 3��
   WHERE A.DEPARTMENT_ID=B.DEPARTMENT_ID
     AND A.SALARY>C.ASAL; 
  --�� ���̺��� �� �� ����ɱ�? C���̺�=���������� �� �ѹ� �����.
  
 2. ������ �ִ� ��������  
  - ���������� ���������� �������� ����� ���
  - ��κ��� ��������
  
��뿹)�����������̺�(JOB_HISTORY)�� �μ����̺��� �μ���ȣ�� ���� �ڷḦ ��ȸ�Ͻÿ�.  
      Alias�� �μ���ȣ,�μ��� �̴�.
      SELECT A.DEPARTMENT_ID AS �μ���ȣ, 
             A.DEPARTMENT_NAME AS �μ���
        FROM HR.departments A
       WHERE A.DEPARTMENT_ID=(SELECT DEPARTMENT_ID
                                FROM HR.JOB_HISTORY B
                               WHERE B.DEPARTMENT_ID=A.DEPARTMENT_ID);   
    --single-row subquery returns more than one row 
    --�ϳ��� ���� ��ȯ�Ǿ������� ���� ���� ������������ �������� ���� ��ȯ�ż� �����Ҽ�����
    --A.DEPARTMENT_ID 1�� VS �������� ������ �񱳶� =�����ڸ� �� �� ����
    (�ذ�) �ٵ� ������ �������� ���Ű� ���θ� �ᵵ ��~
    (IN ������ �̿�)
      SELECT A.DEPARTMENT_ID AS �μ���ȣ, 
             A.DEPARTMENT_NAME AS �μ���
        FROM HR.departments A
       WHERE A.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID       --IN =ANY =SOME �����ʿ� �ִ� ����� �ϳ��� ������ ����
                                   FROM HR.JOB_HISTORY);  --<���ε���.�������ִ�����
    --FROM�� ����-> HR.departments �޸𸮿� ���ٳ��� ->����������-> A.DEPARTMENT_ID �޸𸮿� ���ٳ��� ->�޸𸮿� HR.departments�̹� �����ϱ� �������� �ȿ��� HR.departments�� ����� �� ���� (=A.DEPARTMENT_ID)
    (EXISTS ������ �̿�) EXISTS ������ ���� ���������� ����� 1���̶� ������ ���� ���� ���� �͵� ��. ���̺� ���� ���� �͵� �������. �����Ͱ� ���� �� ����
      SELECT A.DEPARTMENT_ID AS �μ���ȣ, 
             A.DEPARTMENT_NAME AS �μ���
        FROM HR.departments A
       WHERE EXISTS (SELECT 1 --����� �ֳ� ������ �߿��ؼ� DEPARTMENT_ID�� �ƴ� *�� �ᵵ ����� 
                       FROM HR.JOB_HISTORY B
                      WHERE B.DEPARTMENT_ID=A.DEPARTMENT_ID);    
                    --�׷��� EXISTS���� ���������� ����Ʈ���� ���� 1�� ��.
                    --B.DEPARTMENT_ID=A.DEPARTMENT_ID���� ���� �÷��� ������ ���� 1�� ��. �� 1�� �ƹ� �ǹ� ����. �׳� ��¸� �Ǹ� ���̴ϱ�.
                    --���̸� �ٱ��� ���������� ����Ǿ� ��µ�

��뿹)2020�� 5�� �Ǹŵ� ��ǰ�� �Ǹ����� �� �ݾױ��� ���� 3�� ��ǰ �Ǹ����������� ��ȸ�Ͻÿ�.
    Alias ��ǰ�ڵ�,��ǰ��,�ŷ�ó��,�Ǹűݾ��հ�
    --���������� ���������� ������ �����غ���...
(��������:�ݾ� ���� ���� 3�� ��ǰ�� ���� ��ǰ�ڵ�,��ǰ��,�ŷ�ó��,�Ǹűݾ��հ踦 ���)
    SELECT ��ǰ�ڵ�,��ǰ��,�ŷ�ó��,�Ǹűݾ��հ�
      FROM PROD A,BUYER C
     WHERE A.PROD_ID --���� 3�� ��ǰ�� ��ǰ�ڵ�
     
(��������:�Ǹűݾױ������� �Ǹ����� ����)
    SELECT A.CART_PROD AS CID, --CID�� ��ǰ�ڵ�
          SUM(A.CART_QTY*B.PROD_PRICE) AS CSUM
      FROM CART A, PROD B
     WHERE A.CART_PROD=B.PROD_ID
       AND A.CART_NO LIKE '2020050%' --LIKE�� ���ڿ�
     GROUP BY A.CART_PROD
     ORDER BY 3 DSEC;

(����)   
  SELECT C.CID AS ��ǰ�ڵ�,
         C.CNAME AS ��ǰ��,
         B.BUYER_NAME AS �ŷ�ó��,
         C.CSUM AS �Ǹűݾ��հ�
    FROM PROD A, BUYER B,
         (SELECT A.CART_PROD AS CID,
                 B.PROD_NAME AS CNAME,
                 SUM(A.CART_QTY*B.PROD_PRICE) AS CSUM
            FROM CART A, PROD B
           WHERE A.CART_PROD=B.PROD_ID
             AND A.CART_NO LIKE '202005%'
           GROUP BY A.CART_PROD,B.PROD_NAME
           ORDER BY 3 DESC) C
   WHERE A.PROD_ID=C.CID
     AND A.PROD_BUYER=B.BUYER_ID
     AND ROWNUM<=3;   
      
��뿹)2020�� ��ݱ⿡ ���žױ��� 1000���� �̻��� ������ ȸ��������
      ��ȸ�Ͻÿ�.
      Alias�� ȸ����ȣ,ȸ����,����, ���ž�, ���ϸ���
1. (��������:ȸ������ ��ȸ. ȸ����ȣ,ȸ����,����, ���ž�, ���ϸ���
        ����:2020�� ��ݱ⿡ ���žױ��� 1000���� �̻��� ������ ȸ��) =��������
        SELECT A.MEM_ID AS ȸ����ȣ,
               A.MEM_NAME AS ȸ����,
               A.MEM_JOB AS ����,
               B.(????) AS ���ž�,
               A.MEM_MILEAGE AS ���ϸ���
          FROM MEMBER A,
              (1000���� �̻� ������ ȸ��)B =��������
         WHERE A.MEM_ID =B.CART_MEMBER      
2. (��������:2020�� ��ݱ⿡ ���žױ��� 1000���� �̻��� ������ ȸ��) --���������� ������ ���� ��ü ������ ������. A�� B(��������)�� �����÷��� �ݵ�� �־�� ��
    --1. Q.���������� SELECT������ ���� ���ñ�?
    --   A.����ȣ(A���̺�� ����.A�� B�� ���ÿ� �����ϴ� �����÷��̾����)
    --2. ȸ���� ���űݾ� �հ�>=1000����
        SELECT A.CART_MEMBER AS BID,
               SUM(A.CART_QTY*B.PROD_PRICE) AS BSUM
          FROM CART A, PROD B --�ܰ��� �������� ���� JOIN
         WHERE A.CART_PROD=B.PROD_ID
           AND SUBSTR(A.CART_NO,1,6) BETWEEN '202001' AND '202006'--LIKE�ȵǴ� ���� ������ �־ �ȵ�. �׸��� ��¥ 8�� �ڸ��� TO_DATE�� ĳ���ñ��� ������ؼ� ���ŷο�
         GROUP BY A.CART_MEMBER
        HAVING SUM(A.CART_QTY*B.PROD_PRICE) >=10000000; --�����Լ�????? WHERE������ HAVING�� ����
        
3. (����-inline-view��������) �������� ����� ����� B(from��)�� �ɸ�. �׷��� �Ȱ��� ��Ī�� �ᵵ �������    
        SELECT A.MEM_ID AS ȸ����ȣ,
               A.MEM_NAME AS ȸ����,
               A.MEM_JOB AS ����,
               B.BSUM AS ���ž�,
               A.MEM_MILEAGE AS ���ϸ���
          FROM MEMBER A,                                        --Q. BID�� BSUM���� �÷� ��Ī�� ���� ����?
              (SELECT A.CART_MEMBER AS BID,                     --   ���� ���������� A.CART_MEMBER�� �ƴ� CART_MEMBER��� ������ ��Ī�� ���� �ʿ䰡 ����.
                     SUM(A.CART_QTY*B.PROD_PRICE) AS BSUM       --   A.CART_MEMBER��� ��µ� ��Ī�� ������ ������������ B.A.CART_MEMBER��� ������ϰ� �׷� ������ ����.
                 FROM CART A, PROD B --�ܰ��� �������� ���� JOIN
                WHERE A.CART_PROD=B.PROD_ID
                      AND SUBSTR(A.CART_NO,1,6) BETWEEN '202001' AND '202006'--LIKE�ȵǴ� ���� ������ �־ �ȵ�. �׸��� ��¥ 8�� �ڸ��� TO_DATE�� ĳ���ñ��� ������ؼ� ���ŷο�
                GROUP BY A.CART_MEMBER
               HAVING SUM(A.CART_QTY*B.PROD_PRICE) >=10000000)B --=��������
         WHERE A.MEM_ID =B.BID;

4. (����-��ø��������) --WHERE���� ���̺������ �ƴ� ���ϰ� ������� SELECT������ ������ �� ���� (�տ��� ���³��배��..ã�Ƽ� ����)
        SELECT A.MEM_ID AS ȸ����ȣ,
               A.MEM_NAME AS ȸ����,
               A.MEM_JOB AS ����,
       --      B.BSUM AS ���ž�,
               A.MEM_MILEAGE AS ���ϸ���
          FROM MEMBER A   
         WHERE A.MEM_ID IN(SELECT B.BID --=���� ���� 1��VS 8���� �� ������ => IN���� ����
                             FROM (SELECT A.CART_MEMBER AS BID,     --��ø �������� SUM�� �÷����� ����� �ȵ�
                                         SUM(A.CART_QTY*PROD_PRICE) --�ٵ� �� SUM�޳�? ���ž� �հ� 1000���� �̻��� ����� ã�ƾ��ؼ� �ʿ��� �÷���.
                                     FROM CART A,PROD 
                                    WHERE A.CART_PROD=PROD_ID
                                      AND SUBSTR(A.CART_NO,1,6) BETWEEN '202001' AND '202006'
                                    GROUP BY A.CART_MEMBER
                                   HAVING SUM(A.CART_QTY*PROD_PRICE)>=10000000)B )  
                     
    --single-row subquery returns more than one row 
    --�ϳ��� ���� ��ȯ�Ǿ������� ���� ���� ������������ �������� ���� ��ȯ�ż� �����Ҽ�����
    --1�� VS �������� 2�� �÷� �񱳶� =�����ڸ� �� �� ����   
    -- => ���������� �ϳ� �� ����ߵ�