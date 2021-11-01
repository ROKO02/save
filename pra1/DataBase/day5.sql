/*
    in: 데이터를 포함하고 있는 레코드를 출력
    예) in (10, 20, 30) -> column의 데이터가 10 또는 20 또는 30인 레코드를 선택
*/
select * from TB_MEMBER;

select MEM_USERID, MEM_NAME, MEM_GENDER, MEM_POINT from TB_MEMBER where MEM_POINT in(0, 150, 200);

select MEM_USERID, MEM_NAME, MEM_GENDER, MEM_POINT from TB_MEMBER where MEM_POINT = 100 or MEM_POINT = 150;

/*
    like: 해당 문자열을 포함하고 있는 레코드를 선택
    예) like '김%' => '김'으로 시작하는 데이터의 모든 레코드를 모두 선택
    예) like '%김' => '김'으로 끝나는 ~~
    예) like '%김%' => '김'이 포함된 ~~
*/

select MEM_USERID, MEM_NAME, MEM_GENDER from TB_MEMBER where MEM_NAME like '김%';

select MEM_USERID, MEM_NAME, MEM_GENDER from TB_MEMBER where MEM_USERID like '%e%';

select MEM_USERID, MEM_NAME, MEM_GENDER from TB_MEMBER where MEM_USERID like '%a%';

/*
    between a and b : a 이상이고 b 이하인 레코드를 선택
    예) MEM_POINT between 100 and 300 => 포인트 점수가 100이상 300이하인 레코드 선택 
*/

select MEM_USERID, MEM_NAME, MEM_GENDER, MEM_POINT from TB_MEMBER where MEM_POINT between 100 and 300;

/*
    || : 문자열 연결
*/
select mem_userid, mem_name, mem_gender from tb_member;
select mem_userid, 'mem_weight' from tb_member;
select mem_userid as "아이디", mem_userpw as "비밀번호" from tb_member;
select 'id : ' || mem_userid as "아이디", 'password : ' || mem_userpw as "비밀번호" from tb_member;

/*
    distinct : 중복 값을 없앤 레코드를 선택
*/
select distinct mem_gender from tb_member;

/*
    group by(그룹)
    예) select 그룹을 맺은 컬럼명 또는 집계함수 from 테이블명 [where 조건] group by 그룹을 맺을 컬럼명 
    having 조건 order by 컬럼명
    집계함수 : count(), sum(), avg(), max(), min()
*/
select * from tb_member;
select mem_gender from tb_member group by mem_gender;
select mem_gender, mem_userid from tb_member group by mem_gender; -> not a GROUP BY expression
select mem_gender, count(mem_userid) from tb_member group by mem_gender; -- null이 포함되어 있지 않음
select mem_gender, count(mem_regdate) from tb_member group by mem_gender; -- null이 포함되어 있음
select mem_gender, count(mem_userid), sum(mem_point), avg(mem_point), max(mem_point), min(mem_point)
from tb_member group by mem_gender;

select mem_gender, count(mem_userid), sum(mem_point), avg(mem_point), max(mem_point), min(mem_point)
from tb_member where mem_regdate is not null group by mem_gender;

select mem_gender, count(mem_userid), sum(mem_point), avg(mem_point), max(mem_point), min(mem_point)
from tb_member where mem_regdate is not null group by mem_gender having count(mem_userid) > 1;

/*
    주문 테이블 만들기
*/
create table tb_order (
    ord_no varchar2(10),
    ord_userid varchar2(20),
    ord_product varchar2(50) not null,
    ord_count number(3),
    ord_price number(10),
    ord_regdate date default sysdate,
    constraint pk_order_no primary key(ord_no),
    constraint fk_mem_userid foreign key(ord_userid) references tb_member(mem_userid)
);
select * from tb_member;
select * from tb_order;

-- 무결성 제약조건(ADMIN.FK_MEM_USERID)이 위배되었습니다- 부모 키가 없습니다
INSERT INTO tb_order (ord_no, ord_userid, ord_product, ord_count, ord_price) 
VALUES ('1000000001', 'avocado', '맥북프로', 1, 2500000);

INSERT INTO tb_order (ord_no, ord_userid, ord_product, ord_count, ord_price) 
VALUES ('1000000001', 'apple', '맥북프로', 1, 2500000);

INSERT INTO tb_order (ord_no, ord_userid, ord_product, ord_count, ord_price) 
VALUES ('1000000002', 'banana', '청소기', 1, 300000);

INSERT INTO tb_order (ord_no, ord_userid, ord_product, ord_count, ord_price) 
VALUES ('1000000003', 'orange', '세탁기', 1, 1000000);

INSERT INTO tb_order (ord_no, ord_userid, ord_product, ord_count, ord_price) 
VALUES ('1000000004', 'banana', '모니터', 1, 600000);
select * from tb_order;

-- 아이디, 이름, 성별, 제품, 가격, 날짜

/*
    조인(join)
    - 각 테이블간에 공통된 컬럼(조건)으로 데이터를 합쳐 표현
    - select 컬럼명1, 컬럼명2, ... from 테이블명1 (left, right) join 테이블명2 
    on 테이블명1.컬럼명 = 테이블2.컬럼명
    
    inner join(교집합), left join(테이블1 기준), right join(테이블2 기준)
*/
-- inner join
select mem_userid, mem_name, mem_gender, ord_product, ord_price, ord_regdate from tb_member join
tb_order on tb_member.mem_userid = tb_order.ord_userid;

select mem.mem_userid, mem.mem_name, mem.mem_gender, ord.ord_product, ord.ord_price, ord.ord_regdate 
from tb_member mem join tb_order ord on mem.mem_userid = ord.ord_userid;

-- left join
select mem_userid, mem_name, mem_gender, ord_product, ord_price, ord_regdate from tb_member left join
tb_order on tb_member.mem_userid = tb_order.ord_userid;

-- right join
select mem_userid, mem_name, mem_gender, ord_product, ord_price, ord_regdate from tb_member right join
tb_order on tb_member.mem_userid = tb_order.ord_userid;


/*
    오라클 내장 함수
    instr(문자열, 검색 할 문자, [시작지점, n번째 검색단어])
    - 찾는 문자의 위치를 반환 시켜주는 함수
    - 찾는 문자가 없으면 0을 반환
    - 찾는 단어 앞글자의 인덱스를 변환
*/
select instr('Hello Orcale', 'O') as instr from dual; -- 7
select instr('Hello Orcale', 'OX') as instr from dual; -- 0
select instr('Hello Oracle', 'Ora') as instr from dual; -- 7
select instr('Hello Orcale', 'l') as instr from dual; -- 3
select instr('Hello Orcale', 'l',5) as instr from dual; -- 11
select instr('Hello Orcale', 'l', 1, 3) as instr from dual; -- 11
select instr('Hello Orcale', 'l', -1, 3) as instr from dual; -- 3

