-- 조회 생성 수정 삭제



--1. 출결조회, 공휴일테이블
-- 조회
-- 학생이 다니는 날짜 지정
create or replace view vwDate
as
select
    to_date('2024-07-03', 'yyyy-mm-dd') + level - 1 as regdate
from dual
    connect by level <= (to_date('2025-01-03', 'yyyy-mm-dd')
                            - to_date('2024-07-03', 'yyyy-mm-dd') + 1);
---------------------------------------------------          
drop view vwDate;

select * from vwDate;  --1번학생 2024-07-03~2025-01-03 의 모든 날짜
select * from attendance; -- 1번학생(7월) 근태 기록
select * from holiday;
select * from student;

--1번 학생이름,날짜,공휴일,주말 조회------------------------------
select 
    v.regdate as "날짜",
    case
        when to_char(v.regdate, 'd') = '1' then '일요일'
        when to_char(v.regdate, 'd') = '7' then '토요일'
        when h.holidayseq is not null then h.holidayname
        when h.holidayseq is null and t.attendanceseq is null then '결석'
        else t.attendancest
    end as "상태"
from vwDate v
    left outer join attendance t
        on to_char(v.regdate, 'yyyy-mm-dd') = to_char(t.attendancedate, 'yyyy-mm-dd')
            left outer join holiday h
                on to_char(v.regdate, 'yyyy-mm-dd') = to_char(h.holidaydate, 'yyyy-mm-dd')
                    order by v.regdate asc;
---------------------------------------------------------------
-- 공휴일추가하기(학원쉬는날)
select * from holiday;
INSERT INTO holiday VALUES (holiday_seq.nextval,'2024-07-15','학원휴일');
update holiday set holidayname = '쉬는날' where holidayseq=16;
delete from holiday where holidayseq = 16;

 
rollback;





-- 10 학생 지원금 전체 조회
select * from money;
select * from student;

select s.studentname as "학생이름", 
    to_char(m.moneymonth,'yyyy-mm') as "년도 - 월",
    receivedmoney as "지원금"
from money m
    inner join student s
        on s.studentseq = m.studentseq
            where m.studentseq=1;
            
            
           
--9.강사평 추가 조회
select * from tgrade;
select * from teacher;

--강사별 평균 평점 조회
select 
    t.teachername as "교사명",
    round(avg(g.tgradescore),1) as "교사평균평점"
from tgrade g
    inner join teacher t
        on t.teacherseq = g.teacherseq
            group by t.teachername;
            
            
--강사 평점 추가하기
INSERT INTO tGrade VALUES (tGrade_seq.nextval,1,27,9,'강의 내용이 잘 정리되어 있고, 실습을 통해 쉽게 이해할 수 있었습니다.');
update TGRADE set TGRADERW = '너무 좋아요' where TGRADESEQ=1;
delete from TGRADE where TEACHERSEQ = 1;

ROLLBACK;      

            
            
           
--8.학생평 추가 조회
select * from Sgrade;
select * from STUDENT;
SELECT * FROM TEST;
SELECT * FROM STUDENTCLS;
SELECT * FROM PROCESS;

-- 학생 전체 시험 점수 평균 구하기
SELECT 
    ST.STUDENTNAME, 
    ROUND(AVG(SC.TOTALSCORE), 1) AS AVG_SCORE 
FROM STUDENT ST
    INNER JOIN SCORE SC
        ON ST.STUDENTSEQ = SC.STUDENTSEQ
GROUP BY ST.STUDENTNAME; 

    
SELECT * FROM SGRADE;
    
ROLLBACK;

--UPDATE
UPDATE SGRADE G
SET SGRADESCORE = (
    SELECT ROUND(AVG(SC.TOTALSCORE), 1)
    FROM SCORE SC
    WHERE SC.STUDENTSEQ = G.STUDENTSEQ
)
WHERE EXISTS (
    SELECT 1 FROM SCORE SC WHERE SC.STUDENTSEQ = G.STUDENTSEQ
);

            
--학생 평점 추가하기
INSERT INTO sGrade VALUES (sGrade_Seq.nextval,6,1,null,'문제 해결 능력이 뛰어나며 창의적인 접근 방식을 갖춘 학생입니다.');
update SGRADE set SGRADERW = '너무 좋아요' where SGRADESEQ=1;
delete from SGRADE where SGRADESEQ=1;

ROLLBACK;     



--SQL쿼리문
-- B02

--과정명 관리
--1. 입력
insert into Course(courseSeq,courseName) values (course_seq.NEXTVAL, q'[AWS와 Docker & Kubernetes를 활용한 Java Full-Stack 개발자 양성과정]');


--2. 출력
SELECT COURSENAME AS "과정명" 
FROM COURSE;




