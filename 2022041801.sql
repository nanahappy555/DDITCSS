2022-0418-01)
 6) WIDTH_BUCKET(n,min,max,b)--n�Ű����� 0������ 100������ 10�������� ������ ��� ���ϴ���
  - min���� max���� ������ b���� �������� ������ �־��� �� n�� ���� ������
    �ε��� ���� ��ȯ
  - max ���� ������ ���Ե��� ������, min���� ���� n���� 0���� 
    max���� ū ���� b+1�����ε����� ��ȯ��
    --n>=min =>���� ù��° ���� 1����
    --max�� n�� ������ �� �� (1~100���̶�� �� �� MAX�� 100�̰� N�� 99������ ��)
    --100�� 11���� 0�� 0����
    -- 0,B,B+1 �� 12����
��뿹)
  SELECT WIDTH_BUCKET(60,20,80,4) AS COL11,
         WIDTH_BUCKET(80,20,80,4) AS COL12, --���Ѱ��̴ϱ� 4+1=>5����
         WIDTH_BUCKET(20,20,80,4) AS COL13, --���Ѱ��� �ش籸���� ���ԵǴϱ� 1����
         WIDTH_BUCKET(10,20,80,4) AS COL14, --���Ѱ�(1����)���� �����ϱ� 0����
         WIDTH_BUCKET(100,20,80,4) AS COL15 --���Ѱ� �ʰ� 5����
    FROM DUAL;  
    
��뿹) ȸ�����̺��� 1000~6000 ���ϸ����� 6���� �������� ���������� �� ȸ������
       ���ϸ����� ���� ����� ���Ͽ� ����Ͻÿ�.
       Alias�� ȸ����ȣ,ȸ����,���ϸ���,���
       ��, ����� ���ϸ����� 6000�ʰ��� ȸ������ 1��޿��� ������������� �з��Ͻÿ�
       --���� ���ÿ� �ݴ�� ���ϸ����� ������ ���� ��� ũ�� ū ������� ����ؾߵ�
       SELECT MEM_ID AS ȸ����ȣ,
              MEM_NAME AS ȸ����,
              MEM_MILEAGE AS ���ϸ���, -- 6����+ �ʰ��̸�2���� = 8����
              8-WIDTH_BUCKET(MEM_MILEAGE,1000,6000,6)AS ���, --������ ��-������=���ݴ��� ��
              WIDTH_BUCKET(MEM_MILEAGE,6000,999,6) + 1 AS ��� --������ ��-������=���ݴ��� ��
         FROM MEMBER;
       
3. ��¥�� �Լ� --���� ���� ����
 1) SYSDATE
  . �ý��ۿ��� �����ϴ� ��¥�� �ð����� ��ȯ
  . -�� +�� ������ ������
  
��뿹)SELECT SYSDATE+3650 FROM DUAL; --������ ���õ� 10���

 2) ADD_MONTHS(d,n)
  . �־��� ��¥ d�� n������ ���� ��¥ ��ȯ
��뿹)SELECT ADD_MONTHS(SYSDATE,120) FROM DUAL; --������� 10���

 3) NEXT_DAY(d,c)
  . �־��� ��¥ ������ ó�� ������ c������ ��¥�� ��ȯ
  . c�� '������','��' ~ '�Ͽ���','��' �� �ϳ��� ���� ����
��뿹) --���� 4/18(��)
    SELECT NEXT_DAY(SYSDATE,'������'), --������ �����ϰ� ���� ������ 25
           NEXT_DAY(SYSDATE,'�Ͽ���'), --�̹��� �Ͽ���
           NEXT_DAY(SYSDATE,'�����') --�̹��� �����
      FROM DUAL;       
      
 4) LAST_DAY(d) --�ٸ��ź��� Ȱ��� �ɲ� ����
  - �־��� ��¥�ڷ� d�� ���Ե� ���� ������ ��¥�� ��ȯ
  - �ַ� 2���� ����������(����/���)�� ����Ҷ� ���� --Ȧ���� ����X
��뿹)������̺��� 2���� �Ի��� ��������� ��ȸ�Ͻÿ�
      Alias�� �����ȣ, �����, �μ���, ����, �Ի����̴�
    SELECT A.EMPLOYEE_ID AS �����ȣ,
           A.(FIRST_NAME||' '||LAST_NAME) AS �����,
           B.DEPARTMENT_NAME AS �μ���,
           C.JOB_TITLE AS ����,
           A.HIRE_DATE AS �Ի���
      FROM HR.employees A, HR.departments B, HR.jobs C  --���̺�3�� �������� 2���̻�, �����÷� ������
     WHERE A.DEPARTMENT_ID=B.DEPARTMENT_ID    --A�� DEPART_ID�� B�� DEPART_ID�� �������� ����
       AND A.JOB_ID=C.JOB_ID
       AND EXTRACT(MONTH FROM A.HIRE_DATE)=2; --A���̺��� �Ի��Ͽ��� 2�� ��������(2��)

��뿹) �������̺�(BUYPROD)���� 2020�� 2�� ���ں� �������踦 ���Ͻÿ�.
       Alias�� ��¥,�ż����հ�,���Աݾ��հ��̸� ��¥������ ����Ͻÿ�.
       SELECT BUY_DATE AS ��¥,
              SUM(BUY_QTY) AS �ż����հ�,
              SUM(BUY_QTY * BUY_COST) AS ���Աݾ��հ�
         FROM BUYPROD --TO_DATE���ڸ���¥�� ���� ���� Ÿ�Ժ��� �����
        WHERE BUY_DATE BETWEEN TO_DATE('20200201') AND LAST_DAY(TO_DATE('20200201')) --2020/02/01�� �޿� ��������=2020/02/29
        GROUP BY BUY_DATE
        ORDER BY 1;
        
 5) EXTRACT(fmt FROM d)   ���󵵼� ����     
   - �־��� ��¥�ڷ� d���� fmt(Format String:���Ĺ��ڿ�)�� ���õ� ���� ��ȯ
   - fmt�� YEAR,MONTH,DAY,HOUR,MINUTE,SECOND �� �ϳ� --���ջ��X
   - ����� �����ڷ��̴�.
��뿹)ȸ�����̺��� �̹��޿� ������ �ִ� ȸ���� ��ȸ�Ͻÿ�
      Alias�� ȸ����ȣ,ȸ����,�������,���ϸ��� --�°� ��µ� ���ǿ� �´� �ڷᰡ ��� ���� ����
      SELECT MEM_ID AS ȸ����ȣ,
             MEM_NAME AS ȸ����,
             MEM_BIR AS �������,
             MEM_MILEAGE AS ���ϸ���
        FROM MEMBER
       WHERE EXTRACT(MONTH FROM SYSDATE)= EXTRACT(MONTH FROM MEM_BIR);       
      --���� ��¥���� �� ����=������Ͽ��� �� ����
      
��뿹)������ 2020�� 4�� 18���̶�� �����Ҷ�
      ������̺��� �ټӳ���� 15�� �̻��� ����� ��ȸ�Ͻÿ�  
      Alias�� �����ȣ,�����,�Ի���,�ټӳ��,�޿�
      SELECT EMPLOYEE_ID AS �����ȣ,
             (FIRST_NAME||' '||LAST_NAME) AS �����,
             HIRE_DATE AS �Ի���,
             EXTRACT(YEAR FROM TO_DATE('20200418')) -    --���ڿ�->��¥(X)�� �ڵ�����ȯ�ȵ�
             EXTRACT(YEAR FROM HIRE_DATE) AS �ټӳ��,    --�������� ��¥�� ����ȯ �������->TO_DATE �ʿ�
             SALARY AS �޿�
        FROM HR.EMPLOYEES
       WHERE EXTRACT(YEAR FROM TO_DATE('20200418')) -    
             EXTRACT(YEAR FROM HIRE_DATE) >=15
       ORDER BY 4 DESC;     
   