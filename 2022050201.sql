2022-0502-01) 
1. VIEW
  - ���̺�� ������ ��ü
  - '������ ���̺��̳� �信 ���� SELECT���� ��� ����'�� �̸��� �ο��� ��ü -- �̸��� �ο��Ǹ� �����. ����Ǹ� �ٽ� �ҷ������ִ�.
  - �ʿ��� ������ ���� ���̺� �л� �Ǿ� �ִ� ���
  - ���̺��� ��� �ڷḦ �������� �ʰ� Ư�� ����� �����ϴ� ���(����)
  
  (�������)
  CREATE [OR REPLACE] VIEW ���̸�[(�÷�list)] -- CREATE OR REPLACE �̷��� �׻� ��Ʈ��� �������� ������������ 
  AS                                         --�÷�list �信�� ����� �÷��� ->�Ⱦ���?  1.SELECT������ ���� �÷���Ī�� VIEW�� �÷��� 2.(��Ī�� ������) SELECT������ ���� �÷����� VIEW�� �÷���
    SELECT ��
    [WITH READ ONLY]    --�̰��� �信 ���� �ɼ�! �� �� �ϳ��� ��� ����.. 
    [WITH CHECK OPTION] --�̰��� �信 ���� �ɼ�! �� �� �ϳ��� ��� ����.. 
    
    . 'REPLACE' : �̹� �����ϴ� ���� ��� ��ü
    . 'WITH READ ONLY' : �б����� �� ���� --DML����� ����...//VIEW�� �����ص� �������̺��� ����X // �̰� �Ⱦ��� �信�� �����ϸ� �������̺����� ������(����)
    . 'WITH CHECK OPTION' : �並 �����ϴ� SELECT���� ������ �����ϴ� DML����� �信�� �����Ҷ� �����߻� --DML����� �ƿ� ����
    --EX)���ϸ���3000�̻�ȸ�� �������� VIEW�� ������µ� ���ϸ����� �Ἥ 500�� �� ȸ���� �信�� �����ž������� VIEW���� ���ŵ����ʰ���

��뿹) ȸ�����̺��� ���ϸ����� 3000�̻��� ȸ���� ȸ����ȣ,ȸ����,����,���ϸ����� ������ �並 �����Ͻÿ�.
       CREATE OR REPLACE VIEW V_MEM01 (MMID, MNAME, MJOB, MILE)--CREATE OR REPLACE ���� ���� �Ǵ� �̹� �����Ѵٸ� ��ġ�ϼ���(�������
       AS
        SELECT MEM_ID,      --���⼭����
               MEM_NAME,
               MEM_JOB,
               MEM_MILEAGE
          FROM MEMBER
         WHERE MEM_MILEAGE >= 3000      --������� ��������� ���̺��� VIEW V_MEM_01
��뿹)������ ��(V_MEM01)���� 'c001'ȸ���� ���ϸ����� 2500���� ���� --�ſ�ȯ
    UPDATE V_MEM01
       SET MILE=2500
     WHERE MMID='c001';    
   --  => �� ���� (����3000�̻�)�� �������� ���ؼ� �信�� �ſ�ȯ�� Ż����
   --  => �並 �����ߴµ� ������ ���� �������.
     
    SELECT MEM_ID,MEM_NAME,MEM_MILEAGE
      FROM MEMBER
     WHERE MEM_ID='g001';  --�۰��� ���� 800
     
    UPDATE MEMBER
       SET MEM_MILEAGE=3800
     WHERE MEM_ID='g001';  --�۰����� ���� 3800���� ����   

    SELECT * FROM V_MEM01;  --�۰��� �� V_MEM01�� ���� �߰�����    

��뿹) ȸ�����̺��� ���ϸ����� 3000�̻��� ȸ���� ȸ����ȣ,ȸ����,����,���ϸ����� ������ �並 �б��������� �����Ͻÿ�. 
       CREATE OR REPLACE VIEW V_MEM01 (MMID, MNAME, MJOB, MILE)--CREATE OR REPLACE ���� ���� �Ǵ� �̹� �����Ѵٸ� ��ġ�ϼ���(�������
       AS
        SELECT MEM_ID,      
               MEM_NAME,
               MEM_JOB,
               MEM_MILEAGE
          FROM MEMBER
         WHERE MEM_MILEAGE >= 3000
         WITH READ ONLY; --�並 READ ONLY��

    SELECT * FROM V_MEM01;         

��뿹)������ ��(V_MEM01)���� 'g001'ȸ���� ���ϸ����� 800���� ���� --�۰��� ���� ���� 3800
    UPDATE V_MEM01  --VIEW����
       SET MILE=800
     WHERE MMID='g001'; 
   --  ==> READ ONLY������ ������
   
    UPDATE MEMBER   --�������̺����
       SET MEM_MILEAGE=800
     WHERE MEM_ID='g001';    
    -- ==>1�������Ʈ
        ==>VIEW������ �۰��� �����
        
��뿹) ȸ�����̺��� ���ϸ����� 3000�̻��� ȸ���� ȸ����ȣ,ȸ����,����,���ϸ����� ������ �並 WITH CHECK OPTION���� �����Ͻÿ�. 
       CREATE OR REPLACE VIEW V_MEM01 (MMID, MNAME, MJOB, MILE)--CREATE OR REPLACE ���� ���� �Ǵ� �̹� �����Ѵٸ� ��ġ�ϼ���(�������
       AS
        SELECT MEM_ID,      
               MEM_NAME,
               MEM_JOB,
               MEM_MILEAGE
          FROM MEMBER
         WHERE MEM_MILEAGE >= 3000
         WITH CHECK OPTION; --�並 WITH CHECK OPTION��        

��뿹) ������ �信�� ������ȸ��(e001)�� ���ϸ����� 2500���� ����   --���� 6500
    UPDATE V_MEM01
       SET MILE=2500
     WHERE MMID='e001';
   --  ==> WITH CHECK OPTION������ ������ (���� WHERE�� ����3000�̻�� ����Ǵ� �����̶�)     

��뿹) �ſ�ȯ ȸ��('c001')���ϸ����� MEMBER���̺��� 3500���� ���� 
    UPDATE MEMBER
       SET MEM_MILEAGE=3500
     WHERE MEM_ID='c001';
  -- ==>�������̺��� ������ ���氡�� 
  
��뿹) ��ö�� ȸ��('k001')���ϸ����� �信�� 4700���� ���� 
    UPDATE V_MEM01
       SET MILE=4700
     WHERE MMID='k001';
  -- ==>1�� ������Ʈ ���� (���� WHERE�� ����3000�̻� ���ǿ� ������� ����)
  
  --���� V_MEM01���� 7���� ȸ���� ����
    UPDATE MEMBER
       SET MEM_MILEAGE=2500
     WHERE MEM_ID='k001';
  -- ==>1�� ������Ʈ ����
  --V_MEM01���� 6���� ȸ���� ����     