2022-0513-01)������ ���̺�(tbl_good, customer)�� �ڷ� ����

|��ǰ����|
|---|---|---|
|��ǰ��ȣ|�̸�|����|
|p101|�����|1200|
|p102|�Ŷ��|1500|
|p103|�κ�|2500|
|p104|��ġ(200g)|1750|

INSERT INTO TBL_GOOD VALUES('p101','�����',1200);
INSERT INTO TBL_GOOD VALUES('p102','�Ŷ��',1500);
INSERT INTO TBL_GOOD VALUES('p103','�κ�',2500);
INSERT INTO TBL_GOOD VALUES('p104','��ġ(200g)',1750);
SELECT * FROM TBL_GOOD;
COMMIT;

|������|
|---|---|---|
|����ȣ|�̸�|�ּ�|
|2201|������|����� ���ϱ� ������ 100|
|2210|������|������ ����� ������ 1555|
|2205|�յ���|û�ֽ� û���� ���� 102|
INSERT INTO CUSTOMER VALUES('2201','������','����� ���ϱ� ������ 100');
INSERT INTO CUSTOMER VALUES('2210','������','������ ����� ������ 1555');
INSERT INTO CUSTOMER VALUES('2205','�յ���','û�ֽ� û���� ���� 102');
SELECT * FROM CUSTOMER;
COMMIT;

��뿹)ȸ���� ��ǰ�� ������ ��� ���Ż�ǰ(ORDER_GOOD)���̺� ���������� ��ϵǾ�� �Ѵ�.
�̶� �������̺��� ����(AMOUNT)�� �ڵ����� ���ŵ� �� �ִ� Ʈ���Ÿ� �ۼ��Ͻÿ�.
--ORDER����*�ܰ�
--����ڰ� �α����ϸ� �ֹ����̺��� ������ �ڵ����� ���ߵ�
--�׷� �ʿ��� ����? �ֹ���ȣ. ���� Ÿ������ �� ����.
--�ֹ���ȣ �����Լ��� ����� ��. ���ν����� ��ȯ���� ���� �������� ����
--�ֹ���ȣ ���� -> ���Ż�ǰ�� ������ ���Ź�ȣ�� ����;���

���ν����� �Լ��� ���ó ����
+ SELECT, WHERE������ ��ߵ� ���� �Լ��� (�Լ��� ��ȯ�����Ͱ� ����. ��ȯ�����͸� �����)
+ ���ν����� ���������� ����. EXEC
OUT�Ű������� ����ϸ� ������ �����ؼ� ��ߵ�=>�ٸ� ��Ͽ��� ������ ������ְ� 

1)�ֹ���ȣ �����Լ� --�Ϻ����� ������ ���߿� ��������
CREATE OR REPLACE FUNCTION FN_CREATE_ORDER_NUMBER
--�Ű������� �ʿ��� �Ű����� ����
    --��ȯ�Ǵ� ������ Ÿ��
    RETURN NUMBER
IS  --��������
    V_ONUM TBL_ORDER.ORDERNUM%TYPE; --������ �ֹ���ȣ
    V_FLAG NUMBER:=0; --���ó�¥�� �α����� ȸ���� ���� �� �÷��� ���� 
BEGIN
    --1.���� ��¥�� �ֹ��� �� ȸ���� �ִ��� Ȯ��
    SELECT COUNT(*) --�ֹ��� �� ȸ�� �����
      FROM TBL_ORDER
     WHERE TRUNC(ODATE)=TRUNC(SYSDATE); --ODATE(�ú��ʱ��� �������)�� SYSDATE�� �ð��� �ȸ¾Ƽ� �ð��� ������
         --TO_CHAR(ODATE,'YYYYMMDD')=TO_CHAR(SYSDATE,'YYYYMMDD'); --��¥�� ���ó�¥�� ���� ��¥�� ����
    --2. ��� �� IF�� ���� ��� ��� 
    IF V_FLAG=0 THEN --���Ӱ�0��- ���� ��¥�� YYYYMMDD�������� �ٲپ 001�� ���� (īƮ��ȣ)
        V_ONUM :=TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDD')||TRIM('001'));
    ELSE --���Ӱ� ������ -  ���� ��¥ �ڷ��߿�(WHERE) ���� ū �ֹ���ȣ�� 1�� ���ؼ� V_ONUM�� ������
        SELECT MAX(ORDERNUM)+1 INTO V_ONUM
          FROM TBL_ORDER
         WHERE ODATE=SYSDATE;
    END IF;
    --���� ��ȯ�ϴ� ������
    RETURN V_ONUM;
END;
/

1-2) �����͸� �־�� --INSERT UPDATE DELETE�� �� COMMIT ����� �������̼� �� �� ������ �Ȼ���.
INSERT INTO TBL_ORDER VALUES (20220513003,SYSDATE,20000,'2210'); 
COMMIT;

SELECT FN_CREATE_ORDER_NUMBER FROM DUAL;
--------------------------------------
**�ǻ緹�ڵ�**

ORDER_GOOD�� �ڷ� 2���� ����
:NEW --���Ե� �ڷḦ ����Ű�� �ǻ緹�ڵ�
ex) :NEW.GOOD_ID --���Ե� �ڷ��� ��ǰ��ȣ
ù��° �� �а� �ڵ����� �ι�° �ٷ�  �Ѿ
:NEW�� INSERT�� UPDATE�� �߻����� ���� ��ȿ

EMPLOYEE���� ���ó���� ����� ������ ��
:OLD --������ �ڷḦ ����Ű�� �ǻ緹�ڵ�
ex) :OLD.EMPLOYEE_ID --���ó���� ����� ���̵�
:OLD�� DELETE�� UPDATE�� �߻����� ���� ��ȿ (������ �ڷḦ ����Ű�ų�, ������ �ڷḦ ����ų ��)


--------------------------------------
2)Ʈ���� ����
���Ż�ǰ ���̺� INSERT�� �߻��ϸ� AFTER ���� ���̺� �ݾ� UPDATE
CREATE OR REPLACE TRIGGER TG_UPDATE_ORDER
    AFTER INSERT ON ORDER_GOOD --Ÿ�̹�
    FOR EACH ROW
DECLARE
    V_GID tbl_good.good_id%TYPE; --��ǰ�ڵ�
    V_AMT NUMBER:=0; --�ܰ� * ���� ���ؼ� ��� ������ ����
    V_PRICE NUMBER:=0; --�ش��ǰ�� �ܰ�
BEGIN --Ʈ���� ����(ORDER_GOOD�� INSERT�� �� AMOUNT�� ������Ʈ �ϱ�)
    V_GID:=(:NEW.GOOD_ID); --���Ӱ� �ԷµǴ� ���� ���� V_GID�� ����
    
    SELECT GOOD_PRICE INTO V_PRICE --��ǰ���̺��� �ǸŰ��� ã�Ƽ� V_PRICE�� ����
      FROM TBL_GOOD
     WHERE GOOD_ID=V_GID;
     
    V_AMT:=V_PRICE*(:NEW.ORDER_QTY); --V_PRICE�� ���� ���Ե� ���Ź����� ������ ���ؼ� ���űݾ׻���
    
    UPDATE TBL_ORDER
       SET AMOUNT=AMOUNT+V_AMT --������ǰ�� �����ϱ� ������ ����AMOUNT�� ���ϻ�ǰ�� �ݾ��� �߰��ؾߵ�
     WHERE ORDERNUM=(:NEW.ORDERNUM);--���Ź�ȣ�� ������ AMOUNT ������Ʈ
     --Ʈ���� Ŀ��/�ѹ� X
END;

3)�׽�Ʈ --�Ʊ� ������ �Լ��� ���
'�յ���'����
INSERT INTO TBL_ORDER
VALUES (FN_CREATE_ORDER_NUMBER,SYSDATE,0,'2205'); --FN_CREATE_ORDER_NUMBER : ����� �� �Լ� ȣ��
COMMIT;

4)�Ŷ�� 5��, ��ġ 2�� ����
INSERT INTO ORDER_GOOD
���ν����� ����� ����?
Ʈ���Ŵ� ����Ŭ�� �߻��ϰ�,
���ν��� �ƴϸ� �ٸ� ���̺� �ִ� �����͸� �� ���̺��� �� ����� ���λ���
�������� ���� ���� ������ ����� ��� ���ν�����.
/
--�����ѹ��� ã������ CID�� �˾ƾ� �� (CID�� �ش��ϴ� �����ѹ��� ã�� ����)
CREATE OR REPLACE PROCEDURE PROC_INSERT_ORDER
(P_CID IN CUSTOMER.CID%TYPE, P_GID IN tbl_good.good_id%TYPE, P_SU IN NUMBER)
IS
    V_ORDER_NUM tbl_order.ordernum%TYPE;
BEGIN --����ȣ�� ��¥�� ������ �� ������ �ο��� �ֹ���ȣ�� ã�ƶ�
    SELECT T.ORDERNUM INTO V_ORDER_NUM
      FROM TBL_ORDER
     WHERE TRUNC(ODATE)=TRUNC(SYSDATE) 
       AND CID=P_CID;
       
    INSERT INTO ORDER_GOOD
        VALUES (P_GID,V_ORDER_NUM,P_SU);
    COMMIT;    
END;
/
EXEC PROC_INSERT_ORDER('2205','p102',5); --��� ��
EXEC PROC_INSERT_ORDER('2205','p104',2);
/
Q. BEGIN���� �ֹ���ȣ�� ã�µ�
���� ������ ���������� �ֹ���ȣ�� �������� �������� �Ǵϱ� ������ ��
���� ������ �ֹ���ȣ(�����ؼ� ROWNUM 1)�� ���� �� ->BEGIN�� ��������

/1.���������ۼ�/
SELECT T.ORDERNUM INTO V_ORDER_NUM
  FROM (SELECT ORDERNUM,
               CID
          FROM TLB_ORDER
         WHERE TRUNC(ODATE)=TRUNC(SYSDATE)
           AND CID='2210'
         ORDER BY 1 DESC ) T
 WHERE ROWNUM=1;
/2.����/
CREATE OR REPLACE PROCEDURE PROC_INSERT_ORDER
(P_CID IN CUSTOMER.CID%TYPE, P_GID IN tbl_good.good_id%TYPE, P_SU IN NUMBER)
IS
    V_ORDER_NUM tbl_order.ordernum%TYPE;
BEGIN
    SELECT T.ORDERNUM INTO V_ORDER_NUM
      FROM (SELECT ORDERNUM,
                   CID
              FROM TLB_ORDER
             WHERE TRUNC(ODATE)=TRUNC(SYSDATE)
               AND CID='2210'
             ORDER BY 1 DESC ) T
     WHERE ROWNUM=1
       AND TRUNC(ODATE)=TRUNC(SYSDATE) 
       AND CID=P_CID;
       
    INSERT INTO ORDER_GOOD
        VALUES (P_GID,V_ORDER_NUM,P_SU);
    COMMIT;    
END;
/