2022-04-28-01)SUBQUERY�� DML���
1. INSERT ������ �������� ���
  - INSERT INTO ���� ���������� ����ϸ� VALUES���� ������
  - ���Ǵ� ���������� '( )'�� �����ϰ� �����
(�������)
    INSERT INTO ���̺��[(�÷���[,�÷���,...])] --�÷����� �����ϸ� ��� �÷��� ���� �����ؾߵ�.
        ��������;
        . '���̺��( )'�� ����� �÷��� ����,����,Ÿ�԰�
          �������� SELECT���� SELECT���� �÷��� ����,����,Ÿ���� �ݵ�� ��ġ�ؾ� ��
        
��뿹) ���������̺��� �⵵���� '2020'�� ��ǰ�ڵ忡�� ��ǰ���̺��� ��� ��ǰ�ڵ带 �Է��Ͻÿ�.
    INSERT INTO REMAIN(REMAIN_YEAR,PROD_ID)
        SELECT '2020', PROD_ID
          FROM PROD;
          
    SELECT *  FROM REMAIN;    --REMAIN_DATE�� (null)�� ������ ������
    
    DELETE FROM REMAIN;  --REMAIN_DATE�� ���� ��¥�� �־������ �ѹ� �� ������ �Ф�. . . . .

--�԰��� �߰��Ǹ� UPDATE    
2. UPDATE ������ �������� ���
(�������)
    UPDATE ���̺�� [��Ī]
       SET (�÷���[,�÷���,...])=(��������)
    [WHERE ����];   --�����ų ���̺��� �����ų ��. �����ϸ� �����ų ���̺��� ��� ����

    ����)   **������������**
    UPDATE MEMBER
       SET MEM_NAME='ȫ�浿', --������ ���� �������� �÷��� ������ �����
           MEM_BIR=TO_DATE('20011230') 
           
    --������ ���� �������� �÷��� ������ �����
    --�׷� ���������� ������ ����ϳ�..?
    --
    
��뿹)���������̺�(REAMAIN)�� ������� �����Ͻÿ�.    
      �������� ��ǰ���̺��� ����������� �ϸ� ��¥�� 2020��1��1�Ϸ� ����
      --3�� ���ÿ� ����� �������,�⸻���,��¥
      --������� �ϸ� ���������� ���� ��ߵ�
    UPDATE REMAIN A
       SET (A.REMAIN_J_00,A.REMAIN_J_99,A.REMAIN_DATE)=
           (SELECT A.REMAIN_J_00+B.PROD_PROPERSTOCK,
                   A.REMAIN_J_99+B.PROD_PROPERSTOCK,
                   TO_DATE('20200101')
              FROM PROD B
             WHERE A.PROD_ID=B.PROD_ID) --�������� WHERE���� �����ų ���� ����
     WHERE A.REMAIN_YEAR='2020'; --������Ʈ���� �ɸ��� WHERE���� ������ �����͸� ������ ��
     
**������� �ڷ��̿��۾�**     
�ڷ� �̿� �۾��� �ʿ��� ����?
���� ���� �����ų� ���޴� �̼����� ���� �� ����.
������ �ְ� ǰ���� ���� ������ ������ǰ�� ���� �� ����
�ذ� �Ѿ�� �� �ڷḦ �״�� �޾ƿ;���.

��뿹) 2020�� 1�� ��ǰ�� ���Լ����� ��ȸ�Ͽ� ���������̺��� �����Ͻÿ�
    (��������)
     UPDATE REMAIN A
        SET (A.REMAIN_I, A.REMAIN_J_99, A.REMAIN_DATE)=  --�������Ѿ� �Ѵ� ==�߰� UPDATE&SET �Ѽ�Ʈ
            (��������1)
      WHERE A.REMAIN_YEAR='2020'
        AND A.PROD_ID IN(��������2);--�ε����� �Ű����Ѵ�/ �⺻Ű�� �ڵ����� �ε����� ���������/ WHERE������ ��� �⺻Ű�� ����� �ݵ�� �־�� �Ѵ�
        
    (��������1:2020�� 1�� ��ǰ�� ���Լ���)
     SELECT BUY_PROD,
            SUM(BUY_QTY)      
       FROM BUYPROD
      WHERE BUY_DATE BETWEEN TO_DATE ('20200101') AND TO_DATE('20200131')
      GROUP BY BUY_PROD;
      
    (��������2:2020�� 1�� ���Ի�ǰ��ȸ)
    
    (����) ��������+��������1
     UPDATE REMAIN A
        SET (A.REMAIN_I, A.REMAIN_J_99, A.REMAIN_DATE)=  --UPDATE�Ǿ��� �÷���
            (SELECT A.REMAIN_I+B.BSUM,A.REMAIN_J_99+B.BSUM,TO_DATE('20200201') --1���޿� �ִ°� + 2���� ���� �԰�� �� �����ؾ��ؼ� + /���� 1��-2�����/ '20200201' 2��1�Ͽ� 1���� ��� �����ߴٰ� �����ϰ� 2/1�� ������
               FROM (SELECT BUY_PROD AS BID, --���������� �ٷξ��� ���Լ����� �����°� �ƴ϶� �ڵ���� ���̳����⶧���� ���������� �ѹ� �� ����(�հ踸 �ʿ��ϴϱ� FROM���� ����ؼ� �Ǹ��� ���� �� ������� �� �̿�)
                            SUM(BUY_QTY) AS BSUM     
                       FROM BUYPROD
                      WHERE BUY_DATE BETWEEN TO_DATE ('20200101') AND TO_DATE('20200131')
                      GROUP BY BUY_PROD) B
              WHERE A.PROD_ID=B.BID)     
      WHERE A.REMAIN_YEAR='2020' --�ٱ��� WHERE���� ���� ��� ���ϸ� ������� ����ȴ�
        AND A.PROD_ID IN(��������2);
        
    (��������2:2020�� 1�� ���Ի�ǰ ��ȸ) --39�� ��ǰ�ڵ常
     SELECT DISTINCT BUY_PROD --DISTINCT �ߺ���ǰ�ȳ�����. ����ȷȳ� ������� '����'�� �˱�����
       FROM BUYPROD
      WHERE BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200131');


(����
     UPDATE REMAIN A
        SET (A.REMAIN_I, A.REMAIN_J_99, A.REMAIN_DATE)=  --UPDATE�Ǿ��� �÷���
            (SELECT A.REMAIN_I+B.BSUM,A.REMAIN_J_99+B.BSUM,TO_DATE('20200201') --1���޿� �ִ°� + 2���� ���� �԰�� �� �����ؾ��ؼ� + /���� 1��-2�����/ '20200201' 2��1�Ͽ� 1���� ��� �����ߴٰ� �����ϰ� 2/1�� ������
               FROM (SELECT BUY_PROD AS BID, --���������� �ٷξ��� ���Լ����� �����°� �ƴ϶� �ڵ���� ���̳����⶧���� ���������� �ѹ� �� ����(�հ踸 �ʿ��ϴϱ� FROM���� ����ؼ� �Ǹ��� ���� �� ������� �� �̿�)
                            SUM(BUY_QTY) AS BSUM     
                       FROM BUYPROD
                      WHERE BUY_DATE BETWEEN TO_DATE ('20200101') AND TO_DATE('20200131')
                      GROUP BY BUY_PROD) B
              WHERE A.PROD_ID=B.BID)     
      WHERE A.REMAIN_YEAR='2020' --�ٱ��� WHERE���� ���� ��� ���ϸ� ������� ����ȴ�
        AND A.PROD_ID IN(SELECT DISTINCT BUY_PROD
                           FROM BUYPROD
                          WHERE BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200131'));
    SELECT * FROM REMAIN;
    

��뿹) 2020�� 2������ 4������ ��ǰ�� ���Լ����� ��ȸ�Ͽ� ���������̺��� �����Ͻÿ�   
     UPDATE REMAIN A
        SET (A.REMAIN_I, A.REMAIN_J_99, A.REMAIN_DATE)=  --UPDATE�Ǿ��� �÷���
            (SELECT A.REMAIN_I+B.BSUM,A.REMAIN_J_99+B.BSUM,TO_DATE('20200430') --4�� 30�Ͽ� ��� �����ߴٰ� ����
               FROM (SELECT BUY_PROD AS BID, --���������� �ٷξ��� ���Լ����� �����°� �ƴ϶� �ڵ���� ���̳����⶧���� ���������� �ѹ� �� ����(�հ踸 �ʿ��ϴϱ� FROM���� ����ؼ� �Ǹ��� ���� �� ������� �� �̿�)
                            SUM(BUY_QTY) AS BSUM     
                       FROM BUYPROD
                      WHERE BUY_DATE BETWEEN TO_DATE ('20200201') AND TO_DATE('20200430')
                      GROUP BY BUY_PROD) B
              WHERE A.PROD_ID=B.BID)     
      WHERE A.REMAIN_YEAR='2020' --�ٱ��� WHERE���� ���� ��� ���ϸ� ������� ����ȴ�
        AND A.PROD_ID IN(SELECT DISTINCT BUY_PROD
                           FROM BUYPROD
                          WHERE BUY_DATE BETWEEN TO_DATE('20200201') AND TO_DATE('20200430'));
    SELECT * FROM REMAIN;
    COMMIT;
    
--�ٵ� ����ľ��� ������ �ȸ������� ��� �پ�����ؼ� �ð����� ������� �Ǿ����. �츮�� �Ѵ޴����� �ϰ� ���� ����
--�ǸŰ� �߻��Ǿ� ��� ����Ǵ� ���� ����Ǿ���� =>Ʈ���Ÿ� ���� �Ȱ��� UPDATE���� ������ �ڷḦ �ڵ����� �޾ƿ�
��뿹)2020�� 4�� ��ٱ������̺��� �Ǹż����� ��ȸ�Ͽ� ���������̺��� �����Ͻÿ�.  --���� �߿��� �� **����**
     (��������)
     (��������1:2020�� 4�� ��ǰ�� �������)
     SELECT CART_PROD AS BID,
                            SUM(CART_QTY) AS BSUM     
                       FROM CART
                      WHERE SUBSTR(CART_NO,1,8) LIKE '20200401'
                      GROUP BY CART_PROD;
                      
    (����)                  
     UPDATE REMAIN A
        SET (A.REMAIN_O, A.REMAIN_J_99, A.REMAIN_DATE)=  --UPDATE�Ǿ��� �÷���
            (SELECT A.REMAIN_O+B.BSUM,A.REMAIN_J_99-B.BSUM,TO_DATE('20200430') --���ⷮ�� �������+���ο����, �⸻���� ���-�������
               FROM (SELECT CART_PROD AS BID,
                            SUM(CART_QTY) AS BSUM     
                       FROM CART
                      WHERE SUBSTR(CART_NO,1,8) LIKE'202004%'
                      GROUP BY CART_PROD) B
              WHERE A.PROD_ID=B.BID)     
      WHERE A.REMAIN_YEAR='2020'
        AND A.PROD_ID IN(SELECT DISTINCT CART_PROD
                           FROM CART
                          WHERE SUBSTR(CART_NO,1,8) LIKE'202004%');
    SELECT * FROM REMAIN;
    COMMIT;     
    
    ���踦 ���� �Ǹŷ� -> 
    ��� ����
    
Ʈ���� �ڵ��������
**������� ���� Ʈ����
  - �԰�߻��� �ڵ����� �������

CREATE OR REPLACE TRIGGER TG_INPUT
    AFTER INSERT ON BUYPROD --�μ�Ʈ �� ���Ŀ� �˾Ƽ� �����
    FOR EACH ROW
DECLARE
    V_QTY NUMBER:=0;
    V_PROD PROD.PROD_ID%TYPE;
    V_DATE DATE:=(:NEW.BUY_DATE);
BEGIN
    V_QTY:=(:NEW.BUY_QTY);
    V_PROD:=(:NEW.BUY_PROD); --BUY_PROD�� ������ ���ο��ڷ�NEW
    
    UPDATE REMAIN A
       SET A.REMAIN_I=A.REMAIN_I+V_QTY,
           A.REMAIN_J_99=A.REMAIN_J_99+V_QTY,
           A.REMAIN_DATE=V_DATE
     WHERE A.PROD_ID=V_PROD;
     EXCEPTION WHEN OTHERS THEN --�߻��� ��� ������ �ɷ����ִ� ��¸��
       DBMS_OUTPUT.PUT_LINE('���ܹ߻� : '||SQLERRM);  --SQLERRM : SQL�����޼���
END;

**��ǰ�ڵ� 'P101000001' ��ǰ 50���� ���ó�¥�� �����Ѵ�
  (���Դܰ��� 210000��)
  ����Ȳ          �� �� �� ��
  2020  P10100001 33 38 5 66 2020/0430
  
  INSERT INTO BUYPROD
    VALUES(SYSDATE,'P101000001',50,210000);
    
  SELECT * FROM BUYPROD    
  
**���������� �̿��� ���̺����
  - CREATE TABLE ��ɰ� ���������� ����Ͽ� ���̺��� �����ϰ� �ش�Ǵ� ���� ������ �� ����. --�׽�Ʈ�� ������ �����͸� ������ �ӽ����̺� ����
  - ��������� ����(����)���� ����
  (�������)
  CREATE TABLE ���̺��[(�÷���[,�÷���,...])]  --�÷��� �����ϸ� �Է��� ���̺�� ���� �÷��� ���� ���
    AS (��������);      --���������� ����� ���� �� �÷����� ����� �޾Ƽ� ���̺��� ������
  (��뿹) ���������̺��� ��� �����͸� �����Ͽ� ���ο����̺��� �����Ͻÿ�.
          ���̺���� TEMP_REMAIN�̴�.
  CREATE TABLE TEMP_REMAIN
    AS (SELECT * FROM REMAIN); --�⺻Ű,�ܷ�Ű�� ���簡 �� ��. ������� ���� �����ؿ�
    
  SELECT * FROM TEMP_REMAIN;
  
3. DELETE������ �������� ���
  ** DELETE���� �������
    DELETE FROM ���̺�� //�� ������ ó��/
    [WHERE]����;
    
(��뿹)TEMP_REMAIN���̺��� 2020�� 7���� �Ǹŵ� ��ǰ�� ���� �ڵ��� �ڷḦ �����Ͻÿ�
    (��������: 2020�� 7���� �Ǹŵ� ��ǰ)
     SELECT DISTINCT CART_PROD --��ǰ�ڵ尡 �ߺ����� �ʰ� ��ȸ
       FROM CART
      WHERE CART_NO LIKE '202007%'
      
    DELETE FROM TEMP_REMAIN A
     WHERE REMAIN_YEAR='2020'
       AND A.PROD_ID IN(SELECT DISTINCT CART_PROD  ---- =�� ������ ���������� ���Ǿ����� ���迬�����̴�, ���������� ����� 20���� =��� IN ���
                          FROM CART
                         WHERE CART_NO LIKE '202007%');
                         
                         
                         
                         
                         
                         
                         
                         SELECT A.CART_PROD AS ��ǰ�ڵ�,
             B.PROD_NAME AS ��ǰ��,
             SUM(A.CART_QTY) AS �Ǹż����հ�,
             SUM(A.CART_QTY*B.PROD_PRICE) AS �Ǹűݾ��հ� --����*�ܰ�
        FROM CART A,PROD B                 --CART ���̺� ��Ī A. ���̺��� AS�ʿ���� (������)
       WHERE A.CART_PROD=B.PROD_ID   --JOIN����
        AND /*1��*/ SUBSTR(A.CART_NO,1,8)>='20200601' AND
             SUBSTR(A.CART_NO,1,8)>='20200630' 
             /*--2�� SUBSTR*SUBSTR(A.CART_NO,1,6)='203006'
             /*3�� A.CART_NO LIKE'202006%' */ -- GROUP BY �ڿ� ����� �÷� �������� ���踦 ���µ� ���
      GROUP BY A.CART_PROD,B.PROD_NAME 
      ORDER BY 4 DESC; 