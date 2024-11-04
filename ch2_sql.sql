-- DDL : 데이터베이스 생성하기 (Create)
create database shop_db;
use shop_db;

-- DDL : 데이터베이스 조회하기 (Read)
show databases;

-- DDL : 데이터베이스 수정하기 (Update)
ALTER SCHEMA `shop_db`  DEFAULT CHARACTER SET utf8  DEFAULT COLLATE utf8_unicode_ci ;

-- DDL : 데이터베이스 삭제하기 (Delete)
drop database db_shop;

-- DDL : 테이블 생성 (Create) 
create table member(
	member_id char(8) not null primary key,
    member_name varchar(5) not null,
    member_addr char(20)
);

-- 테이블 삭제
drop table member;

-- 테이블 읽어오기
desc member;

-- 테이블 수정하기


-- 제품 테이블 생성하기
create table product(
	product_name char(4) not null primary key,
    cost int not null,
    make_date date,
    company char(5),
    amount int not null
);