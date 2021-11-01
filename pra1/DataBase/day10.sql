/*
    ���ν���(procedure)
    - 
    - �۾� ȿ���� �ø� �� ����
    - �ӵ��� ����
    
    create or replace procedure ���ν�����( [in or out] ������Ÿ��)
    is
        ����
    begin
        ���๮
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

exec proc_addr_insert('10000', '���� ���ʱ� ���絿');

/*
    tb_member(ȸ�����̺�)�� �Ű������� �����Ͽ� ȸ�������ϴ� ���ν����� �ۼ�
    ���ν����� : proc_mem_insert, ������ : seq_member_idx
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
    
exec proc_mem_insert('ryuzy', '1111', '������', '����', '010-1111-1111', 'ryuzy@naver.com', '����ڱ�', '000000', '1111111', '11111', '����', '���ʱ�', '���絿');

/*
    Ʈ������(transaction)
    - DBMS���� �߻��ϴ� 1���̻��� ��ɾ���� ���������� ������� ����
    - Ʈ�����ǿ� ���� �����Ǵ� ��ɾ� : DML(insert, update, delete)�� ���� -> �����Ϳ� ������ ���ϴ� ��ɾ�
    
    Ʈ������ ����
    - comit : Ʈ�������� �Ϸ�
    - rollback : Ʈ������ �۾� ������ �ǵ���
    - save point : Ʈ�������� ���� ��ġ
*/
select * from tb_member;

-- ���ο� ���̺� ������ �����ϱ�
create table tb_member_copy
as
select mem_idx, mem_userid, mem_name, mem_hp, mem_email, mem_regdate from tb_member;

select * from tb_member_copy;

/*
  auto commmit
  - �ڵ� ���� ����
  - ��� insert, update, delete�� ���� �����Ҷ����� commit�� �ٷ� �̾ �����
  - rollback �Ұ���
*/
set autocommit off; -- auto commit�� ����

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
rollback to a; -- savepoint a �������� ���ư�

select * from tb_member;

/*
    tb_member ���̺��� ���̵�� ��̸� �Է��Ͽ� ��̸� update�ϴ� ���ν����� �ۼ�
    ���ν��� : proc_mem_hobby_update
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
    tb_member�� ���̵�� ����Ʈ ������ �Ű������� �Է� �� ���� �� ����Ʈ ������ ��ȯ���ִ� ���ν��� �ۼ�
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
    Ŀ��(cursor)
    - ����Ŭ���� �Ҵ��� ���� �޸� ������ ���� ������
    - ������ ����� ����� ���� ���� ����� �޸𸮻��� ��ġ
    - select���� ��� ������ ó���ϴµ� ���
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
    index(����)
    - index�� ���ϴ� ������ ��ġ�� ������ ��Ȯ�ϰ� �˾Ƴ� �� �ִ� ���
    - �ڵ����� : primary key
    - �������� : query�� ���� ����
    
    �����ϸ� ���� �ʵ�(�÷�)
    - where���̳� join ���� �ȿ� ���� ���Ǵ� �÷�
    - null ���� ���� ���ԵǾ� ���� ���� �÷�
    
    �����ϸ� ������ �ʵ�(�÷�)
    - �����Ͱ� ������(row�� 10000�� ����)
    - ���̺��� ���� ���ŵɶ�
*/
select * from tb_member;
select * from tb_order;

drop table tb_member_copy;

create table tb_member_copy as select * from tb_member;
select * from tb_member_copy;

alter table tb_member_copy add constraint pk_memcopy_userid primary key(mem_userid);

-- index Ȯ���ϱ�
select * from all_indexes where index_name in ('PK_MEMCOPY_USERID');
-- primary key�� �ڵ����� index�� ����

-- index �����
create index idx_mem_idx on tb_member_copy(mem_idx);

select * from all_indexes where ownver='ADMIN';

select * from all_indexes where index_name = 'IDX_MEM_IDX';

/*
    �ε����� ���� ����ϸ� �ȵǴ� ����!!
    - ���ø����̼ǿ��� ���� �̽��� ����� �ֿ� ������ �����ͺ��̽�!
    - �����ͺ��̽� Ʃ���� ���� ù��° ����� �ε���
    - �ε����� 1���� ���̺��� ���� ���Ǵ� 2�� �Ǵ� 3���� �÷����� �����ϴ� ���� ����
*/


