create database hard_practice;
use hard_practice;

drop table if exists usertable;
create table usertable 
(
	user_id varchar(20) primary key,
    user_name varchar(10) not null,
    user_age int,
    user_grade varchar(10) not null,
    user_money int default 0
)default charset=utf8;

drop table if exists prodtable;
create table prodtable
(
	prod_num varchar(3) primary key,
    prod_name varchar(20),
    prod_thing int,
    prod_made varchar(20),
    check ( prod_thing >= 0 and prod_thing <= 10000)
)default charset=utf8;

drop table if exists ordertable;
create table ordertable
(
	order_num varchar(3) primary key,
    user_id varchar(20),
    prod_num varchar(3),
    order_quantity int,
    order_delivery varchar(30),
    order_date date,
    foreign key (user_id) references usertable(user_id),
    foreign key (prod_num) references prodtable(prod_num)
)default charset=utf8;

drop table if exists delicompany;
create table delicompany
(
	com_num varchar(3) primary key,
    com_name varchar(10),
    com_addr varchar(30),
    com_phone1 char(3),
    com_phone2 char(8)
)default charset=utf8;

-- 테이블 수정 
-- 컬럼 추가
alter table usertable add joindate date;
-- 컬럼 삭제
alter table usertable drop column joindate;
-- 컬럼 제약 조건 추가
alter table usertable add constraint chk_age check(user_age>=20);
-- 컬럼 제약 조건 삭제
alter table usertable drop constraint chk_age;