2022-0510-01) USER FUNCTION
2.User Function ����� ���� �Լ�
 1)���� ���� ���� ������ Ȯ��!!!
SELECT PROD_ID, PROD_NAME, PROD_TOTALSTOCK
FROM PROD
WHERE PROD_ID = 'P101000002';


--PARAMETER(�μ�)�� ���
IN �Է¿�
OUT

/
2)���ν��� ���� --�ι��ε庯���� �̿�
CREATE OR REPLACE PROCEDURE USP_PROD_TOTALSTOCK_UPDATE
 (P_PROD_ID IN VARCHAR2, P_PROD_TOTALSTOCK IN NUMBER) --���ε庯�� 208LINE 'P101000002'�� ����/ �����°� �ι��ε� �����°� �ƿ����ε�. ��� PARAMETER�� ������ ������ �ι��ε�
IS
    --��������
BEGIN
    UPDATE PROD
    SET PROD_TOTALSTOCK = PROD_TOTALSTOCK + P_PROD_TOTALSTOCK --�������+20 / �μ��� �ι��ε庯���� �־��� P_PROD_ID, P_PROD_TOTALSTOCK
    WHERE PROD_ID = P_PROD_ID; --'P101000002' / �μ��� �ι��ε庯���� �־��� P_PROD_ID, P_PROD_TOTALSTOCK
    DBMS_OUTPUT.put_line('������Ʈ ����!');
   -- COMMIT;
END;
 /
3) �ͽ�ťƮ
--EXECUTE USP_PROD_TOTALSTOCK_UPDATE;  
EXEC USP_PROD_TOTALSTOCK_UPDATE('P101000002',20); --�μ��� �ι��ε庯���� �־��� P_PROD_ID, P_PROD_TOTALSTOCK
/
4) ������ �ݿ��ƴ��� Ȯ��
/
SELECT PROD_ID, PROD_NAME, PROD_TOTALSTOCK
FROM PROD
WHERE PROD_ID = 'P101000002';
/

��뿹) ȸ�����̵� �Է¹޾� �̸��� ��̸� OUT �Ű�������

(ANONYMOUS BLOCK���)
***PL/SQL�� INTO�� �� ��!***
**���������� DECLARE����**
/
DECLARE
    --SCALAR����
    V_NAME VARCHAR2(20);
    --REFERENCE����
    V_LIKE MEMBER.MEM_LIKE%TYPE; --=VARCHAR2(40)
BEGIN
    SELECT MEM_NAME, MEM_LIKE INTO V_NAME, V_LIKE
    FROM   MEMBER
    WHERE  MEM_ID = 'a001';
    
    DBMS_OUTPUT.put_line(V_NAME || ', ' || V_LIKE);
END;
/

(PROCEDURE ���)
/--���赵��� ����⸸���
CREATE OR REPLACE PROCEDURE USP_GET_MEMBER --USP_GET_MEMBER���ν����̸�
(P_MEM_ID IN VARCHAR2)
--�ι��ε�(�޾Ƽ����ǿ��Ҵ�)
IS
    --SCALAR����
    V_NAME VARCHAR2(20);
    --REFERENCE����
    V_LIKE MEMBER.MEM_LIKE%TYPE; --=VARCHAR2(40)
BEGIN
    SELECT MEM_NAME, MEM_LIKE INTO V_NAME, V_LIKE
    FROM   MEMBER
    WHERE  MEM_ID = P_MEM_ID;
    
    DBMS_OUTPUT.put_line(V_NAME || ', ' || V_LIKE);
END;
/--����� ������

EXEC USP_GET_MEMBER('c001'); --'c001'����
/




/--���赵��� ����⸸���
CREATE OR REPLACE PROCEDURE USP_GET_MEMBER --USP_GET_MEMBER���ν����̸�
(P_MEM_ID IN VARCHAR2, V_NAME OUT VARCHAR2, V_LIKE OUT VARCHAR2) --��Į��/���������� �ʿ����
--�ι��ε�(�޾Ƽ����ǿ��Ҵ�)     �ƿ����ε�                 �ƿ����ε�
IS
BEGIN
    SELECT MEM_NAME, MEM_LIKE INTO V_NAME, V_LIKE
    FROM   MEMBER
    WHERE  MEM_ID = P_MEM_ID;
END;
/--����� ������ --MEM_NAME,MEM_LIKE �������� ȸ����̴�°��� /--'c001'����,  : ����
--�Ʒ� ���� ��ü �巡�� ��������ؼ� ��ũ��Ʈ����
VAR MEM_NAME VARCHAR2(20) 
VAR MEM_LIKE VARCHAR2(20) 
EXEC USP_GET_MEMBER('c001', :MEM_NAME, :MEM_LIKE)
PRINT MEM_NAME
PRINT MEM_LIKE;
/

��뿹)2020�� ȸ���� ���űݾ��� ���� ���ϴ� ������ ������ SALE*QTY
      Alias: MEM_NAME, MEM_AMT
      �� �߿��� ���űݾ��� ���� ���� ���� 1�� ����غ���
    (�Ϲ�)
    SELECT M.MEM_NAME,
           SUM(P.PROD_SALE * C.CART_QTY) AS MEM_AMT
      FROM PROD P, MEMBER M, CART C
     WHERE P.PROD_ID = C.CART_PROD
       AND C.CART_MEMBER = M.MEM_ID
       AND CART_NO LIKE '2020%'
     GROUP BY MEM_NAME
     ORDER BY MEM_NAME;

    (ANSI)
    SELECT M.MEM_NAME,
           SUM(P.PROD_SALE * C.CART_QTY) AS MEM_AMT
      FROM CART C
     INNER JOIN PROD P ON (P.PROD_ID = C.CART_PROD)
     INNER JOIN MEMBER M ON (C.CART_MEMBER = M.MEM_ID AND CART_NO LIKE '2020%')
     GROUP BY MEM_NAME
     ORDER BY MEM_NAME;      
     
     
**����������...? �������� �ȿ� ���� �Ǵٸ� SQL��
����
SELECT ->SCALAR
FROM->IN-LINE VIEW
WHERE->NESTED

CREATE OR REPLACE PROCEDURE USP_MEM_TOP
(P_YEAR IN VARCHAR2,P_MEM_NAME OUT VARCHAR2, P_MEM_AMT OUT NUMBER)
IS
BEGIN
SELECT T.MEM_NAME, T.MEM_AMT INTO P_MEM_NAME, P_MEM_AMT
FROM 
   (
    SELECT M.MEM_NAME,
           SUM(P.PROD_SALE * C.CART_QTY) AS MEM_AMT
      FROM PROD P, MEMBER M, CART C
     WHERE P.PROD_ID = C.CART_PROD
       AND C.CART_MEMBER = M.MEM_ID
       AND CART_NO LIKE P_YEAR || '%'
     GROUP BY MEM_NAME
     ORDER BY 2 DESC
     )T
WHERE ROWNUM<=1;
END;
/
VAR P_MEM_NAME VARCHAR2
VAR P_MEM_AMT NUMBER
EXEC USP_MEM_TOP('2020', :P_MEM_NAME, :P_MEM_AMT)
PRINT P_MEM_NAME
PRINT P_MEM_AMT;
/


-- �ش� ���� ���� �ش� ��ǰ�� �԰�, ��� ó���� ȭ�鿡 ����غ���
--(���ν����� : USP_PRO_INFO, �� ������ YYYYMM�̶� ����, �԰� �� 
--���� OUT  �Ű������� ó��
--1) ������������(1~12)
CREATE OR REPLACE PROCEDURE USP_PRO_INFO
( P_WOL IN VARCHAR2, P_PROD_ID IN VARCHAR2
, P_IN_AMT OUT NUMBER, P_OUT_AMT OUT NUMBER)
IS
BEGIN
    SELECT I.IN_AMT, J.OUT_AMT INTO P_IN_AMT, P_OUT_AMT
    FROM
    (
        SELECT LEVEL WOL FROM   DUAL
        CONNECT BY  LEVEL + 1 <= 13
    ) H,
    (
        --2) �����԰�����
        SELECT EXTRACT(MONTH FROM BP.BUY_DATE) WOL
             , SUM(BP.BUY_QTY) IN_AMT
        FROM   PROD P, BUYPROD BP
        WHERE  P.PROD_ID = BP.BUY_PROD
        AND    TO_CHAR(BP.BUY_DATE,'YYYYMM') = P_WOL
        AND    P.PROD_ID = P_PROD_ID
        GROUP BY EXTRACT(MONTH FROM BP.BUY_DATE)
    ) I,
    (
        --3) �����������
        SELECT TO_NUMBER(SUBSTR(C.CART_NO,5,2)) WOL
             , SUM(C.CART_QTY) OUT_AMT
        FROM   PROD P, CART C
        WHERE  P.PROD_ID = C.CART_PROD
        AND    C.CART_NO LIKE P_WOL || '%'
        AND    P.PROD_ID = P_PROD_ID
        GROUP BY TO_NUMBER(SUBSTR(C.CART_NO,5,2))
    ) J
    WHERE H.WOL = I.WOL(+)
    AND   H.WOL = J.WOL(+)
    AND   H.WOL = TO_NUMBER(SUBSTR(P_WOL,-2));
END;
/
VAR P_IN_AMT VARCHAR2
VAR P_OUT_AMT VARCHAR2
EXEC USP_PRO_INFO('202004', 'P101000001', :P_IN_AMT, :P_OUT_AMT)
PRINT P_IN_AMT
PRINT P_OUT_AMT;
/
SET SERVEROUTPUT ON;
--ȸ�� ���̵� ������ �ش� �̸��� �����ϴ� �Լ� �����
CREATE OR REPLACE FUNCTION FN_GETNAME(P_MEM_ID IN VARCHAR2)
       RETURN VARCHAR2
    IS
     V_NAME VARCHAR2(30);
BEGIN
    SELECT MEM_NAME INTO V_NAME
      FROM MEMBER
     WHERE MEM_ID = P_MEM_ID;
     
     RETURN V_NAME;
     
     --DBMS_OUTPUT.PUT_LINE('V_NAME : ' || V_NAME);
 END;
/   
SELECT FN_GETNAME('c001') FROM DUAL; 
/

------------------------------------------------------------------------
SELECT EXTRACT(YEAR FROM SYSDATE) FROM DUAL;
--�⵵ �� ��ǰ�ڵ带 �Է� ������ �ش�⵵�� ��� �Ǹ� Ƚ���� ��ȯ�ϴ� �Լ�
/
CREATE OR REPLACE FUNCTION FN_PRODAVGQTY
(P_YEAR IN NUMBER DEFAULT(EXTRACT(YEAR FROM SYSDATE)),
 P_PROD_ID IN VARCHAR2)
    RETURN NUMBER
 IS 
    V_QTY NUMBER;
 BEGIN
        SELECT NVL(ROUND(AVG(CART_QTY),2),0) INTO V_QTY
          FROM CART
         WHERE CART_PROD = P_PROD_ID
           AND CART_NO LIKE P_YEAR || '%';
           
           RETURN V_QTY;
END;
/
VAR QTY NUMBER
EXEC :QTY := FN_PRODAVGQTY(2020,'P101000001')
PRINT QTY;
/
SELECT PROD_ID, PROD_NAME, 
       FN_PRODAVGQTY(2020,PROD_ID) AVG_QTY_2020,
       FN_PRODAVGQTY(2021,PROD_ID) AVG_QTY_2021
FROM PROD;
/
-----------------------------------------------------------------------------------------------
--�Լ� ����
--������ ���� ����غ���
--��ǰ�ڵ�, ��ǰ��, ��з��ڵ�, ��з���
--��, �Լ��� �����Ͽ� ��з����� ó���غ���
--�Լ����� FN_PRODNM
CREATE OR REPLACE FUNCTION FN_PRODNM(P_PROD_LGU IN VARCHAR2)
    RETURN VARCHAR2
IS
    V_NM VARCHAR2(100);
BEGIN
    SELECT LPROD_NM INTO V_NM
      FROM LPROD
     WHERE LPROD_GU = P_PROD_LGU;
    RETURN V_NM;
END;
/
SELECT PROD_ID, PROD_NAME, PROD_LGU,
       FN_PRODNM(PROD_LGU) NM
  FROM PROD;
  
