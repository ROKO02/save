/*
    PL/SQL
    - 관계형 데이터베이스 시스템 오라클 DBMS에서 SQL언어를 확장하기 위해 사용하는 프로그래밍 언어
    - 변수 선언
        변수명 데이터타입 := 값;
        num number := 10;
        str varchar2(20) := 'Hello Oracle!';
    - 상수 선언
        상수명 constant 데이터타입 := 값;
        num constant number := 20;
        
    ? 상수 선언시에는 초기값을 무조건 할당해야 하고, 변수는 선언과 동시에 초기값을 할당하지 않으면
    데티어 타입에 관계없이 null로 설정됨
    
    num number; -- null
    num := 10; -- 10
    
    num constant number; -- error
    
    
    PL/SQL은 선언부, 실행부, 예외처리부로 나눠짐
    - 선언부(declare) : 변수 및 상수의 선언
    - 실행부(begin) : 출력
    - 예외처리부 : 예외 상황이 벌어지면 처리되는 문장(옵션)
*/

set serveroutput on; -- 결과창에 프로그래밍 로그를 출력

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
        dbms_output.put_line('A학점');
    when score >= 80 then
        dbms_output.put_line('B학점');
    when score >= 70 then
        dbms_output.put_line('C학점');
    when score >= 60 then
        dbms_output.put_line('D학점');
    else
        dbms_output.put_line('F학점');
    end case;
end;

/*
    if문
    if 조건문1 then 
        조건문1의 결과가 참일때 실행할 문장;
    elsif 조건문2 then 
        조건문2의 결과가 참일때 실행할 문장;
    ...
    else
        모든 조건문이 거짓일때 실행할 문장;
    end if;
*/
declare
    score number := 82;
begin
    if score >= 90 then
        dbms_output.put_line('A학점');
    elsif score >= 80 then
        dbms_output.put_line('B학점');
    elsif score >= 70 then
        dbms_output.put_line('C학점');
    elsif score >= 60 then
        dbms_output.put_line('D학점');
    else
        dbms_output.put_line('F학점');
    end if;
end;

/*
    loop문
    
    lopp
        반복할 문장;
    exit 조건문; -- 조건문이 true면 종료, exit문이 없으면 무한루프
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
    while문
    while(조건식) -- 조건식에 true인 동안 반복
        loop
            반복할 문장;
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
    for 문
    
    for 변수 in 초기값..최종값
        loop 
            반복할 문장;
        end loop;
*/
begin
    for i in 1..10
        loop
            dbms_output.put_line(i);
        end loop;
end;

/*
    for 문을 이용하여 1~10까지 아래와 같이 출력
    1 홀수;
    2 짝수;
    3 홀수;
    4 짝수;
    ...
    10 짝수;
*/
begin
    for i in 1..10
        loop
            if mod(i, 2) = 0 then
                dbms_output.put_line(i || ' 짝수');
            else
                dbms_output.put_line(i || ' 홀수');
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
    tb_gugudan 2단~9단까지 2중 for문을 사용하여 tb_gugudan 테이블에 데이터를 저장
    (단 gu_idx는 시퀀스로 1부터 중복되지 않는 증가값을 저장)
        gu_idx gu_dan gu_nu gu_result
    예)  1       2       1       2
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
    예외처리(Exception)
    -- 에러에 대한 처리
    -- 컴파일 에러, 런타임 에러
    
    declare
        변수 선언
        예외선언
    begin
        실행문;
        예외발생;
    exception
        when 예외1 then
            처리1
        when 예외2 then
            처리2
        ...
        when others then
            처리n
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
        dbms_output.put_line('오류가 발생했어요!');
end;


