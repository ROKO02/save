/*
    PL/SQL
    - ������ �����ͺ��̽� �ý��� ����Ŭ DBMS���� SQL�� Ȯ���ϱ� ���� ����ϴ� ���α׷��� ���
    - ���� ����
        ������ ������Ÿ�� := ��;
        num number := 10;
        str varchar2(20) := 'Hello Oracle!';
    - ��� ����
        ����� constant ������Ÿ�� := ��;
        num constant number := 20;
        
    ? ��� ����ÿ��� �ʱⰪ�� ������ �Ҵ��ؾ� �ϰ�, ������ ����� ���ÿ� �ʱⰪ�� �Ҵ����� ������
    ��Ƽ�� Ÿ�Կ� ������� null�� ������
    
    num number; -- null
    num := 10; -- 10
    
    num constant number; -- error
    
    
    PL/SQL�� �����, �����, ����ó���η� ������
    - �����(declare) : ���� �� ����� ����
    - �����(begin) : ���
    - ����ó���� : ���� ��Ȳ�� �������� ó���Ǵ� ����(�ɼ�)
*/

set serveroutput on; -- ���â�� ���α׷��� �α׸� ���

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
        dbms_output.put_line('A����');
    when score >= 80 then
        dbms_output.put_line('B����');
    when score >= 70 then
        dbms_output.put_line('C����');
    when score >= 60 then
        dbms_output.put_line('D����');
    else
        dbms_output.put_line('F����');
    end case;
end;

/*
    if��
    if ���ǹ�1 then 
        ���ǹ�1�� ����� ���϶� ������ ����;
    elsif ���ǹ�2 then 
        ���ǹ�2�� ����� ���϶� ������ ����;
    ...
    else
        ��� ���ǹ��� �����϶� ������ ����;
    end if;
*/
declare
    score number := 82;
begin
    if score >= 90 then
        dbms_output.put_line('A����');
    elsif score >= 80 then
        dbms_output.put_line('B����');
    elsif score >= 70 then
        dbms_output.put_line('C����');
    elsif score >= 60 then
        dbms_output.put_line('D����');
    else
        dbms_output.put_line('F����');
    end if;
end;

/*
    loop��
    
    lopp
        �ݺ��� ����;
    exit ���ǹ�; -- ���ǹ��� true�� ����, exit���� ������ ���ѷ���
*/
declare
    num number;
begin 
    loop 
        dbms_output.put_line(num);
        num := num + 1;
    exit when num > 10;
    end loop;
end;

/*
    while��
    while(���ǽ�) -- ���ǽĿ� true�� ���� �ݺ�
        loop
            �ݺ��� ����;
            ...
        end loop;
*/
declare
    num number := 1;
begin 
    while(num <= 10)
        loop
            dbms_output.put_line(num);
            num := num + 1;
        end loop;
end;


/*
    7 * 1 = 7
    7 * 2 = 14
    ...
    7 * 9 = 53
*/
declare
    dan number := 7;
    num number := 1;
begin
    while(num < 10)
    loop
        dbms_output.put_line
        (dan || ' * ' || num || ' = ' || dan*num);
        num := num + 1;
    end loop;
end;

/*
    for ��
    
    for ���� in �ʱⰪ..������
        loop 
            �ݺ��� ����;
        end loop;
*/
begin
    for i in 1..10
        loop
            dbms_output.put_line(i);
        end loop;
end;

/*
    for ���� �̿��Ͽ� 1~10���� �Ʒ��� ���� ���
    1 Ȧ��;
    2 ¦��;
    3 Ȧ��;
    4 ¦��;
    ...
    10 ¦��;
*/
begin
    for i in 1..10
        loop
            if mod(i, 2) = 0 then
                dbms_output.put_line(i || ' ¦��');
            else
                dbms_output.put_line(i || ' Ȧ��');
            end if;
        end loop;
end;

/*
    for i in 1..5
        loop
            for j in 1..3
                loop
                    dbms_output.put_line(i || ' ' ||  j');
                end loop;
        end loop
*/

create table tb_gugudan(
    gu_idx number(3) primary key,
    gu_dan number(2) not null,
    gu_num number(2) not null,
    gu_reseult number(3) not null
);

/*
    tb_gugudan 2��~9�ܱ��� 2�� for���� ����Ͽ� tb_gugudan ���̺� �����͸� ����
    (�� gu_idx�� �������� 1���� �ߺ����� �ʴ� �������� ����)
        gu_idx gu_dan gu_nu gu_result
    ��)  1       2       1       2
         2       2       2       4
*/
create sequence seq_gugu_idx
    start with 1
    increment by 1;

declare
    begin
        for dan in 2..9
            loop
                for num in 1..9
                    loop
                        insert into tb_gugudan values (seq_gugu_idx.nextval, dan , num, dan*num);
                    end loop;
            end loop;
    end;

select * from tb_gugudan;

/*
    ����ó��(Exception)
    -- ������ ���� ó��
    -- ������ ����, ��Ÿ�� ����
    
    declare
        ���� ����
        ���ܼ���
    begin
        ���๮;
        ���ܹ߻�;
    exception
        when ����1 then
            ó��1
        when ����2 then
            ó��2
        ...
        when others then
            ó��n
    end;
*/
declare
    num number := 0;
begin
    num := 10 / num;
exception
    when ZERO_DIVIDE then
        num := 0;
        dbms_output.put_line(num);
    when others then
        dbms_output.put_line('������ �߻��߾��!');
end;


