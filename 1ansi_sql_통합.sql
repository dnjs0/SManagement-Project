--------------------------------
--상혁


/*  C-04 교사 - 성적 관리  */
/*추가*/
--성적 등록 (과목성적번호, 교육생번호, 과목번호, 필기점수, 실기점수, 출석점수, 총점수)
insert into score(scoreSeq,studentSeq,subjectSeq,writingScore,realScore, attendanceScore,totalScore) 
    values (score_seq.nextval,27,1,0,72, 20,92);
    
/*조회*/
--교사 이름을 입력하여 강의를 마친 과목 조회
SELECT 
    s.subjectSeq AS 과목번호,
    c.courseName AS 과정명,
    p.processSDate AS 과정시작날짜,
    p.processEDate AS 과정종료날짜,
    cr.clsRoomName AS 강의실명,
    s.subjectName AS 과목명,
    ps.prcSubjectSDate AS 과목시작날짜,
    ps.prcSubjectEDate AS 과목종료날짜,
    b.bookName AS 교재명,
    st.studentName AS 이름,
    sa.attendAllot AS 출석배점,
    sa.writingAllot AS 필기배점,
    sa.realAllot AS 실기배점,
    CASE 
        WHEN sc.studentSeq IS NOT NULL THEN '등록'
        ELSE '미등록'
    END AS 성적등록여부
FROM teacher t
    inner join process p ON t.teacherSeq = p.teacherSeq
    inner join Course c ON p.courseSeq = c.courseSeq
    inner join clsRoom cr ON p.clsRoomSeq = cr.clsRoomSeq
    inner join prcSubject ps ON p.processSeq = ps.processSeq
    inner join subject s ON ps.subjectSeq = s.subjectSeq
    inner join sbjectBook sb ON s.subjectSeq = sb.subjectSeq
    inner join book b ON sb.bookSeq = b.bookSeq
    inner join studentCls scs ON p.processSeq = scs.processSeq
    inner join student st ON scs.studentSeq = st.studentSeq
    left join score sc ON st.studentSeq = sc.studentSeq AND s.subjectSeq = sc.subjectSeq
    inner join scoreAllot sa ON ps.prcSubjectSeq = sa.prcSubjectSeq
WHERE 
    t.teacherName = '구하늘'
    AND ps.prcSubjectEDate <= SYSDATE
    AND p.processSDate <= ps.prcSubjectSDate
    AND p.processEDate >= ps.prcSubjectEDate;
    
--과목을 조회하여 교육생 정보 출력
SELECT 
    st.studentName AS 이름,
    st.studentTel AS 전화번호,
    CASE 
        WHEN ss.status = '수료' OR ss.status IS NULL THEN '수료'
        WHEN ss.stStatusDate >= p.processSDate AND ss.stStatusDate <= p.processEDate THEN '중도탈락'
        WHEN SYSDATE <= p.processSDate THEN '수강예정'
        WHEN SYSDATE >= p.processSDate AND SYSDATE <= p.processEDate THEN '수강중'
        ELSE '수료'
    END AS 교육생상태,
    sc.attendanceScore AS 출석점수,
    sc.writingScore AS 필기점수,
    sc.realScore AS 실기점수
FROM student st
    inner join studentCls scs ON st.studentSeq = scs.studentSeq
    inner join process p ON scs.processSeq = p.processSeq
    inner join prcSubject ps ON p.processSeq = ps.processSeq
    inner join subject s ON ps.subjectSeq = s.subjectSeq
    left join stStatus ss ON st.studentSeq = ss.studentSeq
    inner join score sc ON st.studentSeq = sc.studentSeq AND s.subjectSeq = sc.subjectSeq
WHERE 
    s.subjectSeq = 41
    AND p.processSDate <= ps.prcSubjectSDate
    AND p.processEDate >= ps.prcSubjectEDate;



/*  B-07 관리자 - 시험관리, 성적조회  */
/*추가*/
--성적 등록 (과목성적번호, 교육생번호, 과목번호, 필기점수, 실기점수, 출석점수, 총점수)
insert into score(scoreSeq,studentSeq,subjectSeq,writingScore,realScore, attendanceScore,totalScore) 
    values (score_seq.nextval,27,1,0,72, 20,92);

/*조회*/
-- 개설과정번호를 조회하여 시험문제 확인
SELECT 
    c.courseName AS 과정명,
    s.subjectName AS 과목명,
    t.testType AS 시험종류,
    t.testContext AS 시험문제,
    t.testDate AS 날짜
FROM process p
    inner join Course c ON p.courseSeq = c.courseSeq
    inner join prcSubject ps ON p.processSeq = ps.processSeq
    inner join subject s ON ps.subjectSeq = s.subjectSeq
    inner join test t ON s.subjectSeq = t.subjectSeq
WHERE 
    p.processSeq = 2
    AND t.teacherSeq = p.teacherSeq
    AND t.testDate < p.processEDate;
    

-- 과목번호를 조회하여 성적정보 확인
SELECT 
    c.courseName AS 과정명,
    p.processSDate AS 과정시작날짜,
    p.processEDate AS 과정종료날짜,
    cr.clsRoomName AS 강의실명,
    s.subjectName AS 과목명,
    t.teacherName AS 교사명,
    b.bookName AS 교재명,
    st.studentName AS 학생이름,
    st.studentPw AS 주민번호뒷자리,
    sc.writingScore AS 필기점수,
    sc.realScore AS 실기점수
FROM process p
    inner join Course c ON p.courseSeq = c.courseSeq
    inner join clsRoom cr ON p.clsRoomSeq = cr.clsRoomSeq
    inner join prcSubject ps ON p.processSeq = ps.processSeq
    inner join subject s ON ps.subjectSeq = s.subjectSeq
    inner join sbjectBook sb ON s.subjectSeq = sb.subjectSeq
    inner join book b ON sb.bookSeq = b.bookSeq
    inner join teacher t ON p.teacherSeq = t.teacherSeq
    inner join studentCls sc ON p.processSeq = sc.processSeq
    inner join student st ON sc.studentSeq = st.studentSeq
    inner join score sc ON st.studentSeq = sc.studentSeq AND s.subjectSeq = sc.subjectSeq
WHERE 
    s.subjectSeq = 1;
    
-- 교육생 이름을 조회하여 성적정보 확인
    SELECT 
    st.studentName AS 이름,
    st.studentPw AS 주민번호뒷자리,
    c.courseName AS 과정명,
    p.processSDate AS 과정시작날짜,
    p.processEDate AS 과정종료날짜,
    cr.clsRoomName AS 강의실명,
    s.subjectName AS 과목명,
    ps.prcSubjectSDate AS 과목시작날짜,
    ps.prcSubjectEDate AS 과목종료날짜,
    t.teacherName AS 교사명,
    sc.attendanceScore AS 출석점수,
    sc.writingScore AS 필기점수,
    sc.realScore AS 실기점수
FROM student st
    inner join studentCls scs ON st.studentSeq = scs.studentSeq
    inner join process p ON scs.processSeq = p.processSeq
    inner join Course c ON p.courseSeq = c.courseSeq
    inner join clsRoom cr ON p.clsRoomSeq = cr.clsRoomSeq
    inner join prcSubject ps ON p.processSeq = ps.processSeq
    inner join subject s ON ps.subjectSeq = s.subjectSeq
    inner join sbjectBook sb ON s.subjectSeq = sb.subjectSeq
    inner join book b ON sb.bookSeq = b.bookSeq
    inner join teacher t ON p.teacherSeq = t.teacherSeq
    inner join score sc ON st.studentSeq = sc.studentSeq AND s.subjectSeq = sc.subjectSeq
WHERE 
    st.studentName = '구하늘';


/*수정*/
--과목번호 수정
update score set subjectSeq = 1
    where studentSeq = 1;
--필기점수 수정
update score set writingScore = 0
    where studentSeq = 1;
--실기점수 수정
update score set realScore = 72
    where studentSeq = 1;
--출석점수 수정
update score set attendanceScore = 20
    where studentSeq = 1;
--총점수 수정
update score set totalScore = 92
    where studentSeq = 1;






/*  B-05 관리자 - 개설과정 관리  */

/*추가*/
--과정명 등록 (과정번호, 과정명)
insert into Course(courseSeq,courseName) 
    values (course_seq.NEXTVAL, q'[AWS와 Docker & Kubernetes를 활용한 Java Full-Stack 개발자 양성과정]');
--과정기간 등록 (개설과정번호, 과정번호, 강의실번호, 교사번호, 과정시작날짜, 과정종료날짜, 수강정원)
insert into process(processSeq,courseSeq,clsRoomSeq,teacherSeq, processSDate,processEDate,processCount) 
    values (process_seq.NEXTVAL,3,6,6, to_date('2024-07-03','YYYY-MM-DD'), to_date('2025-01-03','YYYY-MM-DD'),26);
--강의실 등록 (강의실번호, 강의실명, 강의실인원)
insert into clsRoom(clsRoomSeq,clsRoomName,clsRoomPpl) 
    values (clsRoom_seq.NEXTVAL, q'[제 1 강의실]','30');

/*조회*/
--전체조회
SELECT 
    c.courseName AS 과정명,
    p.processSDate AS 과정시작날짜,
    p.processEDate AS 과정종료날짜,
    cr.clsRoomName AS 강의실명,
    s.subjectName AS 과목명,
    (SELECT COUNT(*) 
     FROM studentCls sc 
     WHERE sc.processSeq = p.processSeq) AS 교육생등록인원
FROM process p
    inner join Course c ON p.courseSeq = c.courseSeq
    inner join clsRoom cr ON p.clsRoomSeq = cr.clsRoomSeq
    inner join prcSubject ps ON p.processSeq = ps.processSeq
    inner join subject s ON ps.subjectSeq = s.subjectSeq;
    
--개설과정번호로 조회
SELECT 
    c.courseName AS 과정명,
    s.subjectName AS 과목명,
    cr.clsRoomName AS 강의실명,
    ps.prcSubjectSDate AS 과목시작날짜,
    ps.prcSubjectEDate AS 과목종료날짜,
    sc.studentSeq AS 교육생번호,
    st.studentName AS 이름
FROM process p
    inner join Course c ON p.courseSeq = c.courseSeq
    inner join prcSubject ps ON p.processSeq = ps.processSeq
    inner join subject s ON ps.subjectSeq = s.subjectSeq
    inner join clsRoom cr ON p.clsRoomSeq = cr.clsRoomSeq
    inner join studentCls sc ON p.processSeq = sc.processSeq
    inner join student st ON sc.studentSeq = st.studentSeq
WHERE p.processSeq = 2;

/*수정*/
--과정번호 수정
update process set courseSeq = 3
    where processSeq = 2;
--강의실번호 수정
update process set clsRoomSeq = 6
    where processSeq = 2;
--교사번호 수정
update process set teacherSeq = 6
    where processSeq = 2;
--과정시작날짜 수정
update process set processSDate = to_date('2024-07-03','YYYY-MM-DD')
    where processSeq = 2;
--과정종료날짜 수정
update process set processEDate = to_date('2025-01-03','YYYY-MM-DD')
    where processSeq = 2;
--수강정원 수정
update process set processCount = 26
    where processSeq = 2;
    
/*삭제*/
UPDATE Course
SET 
    courseName = '삭제된과정'
WHERE 
    courseSeq = 2;





/*  B-03 관리자 - 교사계정 관리  */

/*추가*/
--a. 교사명단 추가 (교사번호, 교사명, 비밀번호, 전화번호)
insert into Teacher(teacherSeq,teacherName,teacherPw,teacherTel) 
    values (teacher_seq.nextval,'구하늘',1156493,'010-6789-0123');
--b. 교사 가능과목 추가 (교사가능과목번호, 교사번호, 과목번호)
insert into tSubject(tSubjectSeq,teacherSeq,subjectSeq) 
    values (tSubject_Seq.NEXTVAL,1,1);

/*조회*/
--a. 전체조회
select 
    t.teacherName as 교사이름, 
    t.teacherPw as 비밀번호, 
    t.teacherTel  as 전화번호, 
    s.subjectName as 강의가능과목
from teacher t
    inner join tSubject ts on t.teacherSeq = ts.teacherSeq
    inner join subject s on ts.subjectSeq = s.subjectSeq;
--b. 교사이름 조회
SELECT 
    t.teacherName as 교사이름,
    s.subjectName as 과목명,
    ps.prcSubjectSDate as 과목시작날짜,
    ps.prcSubjectEDate as 과목종료날짜,
    c.courseName as 과정명,
    p.processSDate as 과정시작날짜,
    p.processEDate as 과정종료날짜,
    b.bookName as 교재명,
    cr.clsRoomName as 강의실명,
    CASE
        WHEN ps.prcSubjectSDate > SYSDATE THEN '강의예정'
        WHEN ps.prcSubjectSDate <= SYSDATE AND ps.prcSubjectEDate >= SYSDATE THEN '강의중'
        ELSE '강의종료'
    END AS 강의진행여부
FROM teacher t
    inner join process p ON t.teacherSeq = p.teacherSeq
    inner join prcSubject ps ON p.processSeq = ps.processSeq
    inner join subject s ON ps.subjectSeq = s.subjectSeq
    inner join Course c ON p.courseSeq = c.courseSeq
    inner join clsRoom cr ON p.clsRoomSeq = cr.clsRoomSeq
    inner join sbjectBook sb ON s.subjectSeq = sb.subjectSeq
    inner join book b ON sb.bookSeq = b.bookSeq
WHERE t.teacherName = '구하늘';

/*수정*/
--이름
update teacher set teacherName = '구바람'
    where teacherSeq = 1;
--비밀번호
update teacher set teacherPw = '1234567'
    where teacherSeq = 1;
--전화번호
update teacher set teacherTel = '010-6789-0123'
    where teacherSeq = 1;

/*삭제*/
UPDATE teacher
SET 
    teacherName = '퇴직교사',
    teacherPw = NULL,
    teacherTel = NULL
WHERE 
    teacherName = '구하늘';


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--우현


-- ////////////////////////////////관리자 계정////////////////////////// 

/*추가*/
insert into Admin(AdminSeq,AdminName,AdminTel,AdminPw) 
    values (admin_seq.nextval,'김우현','010-9193-3250',1493870);

/*조회*/
select AdminSeq as 관리자번호, AdminName as 관리자이름, AdminTel as 전화번호, AdminPw as 비밀번호 from Admin;

/*수정*/
update Admin 
   set AdminName = '김우현' 
     , AdminTel = '010-9193-3250'
     , AdminPw = 1493870
where AdminSeq = 1;

/*삭제*/
delete from Admin where AdminSeq = 1;




-- ////////////////////////////////////////1. 기초정보 관리 CRUD/////////////////////////////////
-- 과정명을 등록, 수정, 삭제, 조회 할 수 있다.
/*
drop sequence course_seq;
create sequence course_seq;
*/

/*추가*/
insert into Course(courseSeq,courseName) values (course_seq.NEXTVAL, q'[AWS와 Docker & Kubernetes를 활용한 Java Full-Stack 개발자 양성과정]');
/*조회*/
select courseSeq as 과정번호, courseName as 과정명 from Course;
/*수정*/
update Course 
   set courseName = q'[AWS와 Docker & Kubernetes를 활용한 Java Full-Stack 개발자 양성과정]'
where courseSeq = 1;

/*삭제*/
update Course 
   set courseName = '없음'
where courseSeq = 1;

delete from Course where courseSeq = 21;

--2.과목명 관리
-- 과목명을 등록, 수정, 삭제, 조회 할 수 있다.
-- 필수 과목과 선택 과목이 있다.
-- 과목은 30~50과목이 있다.

/*추가*/
insert into subject(subjectSeq,subjectName,subjectEsn) values (subject_seq.NEXTVAL, q'[java]','필수');
/*조회*/
select subjectSeq as 과목번호, subjectName as 과목명, subjectEsn as 필수선택 from subject;
/*수정*/
update subject 
   set subjectName = q'[java2]'
   , subjectEsn ='필수'
where subjectSeq = 1;
/*삭제*/
update subject 
   set subjectName = '없음'
where subjectSeq = 1;

delete from subject where subjectSeq = 1;

--3.강의실명 관리
-- 강의실명을 등록, 수정, 삭제, 조회 할 수 있다.
-- 강의실은 총 6개로 1,2,3강의실은 정원이 30명, 4,5,6강의실은 정원이 26명이다.
/*추가*/
insert into clsRoom(clsRoomSeq,clsRoomName,clsRoomPpl) values (clsRoom_seq.NEXTVAL, q'[제 1 강의실]','30');
/*조회*/

SELECT distinct    
    c.clsRoomName as 강의실명,   
    c.clsRoomPpl as 강의실수용인원,   
    p.processCount as 수강한인원  
FROM   
    clsRoom c  
INNER JOIN   
    process p ON c.clsRoomSeq = p.clsRoomSeq;  


/*수정*/
update clsRoom 
   set clsRoomName = q'[변경할 강의실 번호]'
   , clsRoomPpl ='강의실 수용인원'
where clsRoomSeq = 1;

/*삭제*/
update clsRoom 
   set clsRoomName = '없음'
where clsRoomSeq = 1;

delete from clsRoom where clsRoomSeq = 1;




--4.교재명 관리
--교재명을 등록, 수정, 삭제, 조회 할 수 있다.
--1과목에는 교재 1권이 존재한다.

select * 
from book;
/*추가*/
insert into book(bookSeq,bookName,bookPublisher,bookAuthor,bookYear) 
values (book_Seq.NEXTVAL, q'[최신Java 프로그래밍]', q'[21세기사]', q'[한정란]', to_date('2024','YYYY'));
/*조회*/
select bookSeq as 교재번호, bookName as 교재명, bookPublisher as 출판사 , bookAuthor as 저자 ,bookYear as 발행연도 
from book;
/*수정*/
update book 
   set bookName = q'[최신Java 프로그래밍]'
   , bookPublisher = q'[21세기사]'
   , bookAuthor = q'[한정란]'
   , bookYear = to_date('2024','YYYY')
where bookSeq = 1;
/*삭제*/
UPDATE book  
set bookName = '없음'
   , bookPublisher = null
   , bookAuthor = null
   , bookYear = null 
WHERE bookSeq = 1;  




--////////////////////////////////B-05. 개설 과목 관리 기능////////////////////////////////////
-- 관리자는 개설 과정에 대해 여러 개의 개설 과목을 등록 및 관리할 수 있다.
/*
1.개설과목등록
--개설 과목 정보 입력시 과목명, 과목기간, 교재번호, 교사명을 입력한다.
2.개설과목수정
3.개설과목삭제
4.개설과목조회
-- 개설 과목 조회시 개설 과정 정보, 과목명, 과목기간, 교재명, 교사명을 출력한다

특정 개설 과정 선택시 개설 과목 정보 출력 및 개설 과목 신규 등록을 할 수 있게 한다.
교재명은 기초 정보 교재명에서 선택적으로 추가한다.
교사명은 현재 과목과 강의 가능 과목이 일치하는 교사 명단에서 선택적으로 추가한다.

*/


--1.개설과목

/*추가*/
insert into prcSubject(prcSubjectSeq,processSeq,subjectSeq,prcSubjectSDate,prcSubjectEDate) 
values (prcSubject_Seq.NEXTVAL,1,1, to_date('24/08/07','YY-MM-DD'), to_date('24/09/11','YY-MM-DD'));

insert into subject(subjectSeq,subjectName,subjectEsn) 
values (subject_seq.NEXTVAL, q'[java]','필수');
insert into tSubject(tSubjectSeq,teacherSeq,subjectSeq) 
values (tSubject_Seq.NEXTVAL,1,1);
insert into sbjectBook(sbjectBookSeq,subjectSeq,bookSeq) 
values (sbjectBook_Seq.NEXTVAL,1,1);
insert into book(bookSeq,bookName,bookPublisher,bookAuthor,bookYear) 
values (book_Seq.NEXTVAL, q'[최신Java 프로그래밍]', q'[21세기사]', q'[한정란]', to_date('2024','YYYY'));


/*조회*/
SELECT   
    p.processSeq as 개설과정번호,
    p.prcSubjectSeq as 개설과정과목번호,      
    p.subjectSeq as 과목번호,   
    s.subjectName as 과목명,   
    p.prcSubjectSDate as 과목시작날짜, 
    p.prcSubjectEDate as 과목종료날짜,   
    t.teacherName as 교사명,
    b.bookName as 교재명
FROM   
    prcSubject p  
INNER JOIN   
    subject s ON p.subjectSeq = s.subjectSeq  
INNER JOIN   
    process pr ON p.processSeq = pr.processSeq  
INNER JOIN   
    teacher t ON pr.teacherSeq = t.teacherSeq
INNER JOIN   
    sbjectBook sb ON s.subjectSeq = sb.subjectSeq
INNER JOIN   
    book B ON sb.bookSeq = b.bookSeq;
    
    
/*수정*/
update subject 
   set subjectName = q'[최신Java 프로그래밍]'
   , subjectEsn = q'[21세기사]'
where subjectSeq = 1;

/*삭제*/
UPDATE subject  
set subjectName = '없음'
   , subjectEsn = '없음'
WHERE subjectSeq = 1;


--///////////////////////// B-06. 교육생 관리 기능/////////////////    
/*
1. 교육생 정보 등록
- 교육생의 이름, 주민번호 뒷자리, 전화번호, 등록일, 수강(신청) 횟수 등 기본정보를 등록한다.
- 주민번호 뒷자리는 로그인 및 패스워드에 사용한다.

2. 교육생 정보 출력
- 이름, 주민번호 뒷자리, 전화번호, 등록일 확인 가능하다.

3.  특정 교육생 선택 시
- 교육생이 수강 신청한 또는 수강중인, 수강했던 개설 과정 정보 확인이 가능 하다.
- 과정 명, 과정기간(시작 년 월일, 끝 년 월일), 강의실, 수료 및 중도 탈락 여부, 수료 및 중도 탈락 날짜를 가져올 수 있다.

4. 검색 기능
- 교육생의 이름, 주민번호 뒷자리, 전화번호를 기본 기준으로 검색할 수 있다.

5. 교육생의 정보 입력, 출력, 수정, 삭제 가능하다.

6. 수료 및 중도 탈락 처리
- 수료 및 중도 탈락 날짜 입력 가능하다.
*/    

/*추가*/
--1
insert into Student(studentSeq,studentName,studentPw,studentTel,studentDate) 
values (ststatus_seq1.nextval,'이영희',2345678,'010-2345-6789','2024-06-03');


/*조회*/
--2
select studentName as 이름, studentPw as 주민번호, studentTel as 전화번호, studentDate as 등록일 
from Student;

--3    
select
st.studentname as 이름,
c.coursename as 과정명,
pr.processSDate as 과정시작날짜,
pr.processEDate as 과정종료날짜,
clR.clsroomname as 강의실,
CASE   
        WHEN stS.Status IS NULL THEN '수료중'  
        ELSE stS.Status    
END AS 수료여부,
stS.stStatusDate as 날짜
from Student st
    INNER JOIN   
    studentCls stcl ON st.studentSeq = stcl.studentSeq
    INNER JOIN   
    process pr ON stcl.processSeq = pr.processSeq
    INNER JOIN   
    Course c ON pr.courseSeq = c.courseSeq
    INNER JOIN   
    clsRoom clR ON pr.clsRoomSeq = clR.clsRoomSeq
    LEFT JOIN  
    stStatus stS ON st.studentSeq = stS.studentSeq
where st.studentSeq = 1;

--4
select studentName as 이름, studentPw as 주민번호, studentTel as 전화번호, studentDate as 등록일 
from student
where studentName = '정수현';

select studentName as 이름, studentPw as 주민번호, studentTel as 전화번호, studentDate as 등록일 
from student
where studentPw = 1234560;

select studentName as 이름, studentPw as 주민번호, studentTel as 전화번호, studentDate as 등록일 
from student
where studentTel = '010-5678-9012';


/*수정*/
--5
update student 
   set studentName = '김우현'
   , studentPw ='1520316'
   , studentTel ='010-4983-9012'
   , studentDate ='2025-02-04'
where studentSeq = 1;

--6
update stStatus 
    set status = '중도탈락'
    ,stStatusDate = '2025-02-04'
where stStatus.studentSeq = 1;    



/*삭제*/
--5
UPDATE student  
    set studentName = null
   , studentPw =null
   , studentTel =null
   , studentDate =null
WHERE studentSeq = 1;




-- B-08 출결 관리 및 출결 조회 가능
/*
1. 특정 개설 과정을 선택하면 모든 교육생의 출결 조회 가능하다.
2. 출결 현황을 기간별(년, 월, 일) 확인 가능하다.
3. 특정 과정 또는 교육생의 출결 현황 조회 가능하다.
4. 현재 출결 관리 현황은 근태 상황 구분(정상, 지각, 조퇴, 외출, 병가, 기타)  가능하다.
*/

/*추가*/
insert into attendance values (attendance_seq.NEXTVAL,1,1,TO_DATE('2024-07-03', 'YYYY-MM-DD'), TO_DATE('2024-07-03 09:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2024-07-03 18:00', 'YYYY-MM-DD HH24:MI'), '정상');

/*조회*/
select
    c.courseName as 과정번호,
    st.studentName as 이름,
    at.attendanceDate as 날짜,
    at.attendanceST as 상태
from attendance at
    INNER JOIN   
        student st ON st.studentSeq = at.studentSeq
    INNER JOIN   
        studentCls stcls ON st.studentSeq = stcls.studentSeq
    INNER JOIN
        process pr ON stcls.processSeq = pr.processSeq
    INNER JOIN
        Course c ON pr.courseSeq = c.courseseq    
where stcls.processSeq = 1;


--C-03. 배점 입출력
/*
1.성적 배점 CRUD
2.교사 특정 과목을 선택하고 해당 과목의 배점 정보를 출결, 필기, 실기로 구분해서 등록. 시험 날짜, 시험 문제 C
3.출결, 필기, 실기의 배점 비중은 담당 교사가 과목별로 결정한다.
4.과목 목록 출력 시 과목번호, 과정명, 과정기간(시작 년월일, 끝 년월일), 강의실, 과목명, 과목기간(시작 년월일, 끝 년월일)
, 교재명, 출결, 필기, 실기 배점 등이 출력되고, 특정 과목을 과목번호로 선택 시
출결 배점, 필기 배점, 실기 배점, 시험 날짜, 시험 문제를 입력할 수 있는 화면으로 연결되어야 한다.
*/

/*추가*/
--1
insert into scoreAllot(scoreAllotSeq,prcSubjectSeq,teacherSeq,attendAllot,writingAllot,realAllot) 
values (scoreAllot_Seq.NEXTVAL,1,1,20,0,80);

--2
insert into test(testSeq,subjectSeq,teacherSeq,testType,testContext,testDate) 
values (test_Seq.NEXTVAL,1,1,'실기',q'[두 개의 정수 배열이 주어졌을 때, 두 배열의 교집합을 찾는 프로그램을 작성하세요. 단, 교집합의 원소는 중복되지 않으며 정렬된 상태로 출력해야 합니다.]'
, to_date('24/09/04', 'yy-mm-dd'));


/*조회*/
--1
select 
    s.subjectName as 과목명,
    scA.attendAllot as 출결배점,
    scA.writingAllot as 필기배점,
    scA.realAllot as 실기배점,
    t.teachername as 교사명
from scoreAllot scA
    INNER JOIN teacher t ON t.teacherSeq = scA.teacherSeq
    INNER JOIN prcSubject ps ON scA.prcSubjectSeq = ps.prcSubjectSeq
    INNER JOIN subject s ON ps.subjectSeq = s.subjectSeq;

--4
SELECT distinct   
    s.subjectSeq AS 과목번호,  
    c.courseName AS 과정명,  
    p.processSDate AS 과정시작날짜,  
    p.processEDate AS 과정종료날짜,  
    r.clsRoomName AS 강의실명,  
    s.subjectName AS 과목명,  
    ps.prcSubjectSDate AS 과목시작날짜,  
    ps.prcSubjectEDate AS 과목종료날짜,  
    b.bookName AS 교재명,  
    st.studentName AS 이름,  
    sa.attendAllot AS 출석배점,  
    sa.writingAllot AS 필기배점,  
    sa.realAllot AS 실기배점  
     
FROM   
    teacher t  
INNER JOIN   
    scoreAllot sa ON t.teacherSeq = sa.teacherSeq  
INNER JOIN   
    prcSubject ps ON sa.prcSubjectSeq = ps.prcSubjectSeq  
INNER JOIN   
    process p ON ps.processSeq = p.processSeq 
INNER JOIN    
    Course c ON p.courseSeq = c.courseSeq 
INNER JOIN   
    subject s ON ps.subjectSeq = s.subjectSeq  
INNER JOIN   
    clsRoom r ON p.clsRoomSeq = r.clsRoomSeq  
INNER JOIN   
    studentCls sc ON p.processSeq = sc.processSeq  
INNER JOIN   
    student st ON sc.studentSeq = st.studentSeq
INNER JOIN   
    sbjectBook sb ON s.subjectSeq = sb.subjectSeq
INNER JOIN   
    book b ON sb.bookSeq = b.bookSeq   
    
LEFT JOIN   
    score sc2 ON st.studentSeq = sc2.studentSeq AND s.subjectSeq = sc2.subjectSeq  
WHERE   
    t.teacherSeq = 5;  
    AND ps.prcSubjectEDate <= SYSDATE  
    AND p.processSDate <= ps.prcSubjectSDate  
    AND p.processEDate >= ps.prcSubjectEDate; 




select t.teacherName, sa.prcSubjectSeq
from scoreAllot sa
join teacher t on sa.teacherSeq = t.teacherseq
where t.teacherSeq = 1;

/*수정*/
--1
UPDATE scoreAllot  
    set prcSubjectSeq = 1
   , teacherSeq = 1
   , attendAllot =20
   , writingAllot =0
   , realAllot=80
WHERE scoreAllotSeq = 1;

/*삭제*/
--1
UPDATE scoreAllot  
    set prcSubjectSeq = 0
   , teacherSeq = 0
   , attendAllot =null
   , writingAllot =null
   , realAllot=null
WHERE scoreAllotSeq = 1;








--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--희원


/*  c-2. 교사 - 강의 스케줄  */
/*조회*/

--a. 자신의 강의스케줄 조회
SELECT 
    t.teacherName as 교사이름,
    s.subjectName as 과목명,
    to_char(ps.prcSubjectSDate, 'yyyy-dd-mm') as 과목시작날짜,
    to_char(ps.prcSubjectEDate, 'yyyy-dd-mm') as 과목종료날짜,
    c.courseName as 과정명,
    to_char(p.processSDate, 'yyyy-dd-mm') as 과정시작날짜,
    to_char(p.processEDate, 'yyyy-dd-mm') as 과정종료날짜,
    b.bookName as 교재명,
    cr.clsRoomName as 강의실명,
    CASE
        WHEN ps.prcSubjectSDate > SYSDATE THEN '강의예정'
        WHEN ps.prcSubjectSDate <= SYSDATE AND ps.prcSubjectEDate >= SYSDATE THEN '강의중'
        ELSE '강의종료'
    END AS 강의진행여부,
    processCount as 수강인원
FROM teacher t
    JOIN process p ON t.teacherSeq = p.teacherSeq
    JOIN prcSubject ps ON p.processSeq = ps.processSeq
    JOIN subject s ON ps.subjectSeq = s.subjectSeq
    JOIN Course c ON p.courseSeq = c.courseSeq
    JOIN clsRoom cr ON p.clsRoomSeq = cr.clsRoomSeq
    JOIN sbjectBook sb ON s.subjectSeq = sb.subjectSeq
    JOIN book b ON sb.bookSeq = b.bookSeq
WHERE t.teacherName = '구하늘'
order by 과정시작날짜;

-- b. 특정 강사의 진행중인 강의 듣는 학생명단 조회(수료 또는 중도탈락)
select s.studentSeq as 학생번호, s.studentName as 학생명, s.studentTel as 전화번호, s.studentDate as 등록일, st.status as 학생상태
from prcSubject ps 
inner join scoreAllot sa on ps.prcSubjectSeq = sa.prcSubjectSeq
    inner join teacher t on t.teacherSeq = sa.teacherSeq
        inner join subject s on s.subjectSeq = ps.subjectSeq
            inner join process p on p.processSeq = ps.processSeq
                inner join studentCls sc on sc.processSeq = p.processSeq
                    inner join student s on s.studentSeq = sc.studentSeq
                        inner join stStatus st on st.studentSeq = s.studentSeq
where ps.prcSubjectEDate > sysdate and ps.prcSubjectSDate <= sysdate and t.teacherSeq = 1 and p.processSeq = 1;



/*  c-5. 교사 - 출결 관리 및 출결 조회  */

/*조회*/
--a. 모든 교육생의 출결 조회
select s.studentName, a.attendanceDate, nvl(to_char(a.attendanceStime, 'hh24:mi'),to_char('-')) as 등원시간, nvl(to_char(a.attendanceETime, 'hh24:mi'),to_char('-')) as 하원시간, attendanceST
from attendance a 
inner join student s on s.studentSeq = a.studentSeq;
            
--b. 기간 별로 출결 현황 조회
select s.studentName, a.attendanceDate, nvl(to_char(a.attendanceStime, 'hh24:mi'),to_char('-')) as 등원시간, nvl(to_char(a.attendanceETime, 'hh24:mi'),to_char('-')) as 하원시간, attendanceST
from attendance a 
inner join student s on s.studentSeq = a.studentSeq
where a.attendanceDate between '2024-07-03' and '2024-07-31';

--c. 특정 과정 출결 현황 조회
select s.studentName, c.courseName, a.attendanceDate, nvl(to_char(a.attendanceStime, 'hh24:mi'),to_char('-')) as 등원시간, nvl(to_char(a.attendanceETime, 'hh24:mi'),to_char('-')) as 하원시간, attendanceST
from attendance a 
inner join student s on s.studentSeq = a.studentSeq
inner join studentCls sc on s.studentSeq = sc.studentSeq
inner join process p on p.processSeq = sc.processSeq
inner join course c on c.courseSeq = p.courseSeq
where p.processSeq = 1;


--d. 특정 인원 출결 현황 조회
select s.studentSeq, s.studentName, c.courseName, a.attendanceDate, nvl(to_char(a.attendanceStime, 'hh24:mi'),to_char('-')) as 등원시간, nvl(to_char(a.attendanceETime, 'hh24:mi'),to_char('-')) as 하원시간, attendanceST
from attendance a 
inner join student s on s.studentSeq = a.studentSeq
inner join studentCls sc on s.studentSeq = sc.studentSeq
inner join process p on p.processSeq = sc.processSeq
inner join course c on c.courseSeq = p.courseSeq
where s.studentSeq = 1;








--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--세원

--교육생 업무


/* D-01 교육생 로그인 기능 */
/* 조회 */
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
                    
                    


/* D-02 교육생 개인성적정보 확인기능 */
/* 조회 */
select * from subject;
select * from course;
select * from process;
select * from prcsubject;
select * from book;
select * from sbjectBook;
select * from teacher;
select * from tsubject;
select * from scoreallot;
select * from test;
select * from tsubject where teacherseq =6;
select * from test where teacherseq =6;
select * from studentcls where studentseq=27;

select * from tsubject ts inner join test t on t.teacherseq=ts.teacherseq where t.teacherseq = 6;

select * from score where studentseq=27;


select distinct
    pc.subjectseq as "과목 번호",
    s.subjectname as "과목 이름",
    pc.prcsubjectsdate as "과목 시작 날짜",
    pc.prcsubjectedate as "과목 종료 날짜",
    b.bookname as "교재명",
    t.teachername as "교사명",
    sa.attendallot as "출석 배점" ,
    sa.writingallot as "필기 배점" ,
    sa.realallot as "실기 배점" ,
    score.attendancescore as "출석 점수",
    score.writingscore as "필기 점수",
    score.realscore as "실기 점수",
    score.totalscore as "총 점수",
    test.testtype as "시험 종류",
    test.testdate as "시험 날짜",
    test.testcontext as "시험 문제"
from prcsubject pc
    inner join process p
        on p.processseq = pc.processseq
            inner join subject s
                on s.subjectseq = pc.subjectseq
                    inner join sbjectBook sb
                        on sb.subjectseq = pc.subjectseq
                            inner join book b
                                on b.bookseq = sb.bookseq
                                    inner join teacher t
                                        on t.teacherseq = p.teacherseq
                                            inner join scoreallot sa
                                                on sa.prcsubjectseq = pc.prcsubjectseq 
                                                    inner join test
                                                        on test.subjectseq = pc.subjectseq
                                                            inner join studentcls scl
                                                                on scl.processseq = p.processseq
                                                                    inner join score
                                                                        on scl.studentseq=score.studentseq
                                                                            where t.teacherseq=1 and p.processseq=2 and scl.studentseq = 27
                                                                                order by pc.prcsubjectsdate;

                           
                                            
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
/* 다닌날 전체 조회 */
create or replace view vwTotalDate
as
select
    to_date('2024-07-03', 'yyyy-mm-dd') + level - 1 as regdate
from dual
    connect by level <= (to_date('2025-01-03', 'yyyy-mm-dd')
                            - to_date('2024-07-03', 'yyyy-mm-dd') + 1);

select 
    v.regdate as "날짜",
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
            left outer join holiday h
                on to_char(v.regdate, 'yyyy-mm-dd') = to_char(h.holidaydate, 'yyyy-mm-dd')
                    order by v.regdate asc;

                       
/*7월 조회*/
create or replace view vwMonth
as
select
    to_date('2024-07-03', 'yyyy-mm-dd') + level - 1 as regdate
from dual
    connect by level <= (to_date('2024-07-31', 'yyyy-mm-dd')
                            - to_date('2024-07-03', 'yyyy-mm-dd') + 1);

select 
    v.regdate as "날짜",
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
                    order by v.regdate asc;              
                    
                    
                    
/* 특정 날짜 조회 */
create or replace view vwDate
as
select
    to_date('2024-07-03', 'yyyy-mm-dd') regdate
from dual;

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





--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--추가기능, 희원세원


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
            
