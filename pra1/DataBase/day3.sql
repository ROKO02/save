/*
    camle case : �� �ܾ �������� �� �ܾ��� ù���ڴ� �빮�ڷ� �ۼ�
    ��) num, numKor
    snake case : �⺻�� �빮�ڷ� �ۼ�, �� �ܾ ��������_�� ����Ͽ� ����
    ��) MEMBER, TB_MEMBER
*/
create table tb_member(
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


-- ������ Ȯ��
select * from tb_member;

/*
    ���̺� ����
    drop table ���̺��;
*/
-- ���̺� ����
drop table tb_member;

/*
    ���̺� ����
    1. �÷� �߰�
        alter table ���̺�� add(
                �÷��� �ڷ��� ��������  
        )
*/
alter table tb_member add(
    mem_gender varchar(6)
);

/*
    2. �÷� ����
    alter table ���̺�� modify(
        �÷��� �ڷ��� ��������
    );
*/
alter table tb_member modify(
    mem_gender varchar2(6) check(mem_gender in ('����', '����'))
);
/*
    3. �÷� ����
    alter table ���̺�� drop(
        �÷���
    );
*/
alter table tb_member drop(
    mem_gender
);

/*
    ���̺�� ����
    alter table ���̺�� rename to ������ ���̵��;
*/
alter table tb_member rename to tb_user;

select * from tb_member;
select * from tb_user;

alter table tb_user rename to tb_member;

/*
    �÷��� ����
    alter table ���̺�� rename column �÷��� to ������ �÷���;
*/
alter table tb_member rename column mem_hp to mem_tel;
alter table tb_member rename column mem_tel to mem_hp;

/*
    insert(����)
    1. 
    insert into ���̺�� (�÷���1, �÷���2, ...) vlaues (��1, ��2, ...);
*/
INSERT INTO tb_member (mem_idx, mem_userid, mem_userpw, mem_name, mem_hp, mem_email, mem_hobby, mem_ssn1,
    mem_ssn2, mem_zipcode, mem_addr1, mem_addr2, mem_addr3, mem_regdate) 
    VALUES (1, 'apple', '1111', '����', '010-1111-1111', 'apple@apple.com', '����̺�',
    '001011', '4068518', '12345', '����Ư����', '���ʱ�', '������', sysdate);

select * from tb_member;

--userid �����ؼ� �ٽ� ���� -> mem_idx unique 
INSERT INTO tb_member (mem_idx, mem_userid, mem_userpw, mem_name, mem_hp, mem_ssn1, mem_ssn2, 
mem_zipcode, mem_addr1) 
    VALUES (2, 'banana', '2222', '���ϳ�', '010-2222-2222', '001011', '4012345', '12345'
    ,'����Ư����');

select * from tb_member;


/*
    2.
    insert into ���̺�� values (��1, ��2, ...)
*/

INSERT INTO tb_member VALUES (3, 'orange', '3333', '������', '010-3333-3333', 'orange@orange.com', '���',
    '001011', '3068518', '12345', '����Ư����', '���ʱ�', '������', sysdate);

select * from tb_member;

-- null : �����Ͱ� ����
INSERT INTO tb_member VALUES (4, 'melon', '4444', '�̸޷�', '010-4444-4444', null, null,
    '001011', '3068518', '12345', '����Ư����', null, null, null);

alter table tb_member add(
    mem_gender varchar(6) check(mem_gender in ('����', '����'))
);

-- ���� ���� ������� �ʽ��ϴ�
INSERT INTO tb_member VALUES (5, 'cherry', '5555', '��ü��', '010-5555-5555', null, null,
    '001011', '4068518', '12345', '����Ư����', null, null, null);
    
-- üũ �������ǿ� null�� ����
INSERT INTO tb_member VALUES (5, 'cherry', '5555', '��ü��', '010-5555-5555', null, null,
    '001011', '4068518', '12345', '����Ư����', null, null, null, null);
    
-- üũ ��������(ADMIN.SYS_C0023493)�� ����
INSERT INTO tb_member VALUES (6, 'watermelon', '6666', '�ڼ���', '010-6666-6666', null, null,
    '001011', '3068518', '12345', '����Ư����', null, null, null, '��');

INSERT INTO tb_member VALUES (6, 'watermelon', '6666', '�ڼ���', '010-6666-6666', null, null,
    '001011', '3068518', '12345', '����Ư����', null, null, null, '����');

select * from tb_member;












