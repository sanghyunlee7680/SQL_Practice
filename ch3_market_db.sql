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

-- 변수 사용
set @myvar1 = 5;
set @myvar2 = 4.25;

select @myvar1;
select (@myvar1  + @myvar2)  '변수1+변수2' ;

set @txt ='기수 이름==> ';
set @height = 166;
select @txt, mem_name from member where height > @height; 

-- prepare execute
set @count=3;
prepare mySQL from 'select mem_name, height from member order by height limit ?';
execute mySQL using @count;

-- 데이터 형 변환
select cast(avg(price) as signed) '평균 가격' 
	from buy;
-- 또는
select convert(avg(price), signed) '평균 가격'
	from buy;
    
select cast('2022$12$12' as date);
select cast('2022/12/12' as date);
select convert('2022%12%12', date);
select convert('2022@12@12', date);

select num, concat(cast(price as char), 'X', cast(amount as char), '=') '가격 = 수량', price*amount '구매액'
	from buy;
    
-- 자동 형변환 concat() 문자를 합쳐주는 기능
select 100 + '200';
select concat(100,200);
select concat('100','200');
select '100' + '200';

-- join() 내부join
select * from buy   -- select * from member;
	inner join member
	on buy.mem_id = member.mem_id;
select * from buy;
select * from member;

-- 내부join 간결한 표현 
select buy.mem_id, mem_name, prod_name, addr, concat(phone1, phone2) '연락처'
	from buy
	inner join member
    on buy.mem_id = member.mem_id;
-- 또는 모든 컬럼 미리 구분해놓기
select buy.mem_id, member.mem_name, buy.prod_name, member.addr, concat(member.phone1, member.phone2) '연락처'
	from buy
	inner join member
    on buy.mem_id = member.mem_id;
-- 내부 join 간결표현 중 테이블 별칭 붙이기 및 정렬하기
select b.mem_id, m.mem_name, b.prod_name, m.addr, concat(m.phone1, m.phone2) '연락처'
	from buy b
    inner join member m
    on b.mem_id = m.mem_id
    order by mem_id;
-- 내부 join 중복된 결과 1개만 출력하기
select distinct m.mem_id, m.mem_name, m.addr
	from buy b
    inner join member m
    on b.mem_id = m.mem_id
    order by mem_id;
-- 외부 join     
select m.mem_id, m.mem_name, b.prod_name, m.addr
	from member m -- left table
		left outer join buy b  -- right table
		on m.mem_id = b.mem_id
    order by m.mem_id;
    
select m.mem_id, m.mem_name, b.prod_name, m.addr
	from member m -- left table
		right outer join buy b  -- right table
		on m.mem_id = b.mem_id
    order by m.mem_id;
    
create table emp_table
( emp char(4),
  manager char(4),
  phone varchar(8)
)default charset=utf8;

insert into emp_table values('대표',null,'0000');
insert into emp_table values('영업이사','대표','1111');
insert into emp_table values('관리이사','대표','2222');
insert into emp_table values('정보이사','대표','3333');
insert into emp_table values('영업과장','영업이사','1111-1');
insert into emp_table values('경리부장','관리이사','2222-1');
insert into emp_table values('인사부장','관리이사','2222-2');
insert into emp_table values('개발팀장','정보이사','3333-1');
insert into emp_table values('개발주임','정보이사','3333-1-1');

select a.emp '직원', b.emp '직속상관', b.phone '직속상관연락처'
	from emp_table a
		inner join emp_table b
        on a.manager = b.emp
	where a.emp = '경리부장';
    
DELIMITER $$
create procedure ifproc3()
BEGIN
	-- 변수 선언
	DECLARE debutDate DATE; -- 데뷔 일자
    DECLARE curDate DATE; -- 현재 일자
    DECLARE days INT; -- 활동한 일수
    
    -- 변수 초기화
    SELECT debut_date INTO debutDate
		FROM market_db.member
        WHERE mem_id = 'APN';
	SET curDate = CURRENT_DATE(); -- 현재 날짜, 라이브러리
    SET days = DATEDIFF(curDate, debutDate); -- 날짜의 차이, 일 단위, 라이브러리
    
    -- 조건제어 if
    IF (days / 365) >= 5 THEN
		SELECT concat('데뷔한 지' , days , '일이 지났습니다. 핑순이들 축하합니다!');
	ELSE
		SELECT '데뷔한 지' + days + '일 되었습니다. 핑순이들 화이팅~';
	END IF;
END $$
DELIMITER ;

call ifproc3();

select m.mem_id, m.mem_name, sum(price*amount) '총구매액',
	case
		when(sum(price*amount) >= 1500) then '최우수고객'
		when(sum(price*amount) >= 1000) then '우수고객'
		when(sum(price*amount) >= 1 ) then '일반고객'
		else '유령고객'
	end "회원등급"
	from buy b
 		right outer join member m
        on b.mem_id = m.mem_id
    group by m.mem_id
    order by sum(price*amount) DESC;

drop procedure if exists whileproc;
delimiter $$
create procedure whileproc()
begin
	declare i INT; -- 1에서 100까지 증가할 변수
    declare hap INT; -- 더한 값을 누적할 변수
    set i = 1;
    set hap = 0;
    
    while(i<=100) do
		set hap = hap + i; -- 값 누적         
        set i = i+1; -- i++ 
	end while;
		select '1부터 100까지의 합 ==>', hap;
end $$
delimiter ;
call whileproc();

drop procedure if exists whileproc2;
delimiter $$
create procedure whileproc2()
begin
	declare i INT;
    declare hap INT;
    set i = 1;
    set hap = 0;
    
    mywhile:
    while(i<=100) do
		if(i%4=0) then
			set i = i+1;
            iterate mywhile;
		end if;
        set hap = hap + i;
        if (hap>1000) then
			leave mywhile;
		end if;
        set i = i+1;
    end while;
    select '1부터 100까지의 합(4의 배수 제왜ㅣ), 1000 넘으면 종료 ==>', hap;
end $$
delimiter ;
call whileproc2();

drop table if exists gate_table;
create table gate_table
(
	id int auto_increment primary key,
    entry_time datetime
)default charset=utf8;

set @curdate = current_date();

prepare myQuery from 'insert into gate_table values(null,?)';
execute myQuery using @curdate;
deallocate prepare myQuery; 