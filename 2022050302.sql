2022-0503-02)�б⹮�� �ݺ���
1.�б⹮
 - ���߾���� �б⹮�� ���� �������
 - IF��, CASE WHEN �� ���� ����
 --CASE WHEN�� �ڹ��� SWITCH�� ���ٰ� ���� ��
 1)IF�� --�ڹٶ� �޸� ���ǹ��� ��ȣ�� ����(�ᵵ��..) {}��� THEN�� ����
  - ���Ǻб⹮
   (�������1) IF ELSE END IF
   IF ���ǹ� THEN
      ��ɹ�1;
   [ELSE 
      ��ɹ�2;]
   END IF; --����Ŭ���� {}�� �ȽἭ END IF; �� ����� ����

   (�������2) ����IF(��� ���� �̸�����)
   IF ���ǹ� THEN
      ��ɹ�1;
   ELSIF ���ǹ�2 THEN
      ��ɹ�2;
        :
   ELSE
      ��ɹ�n;
   END IF;  
   
   (�������3) ��øif �޽�Ƽ����ø --���϶��� ��ø����
   IF ���ǹ� THEN
     IF ���ǹ�2 THEN
        ��ɹ�1;
         :
     END IF;
   ELSE
      ��ɹ�n;
      
��뿹) ���� ����� ������̺� �����ϴ� �͸����� �ۼ��Ͻÿ�
       �����ϱ� ���� �ش� �̸��� ������ ���� ������ �Ǵ��Ͽ�
       ���� �̸��� ������ ������, ������ ������ �����Ͻÿ�.
       �����ȣ�� ���� ū �����ȣ ���� ��ȣ�� �����Ѵ�.
       �����: ȫ�浿, �Ի���: ����, �����ڵ� : IT_PROG
    DECLARE
      V_EID HR.EMPLOYEES.EMPLOYEE_ID%TYPE;     --�����ȣ�� �����ϴ� ����
      V_CNT NUMBER:=0; -- �ش� ��������� �������� �Ǵ�
    BEGIN
      SELECT COUNT(*) INTO V_CNT   --�̸��� ȫ�浿�� ���� �����
        FROM HR.EMPLOYEES
       WHERE EMP_NAME='ȫ�浿';
       --V_CNT = 0 => ȫ�浿�� �������� ������~
       IF V_CNT = 0 THEN
         SELECT MAX(EMPLOYEE_ID)+1 INTO V_EID  --���� ū �����ȣ ���� ��ȣ�� V_EID�� �־���
           FROM HR.employees;
         INSERT INTO HR.employees(EMPLOYEE_ID,EMP_NAME,JOB_ID,HIRE_DATE) --'NULL�� �ƴ�'�÷��� ���� �� ��.�÷��� �Ƚ��ָ� ��� �÷��� �� ����ְ� ��..
           VALUES(V_EID,'ȫ�浿','IT_PROG',SYSDATE);
      ELSE  --ȫ�浿�� �����ϸ�
        UPDATE HR.employees
           SET HIRE_DATE=SYSDATE,
               JOB_ID='IT_PROG'
         WHERE EMP_NAME='ȫ�浿';
      END IF;
      COMMIT;
    END;
    
    SELECT * FROM HR.employees;
    
2. CASE WHEN ��
  - ���� �б���(�ڹ��� SWITCH CASE���� ����) --�ڹٿ� �ִ� BREAK�� ����
  (�������1)
  CASE WHEN ����1 THEN
            ���1;
       WHEN ����2 THEN
            ���2;
             :
      [ELSE
            ���n;]
  END CASE;        --
  
  (�������2)
  CASE ����1 WHEN ��1 THEN
                 ���1;
            WHEN ��2 THEN
                 ���2;
        :
 [ELSE
                 ���n;]
  END CASE;  
  
��뿹)ȸ�����̺��� ���ϸ����� ��ȸ�Ͽ�
      0~2000 : 'Beginner'
      2001~5000 : 'Normal'
      5000~     : 'Excellent' �� ��� ����Ͻÿ�
      ����� ȸ����, ���ϸ���, ����̴�.
    DECLARE
      CURSOR CUR_MEM02  IS  --�� Ŀ����..? �ѻ���� �ƴ϶� ȸ������ŭ ����ؾ��ؼ� CURSOR�� �Ἥ �ݺ�. Ŀ���� �Ⱦ��� SELECT���� ���ؼ� �����Ǵ� �����ʹ� 24���� �ٵ� INTO�� ������ �ѹ��� �ϳ��ۿ� ���޴´�. ������ �� ����. �׷��� 24���� �� �޵� �ѹ��� �ϳ��� �ޱ� ���� ����ϴ� ���� Ŀ��
        SELECT MEM_NAME, MEM_MILEAGE FROM MEMBER; --��� ȸ���� ����̶� ������X
      V_RES VARCHAR2(200); --������� �� ��� �̸����ϸ������ �ѹ���
    BEGIN
      FOR REC IN CUR_MEM02 LOOP --REC���ڵ������ ù��° ���� ����Ű�� ����. Ŀ���� ������ �������� . //FOR������ OPEN FETCH CLOSE �Ƚᵵ��
         CASE WHEN REC.MEM_MILEAGE < 2001 THEN
                   V_RES:=RPAD(REC.MEM_NAME,10)|| --(�������Ŀ����ʿ�����)
                          LPAD(REC.MEM_MILEAGE,7)||'Beginner';
              WHEN REC.MEM_MILEAGE < 5001 THEN
                   V_RES:=RPAD(REC.MEM_NAME,10)||
                          LPAD(REC.MEM_MILEAGE,7)||'Normal';     
              ELSE V_RES:=RPAD(REC.MEM_NAME,10)||
                          LPAD(REC.MEM_MILEAGE,7)||'Excellent';    
         END CASE;                      
          DBMS_OUTPUT.put_line(V_RES); --DBMS���
          DBMS_OUTPUT.put_line('--------------------------');
      END LOOP;
    END;