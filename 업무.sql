/*  공휴일  */

/*추가*/
select * from holiday;
INSERT INTO holiday VALUES (holiday_seq.nextval,'2024-07-15','학원휴일');

/*조회*/
create or replace view vwDate
as
select
    to_date('2024-07-03', 'yyyy-mm-dd') + level - 1 as regdate
from dual
    connect by level <= (to_date('2025-01-03', 'yyyy-mm-dd')
                            - to_date('2024-07-03', 'yyyy-mm-dd') + 1);

create or replace view vwDate2
as
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
                where t.studentseq=1
                    order by v.regdate asc;
                    
select * from vwDate2;
select * from attendance;

/*수정*/
update holiday set holidayname = '쉬는날' where holidayseq=16;

/*삭제*/
delete from holiday where holidayseq = 16;




/*  해당 학생자격증관련 기업 목록  */

/*조회*/
select 
    e.enterName as "기업명", 
    e.enterBuseo as "업무 내용", 
    e.enterLocation as "회사 위치", 
    e.enterSalary as "평균 연봉"
from studentCrtf sc
inner join student s on sc.studentSeq = s.studentSeq
inner join crtf c on c.crtfSeq = sc.crtfSeq
inner join enter e on c.crtfSeq = e.crtfSeq
where s.studentName = '강나라';




/*  기업  */

/*추가*/
insert into enter values (enter_Seq.NEXTVAL,1,5,'에이비일팔공','모바일 개발','인천',6601);

/*조회*/
select * from enter;

/*수정*/
update enter set enterName = '카카오', enterBuseo = '모바일', enterLocation = '서울', enterSalary = 6600  where enter_Seq=1;

/*삭제*/
delete from enter where enterSeq = 1;






/*  자격증 종류  */

/*추가*/
insert into crtf values (4, '컴퓨터시스템응용기술사', '한국산업인력공단');

/*조회*/
select * from crtf;

/*수정*/
update crtf set crtf = '자격증명', crtfService = '인증기관' where crtfSep = 1;
update crtf set crtf = '' where crtfSep = 1;

/*삭제*/
delete from Crtf where CrtfSeq = 1;






/*  교육생의 이름과 자격증  */

/*조회*/
select 
    s.studentName as "학생 이름", 
    c.crtfName as "보유한 자격증"
from studentCrtf sc 
inner join crtf c on sc.crtfSeq = c.crtfSeq
inner join student s on s.studentSeq = sc.studentSeq;






/*  교육생의 자격증  */

/*추가*/
INSERT INTO studentCrtf VALUES (studentCrtf_Seq.NEXTVAL,1,1,to_date('2024-12-10','YYYY-MM-DD'));

/*조회*/
select * from studentCrtf;

/*수정*/
update studentCrtf set crtfSeq = 1, studentSeq = 1, studentCrtfDate = '2024-12-12' where studentCrtfSeq = 1;

/*삭제*/
delete from studentCrtf where studentCrtfSeq = 1;





/*  해당학생(김가현) 프로젝트 사용스택 관련 기업  */

/*조회*/
select 
    e.enterName as "회사이름", 
    e.enterBuseo as "업무 내용", 
    t.techName as "사용하는 주요 기술"
from project p
inner join enter e on e.techSeq = p.techSeq
inner join tech t on e.techSeq = t.techSeq
inner join team te on te.teamSeq = p.teamSeq
inner join student s on s.studentSeq = te.studentSeq
where s.studentname = '김가현';




/*  프로젝트  */

/*추가*/
INSERT INTO project VALUES (project_seq.nextVal,1,1,'전설을 담는 코딩 챌린지 플랫폼','2024-07-11','사용자들이 서로 코딩 문제를 출제하고, 해결하여 순위를 겨루는 플랫폼으로, 경쟁과 학습을 동시에 제공합니다.');

/*조회*/
select * from project;

/*수정*/
update project set teamSeq = 1, techSeq = 1, projectName = '프로젝트명', projectDate = '2024-07-11', projectContent ='프로젝트설명' where projectSeq = 1;

/*삭제*/
delete from project where projectSeq = 1;






/*  교육생자격증 & 프로젝트사용스택 관련 기업  */

/*조회*/
select 
    e.enterName as "회사명" , 
    e.enterBuseo as "업무내용", 
    t.techName as "사용하는 주요 기술"
from project p
inner join enter e on e.techSeq = p.techSeq
inner join tech t on e.techSeq = t.techSeq
inner join team te on te.teamSeq = p.teamSeq
inner join student s on s.studentSeq = te.studentSeq
inner join studentCrtf sc on sc.studentSeq = s.studentSeq
inner join crtf c on c.crtfSeq = sc.crtfSeq
where s.studentname = '홍성준';






/*  과정평가  */

/*추가*/
INSERT INTO cGrade VALUES (cGrade_Seq.nextval,1,1,10,'기초부터 탄탄하게 배울 수 있어 웹 개발이 쉬워졌어요.');

/*조회*/
select * from cGrade;

/*수정*/
update cGrade set processSeq = 1, studentSeq = 1, cgradescore = 10, sgraderw ='강의평' where cGradeSeq = 1;

/*삭제*/
delete from cGrade where cGradeSeq = 1;





/*  과정평가전체  */

/*조회*/
select 
    c.courseName as "과정명", 
    cg.cGradeScore as "평가 점수", 
    cg.cGradeRw as "평가 내용" 
from cGrade cg
inner join process p on p.processSeq = cg.processSeq
inner join course c on p.courseSeq = c.courseSeq;







/*  특정과정평가전체  */

/*조회*/
select 
    cg.cGradeScore as "점수", 
    cg.cGradeRw as "평가 내용" 
from cGrade cg
inner join process p on p.processSeq = cg.processSeq
inner join course c on p.courseSeq = c.courseSeq
where p.processSeq = 7;







/*  과정별 평균평점  */

/*조회*/
select 
    cg.processSeq as "번호", 
    c.courseName as "과정명", 
    round(avg(cg.cGradeScore),2) as "과정평가 평균점수"
from cGrade cg
inner join process p on p.processSeq = cg.processSeq
inner join course c on p.courseSeq = c.courseSeq
group by cg.processSeq, c.courseName;




/*  학생 평가  */

/*추가*/
INSERT INTO sGrade VALUES (sGrade_Seq.nextval,6,1,null,'문제 해결 능력이 뛰어나며 창의적인 접근 방식을 갖춘 학생입니다.');

/*조회*/
select * from sGrade;

/*수정*/
update sGrade set teacherSeq = 1, studentSeq = 1, sgradescore = 50, sgraderw ='학생평가한줄평' where sGradeSeq = 1;

/*삭제*/
delete from sGrade where sGradeSeq = 1;






/*  학생 전체 시험 평균점수   */

/*조회*/
SELECT 
    ST.STUDENTNAME as "학생 이름", 
    ROUND(AVG(SC.TOTALSCORE), 1) AS "평균 점수"
FROM STUDENT ST
    INNER JOIN SCORE SC
        ON ST.STUDENTSEQ = SC.STUDENTSEQ
GROUP BY ST.STUDENTNAME; 







/*  학생평가와 평균점수  */

/*수정*/
UPDATE SGRADE G
SET SGRADESCORE = (
    SELECT ROUND(AVG(SC.TOTALSCORE), 1)
    FROM SCORE SC
    WHERE SC.STUDENTSEQ = G.STUDENTSEQ
)
WHERE EXISTS (
    SELECT 1 FROM SCORE SC WHERE SC.STUDENTSEQ = G.STUDENTSEQ
);

/*조회*/
select * from sgrade;








/* 강사평가  */

/* 추가 */
INSERT INTO tGrade VALUES (tGrade_seq.nextval,1,27,9,'강의 내용이 잘 정리되어 있고, 실습을 통해 쉽게 이해할 수 있었습니다.');

/* 조회 */
select * from tgrade;

/* 수정 */
update TGRADE set TGRADERW = '너무 좋아요' where TGRADESEQ=1;

/* 삭제 */
delete from TGRADE where TEACHERSEQ = 1;





/*  강사별 평균 평점   */

/*조회*/
select 
    t.teachername as "교사명",
    round(avg(g.tgradescore),1) as "교사평균평점"
from tgrade g
    inner join teacher t
        on t.teacherseq = g.teacherseq
            group by t.teachername;
            






/* 학생 지원금  */  

/* 조회 */
select s.studentname as "학생이름", 
    to_char(m.moneymonth,'yyyy-mm') as "년도 - 월",
    receivedmoney as "지원금"
from money m
    inner join student s
        on s.studentseq = m.studentseq
            where m.studentseq=1;
            


















































