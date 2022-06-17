6.NULL ó���Լ�
 - ����Ŭ�� ��� �÷��� ���� ������� ������ �⺻������ NULL�� �ʱ�ȭ ��
 - ���꿡�� NULL�ڷᰡ �����ͷ� ���Ǹ� ��� ����� NULL�� ��
 - Ư�� �÷��̳� ������ ����� NULL���� ���θ� �Ǵ��ϱ����� *������*��
   IS [NOT] NULL
 - NVL, NVL2, NULLIF ���� ����
 1) IS [NOT] NULL
   . Ư�� �÷��̳� ������ ����� NULL���� ���θ� �Ǵ�('='�δ� NULLüũ ����)
��뿹)������̺��� ���������� NULL�̾ƴϸ� ������(80�� �μ�)�� ������ �ʴ�
     ����� ��ȸ�Ͻÿ�.
     Alias�� �����ȣ,�����,�μ��ڵ�,��������
     SELECT EMPLOYEE_ID AS �����ȣ,
            EMP_NAME AS �����,
            DEPARTMENT_ID AS �μ��ڵ�,
            COMMISSION_PCT AS ��������
       FROM HR.employees
      WHERE COMMISSION_PCT IS NOT NULL --NOT NULL TRUE?  
        --  COMMISSION_PCT != NULL
        AND DEPARTMENT_ID IS NULL; --NULL TRUE?
        
 2) NVL(expr, val) --�ƿ������ο� ���� ��
  . 'expr'�� ���� NULL�̸� 'val'���� ��ȯ�ϰ�, 
    NULL�� �ƴϸ� expr �ڽ��� ���� ��ȯ.
  . 'expr'�� 'val'�� ���� ������ Ÿ���̾�� �� --ũ��� �ȸ¾Ƶ� ��
  
��뿹)��ǰ���̺��� ��ǰ�� ũ��(PROD_SIZE)�� NULL�̸� 'ũ������ ����'��
      ũ�������� ������ �� ���� ����Ͻÿ�.
      Alias�� ��ǰ�ڵ�, ��ǰ��, ���Ⱑ��, ��ǰũ��
      SELECT PROD_ID AS ��ǰ�ڵ�,
             PROD_NAME AS ��ǰ��, 
             PROD_PRICE AS ���Ⱑ��,
             NVL(PROD_SIZE,'ũ������ ����') AS ��ǰũ��
        FROM PROD
       
       --COST���� < PRICE���� SALE����
       --SELECT * =��翭, WHERE���� ����=�����    
       
��뿹)������̺��� ��������(COMMISSION_PCT)�� ������ '���ʽ� ���޴���� �ƴ�'��
      ����� ����ϰ�, ��������(COMMISSION_PCT)�� ������ ���ʽ��� ����Ͽ� ����Ͻÿ�.
      Alias�� �����ȣ,�����,��������,���
      ���ʽ��� ��������*�޿��� 30%
      SELECT EMPLOYEE_ID AS �����ȣ,
             EMP_NAME AS �����,
             NVL(TO_CHAR(COMMISSION_PCT,'0.99'),'���ʽ� ���޴���� �ƴ�') AS ��������,
             NVL(COMMISSION_PCT*SALARY*0.3,0) AS ���ʽ�
        FROM HR.employees;
      
��뿹)2020�� 6�� ��� ��ǰ�� �Ǹ����踦 ��ȸ�Ͻÿ�
      Alias�� ��ǰ�ڵ�,��ǰ��,�Ǹż����հ�,�Ǹűݾ��հ�
      --���, ���� ���� ���ľ =>�ƿ������� --���ſ����� �������� ����������Ҽ�����
      --īƮ���� �Ǹŵ� ��ǰ��, PROD���� ��� ��ǰ(��ǰ������ ����)
      SELECT B.PROD_ID AS ��ǰ�ڵ�, --���߸����ʽ���
             B.PROD_NAME AS ��ǰ��,
             NVL(SUM(A.CART_QTY),0) AS �Ǹż����հ�,
             NVL(SUM(A.CART_QTY*B.PROD_PRICE),0) AS �Ǹűݾ��հ�
        FROM CART A
       RIGHT OUTER JOIN PROD B ON (A.CART_PROD=B.PROD_ID AND
             A.CART_NO LIKE '202006%')
       GROUP BY B.PROD_ID, B.PROD_NAME     
       ORDER BY 1;     
      --PROD_ID�� ������ ��� ����. �ϳ��� �����ߵ�. �ϳ��� ��ǰ�ڵ忡 �ΰ��� �̸��� �俩���� ����.
        --�׷��� ���� ������ SELECT���� �������� ������ ����ߵ�      
      
 3) NVL2(expr, val1, val2)      
  . 'expr'�� NULL�� �ƴϸ� 'val1'�� ��ȯ�ϰ�, NULL�̸� 'val2'�� ��ȯ
  . 'val1'�� 'val2'�� �ݵ�� ���� Ÿ���̾�� ��  

��뿹)��ǰ���̺��� ��ǰ�� ũ��(PROD_SIZE)�� NULL�̸� 'ũ������ ����'��
      ũ�������� ������ �� ���� ����Ͻÿ�.NVL2���
      Alias�� ��ǰ�ڵ�, ��ǰ��, ���Ⱑ��, ��ǰũ��   
      SELECT PROD_ID AS ��ǰ�ڵ�, 
             PROD_NAME AS ��ǰ��, 
             PROD_PRICE AS ���Ⱑ��, 
             NVL2(PROD_SIZE,PROD_SIZE,'ũ������ ����') AS ��ǰũ�� --NULL�� �ƴϸ� �ڱ��ڽ� ���
        FROM PROD;      
        
**������̺��� �����ȣ 119,120,131�� ����� MANAGER_ID���� NULL�� �����Ͻÿ�        
    UPDATE HR.employees
       SET MANAGER_ID=NULL --SET �����ؾ��� �÷��� ���ǹ��� �ƴ϶� =(����)�� �ƴ� �Ҵ� ������.ASIGNMENT 
     WHERE EMPLOYEE_ID IN(119,120,131); 
     
    SELECT * FROM HR.employees;  
    --3�� �ٲ�µ� ����� 4���� ����? 100���� ������  

��뿹)������̺� �� ������� ���������ȣ�� ��ȸ�Ͻÿ�.
      ��������� ������ '�������� ���'�� ���������ȣ ���� ����Ͻÿ�
      NVL2�� �̿��Ͽ� QUERY�� �ۼ�
      Alias�� �����ȣ,�����,�μ���ȣ,�������--=MANAGER_ID�� NULL�̸�
      SELECT EMPLOYEE_ID AS �����ȣ,
             EMP_NAME AS �����,
             DEPARTMENT_ID AS �μ���ȣ,
             NVL2(MANAGER_ID,TO_CHAR(MANAGER_ID),'�����������') AS �������
        FROM HR.employees;
        
-�������� �ͽ���Ʈ.SQL  ��������

** ��ǰ���̺��� �з��ڵ尡 P301�� ��ǰ�� ���Ⱑ���� ���԰������� �����Ͻÿ�
    UPDATE PROD
       SET PROD_PRICE=PROD_COST
     WHERE PROD_LGU='P301';   
     
 4) NULLIF(col1, col2)
  . 'col1'�� 'col2'�� ������ ���̸� NULL�� ��ȯ�ϰ� ���� ���� �ƴϸ�
    COL1 ���� ��ȯ��
    
��뿹)��ǰ���̺��� ���԰��� ���Ⱑ�� �����ϸ� ����� '���� ���� ��ǰ'��
      ���� �ٸ� ���̸� '���� �Ǹ� ��ǰ'�� ����Ͻÿ�.
      Alias�� ��ǰ�ڵ�, ��ǰ��, ���԰�, ���Ⱑ, ���
      SELECT PROD_ID AS ��ǰ�ڵ�,
             PROD_NAME AS ��ǰ��,
             PROD_COST AS ���԰�,
             PROD_PRICE AS ���Ⱑ,
             NVL2(NULLIF(PROD_COST,PROD_PRICE),'���� �Ǹ� ��ǰ','���� ���� ��ǰ') AS ���
        FROM PROD;
--NESTED �Լ��� ��ø���