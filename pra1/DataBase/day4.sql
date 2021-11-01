/*
    update(수정)
    1. update 테이블명 set 컬럼명1=값1, 컬렴명2=값2, ... 
*/
update tb_member set mem_email='test@test.com', mem_hobby='퀵보드 타기';

select * from tb_member;

/*
    오늘의 교훈
    1. 데이터를 소중하게 다루자
        - 백업을 생활화
        - 테스트는 충분히, 테스트는 테스트 서버에서
    2. 책임은 대표가 진다
        - 사원은 실수하면 퇴사하면 됨
*/

alter table tb_member add(
    mem_point number(7) default 0
);

select * from tb_member;

-- 모든 회원에게 포인트 100을 추가함
update tb_member set mem_point = mem_point + 100;

/*
    2. update 테이블명 set 컬렴명1=값1, 컬럼명2=값2, ... where 조건식
*/
update tb_member set mem_email='banan@banana.com', mem_hobby='영화감상' where mem_userid='banana';
select * from tb_member;
update tb_member set mem_email='ryuzy@naver.com', mem_hobby='드라이브' where mem_addr1='서울특별시';

/*
    delete(삭제)
    1. delete from 테이블명;
*/
delete from tb_member;
select * from tb_member;

/*
    2. delete from 테이블명 where 조건식;
*/
delete from tb_member where mem_userid='banana';
select * from tb_member;

/*
    select(검색)
    1. select 컬럼명1, 컬럼명2, ... from 테이블명;
*/
select mem_userid, mem_name, mem_hp from tb_member;
select mem_hp, mem_userid, mem_name from tb_member;
select * from tb_member; -- *(모든컬럼), 부하 발생

/*
    2. select 컬럼명1, 컬럼명2, ... from 테이블명 order by 컬럼명 asc 또는 desc; (asc는 생략 가능)
*/
select mem_userid, mem_name, mem_hp, mem_gender, mem_point from tb_member order by mem_point desc;
select mem_userid, mem_name, mem_hp, mem_gender, mem_point from tb_member order by mem_point desc; -- 포인트 내림차순
select mem_userid, mem_name, mem_hp, mem_gender, mem_point from tb_member order by mem_point; -- 포인트 오름차순
select mem_userid, mem_name, mem_hp, mem_gender from tb_member order by mem_userid; -- userid 오름림차순
select mem_idx, mem_userid, mem_name, mem_hp, mem_gender, mem_point from tb_member order by mem_point desc, mem_idx desc;

/*
    연산자
    산술연산자
    +, -, *, /
*/
    select 5 + 3 from dual;
    select 5 - 3 from dual;
    select 5 * 3 from dual;
    select 5 / 3 from dual;
    select 5+3, 5-3, 5*3, 5/3 from dual;
    select 5+3 as "덧셈", 5-3 as "뺄셈", 5*3 as "곱셈", 5/3 as "나눗셈" from dual;
    select 5+3 "덧셈", 5-3 "뺄셈", 5*3 "곱셈", 5/3 "나눗셈" from dual;

/*
    비교연산자 where절 조건
    = : 같다
    != : 다르다
    < : 크다
    > : 작다
    >= : 크거나 같다
    <= : 작거나 같다
*/
select 3 > 2 from dual; -- 열에서 사용
select mem_userid, mem_name, mem_hp from tb_member where mem_userid = 'apple';
select mem_userid, mem_name, mem_hp from tb_member where mem_userid != 'apple';
select mem_userid, mem_name, mem_hp, mem_point from tb_member where mem_point > 100;
-- 성별이 '남자'가 아닌 회원 출력(아이디, 이름, 성별, 전화번호)
select mem_userid, mem_name, mem_gender, mem_hp from tb_member where mem_gender != '남자';
select mem_userid, mem_name, mem_hobby from tb_member where mem_hobby='(null)'; -- ??
select mem_userid, mem_name, mem_hobby from tb_member where mem_hobby=(null); -- ??
select mem_userid, mem_name, mem_hobby from tb_member where mem_hobby='null'; -- ??
select mem_userid, mem_name, mem_hobby from tb_member where mem_hobby=null; -- ??
select mem_userid, mem_name, mem_hobby from tb_member where mem_hobby=''; -- ??
select mem_userid, mem_name, mem_hobby from tb_member where mem_hobby is null;

/*
    논리연산자
    and : 두 조건식의 결과가 모두 참일 때 참
    예) 모든 과목의 평균점수가 60점 이상 그리고 각 과목당 10점 미안의 점수가 있으면 안됨
    or : 두 조건식의 결과 중 하나라도 참일 때 참
    예) 중국집에서 짜장 또는 짬뽕을 시킬꺼야 
    not : 결과를 반대로 출력
*/
select mem_userid, mem_name from tb_member where mem_userid='apple' and mem_userpw='1111';
select * from tb_member;
select mem_userid, mem_name from tb_member where mem_userid='melon' or mem_userid='cherry';
select mem_userid, mem_name from tb_member where mem_userid='melon' or mem_userid='dog';
-- 취미가 있는 회원
select mem_userid, mem_name, mem_hobby from tb_member where mem_hobby is not null;

select mem_userid, mem_name, mem_hp, mem_point from tb_member where not mem_point > 100;

-- 이메일의 값이 없거나 포인트가 100보다 작거나 같은 회원을 출력(아이디, 이름, 이메일, 포인트)
select mem_userid, mem_name, mem_email, mem_point from tb_member where mem_email is null or mem_point <= 100;

