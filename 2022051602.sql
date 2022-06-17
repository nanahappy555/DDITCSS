2022-0516-02)PACKAGE
+ ���� �������� �ִ� PL/SQLŸ��, ����, �Լ�, Ŀ��, ���� ���� �׸��� ������� ��ü
+ ������ ������ ���� DB�� ����Ǹ� �ٸ� ���α׷�(���ν���, �Լ� ��)���� ��Ű�� �׸���� ����, ����, ������ �� ����
+ ��Ű���� ����ο� ����η� ����

## 1)�����
+ ��Ű������ ����� ����� ���� Ÿ��, ���, ����, �������α׷��� **���** ���� ������ ���� �κ�
+ �ڹ��� �������̽��� �߻� Ŭ���� ����� ���� (���� ����� ����� ����)
+ ��ӵ� ��Ģ�� ����� ��

(��� ����)
CREATE OR REPLACE PACKAGE ��Ű���� IS
    ���, ����, Ŀ��, ���� �� ����;

    FUNCTION �Լ���( --�Լ��� ���, ������Ÿ��
        �Ű����� IN|OUT|INOUT Ÿ�Ը�,....) --ũ�� ���� X VARCHAR2(20)(X) VARCHAR2 (O)
        RETURN Ÿ�Ը�;
          :
    PROCEDURE ���ν�����( --���ν����� ��ȯ���� ��� RETURN X
        �Ű����� IN|OUT|INOUT Ÿ�Ը�,...); --ũ�� ����X
          :
END ��Ű����; --��Ű���� ��������

## 2)��Ű���� ����
+ ����� �������α׷��� �����κ�
+ �ڹ��� 
(��� ����) ����ο��� ����� �Լ��� ���ν����� ���� ����
CREATE OR REPLACE PACKAGE ��Ű���� IS
    ���, ����, Ŀ��, ���� �� ����;
    FUNCTION �Լ���( 
        �Ű����� IN|OUT|INOUT Ÿ�Ը�,....)
        RETURN Ÿ�Ը�
    IS
    
    BEGIN
    
    END �Լ���;
          :
    PROCEDURE ���ν�����( 
        �Ű����� IN|OUT|INOUT Ÿ�Ը�,...)
    IS
    
    BEGIN
    
    END ���ν�����;
          :    
END ��Ű����;

����)
��Ű����.���ν�����
��Ű����.�Լ���

��뿹)�ű� ��� ���, �������ó��, ����˻��� ������ �� �ִ� ��Ű���� �����Ͻÿ�. 
RETIRE_DATE�� NULL�̸� ������
����˻� : �����ȣ�� �Է� �޾Ƽ� �̸��� *��ȯ*�ϴ� �Լ�
�������ó�� : ��ȯ�� ���� ���� => ���ν���      

  CREATE OR REPLACE PACKAGE PKG_EMP  IS
    FUNCTION fn_get_empname
      (P_EID IN HR.EMPLOYEES.EMPLOYEE_ID%TYPE)
      RETURN HR.EMPLOYEES.EMP_NAME%TYPE;
      
    PROCEDURE proc_insert_new_emp(
      P_HDATE IN VARCHAR2,
      P_JID IN HR.JOBS.JOB_ID%TYPE,
      P_ENAME IN HR.EMPLOYEES.EMP_NAME%TYPE,
      P_SAL HR.EMPLOYEES.SALARY%TYPE);
      
    PROCEDURE proc_retire(
      P_EID IN HR.EMPLOYEES.EMPLOYEE_ID%TYPE,
      P_HDATE IN VARCHAR2);
  END PKG_EMP;   
(�����)
CREATE OR REPLACE PACKAGE PKG_EMP IS
    FUNCTION FN_GET_EMPNAME
        (P_EID IN HR.employees.EMPLOYEE_ID%TYPE) --IN : �ܺηκ��� �Է¹޾Ƽ� ���
    RETURN HR.employees.EMP_NAME%TYPE;
    
    PROCEDURE PROC_INSERT_NEW_EMP(
        P_HDATE IN VARCHAR2,
        P_JID IN HR.JOBS.JOB_ID%TYPE,
        P_ENAME IN HR.employees.EMP_NAME%TYPE
        P_SAL HR.employees.SALARY%TYPE);
        
    PROCEDURE PROC_RETIRE(
        P_EID IN HR.employees.EMPLOYEE_ID%TYPE, --�ʼ��÷�==NULL�� �ƴ� �÷�
        P_HDATE IN VARCHAR2);
END PKG_EMP;

(��Ű�� ������)
CREATE OR REPLACE PACKAGE PKG_EMP IS
    FUNCTION FN_GET_EMPNAME
        (P_EID IN HR.employees.EMPLOYEE_ID%TYPE) --IN : �ܺηκ��� �Է¹޾Ƽ� ���
    RETURN HR.employees.EMP_NAME%TYPE
IS
    V_ENAME HR.employees.EMP_NAME%TYPE;
BEGIN
    SELECT EMP_NAME INTO V_ENAME
      FROM HR.employees
     WHERE EMPLYEE_ID = P_EID;
     
     RETURN NVL(V_ENAME,'�ش� ������� ����'); --NVL�� �� Ÿ���� ���ƾ� ��
END FN_GET_EMPNAME;
    
    PROCEDURE PROC_INSERT_NEW_EMP(
        P_HDATE IN VARCHAR2,
        P_JID IN HR.JOBS.JOB_ID%TYPE,
        P_ENAME IN HR.employees.EMP_NAME%TYPE,
        P_SAL HR.employees.SALARY%TPE);
IS
    V_EID HR.EMPLOYESS.EMPLOYEE_ID%TYPE;
BEGIN
    SELECT MAX(EMPLOYEE_ID)+1 INTO V_EID
      FROM HR.EMPLOYESS;
      
    INSERT INTO 
END
        
    PROCEDURE PROC_RETIRE(
        P_EID IN HR.employees.EMPLOYEE_ID%TYPE, --�ʼ��÷�==NULL�� �ƴ� �÷�
        P_HDATE IN DATE);
IS
BEGIN
END

END PKG_EMP;

IF THEN
RAISE <- �ڹ��� THROWS�� ����
 CREATE OR REPLACE PACKAGE BODY PKG_EMP  IS
    FUNCTION fn_get_empname(
      P_EID IN HR.EMPLOYEES.EMPLOYEE_ID%TYPE)
      RETURN HR.EMPLOYEES.EMP_NAME%TYPE
    IS
      V_ENAME HR.EMPLOYEES.EMP_NAME%TYPE;
    BEGIN 
      SELECT EMP_NAME INTO V_ENAME
        FROM HR.EMPLOYEES
       WHERE EMPLOYEE_ID=P_EID;
       
      RETURN NVL(V_ENAME,'�ش� ������� ����'); 
    END fn_get_empname;
      
    PROCEDURE proc_insert_new_emp(
      P_HDATE IN VARCHAR2,
      P_JID IN HR.JOBS.JOB_ID%TYPE,
      P_ENAME IN HR.EMPLOYEES.EMP_NAME%TYPE,
      P_SAL HR.EMPLOYEES.SALARY%TYPE)
    IS
      V_EID  HR.EMPLOYEES.EMPLOYEE_ID%TYPE;
    BEGIN
      SELECT MAX(EMPLOYEE_ID)+1 INTO V_EID
        FROM HR.EMPLOYEES;
        
      INSERT INTO HR.EMPLOYEES(EMPLOYEE_ID,HIRE_DATE,JOB_ID,EMP_NAME,
                               SALARY)
        VALUES(V_EID,TO_DATE(P_HDATE),P_JID,P_ENAME,P_SAL);
      
      COMMIT;  
    END proc_insert_new_emp;
      
    PROCEDURE proc_retire(
      P_EID IN HR.EMPLOYEES.EMPLOYEE_ID%TYPE,
      P_HDATE IN VARCHAR2)
    IS
      V_CNT NUMBER:=0;
      E_NO_DATE EXCEPTION;
    BEGIN
      UPDATE HR.EMPLOYEES
         SET RETIRE_DATE=TO_DATE(P_HDATE)
       WHERE EMPLOYEE_ID=P_EID
         AND RETIRE_DATE IS NULL;
         
      V_CNT:=SQL%ROWCOUNT;
      
      IF V_CNT=0 THEN
         RAISE E_NO_DATE;
      END IF;     
      COMMIT;
      EXCEPTION WHEN E_NO_DATE THEN
           DBMS_OUTPUT.PUT_LINE(P_EID||'�� ������� ����');
           ROLLBACK;
        WHEN OTHERS THEN  
           DBMS_OUTPUT.PUT_LINE(SQLERRM);
           ROLLBACK;     
    END proc_retire;
  END PKG_EMP;    

(����-����� �˻�)
SELECT EMPLOYEE_ID,
       pkg_emp.fn_get_empname(EMPLOYEE_ID), --��Ű����.�Լ�(�Ű�����)
       SALARY
  FROM HR.EMPLOYEES;

(����-�űԻ�����)
EXEC pkg_emp.proc_insert_new_emp('20201220','SA_MAN','�ű浿',13000); --�͸��Ͽ��� �����Ҷ��� EXEC���� �ȵ�

(����-������ó��)
ACCEPT P_EID PROMPT '��������� �����ȣ �Է� : '
DECLARE
    V_EID HR.employees.employee_id%TYPE:=TO_NUMBER('&P_EID');
    V_HDATE VARCHAR2(8)='20210710':
BEGIN
    pkg_emp.proc_retire(V_EID,V_HDATE);       
END;