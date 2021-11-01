/*
    width_bucket(값, 최소값, 최대값(<), 버킷): 최소값과 최대값을 설정하고 버킷을 설정한 다음 지정한 값이 어느 위치에 있는지를 반환
    width_bucket(70, 1, 101, 2) -> 2
                     ㄴ1부터 100까지 2개로 쪼갰을때 70은 어디에 있니? 2개중에 2로..
    width_bucket(43, 1, 101, 4) -> 2
*/

--2021년 상반기, 하반기에 가입한 회원 수
select * from tb_member;
select mem_userid, mem_name, case
    width_bucket(extract(month from mem_regdate), 1, 13, 2)
    when 1 then '상반기'
    else '하반기'
    end as half_year, mem_regdate from tb_member;
                    -- ㄴ그냥뽑을때 같이 보려고!
    
select case
    width_bucket(extract(month from mem_regdate), 1, 13, 2)
    when 1 then '상반기'
    else '하반기'
    end as half_year, count(mem_idx) as count from tb_member where extract(year from mem_regdate) = 2021
    group by width_bucket(extract(month from mem_regdate), 1, 13, 2);
    

/*
    sysdate : 현재 날짜
    add_months() : 특정 날짜의 월에 정수를 더한 다음 해당 날짜를 반환
    months_between() : 날짜 간의 차이를 월로 반환
*/
select sysdate from dual;
select sysdate + 100 from dual;
select add_months(sysdate, 1) from dual;

-- 회원의 가입날짜와 현재날와의 차이(달)를 출력
-- 아이디, 이름, 현재날짜, 가입날짜, 차이
select mem_userid, mem_name, sysdate as today, mem_regdate, floor(months_between(sysdate, mem_regdate)) as month from tb_member;


/*
    to_char() : 날짜를 문자형 데이터로 변환
    to_char(날짜, 포멧)
    포멧
    D : 주(1~7) 1은 일요일, 7은 토요일
    DD : 일(1~31)
    DDD : 1년 중 날짜 (1~365)
    HH24 : 시간(0~23)
    IW : 1년 중 몇 주(1~53)
    MI : 분(0~59)
    SS : 초(0~59)
    MM : 월(01~12)
    Q  : 분기(1,2,3,4)
    YYYY : 년
    W : 월 중 몇주(1~5)
*/

select to_char(sysdate, 'HH24:MI:SS') as time from dual;
select to_char(sysdate, 'DDD') as DDD from dual;
select to_char(sysdate, 'D') as D from dual;


--2021년 분기별 가입자 수
select mem_userid, mem_name, case
    width_bucket(extract(month from mem_regdate), 1, 13, 2)
    when 1 then '상반기'
    else '하반기'
    end as half_year, mem_regdate from tb_member;
    
select mem_userid, mem_name, mem_regdate, to_char(mem_regdate, 'Q') as "분기" from tb_member;

select to_char(mem_regdate, 'Q') as "분기", count(mem_idx) as "수" from tb_member
where extract(year from mem_regdate) = 2021 group by to_char(mem_regdate, 'Q') order by "분기";


/*
    decode() : sql문에 조건문(if)을 사용할 수 있도록 제공
    decode(컬럼명, 조건1, 결과1, 조건2, 결과2, ..)
    - 찾는 값을 비교할 때 equal 연산만 가능(비교 연산은 불가능)
*/
select * from tb_member;
select mem_userid, mem_name, decode(mem_gender,'남자', 'male', '여자', 'female') as gender from tb_member;
select mem_userid, mem_name, decode(mem_gender,'남자', 'male', '여자', 'female', '모름') as gender from tb_member;
                                                                            --   ㄴ짝이 안맞는 하나는 else!
                                                                            
 
/*
    rank() : 분석함수, 순위를 표현할 때 사용하는 함수
    - over(order by...) 는 필수
    
    rank() over(정렬) : 동일 순위인 경우 1, 1, 3 형식으로 출력 (같은 조건일 때 데이터 선입력순)
    row_number() over(정렬) : 동일 순위인 경우 1,2,3 형식으로 출력 (데이터 선입력순)
    dense_rank() over(정렬) : 동일 순위인 경우 1, 1, 2 형식으로 출력
    
*/
select * from tb_member;
select mem_userid, mem_name, mem_point, rank() over(order by mem_point desc) as ranking from tb_member;
select mem_userid, mem_name, mem_point, row_number() over(order by mem_point desc) as ranking from tb_member;
select mem_userid, mem_name, mem_point, dense_rank() over(order by mem_point desc) as ranking from tb_member;


/*
    rownum : 조회된 순서대로 순번을 적용
*/
select rownum, mem_userid, mem_name from tb_member;
select rownum, mem_userid, mem_name, mem_regdate from tb_member order by mem_regdate desc;
select rownum, mem_userid, mem_name, mem_regdate from tb_member where rownum<=3 order by mem_regdate desc; -- 순위3번까지


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

-- 아이디, 이름, 성별, 키, 혈액형, 결혼유무
select mem_userid, mem_name, mem_gender, pro_height, pro_blood, pro_islover from tb_member
join tb_profile on tb_member.mem_userid = tb_profile.pro_userid;

-- mem_point 순(내림차순), rank()
-- 랭킹, 아이디, 이름, 혈액형, mbti
select rank() over(order by mem_point desc) as ranking, mem_userid, mem_name, pro_blood, pro_mbti 
from tb_member join tb_profile on tb_member.mem_userid = tb_profile.pro_userid;

/*
    percent_rank() : 분석함수, 순위를 백분율로 표현
    over ([partition by], [order by], [windowing])
    partition by : group by와 동일
    windowing : 표현할 컬럼
*/
select mem_userid, mem_name, mem_point, 
percent_rank() over(partition by mem_gender order by mem_point desc) * 100 as top from tb_member;

-- 올해 가입자들 중에서 성별별 순위를 퍼센트로 출력
-- 아이디, 이름, 성별, 포인트, 가입날짜, 순위
select mem_userid, mem_gender, mem_point, mem_regdate, 
percent_rank() over(partition by mem_gender  order by mem_point desc) * 100 as top
from tb_member where extract(year from mem_regdate) = 2021;









































