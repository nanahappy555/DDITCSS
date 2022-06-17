2022-0415-01) �����Լ�
 1. �������Լ�
  - ABS, SIGN, POWER, SQRT���� ������
  1)ABS(n), SIGN(n), SQRT(n), POWER(e,n)
   . ABS(n) : �־��� �� n�� ���밪 --��ȣ�� ����.�������Ҷ�
   . SIGN(n) : �־��� �� n�� ����̸� 1, �����̸� -1, 0�̸� 0�� ��ȯ
   . SQRT(n) : �־��� �� n�� ���� ��ȯ
   . POWER(e,n) : e�� n��(e�� n�� �ŵ� ���� ��)
   
 (��뿹)
    SELECT ABS(- 2000),ABS(0.0009),ABS(0),
           SIGN(- 2000),SIGN(0.0001),SIGN(0),
           SQRT(16),SQRT(87.99),
           POWER(2, 10)
    FROM dual;     
    
  2)GREATEST(n1,...nn), LEAST(n1,...nn)
   . GREATEST(n1,...nn) : �־��� �� n1 ~nn �� ���� ū �� ��ȯ 
   . LEAST(n1,...nn) : �־��� �� n1 ~nn �� ���� ���� �� ��ȯ  
   
��뿹)
  SELECT GREATEST('ȫ�浿','�̼���','ȫ���'),
         GREATEST('APPLE','AMOLD',100),
         LEAST('APPLE','AMOLD',100)
    FROM DUAL;
    
��뿹)ȸ�����̺��� ���ϸ����� ��ȸ�Ͽ� 1000���� ���� ���̸� 1000�� �ο��ϰ�
      1000���� ũ�� ������ ���� ����Ͻÿ�
      Alias�� ȸ����ȣ,ȸ����,�������ϸ���,���渶�ϸ���
  SELECT MEM_ID AS  ȸ����ȣ,
         MEM_NAME AS ȸ����,
         MEM_MILEAGE AS �������ϸ���,
         GREATEST(MEM_MILEAGE,1000) AS ���渶�ϸ��� 
    FROM MEMBER;     
      
  3)ROUND(n, l), TRUNC(n, l)
   . ROUND�� �ݿø�, TRUNC�� �ڸ������� ����
   . l�� ����̸� 
     - ROUND(n, l) : �־����� n���� �Ҽ��� ���� l+1�ڸ����� �ݿø��Ͽ� l�ڸ����� ��ȯ
                     l�� �����ǰų� 0�̸� �Ҽ� ù��° �ڸ����� �ݿø��Ͽ� ���� ��ȯ 
     - TRUNC(n, l) : �־����� n���� �Ҽ��� ���� l+1�ڸ����� �ڸ�����
   . l�� �����̸� 
     - ROUND(n, l) : �־����� n���� �����ι�  l�ڸ����� �ݿø��Ͽ� ��� ��ȯ
     - TRUNC(n, l) : �־����� n���� �����ι�  l�ڸ����� �ڸ�����    
     --TRUNC(2022-1991,-1) : 31�� 1�ڸ����� ���� -> 30 =���ɴ뱸�ϱ�
��뿹)ȸ�����̺��� ���ɴ뺰 ���ϸ����հ�� ȸ������ ���Ͻÿ�
      Alias�� ���ɴ�,ȸ����,���ϸ����հ�
 (1)���̰��
  SELECT  CASE WHEN SUBSTR(MEM_REGNO2,1,1) IN ('1','2') THEN
                    EXTRACT(YEAR FROM SYSDATE)- 
                    (1900+TO_NUMBER(SUBSTR(MEM_REGNO1,1,2)))
                ELSE EXTRACT(YEAR FROM SYSDATE)-
                     (2000+TO_NUMBER(SUBSTR(MEM_REGNO1,1,2)))
           END   AS ����       
    FROM MEMBER;
     
   SELECT EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM MEM_BIR)  
     FROM MEMBER;
     
  (2)���ɴ�� ��ȯ --���Ϸ� ���ϴ°� ����
   SELECT EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM MEM_BIR) AS ����,
          TRUNC(EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM MEM_BIR),-1) 
          AS ���ɴ�
     FROM MEMBER;  
     
   SELECT TRUNC(EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM MEM_BIR),-1) ||'��'
          AS ���ɴ�,
          COUNT(*) AS ȸ����,
          SUM(MEM_MILEAGE) AS "���ϸ��� �հ�"  
     FROM MEMBER
    GROUP BY TRUNC(EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM MEM_BIR),-1) 
    ORDER BY 1;
    
  4) FLOOR(n), CEIL(n)  
   - FLOOR(n): n�� ���ų�(n�� ������ ���) ���� �� �� ���� ū ����
   - CEIL(n): n�� ���ų�(n�� ������ ���) ū �� �� ���� ���� ����     
 ��뿹)
   SELECT FLOOR(102.6777),FLOOR(102),FLOOR(-102.6777),
          CEIL(102.6777),CEIL(102),CEIL(-102.6777)
     FROM DUAL;     
     
  5)REMAINDER(n, m), MOD(n, m) 
   - �־��� �� n�� m���� ���� �������� ��ȯ
   - ���������� ���� ����� �ٸ�
   - MOD(n, m):�Ϲ����� �������� ��ȯ
   - REMAINDER(n, m) : �������� m�� ���ݰ�(0.5)�� �ʰ��ϸ� ��ȯ ���� ���� ���̵Ǳ� 
     ���� �ʿ��� ���� �����̸�, �׿ܴ� MOD�� ����
   - �������
    MOD       = n - m * FLOOR(n/m)
    REMAINDER = n - m * ROUND(n/m)
   ex) MOD(12, 5), REMAINDER(12,5)  
       MOD(12, 5)        = 12 - 5 * FLOOR(12/5)
                         = 12 - 5 * FLOOR(2.4)
                         = 12 - 5 * 2
                         = 2
       REMAINDER(12,5)   = 12 - 5 * ROUND(12/5)
                         = 12 - 5 * ROUND(2.4)
                         = 12 - 5 * 2
                         = 2
       
       MOD(14, 5), REMAINDER(14,5)                  
       MOD(14, 5)        = 14 - 5 * FLOOR(14/5)
                         = 14 - 5 * FLOOR(2.8)
                         = 14 - 5 * 2
                         = 4
       REMAINDER(14,5)   = 14 - 5 * ROUND(14/5)
                         = 14 - 5 * ROUND(2.8)
                         = 14 - 5 * 3
                         = -1
             