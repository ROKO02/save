/*
    ������(seqence)
    - �ڵ����� ���������� �����ϴ� ������ ��ȯ�ϴ� �����ͺ��̽� ��ü
    - �ߺ����� �����ϰų� pk���� ����
    
    create sequence ��������
        increment by �������� -- �������ڰ� ����� ����, ������ ����(����Ʈ�� 1)
        start with ���ۼ��� -- ���ۼ����� ����Ʈ ���� �����Ҷ� minvalue �����Ҷ� maxvalue
        minvalue �ּҰ�
        max value �ִ밪
        cycle or nocycle : cycle ������ �ִ밪�� �����ϸ� �ּҰ����� �ٽ� ����
*/
create sequence seq_test
    increment by 1
    start with 1;

select seq_test.currval from dual; -- currval ���� ������ ��, �������� �������� �ʾұ� ������ ����
select seq_test.nextval from dual; -- 1�� ����
select seq_test.currval from dual; -- ���� ���� 1
select seq_test.nextval from dual; -- 2

create sequence seq_member_idx
    increment by 1
    start with 7;
    
select * from tb_member;

INSERT INTO tb_member ( mem_idx, mem_userid, mem_userpw, mem_name, mem_hp, mem_email,
    mem_hobby, mem_ssn1, mem_ssn2, mem_zipcode, mem_addr1, mem_addr2,
    mem_addr3, mem_gender, mem_point) 
    VALUES (seq_member_idx.nextval, 'avocado', '7777', '��ī��', '010-7777-7777', 'avocado@avocado.com', '��ȭ����',
    '001011', '3068518', '12345', '����', '���α�', '���ε�', '����', 1000);

select * from tb_member;

/*
    ������ ����
    alter sequence �������� 
    incrememnt by 1 
    start with 1
    ...
*/
-- ������ ���� ��ȣ�� ������ �� �����ϴ�
alter sequence seq_test
    increment by 3
    start with 100;

alter sequence seq_test
    increment by 3
    maxvalue 100;

select seq_test.currval from dual;
select seq_test.nextval from dual; -- ����� ������ ���� �ش� ��ȣ�� �������� �Ѿ

/*
    ������ ����
    drop sequence ��������
*/
drop sequence seq_test;

select seq_test.currval from dual; -- �������� �������� �ʽ��ϴ�.

/*
    ��������(sub query)
    - sql�� ���� ���� select ���� �ǹ�(select �ȿ� select, insert�ȿ� select...)
    - �ٱ��ʿ� �ִ� sql���� ���������� �θ�
    - �������� �ȿ� ���Ե� �������� �����̱� ������ ������ ��������� �׻� ������������ ������ �����Ϳ� ����
    ������������ �ش� ������ �����ߴ��� Ȯ���ϴ� ������� ����
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
(seq_point.nextval, 'apple', '����', 1000, '1000000001');

select * from tb_point;

/*
    �ֹ���ȣ�� '1000000004'�� �����Ϳ��� ����(10000000)�� 5%�� tb_point�� �����ϴ� ������ ������
    ��) po_idx :seq_point.nextval (4), po_userid : banana, po_memo : '����', 
    po_point : �������� ���, po_ordno : '1000000004'
    insert into tb_point ... ()
*/
insert into tb_point(po_idx, po_ueserid, po_memo, po_point, po_ordno)
values(seq_point.nextval, 'banana', '����', 
(0.05 * (select ord_price from tb_order where ord_no='1000000004')),
'1000000004');

select * from tb_point;
/*
    union
    - select ����� ��ĥ �� ����
    - ��ģ ������� �ߺ��Ǵ� ���� ����
    - �÷��� ������ ���ƾ� �ϰ�, �� �÷��� ������Ÿ���� ���ƾ� ��
    
    union all
    - union�� ������ �ߺ��� ���� �������� ����
*/
select * from tb_order;

select ord_userid, ord_regdate from tb_order;
union
select ord_userid, ord_regdate from tb_order where ord_price >= 10000000;

select ord_userid, ord_regdate from tb_order;
union all
select ord_userid, ord_regdate from tb_order where ord_price >= 10000000;

/*
    ��(view) : ���� ���̺�
    - �ϳ� �̻��� ���̺��̳� �ٸ� ���� �����͸� �� �� �ֵ��� �ϴ� �����ͺ��̽� ��ü
    - ���� �����ʹ� �並 �����ϴ� ���̺� ��� ������ ��ġ ���̺�ó�� ����� �� ����
    ? �����ڿ��� �ʿ��� ������ �����ϵ��� ���� ������ �� ����
    ? ������ ������ �ܼ�ȭ ��Ű�� �ӵ��� ��� ��ų �� ����
    
    create or replace view ���̸� as
        ...
    
    create or replace : �並 �����Ҷ� drp ������� �ʰ� �����ϴ� ���
    with read only : select�� ������ �䰡 ����(insert, update, delete�� �Ұ���)
    with check option : where���� ���ǿ� �ش�Ǵ� �����͸� ����, ������ ����
    force : �並 �����Ҷ� �������� ���̺�, �÷�, �Լ� ���� �������� �ʾƵ� ������ ����
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
    drop view ���̸�
*/
drop view vw_memorder;


create or replace view vw_memorder("userid", "name", "gender", "product", "price") as 
    select mem_userid, mem_name, mem_gender, ord_product, ord_price from tb_member
    join tb_order on tb_member.mem_userid = tb_order.ord_userid;

/*
    tb_member ���̺��� ������ �׷��� �ξ� ����, �ο�, �������Ʈ�� �����͸� Ȯ���ϴ� ���� ���̺�(view)�� �ۼ�
    (�� �ʵ���� gender, count, avrpoint ����)
*/
select * from tb_member;

select mem_gender, count(mem_idx), avg(mem_point) from tb_member group by mem_gender;

create or replace view vw_member("gender", "count", "avgpoint") as
    select mem_gender, count(mem_idx), avg(mem_point) from tb_member group by mem_gender;

select * from vw_member;

insert into vw_member(gender, count, avgpoint) values('����', 1, 1000); -- "AVGPOINT": �������� �ĺ���

create table tb_student(
    stu_hakbun varchar2(10) unique not null,
    stu_name varchar2(10) not null,
    stu_gender varchar2(10) not null,
    stu_age number(3),
    stu_point number(3) default 0
);

insert into tb_student (stu_hakbun, stu_name, stu_gender, stu_age, stu_point)
values ('21000001', '����', '����', 20, 90);
select * from tb_student;

create or replace view vw_student1 as
    select stu_hakbun, stu_name, stu_gender, stu_age from tb_student;

select * from vw_student1;

insert into vw_student1(stu_hakbun, stu_name, stu_gender, stu_age)
values('21000002', '���ϳ�', '����', 22);

-- with read only �ɼ�
create or replace view vw_student2 as
    select stu_hakbun, stu_name, stu_gender, stu_age from tb_student
    with read only;

insert into vw_student2(stu_hakbun, stu_name, stu_gender, stu_age)
values('21000004', '�ڼ���', '����', 27); -- �б� ���� �信���� DML �۾��� ������ �� �����ϴ�.
-- DML(insert, delete, update)

select * from tb_student;


create or replace view vw_student3 as
    select stu_hakbun, stu_name, stu_gender, stu_age from tb_student where stu_gender='����'
    
select * from vw_student3;

insert into vw_student3(stu_hakbun, stu_name, stu_gender, stu_age)
values('21000005', '��ü��', '����', 27);

-- with check option
create or replace view vw_student4 as
    select stu_hakbun, stu_name, stu_gender, stu_age from tb_student
    with check option;

insert into vw_student4(stu_hakbun, stu_name, stu_gender, stu_age)
values('21000006', '�迡��', '����', 30);

select * from vw_student4;
select * from tb_student;