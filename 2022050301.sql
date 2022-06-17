2022-0503-01) PL/SQL(Procedual Language SQL) --���ݱ����� ������
  - ǥ�� spl�� Ȯ�� --�Ѱ�������
  - ������ ����� Ư¡�� ����(��, �ݺ�, ����, ��� ��)
  - �̸� ������ ����� �������Ͽ� ������ �����ϰ� �ʿ�� ȣ����� --�̸� Ư���� ����� ��ȯ/����� �� �ִ� ����� �̸� ������
  - ���ȭ/ĸ��ȭ
  - Anonymous Block, Stored Procedure, User Defined Function, Trigger, Package ���� ������
  --Anonymous Block: �͸���. ����X->ȣ��X. 1ȸ��. PL/SQL�� ���� �⺻����
  --Stored Procedure: ���� Procedure���ν��� ��� ��. �Լ��� ���� �����ؾߵ�. �ڹ��� VOID�� Procedure. ��ȯ���� ������ ��������
  --User Defined Function: ����ڰ� �ڱ��� ������ �´� ����� �������� ���� ����ڰ� ������ �Լ�. �ڹ��� ��ȯŸ�Ը޼���
  --Trigger: �ڵ�ȣ�����
  --Package: ���� ������Ʈ �Ҷ���X ����ο� �����(BODY)�� �и��Ǿ�����.
  --������
  --ǥ������ ����x �� DBMS���� ������ �ٸ�. (ǥ�� SQL�� ANSI�� ����)
  --������ �޸� �ʿ�
  
1. Anonymous Block �͸��� 
  - ���� �⺻���� pl/sql ���� ����
  - ���𿵿��� ���࿵������ ����
  - ������� ���� --�ٽ� �ҷ��� �� �ִ� �����ϵ� �ڵ尡 ����X ��� ����� ���Ѿߵ�.
  (�������)
    DECLARE
     �����(1����,2���,3Ŀ�� ����) -- 1~3�� �� �� ����
    BEGIN
     �����(�����Ͻ� ���� ó���� ���� SQL��) --���ݱ��� �� SQL���
     [EXCEPTION  --
        ����ó����
     ]
    END;

��뿹)�泲�� �����ϴ� ȸ������ 2020�� 5�� ���Ž����� ��ȸ�Ͻÿ�. --�泲�� ���� ȸ��-Ŀ��
--������ �ѹ��� �ϳ��� �����.
--ǥ��SQL������ SELECT FROM WHERE // PL/SQL������ SELECT INTO FROM WHERE
--SELECT�� ���� ���� ���. ������ �ѹ��� �ϳ��� ����Ǳ� ������ �����Ҽ�����
--���ʴ�� �����Ϸ���(������0
--Ŀ��=��
--���OPEN ��³����� CLOSE
--Ŀ���� ���� ���پ� �����б� ����
���� : VARIABLE  �̸� : V_...
�Ű����� : PARAMETER �̸� : P_...
    DECLARE --��������
    V_MID MEMBER.MEM_ID%TYPE; --ȸ����ȣ
    V_MNAME MEMBER.MEM_NAME%TYPE; --ȸ���̸�
    V_AMT NUMBER:=0;  --���űݾ��հ�
    CURSOR CUR_MEM IS --Ŀ���� ���پ� �о�´� ==VIEW�� ���� SELECT���� ���=CURSOR
      SELECT MEM_ID,MEM_NAME        --3��2���� ����. 3����� �ΰ��� �÷�
        FROM MEMBER
       WHERE MEM_ADD1 LIKE '�泲%';
  BEGIN
    OPEN CUR_MEM; --Ŀ���� ����
    LOOP --�ݺ�. 3���̴ϱ� 3�� �ݺ�
      FETCH CUR_MEM INTO V_MID, V_MNAME;  --Ŀ���� �о���� ��� FETCH. CUR_MEM�� �ҷ��ͼ� INTO�� ���� V_MID, V_MNAME
      EXIT WHEN CUR_MEM%NOTFOUND; -- EXIT WHEN �������� �о�� ���ΰ�? CUR_MEM%NOTFOUND �ڷᰡ ���������� NOT FOUND���� NOT FOUND�� TRUE�� EXIT
      SELECT SUM(B.PROD_PRICE*A.CART_QTY) INTO V_AMT --�ڷᰡ ���� ��.  SELECT���� ���� ����� 3���ε�  INTO�� �������� 1���ۿ� ������. �׷��� CURSOR�� �����
        FROM CART A, PROD B
       WHERE A.CART_PROD=B.PROD_ID
         AND A.CART_NO LIKE '202005%'
         AND A.CART_MEMBER=V_MID;
        DBMS_OUTPUT.PUT_LINE('ȸ����ȣ : '||V_MID);  --�ڹ��� SYSO�� ���
        DBMS_OUTPUT.PUT_LINE('ȸ���� : '||V_MNAME);
        DBMS_OUTPUT.PUT_LINE('�����հ� : '||V_AMT);
        DBMS_OUTPUT.PUT_LINE('--------------------');
    END LOOP;  --3�� �ݺ��ϰ� CURSOR NOTFOUND�� TRUE�� �Ǿ CLOSE�� ����
    CLOSE CUR_MEM;
  END;
  
  1)������ ���
   - BEGIN ~ END ��Ͽ��� ����� ���� �� ��� ����
   (��������)
   ������  [CONSTANT] ������Ÿ��|����Ÿ�� [:=�ʱⰪ]; --CONSTANT�� ���� ��� �Ⱦ��� ����
   . ������ ����
    - SCLAR ���� : �ϳ��� ���� �����ϴ� �Ϲ��� ����
    - ������ ���� : �ش� ���̺��� ��(ROW)�� �÷�(COLUMN)�� Ÿ�԰� ũ�⸦ �����ϴ� ���� --�� �� ��ü�� ����
    - BIND���� : �Ķ���ͷ� �Ѱ����� ���������ϱ� ���� ���� --�Ű�����PARAMETER 
�׳��̷��Կܿ���   --������ NUMBER Ÿ���� ��� �ʱ�ȭ��Ų��.
�׳��̷��Կܿ���    --����� ��� �ʱ�ȭ��Ų��
   . ��� ������ CONSTANT ���� ����ϸ� �̶� �ݵ�� �ʱⰪ�� �����ؾ� �� --�ڹ��� FINAL
   . ������ Ÿ��
     - SQL���� ����ϴ� �ڷ�Ÿ��
     - PLS_INTEGER, BINARY_INTEGER -> 4 byte ���� --�ڹ��� INT -21��~21�� �ʹ� �۾Ƽ� �� �Ⱦ�
     - BOOLEAN ��� ����  --��..��..��... ����Ŭ�� BOOLEAN������ TURE, FALSE, NULL�� ����
   . ������ ������ ����� �ݵ�� �ʱ�ȭ
   . ������
    - ������ : ���̺��.�÷���%TYPE --�ش����̺��� �ش翭�� �Ȱ��� Ÿ��,ũ��� ��������
    --������ �;��� �����ʹ� �� ���� Ÿ�԰� ũ�⸦ �˰� ������ ���� �ȿ��������.
    - ������ : ���̺��%ROWTYPE
    --�� �࿡ �������� �� ����. �� ���� 

��뿹)Ű����� �⵵�� ���� �Է� �޾� �ش� �Ⱓ���� ���� ���� ���ͱݾ��� ����� ��ǰ�� ���������� ��ȸ�Ͻÿ�.
1.Ű����� �⵵�� ���� �Է¹޾� --ACCEPT == �ڹ��� SCANNER 
    ACCEPT P_PERIOD PROMPT '�Ⱓ(�⵵/��) �Է� : '  --�����ݷ� X
    --�Էµ� ���� �ڵ����� �� ���� �ȿ� ���� P_PERIOD ������ '���ڿ�'�� �����
    
    ACCEPT P_PERIOD PROMPT '�Ⱓ(�⵵/��) �Է� : ' --���� �����ϱ� ���� �߰������
    DECLARE --S_DATE(������ START) E_DATE(������ END) 
      S_DATE DATE := TO_DATE(&P_PERIOD||'01'); --�������� // &P_PERIOD **Ű����� �Է¹��� P_PERIOD ** �� ���� �������� ����
      E_DATE DATE := LAST_DAY(S_DATE);
    BEGIN
      dbms_output.put_line(S_DATE);
    END;
    
2.�ش� �Ⱓ���� ���� ���� ���ͱݾ��� ����� ��ǰ
    ACCEPT P_PERIOD PROMPT '�Ⱓ(�⵵/��) �Է� : ' --���� �����ϱ� ���� �߰������
    DECLARE --S_DATE(������ START) E_DATE(������ END) 
      S_DATE DATE := TO_DATE(&P_PERIOD||'01'); --�������� // &P_PERIOD **Ű����� �Է¹��� P_PERIOD ** �� ���� �������� ����
      E_DATE DATE := LAST_DAY(S_DATE);
      V_PID PROD.PROD_ID%TYPE;  --PROD_ID�� Ÿ�԰� ũ�⸦ ������ PROD���̺��� PROD_ID���� �����ϸ� ��
      V_PNAME PROD.PROD_NAME%TYPE;
      V_AMT NUMBER :=0; --���ڴ� �ʱ�ȭ.....
    BEGIN
      SELECT TA.BID, TA.BNAME, TA.BSUM INTO V_PID, V_PNAME, V_AMT --�̷��� �Ҵ��ϼ���
        FROM (SELECT B.BUY_PROD AS BID, 
                     A.PROD_NAME AS BNAME, 
                     SUM(A.PROD_COST*B.BUY_QTY) AS BSUM
                FROM PROD A, BUYPROD B
               WHERE B.BUY_DATE BETWEEN S_DATE AND E_DATE
                 AND A.PROD_ID=B.BUY_PROD
               GROUP BY B.BUY_PROD, A.PROD_NAME
               ORDER BY 3 DESC) TA
       WHERE ROWNUM=1; --���� ���� �ݾ� �ϳ��ϱ� ROWNUM�� 1���ΰŸ� ������ ��. --ROWNUM�� ()�ȿ� ���� ������� ������ 1�����ؼ� ���� ���ϴ°Ŷ� �ƹ� �ǹ̾��Ե�           
       DBMS_OUTPUT.PUT_LINE('��ǰ�ڵ� : '|| V_PID);
       DBMS_OUTPUT.PUT_LINE('��ǰ�� : '|| V_PNAME);
       DBMS_OUTPUT.PUT_LINE('���Աݾ��հ� : '|| V_AMT);
       
    END;
    

   --����
��뿹)������ �μ��ڵ带 �����Ͽ� �ش�μ��� ���� ���� �Ի��� ��������� ��ȸ�Ͻÿ�.
      Alias�� �����ȣ,�����,�μ���,�����ڵ�,�Ի���
    DECLARE
      V_EID HR.employees.EMPLOYEE_ID%TYPE;
      V_ENAME HR.employees.EMP_NAME%TYPE;
      V_DNAME HR.departments.DEPARTMENT_NAME%TYPE;
      V_JOBID HR.employees.JOB_ID%TYPE;
      V_HDATE DATE;
      V_DID HR.employees.DEPARTMENT_ID%TYPE:=TRUNC(dbms_random.value(10,110),-1); --���Ƿ� ������ �μ��ڵ尡 ��
    BEGIN
      SELECT TA.EID, TA.ENAME, TA.DNAME, TA.JID, TA.HDATE 
        INTO V_EID, V_ENAME, V_DNAME, V_JOBID, V_HDATE
        FROM (SELECT A.EMPLOYEE_ID AS EID,
                     A.EMP_NAME AS ENAME,
                     B.DEPARTMENT_NAME AS DNAME,
                     A.JOB_ID AS JID,
                     A.HIRE_DATE AS HDATE
                FROM HR.employees A, HR.departments B
               WHERE A.DEPARTMENT_ID=V_DID
                 AND A.DEPARTMENT_ID=B.DEPARTMENT_ID
               ORDER BY 5 ) TA
       WHERE ROWNUM=1;         
        DBMS_OUTPUT.PUT_LINE('�����ȣ : '||V_EID);
        DBMS_OUTPUT.PUT_LINE('����� : '||V_ENAME);
        DBMS_OUTPUT.PUT_LINE('�μ��� : '||V_DNAME);
        DBMS_OUTPUT.PUT_LINE('�����ڵ� : '||V_JOBID);
        DBMS_OUTPUT.PUT_LINE('�Ի��� : '||V_HDATE);
    END;
    
    ����
      TRUNC(dbms_random.value(10,110),-1) --(�ʱⰪ,�ּҰ�) 10~110���� ������ 10 11 12 13 14 �̷��� �����ϱ� 10������ ������ TRUNC�Լ� (ASDF,-1) 1�ڸ� ������