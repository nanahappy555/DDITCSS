2022-0504-01)-- FOR ���� ���� ��
2.�ݺ��� --LOOP,WHILE�� Ƚ���𸦶� FOR�� Ƚ���� ������ �� �� ��
  - LOOP, WHILE, FOR���� ������ --WHILE�� FOR���� ��� LOOP���� ������ �ִ�
  - �ַ� Ŀ���� ����ϱ� ���Ͽ� �ݺ����� �ʿ� --WHILE�� ������ ������ �ݺ� LOOP���� ������ ������ �ݺ�����
  1) LOOP
   . �⺻���� �ݺ������� *���ѷ���* ����
   (�������)
   LOOP
     �ݺ�ó����;
     [EXIT WHEN ����;] --�ڹ��� BREAK�� ���� ����
   END LOOP;
   - '����'�� ���϶� �ݺ����� ���(END LOOP ���� ��� ����)

��뿹)�������� 6���� ����Ͻÿ�.
    DECLARE
      V_CNT NUMBER:=1;
    BEGIN
      LOOP
        dbms_output.put_line('6 * '||V_CNT||' = '||(6*V_CNT); --6*1 = 6 ���� ���
        EXIT WHEN V_CNT >= 9;
        V_CNT:=V_CNT+1;
      END LOOP;
    END;      
    
��뿹)������̺��� �����ڵ尡 'SA_REP'�� ��������� �͸����� ����Ͽ� ����Ͻÿ� 
     ����� ������ �����ȣ,�����,�Ի����̴�. --����� ������ ������ ��ߵ�
     --�Ʒ� ������ Ŀ��(��)�� �� ���� --Ŀ�� ���μ��� 1.����� ���� 2.OPEN 3.FETCH(.=.READ) 4.CLOSE
        DECLARE --���� ����
          V_EID HR.employees.EMPLOYEE_ID%TYPE;
          V_ENAME HR.employees.EMP_NAME%TYPE;
          V_HDATE DATE;
          CURSOR CUR_EMP01 IS --Ŀ���� ���� �Ӽ�: NOTFOUND(���̻� �����Ͱ� ������ ��, ������ ����)/FOUND (�����Ͱ� ������ ��, ������ ����)/FETCH
            SELECT EMPLOYEE_ID,EMP_NAME,HIRE_DATE
              FROM HR.employees
             WHERE JOB_ID='SA_REP';
         BEGIN 
           OPEN CUR_EMP01; --���°���
           LOOP
             FETCH CUR_EMP01 INTO V_EID,V_ENAME,V_HDATE; --ù�ٺ��� ���ʴ�� �о�´�, �����ִ� �ڷᰡ �ִ��� �������� ��ġ�� �����غ��� �˼�����
             EXIT WHEN CUR_EMP01%NOTFOUND;
             DBMS_OUTPUT.PUT_LINE('�����ȣ : '||V_EID);
             DBMS_OUTPUT.PUT_LINE('����� : '||V_ENAME);
             DBMS_OUTPUT.PUT_LINE('�Ի��� : '||V_HDATE);
             DBMS_OUTPUT.PUT_LINE('----------------');
             
           END LOOP;
           CLOSE CUR_EMP01;
         END;
     
  2) WHILE�� --�߾Ⱦ�
   . ������ �Ǵ��Ͽ� �ݺ��� �������� ���θ� �Ǵ��ϴ� �ݺ���
   (�������)
   WHILE ���� LOOP
     �ݺ�ó����(��);
  END LOOP;
  - '����'�� ���̸� �ݺ��� �����ϰ� �����̸� �ݺ����� ���
��뿹)�������� 6���� ����Ͻÿ�(WHILE�� ���)  
     DECLARE
       V_CNT NUMBER:=1;
     BEGIN
       WHILE V_CNT<=9 LOOP --�ݺ��� ����Ǳ� ���� �����ִ��� �ƴ��� �˾ƾߵ�-> WHILE�� �ۿ��� FETCH(üũ��)�� ���;���. �ٵ� WHILE�� ���ʿ��� FETCH�� �־�� �ݺ��� ������
         dbms_output.put_line('6* '||V_CNT||' = '||6*V_CNT);
         V_CNT:=V_CNT+1; 
       END LOOP;
     END;
     
��뿹)������̺��� �����ڵ尡 'SA_MAN'�� ��������� �͸����� ����Ͽ� ����Ͻÿ� 
    DECLARE
      V_EID HR.employees.EMPLOYEE_ID%TYPE;
      V_ENAME HR.employees.EMP_NAME%TYPE;
      V_HDATE DATE;
      CURSOR CUR_EMP02 IS
         SELECT EMPLOYEE_ID,EMP_NAME,HIRE_DATE
           FROM HR.employees
          WHERE JOB_ID='SA_MAN';
    BEGIN --���ϸ��� ����. FETCH���� ������. FOUND�� ���� ���� �ٽ� FETCH�ι�°����ҷ���.
      OPEN CUR_EMP02; 
      FETCH CUR_EMP02 INTO V_EID,V_ENAME,V_HDATE;
      WHILE CUR_EMP02%FOUND  LOOP
        DBMS_OUTPUT.PUT_LINE('�����ȣ : '||V_EID);
        DBMS_OUTPUT.PUT_LINE('����� : '||V_ENAME);
        DBMS_OUTPUT.PUT_LINE('�Ի��� : '||V_HDATE);
        DBMS_OUTPUT.PUT_LINE('----------------');
        FETCH CUR_EMP02 INTO V_EID,V_ENAME,V_HDATE; --�� �������� FETCH ������ߵ�.
      END LOOP;
      CLOSE CUR_EMP02;
    END;
    
  3) FOR�� --Ŀ���� ���� ������ ����   �ݺ�Ƚ�� �𸦶��� ����, ������
   . ����Ƚ���� �߿��ϰų� �˰� �ִ� ��� ���
   (�Ϲ��� FOR�� �������) --REVERSE�������� ������
    FOR �ε��� IN [REVERSE] �ʱⰪ..������ LOOP  --����..����. ������~~~1�� ������. ���������� �ʿ����. ���������� �����ϸ� �˾Ƽ� ����.
      �ݺ�ó����ɹ�(��);
    END LOOP;
    
   (CURSOR�� FOR�� �������) --REVERSE�������� ������
    FOR ���ڵ�� IN Ŀ����|Ŀ������|Ŀ����SELECT�� LOOP  --����..����. ������~~~1�� ������. ���������� �ʿ����. ���������� �����ϸ� �˾Ƽ� ����.
      Ŀ��ó����
    END LOOP;    
     . 'Ŀ����|Ŀ������|Ŀ����SELECT��' : Ŀ���� ����ο��� ������ ��� Ŀ������ ���,
       in-line �������� Ŀ���� SELECT ���� ���� ��� ����
     . OPEN, FETCH, CLOSE���� ������� ����
     . Ŀ������ �÷��� ������ '���ڵ��.Ŀ���÷���' ����
     
��뿹)�������� 6���� ����Ͻÿ�(FOR�� ���)  
    DECLARE
    BEGIN
      FOR I IN 1..9 LOOP
      dbms_output.put_line('6 * '||I||' = '||I*6);
      END LOOP;
    END;
    
    DECLARE
    BEGIN
      FOR I IN REVERSE 1..9 LOOP --6*9���� 6*1���� �������� ���
      dbms_output.put_line('6 * '||I||' = '||I*6);
      END LOOP;
    END;
    
��뿹)������̺��� �����ڵ尡 'SA_MAN'�� ��������� �͸����� ����Ͽ� ����Ͻÿ� 
    DECLARE
      CURSOR CUR_EMP03 IS
         SELECT EMPLOYEE_ID,EMP_NAME,HIRE_DATE
           FROM HR.employees
          WHERE JOB_ID='SA_MAN';
    BEGIN 
      FOR REC IN CUR_EMP03 LOOP
        DBMS_OUTPUT.PUT_LINE('�����ȣ : '||REC.EMPLOYEE_ID);
        DBMS_OUTPUT.PUT_LINE('����� : '||REC.EMP_NAME);
        DBMS_OUTPUT.PUT_LINE('�Ի��� : '||REC.HIRE_DATE);
        DBMS_OUTPUT.PUT_LINE('----------------');
      END LOOP;
    END;    
    
 (��ª��..)
    DECLARE
    BEGIN 
      FOR REC IN (SELECT EMPLOYEE_ID,EMP_NAME,HIRE_DATE
                    FROM HR.employees
                   WHERE JOB_ID='SA_MAN')
      LOOP
        DBMS_OUTPUT.PUT_LINE('�����ȣ : '||REC.EMPLOYEE_ID);
        DBMS_OUTPUT.PUT_LINE('����� : '||REC.EMP_NAME);
        DBMS_OUTPUT.PUT_LINE('�Ի��� : '||REC.HIRE_DATE);
        DBMS_OUTPUT.PUT_LINE('----------------');
      END LOOP;
    END;    