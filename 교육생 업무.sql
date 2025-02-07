--교육생 업무


/* D-01 교육생 로그인 기능 */
/* 조회 */
create or replace view vwStudentLogin
as
select
    s.studentname as "학생 이름",
    s. studentpw as "비밀번호",
    s.studenttel as "학생의 전화번호",
    s.studentdate as "학생의 등록일",
    c.coursename as "과정명",
    p.processsdate as "과정 시작일",
    p.processedate as "과정 종료일",
    cr.clsroomname as "강의실"
from student s
    inner join studentcls sc
        on s.studentseq = sc.studentseq
            inner join process p
                on sc.processseq = p.processseq
                    inner join course c
                        on c.courseseq = p.courseseq
                            inner join clsroom cr
                                on cr.clsroomseq = p.clsroomseq
                                    where s.studentseq=1;
                    
                    
select * from vwstudentlogin;



/* D-02 교육생 개인성적정보 확인기능 */
/* 조회 */
-- 조회하는 학생 번호가 27
create or replace view vwStudentInfo
as
select
    pc.subjectseq as 과목번호,
    sj.subjectname as 과목명,
    pc.prcsubjectsdate||' ~ '||pc.prcsubjectedate as "과목 진행 기간",
    b.bookname as 교재명,
    t.teachername as 교사명,
    sa.attendallot as "배점정보:출석",
    sa.writingallot as "배점정보:필기",
    sa.realallot as "배점정보:실기",
    score.attendancescore as 출석점수,
    CASE 
        WHEN test.testtype = '실기' THEN score.realscore
        WHEN test.testtype = '필기' THEN score.writingscore
        ELSE 0
    END  "과목 성적",
    test.testtype as 시험유형,
    test.testdate as 시험날짜,
    test.testcontext as 시험문제
from prcsubject pc
    inner join subject sj on sj.subjectseq = pc.subjectseq
    inner join sbjectbook sb on sb.subjectseq = pc.subjectseq
    inner join book b on b.bookseq = sb.bookseq
    inner join process p on p.processseq = pc.processseq
    inner join teacher t on t.teacherseq = p.teacherseq
    inner join scoreallot sa  on sa.prcsubjectseq=pc.prcsubjectseq
    inner join test on test.teacherseq = t.teacherseq and pc.subjectseq=test.subjectseq
    inner join studentcls scl on scl.processseq = p.processseq
    inner join student st on st.studentseq =scl.studentseq
    inner join score on score.subjectseq=pc.subjectseq and score.studentseq = st.studentseq
where st.studentseq=27 
    and pc.processseq=(select processseq from studentcls where studentseq=27) --과정번호 2임
    and test.teacherseq=(select teacherseq from process where processseq = (select processseq from studentcls where studentseq=27))-- 교사번호가 1임
    and test.testdate BETWEEN p.processsdate AND p.processedate;
    
    
    
select * from vwstudentInfo;
---------------------------------------------------------------


select * from attendance where studentseq=1 and attendancedate = sysdate;
delete from attendance where studentseq=1 and attendancedate = sysdate;
/* D-03 교육생 출결관리 기능 */
/* 1번 학생의 등원 추가 */
INSERT INTO attendance 
VALUES (
    attendance_seq.nextval, 
    1, --학생등원
    1, --교육과정
    TRUNC(SYSDATE),  -- 날짜 (시간 00:00:00 초기화)
    SYSDATE,         -- 현재 시간으로 출근 기록
    NULL,            -- 퇴근 시간은 아직 없음
    '출석'
);



/* 수업종료 */
UPDATE attendance
SET attendanceetime = SYSDATE,   -- 현재 시간으로 퇴근 기록
    attendancest = '정상'       -- 상태 변경
WHERE studentseq = 1 
  AND attendancedate = TRUNC(SYSDATE)  -- 오늘 날짜의 출석 기록만 수정
  AND attendanceetime IS NULL;      -- 아직 퇴근 기록이 없는 경우


/* 오늘의 출결 상태 보기 */
create or replace view vwTodayAttendance
as
select 
    attendancedate as "오늘 날짜", 
    TO_char(attendancestime, 'HH24:MI') as "등원 시간",
    to_char(attendanceetime, 'HH24:MI') as "하원 시간"
from attendance where attendancedate=to_char(SYSDATE) AND PROCESSSEQ=1;

select * from vwTodayAttendance;




/* D-04 교육생 출결조회 기능 */
/* 조회 */
/* 다닌날 전체 조회 */


/* 날짜 뷰 만들기*/
create or replace view vwTotalDate
as
select
    to_date('2024-07-03', 'yyyy-mm-dd') + level - 1 as regdate
from dual
    connect by level <= (to_date('2025-08-03', 'yyyy-mm-dd')
                            - to_date('2024-07-03', 'yyyy-mm-dd') + 1);
                            
SELECT * FROM VWTOTALDATE;


/* 1번 학생 날짜 별 출결 뷰 만들기*/
create or replace view vwStudentTotalDate
as
select 
    v.regdate as "날짜",
    TO_char(t.attendancestime, 'HH24:MI') as "등원 시간",
    to_char(t.attendanceetime, 'HH24:MI') as "하원 시간",
    case
        when to_char(v.regdate, 'd') = '1' then '일요일'
        when to_char(v.regdate, 'd') = '7' then '토요일'
        when h.holidayseq is not null then h.holidayname
        when h.holidayseq is null and t.attendanceseq is null then '결석'
        else t.attendancest
    end as "상태"
from vwTotalDate v
    left outer join attendance t
        on to_char(v.regdate, 'yyyy-mm-dd') = to_char(t.attendancedate, 'yyyy-mm-dd')
        AND T.STUDENTSEQ=1
            left outer join holiday h
                on to_char(v.regdate, 'yyyy-mm-dd') = to_char(h.holidaydate, 'yyyy-mm-dd')
                    order by v.regdate asc;


select * from vwStudenttOTALDate;
                       
/*7월 조회*/
create or replace view vwMonth
as
select
    to_date('2024-07-03', 'yyyy-mm-dd') + level - 1 as regdate
from dual
    connect by level <= (to_date('2024-07-31', 'yyyy-mm-dd')
                            - to_date('2024-07-03', 'yyyy-mm-dd') + 1);

create or replace view vwStudentMonth
as
select 
    v.regdate as "날짜",
    TO_char(t.attendancestime, 'HH24:MI') as "등원 시간",
    to_char(t.attendanceetime, 'HH24:MI') as "하원 시간",
    case
        when to_char(v.regdate, 'd') = '1' then '일요일'
        when to_char(v.regdate, 'd') = '7' then '토요일'
        when h.holidayseq is not null then h.holidayname
        when h.holidayseq is null and t.attendanceseq is null then '결석'
        else t.attendancest
    end as "상태"
from vwMonth v
    left outer join attendance t
        on to_char(v.regdate, 'yyyy-mm-dd') = to_char(t.attendancedate, 'yyyy-mm-dd')
            left outer join holiday h
                on to_char(v.regdate, 'yyyy-mm-dd') = to_char(h.holidaydate, 'yyyy-mm-dd')
                    WHERE t.studentseq=1 
                    order by v.regdate asc;              

select * from vwStudentMonth;                    


                    
/* 특정 날짜 조회 */
create or replace view vwDate
as
select
    to_date('2024-07-03', 'yyyy-mm-dd') regdate
from dual;


create or replace view vwStudentDate
as
select
    v.regdate as "날짜",
    TO_char(t.attendancestime, 'HH24:MI') as "등원 시간",
    to_char(t.attendanceetime, 'HH24:MI') as "하원 시간",
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
                WHERE t.studentseq=1 
                    order by v.regdate asc;   
                    
select * from vwStudentDate; 