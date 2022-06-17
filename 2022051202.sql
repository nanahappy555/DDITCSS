2022-0512-02) 
1.계정생성 및 권한 부여
CREATE USER LHR1 IDENTIFIED BY java;

GRANT CONNECT,RESOURCE,DBA TO LHR1;

2. ERD모델링

3. DDL 구문 copy&paste
4.실행
/* 상품 */
CREATE TABLE tbl_good (
	good_id char(5) NOT NULL, /* 상품코드 */
	good_name VARCHAR2(30), /* 상품명 */
	good_price  number(8) DEFAULT 0 /* 가격 */
);

ALTER TABLE tbl_good
	ADD
		CONSTRAINT PK_tbl_good
		PRIMARY KEY (
			good_id
		);

/* 고객 */
CREATE TABLE customer (
	CID CHAR(4) NOT NULL, /* 고객번호 */
	CNAME VARCHAR2(30), /* 고객명 */
	CADDRESS VARCHAR2(100) /* 주소 */
);

ALTER TABLE customer
	ADD
		CONSTRAINT PK_customer
		PRIMARY KEY (
			CID
		);

/* 구매 */
CREATE TABLE tbl_order (
	ordernum NUMBER(11) NOT NULL, /* 구매번호 */
	odate DATE, /* 날짜 */
	amount NUMBER(9) DEFAULT 0, /* 금액 */
	CID CHAR(4) /* 고객번호 */
);

ALTER TABLE tbl_order
	ADD
		CONSTRAINT PK_tbl_order
		PRIMARY KEY (
			ordernum
		);

/* 구매상품 */
CREATE TABLE order_good (
	good_id char(5) NOT NULL, /* 상품코드 */
	ordernum NUMBER(11) NOT NULL, /* 구매번호 */
	order_qty NUMBER(5) DEFAULT 0 /* 수량 */
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