/*
    시퀀스(seqence)
    - 자동으로 순차적으로 증가하는 순번을 반환하는 데이터베이스 객체
    - 중복값을 방지하거나 pk값을 설정
    
    create sequence 시퀀스명
        increment by 증감숫자 -- 증감숫자가 양수면 증가, 음수면 감소(디폴트는 1)
        start with 시작숫자 -- 시작숫자의 디폴트 값은 증가할때 minvalue 감소할때 maxvalue
        minvalue 최소값
        max value 최대값
        cycle or nocycle : cycle 설정시 최대값에 도달하면 최소값부터 다시 시작
*/
create sequence seq_test
    increment by 1
    start with 1;

select seq_test.currval from dual; -- currval 현재 시퀀스 값, 설정값이 정해지지 않았기 때문에 에러
select seq_test.nextval from dual; -- 1로 시작
select seq_test.currval from dual; -- 현재 값은 1
select seq_test.nextval from dual; -- 2

create sequence seq_member_idx
    increment by 1
    start with 7;
    
select * from tb_member;

INSERT INTO tb_member ( mem_idx, mem_userid, mem_userpw, mem_name, mem_hp, mem_email,
    mem_hobby, mem_ssn1, mem_ssn2, mem_zipcode, mem_addr1, mem_addr2,
    mem_addr3, mem_gender, mem_point) 
    VALUES (seq_member_idx.nextval, 'avocado', '7777', '안카도', '010-7777-7777', 'avocado@avocado.com', '영화감상',
    '001011', '3068518', '12345', '서울', '구로구', '구로동', '남자', 1000);

select * from tb_member;

/*
    시퀀스 수정
    alter sequence 시퀀스명 
    incrememnt by 1 
    start with 1
    ...
*/
-- 시퀀스 시작 번호는 변경할 수 없습니다
alter sequence seq_test
    increment by 3
    start with 100;

alter sequence seq_test
    increment by 3
    maxvalue 100;

select seq_test.currval from dual;
select seq_test.nextval from dual; -- 실행시 에러가 나면 해당 번호는 다음으로 넘어감

/*
    시퀀스 삭제
    drop sequence 시퀀스명
*/
drop sequence seq_test;

select seq_test.currval from dual; -- 시퀀스가 존재하지 않습니다.

/*
    서브쿼리(sub query)
    - sql문 내에 쓰인 select 문을 의미(select 안에 select, insert안에 select...)
    - 바깥쪽에 있는 sql문을 메인쿼리라 부름
    - 메인쿼리 안에 포함된 종속적인 관계이기 때문에 논리적인 실행순서는 항상 메인쿼리에서 읽혀진 데이터에 대해
    서브쿼리에서 해당 조건이 만족했는지 확인하는 방식으로 수행
*/
select * from(
    select mem_userid, mem_name, mem_gender, mem_point, mem_regdate,
    percent_rank() over(partition by mem_gender order by mem_point desc) * 100 as top
    from tb_member where extract(year from mem_regdate) = 2021
    ) where top <= 50

select * from tb_member;
select * from tb_order;

create table tb_point(
    po_idx number(7) unique not null,
    po_userid varchar2(20) not null,
    po_memo varchar2(10) not null,
    po_point number(7) default 0,
    po_ordno varchar2(10) unique not null,
    po_regdate date default sysdate,
    constraint fk_point_userid foreign key(po_userid) references tb_member(mem_userid),
    constraint fk_point_ordno foreign key(po_ordno) references tb_order(ord_no)
);

create sequence seq_point
    increment by 1
    start with 1;

insert into tb_point(po_idx, po_userid, po_memo, po_point, po_ordno) values
(seq_point.nextval, 'apple', '구입', 1000, '1000000001');

select * from tb_point;

/*
    주문번호가 '1000000004'인 데이터에서 가격(10000000)의 5%를 tb_point에 적립하는 쿼리를 만들자
    예) po_idx :seq_point.nextval (4), po_userid : banana, po_memo : '구입', 
    po_point : 서브쿼리 계산, po_ordno : '1000000004'
    insert into tb_point ... ()
*/
insert into tb_point(po_idx, po_ueserid, po_memo, po_point, po_ordno)
values(seq_point.nextval, 'banana', '구입', 
(0.05 * (select ord_price from tb_order where ord_no='1000000004')),
'1000000004');

select * from tb_point;
/*
    union
    - select 결과를 합칠 수 있음
    - 합친 결과에서 중복되는 행을 제거
    - 컬럼의 개수가 같아야 하고, 각 컬럼의 데이터타입이 같아야 함
    
    union all
    - union과 같지만 중복된 행을 제거하지 않음
*/
select * from tb_order;

select ord_userid, ord_regdate from tb_order;
union
select ord_userid, ord_regdate from tb_order where ord_price >= 10000000;

select ord_userid, ord_regdate from tb_order;
union all
select ord_userid, ord_regdate from tb_order where ord_price >= 10000000;

/*
    뷰(view) : 가상 테이블
    - 하나 이상의 테이블이나 다른 뷰의 데이터를 볼 수 있도록 하는 데이터베이스 객체
    - 실제 데이터는 뷰를 구성하는 테이블에 담겨 있지만 마치 테이블처럼 사용할 수 있음
    ? 개발자에게 필요한 정보만 접근하도록 접근 제한할 수 있음
    ? 복잡한 쿼리를 단순화 시키고 속도를 향상 시킬 수 있음
    
    create or replace view 뷰이름 as
        ...
    
    create or replace : 뷰를 수정할때 drp 사용하지 않고 수정하는 방법
    with read only : select만 가능한 뷰가 생성(insert, update, delete가 불가능)
    with check option : where절의 조건에 해당되는 데이터만 저장, 변경이 가능
    force : 뷰를 생성할때 쿼리문의 테이블, 컬럼, 함수 등이 존재하지 않아도 생성이 가능
*/
select * from tb_member;
select * from tb_order;

select mem_userid, mem_name, mem_gender, ord_product, ord_price from tb_member
join tb_order on tb_member.mem_userid = tb_order.ord_userid;

create or replace view vw_memorder as 
    select mem_userid, mem_name, mem_gender, ord_product, ord_price from tb_member
    join tb_order on tb_member.mem_userid = tb_order.ord_userid;

select * from vw_memorder;

/*
    drop view 뷰이름
*/
drop view vw_memorder;


create or replace view vw_memorder("userid", "name", "gender", "product", "price") as 
    select mem_userid, mem_name, mem_gender, ord_product, ord_price from tb_member
    join tb_order on tb_member.mem_userid = tb_order.ord_userid;

/*
    tb_member 테이블에서 성별로 그룹을 맺어 성별, 인원, 평균포인트의 데이터를 확인하는 가상 테이블(view)를 작성
    (각 필드명은 gender, count, avrpoint 생성)
*/
select * from tb_member;

select mem_gender, count(mem_idx), avg(mem_point) from tb_member group by mem_gender;

create or replace view vw_member("gender", "count", "avgpoint") as
    select mem_gender, count(mem_idx), avg(mem_point) from tb_member group by mem_gender;

select * from vw_member;

insert into vw_member(gender, count, avgpoint) values('여자', 1, 1000); -- "AVGPOINT": 부적합한 식별자

create table tb_student(
    stu_hakbun varchar2(10) unique not null,
    stu_name varchar2(10) not null,
    stu_gender varchar2(10) not null,
    stu_age number(3),
    stu_point number(3) default 0
);

insert into tb_student (stu_hakbun, stu_name, stu_gender, stu_age, stu_point)
values ('21000001', '김사과', '여자', 20, 90);
select * from tb_student;

create or replace view vw_student1 as
    select stu_hakbun, stu_name, stu_gender, stu_age from tb_student;

select * from vw_student1;

insert into vw_student1(stu_hakbun, stu_name, stu_gender, stu_age)
values('21000002', '반하나', '여자', 22);

-- with read only 옵션
create or replace view vw_student2 as
    select stu_hakbun, stu_name, stu_gender, stu_age from tb_student
    with read only;

insert into vw_student2(stu_hakbun, stu_name, stu_gender, stu_age)
values('21000004', '박수박', '남자', 27); -- 읽기 전용 뷰에서는 DML 작업을 수행할 수 없습니다.
-- DML(insert, delete, update)

select * from tb_student;


create or replace view vw_student3 as
    select stu_hakbun, stu_name, stu_gender, stu_age from tb_student where stu_gender='남자'
    
select * from vw_student3;

insert into vw_student3(stu_hakbun, stu_name, stu_gender, stu_age)
values('21000005', '김체리', '여자', 27);

-- with check option
create or replace view vw_student4 as
    select stu_hakbun, stu_name, stu_gender, stu_age from tb_student
    with check option;

insert into vw_student4(stu_hakbun, stu_name, stu_gender, stu_age)
values('21000006', '배에리', '여자', 30);

select * from vw_student4;
select * from tb_student;