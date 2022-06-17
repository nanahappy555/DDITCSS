2022-0407-
1. DML ���
    1. ���̺� �������(CREATE TABLE)
    - ����Ŭ���� ���� ���̺��� ����
    (�������)
    CREATE TABLE ���̺��(
        �÷��� ������ Ÿ��[(ũ��)] [NOT NULL] [DEFAULT ��] [,]
                 :
        �÷��� ������ Ÿ��[(ũ��)] [NOT NULL] [DEFAULT ��] [,]
         [CONSTRAINT �⺻Ű�ε����� PRIMARY KEY(�÷���[,�÷���,...]) [,]]
         [CONSTRAINT �ܷ�Ű�ε����� FOREIGN KEY(�÷���[,�÷���,...])
            REFERENCES ���̺��(�÷���[,�÷���,...])[,]]
         [CONSTRAINT �ܷ�Ű�ε����� FOREIGN KEY(�÷���[,�÷���,...])
            REFERENCES ���̺��(�÷���[,�÷���,...])[,]];
        . '���̺��', �÷���, �ε����� : ��������Ǵܾ ���
        . 'NOT NULL'�� ����� �÷��� ������ ���Խ� ���� �Ұ���
        . 'DEFAULT ��' :����ڰ� �����͸� �Է����� ���� ��� �ڵ����� ���ԵǴ� ��
        . '�⺻Ű�ε�����','�ܷ�Ű�ε�����','���̺��'�� �ߺ��Ǿ�� �ȵ�
        . '���̺��(�÷���[,�÷���,...])[,]]': �θ����̺�� �� �θ����̺��� ���� �÷���
    
 ��뿹)���̺��1�� ���̺���� �����Ͻÿ�.
 
    CREATE TABLE GOODS(
        GOOD_ID CHAR(4) NOT NULL, --�⺻Ű, NOT NULL ��������
        GOOD_NAME VARCHAR2(50),
        PRICE NUMBER(8),
        CONSTRAINT pk_goods PRIMARY KEY(GOOD_ID));
        
    CREATE TABLE CUSTS(
        CUST_ID CHAR(4) NOT NULL,
        CUST_NAME VARCHAR2(50),
        ADDRESS VARCHAR2(100),
        CONSTRAINT PK_CUSTS PRIMARY KEY(CUST_ID));
        
    CREATE TABLE ORDERS(
        ORDER_ID CHAR(11),
        ORDER_DATE DATE DEFAULT SYSDATE, --����Ʈ���� �Է����� ������ �ڵ����� �ý��� ��¥ �Էµ�
        CUST_ID CHAR(4),
        ORDER_AMT NUMBER(10) DEFAULT 0, --����ڰ� �Է����� ������ 0���� ��
        CONSTRAINT PK_ORDER PRIMARY KEY(ORDER_ID), --�⺻Ű PK_ORDER(�̸�)�� �÷�ORDER_ID
        CONSTRAINT FK_ORDER_CUST FOREIGN KEY(CUST_ID) --�ܷ�Ű FK_ORDER_CUST(�̸�)�� �÷�CUST_ID
            REFERENCES CUSTS(CUST_ID)); --�θ����̺� CUSTS�� �÷�CUST_ID�� �����ؼ� �ڽ����̺� ORDERS�� �÷�CUST_ID�� ����
            
    CREATE TABLE GOOD_ORDERS(
        ORDER_ID CHAR(11),
        GOOD_ID CHAR(4),
        ORDER_QTY NUMBER(3),
        CONSTRAINT PK_GORD PRIMARY KEY(ORDER_ID,GOOD_ID),
        CONSTRAINT FK_GORD_ORDER FOREIGN KEY(ORDER_ID)
            REFERENCES ORDERS(ORDER_ID),
        CONSTRAINT FK_GORD_GOODS FOREIGN KEY(GOOD_ID)
            REFERENCES GOODS(GOOD_ID)); --FK_GORD_ORDER�� FK_GORD_GOOD�� �����ϴ� �θ����̺��� �޶� ���� ����
            
2. INSERT ���
    - ������ ���̺� ���ο� �ڷḦ �Է�
    (�������)
        INSERT INTO ���̺��[(�÷���[,�÷���,...])]
            VALUES(��1[,��2,...]);
        . '���̺��[(�÷���[,�÷���,...])]'; '�÷���'�� �����ǰ� ���̺�� ����Ǹ�
          ���̺��� ��� �÷��� �Էµ� �����͸� ������ ���߾� ����ؾ���(���� �� ���� ��ġ)
        . '(�÷���[,�÷���,...])':�Է��� �����Ϳ� �ش��ϴ� �÷��� ���, 
          ��, NOT NULL �÷��� ���� �� �� ���� --NULLABLE : YES(=NOT NULL)
          
��뿹)���� �ڷḦ GOODS���̺� �����Ͻÿ�
     ��ǰ�ڵ�    ��ǰ��     ����
-------------------------------------
        P101     ����     500
        P102    ���콺  15000
        P103    ����      300
        P104   ���찳    1000
        P201   A4����   7000
        
    INSERT INTO GOODS VALUES('p101','����',500); --�� ����
    INSERT INTO GOODS(good_id,GOOD_NAME,PRICE)
        VALUES('p102','���콺',15000);
    INSERT INTO GOODS(good_id,GOOD_NAME,PRICE)
        VALUES('p103','����',300);
        

        
    SELECT * FROM GOODS; --���� ����� ���Եƴ��� Ȯ��
    
��뿹)�����̺�(CUSTS)�� �����ڷḦ �Է��Ͻÿ�
    ����ȣ    ���� �ּ�
-----------------------------------
    a001     ȫ�浿    ������ �߱� ���� 846
    a002     ���μ�    ����� ���ϱ� ����1�� 66
    
    INSERT INTO CUSTS VALUES('a001','ȫ�浿','������ �߱� ���� 846');
    INSERT INTO CUSTS(CUST_ID, ADDRESS)
        VALUES('a001','����� ���ϱ� ����1�� 66');
    INSERT INTO CUSTS(CUST_ID, ADDRESS)
        VALUES('a001','ȫ�浿','����� ���ϱ� ����1�� 66'); --�÷��� �������� ���� ������ �� ����
    INSERT INTO CUSTS(CUST_ID, ADDRESS)
        VALUES('a001', '����� ���ϱ� ����1�� 66'); --�⺻Ű�� �ߺ�����
    
    SELECT * FROM CUSTS;
    
��뿹)���� ȫ�浿 ���� �α��� ���� ��� �ֹ����̺� �ش� ������ �Է��Ͻÿ� --ORDER_ID 11�ڸ�, CUST_ID 4�ڸ�
     INSERT INTO ORDERS(ORDER_ID,CUST_ID)     
        VALUES('20220407001','a001');
        
    SELECT * FROM ORDERS;    
    
��뿹)���� ȫ�浿 ���� ������ ���� �������� �� ���Ż�ǰ���̺�(GOOD_ORDER)�� �ڷḦ �����Ͻÿ�.
        ���Ź�ȣ       ��ǰ��ȣ     ����
    -----------------------------------
        20220407001     p101    5
        20220407001     p102    10
        20220407001     p103    2
        
    INSERT INTO GOOD_ORDERS
        VALUES('20220407001','p101',5);
    INSERT INTO GOOD_ORDERS    
        VALUES('20220407001','P102',10);
    INSERT INTO GOOD_ORDERS
        VALUES('20220407001','P103',2);   
        
    UPDATE GOODS
       SET PRICE=15000
    WHERE GOOD_ID='P102';
        
    UPDATE ORDERS
        SET ORDER_AMT=ORDER_AMT+(SELECT ORDER_QTY*PRICE  --�����ݾװ� �հ谡 �Ǿ����
                                 FROM GOOD_ORDERS A, GOODS B
                                 WHERE A.GOOD_ID=B.GOOD_ID
                                 AND ORDER_ID='20220407001')
                                 AND A.GOOD_ID='p103')
        WHERE ORDER_ID='20220407001';     
        
        SELECT * FROM ORDERS;
        SELECT * FROM GOOD_ORDERS; --��� ��(*)�� ��� ��(WHERE����)�� ����϶�
        UPDATE ORDERS
            SET ORDER_AMT=0;
        
3. UPDATE ��� 
    - �̹� ���̺� �����ϴ� �ڷḦ ������ �� ��� --�̹� �����ϴ� �ڷ� ����
    (�������)
    UPDATE ���̺��
       SET �÷���=��[,]
           �÷���=��[,]     
              :
           �÷���=��[,]
    [WHERE ����];       --�� ���̺��� �࿡ ����. WHERE�� �Ⱦ��� ��� ���� �����ع���
    
 --1. Ȯ���� ���� �ʿ��� �����͸� ����ϱ�    
    SELECT PROD_NAME AS ��ǰ��, --PROD_NAME�� ��ǰ���̶�� �Ұ��̴�
           PROD_COST AS ���Դܰ� -- ~ ���Դܰ���� �Ұ��̴�
    FROM PROD;  --(���������)PROD���̺� ��ǰ��� ���Դܰ��� �̸� ���� ��� ���� ����ϼ���
    
 --2. UPDATE�� �̿��ؼ� �ڷ� ����    
��뿹) ��ǰ���̺��� �з��ڵ尡 'P101'�� ���� ��ǰ�� ���԰����� 10%�λ��Ͻÿ�.
    UPDATE PROD
       SET PROD_COST=PROD_COST+ROUND(PROD_COST*0.1)
       WHERE PROD_LGU='P101';  --LGU�з��ڵ�  -> �з��ڵ尡 p101�� 6�� �ุ ������Ʈ 

    ROLLBACK; --