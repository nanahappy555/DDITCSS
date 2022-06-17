��뿹)2020 4�� �ŷ�ó�� ���Աݾ��� ��ȸ�Ͻÿ�. --BUYER BUYPROD(����) PROD
      Alias�� �ŷ�ó�ڵ�,�ŷ�ó��,���Աݾ��հ� --�ŷ�ó�� 13���� �� 4���� ���Թ߻� 6����
      --BUYPROD�� �����Ͱ� �� �� �Ȱ��� PROD_ID�� �ִ��� PROD���̺��� �˻��ϰ� INSERT��. 
      --�� �� PROD���̺� ��ǰ�ڵ尡 �ִ��� ���� Ȯ���ϰ� ������ ������� ����.
      (�Ϲ�����)
      SELECT A.BUYER_ID AS �ŷ�ó�ڵ�,
             A.BUYER_NAME AS �ŷ�ó��,
             SUM(B.BUY_QTY*B.BUY_COST) AS ���Աݾ��հ�
        FROM BUYER A, BUYPROD B, PROD C
       WHERE A.BUYER_ID=C.PROD_BUYER    
         AND B.BUY_PROD=C.PROD_ID
         AND B.BUY_DATE BETWEEN TO_DATE('20200401') AND TO_DATE('20200430')
       GROUP BY A.BUYER_ID, A.BUYER_NAME
       ORDER BY 1;
       --�� 13�� 4�� �ŷ�ó 6��. ������ 7���� NULL
       --OUTER JOIN ������ �� �������� ��� NULL�� ������ �پ���
       --�̰� OUTER JOIN���� �ٽ� ����
      (ANSI ����)
      SELECT A.BUYER_ID AS �ŷ�ó�ڵ�,
             A.BUYER_NAME AS �ŷ�ó��,
             SUM(B.BUY_QTY*B.BUY_COST) AS ���Աݾ��հ�
        FROM BUYER A
       INNER JOIN PROD C ON(A.BUYER_ID=C.PROD_BUYER) --FROM���� ���� ���̺�� ù��° INNER JOIN�� ���� ���̺��� ���� ���εǾ����
       INNER JOIN BUYPROD B ON(B.BUY_PROD=C.PROD_ID AND B.BUY_DATE BETWEEN TO_DATE('20200401') AND TO_DATE('20200430'))
       GROUP BY A.BUYER_ID, A.BUYER_NAME
       ORDER BY 1;       
       
      
��뿹)2020 4�� �ŷ�ó�� ����ݾ��� ��ȸ�Ͻÿ�. --BUYER CART(����) PROD
      Alias�� �ŷ�ó�ڵ�,�ŷ�ó��,����ݾ��հ�
      (�Ϲ�����)
      SELECT A.BUYER_ID AS �ŷ�ó�ڵ�,
             A.BUYER_NAME AS �ŷ�ó��,
             SUM(B.CART_QTY*C.PROD_PRICE) AS ����ݾ��հ�
        FROM BUYER A, CART B, PROD C
       WHERE A.BUYER_ID=C.PROD_BUYER    
         AND B.CART_PROD=C.PROD_ID
         AND B.CART_NO LIKE '202004%'
       GROUP BY A.BUYER_ID, A.BUYER_NAME
       ORDER BY 1;  
     
      (ANSI ����)
      SELECT A.BUYER_ID AS �ŷ�ó�ڵ�,
             A.BUYER_NAME AS �ŷ�ó��,
             SUM(B.CART_QTY*C.PROD_PRICE) AS ����ݾ��հ�
        FROM BUYER A
       INNER JOIN PROD C ON(A.BUYER_ID=C.PROD_BUYER)
       INNER JOIN CART B ON(B.CART_PROD=C.PROD_ID AND B.CART_NO LIKE '202004%') --AND �ڰ� �Ϲ�����
       GROUP BY A.BUYER_ID, A.BUYER_NAME
       ORDER BY 1;      
      
��뿹)2020 4�� �ŷ�ó�� ����/����ݾ��� ��ȸ�Ͻÿ�.
      Alias�� �ŷ�ó�ڵ�,�ŷ�ó��,���Աݾ��հ�,����ݾ��հ�
     (�Ϲ�)
      SELECT A.BUYER_ID AS �ŷ�ó�ڵ�,
             A.BUYER_NAME AS �ŷ�ó��,
             SUM(B.BUY_QTY*D.PROD_COST) AS ���Աݾ��հ�,
             SUM(C.CART_QTY*D.PROD_PRICE) AS ����ݾ��հ�
        FROM BUYER A, BUYPROD B, CART C, PROD D
       WHERE A.BUYER_ID=D.PROD_BUYER --(��������)�ŷ�ó �ڵ� ����   
         AND B.BUY_PROD=D.PROD_ID --(��������)���Դܰ� ����
         AND C.CART_PROD=D.PROD_ID --(��������)����ܰ� ����
         AND B.BUY_DATE BETWEEN TO_DATE('20200401') AND TO_DATE('20200430') --(�Ϲ�����)
         AND C.CART_NO LIKE '202004%' --(�Ϲ�����)
       GROUP BY A.BUYER_ID, A.BUYER_NAME
       ORDER BY 1;   
    --����� 6���� ������ ����: INNER JOIN�� ����6��, ����12�� ��
    --��ġ�� 6���� ����� ������ ������ 6���� *����*  
    --ANSI�ε� �ذ�ȵǰ� ���������� ����ؾ� ��.
     (ANSI)
      SELECT A.BUYER_ID AS �ŷ�ó�ڵ�,
             A.BUYER_NAME AS �ŷ�ó��,
             SUM(B.BUY_QTY*D.PROD_COST) AS ���Աݾ��հ�,
             SUM(C.CART_QTY*D.PROD_PRICE) AS ����ݾ��հ�
        FROM BUYER A       --FROM���� PROD�� �´ٸ� BUYER,BUYPROD,CART��� ����JOIN�ǹǷ� �ٷ� ������ �� �� �� �� ����
       INNER JOIN PROD D ON (A.BUYER_ID=D.PROD_BUYER)
       INNER JOIN BUYPROD B ON(B.BUY_PROD=D.PROD_ID AND
             B.BUY_DATE BETWEEN TO_DATE('20200401') AND TO_DATE('20200430'))
       INNER JOIN CART C ON(C.CART_PROD=D.PROD_ID AND C.CART_NO LIKE '202004%')
       GROUP BY A.BUYER_ID, A.BUYER_NAME
       ORDER BY 1;   
    --����� 6���� ������ ����: INNER JOIN�� ����6��, ����12�� ��
    --��ġ�� 6���� ����� ������ ������ 6���� *����*  
    --ANSI�ε� �ذ�ȵǰ� ���������� ����ؾ� ��.
    
    (�ذ� : ��������+�ܺ�����)
    SELECT TB.CID AS �ŷ�ó�ڵ�,     --��������//���Ժ��� �������� ������ �ŷ�ó������ �� ���Ƽ� ���� ������ ��
           TB.CNAME AS �ŷ�ó��,           --//�������� TA.BID�� ���� ���Կ� ���� �ŷ�ó 6������ NULL���� ����
           NVL(TA.BSUM,0) AS ���Աݾ��հ�,
           NVL(TB.CSUM,0) AS ����ݾ��հ�
      FROM (SELECT B.PROD_BUYER AS BID,     --��������
                   SUM(A.BUY_QTY*B.PROD_COST) AS BSUM   --������ ���� ����:�����Ұ��̴�. �ѱۿ����߳�
              FROM BUYPROD A, PROD B, BUYER C
             WHERE A.BUY_DATE BETWEEN TO_DATE('20200401') AND TO_DATE('20200430')
               AND A.BUY_PROD=B.PROD_ID
               AND C.BUYER_ID=B.PROD_BUYER    
             GROUP BY C.BUYER_ID) TA,
           (SELECT A.BUYER_ID AS CID,
                   A.BUYER_NAME AS CNAME,
                   SUM(B.CART_QTY*C.PROD_PRICE) AS CSUM
              FROM BUYER A, CART B, PROD C
             WHERE B.CART_PROD=C.PROD_ID
               AND C.PROD_BUYER=A.BUYER_ID
               AND B.CART_NO LIKE '202004%'
             GROUP BY A.BUYER_ID, A.BUYER_NAME) TB                  
    WHERE TA.BID(+)=TB.CID --�ܺ���������//������ ���� �ʿ� (+)�� ���� Ȯ���ش޶�¶�.
    ORDER BY 1;

��뿹)������̺��� ����� ��ձ޿����� �� ���� �޿��� �޴� ����� ��ȸ�Ͻÿ�.
      Alias�� �����ȣ,�����,�μ��ڵ�,�޿�
      SELECT A.EMPLOYEE_ID AS �����ȣ,
             A.EMP_NAME AS �����,
             A.DEPARTMENT_ID AS �μ��ڵ�,
             A.SALARY AS �޿�
        FROM HR.employees A,
            (SELECT AVG(SALARY) AS BSAL  --���
               FROM HR.employees) B     --SELECT������ �Ϲ��÷��� ������ GROUP BY�� X
       WHERE A.SALARY>B.BSAL  --SALARY�� ��հ� ������ �� �� ũ�� ��� // Non Equi-Join (��������)
       ORDER BY 3;
    --��� 51�� (�μ��ڵ尡 NULL�� ����� 1������)   
    --�μ����� ����Ѵ�->   DEPARTMENTS ���̺� �ʿ� -> �������Ǳ��� �� ���� NULL�÷��� �������鼭 ��� 50��
