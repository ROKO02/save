/*
    regexp_instr(����ڿ�, ����, [ó�� ������ġ, ���° ��ġ, ��ġ�ϴ� ���ڿ� ������ġ])
    - �����Լ� instr()�� Ȯ���� ������ ���� ǥ������ �̿��� �Էµ� ������ �˻�
    
    ?���� ǥ����
    - ���ڿ��� ��Ÿ�� Ư�� ���� ���հ� �����ϱ� ���� ���Ǵ� ���Ͻ�
    https://ko.wikipedia.org/wiki/%EC%A0%95%EA%B7%9C_%ED%91%9C%ED%98%84%EC%8B%9D
*/
select * from tb_member;
select mem_userid, mem_name, mem_hp, regexp_instr(mem_hp, '[[:digit:]]{4}') as regexp from tb_member;

create table tb_example(
  ex_str varchar2(100)
);

insert into tb_example values('abc123-abc-01');
insert into tb_example values('abb123-abc-02');
insert into tb_example values('acc123-abc-03');
insert into tb_example values('add123-abc-04');
insert into tb_example values('aee123-abc-05');
insert into tb_example values('aff123-abc-06');

select * from tb_example;

-- ���ڿ��� 'bb'�� ��� �ִ� ���� Ȯ��
select ex_str, regexp_instr(ex_str, 'bb', 1) from tb_example;

-- ���ڿ��� 'bb'�� ��� �ִ� ���ڵ常 ���
select ex_str, regexp_instr(ex_str, 'bb', 1) from tb_example where regexp_instr(ex_str, 'bb', 1) > 0;

/*
    regexp_substr(����ڿ�, ����)
    - ���� ǥ���� ������ �����Ͽ� ���ڿ� �Ϻθ� ��ȯ
*/
select * from tb_member;
select mem_userid, mem_name, mem_email, regexp_substr(mem_email, '[^@]+') as email_id from tb_member;

/*
    concat()
    - ���ڿ��� �����ϴ� �Լ�
*/
select * from tb_member;
select mem_userid, mem_name, concat(concat(mem_addr1, mem_addr2), mem_addr3) as addr from tb_member;

select mem_userid, mem_name, concat(mem_addr1||' ', mem_addr2) as addr from tb_member;
select mem_userid, mem_name, concat(concat(mem_addr1, ' '), mem_addr2) as addr from tb_member;

-- ��� ȸ���� �̸��� id�� ��ȯ�Ͽ� @korea.com�� �ٿ� �̸����� ���
-- apple@naver.com -> apple@korea.com���� ����
-- ���̵�, �̸�, �̸���
select mem_userid, mem_name, regexp_substr(mem_email, '[^@]+') || '@korea.com' as email from tb_member;
select mem_userid, mem_name, concat(regexp_substr(mem_email, '[^@]+'), '@korea.com') as email 
from tb_member;

/*
    trim(), ltrim(), rtrim() : ���ڿ����� �����̳� Ư�� ���ڸ� ������ ���� ��ȯ
*/
create table tb_sample(
    sam_str varchar2(20)
);
insert into tb_sample values ('oracle');
insert into tb_sample values ('oracle   ');
insert into tb_sample values (' oracle');
insert into tb_sample values (' oracle  ');

select * from tb_sample;
select '|'||sam_str||'|' from tb_sample;
select '|'||trim(sam_str)||'|' from tb_sample;
select '|'||ltrim(sam_str)||'|' from tb_sample;
select '|'||rtrim(sam_str)||'|' from tb_sample;

/*
    case ��
    
    case 
        ���ǽ�
    when ��1 then ���๮
    whne ��2 then ���๮
    ...
    end
*/
select * from tb_member;
select mem_userid, mem_name, mem_gender,
    case mem_gender
    when '����' then 'male'
    when '����' then 'female'
    end as gender from tb_member;

/*
    lpad(), rpad() : ������ ���̸�ŭ Ư�����ڷ� ä����
    lpad(���ڿ�, �ѹ��ڱ���, ä���� ����) : ���ʿ�������
    rpad(���ڿ�, �ѹ��ڱ���, ä���� ����) : �����ʿ�������
    
    length() : ���ڿ��� ���̸� ��ȯ
*/
select lpad('abcdefghijklmn', 17, '...') from dual;
select rpad('abcdefghijklmn', 17, '...') from dual;
select length('abcdefghijklmn') from dual;

select * from tb_member;

select mem_userid, mem_name, mem_email,
    case when length(mem_email) <= 15 then mem_email
    else rpad(substr(mem_email, 1, 16), 19, '...')
    end as email from tb_member;
    
/*
    ��¥ �Լ�
    extract() : Ư�� ��¥ �����ͷκ��� ���ϴ� ���� ��ȯ
    extract(��(day) �Ǵ� ��(month) �Ǵ� ��(year) from �ʵ��)
*/
select * from tb_member;
select mem_userid, mem_name, mem_gender, mem_regdate, extract(month from mem_regdate) as month from tb_member;
select mem_userid, mem_name, mem_gender, mem_regdate, extract(year from mem_regdate) as year from tb_member;

/*
    �Ҽ��� ���� �Լ�
    ceil() : �ø� ó���� �������� ��ȯ
    round() : ���ڸ� ������ �ڸ����� �ݿø��Ͽ� ��ȯ
    trunc() : ���ڸ� ������ �ڸ����� �����Ͽ� ��ȯ
*/
select ceil(10.6) from dual;
select ceil(-10.5) from dual;
select round(19.854, 1) from dual;
select round(19.854, 2) from dual;
select trunc(10.6) from dual;
select trunc(-10.5) from dual;
select trunc(-10.544, 2) from dual;

-- ������ ���� Ȧ������ ¦������ Ȯ��
-- mod() : ���� ���� ���� �� �������� ��ȯ
-- mod(10, 2) => 0
select mem_name, mem_gender, mem_regdate, extract(month from mem_regdate) as month,
    case mod(extract(month from mem_regdate), 2) 
    when 0 then '¦����'
    else 'Ȧ����'
    end as mod_month from tb_member;









