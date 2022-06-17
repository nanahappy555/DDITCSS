4)��Ÿ������
    (1) IN ������   --OR���� ��� �����ѵ� IN�� �����ؼ� ���� ����     >,<�� �� ��. =�� ���ԵǾ��־
     - �ҿ������̰ų� ��Ģ���� ���� �ڷḦ ���Ҷ� ���
     - OR������, =ANY, =SOME�����ڷ� ��ȯ����
     - IN �����ڿ��� '='����� ������
    (�������)
     expr IN(��1, ��2,...��n) --�Ǵ� expr=��1 �Ǵ� expr=��2 ...
        - 'expr'(����)�� ���� ����� '��1' ~ '��n' �� ��� �ϳ��� ��ġ�ϸ� ����� ��(true)�� ��ȯ
        
(��뿹) ������̺��� 20��, 70��, 90��, 110�� �μ��� �ٹ��ϴ� ����� ��ȸ�Ͻÿ� --�ѻ���� �� �μ����� �Ҽӵ� �� ������ �ߺ�X
        Alias�� �����ȣ,�����,�μ���ȣ,�޿��̴�.
        
    (OR ������ ���)    
        SELECT EMPLOYEE_ID AS �����ȣ,
               EMP_NAME AS �����,
               DEPARTMENT_ID AS �μ���ȣ,
               SALARY AS �޿�
          FROM HR.employees
         WHERE DEPARTMENT_ID=20
            OR DEPARTMENT_ID=70
            OR DEPARTMENT_ID=90
            OR DEPARTMENT_ID=110;
            
    (IN ������ ���)        
        SELECT EMPLOYEE_ID AS �����ȣ,
               EMP_NAME AS �����,
               DEPARTMENT_ID AS �μ���ȣ,
               SALARY AS �޿�
          FROM HR.employees
         WHERE DEPARTMENT_ID IN(20, 70,90,110);
         
    (=ANY(=SOME) ������ ���)        
        SELECT EMPLOYEE_ID AS �����ȣ,
               EMP_NAME AS �����,
               DEPARTMENT_ID AS �μ���ȣ,
               SALARY AS �޿�
          FROM HR.employees
         WHERE DEPARTMENT_ID =ANY(20,70,90,110);    --SOME�� ANY���� =����� ��� =�� �������.
        --     DEPARTMENT_ID =SOME(20,70,90,110);     �����������
        

    (2) ANY, SOME ������   -- (= ���ԵȰ� IN) ANY�� SOME�� ������ ����
        - ��ȣ(=)�� ����� ���Ե��� ���� IN�����ڿ� ���� ��� ����
    (�������)                --���迬���� >< >=<=
     expr  ���Կ�����ANY(SOME)(��1,...��)   --ALL���� ū �� ���� �� ũ�� ��
  
  
    (��뿹)ȸ�����̺��� ������ �������� ȸ������ ���ϸ������� ���� ���ϸ����� ������ ȸ������ ��ȸ�Ͻÿ�. --������ �������� ȸ������ (���� ����)���ϸ���
           Alias�� ȸ����ȣ, ȸ����, ����, ���ϸ���
 ����1.  SELECT MEM_MILEAGE        --1700/900/2200/3200 **���� ũ�ų� **���� ũ�ų�... ū -> ~�ų�=�Ǵ�=OR ->900���� ũ�� ����
        FROM MEMBER                --3200���� Ŭ���� ALL
        WHERE MEM_JOB='������';
     
    2.  SELECT MEM_ID AS ȸ����ȣ,   -- FROM1 WHERE2 SELECT3 (ORDER BY4) �������
               MEM_NAME AS ȸ����,
               MEM_JOB AS ����,
               MEM_MILEAGE AS ���ϸ���
          FROM MEMBER                            
         WHERE MEM_MILEAGE >ANY(1700,900,2200,3200) -- >ANY(��) 'ANY�� �ִ� ������ ū' �� ���̸� SELECT�� ����
         ORDER BY 4;                                -- >=�� �ƴ϶� 900�� ���Ե��� ����
         
         -- <ANY(��) ��� ���� 1700���� �۰ų� OR 900���� �۰ų� OR 2200���� �۰ų� OR 3200���� �۰ų� => 3200���� ������ ���
         -- >ANY(��) ��� ���� 1700���� ũ�ų� OR 900���� ũ�ų� OR 2200���� ũ�ų� OR 3200���� ũ�ų� => 900���� ũ�� ���

�����δ� �̷��� ����Ѵ�.
(SUBQUERY)
    1. SELECT MEM_ID AS ȸ����ȣ,   -- FROM1 WHERE2 SELECT3 (ORDER BY4) �������
               MEM_NAME AS ȸ����,
               MEM_JOB AS ����,
               MEM_MILEAGE AS ���ϸ���
          FROM MEMBER                            
         WHERE MEM_MILEAGE >ANY(SELECT MEM_MILEAGE        
                                  FROM MEMBER                
                                 WHERE MEM_JOB='������')
         ORDER BY 4; 
        
        
    (3) ALL ������
     - ALL������ ����� ���� ��θ� ������ų���� ������ ��(TRUE)�� ��ȯ
    (�������)
      expr ���迬���� ALL(��,....,��n)
    (��뿹)ȸ�����̺��� ������ �������� ȸ���� �� ���� ���� ���ϸ����� ������ ȸ������ �� ���� ���ϸ����� ������ ȸ������ ��ȸ�Ͻÿ�. 
        Alias�� ȸ����ȣ, ȸ����, ����, ���ϸ���                       ----������ �������� ȸ������ (���� ����)���ϸ���
        
        SELECT MEM_ID AS ȸ����ȣ,
               MEM_NAME AS ȸ����,
               MEM_JOB AS ����,
               MEM_MILEAGE AS ���ϸ���
          FROM MEMBER
         WHERE MEM_MILEAGE >ALL(SELECT MEM_MILEAGE      --1700���� ũ�� AND 900���� ũ�� AND 2200���� ũ�� AND 3200���� ŭ => 3200���� ŭ
                                  FROM MEMBER
                                 WHERE MEM_JOB='������')
         ORDER BY 4;  
         
    (4) BETWEEN  --������ ���� ��  
      - ���õ� �ڷ��� ������ ������ �� ���
      - AND �����ڿ� ���� ���
      - ��� ������ Ÿ�Կ� ��� ���� ����,��¥ �� ����
    (�������)
     expr BETWEEN ���Ѱ�  AND  ���Ѱ�  --���Ѱ����� ���Ѱ�����
     . '���Ѱ�'�� '���Ѱ�'�� Ÿ���� �����ؾ� ��
     
    (��뿹)��ǰ���̺��� ���԰����� 100000��~200000�� ������ ��ǰ�� ��ȸ�Ͻÿ�
           Alias�� ��ǰ�ڵ�, ��ǰ��, ���԰�, ���Ⱑ�̸�, ���԰������� ���   --���԰���->�������賾��
           SELECT PROD_ID AS ��ǰ�ڵ�,
                  PROD_NAME AS ��ǰ��,
                  PROD_COST AS ���԰�,
                  PROD_PRICE AS ���Ⱑ
             FROM PROD
            WHERE PROD_COST BETWEEN 100000 AND 200000   -- �������ڷ� �ϴ� �� WHERE PROD_COST>=100000 AND PROD_COST<=200000
            ORDER BY 3;                                 
    (��뿹)������̺��� 2006��~2007�� ���̿� �Ի��� ������� ��ȸ�Ͻÿ�
           Alias�� �����ȣ,�����,�Ի���,�μ��ڵ��̸� �Ի��� ������ ���
           SELECT EMPLOYEE_ID AS �����ȣ,
                  EMP_NAME AS �����,
                  HIRE_DATE AS �Ի���,
                  DEPARTMENT_ID AS �μ��ڵ�
             FROM HR.employees
            WHERE HIRE_DATE BETWEEN TO_DATE('20060101') AND TO_DATE('20071231')
            ORDER BY 3;
           
    (��뿹)��ǰ�� �з��ڵ尡 'P100'����('P101'-'P199')�� ��ǰ�� �ŷ��ϴ� �ŷ�ó������ ��ȸ�Ͻÿ�.  
           Alias�� �ŷ�ó�ڵ�,�ŷ�ó��,�ּ�,�з��ڵ�
           SELECT BUYER_ID AS �ŷ�ó�ڵ�,
                  BUYER_NAME AS �ŷ�ó��,
                  BUYER_ADD1||' '||BUYER_ADD2 AS �ּ�,
                  BUYER_LGU AS �з��ڵ�
             FROM BUYER
            WHERE BUYER_LGU BETWEEN 'P101' AND 'P199'
            ORDER BY 4;
     
      
    (5) LIKE ������      --���ڿ� ��(��¥,����X). �񱳴�� ���ڿ�.
      - ������ ���ϴ� ������
      - ���ϵ�ī��(���Ϻ񱳹��ڿ�) : '%'�� '_'�� ���Ǿ� ������ ������ 
    (�������)
    expr LIKE '���Ϲ��ڿ�'
1) '%' : '%'�� ���� ��ġ���� ������ ��� ���ڿ��� ���
    ex) SNAME LIKE '��%' => SNAME�� ���� '��'���� �����ϴ� ��� ���� ������
        SNAME LIKE '%��%' => SNAME�� ���� '��'�� �ִ� ��� ���� ������  
        SNAME LIKE '%��' => SNAME�� ���� '��'���� ������ ��� ���� ������
1) '_' : '_'�� ���� ��ġ���� �ϳ��� ���ڿ� ���
    ex) SNAME LIKE '��_' => SNAME�� ���� 2�����̸� '��'���� �����ϴ� ���ڿ��� ������
        SNAME LIKE '_��_' => SNAME�� �� �� 3���ڷ� ������ �� �� �߰��� ���ڰ� '��'�� �����Ϳ� ������  
        SNAME LIKE '_��' => SNAME�� �� �� 2�����̸� '��'���� ������ ���ڿ��� ������        
        
  (��뿹) ��ٱ������̺�(CART)���� 2020�� 6���� �Ǹŵ� �ڷḦ ��ȸ�Ͻÿ�
          Alias�� �Ǹ�����, ��ǰ�ڵ�, �Ǹż����̸� �Ǹ��� ������ ����Ͻÿ�.
          SELECT SUBSTR(CART_NO,1,8) AS �Ǹ�����, 
                 CART_PROD AS ��ǰ�ڵ�,
                 CART_QTY AS �Ǹż���
            FROM CART
           WHERE CART_NO LIKE '202006%'  --202006 �ڷ� � ���� �͵� �������
           ORDER BY 1;
          
  (��뿹) �������̺�(BUYPROD)���� 2020�� 6���� ���Ե� �ڷḦ ��ȸ�Ͻÿ�
          Alias�� ��������, ��ǰ�ڵ�, ���ż���, ���ž��̸� ������ ������ ����Ͻÿ�.  
          SELECT BUY_DATE AS ��������,
                 BUY_PROD AS ��ǰ�ڵ�,
                 BUY_QTY AS ���ż���,
                 BUY_COST*BUY_COST AS ���ž�
            FROM BUYPROD                                     --BUY_DATE�÷��� Ÿ���� DATE�� LIKE�� ����X
           WHERE BUY_DATE BETWEEN TO_DATE('20200601') AND TO_DATE('20200630') --LIKE '2020/06%'�� ������ ���ڿ��� �ν������� �̷��� ���� ���� �Ф�
           ORDER BY 1;
          
  (��뿹) ȸ�����̺��� �泲�� �����ϴ� ȸ���� ��ȸ�Ͻÿ�.
          Alias�� ȸ����ȣ, ȸ����, �ּ�, ���ϸ���
          SELECT MEM_ID AS ȸ����ȣ,
                 MEM_NAME AS ȸ����,
                 MEM_ADD1||' '||MEM_ADD2 AS �ּ�,
                 MEM_MILEAGE AS ���ϸ���
            FROM MEMBER
           WHERE MEM_ADD1 LIKE '�泲%';        