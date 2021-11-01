/*
    regexp_instr(대상문자열, 패턴, [처음 시작위치, 몇번째 일치, 일치하는 문자열 시작위치])
    - 문자함수 instr()을 확장한 것으로 정규 표현식을 이용해 입력된 문장을 검색
    
    ?정규 표현식
    - 문자열에 나타난 특정 문자 조합과 대응하기 위해 사용되는 패턴식
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

-- 문자열에 'bb'가 들어 있는 값을 확인
select ex_str, regexp_instr(ex_str, 'bb', 1) from tb_example;

-- 문자열에 'bb'가 들어 있는 레코드만 출력
select ex_str, regexp_instr(ex_str, 'bb', 1) from tb_example where regexp_instr(ex_str, 'bb', 1) > 0;

/*
    regexp_substr(대상문자열, 패턴)
    - 정규 표현식 패턴을 적용하여 문자열 일부를 변환
*/
select * from tb_member;
select mem_userid, mem_name, mem_email, regexp_substr(mem_email, '[^@]+') as email_id from tb_member;

/*
    concat()
    - 문자열을 연결하는 함수
*/
select * from tb_member;
select mem_userid, mem_name, concat(concat(mem_addr1, mem_addr2), mem_addr3) as addr from tb_member;

select mem_userid, mem_name, concat(mem_addr1||' ', mem_addr2) as addr from tb_member;
select mem_userid, mem_name, concat(concat(mem_addr1, ' '), mem_addr2) as addr from tb_member;

-- 모든 회원의 이메일 id를 변환하여 @korea.com을 붙여 이메일을 출력
-- apple@naver.com -> apple@korea.com으로 변경
-- 아이디, 이름, 이메일
select mem_userid, mem_name, regexp_substr(mem_email, '[^@]+') || '@korea.com' as email from tb_member;
select mem_userid, mem_name, concat(regexp_substr(mem_email, '[^@]+'), '@korea.com') as email 
from tb_member;

/*
    trim(), ltrim(), rtrim() : 문자열에서 공백이나 특정 문자를 제거한 값을 변환
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
    case 문
    
    case 
        조건식
    when 값1 then 실행문
    whne 값2 then 실행문
    ...
    end
*/
select * from tb_member;
select mem_userid, mem_name, mem_gender,
    case mem_gender
    when '남자' then 'male'
    when '여자' then 'female'
    end as gender from tb_member;

/*
    lpad(), rpad() : 지정한 길이만큼 특정문자로 채워줌
    lpad(문자열, 총문자길이, 채워질 문자) : 왼쪽에서부터
    rpad(문자열, 총문자길이, 채워질 문자) : 오른쪽에서부터
    
    length() : 문자열의 길이를 반환
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
    날짜 함수
    extract() : 특정 날짜 데이터로부터 원하는 값을 반환
    extract(일(day) 또는 월(month) 또는 년(year) from 필드명)
*/
select * from tb_member;
select mem_userid, mem_name, mem_gender, mem_regdate, extract(month from mem_regdate) as month from tb_member;
select mem_userid, mem_name, mem_gender, mem_regdate, extract(year from mem_regdate) as year from tb_member;

/*
    소수점 관련 함수
    ceil() : 올림 처리한 정수값을 반환
    round() : 숫자를 지정한 자리수로 반올림하여 반환
    trunc() : 숫자를 지정한 자리수로 버림하여 반환
*/
select ceil(10.6) from dual;
select ceil(-10.5) from dual;
select round(19.854, 1) from dual;
select round(19.854, 2) from dual;
select trunc(10.6) from dual;
select trunc(-10.5) from dual;
select trunc(-10.544, 2) from dual;

-- 가입한 월이 홀수인지 짝수인지 확인
-- mod() : 값을 나눈 다음 그 나머지를 반환
-- mod(10, 2) => 0
select mem_name, mem_gender, mem_regdate, extract(month from mem_regdate) as month,
    case mod(extract(month from mem_regdate), 2) 
    when 0 then '짝수월'
    else '홀수월'
    end as mod_month from tb_member;









