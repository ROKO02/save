/*
    camle case : 두 단어가 합쳐질때 뒤 단어의 첫문자는 대문자로 작성
    예) num, numKor
    snake case : 기본은 대문자로 작성, 두 단어가 합쳐질때_를 사용하여 연결
    예) MEMBER, TB_MEMBER
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


-- 데이터 확인
select * from tb_member;

/*
    테이블 삭제
    drop table 테이블명;
*/
-- 테이블 삭제
drop table tb_member;

/*
    테이블 수정
    1. 컬럼 추가
        alter table 테이블명 add(
                컬럼명 자료형 제약조건  
        )
*/
alter table tb_member add(
    mem_gender varchar(6)
);

/*
    2. 컬럼 수정
    alter table 테이블명 modify(
        컬럼명 자료형 제약조건
    );
*/
alter table tb_member modify(
    mem_gender varchar2(6) check(mem_gender in ('남자', '여자'))
);
/*
    3. 컬럼 삭제
    alter table 테이블명 drop(
        컬럼명
    );
*/
alter table tb_member drop(
    mem_gender
);

/*
    테이블명 수정
    alter table 테이블명 rename to 변경할 테이들명;
*/
alter table tb_member rename to tb_user;

select * from tb_member;
select * from tb_user;

alter table tb_user rename to tb_member;

/*
    컬럼명 수정
    alter table 테이블명 rename column 컬럼명 to 변경할 컬럼명;
*/
alter table tb_member rename column mem_hp to mem_tel;
alter table tb_member rename column mem_tel to mem_hp;

/*
    insert(삽입)
    1. 
    insert into 테이블명 (컬럼명1, 컬럼명2, ...) vlaues (값1, 값2, ...);
*/
INSERT INTO tb_member (mem_idx, mem_userid, mem_userpw, mem_name, mem_hp, mem_email, mem_hobby, mem_ssn1,
    mem_ssn2, mem_zipcode, mem_addr1, mem_addr2, mem_addr3, mem_regdate) 
    VALUES (1, 'apple', '1111', '김사과', '010-1111-1111', 'apple@apple.com', '드라이브',
    '001011', '4068518', '12345', '서울특별시', '서초구', '양제동', sysdate);

select * from tb_member;

--userid 변경해서 다시 삽입 -> mem_idx unique 
INSERT INTO tb_member (mem_idx, mem_userid, mem_userpw, mem_name, mem_hp, mem_ssn1, mem_ssn2, 
mem_zipcode, mem_addr1) 
    VALUES (2, 'banana', '2222', '반하나', '010-2222-2222', '001011', '4012345', '12345'
    ,'서울특별시');

select * from tb_member;


/*
    2.
    insert into 테이블명 values (값1, 값2, ...)
*/

INSERT INTO tb_member VALUES (3, 'orange', '3333', '오렌지', '010-3333-3333', 'orange@orange.com', '등산',
    '001011', '3068518', '12345', '서울특별시', '서초구', '반포동', sysdate);

select * from tb_member;

-- null : 데이터가 없음
INSERT INTO tb_member VALUES (4, 'melon', '4444', '이메론', '010-4444-4444', null, null,
    '001011', '3068518', '12345', '서울특별시', null, null, null);

alter table tb_member add(
    mem_gender varchar(6) check(mem_gender in ('남자', '여자'))
);

-- 값의 수가 충분하지 않습니다
INSERT INTO tb_member VALUES (5, 'cherry', '5555', '김체리', '010-5555-5555', null, null,
    '001011', '4068518', '12345', '서울특별시', null, null, null);
    
-- 체크 제약조건에 null을 삽입
INSERT INTO tb_member VALUES (5, 'cherry', '5555', '김체리', '010-5555-5555', null, null,
    '001011', '4068518', '12345', '서울특별시', null, null, null, null);
    
-- 체크 제약조건(ADMIN.SYS_C0023493)이 위배
INSERT INTO tb_member VALUES (6, 'watermelon', '6666', '박수박', '010-6666-6666', null, null,
    '001011', '3068518', '12345', '서울특별시', null, null, null, '남');

INSERT INTO tb_member VALUES (6, 'watermelon', '6666', '박수박', '010-6666-6666', null, null,
    '001011', '3068518', '12345', '서울특별시', null, null, null, '남자');

select * from tb_member;












