create table tb_member1(
    mem_idx number(9) unique not null,
    mem_userid varchar2(20) primary key,
    mem_userpw varchar2(20) not null,
    mem_name varchar2(20) not null,
    mem_hp varchar2(15) not null,
    mem_email varchar2(50),
    mem_hobby varchar2(50),
    mem_ssn1 char(6) not null,
    mem_ssn2 char(7) not null,
    mem_zipcode char(5) not null,
    mem_addr1 varchar2(100) not null,
    mem_addr2 varchar2(100),
    mem_addr3 varchar2(100),
    mem_regdate date default sysdate
);


select * from tb_member1;
alter table tb_member1 add(
    mem_gender varchar2(6)
);

select * from tb_member1;

alter table tb_member modify(
    mem_gender varchar2(6) check(mem_gender in ('남자', '여자'))
);

INSERT INTO tb_member1 (mem_idx, mem_userid, mem_userpw, mem_name, mem_hp, mem_email, mem_hobby, mem_ssn1,
    mem_ssn2, mem_zipcode, mem_addr1, mem_addr2, mem_addr3, mem_regdate) 
    VALUES (1, 'apple', '1111', '김사과', '010-1111-1111', 'apple@apple.com', '드라이브',
    '001011', '4068518', '12345', '서울특별시', '서초구', '양제동', sysdate);

INSERT INTO tb_member1 (mem_idx, mem_userid, mem_userpw, mem_name, mem_hp, mem_ssn1, mem_ssn2, 
mem_zipcode, mem_addr1) 
    VALUES (2, 'banana', '2222', '반하나', '010-2222-2222', '001011', '4012345', '12345'
    ,'서울특별시');

INSERT INTO tb_member1 VALUES (3, 'orange', '3333', '오렌지', '010-3333-3333', 'orange@orange.com', '등산',
    '001011', '3068518', '12345', '서울특별시', '서초구', '반포동', sysdate);

INSERT INTO tb_member1 VALUES (4, 'melon', '4444', '이메론', '010-4444-4444', null, null,
    '001011', '3068518', '12345', '서울특별시', null, null, null);

alter table tb_member1 add(
    mem_gender varchar2(6) check(mem_gender in('남자', '여자'))
);

INSERT INTO tb_member1 VALUES (5, 'cherry', '5555', '김체리', '010-5555-5555', null, null,
    '001011', '4068518', '12345', '서울특별시', null, null, null, null);

INSERT INTO tb_member1 VALUES (6, 'watermelon', '6666', '박수박', '010-6666-6666', null, null,
    '001011', '3068518', '12345', '서울특별시', null, null, null, '남자');

select * from tb_member1;

update tb_member1 set mem_email='test@test.com', mem_hobby='퀵보드타기';

select * from tb_member1;

alter table tb_member1 add(
    mem_point number(7) default 0
);

select * from tb_member1;

update tb_member1 set mem_point = mem_point + 100;

select * from tb_member1;

update tb_member1 set mem_email='banana@banana.com', mem_hobby='영화감상' where mem_userid='banana';
update tb_member1 set mem_email='ryuzy@naver.com', mem_hobby='드라이브' where mem_addr1='서울특별시';

delete from tb_member1 where mem_userid='banana';
select * from tb_member1;

select mem_userid, mem_name, mem_hp from tb_member1;

select mem_userid, mem_name, mem_hp, mem_gender ,mem_point from tb_member1 order by mem_point desc;
select mem_userid, mem_name, mem_hp, mem_gender, mem_point from tb_member1 order by mem_point desc;
select mem_userid, mem_name, mem_hp, mem_gender, mem_point from tb_member1 order by mem_point;
select mem_idx, mem_userid, mem_name, mem_hp, mem_gender, mem_point from tb_member1 order by mem_point desc, mem_idx desc;

select mem_userid, mem_name, mem_gender, mem_point from tb_member1 where mem_point in (50, 150, 200);
select mem_userid, mem_name, mem_gender, mem_point from tb_member1 where mem_point = 100 or mem_point = 200;

select mem_userid, mem_name, mem_gender from tb_member1 where mem_name like '김%';
select mem_userid, mem_name, mem_gender from tb_member1 where mem_userid like'%e%';
select mem_userid, mem_name, mem_gender from tb_member1 where mem_userid like '%e';

select mem_userid, mem_name, mem_gender, mem_point from tb_member1 where mem_point between 100 and 300;

select mem_userid, mem_name, mem_gender from tb_member1;
select mem_userid, 'mem_weight' from tb_member1;
select mem_userid as "아이디", mem_userpw as "비밀번호" from tb_member1;
select 'id : ' || mem_userid as "아이디", 'password : ' || mem_userpw as "비밀번호" from tb_member1;

select distinct mem_gender from tb_member1;

select mem_gender from tb_member1 group by mem_gender;
select mem_gender, count(mem_userid) from tb_member1 group by mem_gender;
select mem_gender, count(mem_regdate) from tb_member1 group by mem_gender;
select mem_gender, count(mem_userid), sum(mem_point), avg(mem_point), max(mem_point), min(mem_point)
from tb_member1 group by mem_gender;

select mem_gender, count(mem_userid), sum(mem_point), avg(mem_point), max(mem_point), min(mem_point)
from tb_member1 where mem_regdate is not null group by mem_gender having count(mem_userid) > 1;

create table tb_order1(
    ord_no varchar2(10),
    ord_userid varchar2(20),
    ord_product varchar2(50) not null,
    ord_count number(3),
    ord_price number(10),
    ord_regdate date default sysdate,
    constraint pk_order_no1 primary key(ord_no),
    constraint fk_mem_userid1 foreign key(ord_userid) references tb_member1(mem_userid)
);

select * from tb_member1;
select * from tb_order1;

INSERT INTO tb_order1 (ord_no, ord_userid, ord_product, ord_count, ord_price) 
VALUES ('1000000001', 'apple', '맥북프로', 1, 2500000);

INSERT INTO tb_order1 (ord_no, ord_userid, ord_product, ord_count, ord_price) 
VALUES ('1000000002', 'banana', '청소기', 1, 3000000);

INSERT INTO tb_order1 (ord_no, ord_userid, ord_product, ord_count, ord_price) 
VALUES ('1000000003', 'orange', '세탁기', 1, 10000000);

INSERT INTO tb_order1 (ord_no, ord_userid, ord_product, ord_count, ord_price) 
VALUES ('1000000004', 'banana', '모니터', 1, 6000000);

select mem_userid, mem_name, mem_gender, ord_product, ord_price, ord_regdate from tb_member1 
join tb_order1 on tb_member1.mem_userid = tb_order1.ord_userid;

select * from tb_member1;
select mem_userid, mem_name, mem_hp, regexp_instr(mem_hp, '[[:digit:]]{4}') as regexp from tb_member1;

create table tb_example1(
    ex_str varchar2(100)
);

insert into tb_example1 values('abc123-abc-01');
insert into tb_example1 values('abb123-abc-02');
insert into tb_example1 values('acc123-abc-03');
insert into tb_example1 values('add123-abc-04');
insert into tb_example1 values('aee123-abc-05');
insert into tb_example1 values('aff123-abc-06');

select * from tb_example1;

select ex_str, regexp_instr(ex_str, 'bb', 1) from tb_example1;
select ex_str from tb_example1 where regexp_instr(ex_str, 'bb', 1) > 0;
select mem_userid, mem_name, mem_email, regexp_substr(mem_email, '[^@]+') as email_id from tb_member1;

select mem_userid, mem_name, concat(concat(mem_addr1, mem_addr2), mem_addr3) as addr from tb_member1;
select mem_userid, mem_name, concat(mem_addr1 || ' ', mem_addr2) as addr from tb_member1;

select mem_userid, mem_name, regexp_substr(mem_email, '[^@]+') || '@korea.com' as email from tb_member1; 
select mem_userid, mem_name, concat(regexp_substr(mem_email, '[^@]+'), '@korea.com') as email from tb_member1;

create table tb_sample1(
    sam_str varchar2(20)
);

insert into tb_sample1 values ('oracle');
insert into tb_sample1 values ('oracle   ');
insert into tb_sample1 values (' oracle');
insert into tb_sample1 values (' oracle  ');

select * from tb_sample1;
select '|'||sam_str||'|' from tb_sample1;
select '|'||trim(sam_str)||'|' from tb_sample1;
select '|'||ltrim(sam_str)||'|' from tb_sample1;
select '|'||rtrim(sam_str)||'|' from tb_sample1;

select * from tb_member1;
select mem_userid, mem_name, mem_gender,
    case mem_gender
    when '남자' then 'male'
    when '여자' then 'famale'
    else '모름'
    end as gender from tb_member1;

select lpad('abcdefghijklmn', 17, '...') from dual;
select rpad('abcdefghijklmn', 17, '...') from dual;
select length('abcdefghijklmn') from dual;

select mem_userid, mem_name, mem_email,
    case when length(mem_email) <= 15 then mem_email
    else rpad(regexp_substr(mem_email, 1, 15), 18, '...')
    end as email from tb_member1;
    
select mem_userid, mem_name, mem_gender, mem_regdate, extract(month from mem_regdate) as month from tb_member1;
select mem_userid, mem_name, mem_gender, mem_regdate, extract(year from mem_regdate) as year from tb_member1;

select ceil(10.6) from dual;
select ceil(-10.5) from dual;
select round(19.854, 1) from dual;
select round(19.854, 2) from dual;
select trunc(10.6) from dual;
select trunc(-10.5) from dual;
select trunc(-10.544, 2) from dual;

select mem_name, mem_gender, mem_regdate, extract(month from mem_regdate) as month,
    case mod(extract(month from mem_regdate), 2)
    when 0 then '짝수월'
    else '홀수월'
    end as mod_month from tb_member1;

select mem_userid, mem_name,
    case width_bucket(extract(month from mem_regdate), 1, 13, 2)
    when 1 then '상반기'
    else '하반기'
    end as half_year, mem_regdate from tb_member1;

select case
    width_bucket(extract(month from mem_regdate), 1, 13, 2)
    when 1 then '상반기'
    else '하반기'
    end as half_year, count(mem_idx) as count from tb_member1 where extract(year from mem_regdate) = 2021
    group by width_bucket(extract(month from mem_regdate), 1, 13, 2);


select mem_userid, mem_name, sysdate as today, mem_regdate, floor(months_between(sysdate, mem_regdate)) as month from tb_member1;

select mem_userid, mem_name, mem_regdate, to_char(mem_regdate, 'Q') as "분기" from tb_member1;

select to_char(mem_regdate, 'Q') as "분기", count(mem_idx) as "수" from tb_member1
where extract(year from mem_regdate) = 2021 group by to_char(mem_regdate, 'Q') order by "분기";

select mem_userid, mem_name, decode(mem_gender, '남자', 'male', '여자', 'female', '모름') as gender from tb_member1;

select mem_userid, mem_name, mem_point, rank() over(order by mem_point desc) as ranking from tb_member1;
select mem_userid, mem_name, mem_point, row_number() over(order by mem_point desc) as ranking from tb_member1;
select mem_userid, mem_name, mem_point, dense_rank() over(order by mem_point desc) as ranking from tb_member1;

select rownum, mem_userid, mem_name, mem_regdate from tb_member1 where rownum <= 3 order by mem_regdate desc;

create table TB_PROFILE1(
    PRO_USERID varchar2(20) not null,
    PRO_HEIGHT number(3),
    PRO_WEIGHT number(3),
    PRO_MBTI varchar2(10),
    PRO_BLOOD varchar2(2),
    PRO_ISLOVER char(1),
    constraint FK_PROFILE_USERID1 foreign key(PRO_USERID) references TB_MEMBER(MEM_USERID)
);
select * from tb_profile1;
select * from tb_member1;

insert into tb_profile1 values ('apple', 160, 50, 'ENFJ', 'O', 'N');
insert into tb_profile1 values ('orange', 155, 45, 'INTP', 'A', 'N');
insert into tb_profile1 values ('melon', 170, 70, 'ESFP', 'O', 'N');
insert into tb_profile1 values ('watermelon', 180, 80, 'ABCD','AB', 'N');

select * from tb_profile1;

select mem_userid, mem_name, mem_gender, pro_height, pro_blood, pro_islover from tb_member1
join tb_profile1 on tb_member1.mem_userid=tb_profile1.pro_userid;

select rank() over(order by mem_point desc) as ranking, mem_userid, mem_name, pro_blood, pro_mbti 
from tb_member1 join tb_profile1 on tb_member1.mem_userid=tb_profile1.pro_userid;

select mem_userid, mem_name, mem_point,
percent_rank() over(partition by mem_gender order by mem_point desc) * 100 as top from tb_member1;

create sequence seq_member_idx1
    increment by 1
    start with 7;
    
INSERT INTO tb_member1 ( mem_idx, mem_userid, mem_userpw, mem_name, mem_hp, mem_email,
    mem_hobby, mem_ssn1, mem_ssn2, mem_zipcode, mem_addr1, mem_addr2,
    mem_addr3, mem_gender, mem_point) 
    VALUES (seq_member_idx1.nextval, 'avocado', '7777', '안카도', '010-7777-7777', 'avocado@avocado.com', '영화감상',
    '001011', '3068518', '12345', '서울', '구로구', '구로동', '남자', 1000);

select * from tb_member1;


create table tb_point1(
    po_idx number(7) unique not null,
    po_userid varchar2(20) not null,
    po_memo varchar2(10) not null,
    po_point number(7) default 0,
    po_ordno varchar2(10) unique not null,
    po_regdate date default sysdate,
    constraint fk_point_userid1 foreign key(po_userid) references tb_member(mem_userid),
    constraint fk_point_ordno1 foreign key(po_ordno) references tb_order(ord_no)
);

create sequence seq_point1
    increment by 1
    start with 1;
    
insert into tb_point1(po_idx, po_userid, po_memo, po_point, po_ordno) values
(seq_point1.nextval, 'apple', '구입', 1000, '1000000001');

select * from tb_point1;
select * from tb_order1;

insert into tb_point1(po_idx, po_userid, po_memo, po_point, po_ordno)
values(seq_point1.nextval, 'banana', '구입', 
0.05 * (select ord_price from tb_order1 where ord_no = '1000000004'), '1000000004');

select ord_userid, ord_regdate from tb_order1;
union
select ord_userid, ord_regdate from tb_order1 where ord_price >= 10000000;

select ord_userid, ord_regdate from tb_order1;
union all
select ord_userid, ord_regdate from tb_order1 where ord_price >= 10000000;

create or replace view vw_memorder1 as
    select mem_userid, mem_name, mem_gender, ord_product, ord_price 
    from tb_member1 join tb_order1 on tb_member1.mem_userid=tb_order1.ord_userid;

select * from vw_memorder1;

drop view vw_memorder1;

create or replace view vw_memorder1("userid", "name", "gender", "product", "price") as 
    select mem_userid, mem_name, mem_gender, ord_product, ord_price from tb_member
    join tb_order on tb_member.mem_userid = tb_order.ord_userid;

select * from vw_memorder1;

select mem_gender, count(mem_idx), avg(mem_point) from tb_member1 group by mem_gender;

create or replace view vw_member1("gender", "count", "avrpoint") as
    select mem_gender, count(mem_idx), avg(mem_point) from tb_member1 group by mem_gender;

select * from vw_member1;

create table tb_student1(
    stu_hakbun varchar2(10) unique not null,
    stu_name varchar2(10) not null,
    stu_gender varchar2(10) not null,
    stu_age number(3),
    stu_point number(3) default 0
);

insert into tb_student1 (stu_hakbun, stu_name, stu_gender, stu_age, stu_point)
values ('21000001', '김사과', '여자', 20, 90);

select * from tb_student1;

create or replace view vw_student01 as
    select stu_hakbun, stu_name, stu_gender, stu_age from tb_student1;

select * from vw_student01;

insert into vw_student01(stu_hakbun, stu_name, stu_gender, stu_age)
values('21000002', '반하나', '여자', 22);

create or replace view vw_student02 as
    select stu_hakbun, stu_name, stu_gender, stu_age from tb_student1
    with read only;

create or replace view vw_student03 as
    select stu_hakbun, stu_name, stu_gender, stu_age from tb_student where stu_gender='남자';

select * from vw_student03;

insert into vw_student03(stu_hakbun, stu_name, stu_gender, stu_age)
values('21000005', '김체리', '여자', 27);

create or replace view vw_student04 as
    select stu_hakbun, stu_name, stu_gender, stu_age from tb_student
    with check option;

insert into vw_student04(stu_hakbun, stu_name, stu_gender, stu_age)
values('21000006', '배에리', '여자', 30);

select * from vw_student04;
select * from tb_student1;

set serveroutput on;

declare
    num1 number := 10;
    num2 number := 5;
begin
    dbms_output.put_line(num1+num2);
end;

declare
    score number := 82;
begin
    case 
    when score >= 90 then 
        dbms_output.put_line('A학점');
    when score >= 80 then
        dbms_output.put_line('B학점');
    when score >= 70 then
        dbms_output.put_line('C학점');
    when score >= 60 then
        dbms_output.put_line('D학점');
    else
        dbms_output.put_line('F학점');
    end case;
end;





































