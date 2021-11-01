/*
    width_bucket(��, �ּҰ�, �ִ밪(<), ��Ŷ): �ּҰ��� �ִ밪�� �����ϰ� ��Ŷ�� ������ ���� ������ ���� ��� ��ġ�� �ִ����� ��ȯ
    width_bucket(70, 1, 101, 2) -> 2
                     ��1���� 100���� 2���� �ɰ����� 70�� ��� �ִ�? 2���߿� 2��..
    width_bucket(43, 1, 101, 4) -> 2
*/

--2021�� ��ݱ�, �Ϲݱ⿡ ������ ȸ�� ��
select * from tb_member;
select mem_userid, mem_name, case
    width_bucket(extract(month from mem_regdate), 1, 13, 2)
    when 1 then '��ݱ�'
    else '�Ϲݱ�'
    end as half_year, mem_regdate from tb_member;
                    -- ���׳ɻ����� ���� ������!
    
select case
    width_bucket(extract(month from mem_regdate), 1, 13, 2)
    when 1 then '��ݱ�'
    else '�Ϲݱ�'
    end as half_year, count(mem_idx) as count from tb_member where extract(year from mem_regdate) = 2021
    group by width_bucket(extract(month from mem_regdate), 1, 13, 2);
    

/*
    sysdate : ���� ��¥
    add_months() : Ư�� ��¥�� ���� ������ ���� ���� �ش� ��¥�� ��ȯ
    months_between() : ��¥ ���� ���̸� ���� ��ȯ
*/
select sysdate from dual;
select sysdate + 100 from dual;
select add_months(sysdate, 1) from dual;

-- ȸ���� ���Գ�¥�� ���糯���� ����(��)�� ���
-- ���̵�, �̸�, ���糯¥, ���Գ�¥, ����
select mem_userid, mem_name, sysdate as today, mem_regdate, floor(months_between(sysdate, mem_regdate)) as month from tb_member;


/*
    to_char() : ��¥�� ������ �����ͷ� ��ȯ
    to_char(��¥, ����)
    ����
    D : ��(1~7) 1�� �Ͽ���, 7�� �����
    DD : ��(1~31)
    DDD : 1�� �� ��¥ (1~365)
    HH24 : �ð�(0~23)
    IW : 1�� �� �� ��(1~53)
    MI : ��(0~59)
    SS : ��(0~59)
    MM : ��(01~12)
    Q  : �б�(1,2,3,4)
    YYYY : ��
    W : �� �� ����(1~5)
*/

select to_char(sysdate, 'HH24:MI:SS') as time from dual;
select to_char(sysdate, 'DDD') as DDD from dual;
select to_char(sysdate, 'D') as D from dual;


--2021�� �б⺰ ������ ��
select mem_userid, mem_name, case
    width_bucket(extract(month from mem_regdate), 1, 13, 2)
    when 1 then '��ݱ�'
    else '�Ϲݱ�'
    end as half_year, mem_regdate from tb_member;
    
select mem_userid, mem_name, mem_regdate, to_char(mem_regdate, 'Q') as "�б�" from tb_member;

select to_char(mem_regdate, 'Q') as "�б�", count(mem_idx) as "��" from tb_member
where extract(year from mem_regdate) = 2021 group by to_char(mem_regdate, 'Q') order by "�б�";


/*
    decode() : sql���� ���ǹ�(if)�� ����� �� �ֵ��� ����
    decode(�÷���, ����1, ���1, ����2, ���2, ..)
    - ã�� ���� ���� �� equal ���길 ����(�� ������ �Ұ���)
*/
select * from tb_member;
select mem_userid, mem_name, decode(mem_gender,'����', 'male', '����', 'female') as gender from tb_member;
select mem_userid, mem_name, decode(mem_gender,'����', 'male', '����', 'female', '��') as gender from tb_member;
                                                                            --   ��¦�� �ȸ´� �ϳ��� else!
                                                                            
 
/*
    rank() : �м��Լ�, ������ ǥ���� �� ����ϴ� �Լ�
    - over(order by...) �� �ʼ�
    
    rank() over(����) : ���� ������ ��� 1, 1, 3 �������� ��� (���� ������ �� ������ ���Է¼�)
    row_number() over(����) : ���� ������ ��� 1,2,3 �������� ��� (������ ���Է¼�)
    dense_rank() over(����) : ���� ������ ��� 1, 1, 2 �������� ���
    
*/
select * from tb_member;
select mem_userid, mem_name, mem_point, rank() over(order by mem_point desc) as ranking from tb_member;
select mem_userid, mem_name, mem_point, row_number() over(order by mem_point desc) as ranking from tb_member;
select mem_userid, mem_name, mem_point, dense_rank() over(order by mem_point desc) as ranking from tb_member;


/*
    rownum : ��ȸ�� ������� ������ ����
*/
select rownum, mem_userid, mem_name from tb_member;
select rownum, mem_userid, mem_name, mem_regdate from tb_member order by mem_regdate desc;
select rownum, mem_userid, mem_name, mem_regdate from tb_member where rownum<=3 order by mem_regdate desc; -- ����3������


create table TB_PROFILE(
    PRO_USERID varchar2(20) not null,
    PRO_HEIGHT number(3),
    PRO_WEIGHT number(3),
    PRO_MBTI varchar2(10),
    PRO_BLOOD varchar2(2),
    PRO_ISLOVER char(1),
    constraint FK_PROFILE_USERID foreign key(PRO_USERID) references TB_MEMBER(MEM_USERID)
);

select * from tb_profile;
select * from tb_member;

insert into tb_profile values ('apple', 160, 50, 'ENFJ', 'O', 'N');
insert into tb_profile values ('orange', 155, 45, 'INTP', 'A', 'N');
insert into tb_profile values ('melon', 170, 70, 'ESFP', 'O', 'N');
insert into tb_profile values ('watermelon', 180, 80, 'ABCD','AB', 'N');

-- ���̵�, �̸�, ����, Ű, ������, ��ȥ����
select mem_userid, mem_name, mem_gender, pro_height, pro_blood, pro_islover from tb_member
join tb_profile on tb_member.mem_userid = tb_profile.pro_userid;

-- mem_point ��(��������), rank()
-- ��ŷ, ���̵�, �̸�, ������, mbti
select rank() over(order by mem_point desc) as ranking, mem_userid, mem_name, pro_blood, pro_mbti 
from tb_member join tb_profile on tb_member.mem_userid = tb_profile.pro_userid;

/*
    percent_rank() : �м��Լ�, ������ ������� ǥ��
    over ([partition by], [order by], [windowing])
    partition by : group by�� ����
    windowing : ǥ���� �÷�
*/
select mem_userid, mem_name, mem_point, 
percent_rank() over(partition by mem_gender order by mem_point desc) * 100 as top from tb_member;

-- ���� �����ڵ� �߿��� ������ ������ �ۼ�Ʈ�� ���
-- ���̵�, �̸�, ����, ����Ʈ, ���Գ�¥, ����
select mem_userid, mem_gender, mem_point, mem_regdate, 
percent_rank() over(partition by mem_gender  order by mem_point desc) * 100 as top
from tb_member where extract(year from mem_regdate) = 2021;









































