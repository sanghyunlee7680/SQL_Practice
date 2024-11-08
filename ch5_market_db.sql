DROP DATABASE IF EXISTS market_db; -- 만약 market_db가 존재하면 우선 삭제한다.
CREATE DATABASE market_db;

USE market_db;
CREATE TABLE member -- 회원 테이블
( mem_id  		CHAR(8) NOT NULL PRIMARY KEY, -- 사용자 아이디(PK)
  mem_name    	VARCHAR(10) NOT NULL, -- 이름
  mem_number    INT NOT NULL,  -- 인원수
  addr	  		CHAR(2) NOT NULL, -- 지역(경기,서울,경남 식으로 2글자만입력)
  phone1		CHAR(3), -- 연락처의 국번(02, 031, 055 등)
  phone2		CHAR(8), -- 연락처의 나머지 전화번호(하이픈제외)
  height    	SMALLINT,  -- 평균 키
  debut_date	DATE  -- 데뷔 일자
);
CREATE TABLE buy -- 구매 테이블
(  num 		INT AUTO_INCREMENT NOT NULL PRIMARY KEY, -- 순번(PK)
   mem_id  	CHAR(8) NOT NULL, -- 아이디(FK)
   prod_name 	CHAR(6) NOT NULL, --  제품이름
   group_name 	CHAR(4)  , -- 분류
   price     	INT  NOT NULL, -- 가격
   amount    	SMALLINT  NOT NULL, -- 수량
   FOREIGN KEY (mem_id) REFERENCES member(mem_id)
);

INSERT INTO member VALUES('TWC', '트와이스', 9, '서울', '02', '11111111', 167, '2015.10.19');
INSERT INTO member VALUES('BLK', '블랙핑크', 4, '경남', '055', '22222222', 163, '2016.08.08');
INSERT INTO member VALUES('WMN', '여자친구', 6, '경기', '031', '33333333', 166, '2015.01.15');
INSERT INTO member VALUES('OMY', '오마이걸', 7, '서울', NULL, NULL, 160, '2015.04.21');
INSERT INTO member VALUES('GRL', '소녀시대', 8, '서울', '02', '44444444', 168, '2007.08.02');
INSERT INTO member VALUES('ITZ', '잇지', 5, '경남', NULL, NULL, 167, '2019.02.12');
INSERT INTO member VALUES('RED', '레드벨벳', 4, '경북', '054', '55555555', 161, '2014.08.01');
INSERT INTO member VALUES('APN', '에이핑크', 6, '경기', '031', '77777777', 164, '2011.02.10');
INSERT INTO member VALUES('SPC', '우주소녀', 13, '서울', '02', '88888888', 162, '2016.02.25');
INSERT INTO member VALUES('MMU', '마마무', 4, '전남', '061', '99999999', 165, '2014.06.19');

INSERT INTO buy VALUES(NULL, 'BLK', '지갑', NULL, 30, 2);
INSERT INTO buy VALUES(NULL, 'BLK', '맥북프로', '디지털', 1000, 1);
INSERT INTO buy VALUES(NULL, 'APN', '아이폰', '디지털', 200, 1);
INSERT INTO buy VALUES(NULL, 'MMU', '아이폰', '디지털', 200, 5);
INSERT INTO buy VALUES(NULL, 'BLK', '청바지', '패션', 50, 3);
INSERT INTO buy VALUES(NULL, 'MMU', '에어팟', '디지털', 80, 10);
INSERT INTO buy VALUES(NULL, 'GRL', '혼공SQL', '서적', 15, 5);
INSERT INTO buy VALUES(NULL, 'APN', '혼공SQL', '서적', 15, 2);
INSERT INTO buy VALUES(NULL, 'APN', '청바지', '패션', 50, 1);
INSERT INTO buy VALUES(NULL, 'MMU', '지갑', NULL, 30, 1);
INSERT INTO buy VALUES(NULL, 'APN', '혼공SQL', '서적', 15, 1);
INSERT INTO buy VALUES(NULL, 'MMU', '지갑', NULL, 30, 4);

SELECT * FROM member;
SELECT * FROM buy;

-- 가상테이블 뷰 생성
create view v_member
as 
	select mem_id, mem_name, addr from member; -- 가상 테이블 생성 시 3개의 컬럼만 가져옴
select * from v_member;
select mem_name, addr from v_member
	where addr in ('서울', '경기');
 
 -- 복잡한 SQL을 단순하게 만들기
create view v_memberbuy
as
	select B.mem_id, M.mem_name, B.prod_name, M.addr,
					concat(M.phone1, M.phone2) '연락처'
				from buy B
					inner join member M
                    ON B.mem_id = M.mem_id;
select * from v_memberbuy;

-- 뷰의 생성
create view v_viewtest1
as
	select B.mem_id as Member_ID, M.mem_name AS Member_Name,
		B.prod_name 'product Name',
				concat(M.phone1, M.phone2) AS 'Office Phone'
		from buy B
			inner join member M
            on B.mem_id = M.mem_id;
select distinct Member_ID, Member_Name from v_viewtest1;

-- 뷰의 수정
alter view v_viewtest1
as
	select B.mem_id AS '회원 아이디', M.mem_name AS '회원 이름',
		B.prod_name '제품 이름',
			concat(M.phone1, M.phone2) AS '연락처'
		from buy B
			inner join member M
            on B.mem_id = M.mem_id;
select distinct `회원 아이디`, `회원 이름` from v_viewtest1;
-- 뷰의 삭제
drop view if exists v_viewtest1;

-- 뷰를 통한 데이터 수정
update v_member set addr = '부산' where mem_id='BLK';
select * from v_member;
insert into v_member(mem_id, mem_name, addr) values('BTS', '방탄소년단', '경기');

-- 뷰를 통한 데이터 삭제
create view v_height167
as
	select * from member where height >= 167;
select * from v_height167;
delete from v_height167 where height < 167;
-- 뷰를 통한 데이터 입력
insert into v_height167 values('TRA', '티아라', 6, '서울', NULL, NULL, 159, '2005-01-01');
select * from v_height167; 
select * from member; 
-- 뷰에 제약조건 예약어 with check option
alter view v_height167
as
	select * from member where height >= 167
			with check option ;
            
insert into v_height167 values('TOB', '텔레토비', 4, '영국', NULL, NULL, 140, '1995-01-01');

