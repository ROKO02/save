/*
    update(����)
    1. update ���̺�� set �÷���1=��1, �÷Ÿ�2=��2, ... 
*/
update tb_member set mem_email='test@test.com', mem_hobby='������ Ÿ��';

select * from tb_member;

/*
    ������ ����
    1. �����͸� �����ϰ� �ٷ���
        - ����� ��Ȱȭ
        - �׽�Ʈ�� �����, �׽�Ʈ�� �׽�Ʈ ��������
    2. å���� ��ǥ�� ����
        - ����� �Ǽ��ϸ� ����ϸ� ��
*/

alter table tb_member add(
    mem_point number(7) default 0
);

select * from tb_member;

-- ��� ȸ������ ����Ʈ 100�� �߰���
update tb_member set mem_point = mem_point + 100;

/*
    2. update ���̺�� set �÷Ÿ�1=��1, �÷���2=��2, ... where ���ǽ�
*/
update tb_member set mem_email='banan@banana.com', mem_hobby='��ȭ����' where mem_userid='banana';
select * from tb_member;
update tb_member set mem_email='ryuzy@naver.com', mem_hobby='����̺�' where mem_addr1='����Ư����';

/*
    delete(����)
    1. delete from ���̺��;
*/
delete from tb_member;
select * from tb_member;

/*
    2. delete from ���̺�� where ���ǽ�;
*/
delete from tb_member where mem_userid='banana';
select * from tb_member;

/*
    select(�˻�)
    1. select �÷���1, �÷���2, ... from ���̺��;
*/
select mem_userid, mem_name, mem_hp from tb_member;
select mem_hp, mem_userid, mem_name from tb_member;
select * from tb_member; -- *(����÷�), ���� �߻�

/*
    2. select �÷���1, �÷���2, ... from ���̺�� order by �÷��� asc �Ǵ� desc; (asc�� ���� ����)
*/
select mem_userid, mem_name, mem_hp, mem_gender, mem_point from tb_member order by mem_point desc;
select mem_userid, mem_name, mem_hp, mem_gender, mem_point from tb_member order by mem_point desc; -- ����Ʈ ��������
select mem_userid, mem_name, mem_hp, mem_gender, mem_point from tb_member order by mem_point; -- ����Ʈ ��������
select mem_userid, mem_name, mem_hp, mem_gender from tb_member order by mem_userid; -- userid ����������
select mem_idx, mem_userid, mem_name, mem_hp, mem_gender, mem_point from tb_member order by mem_point desc, mem_idx desc;

/*
    ������
    ���������
    +, -, *, /
*/
    select 5 + 3 from dual;
    select 5 - 3 from dual;
    select 5 * 3 from dual;
    select 5 / 3 from dual;
    select 5+3, 5-3, 5*3, 5/3 from dual;
    select 5+3 as "����", 5-3 as "����", 5*3 as "����", 5/3 as "������" from dual;
    select 5+3 "����", 5-3 "����", 5*3 "����", 5/3 "������" from dual;

/*
    �񱳿����� where�� ����
    = : ����
    != : �ٸ���
    < : ũ��
    > : �۴�
    >= : ũ�ų� ����
    <= : �۰ų� ����
*/
select 3 > 2 from dual; -- ������ ���
select mem_userid, mem_name, mem_hp from tb_member where mem_userid = 'apple';
select mem_userid, mem_name, mem_hp from tb_member where mem_userid != 'apple';
select mem_userid, mem_name, mem_hp, mem_point from tb_member where mem_point > 100;
-- ������ '����'�� �ƴ� ȸ�� ���(���̵�, �̸�, ����, ��ȭ��ȣ)
select mem_userid, mem_name, mem_gender, mem_hp from tb_member where mem_gender != '����';
select mem_userid, mem_name, mem_hobby from tb_member where mem_hobby='(null)'; -- ??
select mem_userid, mem_name, mem_hobby from tb_member where mem_hobby=(null); -- ??
select mem_userid, mem_name, mem_hobby from tb_member where mem_hobby='null'; -- ??
select mem_userid, mem_name, mem_hobby from tb_member where mem_hobby=null; -- ??
select mem_userid, mem_name, mem_hobby from tb_member where mem_hobby=''; -- ??
select mem_userid, mem_name, mem_hobby from tb_member where mem_hobby is null;

/*
    ��������
    and : �� ���ǽ��� ����� ��� ���� �� ��
    ��) ��� ������ ��������� 60�� �̻� �׸��� �� ����� 10�� �̾��� ������ ������ �ȵ�
    or : �� ���ǽ��� ��� �� �ϳ��� ���� �� ��
    ��) �߱������� ¥�� �Ǵ� «���� ��ų���� 
    not : ����� �ݴ�� ���
*/
select mem_userid, mem_name from tb_member where mem_userid='apple' and mem_userpw='1111';
select * from tb_member;
select mem_userid, mem_name from tb_member where mem_userid='melon' or mem_userid='cherry';
select mem_userid, mem_name from tb_member where mem_userid='melon' or mem_userid='dog';
-- ��̰� �ִ� ȸ��
select mem_userid, mem_name, mem_hobby from tb_member where mem_hobby is not null;

select mem_userid, mem_name, mem_hp, mem_point from tb_member where not mem_point > 100;

-- �̸����� ���� ���ų� ����Ʈ�� 100���� �۰ų� ���� ȸ���� ���(���̵�, �̸�, �̸���, ����Ʈ)
select mem_userid, mem_name, mem_email, mem_point from tb_member where mem_email is null or mem_point <= 100;

