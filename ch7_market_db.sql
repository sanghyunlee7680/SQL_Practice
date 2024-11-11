create database ch7_market_db;
use ch7_market_db;

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

-- 7장 스토어드 프로시저 
-- 스토어드 프로시저 생성
drop procedure if exists user_proc;
delimiter $$
create procedure user_proc()
begin
	select * from member;
end $$
delimiter ; 
call user_proc();

-- 입력 매개변수의 활용
drop procedure if exists user_proc1;
delimiter $$
create procedure user_proc1(in userName varchar(10))
begin
	select * from member 
		where mem_name = userName;
end $$
delimiter ;
call user_proc('에이핑크');

-- 파라미터가 2개일 때
drop procedure if exists user_proc2;
delimiter $$
create procedure user_proc2(in userNumber int, in userHeight int)
begin
	select * from member
		where mem_number > userNumber AND height > userHeight;
end $$
delimiter ;
call user_proc2(6, 165);
select * from member;

-- 출력 매개변수 활용
drop table if exists noTable;
create table noTable
(
	id int auto_increment primary key,
    txt char(10)
)default charset=utf8;

drop procedure if exists user_proc3;
delimiter $$
create procedure user_proc3( in txtValue char(10), out outValue int )
begin
	insert into noTable values(null, txtValue);
    select MAX(id) into outValue from noTable;
end $$
delimiter ;

call user_proc3 ('테스트', @myValue);
select concat('입력된 ID 값 ==>', @myValue);

-- 활용
drop procedure if exists ifelse_proc;
delimiter $$
create procedure ifelse_proc( IN memName varchar(10) )
begin
	declare debutYear int;
    select year(debut_date) into debutYear from member
		where mem_name = memName;
	if ( debutYear >= 2015) then
		select '신인 가수네요. 화이팅 하세요.' AS '메시지';
	else
		select '고참 가수네요. 그동안 수고하셨어요.' AS '메시지';
    end if;
end$$
delimiter ;
call ifelse_proc('오마이걸');

-- 동적 SQL
drop procedure if exists dynamic_proc;
delimiter $$
create procedure dynamic_proc( in tableName varchar(20) )
begin
	SET @sqlQuery = concat('select * from ', tableName);
    prepare myQuery from @sqlQuery;
    execute myQuery;
end $$
delimiter ;
call dynamic_proc('member');

-- 7-2 스토어드 함수
-- 함수의 생성 권환 설정 // SQL은 백그라운드 프로그램이기 때문에 파일을 수정해서 설정을 바꿔야한다.
-- 한 번 설정하면 설정 변경 전까지 바뀌지 앟음 1 true / 0 false
set global log_bin_trust_function_creators = 1;

delimiter $$
create function sumFunc(number1 int, number2 int)
	returns int
begin
	return number1 + number2;
end $$
delimiter ;

select sumFunc(100, 200) AS '합계';

delimiter $$
create function calcYearFunc(dYear int)
	returns int
begin
	declare actYear int;
    set actYear = year(curdate()) - dYear;
    return actYear;
end $$
delimiter ;

select calcYearFunc(2010) as '활동 햇수';

-- 함수의 반환 값을 변수에 담고 출력하기 ( 연산 ) select ~ into ~
select calcYearFunc(2007) into @debut2007;
select calcYearFunc(2013) into @debut2013;
select @debut2007 - @debut2013 as '2007과 2013 활동 햇수 차이';

select mem_id, mem_name, calcYearFunc(YEAR(debut_date)) AS '활동 햇수'
	from member;
    
show create function calcYearFunc;

use ch7_market_db;
drop procedure cursor_proc;
delimiter $$
create procedure cursor_proc()
begin
	-- 변수 선언 및 초기화
	declare memNumber int;
    declare cnt int default 0;
    declare totNumber int default 0;
    declare endOfRow boolean default false;  -- 행의 끝을 파악 // 처음에는 행의 끝이 아니기때문에 false 초기화

	-- 반복
    declare memberCursor cursor for 
		select mem_number from member;
	-- 마지막 줄에서 변수애 true 대입, 마지막 줄이면 동작 중지
	declare continue handler 
		for not found set endOfRow = true;
	
    open memberCursor;
    
    cursor_loop: loop
		fetch memberCursor into memNumber;
    
    		if endOfRow then  -- 마지막 줄 인지 아닌지, 마지막 줄이면 반복 중지
			leave cursor_loop;
		end if;
		
		set cnt = cnt + 1; -- 반복횟수
		set totNumber = totNumber + memNumber; -- 누적
		
	end loop cursor_loop;
		
	select (totNumber/cnt) as '회원의 평균 인원 수'; -- 출력

    
    close memberCursor; -- 종료
end $$
delimiter ;
call cursor_proc();


-- 트리거
use ch7_market_db;
create table if not exists trigger_table 
( 
	id int,
    txt varchar(10)
)default charset=utf8;

insert into trigger_table values(1, '레드벨벳');
insert into trigger_table values(2, '잇지');
insert into trigger_table values(3, '블랙핑크');

delimiter $$
create trigger myTrigger
	after delete
    on trigger_table
    for each row
begin
	set @msg = '가수 그룹이 삭제됨' ; -- 트리거 실행 시 작동되는 코드들
end $$
delimiter ;

set @msg = '';
insert into trigger_table values(4, '마마무');
select @msg;
update trigger_table set txt = '블핑' where id = 3;
select @msg;
delete from trigger_table where id = 4;
select @msg;

create table singer
(
	select mem_id, mem_name, mem_number, addr
	from member
);

create table backup_singer
(
	mem_id char(8) not null,
    mem_name varchar(10) not null,
    mem_number int not null,
    addr char(2) not null,
    modType char(2), -- 변경된 타입. '수정'  또는 '삭제'
    modDate DATE, -- 변경된 날짜
    modUser Varchar(30) -- 변경한 사용자
)default charset=utf8;

delimiter $$
create trigger singer_updateTrg
	after update
    on singer
    for each row
begin
	insert into backup_singer values( old.mem_id, old.mem_name,
		old.mem_number, old.addr, '수정', curdate(), current_user() );
end $$
delimiter ;

delimiter $$
create trigger singer_deleteTrg
	after delete
    on singer
    for each row
begin
	insert into backup_singer values( old.mem_id, old.mem_name,
		old.mem_number, old.addr, '삭제', curdate(), current_user() );
end $$
delimiter ;

update singer SET addr = '영국' where mem_id = 'BLK';
delete from singer where mem_number >= 7;

select * from backup_singer;