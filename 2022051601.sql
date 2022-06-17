2022-0516-01)
** Ʈ���� �ǻ緹�ڵ�
+ :NEW : INSERT�� UPDATE�� ���. �����Ͱ� ����(����)�� �� ���� �ԷµǴ� ���� ��Ī. DELETE�� ��� NULL��
+ :OLD : DELETE�� UPDATE�� ���. �����Ͱ� ����(����)�� �� �̹� ����Ǿ� �ִ� ���� ��Ī. INSERT�� ��� NULL��

** Ʈ���� �Լ�
+ INSERTING : �̺�Ʈ�� INSERT �̸� true
+ UPDATING : �̺�Ʈ�� UPDATE �̸� true
+ DELETING : �̺�Ʈ�� DELETE �̸� true

SET SERVEROUTPUT ON;

INSERTING ��ٱ��� ��� / UPDATING ��ٱ��� ���� ����/ DELETING ��ǰ ���� => �������� UPDATE
��뿹)��ٱ������̺� ���ó�¥�� �ڷᰡ �Է�(����/����/����)�Ǿ��� �� ���������̺��� ���, ����� ���� �÷��� �����Ͻÿ�.

1. Ʈ���� �ۼ�
CREATE OR REPLACE TRIGGER TG_CART_CHANGE
    AFTER  INSERT OR UPDATE OR DELETE  ON CART
    FOR EACH ROW --�����Ǹ� ������� Ʈ���Ű� �Ǳ� ������ :NEW,:OLD�� �� �� ����
DECLARE --�ʿ��� ����,���,Ŀ�� ����
    V_QTY NUMBER:=0;
    V_PID PROD.PROD_ID%TYPE;
    V_DATE DATE;
BEGIN
    IF INSERTING THEN
       V_PID:=(:NEW.CART_PROD);
       V_QTY:=(:NEW.CART_QTY);
       V_DATE:=TO_DATE(SUBSTR((:NEW.CART_NO),1,8));
    ELSIF UPDATING THEN
       V_PID:=(:NEW.CART_PROD);
       V_QTY:=(:NEW.CART_QTY)-(:OLD.CART_QTY); --�̹� �߰��Ǿ� �ִ� ���� ������ ����Ǳ� ������ // :NEW������3-:OLDó����5=�������-2�� ����
       V_DATE:=TO_DATE(SUBSTR((:NEW.CART_NO),1,8));
    ELSIF DELETING THEN
       V_PID:=(:OLD.CART_PROD);
       V_QTY:=-(:OLD.CART_QTY); 
       V_DATE:=TO_DATE(SUBSTR((:OLD.CART_NO),1,8));
    END IF;
    
    UPDATE REMAIN A
       SET a.remain_o = a.remain_o+V_QTY,
           a.remain_j_99 = a.remain_j_99-V_QTY, --���� ���̳ʽ�
           a.remain_date = V_DATE
     WHERE a.remain_year='2020'
       AND A.PROD_ID = V_PID;
END;

2. 'f001'ȸ���� 'P201000018'�� 10�� ����
INSERT INTO CART
    VALUES('f001','2022051600001','P201000018',10);

3. 'f001'ȸ���� 'P201000018'�� ��ǰ ���ż����� 3���� ����
UPDATE CART
   SET CART_QTY=3
 WHERE CART_NO='2022051600001',
   AND CART_PROD='P201000018';

4. 'f001'ȸ���� 'P201000018'�� ��ǰ�� ��� ��ǰ�� ���      
DELETE FROM CART
 WHERE CART_NO='2022051600001'
   AND CART_PROD='P201000018'; 