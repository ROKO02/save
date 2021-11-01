/*
    in: �����͸� �����ϰ� �ִ� ���ڵ带 ���
    ��) in (10, 20, 30) -> column�� �����Ͱ� 10 �Ǵ� 20 �Ǵ� 30�� ���ڵ带 ����
*/
select * from TB_MEMBER;

select MEM_USERID, MEM_NAME, MEM_GENDER, MEM_POINT from TB_MEMBER where MEM_POINT in(0, 150, 200);

select MEM_USERID, MEM_NAME, MEM_GENDER, MEM_POINT from TB_MEMBER where MEM_POINT = 100 or MEM_POINT = 150;

/*
    like: �ش� ���ڿ��� �����ϰ� �ִ� ���ڵ带 ����
    ��) like '��%' => '��'���� �����ϴ� �������� ��� ���ڵ带 ��� ����
    ��) like '%��' => '��'���� ������ ~~
    ��) like '%��%' => '��'�� ���Ե� ~~
*/

select MEM_USERID, MEM_NAME, MEM_GENDER from TB_MEMBER where MEM_NAME like '��%';

select MEM_USERID, MEM_NAME, MEM_GENDER from TB_MEMBER where MEM_USERID like '%e%';

select MEM_USERID, MEM_NAME, MEM_GENDER from TB_MEMBER where MEM_USERID like '%a%';

/*
    between a and b : a �̻��̰� b ������ ���ڵ带 ����
    ��) MEM_POINT between 100 and 300 => ����Ʈ ������ 100�̻� 300������ ���ڵ� ���� 
*/

select MEM_USERID, MEM_NAME, MEM_GENDER, MEM_POINT from TB_MEMBER where MEM_POINT between 100 and 300;

/*
    || : ���ڿ� ����
*/
select mem_userid, mem_name, mem_gender from tb_member;
select mem_userid, 'mem_weight' from tb_member;
select mem_userid as "���̵�", mem_userpw as "��й�ȣ" from tb_member;
select 'id : ' || mem_userid as "���̵�", 'password : ' || mem_userpw as "��й�ȣ" from tb_member;

/*
    distinct : �ߺ� ���� ���� ���ڵ带 ����
*/
select distinct mem_gender from tb_member;

/*
    group by(�׷�)
    ��) select �׷��� ���� �÷��� �Ǵ� �����Լ� from ���̺�� [where ����] group by �׷��� ���� �÷��� 
    having ���� order by �÷���
    �����Լ� : count(), sum(), avg(), max(), min()
*/
select * from tb_member;
select mem_gender from tb_member group by mem_gender;
select mem_gender, mem_userid from tb_member group by mem_gender; -> not a GROUP BY expression
select mem_gender, count(mem_userid) from tb_member group by mem_gender; -- null�� ���ԵǾ� ���� ����
select mem_gender, count(mem_regdate) from tb_member group by mem_gender; -- null�� ���ԵǾ� ����
select mem_gender, count(mem_userid), sum(mem_point), avg(mem_point), max(mem_point), min(mem_point)
from tb_member group by mem_gender;

select mem_gender, count(mem_userid), sum(mem_point), avg(mem_point), max(mem_point), min(mem_point)
from tb_member where mem_regdate is not null group by mem_gender;

select mem_gender, count(mem_userid), sum(mem_point), avg(mem_point), max(mem_point), min(mem_point)
from tb_member where mem_regdate is not null group by mem_gender having count(mem_userid) > 1;

/*
    �ֹ� ���̺� �����
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

-- ���Ἲ ��������(ADMIN.FK_MEM_USERID)�� ����Ǿ����ϴ�- �θ� Ű�� �����ϴ�
INSERT INTO tb_order (ord_no, ord_userid, ord_product, ord_count, ord_price) 
VALUES ('1000000001', 'avocado', '�ƺ�����', 1, 2500000);

INSERT INTO tb_order (ord_no, ord_userid, ord_product, ord_count, ord_price) 
VALUES ('1000000001', 'apple', '�ƺ�����', 1, 2500000);

INSERT INTO tb_order (ord_no, ord_userid, ord_product, ord_count, ord_price) 
VALUES ('1000000002', 'banana', 'û�ұ�', 1, 300000);

INSERT INTO tb_order (ord_no, ord_userid, ord_product, ord_count, ord_price) 
VALUES ('1000000003', 'orange', '��Ź��', 1, 1000000);

INSERT INTO tb_order (ord_no, ord_userid, ord_product, ord_count, ord_price) 
VALUES ('1000000004', 'banana', '�����', 1, 600000);
select * from tb_order;

-- ���̵�, �̸�, ����, ��ǰ, ����, ��¥

/*
    ����(join)
    - �� ���̺��� ����� �÷�(����)���� �����͸� ���� ǥ��
    - select �÷���1, �÷���2, ... from ���̺��1 (left, right) join ���̺��2 
    on ���̺��1.�÷��� = ���̺�2.�÷���
    
    inner join(������), left join(���̺�1 ����), right join(���̺�2 ����)
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
    ����Ŭ ���� �Լ�
    instr(���ڿ�, �˻� �� ����, [��������, n��° �˻��ܾ�])
    - ã�� ������ ��ġ�� ��ȯ �����ִ� �Լ�
    - ã�� ���ڰ� ������ 0�� ��ȯ
    - ã�� �ܾ� �ձ����� �ε����� ��ȯ
*/
select instr('Hello Orcale', 'O') as instr from dual; -- 7
select instr('Hello Orcale', 'OX') as instr from dual; -- 0
select instr('Hello Oracle', 'Ora') as instr from dual; -- 7
select instr('Hello Orcale', 'l') as instr from dual; -- 3
select instr('Hello Orcale', 'l',5) as instr from dual; -- 11
select instr('Hello Orcale', 'l', 1, 3) as instr from dual; -- 11
select instr('Hello Orcale', 'l', -1, 3) as instr from dual; -- 3

