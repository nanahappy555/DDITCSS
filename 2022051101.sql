2022-0511-01) EXCEPTION
SET SERVEROUTPUT ON;
--�ܼ�â�� DBMS����� ����ϱ� ���� �ڵ�
/*
����Ŭ �����ٷ� ����ϱ�!

�����ٷ���?
- Ư���� �ð��� �Ǹ� �ڵ������� ����(query)����� ����ǵ��� �ϴ� ���
*/
SELECT *
FROM   MEMBER
WHERE  MEM_ID = 'a001';

UPDATE MEMBER
SET    MEM_MILEAGE = MEM_MILEAGE + 10
WHERE  MEM_ID = 'a001';
/
SELECT MEM_ID, MEM_MILEAGE
FROM   MEMBER
WHERE  MEM_ID = 'a001';
/
EXEC USP_UP_MEMBER_MIL;
/
--PROCEDURE�� �����
CREATE OR REPLACE PROCEDURE USP_UP_MEMBER_MIL
IS
BEGIN
    UPDATE MEMBER
    SET    MEM_MILEAGE = MEM_MILEAGE + 10
    WHERE  MEM_ID = 'a001';
END;
/

--������ ���� (�͸���)
DECLARE
    --������JOB�� ������ ���̵�. ������ ����
    V_JOB NUMBER(5);
BEGIN
    DBMS_JOB.SUBMIT(
        V_JOB, --JOB���̵�
        'USP_UP_MEMBER_MIL;', --������ PROCEDURE �۾�
        SYSDATE, --���� �۾��� ������ �ð�
        'SYSDATE + (1/1440)', --1�и���
        FALSE --�Ľ�(�����м�, �ǹ̺м�)����
    );
    DBMS_OUTPUT.PUT_LINE('JOB_IS ' || TO_CHAR(V_JOB));
    COMMIT;
END;
/

--�����ٷ��� ��ϵ� �۾��� ��ȸ
SELECT * FROM USER_JOBS;
/
--�����ٷ����� �۾� ����
BEGIN
    DBMS_JOB.REMOVE(1);
END;
/    
SELECT SYSDATE,
       TO_CHAR(SYSDATE + (1/1440),'YYYY-MM-DD HH24:MI:SS'), --1�� ��
       TO_CHAR(SYSDATE + (1/24),'YYYY-MM-DD HH24:MI:SS'), --�ѽð� ��
       TO_CHAR(SYSDATE + 1,'YYYY-MM-DD HH24:MI:SS') --1�� ��
FROM   DUAL;       
/

/*
EXCEPTION
 - PL/SQL���� ERROR�� �߻��ϸ� EXCEPTION�� �߻��ǰ�
  �ش����� �����ϸ� ����ó���κ����� �̵���
��������
 - ���ǵ� ����
   PL/SQL���� ���� �߻��ϴ� ERROR�� �̸� ������
   ������ �ʿ䰡 ���� �������� �Ͻ������� �߻���
   1) NO_DATA_FOUND : �������
   2) TOO_MANY_ROWS : ������ ����
   3) DUP_VAL_ON_INDEX : ������ �ߺ� ���� (P.K/U.K)
   4) VALUE_ERROR : �� �Ҵ� �� ��ȯ �� ����
   5) INVALID_NUMBER : ���ڷ� ��ȯ�� �ȵ� EX)TO_NUMBER('������') 
   6) NOT_LOGGED_ON : DB�� ������ �ȵǾ��µ� ����
   7) LOGIN_DENIED : �߸��� ����� / �߸��� ��й�ȣ
   8) ZERO_DIVIDE : 0���� ����
   9) INVALID_CURSOR : ������ ���� Ŀ���� ����
   
 - ���ǵ��� ���� ����
   ��Ÿ ǥ�� ERROR
   ������ �ؾ� �ϸ� �������� �Ͻ������� �߻�
 
 - ����� ���� ����
   ���α׷��Ӱ� ���� ���ǿ� �������� ���� ��� �߻�
   ������ �ؾ� �ϰ�, ��������� RAISE���� ����Ͽ� �߻�
*/
/--DBMS����� �ܼ�â�� ����ϴ� ���
SET SERVEROUTPUT ON;
/
DECLARE
    V_NAME VARCHAR2(20);
BEGIN
    SELECT LPROD_NM + 10 INTO V_NAME
    FROM   LPROD
    WHERE  LPROD_GU = 'P201';
    dbms_output.put_line('�з���: ' || V_NAME);
    
    EXCEPTION --NO_DATE_FOUND �ʹ� ���� �߻��ϴ� ������ �̸��� ���ص�
        WHEN NO_DATA_FOUND THEN --ORA-01403
             DBMS_OUTPUT.put_line('�ش� ������ �����ϴ�.');
        WHEN TOO_MANY_ROWS THEN--TOO_MANY_ROWS ORA-01422
             DBMS_OUTPUT.put_line('�Ѱ� �̻��� ���� ���Խ��ϴ�.');     
        WHEN OTHERS THEN     
             DBMS_OUTPUT.put_line('��Ÿ ���� : ' || SQLERRM);    --SQLERRM �����޼���
    
END;
/

--���ǵ��� ���� ����
DECLARE
    --EXCEPTION Ÿ���� exp_reference ���� ����
    exp_reference EXCEPTION;
    --EXCEPTION_INIT�� ���� �����̸��� ������ȣ�� �����Ϸ����� �����
    PRAGMA EXCEPTION_INIT(exp_reference, -2292);
BEGIN
    --ORA-02292 ���� �߻�
    --
    DELETE FROM LPROD WHERE LPROD_GU='P101';
    DBMS_OUTPUT.PUT_LINE('�з� ����');
    EXCEPTION
        WHEN exp_reference THEN
            DBMS_OUTPUT.PUT_LINE('���� �Ұ�');
END;
/

SELECT *
FROM   USER_CONSTRAINTS
WHERE  CONSTRAINT_NAME = 'FR_BUYER_LGU';
/
-----------------------------------------------------------------------------------------

--����� ���� ����

--������� �� ��ũ��Ʈ ���� ������
ACCEPT p_lgu PROMPT '����Ϸ��� �з��ڵ� �Է�:' --������Ʈ(�Է�â)�� ���� ���� p_lgu������ ��
DECLARE
    --EXCEPTION Ÿ���� exp_reference ���� ����
    exp_lprod_gu EXCEPTION;
    v_lgu VARCHAR2(10) := UPPER('&p_lgu'); --�ּҷ� ã�ư� => ������Ʈ�� �Է��� 'p101'�� ġȯ�� => UPPER�� �빮�� P101�� ��ȯ
BEGIN
    DBMS_OUTPUT.PUT_LINE(V_LGU || '�� ��� ����');
END;

--p_lgu : CPU�� �޸𸮸� ã�ư� �� �ּҷ� ã�ư��� ��찡 �ְ� p_lgu�̸����� ã�ư��� ��찡 �ִ�
--&p_lgu�� �ּҷ� ã�ư��� ��
/

--P101�� �̹� �־ ��� ���ϰ� ���ƾ߰ھ�!!!!!!!!!!! --����Ŭ �ý��� ������ �ƴ�
SELECT LPROD_GU FROM LPROD;
/
ACCEPT p_lgu PROMPT '����Ϸ��� �з��ڵ� �Է�:' 
DECLARE
    --EXCEPTION Ÿ���� exp_reference ���� ����
    exp_lprod_gu EXCEPTION;
    v_lgu VARCHAR2(10) := UPPER('&p_lgu'); 
BEGIN
    IF v_lgu IN ('P101', 'P102', 'P201', 'P202') THEN --v_lgu�� IN (��ȣ ��)�� ����ִ� ���� �� �ϳ��� ��ġ�ϸ�
        --����ο��� RAISE�������� ��������� exp_lprod_gu��� EXCEPTION�� �߻���
        RAISE exp_lprod_gu;
    END IF;
    DBMS_OUTPUT.PUT_LINE(V_LGU || '�� ��� ����');
    
    EXCEPTION
        WHEN exp_lprod_gu THEN
            DBMS_OUTPUT.PUT_LINE(v_lgu  || '�� �̹� ��ϵ� �ڵ��Դϴ�.');
END;

/
Q. v_lgu��� ������ �� �����ؾ��ұ�?
1.
ACCEPT p_lgu PROMPT '����Ϸ��� �з��ڵ� �Է�:' => DECLARE �ۿ� �־ DECLARE�ȿ��� p_lgu��� ������ �ν����� ����
&p_lgu��� �ּҸ� ����Ϸ��� �ݵ�� v_lgu��� ������ �����ؾ���

2. v_lgu�� �������� �ʰ� UPPER('&p_lgu')�� ��� ����ϸ� ���������� �����
ACCEPT p_lgu PROMPT '����Ϸ��� �з��ڵ� �Է�:' 
DECLARE
    --EXCEPTION Ÿ���� exp_reference ���� ����
    exp_lprod_gu EXCEPTION;
    --v_lgu VARCHAR2(10) := UPPER('&p_lgu'); ������ �������� �ʰ� �غ����� �ּ�ó��!
BEGIN
    IF UPPER('&p_lgu') IN ('P101', 'P102', 'P201', 'P202') THEN --v_lgu�� IN (��ȣ ��)�� ����ִ� ���� �� �ϳ��� ��ġ�ϸ�
        --����ο��� RAISE�������� ��������� exp_lprod_gu��� EXCEPTION�� �߻���
        RAISE exp_lprod_gu;
    END IF;
    DBMS_OUTPUT.PUT_LINE(UPPER('&p_lgu') || '�� ��� ����');
    
    EXCEPTION
        WHEN exp_lprod_gu THEN
            DBMS_OUTPUT.PUT_LINE(UPPER('&p_lgu')  || '�� �̹� ��ϵ� �ڵ��Դϴ�.');
END;
/
---------------------------------------------------------------------------------
��뿹)
1)
--DEPARTMENT ���̺� �а��ڵ带 '�İ�',
--�а����� '��ǻ�Ͱ��а�', ��ȭ��ȣ�� '765-4100'
--���� INSERT�غ���
INSERT INTO DEPARTMENT(DEPT_ID, DEPT_NAME, DEPT_TEL)
    VALUES('�İ�', '��ǻ�Ͱ��а�', '765-4100');
    
2)
--constraint
���� ���� -
ORA-00001: unique constraint (LHR91.DEPARTMENT_PK) violated
--������ �ִ� DEPARTMENT�� PK�� Ȯ�� => �̹� �ִ� id
SELECT *
FROM   USER_CONSTRAINTS
WHERE  CONSTRAINT_NAME = 'DEPARTMENT_PK';

3) EXCEPTIONó��
--
/
DECLARE
BEGIN
    INSERT INTO DEPARTMENT(DEPT_ID, DEPT_NAME, DEPT_TEL)
    VALUES('�İ�', '��ǻ�Ͱ��а�', '765-4100');
    COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.put_line('<�ߺ��� �ε��� ���� �߻�!>');
        WHEN OTHERS THEN --�� �� ����
            NULL;
END;
/
---------------------------------------------------------------------------------
��뿹)
COURSE ���̺��� �����ڵ尡 'L1031'�� ���Ͽ�
�߰� ������(COURSE_FEES)�� '�︸��'���� �����غ���
[������ ������Ÿ���� ���� �߻�]
1.Ȯ�� ����
    SELECT COURSE_ID,
           COURSE_FEES
    FROM   COURSE
    WHERE COURSE_ID = 'L1031';
2. ������Ʈ��뿩  =>   ORA-01722: invalid number (���ڷ� ��ȯ�� �ȵ�)
    UPDATE COURSE
    SET COURSE_FEES = '�︸��'
    WHERE COURSE_ID = 'L1031';
/
DECLARE
BEGIN
    UPDATE COURSE
    SET COURSE_FEES = '�︸��'
    WHERE COURSE_ID = 'L1031';
    COMMIT;
    EXCEPTION
        WHEN invalid_number THEN
            DBMS_OUTPUT.PUT_LINE('<�߸��� ���� ���� �߻�!>');
        WHEN OTHERS THEN
            NULL;
END;
/

----------------------------------------------------------------------------------
��뿹) SG_SCORES ���̺� ����� SCORE �÷��� ������
100���� �ʰ��Ǵ� ���� �ִ��� �����ϴ� ����� �ۼ��غ���
��, 100�� �ʰ��� OVER_SCORE ���ܸ� �����غ���
[����� ���� ���ܷ� ó���غ���]

0. 100���� �ʰ��ϴ� �÷� �߰�
/
INSERT INTO SG_SCORES(STUDENT_ID, COURSE_ID, SCORE, SCORE_ASSIGNED)
VALUES('A1701','L0013',107,'2010/12/29');
/
1. ������ Ȯ���ϴ� SELECT��
/
SELECT STUDENT_ID, COURSE_ID, SCORE, SCORE_ASSIGNED
FROM SG_SCORES
WHERE SCORE > 100;
/
2.
--�ݺ����� ����Ͽ� SCORE�� 100�� �ʰ��ϸ�
--�� SCORE���� V_SCORE������ �ְ�
--RAISE OVER_SCORE;�� ������[���ܸ޼��� : 107������ 100���� �ʰ��մϴ�]
-----

-----���� Ǭ ��
--����� 105�ϳ��� ����
/
DECLARE
    OVER_SCORE EXCEPTION;
    V_SCORE SG_SCORES.SCORE%TYPE;
BEGIN 
    FOR V_ROW IN (SELECT T.SCORE 
                    FROM (SELECT SCORE
                            FROM SG_SCORES
                           WHERE SCORE > 100) T
    ) LOOP
        IF V_ROW.SCORE > 100 THEN
        RAISE OVER_SCORE;
        END IF;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('100���� �ʰ����� �ʽ��ϴ�');
    EXCEPTION 
        WHEN OVER_SCORE THEN
            DBMS_OUTPUT.PUT_LINE('100���� �ʰ��մϴ�');
END;
