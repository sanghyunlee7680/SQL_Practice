drop database if exists naver_db;
create database naver_db;
use naver_db;

drop table if exists member;
create table member
(
	mem_id varchar(10) primary key,
    name varchar(10) not null,
    no int not null,
    addr char(10) not null,
    tel1 varchar(10),
    tel2 varchar(20),
    height tinyint unsigned,
	debut date
)default charset=utf8;

drop table if exists buy;
create table buy
(
	num int auto_increment primary key,
    mem_id varchar(10) not null ,
    product varchar(10) not null,
    category varchar(10),
    price int not null,
    amount int not null,
    foreign key (mem_id) references member(mem_id)
    on update cascade
    on delete cascade
)default charset=utf8;

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

-- 테이블 생성에서 설정하는 기본 키 제약조건
drop table if exists buy, member;
create table member
(
	mem_id char(8) not null primary key,
    mem_name varchar(10) not null,
    height int
)default charset=utf8;

-- 기존테이블에 제약조건 추가하기
drop table if exists buy, member;
create table member
(
	mem_id char(8),
    mem_name varchar(10) not null,
    height int
)default charset=utf8;

alter table member
	add constraint
	primary key (mem_id);

-- 기본 키에 이름 지정하기    
drop table if exists buy, member;
create table member
(
	mem_id char(8) ,
    mem_name varchar(10) not null,
    height int,
    constraint primary key pk_member_mem_id (mem_id)
)default charset=utf8;

-- 테이블 생성에서 설정하는 외래 키 제약 조건
drop table if exists buy, member;
create table member
(
	mem_id char(8) not null primary key,
    mem_name varchar(10) not null,
    height int
)default charset=utf8;
create table buy
(
	num int auto_increment primary key,
    mem_id char(8) not null,
    prod_name char(6) not null,
    foreign key (mem_id) references member (mem_id)
)default charset=utf8;

-- 테이블 수정할 때 설정하는 왜래 키 제약조건
drop table if exists buy;
create table buy
(
	num int auto_increment primary key,
    mem_id char(8) not null,
    prod_name char(6) not null
)default charset=utf8;
alter table buy
	add constraint fk_mem_id -- 생략가능
    foreign key (mem_id)
    references member(mem_id);

-- 기준 테이블(PK)의 열이 변경될 경우 
drop table if exists buy;
create table buy
(
	num int auto_increment primary key,
    mem_id char(8) not null,
    prod_name char(6) not null
)default charset=utf8;
alter table buy
	add constraint 
    foreign key (mem_id)
    references member(mem_id)
    on update cascade
    on delete cascade;

select * from member;
update member set mem_id = 'pink' where mem_id='blk';

-- 고유 키(Unique) 제약조건
drop table if exists buy, member;
create table member
(
	mem_id char(8) primary key,
    mem_name varchar(20) not null,
    height int,
    email char(30) unique
)default charset=utf8;

insert into member values('BLK', '블랙핑크', 163, 'pink@gmail.com');
insert into member values('TWC', '트와이스', 167, NULL);
insert into member values('APN', '에이핑크', 164, 'black@gmail.com');

-- 체크 check() 제약조건
drop table if exists member;
create table memeber
(
	mem_id char(8) primary key,
    mem_name varchar(10) not null,
    height int,
	phone1 char(3),
    check(height >= 100)
)default charset=utf8;

-- 같은 표현
drop table if exists member;
create table member
(
	mem_id char(8) primary key,
    mem_name varchar(10) not null,
    height int check(height >= 100),
	phone1 char(3)
)default charset=utf8;
insert into member values('BLK', '블랙핑크', 163, NULL);
insert into member values('TWC', '트와이스', 99, NULL);


-- 테이블 생성할 때 체크를 이용한 여러 값 중 하나만 입력되게 하는방법 
drop table if exists member;
create table memeber
(
	mem_id char(8) primary key,
    mem_name varchar(10) not null,
    height int,
	phone1 char(3),
    check (phone1 in('02', '031', '032', '054', '055', '061'))
)default charset=utf8;
-- 테이블 수정할 때 체크를 이용한 여러 값 중 하나만 입력되게 하는방법 
drop table if exists member;
create table member
(
	mem_id char(8) primary key,
    mem_name varchar(10) not null,
    height int,
	phone1 char(3)
)default charset=utf8;
alter table member
	add constraint
    check (phone1 in('02', '031', '032', '054', '055', '061'));
insert into member values('TWC', '트와이스', 167, '02');
insert into member values('OMY', '오마이걸', 167, '010');
insert into member values('GID', '여자아이들', 169, '033');
select * from member;

-- 기본값 정의 
drop table if exists member;
create table member
(
	mem_id char(8) primary key,
    mem_name varchar(10) not null,
    height int null default 160,
	phone1 char(3)
)default charset=utf8;
-- 테이블 수정 시 기본 값 지정
drop table if exists member;
create table member
(
	mem_id char(8) primary key,
    mem_name varchar(10) not null,
    height int null default 160,
	phone1 char(3)
)default charset=utf8;
alter table member
	alter column phone1 set default '02';
insert into member values('RED', '레드벨벳', 161, '054');
insert into member values('SPC', '우주소녀', default, default);
insert into member values('BLK', '블랙핑크');
select * from member;