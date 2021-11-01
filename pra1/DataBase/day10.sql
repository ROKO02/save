/*
    프로시저(procedure)
    - 
    - 작업 효율을 늘릴 수 있음
    - 속도가 빠름
    
    create or replace procedure 프로시저명( [in or out] 데이터타입)
    is
        선언문
    begin
        실행문
    end;
    
*/
create table tb_address(
    add_num number(7),
    add_zipcode varchar2(5),
    add_address varchar2(20)
);

create sequence seq_addr_num
    increment by 1
    start with 1;

create or replace procedure proc_addr_insert(
    p_add_zipcode in varchar2,
    p_add_address in varchar2
)
is
    -- p_add_zipcode varchar(5) := '12345';
begin
    insert into tb_address(add_num, add_zipcode, add_address) values
    (seq_addr_num.nextval, p_add_zipcode, p_add_address);
end proc_addr_insert;

exec proc_addr_insert('10000', '서울 서초구 양재동');

/*
    tb_member(회원테이블)에 매개변수를 전달하여 회원가입하는 프로시저를 작성
    프로시저명 : proc_mem_insert, 시퀀스 : seq_member_idx
*/
create or replace procedure proc_mem_insert(
    p_mem_userid in varchar2,
    p_mem_userpw in varchar2,
    p_mem_name in varchar2,
    p_mem_gender in varchar2,
    p_mem_hp in varchar2,
    p_mem_email in varchar2,
    p_mem_hobby in varchar2,
    p_mem_ssn1 in varchar2,
    p_mem_ssn2 in varchar2,
    p_mem_zipcode in varchar2,
    p_mem_addr1 in varchar2,
    p_mem_addr2 in varchar2,
    p_mem_addr3 in varchar2
)
is
begin
    insert into tb_member(mem_idx, mem_userid, mem_userpw, mem_name, mem_gender, mem_email, 
    mem_hp, mem_zipcode, mem_addr1, mem_addr2, mem_addr3, mem_ssn1, mem_ssn2, mem_hobby) values (SEQ_MEMBER_IDX.nextval, p_mem_userid, 
    p_mem_userpw, p_mem_name, p_mem_gender, p_mem_email, p_mem_hp, p_mem_zipcode, p_mem_addr1, p_mem_addr2, 
    p_mem_addr3, p_mem_ssn1, p_mem_ssn2, p_mem_hobby);
    
exec proc_mem_insert('ryuzy', '1111', '류정원', '남자', '010-1111-1111', 'ryuzy@naver.com', '잠안자기', '000000', '1111111', '11111', '서울', '서초구', '양재동');

/*
    트랜젝션(transaction)
    - DBMS에서 발생하는 1개이상의 명령어들을 논리집합으로 묶어놓은 단위
    - 트랜젝션에 의해 관리되는 명령어 : DML(insert, update, delete)만 포함 -> 데이터에 조작을 가하는 명령어
    
    트랜젝션 관리
    - comit : 트랜젝션을 완료
    - rollback : 트랜젝션 작업 전으로 되돌림
    - save point : 트랜젝션의 저장 위치
*/
select * from tb_member;

-- 새로운 테이블에 데이터 복사하기
create table tb_member_copy
as
select mem_idx, mem_userid, mem_name, mem_hp, mem_email, mem_regdate from tb_member;

select * from tb_member_copy;

/*
  auto commmit
  - 자동 저장 가능
  - 모든 insert, update, delete를 각각 실행할때마다 commit를 바로 이어서 실행됨
  - rollback 불가능
*/
set autocommit off; -- auto commit을 해제

delete from tb_member_copy where mem_idx = 7;

rollback;

delete from tb_member_copy where mem_idx = 7;

commit;

select * from tb_member_copy;

delete from tb_member_copy where mem_userid='melon';

savepoint a;

delete from tb_member_copy where mem_userid='watermelon';

savepoint b;

rollback;
rollback to a; -- savepoint a 시점으로 돌아감

select * from tb_member;

/*
    tb_member 테이블의 아이디와 취미를 입력하여 취미를 update하는 프로시저를 작성
    프로시저 : proc_mem_hobby_update
*/
create or replace procedure proc_mem_hobby_update(
    p_mem_userid in varchar2,
    p_mem_hobby in varchar2
)
is 
begin
    update tb_member set mem_hobby = p_mem_hobby where mem_userid = p_mem_userid;
exception
    when others then
        rollback;
        dbms_output.put_line('SQL ERROR');
end proc_mem_hobby_update;

select * from tb_member;

/*
    tb_member의 아이디와 포인트 점수를 매개변수로 입력 후 현재 총 포인트 점수를 반환해주는 프로시저 작성
*/
create or replace procedure proc_mem_point_sum(
    p_mem_userid in varchar2,
    p_mem_point in number,
    o_sum_point out number
)
is
    o_result number;
begin
    update tb_member set mem_point = mem_point + p_mem_point where mem_userid=p_mem_userid;
    o_result := SQL%ROWCOUNT;
    o_sum_point := o_result;
exception
    when others then
        rollback;
        dbms_output.put_line('SQL Error!');
end proc_mem_point_sum;

   
set serveroutput on;
   
declare 
    result number;
begin
    proc_mem_point_sum('apple', 500, result);
    dbms_output.put_line(result);
end;


select * from tb_member;

/*
    커서(cursor)
    - 오라클에서 할당한 전용 메모리 영역에 대한 포인터
    - 질의의 결과로 얻어진 여러 행이 저장된 메모리상의 위치
    - select문의 결과 집합을 처리하는데 사용
*/
create or replace procedure proc_member_select(
    p_userid in varchar2,
    p_point in number,
    o_cursor out SYS_REFCURSOR
)
is
begin
    begin
        open o_cursor for
            select mem_idx, mem_userid, mem_name, mem_gender from tb_member where mem_userid=p_userid;
        exception
            when others then
                rollback;
                dbms_output.put_line('SELECT SQL ERROR');
    end;
    begin
        update tb_member set mem_point = mem_point + p_point where mem_userid=p_userid;
        exception
            when others then
                rollback;
                dbms_output.put_line('UPDATE SQL ERROR');
    end;
end proc_member_select;

var o_cursor REFCURSOR
exec proc_member_select('apple', 500, :o_cursor)
print o_cursor;

create or replace procedure proc_member_select(
    p_userid in varchar2,
    p_point in number,
    o_cursor out SYS_REFCURSOR
)
is
begin
    begin
        update tb_member set mem_point = mem_point + p_point where mem_userid=p_userid;
        exception
            when others then
                rollback;
                dbms_output.put_line('UPDATE SQL ERROR');
    end;
    begin
        open o_cursor for
            select mem_idx, mem_userid, mem_name, mem_gender, mem_point from tb_member where mem_userid=p_userid;
        exception
            when others then
                rollback;
                dbms_output.put_line('SELECT SQL ERROR');
    end;
end proc_member_select;

var o_cursor REFCURSOR
exec proc_member_select('apple', 500, :o_cursor)
print o_cursor;

/*
    index(색인)
    - index는 원하는 정보의 위치를 빠르고 정확하게 알아낼 수 있는 방법
    - 자동생성 : primary key
    - 수동생성 : query를 통해 만듬
    
    생성하면 좋은 필드(컬럼)
    - where절이나 join 조건 안에 자주 사용되는 컬럼
    - null 값이 많이 포함되어 있지 않은 컬럼
    
    생성하면 안좋은 필드(컬럼)
    - 데이터가 적을때(row가 10000개 이하)
    - 테이블이 자주 갱신될때
*/
select * from tb_member;
select * from tb_order;

drop table tb_member_copy;

create table tb_member_copy as select * from tb_member;
select * from tb_member_copy;

alter table tb_member_copy add constraint pk_memcopy_userid primary key(mem_userid);

-- index 확인하기
select * from all_indexes where index_name in ('PK_MEMCOPY_USERID');
-- primary key는 자동으로 index를 만듬

-- index 만들기
create index idx_mem_idx on tb_member_copy(mem_idx);

select * from all_indexes where ownver='ADMIN';

select * from all_indexes where index_name = 'IDX_MEM_IDX';

/*
    인덱스를 많이 사용하면 안되는 이유!!
    - 어플리케이션에서 성능 이슈가 생기는 주요 원인은 데이터베이스!
    - 데이터베이스 튜닝의 가장 첫번째 대상은 인덱스
    - 인덱스는 1개의 테이블에서 자주 사용되는 2개 또는 3개의 컬럼에만 적용하는 것이 좋음
*/


