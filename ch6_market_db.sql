-- --------------- 6장 ---------------------
drop table if exists market_db;
create database market_db;
use market_db;
-- 클러스터형 인덱스 PK
create table table1
(
	col1 int primary key,
    col2 int,
    col3 int
);

show index from table1;

-- 보조 인덱스
create table table2
(
	col1 int primary key,
    col2 int unique,
    col3 int unique
);
show index from tabl2;

create table member
(
	mem_id char(8),
    mem_name varchar(10),
    mem_number int,
    addr char(2)
)default charset=utf8;

INSERT INTO member VALUES('TWC', '트와이스', 9, '서울');
INSERT INTO member VALUES('BLK', '블랙핑크', 4, '경남');
INSERT INTO member VALUES('WMN', '여자친구', 6, '경기');
INSERT INTO member VALUES('OMY', '오마이걸', 7, '서울');

select * from member;

alter table member
	add constraint
    primary key(mem_id);
    
    
show table status like 'member';
show index from member;

-- 인덱스 생성
-- 단순 보조 인덱스
create index idx_member_addr
	on member (addr);
-- analyze table 문을 실행해줘야 실제로 적용된다.
analyze table member;

-- 고유 보조 인덱스 
create  unique index idx_member_mem_number
	on member (mem_num);
    
create unique index idx_member_mem_name
	on member (mem_name);
show index from member;

insert into member values('MOO', '마마무', 2, '태국', '001', '12341234', 155, '2020.10.10');

analyze table member;
show index from member;
select * from member;

select mem_id, mem_name, addr from member where mem_name = '에이핑크';

create index idx_member_mem_number
	on member (mem_number);
analyze table member;

select mem_name, mem_number
	from member
	where mem_number >= 7;
    
