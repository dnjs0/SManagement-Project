--업무pl.sql
set serverout on;

--==========================================================
/*  공휴일  */
--==========================================================

/*추가*/

CREATE OR REPLACE PROCEDURE pInsertHoliday (
    pyear in number,
    pmonth in number,
    pday in number,
    pHolidayName IN VARCHAR2
)
is
    vcount NUMBER;
    vholiday_date date;
BEGIN

    vholiday_date := TO_DATE(pyear || '-' || pmonth || '-' || pday, 'YYYY-MM-DD');

    SELECT COUNT(*) INTO vcount 
    FROM holiday 
    WHERE holidaydate = vholiday_date; 

    -- 날짜가 존재하면 예외 처리
    IF vcount > 0 THEN
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(vholiday_date, 'YYYY-MM-DD') || ' : 이 날짜는 이미 등록된 휴일입니다! 다시 입력해주세요.');
    ELSE
        INSERT INTO holiday VALUES (holiday_seq.NEXTVAL, vholiday_date, pHolidayName);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(vholiday_date, 'YYYY-MM-DD') || ' : 휴일(' || pHolidayName || ')이 정상적으로 추가되었습니다.');
    END IF;
END pInsertHoliday;
/

-- 호출하기 매개변수 : 년,월,일
begin
    pInsertHoliday(2024,12,5, '학원휴일');
end;
/











/*수정*/
CREATE OR REPLACE PROCEDURE pUpdateHoliday (
    pyear in number,
    pmonth in number,
    pday in number,
    pholiday_name in varchar2
)
is
    vcount NUMBER;
    vholiday_date date;
BEGIN

    vholiday_date := TO_DATE(pyear || '-' || pmonth || '-' || pday, 'YYYY-MM-DD');

    SELECT COUNT(*) INTO vcount 
    FROM holiday 
    WHERE holidaydate = vholiday_date; 

    -- 날짜가 존재하면 수정
    IF vcount > 0 THEN
        UPDATE holiday 
        SET holidayname = pholiday_name
        WHERE holidaydate = vholiday_date;
        
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(vholiday_date, 'YYYY-MM-DD') || ' 휴일명이 "' || pholiday_name || '"으로 변경되었습니다.');
    
    ELSE
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(vholiday_date, 'YYYY-MM-DD') || ' 해당 날짜의 휴일 정보가 없습니다!');
    END IF;
END pUpdateHoliday;
/

-- 호출하기 매개변수 : 년,월,일,공휴일명
begin
    pUpdateHoliday(2024,12,5,'학원 쉬는날');
end;
/



















/*삭제*/
CREATE OR REPLACE PROCEDURE pDeleteHoliday(
    pyear in number,
    pmonth in number,
    pday in number
) IS
    vholiday_date date;
    vcount NUMBER;
BEGIN

    vholiday_date := TO_DATE(pyear || '-' || pmonth || '-' || pday, 'YYYY-MM-DD');
    
    SELECT COUNT(*) INTO vcount 
    FROM holiday 
    WHERE holidaydate = vholiday_date; 
    
    
    -- 날짜가 존재하면 삭제
    IF vcount > 0 THEN
        delete from holiday 
        WHERE holidaydate = vholiday_date;
        
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(vholiday_date, 'YYYY-MM-DD') || '의 휴일이 삭제되었습니다.');
    
    ELSE
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(vholiday_date, 'YYYY-MM-DD') || ' 해당 날짜의 휴일 정보가 없습니다!');
    END IF;
END pDeleteHoliday;
/

-- 호출하기 매개변수 : 년,월,일
begin
    pDeleteHoliday(2024,12,5);
end;
/


















--==========================================================
/*  학생이 보유한 자격증 view, pl/sql  */
--==========================================================
-- view
CREATE OR REPLACE VIEW vwstudent_certifications AS
select 
    s.studentName as "학생 이름", 
    c.crtfName as "보유한 자격증"
from studentCrtf sc 
inner join crtf c on sc.crtfSeq = c.crtfSeq
inner join student s on s.studentSeq = sc.studentSeq;

SELECT * FROM vwstudent_certifications;


--pl/sql
CREATE OR REPLACE PROCEDURE pstudent_certifications IS
    -- 변수 선언
    vStudentName student.studentName%TYPE;
    vCrtfName crtf.crtfName%TYPE;

    -- 커서 선언
    CURSOR student_cursor IS
        SELECT 
            s.studentName AS studentName, 
            c.crtfName AS crtfName
        FROM studentCrtf sc
        INNER JOIN crtf c ON sc.crtfSeq = c.crtfSeq
        INNER JOIN student s ON s.studentSeq = sc.studentSeq;
BEGIN
    dbms_output.put_line('====================================================================');
    dbms_output.put_line('              학생 전체 목록과 보유한 자격증');
    dbms_output.put_line('====================================================================');
    

    OPEN student_cursor;

    -- 커서에서 데이터 하나씩 가져오기
    LOOP
        FETCH student_cursor INTO vStudentName, vCrtfName;

        -- 커서 끝에 도달하면 종료
        EXIT WHEN student_cursor%NOTFOUND;

        -- 학생 이름과 자격증 출력
        DBMS_OUTPUT.PUT_LINE('학생 이름: ' || vStudentName || ', 보유한 자격증: ' || vCrtfName);
    END LOOP;

    -- 커서 닫기
    CLOSE student_cursor;
EXCEPTION
    WHEN OTHERS THEN
        -- 오류 발생 시 예외 처리
        DBMS_OUTPUT.PUT_LINE('오류 발생: ' || SQLERRM);
END pstudent_certifications;
/






-- 호출하기, 매개변수 없음
begin
    pstudent_certifications();
end;
/











SET SERVEROUTPUT ON;





--==========================================================
/* D-01 교육생 로그인 기능 */
--==========================================================
/* 조회 */
CREATE OR REPLACE PROCEDURE pStudentLogin(
    pstudentNum IN STUDENT.studentseq%TYPE,
    pstudentPW IN STUDENT.studentpw%TYPE
)
IS
    vstudentName student.studentname%TYPE;
    vstudentTel student.studenttel%TYPE;
    vstudentDate student.studentdate%TYPE;
    vcourseName course.coursename%TYPE;
    vprocessStart process.processsdate%TYPE;
    vprocessEnd process.processedate%TYPE;
    vclassroom clsroom.clsroomname%TYPE;
    vcount NUMBER;

    -- 학생 정보
    CURSOR student_cursor 
    IS
        SELECT 
            s.studentname, 
            s.studenttel, 
            s.studentdate, 
            c.coursename, 
            p.processsdate, 
            p.processedate, 
            cr.clsroomname
        FROM student s
        INNER JOIN studentcls sc ON s.studentseq = sc.studentseq
        INNER JOIN process p ON sc.processseq = p.processseq
        INNER JOIN course c ON c.courseseq = p.courseseq
        INNER JOIN clsroom cr ON cr.clsroomseq = p.clsroomseq
        WHERE s.studentseq = pstudentNum;

BEGIN
    -- 1. 학생 존재 확인, 및 비밀번호 확인
    SELECT COUNT(*) INTO vcount
    FROM student 
    WHERE studentseq = pstudentNum AND studentpw = pstudentPW;
    
    IF vcount = 0 THEN
        DBMS_OUTPUT.PUT_LINE('로그인 실패: 학번 또는 비밀번호가 틀렸습니다.');
        RETURN;
    END IF;

    -- 2. 학생 정보 출력
    OPEN student_cursor;
    
    FETCH student_cursor INTO 
        vstudentName, vstudentTel, vstudentDate, 
        vcourseName, vprocessStart, vprocessEnd, vclassroom;
    
    IF student_cursor%NOTFOUND THEN
        DBMS_OUTPUT.PUT_LINE('학생 정보가 존재하지 않습니다.');
    ELSE
        DBMS_OUTPUT.PUT_LINE(' 로그인 성공!');
        DBMS_OUTPUT.PUT_LINE('--------------------------------------');
        DBMS_OUTPUT.PUT_LINE('이름: ' || vstudentName);
        DBMS_OUTPUT.PUT_LINE('전화번호: ' || vstudentTel);
        DBMS_OUTPUT.PUT_LINE('등록일: ' || TO_CHAR(vstudentDate, 'YYYY-MM-DD'));
        DBMS_OUTPUT.PUT_LINE('과정명: ' || vcourseName);
        DBMS_OUTPUT.PUT_LINE('과정 시작일: ' || TO_CHAR(vprocessStart, 'YYYY-MM-DD'));
        DBMS_OUTPUT.PUT_LINE('과정 종료일: ' || TO_CHAR(vprocessEnd, 'YYYY-MM-DD'));
        DBMS_OUTPUT.PUT_LINE('강의실: ' || vclassroom);
        DBMS_OUTPUT.PUT_LINE('--------------------------------------');
    END IF;
    
    CLOSE student_cursor;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('로그인 실패: 학번 또는 비밀번호가 틀렸습니다.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류 발생!');
END pStudentLogin;
/


-- 호출문의 매개변수 : 학생 번호
BEGIN
    pStudentLogin(1,2345678);
END;
/







set serveroutput on ;


--==========================================================
/* D-02 교육생 개인성적정보 확인기능 */
--==========================================================

CREATE OR REPLACE PROCEDURE pStudentInfo(
    p_studentseq IN NUMBER
) 
as
BEGIN
    FOR rec IN (
        SELECT 
            pc.subjectseq AS 과목번호,
            sj.subjectname AS 과목명,
            pc.prcsubjectsdate || ' ~ ' || pc.prcsubjectedate AS "과목 진행 기간",
            b.bookname AS 교재명,
            t.teachername AS 교사명,
            '(' || sa.attendallot || ', ' || sa.writingallot || ' ,' || sa.realallot || ')' AS "과목별 배점정보(출석, 필기, 실기)",
            '('||score.attendancescore||', '||score.writingscore  ||' ,'|| score.realscore ||')'  as "과목별 성적정보(출석, 필기, 실기)",
            score.totalscore AS "과목별 총점수",
            test.testtype AS 시험유형,
            test.testdate AS 시험날짜,
            test.testcontext AS 시험문제
        FROM prcsubject pc
            INNER JOIN subject sj ON sj.subjectseq = pc.subjectseq
            INNER JOIN sbjectbook sb ON sb.subjectseq = pc.subjectseq
            INNER JOIN book b ON b.bookseq = sb.bookseq
            INNER JOIN process p ON p.processseq = pc.processseq
            INNER JOIN teacher t ON t.teacherseq = p.teacherseq
            INNER JOIN scoreallot sa ON sa.prcsubjectseq = pc.prcsubjectseq
            INNER JOIN test ON test.teacherseq = t.teacherseq AND pc.subjectseq = test.subjectseq
            INNER JOIN studentcls scl ON scl.processseq = p.processseq
            INNER JOIN student st ON st.studentseq = scl.studentseq
            INNER JOIN score ON score.subjectseq = pc.subjectseq AND score.studentseq = st.studentseq
        WHERE st.studentseq = p_studentseq 
            AND pc.processseq = (SELECT processseq FROM studentcls WHERE studentseq = p_studentseq)
            AND test.teacherseq = (SELECT teacherseq FROM process WHERE processseq = (SELECT processseq FROM studentcls WHERE studentseq = p_studentseq))
            AND test.testdate BETWEEN p.processsdate AND p.processedate
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('과목번호: ' || rec.과목번호);
        DBMS_OUTPUT.PUT_LINE('과목명: ' || rec.과목명);
        DBMS_OUTPUT.PUT_LINE('과목 진행 기간: ' || rec."과목 진행 기간");
        DBMS_OUTPUT.PUT_LINE('교재명: ' || rec.교재명);
        DBMS_OUTPUT.PUT_LINE('교사명: ' || rec.교사명);
        DBMS_OUTPUT.PUT_LINE('과목별 배점정보(출석, 필기, 실기): ' || rec."과목별 배점정보(출석, 필기, 실기)");
        DBMS_OUTPUT.PUT_LINE('과목별 성적정보(출석, 필기, 실기): ' || rec."과목별 성적정보(출석, 필기, 실기)");
        DBMS_OUTPUT.PUT_LINE('과목별 총점수: ' || rec."과목별 총점수");
        DBMS_OUTPUT.PUT_LINE('시험유형: ' || rec.시험유형);
        DBMS_OUTPUT.PUT_LINE('시험날짜: ' || rec.시험날짜);
        DBMS_OUTPUT.PUT_LINE('시험문제: ' || rec.시험문제);
        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------');
    END LOOP;
END pStudentInfo;
/



-- 호출문의 매개변수 : 학생 번호
BEGIN
    pStudentInfo(27);
END;
/




SET SERVEROUTPUT ON;

--==========================================================
/* D-03 교육생 출결관리 기능 */
--==========================================================
-- 출결 조회하기
CREATE OR REPLACE PROCEDURE pStudentAttendance(
    pstudentNum IN attendance.studentseq%TYPE
)
IS
    CURSOR cur_attendance IS
        SELECT 
            attendancedate AS 날짜,
            TO_CHAR(attendancestime, 'HH24:MI') AS 등원시간,
            TO_CHAR(attendanceetime, 'HH24:MI') AS 하원시간
        FROM attendance
        WHERE studentseq = pstudentNum
        ORDER BY attendancedate;

    v_attendancedate attendance.attendancedate%TYPE;
    v_attendancestime VARCHAR2(5);
    v_attendanceetime VARCHAR2(5);

BEGIN
    OPEN cur_attendance;
    
    LOOP
        FETCH cur_attendance INTO 
            v_attendancedate, v_attendancestime, v_attendanceetime;
        
        EXIT WHEN cur_attendance%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('날짜: ' || TO_CHAR(v_attendancedate, 'YYYY-MM-DD'));
        DBMS_OUTPUT.PUT_LINE('등원 시간: ' || v_attendancestime);
        DBMS_OUTPUT.PUT_LINE('하원 시간: ' || v_attendanceetime);
        DBMS_OUTPUT.PUT_LINE('-------------------------------------');
    END LOOP;

    CLOSE cur_attendance;
END;
/
set serveroutput on;
-- 호출문의 매개변수 : 학생 번호
BEGIN
    pStudentAttendance(1);
END;
/


-----------------------------------------------------------------------------------


-- 특정 날짜(2024-07-24) 출결 조회하기
CREATE OR REPLACE PROCEDURE pStudentAttendanceDate(
    pstudentNum IN attendance.studentseq%TYPE,
    pyear IN NUMBER,
    pmonth IN NUMBER,
    pdate IN NUMBER
)
IS
    CURSOR cur_attendance IS
        SELECT 
            attendancedate AS 날짜,
            TO_CHAR(attendancestime, 'HH24:MI') AS 등원시간,
            TO_CHAR(attendanceetime, 'HH24:MI') AS 하원시간
        FROM attendance
        WHERE studentseq = pstudentNum
            AND EXTRACT(year FROM attendancedate) = pyear
            AND EXTRACT(MONTH FROM attendancedate) = pmonth
            AND EXTRACT(day FROM attendancedate) = pdate
        ORDER BY attendancedate;

    vattendancedate attendance.attendancedate%TYPE;
    vattendancestime VARCHAR2(5);
    vattendanceetime VARCHAR2(5);

BEGIN
    OPEN cur_attendance;
    
    LOOP
        FETCH cur_attendance INTO 
            vattendancedate, vattendancestime, vattendanceetime;
        
        EXIT WHEN cur_attendance%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('-------------------------------------');
        DBMS_OUTPUT.PUT_LINE('날짜: ' || TO_CHAR(vattendancedate, 'YYYY-MM-DD'));
        DBMS_OUTPUT.PUT_LINE('등원 시간: ' || vattendancestime);
        DBMS_OUTPUT.PUT_LINE('하원 시간: ' || vattendanceetime);
        DBMS_OUTPUT.PUT_LINE('-------------------------------------');
    END LOOP;

    CLOSE cur_attendance;
END;
/


-- 호출문의 매개변수 : 학생 번호,년,월,일
BEGIN
    pStudentAttendanceDate(1,2024,7,24);
END;
/

--오늘 날짜 조회, 출석있으면 삭제하고 실행
SELECT * FROM ATTENDANCE WHERE ATTENDANCEDATE = TRUNC(SYSDATE) AND STUDENTSEQ=1;
DELETE FROM ATTENDANCE WHERE  ATTENDANCEDATE = TRUNC(SYSDATE) AND STUDENTSEQ=1;
----------------------------------------------------------------

--출석 입력하기, 등원 추가
CREATE OR REPLACE PROCEDURE pInsertAttendance(
    pstudentNum IN attendance.studentseq%TYPE
)
IS
    vstudentName student.studentname%TYPE;
    vprocessnum number;
    vcount number;
BEGIN
    select 
        studentname into vstudentName
    from student where studentseq = pstudentNum;
    
    
    select DISTINCT
        processSeq into vprocessnum
    from attendance where studentseq = pstudentNum;
    
    -- 출석을 했는가 예외처리
    SELECT COUNT(*) 
    INTO vcount
    FROM attendance
    WHERE studentseq = pstudentNum
      AND attendancedate = TRUNC(SYSDATE);
    
    -- 이미 출석을 한 경우 종료
    IF vcount > 0 THEN
        DBMS_OUTPUT.PUT_LINE(vstudentName || ' 학생은 이미 출석이 기록되어 있습니다.');
        RETURN;
    END IF;
    
    
    
    INSERT INTO attendance (
        attendanceseq, 
        studentseq,
        processseq,
        attendancedate, 
        attendancestime, 
        attendanceetime, 
        attendancest
    ) VALUES (
        attendance_seq.NEXTVAL,     
        pstudentNum, 
        vprocessnum,
        TRUNC(SYSDATE),             -- 현재 날짜 (시간 00:00:00)
        SYSDATE,                    -- 현재 시간으로 출석 시간 기록
        NULL,                       -- 퇴근
        '출석'                     
    );

    -- 변경 사항 저장
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE(vstudentname||' 학생, '|| '출석 등록 완료 (' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') || ')');
    
EXCEPTION
    WHEN OTHERS THEN
        -- 에러 발생 시 롤백
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('오류 발생'||SQLERRM);
END ;
/


-- 호출문의 매개변수 : 학생 번호
BEGIN
    pInsertAttendance(1);
END;
/

---------------------------------------------------------------------------------
-- 수업종료 입력하기, 하원 추가
CREATE OR REPLACE PROCEDURE pUpdateAttendance(
    pstudentNum IN attendance.studentseq%TYPE
)
IS
    vattendancestime DATE;
    vstudentName varchar2(50);
    vstatus VARCHAR2(10);
    vcount number;

BEGIN

    select 
        max(studentname) into vstudentName
    from student where studentseq = pstudentNum;
    
    
    -- 하원을 했는가 예외처리
    SELECT COUNT(*) 
    INTO vcount
    FROM attendance
    WHERE studentseq = pstudentNum
      AND attendancedate = TRUNC(SYSDATE)
      and attendanceetime is not null;
    
    -- 이미 하원을 한 경우 종료
    IF vcount > 0 THEN
        DBMS_OUTPUT.PUT_LINE(vstudentName || ' 학생은 이미 하원이 기록되어 있습니다.');
        RETURN;
    END IF;
    
    
    SELECT min(attendancestime)
    INTO vattendancestime
    FROM attendance
    WHERE studentseq = pstudentNum
      AND attendancedate = TRUNC(SYSDATE)  
      AND attendanceetime IS NULL;

    -- 등원 시간이 NULL -> 지각(하원은 등록했기때문)
    IF vattendancestime IS NULL THEN
        vstatus := '지각';

    -- 정상 출석
    ELSIF TO_CHAR(vattendancestime, 'HH24:MI') <= '09:00' 
      AND TO_CHAR(SYSDATE, 'HH24:MI') >= '18:00' THEN
        vstatus := '정상';
        

    -- 지각 (등원이 09:00 이후)
    ELSIF TO_CHAR(vattendancestime, 'HH24:MI') > '09:00' THEN
        vstatus := '지각';

    -- 조퇴 (하원이 18:00 이전)
    ELSIF TO_CHAR(SYSDATE, 'HH24:MI') < '18:00' THEN
        vstatus := '조퇴';

    END IF;

    --업데이트
    UPDATE attendance
    SET attendanceetime = SYSDATE,
        attendancest = vstatus
    WHERE studentseq = pstudentNum
      AND attendancedate = TRUNC(SYSDATE)  
      AND attendanceetime IS NULL;

    --저장
    COMMIT;

    DBMS_OUTPUT.PUT_LINE(vstudentname ||' 학생, '|| ' 퇴근 등록 완료 (' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') || ')');
    DBMS_OUTPUT.PUT_LINE('출석 상태: ' || vstatus);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('출석 기록 없음: ' ||  vstudentName || '의 오늘 출석 정보가 없습니다.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('오류 발생: ' || SQLERRM);
END;
/


-- 호출문의 매개변수 : 학생 번호
BEGIN
    pUpdateAttendance(1);
END;
/




--==========================================================
/* D-04 교육생 출결조회 기능 */
--==========================================================
--날짜의 뷰 먼저 생성
create or replace view vwTotalDate
as
select
    to_date('2024-07-03', 'yyyy-mm-dd') + level - 1 as regdate
from dual
    connect by level <= (to_date('2025-08-24', 'yyyy-mm-dd')
                            - to_date('2024-07-03', 'yyyy-mm-dd') + 1);
                                                        

----------------------------------------------------------------------------------
--1. 1번 학생의 출결전체 조회 
-- 선언문
CREATE OR REPLACE PROCEDURE pAttendanceStudentTotal(
    pstudentNum in STUDENT.studentseq%type
)
is
    vname student.studentname%type;
    vdate date;
    vresult varchar2(50);
    vstartdate date;
    venddate date;
    
    cursor vcursor
    is
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
            AND t.studentseq = pstudentNum 
                left outer join holiday h
                    on to_char(v.regdate, 'yyyy-mm-dd') = to_char(h.holidaydate, 'yyyy-mm-dd')
                    WHERE v.regdate BETWEEN vstartdate AND venddate
                        order by v.regdate asc;

    
begin
    select studentname into vname from student where studentseq=pstudentNum;
    
    SELECT processsdate,processedate
    INTO vstartdate, venddate
    FROM process
    where processseq=1;
    dbms_output.put_line(vname||' 학생의 출석부');
    dbms_output.put_line('----------------------------------------------------');
    dbms_output.put_line('조회할 기간 : '|| TO_CHAR(vstartdate, 'YYYY-MM-DD') || ' ~ ' || TO_CHAR(venddate, 'YYYY-MM-DD'));
    
    open vcursor;
    
    loop    
        fetch vcursor into vdate,vresult;
        exit when vcursor%notfound;
        
        DBMS_OUTPUT.PUT_LINE('['||TO_CHAR(vdate, 'YYYY-MM-DD')||']  ' || vresult);
        
    end loop;
    close vcursor;

end;
/                            

-- 호출문의 매개변수 : 학생 번호
BEGIN
    pAttendanceStudentTotal(1);
END;
/


--------------------------------------------------------------------------------
--2. 1번 학생의 특정 월(7월) 출결 조회
-- 선언문
CREATE OR REPLACE PROCEDURE pAttendanceStudentMonth(
    pstudentNum in STUDENT.studentseq%type,
    pyear in number,
    pmonth in number
)
is
    vname student.studentname%type;
    vdate date;
    vresult varchar2(50);
    vstartdate date;
    venddate date;

    cursor vcursor
    is
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
                AND t.studentseq = pstudentNum 
                    left outer join holiday h
                        on to_char(v.regdate, 'yyyy-mm-dd') = to_char(h.holidaydate, 'yyyy-mm-dd')
                            WHERE extract(year from v.regdate) = pyear
                                and extract(month from v.regdate) = pmonth
                                    order by v.regdate asc;

    
begin
    select studentname into vname from student where studentseq=pstudentNum;
    

    dbms_output.put_line(vname||' 학생의 출석부');
    dbms_output.put_line('----------------------------------------------------');
    dbms_output.put_line('조회할 월 : '||pyear || '년 ' || pmonth|| '월 ');
    
    open vcursor;
    
    loop    
        fetch vcursor into vdate,vresult;
        exit when vcursor%notfound;
        
        DBMS_OUTPUT.PUT_LINE('['||TO_CHAR(vdate, 'YYYY-MM-DD')||']  ' || vresult);
        
    end loop;
    close vcursor;

end;
/                            

-- 매개변수 : 학생 번호, 년, 월
-- 호출문
BEGIN
    pAttendanceStudentMonth(1,2024,7);
END;
/

---------------------------------------------------------------------------------
--3. 1번 학생의 특정 날짜 출결 조회
-- 선언문
CREATE OR REPLACE PROCEDURE pAttendanceStudentDate(
    pstudentNum in STUDENT.studentseq%type,
    pyear in number,
    pmonth in number,
    pdate in number
)
is
    vname student.studentname%type;
    vdate date;
    vresult varchar2(50);

    cursor vcursor
    is
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
                AND t.studentseq = pstudentNum 
                    left outer join holiday h
                        on to_char(v.regdate, 'yyyy-mm-dd') = to_char(h.holidaydate, 'yyyy-mm-dd')
                            WHERE extract(year from v.regdate) = pyear
                                and extract(month from v.regdate) = pmonth
                                and extract(day from v.regdate) = pdate
                                    order by v.regdate asc;

    
begin
    select studentname into vname from student where studentseq=pstudentNum;
    

    dbms_output.put_line(vname||' 학생의 출석부');
    dbms_output.put_line('----------------------------------------------------');
    dbms_output.put_line('조회할 날짜 : '||pyear || '년 ' || pmonth|| '월 '|| pdate|| '일 ');
    
    open vcursor;
    
    loop    
        fetch vcursor into vdate,vresult;
        exit when vcursor%notfound;
        
        DBMS_OUTPUT.PUT_LINE('['||TO_CHAR(vdate, 'YYYY-MM-DD')||']  ' || vresult);
        
    end loop;
    close vcursor;

end;
/                            

-- 매개변수 : 학생 번호, 년, 월
-- 호출문
BEGIN
    pAttendanceStudentDate(1,2024,7,24);
END;
/


--===========================================================================================================================
--===========================================================================================================================
--==========================================================
/* C-05. 출결 관리 및 출결 조회 */
--==========================================================
--날짜의 뷰 먼저 생성
create or replace view vwTotalDate
as
select
    to_date('2024-07-03', 'yyyy-mm-dd') + level - 1 as regdate
from dual
    connect by level <= (to_date('2025-08-24', 'yyyy-mm-dd')
                            - to_date('2024-07-03', 'yyyy-mm-dd') + 1);




--1. 2번 교사가 강의한 1번 과정의 모든 교육생의 출결
CREATE OR REPLACE PROCEDURE pAttendanceTeacherTotal(
    pteacherNum IN teacher.teacherseq%TYPE,
    pprocessNum IN process.processseq%TYPE
)
IS
    vteacherName teacher.teachername%TYPE;
    vstudentName student.studentname%TYPE;
    vdate DATE;
    vresult VARCHAR2(50);
    vstartdate date;
    venddate date;
    
    -- 교육생 목록 조회를 위한 커서
    CURSOR student_cursor IS
        SELECT s.studentseq, s.studentname
        FROM student s
        JOIN studentcls sc ON s.studentseq = sc.studentseq
        WHERE sc.processseq = pprocessNum;
    
    -- 특정 교육생의 출결 조회를 위한 커서
    CURSOR attendance_cursor(pstudentNum student.studentseq%TYPE) IS
        SELECT 
            v.regdate AS "날짜",
            CASE
                WHEN TO_CHAR(v.regdate, 'd') = '1' THEN '일요일'
                WHEN TO_CHAR(v.regdate, 'd') = '7' THEN '토요일'
                WHEN h.holidayseq IS NOT NULL THEN h.holidayname
                WHEN h.holidayseq IS NULL AND t.attendanceseq IS NULL THEN '결석'
                ELSE t.attendancest
            END AS "상태"
        FROM vwTotalDate v
        LEFT JOIN attendance t 
            ON TO_CHAR(v.regdate, 'yyyy-mm-dd') = TO_CHAR(t.attendancedate, 'yyyy-mm-dd')
            AND t.studentseq = pstudentNum
        LEFT JOIN holiday h 
            ON TO_CHAR(v.regdate, 'yyyy-mm-dd') = TO_CHAR(h.holidaydate, 'yyyy-mm-dd')
                WHERE v.regdate BETWEEN vstartdate AND venddate
                     ORDER BY v.regdate ASC;

BEGIN
    -- 교사 이름 
    SELECT teachername INTO vteacherName 
    FROM teacher 
    WHERE teacherseq = pteacherNum;
    
    -- 과정의 시작일과 종료일 가져오기
    SELECT processsdate, processedate INTO vstartdate, venddate
    FROM process 
    WHERE processseq = pprocessNum;

    DBMS_OUTPUT.PUT_LINE(vteacherName || ' 강사의 ' || pprocessNum || '번 과정 출석부');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('조회할 기간 : ' || vstartdate || '~ ' || venddate);
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');

    -- 학생 목록
    FOR student_rec IN student_cursor LOOP
        vstudentName := student_rec.studentname;
        DBMS_OUTPUT.PUT_LINE(vstudentName);

        -- 특정 학생의 출결
        OPEN attendance_cursor(student_rec.studentseq);
        
        LOOP
            FETCH attendance_cursor INTO vdate, vresult;
            EXIT WHEN attendance_cursor%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('  [' || TO_CHAR(vdate, 'YYYY-MM-DD') || '] ' || vresult);
        END LOOP;

        CLOSE attendance_cursor;
    END LOOP;
END;
/

-- 매개변수 : 교사번호,과정
-- 호출문
BEGIN
    pAttendanceTeacherTotal(2,1);
END;
/




----------------------------------------------------------------------------------
--2. 2번 교사가 강의한 1번 과정의 월 입력시 모든 교육생의 출결
CREATE OR REPLACE PROCEDURE pAttendanceTeacherMonth(
    pteacherNum IN teacher.teacherseq%TYPE,
    pprocessNum IN process.processseq%TYPE,
    pyear IN NUMBER,
    pmonth IN NUMBER
)
IS
    vteacherName teacher.teachername%TYPE;
    vstudentName student.studentname%TYPE;
    vdate DATE;
    vresult VARCHAR2(50);
    
    -- 교육생 목록 조회를 위한 커서
    CURSOR student_cursor IS
        SELECT s.studentseq, s.studentname
        FROM student s
        JOIN studentcls sc ON s.studentseq = sc.studentseq
        WHERE sc.processseq = pprocessNum;
    
    -- 특정 교육생의 출결 조회를 위한 커서
    CURSOR attendance_cursor(pstudentNum student.studentseq%TYPE) IS
        SELECT 
            v.regdate AS "날짜",
            CASE
                WHEN TO_CHAR(v.regdate, 'd') = '1' THEN '일요일'
                WHEN TO_CHAR(v.regdate, 'd') = '7' THEN '토요일'
                WHEN h.holidayseq IS NOT NULL THEN h.holidayname
                WHEN h.holidayseq IS NULL AND t.attendanceseq IS NULL THEN '결석'
                ELSE t.attendancest
            END AS "상태"
        FROM vwTotalDate v
        LEFT JOIN attendance t 
            ON TO_CHAR(v.regdate, 'yyyy-mm-dd') = TO_CHAR(t.attendancedate, 'yyyy-mm-dd')
            AND t.studentseq = pstudentNum
        LEFT JOIN holiday h 
            ON TO_CHAR(v.regdate, 'yyyy-mm-dd') = TO_CHAR(h.holidaydate, 'yyyy-mm-dd')
        WHERE EXTRACT(YEAR FROM v.regdate) = pyear
          AND EXTRACT(MONTH FROM v.regdate) = pmonth
        ORDER BY v.regdate ASC;

BEGIN
    -- 교사 이름 
    SELECT teachername INTO vteacherName 
    FROM teacher 
    WHERE teacherseq = pteacherNum;

    DBMS_OUTPUT.PUT_LINE(vteacherName || ' 강사의 ' || pprocessNum || '번 과정 출석부');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('조회할 월 : ' || pyear || '년 ' || pmonth || '월 ');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');

    -- 학생 목록
    FOR student_rec IN student_cursor LOOP
        vstudentName := student_rec.studentname;
        DBMS_OUTPUT.PUT_LINE(vstudentName);

        -- 특정 학생의 출결
        OPEN attendance_cursor(student_rec.studentseq);
        
        LOOP
            FETCH attendance_cursor INTO vdate, vresult;
            EXIT WHEN attendance_cursor%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('  [' || TO_CHAR(vdate, 'YYYY-MM-DD') || '] ' || vresult);
        END LOOP;

        CLOSE attendance_cursor;
    END LOOP;
END;
/

-- 매개변수 : 교사번호,과정, 년
-- 호출문
BEGIN
    pAttendanceTeacherMonth(2,1,2024,7);
END;
/





-------------------------------------------------------------------------------------
--3. 2번 교사가 강의한 1번 과정의 날짜 입력시 모든 교육생의 출결
CREATE OR REPLACE PROCEDURE pAttendanceTeacherDate(
    pteacherNum IN teacher.teacherseq%TYPE,
    pprocessNum IN process.processseq%TYPE,
    pyear IN NUMBER,
    pmonth IN NUMBER,
    pdate IN NUMBER
)
IS
    vteacherName teacher.teachername%TYPE;
    vstudentName student.studentname%TYPE;
    vdate DATE;
    vresult VARCHAR2(50);
    
    -- 교육생 목록 조회를 위한 커서
    CURSOR student_cursor IS
        SELECT s.studentseq, s.studentname
        FROM student s
        JOIN studentcls sc ON s.studentseq = sc.studentseq
        WHERE sc.processseq = pprocessNum;
    
    -- 특정 교육생의 출결 조회를 위한 커서
    CURSOR attendance_cursor(pstudentNum student.studentseq%TYPE) IS
        SELECT 
            v.regdate AS "날짜",
            CASE
                WHEN TO_CHAR(v.regdate, 'd') = '1' THEN '일요일'
                WHEN TO_CHAR(v.regdate, 'd') = '7' THEN '토요일'
                WHEN h.holidayseq IS NOT NULL THEN h.holidayname
                WHEN h.holidayseq IS NULL AND t.attendanceseq IS NULL THEN '결석'
                ELSE t.attendancest
            END AS "상태"
        FROM vwTotalDate v
        LEFT JOIN attendance t 
            ON TO_CHAR(v.regdate, 'yyyy-mm-dd') = TO_CHAR(t.attendancedate, 'yyyy-mm-dd')
            AND t.studentseq = pstudentNum
        LEFT JOIN holiday h 
            ON TO_CHAR(v.regdate, 'yyyy-mm-dd') = TO_CHAR(h.holidaydate, 'yyyy-mm-dd')
        WHERE EXTRACT(YEAR FROM v.regdate) = pyear
          AND EXTRACT(MONTH FROM v.regdate) = pmonth
          AND EXTRACT(DAY FROM v.regdate) = pdate
        ORDER BY v.regdate ASC;

BEGIN
    -- 교사 이름 
    SELECT teachername INTO vteacherName 
    FROM teacher 
    WHERE teacherseq = pteacherNum;

    DBMS_OUTPUT.PUT_LINE(vteacherName || ' 강사의 ' || pprocessNum || '번 과정 출석부');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('조회할 날짜 : ' || pyear || '년 ' || pmonth || '월 ' || pdate || '일');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');

    -- 학생 목록
    FOR student_rec IN student_cursor LOOP
        vstudentName := student_rec.studentname;

        -- 특정 학생의 출결
        OPEN attendance_cursor(student_rec.studentseq);
        
        LOOP
            FETCH attendance_cursor INTO vdate, vresult;
            EXIT WHEN attendance_cursor%NOTFOUND;

            DBMS_OUTPUT.PUT_LINE(vstudentName||' : '|| vresult);
        END LOOP;

        CLOSE attendance_cursor;
    END LOOP;
END;
/

-- 매개변수 : 교사번호,과정, 년, 월
-- 호출문
BEGIN
    pAttendanceTeacherDate(2,1,2024,7,24);
END;
/































