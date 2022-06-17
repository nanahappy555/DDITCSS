2022-0512-02) 
1.�������� �� ���� �ο�
CREATE USER LHR1 IDENTIFIED BY java;

GRANT CONNECT,RESOURCE,DBA TO LHR1;

2. ERD�𵨸�

3. DDL ���� copy&paste
4.����
/* ��ǰ */
CREATE TABLE tbl_good (
	good_id char(5) NOT NULL, /* ��ǰ�ڵ� */
	good_name VARCHAR2(30), /* ��ǰ�� */
	good_price  number(8) DEFAULT 0 /* ���� */
);

ALTER TABLE tbl_good
	ADD
		CONSTRAINT PK_tbl_good
		PRIMARY KEY (
			good_id
		);

/* �� */
CREATE TABLE customer (
	CID CHAR(4) NOT NULL, /* ����ȣ */
	CNAME VARCHAR2(30), /* ���� */
	CADDRESS VARCHAR2(100) /* �ּ� */
);

ALTER TABLE customer
	ADD
		CONSTRAINT PK_customer
		PRIMARY KEY (
			CID
		);

/* ���� */
CREATE TABLE tbl_order (
	ordernum NUMBER(11) NOT NULL, /* ���Ź�ȣ */
	odate DATE, /* ��¥ */
	amount NUMBER(9) DEFAULT 0, /* �ݾ� */
	CID CHAR(4) /* ����ȣ */
);

ALTER TABLE tbl_order
	ADD
		CONSTRAINT PK_tbl_order
		PRIMARY KEY (
			ordernum
		);

/* ���Ż�ǰ */
CREATE TABLE order_good (
	good_id char(5) NOT NULL, /* ��ǰ�ڵ� */
	ordernum NUMBER(11) NOT NULL, /* ���Ź�ȣ */
	order_qty NUMBER(5) DEFAULT 0 /* ���� */
);

ALTER TABLE order_good
	ADD
		CONSTRAINT PK_order_good
		PRIMARY KEY (
			good_id,
			ordernum
		);

ALTER TABLE tbl_order
	ADD
		CONSTRAINT FK_customer_TO_tbl_order
		FOREIGN KEY (
			CID
		)
		REFERENCES customer (
			CID
		);

ALTER TABLE order_good
	ADD
		CONSTRAINT FK_tbl_good_TO_order_good
		FOREIGN KEY (
			good_id
		)
		REFERENCES tbl_good (
			good_id
		);

ALTER TABLE order_good
	ADD
		CONSTRAINT FK_tbl_order_TO_order_good
		FOREIGN KEY (
			ordernum
		)
		REFERENCES tbl_order (
			ordernum
		);