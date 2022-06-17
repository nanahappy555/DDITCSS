2022-0506-01)CURSOR��
--2005�⵵ �� ��ǰ�� �� �԰������ ����ϴ� Ŀ��
SET SERVEROUTPUT ON;
--�ܼ�â�� DBMS����� ����ϱ� ���� �ڵ�

DECLARE
    --SCALAR�Ϲݺ���
    V_BUY_PROD VARCHAR2(10);
    V_QTY NUMBER(10);
    --2020�⵵ ��ǰ�� ���Լ����� ��
    CURSOR CUR IS --������ �信 �̸����̱�
    SELECT BUY_PROD, SUM(BUY_QTY)
      FROM BUYPROD
     WHERE BUY_DATE LIKE '2020%' --% WILDCARD
     GROUP BY BUY_PROD
     ORDER BY BUY_PROD;
BEGIN
    --�޸� �Ҵ�(�ö�) = ���ε�
    OPEN CUR;
    --����� ��ġ:�̵��ϰ� ��:Ŀ���� �ִ��� ������ ������ ��:����Ѵ�
    --���� ������ �̵�, ���� �����ϴ��� üũ
    --��
    FETCH CUR INTO V_BUY_PROD, V_QTY; --�ѹ��������� �̵�
    --��(FOUND:����������? / NOTFOUND:�����;�����? / ROWCOUNT : ���� ��)
    WHILE(CUR%FOUND) LOOP
        DBMS_OUTPUT.PUT_LINE(V_BUY_PROD ||', ' || V_QTY);--��
        FETCH CUR INTO V_BUY_PROD, V_QTY;--�� ('��'�ε��ư�
    END LOOP;    
    --������θ޸𸮹�ȯ(�ʼ�)
    CLOSE CUR;
END; 
    
--ȸ�����̺��� ȸ����� ���ϸ����� ����غ���
--��, ������ '�ֺ�'�� ȸ���� ����ϰ� ȸ�������� �������� �����غ���
--ALIAS: MEM_NAME, MEM_MILEAGE

    SELECT MEM_NAME, MEM_MILEAGE
      FROM MEMBER
     WHERE MEM_JOB='�ֺ�'
     ORDER BY MEM_NAME;
     
--CUR�̸��� CURSOR�� �����ϰ� �͸������� ǥ���غ���
/
DECLARE     
    V_NAME MEMBER.MEM_NAME%TYPE; --REFERENCE����
    V_MILE NUMBER(10); --SCALAR����
    CURSOR CUR IS
        SELECT MEM_NAME, MEM_MILEAGE
          FROM MEMBER
         WHERE MEM_JOB='�ֺ�'
         ORDER BY MEM_NAME;     
BEGIN
    OPEN CUR;
    LOOP
        FETCH CUR INTO V_NAME, V_MILE; --��
        EXIT WHEN CUR%NOTFOUND; --�� ( CUR�����Ͱ� �������� ����)
        DBMS_OUTPUT.PUT_LINE(CUR%ROWCOUNT || ', ' || V_NAME || ', ' || V_MILE); --��
    END LOOP;
    CLOSE CUR;

END;
/


/
DECLARE     
    V_NAME MEMBER.MEM_NAME%TYPE; --REFERENCE����
    V_MILE NUMBER(10); --SCALAR����
    CURSOR CUR(V_JOB VARCHAR2) IS --�Ű������� ����
        SELECT MEM_NAME, MEM_MILEAGE
          FROM MEMBER
         WHERE MEM_JOB = V_JOB
         ORDER BY MEM_NAME;     
BEGIN
    OPEN CUR('�ֺ�'); --�Ű����� ����
    LOOP
        FETCH CUR INTO V_NAME, V_MILE; --��
        EXIT WHEN CUR%NOTFOUND; --�� ( CUR�����Ͱ� NOTFOUND�� ����)
        DBMS_OUTPUT.PUT_LINE(CUR%ROWCOUNT || ', ' || V_NAME || ', ' || V_MILE); --��
    END LOOP;
    CLOSE CUR;

END;
/

--������ �Է¹޾Ƽ� FOR LOOP�� �̿��ϴ� CURSOR
/
DECLARE     
    CURSOR CUR(V_JOB VARCHAR2) IS --�Ű������� ����
        SELECT MEM_NAME, MEM_MILEAGE
          FROM MEMBER
         WHERE MEM_JOB = V_JOB
         ORDER BY MEM_NAME;     
BEGIN
    --FOR LOOP
    --FOR������ �ݺ��ϴ� ���� Ŀ���� *�ڵ����� OPEN*�ϰ�
    --��� ���� ó���Ǹ� *�ڵ����� Ŀ���� CLOSE*��
    --REC : �ڵ����� ������ ����
    FOR REC IN CUR('�л�') LOOP
        DBMS_OUTPUT.PUT_LINE(CUR%ROWCOUNT || ', ' || REC.MEM_NAME || ', ' || REC.MEM_MILEAGE);
    END LOOP;

END;
/

/--���������� �̿��ؼ� ó��

BEGIN
    --FOR LOOP
    --FOR������ �ݺ��ϴ� ���� Ŀ���� *�ڵ����� OPEN*�ϰ�
    --��� ���� ó���Ǹ� *�ڵ����� Ŀ���� CLOSE*��
    --REC : �ڵ����� ������ ����
    FOR REC IN (SELECT MEM_NAME, MEM_MILEAGE
                  FROM MEMBER
                 WHERE MEM_JOB = '�л�'
                 ORDER BY MEM_NAME) LOOP
        DBMS_OUTPUT.PUT_LINE(REC.MEM_NAME || ', ' || REC.MEM_MILEAGE);
    END LOOP;

END;
/

--CURSOR����
--2020�⵵ ȸ���� �Ǹűݾ�(�ǸŰ�*���ż���)�� �հ�
--CURSOR�� FOR���� ���� ����غ���
--ALIAS : MEM_ID, MEM_NAME, SUM_AMT
--��¿��� : a001, ������, 2000
--          b001, �̻���, 1750
--                  :
(����Ŭ �Ϲ�����)
     SELECT A.MEM_ID,
            A.MEM_NAME,
            SUM(C.PROD_SALE * B.CART_QTY) AS OUT_AMT
       FROM MEMBER A, CART B, PROD C
      WHERE CART_NO LIKE '2020%'
        AND A.MEM_ID = B.CART_MEMBER --��������
        AND B.CART_PROD = C.PROD_ID
      GROUP BY A.MEM_ID, A.MEM_NAME
      ORDER BY 1;
      
 (ANSI INNER JOIN)
     SELECT A.MEM_ID, A.MEM_NAME, SUM(C.PROD_SALE * B.CART_QTY) AS OUT_AMT
       FROM PROD C
      INNER JOIN CART B ON (B.CART_PROD = C.PROD_ID)
      INNER JOIN MEMBER A ON (A.MEM_ID = B.CART_MEMBER)
      WHERE  B.CART_NO LIKE '2020%'
      GROUP BY A.MEM_ID, A.MEM_NAME
      ORDER BY 1;
      
 /
 DECLARE
    CURSOR CUR IS
        SELECT A.MEM_ID, A.MEM_NAME, SUM(C.PROD_SALE * B.CART_QTY) AS SUM_AMT
           FROM CART B
                 INNER JOIN PROD C ON (B.CART_PROD = C.PROD_ID)
                 INNER JOIN MEMBER A ON (A.MEM_ID = B.CART_MEMBER)
          WHERE  B.CART_NO LIKE '2020%'
          GROUP BY A.MEM_ID, A.MEM_NAME
          ORDER BY 1;
 BEGIN --FOR������ OPEN CLOSE�� �ʿ����
    FOR REC IN CUR LOOP
        IF MOD(CUR%ROWCOUNT,2) = 1 THEN --Ȧ����
        dbms_output.put_line(CUR%ROWCOUNT || ', ' || REC.MEM_ID || ', ' || REC.MEM_NAME || ', ' || REC.SUM_AMT);
        END IF; --IF�� �ݱ�
    END LOOP;
 END;
 /
 
 
1. Stored procedure
 --STORED(����Ŭ ������ ĳ�ð����� �̸� �����) PROCEDURE
 --������Ʈ ��뿩 ������Ʈ�� �����ϴ� ����� ������ ���డ��
 1)������Ʈ�����
 1-1)���ϴ� ������ Ȯ��
 --Ȯ�κ��� �ϰ� ������Ʈ�ؾߵ�
 SELECT PROD_ID, PROD_TOTALSTOCK
 FROM PROD
 WHERE PROD_ID = 'P101000001';
 1-2)���� ������Ʈ --����!
 --������Ʈ
 UPDATE PROD
 --��
 SET PROD_TOTALSTOCK = PROD_TOTALSTOCK + 10
 --�뿩
 WHERE PROD_ID = 'P101000001';
 
 2)PROCEDURE �̿�
 2-1) PROCEDURE����
 /--PROCEDURE�� ������ �ƴ϶� ������ �ؼ� ������ ĳ�������� �־��ִ� ��. ������Ʈ ���� ����
CREATE OR REPLACE PROCEDURE USP_PROD_TOTALSTOCK_UPDATE --REPLACE:PROCEDURE������
IS
BEGIN
    UPDATE PROD
    SET PROD_TOTALSTOCK = PROD_TOTALSTOCK + 10
    WHERE PROD_ID = 'P101000001';
    DBMS_OUTPUT.put_line('������Ʈ ����!');
    COMMIT;
END;
 /
 2-2)EXCU����
--EXECUTE USP_PROD_TOTALSTOCK_UPDATE;  
--PROCEDURE ���๮�� ���ν����� �������ٰ� �ͽ�ťƮ�� �����ؾ� ���̺� �����Ͱ� ��
EXEC USP_PROD_TOTALSTOCK_UPDATE;
/
2-3)SELECT���� ���� ��� Ȯ��
 SELECT PROD_ID, PROD_TOTALSTOCK
 FROM PROD
 WHERE PROD_ID = 'P101000001';


