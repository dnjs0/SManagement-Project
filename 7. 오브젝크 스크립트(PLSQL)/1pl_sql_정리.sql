/*
B. 관리자	
업무 영역	관리자
요구사항 명	B-01. 관리자 계정 – 관리자 기능
개요	관리자 계정
상세설명	
관리자는 3~5명으로 모두 동일한 권한을 가진다. 또 관리자 계정은 하위 기능을 모두 관리할 수 있다.	
	
1)기초 정보 관리	
2)교사 계정 관리	
3)개설 과정 관리	
4)개설 과목 관리	
5)교육생 관리	
6)시험 관리 및 성적 조회	
7)출결 관리 및 출결 조회	
	
	
제약사항	
- 관리자 계정은 가입 절차 없이 사전에 데이터베이스에 등록하여 사용한다.	
- 관리자 기능은 로그인 후에 사용가능하다.	
*/


drop sequence admin_seq;
create sequence admin_seq;

-- //////////////////////////////// B-01. 관리자 계정////////////////////////// 

--/*추가*/AdminInsert
create or replace procedure adminInsert( 
    pName Admin.AdminName%type,
    pTel Admin.AdminTel%type,
    pPw Admin.AdminPw%type
)
is
    v_AdminSeq NUMBER;
BEGIN  
    -- 관리자 정보 삽입
    v_AdminSeq := admin_seq.NEXTVAL;
    INSERT INTO Admin (AdminSeq, AdminName, AdminTel, AdminPw)   
    VALUES (v_AdminSeq, pName, pTel, pPw);    
     
    DBMS_OUTPUT.PUT_LINE('추가된 관리자 번호: ' || v_AdminSeq);  
    DBMS_OUTPUT.PUT_LINE('관리자 이름: ' || pName);  
    DBMS_OUTPUT.PUT_LINE('관리자 전화번호: ' || pTel);
    DBMS_OUTPUT.PUT_LINE('관리자 비밀번호: ' || pPw);
    
EXCEPTION  
    WHEN OTHERS THEN  
        ROLLBACK; -- 오류 발생시 롤백  
        DBMS_OUTPUT.PUT_LINE('오류 발생: ' || SQLERRM); 
END;  
/
--adminInsert(관리자이름, 관리자전화번호, 관리자비밀번호);
begin
    adminInsert('김우현', '010-9193-3250', 1493870);
end;
/

--/*조회*/AdminRead
CREATE OR REPLACE PROCEDURE adminRead IS  
    CURSOR admin_cursor IS  
        SELECT AdminSeq ,   
               AdminName,   
               AdminTel ,   
               AdminPw   
        FROM Admin;  

    v_AdminSeq Admin.AdminSeq%TYPE;  
    v_AdminName Admin.AdminName%TYPE;  
    v_AdminTel Admin.AdminTel%TYPE;  
    v_AdminPw Admin.AdminPw%TYPE;  

BEGIN  
    OPEN admin_cursor;  -- 커서를 여는 부분  

    LOOP  
        FETCH admin_cursor INTO v_AdminSeq, v_AdminName, v_AdminTel, v_AdminPw;  -- 커서로부터 값을 읽어옴  
        EXIT WHEN admin_cursor%NOTFOUND;  -- 더 이상 읽을 것이 없으면 루프 종료  

        -- 결과 출력  
        DBMS_OUTPUT.PUT_LINE('관리자 번호: ' || v_AdminSeq ||   
                             ', 관리자 이름: ' || v_AdminName ||   
                             ', 전화번호: ' || v_AdminTel ||   
                             ', 비밀번호: ' || v_AdminPw);  
    END LOOP;  

    CLOSE admin_cursor;  -- 커서를 닫는 부분  

EXCEPTION  
    WHEN OTHERS THEN  
        DBMS_OUTPUT.PUT_LINE('오류 발생: ' || SQLERRM);   
END;  
/
--adminRead();
begin
    adminRead();
end;
/

--/*수정*/AdminUpdate
CREATE OR REPLACE PROCEDURE adminUpdate(  
    p_AdminSeq Admin.AdminSeq%TYPE,  
    p_AdminName Admin.AdminName%TYPE,  
    p_AdminTel Admin.AdminTel%TYPE,  
    p_AdminPw Admin.AdminPw%TYPE  
) IS  
BEGIN  
    -- 관리자 정보 업데이트  
    UPDATE Admin  
    SET AdminName = p_AdminName,  
        AdminTel = p_AdminTel,  
        AdminPw = p_AdminPw  
    WHERE AdminSeq = p_AdminSeq;  

    -- 변경된 행 수를 확인하고 출력  
    IF SQL%ROWCOUNT > 0 THEN  
        DBMS_OUTPUT.PUT_LINE('관리자 번호 ' || p_AdminSeq || '가(이) 성공적으로 업데이트되었습니다.');  
    ELSE  
        DBMS_OUTPUT.PUT_LINE('관리자 번호 ' || p_AdminSeq || '은(는) 존재하지 않거나 업데이트할 데이터가 없습니다.');  
    END IF;  

EXCEPTION  
    WHEN OTHERS THEN  
        ROLLBACK;  -- 오류 발생 시 롤백  
        DBMS_OUTPUT.PUT_LINE('오류 발생: ' || SQLERRM);   
END;
/
--adminUpdate(관리자번호,관리자이름,관리자전화번호,관리자비밀번호);
begin
    adminUpdate(1, '김우현', '010-9193-3250', 1493870);
end;
/

-- /*삭제*/AdminDELETE
CREATE OR REPLACE PROCEDURE AdminDELETE(  
    p_AdminSeq Admin.AdminSeq%TYPE  
) IS  
BEGIN  
    -- 관리자 정보 업데이트  
    UPDATE Admin  
    SET AdminName = '없음',  
        AdminTel = '없음',  
        AdminPw = 0  
    WHERE AdminSeq = p_AdminSeq;  

    -- 변경된 행 수를 확인하고 출력  
    IF SQL%ROWCOUNT > 0 THEN  
        DBMS_OUTPUT.PUT_LINE('관리자 순서 번호 ' || p_AdminSeq || '가(이) 성공적으로 초기화되었습니다.');  
    ELSE  
        DBMS_OUTPUT.PUT_LINE('관리자 순서 번호 ' || p_AdminSeq || '은(는) 존재하지 않거나 업데이트할 데이터가 없습니다.');  
    END IF;  

EXCEPTION  
    WHEN OTHERS THEN  
        ROLLBACK;  -- 오류 발생 시 롤백  
        DBMS_OUTPUT.PUT_LINE('오류 발생: ' || SQLERRM);   
END;  
/
-- AdminDELETE(관리자번호);
begin
    AdminDELETE(1);
end;
/








/*
업무 영역	관리자
요구사항 명	B-02. 기초 정보 관리 기능
개요	개설 과정, 개설 과목에 사용하게 될 기초 정보를 등록 및 관리한다.
상세설명	
1.과정명 관리	
- 과정명을 등록, 수정, 삭제, 조회 할 수 있다.	
2.과목명 관리	
- 과목명을 등록, 수정, 삭제, 조회 할 수 있다.	
- 필수 과목과 선택 과목이 있다.	
- 과목은 30~50과목이 있다.	
3.강의실명 관리	
- 강의실명을 등록, 수정, 삭제, 조회 할 수 있다.	
- 강의실은 총 6개로 1,2,3강의실은 정원이 30명, 4,5,6강의실은 정원이 26명이다.	
4.교재명 관리	
-교재명을 등록, 수정, 삭제, 조회 할 수 있다.	
-1과목에는 교재 1권이 존재한다.	
	
제약사항	
기초 정보에 대한 입력, 출력, 수정, 삭제 기능을 사용할 수 있어야 한다.	
*/



-- //////////////////////////////////////// B-02. 기초정보(과정) 관리 CRUD/////////////////////////////////
--/*추가*/CourseInsert
create or replace procedure CourseInsert( 
    pCourseName Course.courseName%type
)
is
    v_CourseSeq NUMBER;
BEGIN  
    -- 관리자 정보 삽입
    v_CourseSeq := course_seq.NEXTVAL;
    INSERT INTO Course (courseSeq,courseName)   
    VALUES (v_CourseSeq,pCourseName);    
     
    DBMS_OUTPUT.PUT_LINE('추가된 과정 번호: ' || v_CourseSeq);  
    DBMS_OUTPUT.PUT_LINE('추가된 과정 이름: ' || pCourseName);  
    
    
EXCEPTION  
    WHEN OTHERS THEN  
        ROLLBACK; -- 오류 발생시 롤백  
        DBMS_OUTPUT.PUT_LINE('오류 발생: ' || SQLERRM); 
END;  
/
--CourseInsert(과정명)
Begin
    CourseInsert(q'[AWS와 Docker & Kubernetes를 활용한 Java Full-Stack 개발자 양성과정]');
end;
/


--/*조회*/CourseRead
CREATE OR REPLACE PROCEDURE CourseRead IS  
    CURSOR Course_cursor IS  
        SELECT CourseSeq,   
               CourseName   
                  
        FROM Course;  

    v_CourseSeq Course.CourseSeq%TYPE;  
    v_CourseName Course.CourseName%TYPE;  
    
BEGIN  
    OPEN Course_cursor;  -- 커서를 여는 부분  

    LOOP  
        FETCH Course_cursor INTO v_CourseSeq, v_CourseName;  -- 커서로부터 값을 읽어옴  
        EXIT WHEN Course_cursor%NOTFOUND;  -- 더 이상 읽을 것이 없으면 루프 종료  

        -- 결과 출력  
        DBMS_OUTPUT.PUT_LINE('과정번호: ' || v_CourseSeq ||   
                             ', 과정이름: ' || v_CourseName);  
    END LOOP;  

    CLOSE Course_cursor;  -- 커서를 닫는 부분  

EXCEPTION  
    WHEN OTHERS THEN  
        DBMS_OUTPUT.PUT_LINE('오류 발생: ' || SQLERRM);   
END;  
/
--CourseRead()
Begin
    CourseRead();
end;
/
--/*수정*/CourseUpdate
CREATE OR REPLACE PROCEDURE CourseUpdate(  
    p_CourseSeq Course.CourseSeq%TYPE,  
    p_CourseName Course.CourseName%TYPE  
      
) IS  
BEGIN  
    -- 과정 정보 업데이트  
    UPDATE Course  
    SET 
        CourseName = p_CourseName      
    WHERE CourseSeq = p_CourseSeq;  

    -- 변경된 행 수를 확인하고 출력  
    IF SQL%ROWCOUNT > 0 THEN  
        DBMS_OUTPUT.PUT_LINE('과정 번호 ' || p_CourseSeq || '가(이) 성공적으로 업데이트되었습니다.');  
    ELSE  
        DBMS_OUTPUT.PUT_LINE('과정 번호 ' || p_CourseSeq || '은(는) 존재하지 않거나 업데이트할 데이터가 없습니다.');  
    END IF;  

EXCEPTION  
    WHEN OTHERS THEN  
        ROLLBACK;  -- 오류 발생 시 롤백  
        DBMS_OUTPUT.PUT_LINE('오류 발생: ' || SQLERRM);   
END;
/
--CourseUpdate(1,과정명)
begin
    CourseUpdate(1,q'[AWS와 Docker & Kubernetes를 활용한 Java Full-Stack 개발자 양성과정]');
end;
/


-- /*삭제*/CourseDelete
CREATE OR REPLACE PROCEDURE CourseDelete(  
    p_CourseSeq Course.CourseSeq%TYPE  
) IS  
BEGIN  
    -- 과정 정보 초기화  
    UPDATE Course  
    SET CourseName = '없음' 
    WHERE CourseSeq = p_CourseSeq;  

    -- 변경된 행 수를 확인하고 출력  
    IF SQL%ROWCOUNT > 0 THEN  
        DBMS_OUTPUT.PUT_LINE('과정 번호 ' || p_CourseSeq || '가(이) 성공적으로 초기화되었습니다.');  
    ELSE  
        DBMS_OUTPUT.PUT_LINE('과정 번호 ' || p_CourseSeq || '은(는) 존재하지 않거나 업데이트할 데이터가 없습니다.');  
    END IF;  

EXCEPTION  
    WHEN OTHERS THEN  
        ROLLBACK;  -- 오류 발생 시 롤백  
        DBMS_OUTPUT.PUT_LINE('오류 발생: ' || SQLERRM);   
END;  
/
-- CourseDelete(과정번호);
begin
    CourseDelete(1);
end;
/


--2.과목명 관리
--/*추가*/SubjectInsert
create or replace procedure SubjectInsert( 
    p_subjectName subject.subjectName%type,
    p_subjectEsn subject.subjectEsn%type
)
is
    v_subjectSeq NUMBER;
BEGIN  
    -- 과목 정보 삽입
    v_subjectSeq := subject_seq.NEXTVAL;
    INSERT INTO subject (subjectSeq,subjectName,subjectEsn)   
    VALUES (v_subjectSeq,p_subjectName,p_subjectEsn);    
     
    DBMS_OUTPUT.PUT_LINE('추가된 과목 번호: ' || v_CourseSeq);  
    DBMS_OUTPUT.PUT_LINE('추가된 과목 이름: ' || pCourseName);  
    DBMS_OUTPUT.PUT_LINE('추가된 과목 유형: ' || p_subjectEsn);
    
EXCEPTION  
    WHEN OTHERS THEN  
        ROLLBACK; -- 오류 발생시 롤백  
        DBMS_OUTPUT.PUT_LINE('오류 발생: ' || SQLERRM); 
END;  
/
--SubjectInsert(과목명,과목유형)
Begin
    SubjectInsert(q'[java]','필수');
end;
/

--/*조회*/SubjectRead
CREATE OR REPLACE PROCEDURE SubjectRead IS  
    CURSOR Subject_cursor IS  
        SELECT subjectSeq ,   
               subjectName,
               subjectEsn
                  
        FROM Subject;  

    v_SubjectSeq Subject.subjectSeq%TYPE;  
    v_SubjectName Subject.subjectName%TYPE;  
    v_SubjectEsn Subject.subjectEsn%TYPE;
    
BEGIN  
    OPEN Subject_cursor;  -- 커서를 여는 부분  

    LOOP  
        FETCH Subject_cursor INTO v_SubjectSeq, v_SubjectName,v_SubjectEsn;  -- 커서로부터 값을 읽어옴  
        EXIT WHEN Subject_cursor%NOTFOUND;  -- 더 이상 읽을 것이 없으면 루프 종료  

        -- 결과 출력  
        DBMS_OUTPUT.PUT_LINE('과목번호: ' || v_SubjectSeq ||   
                             ', 과목이름: ' || v_SubjectName ||
                             ', 과목유형: ' || v_SubjectEsn);  
    END LOOP;  

    CLOSE Subject_cursor;  -- 커서를 닫는 부분  

EXCEPTION  
    WHEN OTHERS THEN  
        DBMS_OUTPUT.PUT_LINE('오류 발생: ' || SQLERRM);   
END;  
/
--SubjectRead()
Begin
    SubjectRead();
end;
/

--/*수정*/SubjectUpdate
CREATE OR REPLACE PROCEDURE SubjectUpdate(  
    p_SubjectSeq Subject.SubjectSeq%TYPE,  
    p_SubjectName Subject.SubjectName%TYPE,  
    p_SubjectEsn Subject.SubjectEsn%TYPE 
) IS  
BEGIN  
    -- 과정 정보 업데이트  
    UPDATE Subject  
    SET 
        SubjectName = p_SubjectName,  
        SubjectEsn = p_SubjectEsn
    WHERE SubjectSeq = p_SubjectSeq;  

    -- 변경된 행 수를 확인하고 출력  
    IF SQL%ROWCOUNT > 0 THEN  
        DBMS_OUTPUT.PUT_LINE('과목 번호 ' || p_SubjectSeq || '가(이) 성공적으로 업데이트되었습니다.');  
    ELSE  
        DBMS_OUTPUT.PUT_LINE('과목 번호 ' || p_SubjectSeq || '은(는) 존재하지 않거나 업데이트할 데이터가 없습니다.');  
    END IF;  

EXCEPTION  
    WHEN OTHERS THEN  
        ROLLBACK;  -- 오류 발생 시 롤백  
        DBMS_OUTPUT.PUT_LINE('오류 발생: ' || SQLERRM);   
END;
/
--SubjectUpdate(1,과목명,과목유형(필수/선택))
begin
    SubjectUpdate(1,q'[java]','필수');
end;
/

-- /*삭제*/SubjectDelete
CREATE OR REPLACE PROCEDURE SubjectDelete(  
    p_SubjectSeq Subject.SubjectSeq%TYPE  
) IS  
BEGIN  
    -- 과목 정보 초기화 
    UPDATE Subject  
    SET SubjectName = '없음',
        SubjectEsn = '없음'
    WHERE SubjectSeq = p_SubjectSeq;  

    -- 변경된 행 수를 확인하고 출력  
    IF SQL%ROWCOUNT > 0 THEN  
        DBMS_OUTPUT.PUT_LINE('과목 번호 ' || p_SubjectSeq || '가(이) 성공적으로 초기화되었습니다.');  
    ELSE  
        DBMS_OUTPUT.PUT_LINE('과목 번호 ' || p_SubjectSeq || '은(는) 존재하지 않거나 업데이트할 데이터가 없습니다.');  
    END IF;  

EXCEPTION  
    WHEN OTHERS THEN  
        ROLLBACK;  -- 오류 발생 시 롤백  
        DBMS_OUTPUT.PUT_LINE('오류 발생: ' || SQLERRM);   
END;  
/
-- SubjectDelete(과목번호);
begin
    SubjectDelete(1);
end;
/

select * from clsRoom;
--3.강의실명 관리
/*추가*/
insert into clsRoom(clsRoomSeq,clsRoomName,clsRoomPpl) values (clsRoom_seq.NEXTVAL, q'[제 1 강의실]','30');

--/*추가*/ClsRoomInsert
--/추가/ClsRoomInsert
create or replace procedure ClsRoomInsert( 
    p_clsRoomName clsroom.clsRoomName%type,
    p_clsRoomPpl clsroom.clsRoomPpl%type
)
is
    v_clsRoomSeq NUMBER;
BEGIN
    -- 과목 정보 삽입
    v_clsRoomSeq := clsRoom_seq.NEXTVAL;
    INSERT INTO clsRoom (clsRoomSeq,clsRoomName,clsRoomPpl)
    VALUES (v_clsRoomSeq,p_clsRoomName,p_clsRoomPpl);

    DBMS_OUTPUT.PUT_LINE('추가된 강의실 번호: ' || v_clsRoomSeq);
    DBMS_OUTPUT.PUT_LINE('추가된 강의실 이름: ' || p_clsRoomName);
    DBMS_OUTPUT.PUT_LINE('추가된 강의실 수용인원: '||  p_clsRoomPpl);

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK; -- 오류 발생시 롤백
        DBMS_OUTPUT.PUT_LINE('오류 발생: ' || SQLERRM); 
END;
/
--ClsRoomInsert(강의실명,강의실수용인원)
Begin
    ClsRoomInsert(q'[제 1 강의실]','30');
end;
/

--/*조회*/ClsRoomRead
CREATE OR REPLACE PROCEDURE ClsRoomRead IS  
    CURSOR clsRoom_cursor IS  
        SELECT distinct 
            c.clsRoomName ,   
            c.clsRoomPpl ,   
            p.processCount   
        FROM   
            clsRoom c  
        INNER JOIN   
            process p ON c.clsRoomSeq = p.clsRoomSeq;    
 
    v_ClsRoomName clsRoom.clsRoomName%TYPE;  
    v_ClsRoomPpl clsRoom.clsRoomPpl%TYPE;
    v_ProcessCount process.processCount%TYPE;
    
BEGIN  
    OPEN ClsRoom_cursor;  -- 커서를 여는 부분  

    LOOP  
        FETCH ClsRoom_cursor INTO v_ClsRoomName,v_ClsRoomPpl,v_ProcessCount;  -- 커서로부터 값을 읽어옴  
        EXIT WHEN ClsRoom_cursor%NOTFOUND;  -- 더 이상 읽을 것이 없으면 루프 종료  

        -- 결과 출력  
        DBMS_OUTPUT.PUT_LINE('강의실이름: ' || v_ClsRoomName ||
                             ', 강의실수용인원: ' || v_ClsRoomPpl ||
                             ', 수강한인원: ' || v_ProcessCount);  
    END LOOP;  

    CLOSE ClsRoom_cursor;  -- 커서를 닫는 부분  

EXCEPTION  
    WHEN OTHERS THEN  
        DBMS_OUTPUT.PUT_LINE('오류 발생: ' || SQLERRM);   
END;  
/
--ClsRoomRead()
Begin
    ClsRoomRead();
end;
/

--/*수정*/ClsRoomUpdate
CREATE OR REPLACE PROCEDURE ClsRoomUpdate(  
    p_ClsRoomSeq ClsRoom.ClsRoomSeq%TYPE,  
    p_ClsRoomName ClsRoom.ClsRoomName%TYPE,  
    p_ClsRoomPpl ClsRoom.ClsRoomPpl%TYPE 
) IS  
BEGIN  
    -- 강의실 정보 업데이트  
    UPDATE ClsRoom  
    SET 
        ClsRoomName = p_ClsRoomName,
        ClsRoomPpl = p_ClsRoomPpl
        
    WHERE ClsRoomSeq = p_ClsRoomSeq;  

    -- 변경된 행 수를 확인하고 출력  
    IF SQL%ROWCOUNT > 0 THEN  
        DBMS_OUTPUT.PUT_LINE('강의실 번호 ' || p_ClsRoomSeq || '가(이) 성공적으로 업데이트되었습니다.');  
    ELSE  
        DBMS_OUTPUT.PUT_LINE('강의실 번호 ' || p_ClsRoomSeq || '은(는) 존재하지 않거나 업데이트할 데이터가 없습니다.');  
    END IF;  

EXCEPTION  
    WHEN OTHERS THEN  
        ROLLBACK;  -- 오류 발생 시 롤백  
        DBMS_OUTPUT.PUT_LINE('오류 발생: ' || SQLERRM);   
END;
/
--ClsRoomUpdate(강의실번호,강의실명,강의실수용인원)
begin
    ClsRoomUpdate(1,q'[제 1 강의실]',30);
end;
/

-- /*삭제*/ClsRoomDelete
CREATE OR REPLACE PROCEDURE ClsRoomDelete(  
    p_ClsRoomSeq ClsRoom.ClsRoomSeq%TYPE  
) IS  
BEGIN  
    -- 선택한 강의실 정보 초기화(삭제)
    UPDATE ClsRoom  
    SET ClsRoomName = '없음',
        ClsRoomPpl = 0
    WHERE ClsRoomSeq = p_ClsRoomSeq;  

    -- 변경된 행 수를 확인하고 출력  
    IF SQL%ROWCOUNT > 0 THEN  
        DBMS_OUTPUT.PUT_LINE('강의실 번호 ' || p_ClsRoomSeq || '가(이) 성공적으로 초기화되었습니다.');  
    ELSE  
        DBMS_OUTPUT.PUT_LINE('강의실 번호 ' || p_ClsRoomSeq || '은(는) 존재하지 않거나 업데이트할 데이터가 없습니다.');  
    END IF;  

EXCEPTION  
    WHEN OTHERS THEN  
        ROLLBACK;  -- 오류 발생 시 롤백  
        DBMS_OUTPUT.PUT_LINE('오류 발생: ' || SQLERRM);   
END;  
/
-- ClsRoomDelete(강의실번호);
begin
    ClsRoomDelete(1);
end;
/

--4.교재명 관리
--/*추가*/BookInsert
create or replace procedure BookInsert( 
    p_BookName book.bookName%type,
    p_BookPublisher book.bookPublisher%type,
    p_BookAuthor book.bookAuthor%type,
    p_BookYear book.bookYear%type
)
is
    v_BookSeq NUMBER;
BEGIN  
    -- 교재 정보 추가등록
    v_BookSeq := book_seq.NEXTVAL;
    INSERT INTO book(bookSeq,bookName,bookPublisher,bookAuthor,bookYear)   
    VALUES (v_BookSeq,p_BookName,p_BookPublisher,p_BookAuthor,p_BookYear);
     
    DBMS_OUTPUT.PUT_LINE('추가등록된 교재 번호: ' || v_BookSeq);  
    DBMS_OUTPUT.PUT_LINE('추가등록된 교재 이름: ' || p_BookName);  
    DBMS_OUTPUT.PUT_LINE('추가등록된 교재 출판사: ' || p_BookPublisher);
    DBMS_OUTPUT.PUT_LINE('추가등록된 교재 작가: ' || p_BookAuthor);
    DBMS_OUTPUT.PUT_LINE('추가등록된 교재 발행연도: ' || p_BookYear);
    
EXCEPTION  
    WHEN OTHERS THEN  
        ROLLBACK; -- 오류 발생시 롤백  
        DBMS_OUTPUT.PUT_LINE('오류 발생: ' || SQLERRM); 
END;  
/
--BookInsert(교재명,출판사,작가,발행연도)
Begin
    BookInsert(q'[최신Java 프로그래밍]', q'[21세기사]', q'[한정란]', to_date('2024','YYYY'));
end;
/

--/*조회*/BookRead
CREATE OR REPLACE PROCEDURE BookRead IS  
    CURSOR Book_cursor IS  
        SELECT
            bookseq,
            bookName,
            bookPublisher,
            bookAuthor,
            bookYear 
        FROM   
            book;
    v_Bookseq book.bookseq%TYPE;          
    v_BookName book.bookName%TYPE;  
    v_BookPublisher book.bookPublisher%TYPE;
    v_BookAuthor book.bookAuthor%TYPE;
    v_BookYear book.bookYear%TYPE;
BEGIN  
    OPEN Book_cursor;  -- 커서를 여는 부분  

    LOOP  
        FETCH Book_cursor INTO v_Bookseq,v_BookName,v_BookPublisher,v_BookAuthor,v_BookYear;  -- 커서로부터 값을 읽어옴  
        EXIT WHEN Book_cursor%NOTFOUND;  -- 더 이상 읽을 것이 없으면 루프 종료  
        
        -- 결과 출력  
        DBMS_OUTPUT.PUT_LINE('교재번호: ' || v_BookSeq ||
                             ', 교재이름: ' || v_BookName ||
                             ', 강의실수용인원: ' || v_BookPublisher ||
                             ', 수강한인원: ' || v_BookAuthor ||
                             ', 강의실수용인원: ' || v_BookYear);  
    END LOOP;  

    CLOSE Book_cursor;  -- 커서를 닫는 부분  

EXCEPTION  
    WHEN OTHERS THEN  
        DBMS_OUTPUT.PUT_LINE('오류 발생: ' || SQLERRM);   
END;  
/
--BookRead()
Begin
    BookRead();
end;
/


update book 
   set bookName = q'[최신Java 프로그래밍]'
   , bookPublisher = q'[21세기사]'
   , bookAuthor = q'[한정란]'
   , bookYear = to_date('2024','YYYY')
where bookSeq = 1;

--/*수정*/BookUpdate
CREATE OR REPLACE PROCEDURE BookUpdate(
    p_bookSeq book.bookSeq%TYPE,
    p_bookName book.bookName%TYPE,  
    p_bookPublisher book.bookPublisher%TYPE,  
    p_bookAuthor book.bookAuthor%TYPE,
    p_bookYear book.bookYear%TYPE
) IS  
BEGIN  
    -- 교재 정보 업데이트  
    UPDATE book  
    SET 
        bookName = p_bookName,
        bookPublisher = p_bookPublisher,
        bookAuthor = p_bookAuthor,
        bookYear = p_bookYear
        
    WHERE bookSeq = p_bookSeq;  

    -- 변경된 행 수를 확인하고 출력  
    IF SQL%ROWCOUNT > 0 THEN  
        DBMS_OUTPUT.PUT_LINE('교재 번호 ' || p_bookSeq || '가(이) 성공적으로 업데이트되었습니다.');  
    ELSE  
        DBMS_OUTPUT.PUT_LINE('교재 번호 ' || p_bookSeq || '은(는) 존재하지 않거나 업데이트할 데이터가 없습니다.');  
    END IF;  

EXCEPTION  
    WHEN OTHERS THEN  
        ROLLBACK;  -- 오류 발생 시 롤백  
        DBMS_OUTPUT.PUT_LINE('오류 발생: ' || SQLERRM);   
END;
/
--BookUpdate()
Begin
    BookUpdate(1,q'[최신Java 프로그래밍]',q'[21세기사]',q'[한정란]',to_date('2024','YYYY'));
end;
/

-- /*삭제*/BookDelete
CREATE OR REPLACE PROCEDURE BookDelete(  
    p_BookSeq book.bookSeq%TYPE  
) IS  
BEGIN  
    -- 선택한 강의실 정보 초기화(삭제)
    UPDATE book  
    SET bookName = '없음'
       , bookPublisher = null
       , bookAuthor = null
       , bookYear = null 
    WHERE bookSeq = p_BookSeq;  

    -- 변경된 행 수를 확인하고 출력  
    IF SQL%ROWCOUNT > 0 THEN  
        DBMS_OUTPUT.PUT_LINE('교재번호 ' || p_BookSeq || '가(이) 성공적으로 초기화되었습니다.');  
    ELSE  
        DBMS_OUTPUT.PUT_LINE('교재번호 ' || p_BookSeq || '은(는) 존재하지 않거나 업데이트할 데이터가 없습니다.');  
    END IF;  

EXCEPTION  
    WHEN OTHERS THEN  
        ROLLBACK;  -- 오류 발생 시 롤백  
        DBMS_OUTPUT.PUT_LINE('오류 발생: ' || SQLERRM);   
END;  
/
-- BookDelete(교재번호);
begin
    BookDelete(1);
end;
/





/*
업무 영역	관리자
요구사항 명	B-03. 교사 계정 관리 기능
개요	관리자는 여러명의 교사 정보를 등록 및 관리할 수 있다.
상세설명	
1.교사 정보 등록	
-이름, 주민번호 뒷자리, 전화번호, 강의 가능 과목을 등록한다.	
2.교사 정보 수정	
3.교사 정보 삭제	
4. 교사 정보 조회	
"-전체명단 조회할 시 이름, 주민번호 뒷자리, 전화번호, 강의가능과목을 출력하고 
특정 교사만 조회할 경우 배설된 개설 과목명, 개설 과목기간과 개설 과정기간의 시작 년월일과 끝 년월일, 과정명, 교재명, 강의실, 강의진행여부를 확인 할 수 있어야 한다."	
	
제약사항	
-교사 계정으로 로그인시 패스워드는 주민번호 뒷자리를 사용하게 한다.	
-교사 정보 조회시 강의 진행 여부는 날짜를 기준으로 강의 예정, 강의 중, 강의 종료 등 정보를 확인할 수 있도록 한다.	
*/


/*  B-03 관리자 - 교사계정 관리  */

/*추가*/
--a. 교사명단 추가 (교사번호, 교사명, 비밀번호, 전화번호)
CREATE OR REPLACE PROCEDURE c_Teacher(
    p_teacherName Teacher.teacherName%TYPE,
    p_teacherPw Teacher.teacherPw%TYPE,
    p_teacherTel Teacher.teacherTel%TYPE
)
IS
BEGIN
    INSERT INTO Teacher(teacherSeq, teacherName, teacherPw, teacherTel) 
    VALUES (teacher_seq.NEXTVAL, p_teacherName, p_teacherPw, p_teacherTel);
END c_Teacher;
/
--교사명,비밀번호,전화번호
BEGIN
    c_Teacher('구하늘', 1156493, '010-6789-0123');
    DBMS_OUTPUT.PUT_LINE('등록 완료');
END;
/

--b. 교사 가능과목 추가 (교사가능과목번호, 교사번호, 과목번호)
CREATE OR REPLACE PROCEDURE c_tSubject(
    p_teacherSeq Teacher.teacherSeq%TYPE,
    p_subjectSeq Subject.subjectSeq%TYPE
)
IS
BEGIN
    INSERT INTO tSubject(tSubjectSeq, teacherSeq, subjectSeq) 
    VALUES (tSubject_Seq.NEXTVAL, p_teacherSeq, p_subjectSeq);
END c_tSubject;
/
--교사번호, 과목번호
BEGIN
    c_tSubject(1, 1);
    DBMS_OUTPUT.PUT_LINE('등록 완료');
END;
/

/*조회*/
--a. 전체조회
CREATE OR REPLACE PROCEDURE r_teacher 
IS
    CURSOR cur_teacher IS
        SELECT 
            t.teacherName AS 교사이름, 
            t.teacherPw AS 비밀번호, 
            t.teacherTel AS 전화번호, 
            s.subjectName AS 강의가능과목
        FROM teacher t
            INNER JOIN tSubject ts ON t.teacherSeq = ts.teacherSeq
            INNER JOIN subject s ON ts.subjectSeq = s.subjectSeq;

    v_teacherName  Teacher.teacherName%TYPE;
    v_teacherPw    Teacher.teacherPw%TYPE;
    v_teacherTel   Teacher.teacherTel%TYPE;
    v_subjectName  Subject.subjectName%TYPE;
BEGIN
    FOR rec IN cur_teacher LOOP
        v_teacherName := rec.교사이름;
        v_teacherPw := rec.비밀번호;
        v_teacherTel := rec.전화번호;
        v_subjectName := rec.강의가능과목;

        DBMS_OUTPUT.PUT_LINE(
            v_teacherName || ' | ' ||
            v_teacherPw || ' | ' ||
            v_teacherTel || ' | ' ||
            v_subjectName
        );
    END LOOP;
END r_teacher;
/
--교사명단조회
BEGIN
    r_teacher;
END;
/

--b. 교사이름 조회
CREATE OR REPLACE PROCEDURE r_t_teacherName(
    p_teacherName Teacher.teacherName%TYPE
)
IS
    CURSOR cur_TeacherLecture IS
        SELECT 
            t.teacherName AS 교사이름,
            s.subjectName AS 과목명,
            ps.prcSubjectSDate AS 과목시작날짜,
            ps.prcSubjectEDate AS 과목종료날짜,
            c.courseName AS 과정명,
            p.processSDate AS 과정시작날짜,
            p.processEDate AS 과정종료날짜,
            b.bookName AS 교재명,
            cr.clsRoomName AS 강의실명,
            CASE
                WHEN ps.prcSubjectSDate > SYSDATE THEN '강의예정'
                WHEN ps.prcSubjectSDate <= SYSDATE AND ps.prcSubjectEDate >= SYSDATE THEN '강의중'
                ELSE '강의종료'
            END AS 강의진행여부
        FROM teacher t
            INNER JOIN process p ON t.teacherSeq = p.teacherSeq
            INNER JOIN prcSubject ps ON p.processSeq = ps.processSeq
            INNER JOIN subject s ON ps.subjectSeq = s.subjectSeq
            INNER JOIN Course c ON p.courseSeq = c.courseSeq
            INNER JOIN clsRoom cr ON p.clsRoomSeq = cr.clsRoomSeq
            INNER JOIN sbjectBook sb ON s.subjectSeq = sb.subjectSeq
            INNER JOIN book b ON sb.bookSeq = b.bookSeq
        WHERE t.teacherName = p_teacherName;

    v_teacherName    Teacher.teacherName%TYPE;
    v_subjectName    Subject.subjectName%TYPE;
    v_prcSubjectSDate prcSubject.prcSubjectSDate%TYPE;
    v_prcSubjectEDate prcSubject.prcSubjectEDate%TYPE;
    v_courseName     Course.courseName%TYPE;
    v_processSDate   Process.processSDate%TYPE;
    v_processEDate   Process.processEDate%TYPE;
    v_bookName       Book.bookName%TYPE;
    v_clsRoomName    clsRoom.clsRoomName%TYPE;
    v_lectureStatus  VARCHAR2(20);
BEGIN
    FOR rec IN cur_TeacherLecture LOOP
        v_teacherName := rec.교사이름;
        v_subjectName := rec.과목명;
        v_prcSubjectSDate := rec.과목시작날짜;
        v_prcSubjectEDate := rec.과목종료날짜;
        v_courseName := rec.과정명;
        v_processSDate := rec.과정시작날짜;
        v_processEDate := rec.과정종료날짜;
        v_bookName := rec.교재명;
        v_clsRoomName := rec.강의실명;
        v_lectureStatus := rec.강의진행여부;

        DBMS_OUTPUT.PUT_LINE(
            v_teacherName || ' | ' ||
            v_subjectName || ' | ' ||
            TO_CHAR(v_prcSubjectSDate, 'YYYY-MM-DD') || ' | ' ||
            TO_CHAR(v_prcSubjectEDate, 'YYYY-MM-DD') || ' | ' ||
            v_courseName || ' | ' ||
            TO_CHAR(v_processSDate, 'YYYY-MM-DD') || ' | ' ||
            TO_CHAR(v_processEDate, 'YYYY-MM-DD') || ' | ' ||
            v_bookName || ' | ' ||
            v_clsRoomName || ' | ' ||
            v_lectureStatus
        );
    END LOOP;
END r_t_teacherName;
/
--조회할 교사이름
BEGIN
    r_t_teacherName('구하늘');
END;
/


/*수정*/
--이름
CREATE OR REPLACE PROCEDURE u_t_teacherName (
    p_teacherSeq teacher.teacherSeq%TYPE,
    p_teacherName teacher.teacherName%TYPE
) IS
BEGIN
    UPDATE teacher
    SET teacherName = p_teacherName
    WHERE teacherSeq = p_teacherSeq;
    dbms_output.put_line('수정 성공');
END;
/
--교사번호, 이름수정
BEGIN
    u_t_teacherName(1, '구바람');
END;
/

--비밀번호
CREATE OR REPLACE PROCEDURE u_t_teacherPw (
    p_teacherSeq teacher.teacherSeq%TYPE,
    p_teacherPw teacher.teacherPw%TYPE
) IS
BEGIN
    UPDATE teacher
    SET teacherPw = p_teacherPw
    WHERE teacherSeq = p_teacherSeq;
    dbms_output.put_line('수정 성공');
END;
/
--교사번호, 비밀번호수정
BEGIN
    u_t_teacherPw(1, '1234567');
END;
/

--전화번호
CREATE OR REPLACE PROCEDURE u_t_teacherTel (
    p_teacherSeq teacher.teacherSeq%TYPE,
    p_teacherTel teacher.teacherTel%TYPE
) IS
BEGIN
    UPDATE teacher
    SET teacherTel = p_teacherTel
    WHERE teacherSeq = p_teacherSeq;
    dbms_output.put_line('수정 성공');
END;
/
--교사번호, 전화번호 수정
BEGIN
    u_t_teacherTel(1, '010-6789-0123');
END;
/


/*삭제*/
CREATE OR REPLACE PROCEDURE d_teacher (
    p_teacherName teacher.teacherName%TYPE
) IS
BEGIN
    UPDATE teacher
    SET 
        teacherName = '퇴직교사',
        teacherPw = NULL,
        teacherTel = NULL
    WHERE 
        teacherName = p_teacherName;
END;
/

BEGIN
    d_teacher('구하늘');
    dbms_output.put_line('삭제 성공');
END;
/





/* 
업무 영역	관리자
요구사항 명	B-04. 개설 과정 관리
개요	관리자는 여러 개의 개설 과정을 등록 및 관리할 수 있다.
상세설명	
1.개설 과정 등록	
-과정 정보에는 과정 명, 과정기간, 강의실 정보를 입력한다.	
2.개설 과정 수정	
3.개설 과정 삭제	
4.개설 과정 조회	
- 개설과정 조회 시 과정 명, 개설과정기간, 강의실명, 개설과목 등록여부, 교육생 등록 인원을 출력한다.	
- 특정 개설 과정 조회 시 개설 과정에 등록된 개설 과목정보 및 등록된 교육생 정보를 출력한다.	
	
제약사항	
과정 등록시 강의실 정보는 기초정보 강의실명에서 선택적으로 추가할 수 있게 한다.	
수료된 개설 과정은 중도 탈락자를 제외한 교육생 전체에 대해서 수료날짜를 지정할 수 있어야 한다.	
*/


/*  B-04 관리자 - 개설과정 관리  */

/*추가*/
--과정명 등록 (과정번호, 과정명)
CREATE OR REPLACE PROCEDURE c_Course(
    p_courseName Course.courseName%TYPE
) 
IS
BEGIN
    INSERT INTO Course(courseSeq, courseName) 
    VALUES (course_seq.NEXTVAL, p_courseName);
END c_Course;
/
--과정명 입력
BEGIN
    c_Course(q'[AWS와 Docker & Kubernetes를 활용한 Java Full-Stack 개발자 양성과정]');
    dbms_output.put_line('등록 완료');
END;
/


--과정기간 등록 (개설과정번호, 과정번호, 강의실번호, 교사번호, 과정시작날짜, 과정종료날짜, 수강정원)
CREATE OR REPLACE PROCEDURE c_Process(
    p_courseSeq    Process.courseSeq%TYPE,
    p_clsRoomSeq   Process.clsRoomSeq%TYPE,
    p_teacherSeq   Process.teacherSeq%TYPE,
    p_processSDate VARCHAR2,
    p_processEDate VARCHAR2,
    p_processCount Process.processCount%TYPE
) 
IS
BEGIN
    INSERT INTO Process(processSeq, courseSeq, clsRoomSeq, teacherSeq, processSDate, processEDate, processCount) 
    VALUES (process_seq.NEXTVAL, p_courseSeq, p_clsRoomSeq, p_teacherSeq, 
            TO_DATE(p_processSDate, 'YYYY-MM-DD'), 
            TO_DATE(p_processEDate, 'YYYY-MM-DD'), 
            p_processCount);
END c_Process;
/
--과정번호, 강의실번호, 교사번호, 과정시작날짜, 과정종료날짜, 수강정원
BEGIN
    c_Process(3, 6, 6, '2024-07-03', '2025-01-03', 26);
    dbms_output.put_line('등록 완료');
END;
/


--강의실 등록 (강의실번호, 강의실명, 강의실인원)
CREATE OR REPLACE PROCEDURE c_clsRoom(
    p_clsRoomName ClsRoom.clsRoomName%TYPE,
    p_clsRoomPpl  ClsRoom.clsRoomPpl%TYPE
) 
IS
BEGIN
    INSERT INTO ClsRoom(clsRoomSeq, clsRoomName, clsRoomPpl) 
    VALUES (clsRoom_seq.NEXTVAL, p_clsRoomName, p_clsRoomPpl);
END c_clsRoom;
/
--강의실명, 강의실인원
BEGIN
    c_clsRoom(q'[제 1 강의실]', 30);
    dbms_output.put_line('등록 완료');
END;
/


/*조회*/
CREATE OR REPLACE PROCEDURE r_process
IS
    CURSOR cur_process IS
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
            INNER JOIN Course c ON p.courseSeq = c.courseSeq
            INNER JOIN clsRoom cr ON p.clsRoomSeq = cr.clsRoomSeq
            INNER JOIN prcSubject ps ON p.processSeq = ps.processSeq
            INNER JOIN subject s ON ps.subjectSeq = s.subjectSeq;

    v_courseName       Course.courseName%TYPE;
    v_processSDate     Process.processSDate%TYPE;
    v_processEDate     Process.processEDate%TYPE;
    v_clsRoomName      clsRoom.clsRoomName%TYPE;
    v_subjectName      subject.subjectName%TYPE;
    v_studentCount     NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('과정명 | 시작일 | 종료일 | 강의실 | 과목명 | 등록인원');
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------');

    FOR rec IN cur_process LOOP
        v_courseName := rec.과정명;
        v_processSDate := rec.과정시작날짜;
        v_processEDate := rec.과정종료날짜;
        v_clsRoomName := rec.강의실명;
        v_subjectName := rec.과목명;
        v_studentCount := rec.교육생등록인원;

        DBMS_OUTPUT.PUT_LINE(
            v_courseName || ' | ' || 
            TO_CHAR(v_processSDate, 'YYYY-MM-DD') || ' | ' || 
            TO_CHAR(v_processEDate, 'YYYY-MM-DD') || ' | ' || 
            v_clsRoomName || ' | ' || 
            v_subjectName || ' | ' || 
            v_studentCount
        );
    END LOOP;
END r_process;
/
--전체조회
BEGIN
    r_process;
END;
/
    
    
    

--개설과정번호로 조회
CREATE OR REPLACE PROCEDURE r_p_processSeq(
    p_processSeq Process.processSeq%TYPE
) 
IS
    CURSOR cur_ProcessInfo IS
        SELECT 
            c.courseName AS 과정명,
            s.subjectName AS 과목명,
            cr.clsRoomName AS 강의실명,
            ps.prcSubjectSDate AS 과목시작날짜,
            ps.prcSubjectEDate AS 과목종료날짜,
            sc.studentSeq AS 교육생번호,
            st.studentName AS 이름
        FROM process p
            INNER JOIN Course c ON p.courseSeq = c.courseSeq
            INNER JOIN prcSubject ps ON p.processSeq = ps.processSeq
            INNER JOIN subject s ON ps.subjectSeq = s.subjectSeq
            INNER JOIN clsRoom cr ON p.clsRoomSeq = cr.clsRoomSeq
            INNER JOIN studentCls sc ON p.processSeq = sc.processSeq
            INNER JOIN student st ON sc.studentSeq = st.studentSeq
        WHERE p.processSeq = p_processSeq;

    v_courseName      Course.courseName%TYPE;
    v_subjectName     Subject.subjectName%TYPE;
    v_clsRoomName     clsRoom.clsRoomName%TYPE;
    v_prcSubjectSDate prcSubject.prcSubjectSDate%TYPE;
    v_prcSubjectEDate prcSubject.prcSubjectEDate%TYPE;
    v_studentSeq      Student.studentSeq%TYPE;
    v_studentName     Student.studentName%TYPE;
BEGIN
    FOR rec IN cur_ProcessInfo LOOP
        v_courseName := rec.과정명;
        v_subjectName := rec.과목명;
        v_clsRoomName := rec.강의실명;
        v_prcSubjectSDate := rec.과목시작날짜;
        v_prcSubjectEDate := rec.과목종료날짜;
        v_studentSeq := rec.교육생번호;
        v_studentName := rec.이름;

        DBMS_OUTPUT.PUT_LINE(
            v_courseName || ' | ' ||
            v_subjectName || ' | ' ||
            v_clsRoomName || ' | ' ||
            TO_CHAR(v_prcSubjectSDate, 'YYYY-MM-DD') || ' | ' ||
            TO_CHAR(v_prcSubjectEDate, 'YYYY-MM-DD') || ' | ' ||
            v_studentSeq || ' | ' ||
            v_studentName
        );
    END LOOP;
END r_p_processSeq;
/
--개설과정번호
BEGIN
    r_p_processSeq(2);
END;
/


/*수정*/
--과정번호 수정
CREATE OR REPLACE PROCEDURE u_p_courseSeq(
    p_processSeq Process.processSeq%TYPE,
    p_courseSeq Course.courseSeq%TYPE
)
IS
BEGIN
    UPDATE process 
    SET courseSeq = p_courseSeq
    WHERE processSeq = p_processSeq;
END u_p_courseSeq;
/
--개설과정번호, 과정번호
BEGIN
    u_p_courseSeq(2, 3);
    DBMS_OUTPUT.PUT_LINE('수정 성공');    
END;
/



--강의실번호 수정
CREATE OR REPLACE PROCEDURE u_p_clsRoomSeq(
    p_processSeq Process.processSeq%TYPE,
    p_clsRoomSeq clsRoom.clsRoomSeq%TYPE
)
IS
BEGIN
    UPDATE process 
    SET clsRoomSeq = p_clsRoomSeq
    WHERE processSeq = p_processSeq;
END u_p_clsRoomSeq;
/
--개설과정번호, 강의실번호
BEGIN
    u_p_clsRoomSeq(2, 6);
    DBMS_OUTPUT.PUT_LINE('수정 성공');    
END;
/



--교사번호 수정
CREATE OR REPLACE PROCEDURE u_p_teacherSeq(
    p_processSeq Process.processSeq%TYPE,
    p_teacherSeq Process.teacherSeq%TYPE
)
IS
BEGIN
    UPDATE process 
    SET teacherSeq = p_teacherSeq
    WHERE processSeq = p_processSeq;
END u_p_teacherSeq;
/
--개설과정번호, 교사번호
BEGIN
    u_p_teacherSeq(2, 6);
    DBMS_OUTPUT.PUT_LINE('수정 성공');    
END;
/



--과정시작날짜 수정
CREATE OR REPLACE PROCEDURE u_p_processSDate(
    p_processSeq Process.processSeq%TYPE,
    p_processSDate Process.processSDate%TYPE
)
IS
BEGIN
    UPDATE process 
    SET processSDate = p_processSDate
    WHERE processSeq = p_processSeq;
END u_p_processSDate;
/
--개설과정번호, 시작날짜
BEGIN
    u_p_processSDate(2, TO_DATE('2024-07-03', 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('수정 성공');    
END;
/



--과정종료날짜 수정
CREATE OR REPLACE PROCEDURE u_p_processEDate(
    p_processSeq Process.processSeq%TYPE,
    p_processEDate Process.processEDate%TYPE
)
IS
BEGIN
    UPDATE process 
    SET processEDate = p_processEDate
    WHERE processSeq = p_processSeq;
END u_p_processEDate;
/
--개설과정번호, 과정종료날짜
BEGIN
    u_p_processEDate(2, TO_DATE('2025-01-03', 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('수정 성공');    
END;
/

--수강정원 수정
CREATE OR REPLACE PROCEDURE u_p_processCount(
    p_processSeq Process.processSeq%TYPE,
    p_processCount Process.processCount%TYPE
)
IS
BEGIN
    UPDATE process 
    SET processCount = p_processCount
    WHERE processSeq = p_processSeq;
END u_p_processCount;
/
--개설과정번호, 수강정원
BEGIN
    u_p_processCount(2, 26);
    DBMS_OUTPUT.PUT_LINE('수정 성공');    
END;
/


    
/*삭제*/
CREATE OR REPLACE PROCEDURE u_courseName(
    p_courseSeq Course.courseSeq%TYPE
)
IS
BEGIN
    UPDATE Course
    SET courseName = '삭제된과정'
    WHERE courseSeq = p_courseSeq;
END u_courseName;
/
--삭제할 과정번호입력
BEGIN
    u_courseName(2);
    DBMS_OUTPUT.PUT_LINE('수정 성공');    
END;
/





/*
업무 영역	관리자
요구사항 명	B-05. 개설 과목 관리 기능
개요	관리자는 개설 과정에 대해 여러 개의 개설 과목을 등록 및 관리할 수 있다.
상세설명	
1.개설과목등록	
- 개설 과목 정보 입력시 과목명, 과목기간, 교재명, 교사명을 입력한다.	
2.개설과목수정	
3.개설과목삭제	
4.개설과목조회	
- 개설 과목 조회시 개설 과정 정보, 과목명, 과목기간, 교재명, 교사명을 출력한다.	
	
제약사항	
특정 개설 과정 선택시 개설 과목 정보 출력 및 개설 과목 신규 등록을 할 수 있게 한다.	
교재명은 기초 정보 교재명에서 선택적으로 추가한다.	
교사명은 현재 과목과 강의 가능 과목이 일치하는 교사 명단에서 선택적으로 추가한다.	
*/



--////////////////////////////////B-05. 개설 과목 관리 기능////////////////////////////////////
insert into subject(subjectSeq,subjectName,subjectEsn) 
values (subject_seq.NEXTVAL, q'[java]','필수');

insert into prcSubject(prcSubjectSeq,processSeq,subjectSeq,prcSubjectSDate,prcSubjectEDate) 
values (prcSubject_Seq.NEXTVAL,2,1, to_date('24/08/07','YY-MM-DD'), to_date('24/09/11','YY-MM-DD'));

insert into book(bookSeq,bookName,bookPublisher,bookAuthor,bookYear) 
values (book_Seq.NEXTVAL, q'[최신Java 프로그래밍]', q'[21세기사]', q'[한정란]', to_date('2024','YYYY'));

insert into Teacher(teacherSeq,teacherName,teacherPw,teacherTel) 
values (teacher_seq.nextval,'구하늘',1156493,'010-6789-0123');

insert into tSubject(tSubjectSeq,teacherSeq,subjectSeq) 
values (tSubject_Seq.NEXTVAL,1,1);

insert into sbjectBook(sbjectBookSeq,subjectSeq,bookSeq) 
values (sbjectBook_Seq.NEXTVAL,1,1);

--/*추가*/
begin 
    SubjectRead();
    BookRead();
    prcSubject();
    
end;
/

create or replace procedure prcSubjectInsert(
    p_processSeq prcSubject.processSeq%type,
    p_subjectSeq prcSubject.subjectSeq%type,
    p_prcSubjectSDate prcSubject.prcSubjectSDate%type,
    p_prcSubjectEDate prcSubject.prcSubjectEDate%type
)
is
    v_prcSubjectSeq NUMBER;
BEGIN  
    -- 교재 정보 추가등록
    v_prcSubjectSeq := prcSubject_seq.NEXTVAL;
    INSERT INTO prcSubject(prcSubjectSeq,processSeq,subjectSeq,prcSubjectSDate,prcSubjectEDate)   
    VALUES (v_prcSubjectSeq,p_processSeq,p_subjectSeq,p_prcSubjectSDate,p_prcSubjectEDate);
     
    DBMS_OUTPUT.PUT_LINE('추가등록된 개설과정과목번호: ' || v_prcSubjectSeq);  
    DBMS_OUTPUT.PUT_LINE('추가등록된 개설과정번호: ' || p_processSeq);  
    DBMS_OUTPUT.PUT_LINE('추가등록된 과목번호: ' || p_subjectSeq);
    DBMS_OUTPUT.PUT_LINE('추가등록된 과목시작날짜: ' || p_prcSubjectSDate);  
    DBMS_OUTPUT.PUT_LINE('추가등록된 과목종료날짜: ' || p_prcSubjectEDate);
    
EXCEPTION  
    WHEN OTHERS THEN  
        ROLLBACK; -- 오류 발생시 롤백  
        DBMS_OUTPUT.PUT_LINE('오류 발생: ' || SQLERRM); 
END;  
/

--prcSubjectInsert(교재명,출판사,작가,발행연도)
Begin
    prcSubjectInsert(2,1, to_date('24/08/07','YY-MM-DD'), to_date('24/09/11','YY-MM-DD'));
end;
/

create or replace procedure teacherInsert(
    p_teacherName teacher.teacherName%type,
    p_teacherPw teacher.teacherPw%type,
    p_teacherTel teacher.teacherTel%type
)
is
    v_teacherSeq NUMBER;
BEGIN  
    -- 교재 정보 추가등록
    v_teacherSeq := teacher_seq.NEXTVAL;
    INSERT INTO teacher(teacherSeq,teacherName,teacherPw,teacherTel)   
    VALUES (v_teacherSeq,p_teacherName,p_teacherPw,p_teacherTel);
    
    DBMS_OUTPUT.PUT_LINE('추가등록된 교사번호: ' || v_teacherSeq);  
    DBMS_OUTPUT.PUT_LINE('추가등록된 교사이름: ' || p_teacherName);
    DBMS_OUTPUT.PUT_LINE('추가등록된 교사비밀번호: ' || p_teacherPw);  
    DBMS_OUTPUT.PUT_LINE('추가등록된 교사전화번호: ' || p_teacherTel);
    
EXCEPTION  
    WHEN OTHERS THEN  
        ROLLBACK; -- 오류 발생시 롤백  
        DBMS_OUTPUT.PUT_LINE('오류 발생: ' || SQLERRM); 
END;  
/

--teacherInsert(교사번호,교사이름,교사비밀번호,교사전화번호)
Begin
    teacherInsert('구하늘',1156493,'010-6789-0123');
end;
/


CREATE OR REPLACE PROCEDURE prcSubjectRead AS  
    CURSOR subject_cursor IS  
        SELECT   
            p.processSeq,  
            p.prcSubjectSeq,      
            p.subjectSeq,   
            s.subjectName,   
            p.prcSubjectSDate,   
            p.prcSubjectEDate,   
            t.teacherName,  
            b.bookName   
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
            book b ON sb.bookSeq = b.bookSeq;  

    rec subject_cursor%ROWTYPE; -- 커서의 레코드 타입 정의  
BEGIN  
    OPEN subject_cursor; -- 커서 열기  
    LOOP  
        FETCH subject_cursor INTO rec; -- 데이터 가져오기  
        EXIT WHEN subject_cursor%NOTFOUND; -- 모든 데이터를 읽었는지 확인  
        DBMS_OUTPUT.PUT_LINE('개설과정번호: ' || rec.processSeq ||  
                             ', 개설과정과목번호: ' || rec.prcSubjectSeq ||  
                             ', 과목번호: ' || rec.subjectSeq ||  
                             ', 과목명: ' || rec.subjectName ||  
                             ', 과목시작날짜: ' || rec.prcSubjectSDate ||  
                             ', 과목종료날짜: ' || rec.prcSubjectEDate ||  
                             ', 교사명: ' || rec.teacherName ||  
                             ', 교재명: ' || rec.bookName);  
    END LOOP;  

    CLOSE subject_cursor; -- 커서 닫기  
END prcSubjectRead; 
/
BEGIN   
    prcSubjectRead();  
END;  
/  




/*조회*/ --개설과정과목조회
CREATE OR REPLACE PROCEDURE prcSubjectRead IS  
    CURSOR prcSubject_cursor IS  
        SELECT
            prcSubjectseq,
            processSeq,
            subjectSeq,
            prcSubjectSDate,
            prcSubjectEDate 
        FROM
            prcSubject;
    v_prcSubjectseq prcSubject.prcSubjectseq%TYPE;          
    v_processSeq prcSubject.processSeq%TYPE;  
    v_subjectSeq prcSubject.subjectSeq%TYPE;
    v_prcSubjectSDate prcSubject.prcSubjectSDate%TYPE;
    v_prcSubjectEDate prcSubject.prcSubjectEDate%TYPE;
BEGIN  
    OPEN prcSubject_cursor;  -- 커서를 여는 부분  

    LOOP  
        FETCH prcSubject_cursor INTO v_prcSubjectseq,v_processSeq,v_subjectSeq,v_prcSubjectSDate,v_prcSubjectEDate;  -- 커서로부터 값을 읽어옴  
        EXIT WHEN prcSubject_cursor%NOTFOUND;  -- 더 이상 읽을 것이 없으면 루프 종료  
        
        -- 결과 출력  
        DBMS_OUTPUT.PUT_LINE('개설과정과목번호: ' || v_prcSubjectseq ||
                             ', 과정번호: ' || v_processSeq ||
                             ', 과목번호: ' || v_subjectSeq ||
                             ', 개설과목시작일: ' || v_prcSubjectSDate ||
                             ', 개설과목종료일: ' || v_prcSubjectEDate);  
    END LOOP;  

    CLOSE prcSubject_cursor;  -- 커서를 닫는 부분  

EXCEPTION  
    WHEN OTHERS THEN  
        DBMS_OUTPUT.PUT_LINE('오류 발생: ' || SQLERRM);   
END;  
/
--prcSubjectRead()
Begin
    prcSubjectRead();
end;
/

/*수정*/--개설과정과목수정
CREATE OR REPLACE PROCEDURE prcSubjectUpdate(
    p_prcSubjectSeq prcSubject.prcSubjectSeq%TYPE,
    p_processSeq prcSubject.processSeq%TYPE,  
    p_subjectSeq prcSubject.subjectSeq%TYPE,  
    p_prcSubjectSDate prcSubject.prcSubjectSDate%TYPE,
    p_prcSubjectEDate prcSubject.prcSubjectEDate%TYPE
) IS  
BEGIN  
    -- 교재 정보 업데이트  
    UPDATE prcSubject  
    SET 
        processSeq = p_processSeq,
        subjectSeq = p_subjectSeq,
        prcSubjectSDate = p_prcSubjectSDate,
        prcSubjectEDate = p_prcSubjectEDate
         
    WHERE prcSubjectSeq = p_prcSubjectSeq;  

    -- 변경된 행 수를 확인하고 출력  
    IF SQL%ROWCOUNT > 0 THEN  
        DBMS_OUTPUT.PUT_LINE('교재 번호 ' || p_prcSubjectSeq || '가(이) 성공적으로 업데이트되었습니다.');  
    ELSE  
        DBMS_OUTPUT.PUT_LINE('교재 번호 ' || p_prcSubjectSeq || '은(는) 존재하지 않거나 업데이트할 데이터가 없습니다.');  
    END IF;  

EXCEPTION  
    WHEN OTHERS THEN  
        ROLLBACK;  -- 오류 발생 시 롤백  
        DBMS_OUTPUT.PUT_LINE('오류 발생: ' || SQLERRM);   
END;
/
--prcSubjectUpdate()
Begin
    prcSubjectUpdate(1,2,1, to_date('24/08/07','YY-MM-DD'), to_date('24/09/11','YY-MM-DD'));
end;
/



-- /*삭제*/prcSubjectDelete
CREATE OR REPLACE PROCEDURE prcSubjectDelete(  
    p_prcSubjectSeq prcSubject.prcSubjectSeq%TYPE  
) IS  
BEGIN  
    -- 선택한 강의실 정보 초기화(삭제)
    UPDATE prcSubject  
    SET 
        prcSubjectSDate = null
       , prcSubjectEDate = null 
    WHERE prcSubjectSeq = p_prcSubjectSeq;  

    -- 변경된 행 수를 확인하고 출력  
    IF SQL%ROWCOUNT > 0 THEN  
        DBMS_OUTPUT.PUT_LINE('개설과정과목번호 ' || p_prcSubjectSeq || '가(이) 성공적으로 초기화되었습니다.');  
    ELSE  
        DBMS_OUTPUT.PUT_LINE('개설과정과목번호 ' || p_prcSubjectSeq || '은(는) 존재하지 않거나 업데이트할 데이터가 없습니다.');  
    END IF;  

EXCEPTION  
    WHEN OTHERS THEN  
        ROLLBACK;  -- 오류 발생 시 롤백  
        DBMS_OUTPUT.PUT_LINE('오류 발생: ' || SQLERRM);   
END;  
/
-- prcSubjectDelete(개설과정과목번호);
begin
    prcSubjectDelete(1);
end;
/


/*
업무 영역	관리자
요구사항 명	B-06. 교육생 관리 기능
개요	관리자는 교육생 전체 정보 조회, 등록, 수정, 삭제 등 관리할 수 있다.
상세설명	
1. 교육생 정보 등록	
- 교육생의 이름, 주민번호 뒷자리, 전화번호, 등록일, 수강(신청) 횟수 등 기본정보를 등록한다.	
- 주민번호 뒷자리는 로그인 및 패스워드에 사용한다.	
	
2. 교육생 정보 출력	
- 이름, 주민번호 뒷자리, 전화번호, 등록일, 수강(신청) 횟수 확인 가능하다.	
	
3.  특정 교육생 선택 시	
- 교육생이 수강 신청한 또는 수강중인, 수강했던 개설 과정 정보 확인이 가능 하다.	
- 과정 명, 과정기간(시작 년 월일, 끝 년 월일), 강의실, 수료 및 중도 탈락 여부, 수료 및 중도 탈락 날짜를 가져올 수 있다.	
	
4. 검색 기능	
- 교육생의 이름, 주민번호 뒷자리, 전화번호를 기본 기준으로 검색할 수 있다.	
	
5. 교육생의 정보 입력, 출력, 수정, 삭제 가능하다.	
	
6. 수료 및 중도 탈락 처리	
- 수료 및 중도 탈락 날짜 입력 가능하다.	
	
제약사항	
교육생 정보 입력 시 등록일은 자동으로 입력된다.	
*/



--///////////////////////// B-06. 교육생 관리 기능/////////////////
/*추가*/--1. 학생 정보 입력
CREATE OR REPLACE PROCEDURE StudentInsert(  
    p_studentName IN VARCHAR2,  
    p_studentPw IN NUMBER,  
    p_studentTel IN VARCHAR2,   
    p_studentDate IN DATE  
)  
IS  
    v_studentSeq NUMBER;  
BEGIN  
    SELECT ststatus_seq1.NEXTVAL INTO v_studentSeq FROM DUAL;  

    INSERT INTO Student (studentSeq, studentName, studentPw, studentTel, studentDate)  
    VALUES (v_studentSeq, p_studentName, p_studentPw, p_studentTel, p_studentDate);  

    COMMIT;  
END;  
/  

select studentName as 이름, studentPw as 주민번호, studentTel as 전화번호, studentDate as 등록일 
from Student;

BEGIN  
    StudentInsert('이영희', 2345678, '010-2345-6789', '2024-06-03');  
END;  
/  

/*조회*/--2
CREATE OR REPLACE PROCEDURE studentRead  
IS  
    CURSOR student_cursor IS  
        SELECT studentName AS 이름, studentPw AS 주민번호, studentTel AS 전화번호, studentDate AS 등록일  
        FROM Student;  
    
    v_studentName VARCHAR2(50);  
    v_studentPw NUMBER;  
    v_studentTel VARCHAR2(20);  
    v_studentDate DATE;  
BEGIN  
    OPEN student_cursor;  
    LOOP  
        FETCH student_cursor INTO v_studentName, v_studentPw, v_studentTel, v_studentDate;  
        EXIT WHEN student_cursor%NOTFOUND;  
        
        DBMS_OUTPUT.PUT_LINE('이름: ' || v_studentName);  
        DBMS_OUTPUT.PUT_LINE('주민번호: ' || v_studentPw);  
        DBMS_OUTPUT.PUT_LINE('전화번호: ' || v_studentTel);  
        DBMS_OUTPUT.PUT_LINE('등록일: ' || TO_CHAR(v_studentDate, 'YYYY-MM-DD'));  
        DBMS_OUTPUT.PUT_LINE('-----------------------');  
    END LOOP;  
    CLOSE student_cursor;  
END;  
/  

BEGIN  
    studentRead();  
END;  
/
/*조회*/--3
CREATE OR REPLACE PROCEDURE studentInfoRead(  
    P_studentSeq student.studentSeq%TYPE  
)  
IS  
    CURSOR student_info_cursor IS  
        SELECT  
            st.studentname AS 이름,  
            c.coursename AS 과정명,  
            pr.processSDate AS 과정시작날짜,  
            pr.processEDate AS 과정종료날짜,  
            clR.clsroomname AS 강의실,  
            CASE   
                WHEN stS.Status IS NULL THEN '수료중'  
                ELSE stS.Status  
            END AS 수료여부,  
            stS.stStatusDate AS 날짜  
        FROM Student st  
        INNER JOIN studentCls stcl ON st.studentSeq = stcl.studentSeq  
        INNER JOIN process pr ON stcl.processSeq = pr.processSeq  
        INNER JOIN Course c ON pr.courseSeq = c.courseSeq  
        INNER JOIN clsRoom clR ON pr.clsRoomSeq = clR.clsRoomSeq  
        LEFT JOIN stStatus stS ON st.studentSeq = stS.studentSeq  
        WHERE st.studentSeq = P_studentSeq;  
    
    v_name VARCHAR2(50);  
    v_courseName VARCHAR2(100);  
    v_startDate DATE;  
    v_endDate DATE;  
    v_classroom VARCHAR2(50);  
    v_status VARCHAR2(20);  
    v_statusDate DATE;  
BEGIN  
    OPEN student_info_cursor;  
    LOOP  
        FETCH student_info_cursor INTO v_name, v_courseName, v_startDate, v_endDate, v_classroom, v_status, v_statusDate;  
        EXIT WHEN student_info_cursor%NOTFOUND;  
        
        DBMS_OUTPUT.PUT_LINE('이름: ' || v_name);  
        DBMS_OUTPUT.PUT_LINE('과정명: ' || v_courseName);  
        DBMS_OUTPUT.PUT_LINE('과정 시작날짜: ' || TO_CHAR(v_startDate, 'YYYY-MM-DD'));  
        DBMS_OUTPUT.PUT_LINE('과정 종료날짜: ' || TO_CHAR(v_endDate, 'YYYY-MM-DD'));  
        DBMS_OUTPUT.PUT_LINE('강의실: ' || v_classroom);  
        DBMS_OUTPUT.PUT_LINE('수료여부: ' || v_status);  
        DBMS_OUTPUT.PUT_LINE('날짜: ' || TO_CHAR(v_statusDate, 'YYYY-MM-DD'));  
        DBMS_OUTPUT.PUT_LINE('-----------------------');  
    END LOOP;  
    CLOSE student_info_cursor;  
END;  
/  

BEGIN  
    studentInfoRead(1);  
END;  
/  

--4
CREATE OR REPLACE PROCEDURE stInfoReadName(  
    P_studentName student.studentName%TYPE  
)  
IS  
    CURSOR student_info_cursor IS  
        SELECT studentName AS 이름, studentPw AS 주민번호, studentTel AS 전화번호, studentDate AS 등록일  
        FROM student  
        WHERE studentName = P_studentName;  
    
    v_name student.studentName%TYPE;  
    v_pw student.studentPw%TYPE;  
    v_tel student.studentTel%TYPE;  
    v_date student.studentDate%TYPE;  
BEGIN  
    OPEN student_info_cursor;  
    LOOP  
        FETCH student_info_cursor INTO v_name, v_pw, v_tel, v_date;  
        EXIT WHEN student_info_cursor%NOTFOUND;  
        
        DBMS_OUTPUT.PUT_LINE('이름: ' || v_name);  
        DBMS_OUTPUT.PUT_LINE('주민번호: ' || v_pw);  
        DBMS_OUTPUT.PUT_LINE('전화번호: ' || v_tel);  
        DBMS_OUTPUT.PUT_LINE('등록일: ' || TO_CHAR(v_date, 'YYYY-MM-DD'));  
        DBMS_OUTPUT.PUT_LINE('-----------------------');  
    END LOOP;  
    CLOSE student_info_cursor;  
END;  
/  
BEGIN  
    stInfoReadName('정수현');  
END;  
/  

CREATE OR REPLACE PROCEDURE stInfoReadPw(  
    P_studentPw student.studentPw%TYPE  
)  
IS  
    CURSOR student_info_cursor IS  
        SELECT studentName AS 이름, studentPw AS 주민번호, studentTel AS 전화번호, studentDate AS 등록일  
        FROM student  
        WHERE studentPw = P_studentPw;  
    
    v_name student.studentName%TYPE;  
    v_pw student.studentPw%TYPE;  
    v_tel student.studentTel%TYPE;  
    v_date student.studentDate%TYPE;  
BEGIN  
    OPEN student_info_cursor;  
    LOOP  
        FETCH student_info_cursor INTO v_name, v_pw, v_tel, v_date;  
        EXIT WHEN student_info_cursor%NOTFOUND;  
        
        DBMS_OUTPUT.PUT_LINE('이름: ' || v_name);  
        DBMS_OUTPUT.PUT_LINE('주민번호: ' || v_pw);  
        DBMS_OUTPUT.PUT_LINE('전화번호: ' || v_tel);  
        DBMS_OUTPUT.PUT_LINE('등록일: ' || TO_CHAR(v_date, 'YYYY-MM-DD'));  
        DBMS_OUTPUT.PUT_LINE('-----------------------');  
    END LOOP;  
    CLOSE student_info_cursor;  
END;  
/  
BEGIN  
    stInfoReadPw('1234560');  
END;  
/ 

CREATE OR REPLACE PROCEDURE stInfoReadTel(  
    P_studentTel student.studentTel%TYPE  
)  
IS  
    CURSOR student_info_cursor IS  
        SELECT studentName AS 이름, studentPw AS 주민번호, studentTel AS 전화번호, studentDate AS 등록일  
        FROM student  
        WHERE studentTel = P_studentTel;  
    
    v_name student.studentName%TYPE;  
    v_pw student.studentPw%TYPE;  
    v_tel student.studentTel%TYPE;  
    v_date student.studentDate%TYPE;  
BEGIN  
    OPEN student_info_cursor;  
    LOOP  
        FETCH student_info_cursor INTO v_name, v_pw, v_tel, v_date;  
        EXIT WHEN student_info_cursor%NOTFOUND;  
        
        DBMS_OUTPUT.PUT_LINE('이름: ' || v_name);  
        DBMS_OUTPUT.PUT_LINE('주민번호: ' || v_pw);  
        DBMS_OUTPUT.PUT_LINE('전화번호: ' || v_tel);  
        DBMS_OUTPUT.PUT_LINE('등록일: ' || TO_CHAR(v_date, 'YYYY-MM-DD'));  
        DBMS_OUTPUT.PUT_LINE('-----------------------');  
    END LOOP;  
    CLOSE student_info_cursor;  
END;  
/  

BEGIN  
    stInfoReadTel('010-5678-9012');  
END;  
/ 

--5 /*수정*/
CREATE OR REPLACE PROCEDURE studentUpdate(  
    P_studentSeq student.studentSeq%TYPE,  
    P_studentName student.studentName%TYPE,  
    P_studentPw student.studentPw%TYPE,  
    P_studentTel student.studentTel%TYPE,  
    P_studentDate student.studentDate%TYPE  
)  
IS  
BEGIN  
    UPDATE student  
    SET studentName = P_studentName,  
        studentPw = P_studentPw,  
        studentTel = P_studentTel,  
        studentDate = P_studentDate  
    WHERE studentSeq = P_studentSeq;  
END;  
/  

BEGIN  
    studentUpdate(1, '김우현', 1520316, '010-4983-9012', '2025-02-04');  
END;  
/

--5 /*수정*/
CREATE OR REPLACE PROCEDURE stStatusUpdate(  
    P_studentSeq stStatus.studentSeq%TYPE,  
    P_status stStatus.status%TYPE,  
    P_stStatusDate stStatus.stStatusDate%TYPE  
)  
IS  
BEGIN  
    UPDATE stStatus  
    SET status = P_status,  
        stStatusDate = P_stStatusDate  
    WHERE stStatus.studentSeq = P_studentSeq;  
END;  
/  

BEGIN  
    stStatusUpdate(1, '중도탈락', '2025-02-04');  
END;  
/  

/*삭제*/
--5
CREATE OR REPLACE PROCEDURE Studentdelete(  
    P_studentSeq student.studentSeq%TYPE  
)  
IS  
BEGIN  
    UPDATE student  
    SET studentName = NULL,  
        studentPw = NULL,  
        studentTel = NULL,  
        studentDate = NULL  
    WHERE studentSeq = P_studentSeq;  
END;  
/  

BEGIN  
    Studentdelete(1);  
END;  
/  


SELECT * from Student;





/*
업무 영역	관리자
요구사항 명	B-07. 시험 관리 및 성적 조회기능
개요	관리자는 시험 관리 및 성적 조회할 수 있다.
상세설명	
1. 특정 개설 과정을 선택 시 과목 정보 확인	
- 과목 별로 성적을 등록 할 수 있다.	
- 시험 문제 파일 등록 여부 확인한다.	
	
2. 성적 정보 출력	
- 과목별 및 교육생 개인별 확인 가능하다.	
- 과목별 출력 시: 개설 과정 명, 개설 과정기간, 강의실명, 개설 과목명, 교사 명, 교재 명 및 과목을 수강한 교육생의 성적정보(교육생 이름, 주민번호 뒷자리, 필기, 실기) 확인한다	
- 교육생 개인별 출력 시: 교육생 이름, 주민번호 뒷자리, 개설 과정 명, 개설 과정기간, 강의실명 및 교육생이 수강한 개설 과목에 대한 성적정보(과목명, 과목 기간, 교사 명, 성적, 필기, 실기) 확인한다	
	
제약사항	
실행과 결과만을 시스템으로 관리한다.	
*/



/*  B-07 관리자 - 시험관리, 성적조회  */
/*추가*/
--성적 등록 (과목성적번호, 교육생번호, 과목번호, 필기점수, 실기점수, 출석점수, 총점수)
CREATE OR REPLACE PROCEDURE c_procscore (
  p_studentSeq       SCORE.STUDENTSEQ%TYPE,
  p_s_subjectSeq       SCORE.SUBJECTSEQ%TYPE,
  p_writingScore     SCORE.WRITINGSCORE%TYPE,
  p_realScore        SCORE.REALSCORE%TYPE,
  p_attendanceScore  SCORE.ATTENDANCESCORE%TYPE,
  p_totalScore       SCORE.TOTALSCORE%TYPE
) IS
BEGIN
  INSERT INTO SCORE (scoreSeq, studentSeq, subjectSeq, writingScore, realScore, attendanceScore, totalScore)
  VALUES (score_seq.NEXTVAL, p_studentSeq, p_s_subjectSeq, p_writingScore, p_realScore, p_attendanceScore, p_totalScore);

END;
/

--성적 등록 (교육생번호, 과목번호, 필기점수, 실기점수, 출석점수, 총점수)
BEGIN
  c_procscore(27, 1, 0, 72, 20, 92);
  dbms_output.put_line('성적 등록 완료');
END;
/


/*조회*/
-- 개설과정번호를 조회하여 시험문제 확인
CREATE OR REPLACE PROCEDURE r_p_processSeq(
    p_processSeq process.processSeq%TYPE
) IS
    v_courseName Course.courseName%TYPE;
    v_subjectName subject.subjectName%TYPE;
    v_testType test.testType%TYPE;
    v_testContext test.testContext%TYPE;
    v_testDate test.testDate%TYPE;
    
    CURSOR process_cursor IS
        SELECT 
            c.courseName,
            s.subjectName,
            t.testType,
            t.testContext,
            t.testDate
        FROM process p
            INNER JOIN Course c ON p.courseSeq = c.courseSeq
            INNER JOIN prcSubject ps ON p.processSeq = ps.processSeq
            INNER JOIN subject s ON ps.subjectSeq = s.subjectSeq
            INNER JOIN test t ON s.subjectSeq = t.subjectSeq
        WHERE 
            p.processSeq = p_processSeq
            AND t.teacherSeq = p.teacherSeq
            AND t.testDate < p.processEDate;
BEGIN
    OPEN process_cursor;
    LOOP
        FETCH process_cursor INTO 
            v_courseName, v_subjectName, v_testType, v_testContext, v_testDate;
        
        EXIT WHEN process_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('개설과정번호로 조회된 시험문제');
        DBMS_OUTPUT.PUT_LINE('과정명: ' || v_courseName || ', 과목명: ' || v_subjectName);
        DBMS_OUTPUT.PUT_LINE('시험종류: ' || v_testType || ', 시험문제: ' || v_testContext);
        DBMS_OUTPUT.PUT_LINE('날짜: ' || v_testDate);
        DBMS_OUTPUT.PUT_LINE('-------------------------------------------------');
    END LOOP;
    
    CLOSE process_cursor;
END;
/

--개설과정번호로 조회
BEGIN
    r_p_processSeq(2);
END;
/
    

-- 과목번호를 조회하여 성적정보 확인
CREATE OR REPLACE PROCEDURE r_s_subjectSeq(
    p_subjectSeq subject.subjectSeq%TYPE
) IS
    v_courseName Course.courseName%TYPE;
    v_processSDate process.processSDate%TYPE;
    v_processEDate process.processEDate%TYPE;
    v_clsRoomName clsRoom.clsRoomName%TYPE;
    v_subjectName subject.subjectName%TYPE;
    v_teacherName teacher.teacherName%TYPE;
    v_bookName book.bookName%TYPE;
    v_studentName student.studentName%TYPE;
    v_studentPw student.studentPw%TYPE;
    v_writingScore score.writingScore%TYPE;
    v_realScore score.realScore%TYPE;
    
    CURSOR subject_cursor IS
        SELECT 
            c.courseName,
            p.processSDate,
            p.processEDate,
            cr.clsRoomName,
            s.subjectName,
            t.teacherName,
            b.bookName,
            st.studentName,
            st.studentPw,
            sc.writingScore,
            sc.realScore
        FROM process p
            INNER JOIN Course c ON p.courseSeq = c.courseSeq
            INNER JOIN clsRoom cr ON p.clsRoomSeq = cr.clsRoomSeq
            INNER JOIN prcSubject ps ON p.processSeq = ps.processSeq
            INNER JOIN subject s ON ps.subjectSeq = s.subjectSeq
            INNER JOIN sbjectBook sb ON s.subjectSeq = sb.subjectSeq
            INNER JOIN book b ON sb.bookSeq = b.bookSeq
            INNER JOIN teacher t ON p.teacherSeq = t.teacherSeq
            INNER JOIN studentCls sc ON p.processSeq = sc.processSeq
            INNER JOIN student st ON sc.studentSeq = st.studentSeq
            INNER JOIN score sc ON st.studentSeq = sc.studentSeq AND s.subjectSeq = sc.subjectSeq
        WHERE 
            s.subjectSeq = p_subjectSeq;
BEGIN
    OPEN subject_cursor;
    LOOP
        FETCH subject_cursor INTO 
            v_courseName, v_processSDate, v_processEDate, v_clsRoomName, v_subjectName, v_teacherName, v_bookName, v_studentName, v_studentPw, v_writingScore, v_realScore;
        
        EXIT WHEN subject_cursor%NOTFOUND;
        dbms_output.put_line('과목번호로 조회된 성적정보');
        DBMS_OUTPUT.PUT_LINE('과정명: ' || v_courseName || ', 과정시작날짜: ' || v_processSDate || ', 과정종료날짜: ' || v_processEDate);
        DBMS_OUTPUT.PUT_LINE('강의실명: ' || v_clsRoomName || ', 과목명: ' || v_subjectName || ', 교사명: ' || v_teacherName);
        DBMS_OUTPUT.PUT_LINE('교재명: ' || v_bookName || ', 학생이름: ' || v_studentName || ', 주민번호뒷자리: ' || v_studentPw);
        DBMS_OUTPUT.PUT_LINE('필기점수: ' || v_writingScore || ', 실기점수: ' || v_realScore);
        DBMS_OUTPUT.PUT_LINE('-------------------------------------------------');
    END LOOP;
    
    CLOSE subject_cursor;
END;
/

--과목번호로 조회
BEGIN
    r_s_subjectSeq(1);
END;
/

    
-- 교육생 이름을 조회하여 성적정보 확인
CREATE OR REPLACE PROCEDURE r_st_studentName(
    p_studentName student.studentName%TYPE
) IS
    v_studentName student.studentName%TYPE;
    v_studentPw student.studentPw%TYPE;
    v_courseName Course.courseName%TYPE;
    v_processSDate process.processSDate%TYPE;
    v_processEDate process.processEDate%TYPE;
    v_clsRoomName clsRoom.clsRoomName%TYPE;
    v_subjectName subject.subjectName%TYPE;
    v_prcSubjectSDate prcSubject.prcSubjectSDate%TYPE;
    v_prcSubjectEDate prcSubject.prcSubjectEDate%TYPE;
    v_teacherName teacher.teacherName%TYPE;
    v_attendanceScore score.attendanceScore%TYPE;
    v_writingScore score.writingScore%TYPE;
    v_realScore score.realScore%TYPE;
    
    CURSOR student_cursor IS
        SELECT 
            st.studentName,
            st.studentPw,
            c.courseName,
            p.processSDate,
            p.processEDate,
            cr.clsRoomName,
            s.subjectName,
            ps.prcSubjectSDate,
            ps.prcSubjectEDate,
            t.teacherName,
            sc.attendanceScore,
            sc.writingScore,
            sc.realScore
        FROM student st
            INNER JOIN studentCls scs ON st.studentSeq = scs.studentSeq
            INNER JOIN process p ON scs.processSeq = p.processSeq
            INNER JOIN Course c ON p.courseSeq = c.courseSeq
            INNER JOIN clsRoom cr ON p.clsRoomSeq = cr.clsRoomSeq
            INNER JOIN prcSubject ps ON p.processSeq = ps.processSeq
            INNER JOIN subject s ON ps.subjectSeq = s.subjectSeq
            INNER JOIN sbjectBook sb ON s.subjectSeq = sb.subjectSeq
            INNER JOIN book b ON sb.bookSeq = b.bookSeq
            INNER JOIN teacher t ON p.teacherSeq = t.teacherSeq
            INNER JOIN score sc ON st.studentSeq = sc.studentSeq AND s.subjectSeq = sc.subjectSeq
        WHERE 
            st.studentName = p_studentName;
BEGIN
    OPEN student_cursor;
    LOOP
        FETCH student_cursor INTO 
            v_studentName, v_studentPw, v_courseName, v_processSDate, v_processEDate, v_clsRoomName, v_subjectName, v_prcSubjectSDate, v_prcSubjectEDate, v_teacherName, v_attendanceScore, v_writingScore, v_realScore;
        
        EXIT WHEN student_cursor%NOTFOUND;
        dbms_output.put_line('교육생 이름으로 조회된 성적정보');
        DBMS_OUTPUT.PUT_LINE('학생이름: ' || v_studentName || ', 주민번호뒷자리: ' || v_studentPw);
        DBMS_OUTPUT.PUT_LINE('과정명: ' || v_courseName || ', 과정시작날짜: ' || v_processSDate || ', 과정종료날짜: ' || v_processEDate);
        DBMS_OUTPUT.PUT_LINE('강의실명: ' || v_clsRoomName || ', 과목명: ' || v_subjectName);
        DBMS_OUTPUT.PUT_LINE('과목시작날짜: ' || v_prcSubjectSDate || ', 과목종료날짜: ' || v_prcSubjectEDate);
        DBMS_OUTPUT.PUT_LINE('교사명: ' || v_teacherName);
        DBMS_OUTPUT.PUT_LINE('출석점수: ' || v_attendanceScore || ', 필기점수: ' || v_writingScore || ', 실기점수: ' || v_realScore);
        DBMS_OUTPUT.PUT_LINE('-------------------------------------------------');
    END LOOP;
    
    CLOSE student_cursor;
END;
/

--교육생 이름 입력
BEGIN
    r_st_studentName('구하늘');
END;
/



/*수정*/
--과목번호 수정
CREATE OR REPLACE PROCEDURE u_subjectSeq(
    p_studentSeq score.studentSeq%TYPE,
    p_subjectSeq score.subjectSeq%TYPE
) IS
BEGIN
    UPDATE score SET subjectSeq = p_subjectSeq
    WHERE studentSeq = p_studentSeq;
END;
/

--학생번호, 과목번호
BEGIN
    u_subjectSeq(1, 1);
    dbms_output.put_line('수정 성공');
END;
/


--필기점수 수정
CREATE OR REPLACE PROCEDURE u_writingScore(
    p_studentSeq score.studentSeq%TYPE,
    p_writingScore score.writingScore%TYPE
) IS
BEGIN
    UPDATE score SET writingScore = p_writingScore
    WHERE studentSeq = p_studentSeq;
END;
/

--학생번호, 필기점수
BEGIN
    u_writingScore(1, 0);
    dbms_output.put_line('수정 성공');
END;
/



--실기점수 수정
CREATE OR REPLACE PROCEDURE u_realScore(
    p_studentSeq score.studentSeq%TYPE,
    p_realScore score.realScore%TYPE
) IS
BEGIN
    UPDATE score SET realScore = p_realScore
    WHERE studentSeq = p_studentSeq;
END;
/

--학생번호, 실기번호
BEGIN
    u_realScore(1, 72);
    dbms_output.put_line('수정 성공');
END;
/



--출석점수 수정
CREATE OR REPLACE PROCEDURE u_attendanceScore(
    p_studentSeq score.studentSeq%TYPE,
    p_attendanceScore score.attendanceScore%TYPE
) IS
BEGIN
    UPDATE score SET attendanceScore = p_attendanceScore
    WHERE studentSeq = p_studentSeq;
END;
/
--학생번호, 출석점수
BEGIN
    u_attendanceScore(1, 20);
    dbms_output.put_line('수정 성공');    
END;
/



--총점수 수정
CREATE OR REPLACE PROCEDURE u_totalScore(
    p_studentSeq  score.studentSeq%TYPE,
    p_newScore    score.totalScore%TYPE
) 
IS
BEGIN
    UPDATE score
    SET totalScore = p_newScore
    WHERE studentSeq = p_studentSeq;
END u_totalScore;
/
--학생번호, 총점수
BEGIN
    u_totalScore(1, 92);
    dbms_output.put_line('수정 성공');
END;
/




/*
업무 영역	관리자
요구사항 명	B-08 출결 관리 및 출결 조회 가능
개요	관리자는 출결 관리 및 출결 조회수 있다.
상세설명	
1. 특정 개설 과정을 선택하면 모든 교육생의 출결 조회 가능하다.	
2. 출결 현황을 기간별(년, 월, 일) 확인 가능하다.	
3. 특정 과정 또는 교육생의 출결 현황 조회 가능하다.	
4. 현재 출결 관리 현황은 근태 상황 구분(정상, 지각, 조퇴, 외출, 병가, 기타)  가능하다.	
*/


-- B-08 출결 관리 및 출결 조회 가능
/*
1. 특정 개설 과정을 선택하면 모든 교육생의 출결 조회 가능하다.
2. 출결 현황을 기간별(년, 월, 일) 확인 가능하다.
3. 특정 과정 또는 교육생의 출결 현황 조회 가능하다.
4. 현재 출결 관리 현황은 근태 상황 구분(정상, 지각, 조퇴, 외출, 병가, 기타)  가능하다.
*/

/*추가*/
CREATE OR REPLACE PROCEDURE c_attendance (
    p_studentSeq attendance.studentSeq%TYPE,
    p_attendDate attendance.attendDate%TYPE,
    p_startTime attendance.startTime%TYPE,
    p_endTime attendance.endTime%TYPE,
    p_status attendance.status%TYPE
) IS
BEGIN
    INSERT INTO attendance
    VALUES (attendance_seq.nextval, p_studentSeq, p_attendDate, p_startTime, p_endTime, p_status);
END c_attendance;
/
--교육생번호, 날짜, 등원시간, 하원시간, 출결상태
BEGIN
    c_attendance(1, TO_DATE('2024-07-03', 'YYYY-MM-DD'), TO_DATE('09:00', 'HH24:MI'), TO_DATE('18:00', 'HH24:MI'), '정상');
    dbms_output.put_line('등록 완료');
END;
/


/*조회*/
CREATE OR REPLACE PROCEDURE r_stcls_processSeq (
    p_processSeq studentCls.processSeq%TYPE
) IS
    CURSOR cur_attendance IS
        SELECT
            c.courseName AS 과정번호,
            st.studentName AS 이름,
            at.attendanceDate AS 날짜,
            at.attendanceST AS 상태
        FROM attendance at
            INNER JOIN student st ON st.studentSeq = at.studentSeq
            INNER JOIN studentCls stcls ON st.studentSeq = stcls.studentSeq
            INNER JOIN process pr ON stcls.processSeq = pr.processSeq
            INNER JOIN Course c ON pr.courseSeq = c.courseSeq
        WHERE stcls.processSeq = p_processSeq;

    v_courseName Course.courseName%TYPE;
    v_studentName student.studentName%TYPE;
    v_attendanceDate attendance.attendanceDate%TYPE;
    v_attendanceST attendance.attendanceST%TYPE;

BEGIN
    FOR rec IN cur_attendance LOOP
        v_courseName := rec.과정번호;
        v_studentName := rec.이름;
        v_attendanceDate := rec.날짜;
        v_attendanceST := rec.상태;

        DBMS_OUTPUT.PUT_LINE(
            v_courseName || ' | ' ||
            v_studentName || ' | ' ||
            TO_CHAR(v_attendanceDate, 'YYYY-MM-DD') || ' | ' ||
            v_attendanceST
        );
    END LOOP;
END r_stcls_processSeq;
/

BEGIN
    r_stcls_processSeq(1);
END;
/

CREATE OR REPLACE PROCEDURE r_stuatt_processSeq (
    p_processSeq studentCls.processSeq%TYPE
) IS
    CURSOR cur_attendance IS
        SELECT
            st.studentSeq AS 교육생번호,
            st.studentName AS 이름,
            at.attendanceDate AS 날짜,
            at.attendanceStime AS 등원시간,
            at.attendanceETime AS 하원시간,
            at.attendanceST AS 출결상태
        FROM attendance at
            JOIN student st ON st.studentSeq = at.studentSeq
            JOIN studentCls stcls ON st.studentSeq = stcls.studentSeq
            JOIN process pr ON stcls.processSeq = pr.processSeq
        WHERE stcls.processSeq = p_processSeq;

    v_studentSeq student.studentSeq%TYPE;
    v_studentName student.studentName%TYPE;
    v_attendanceDate attendance.attendanceDate%TYPE;
    v_attendanceStime attendance.attendanceStime%TYPE;
    v_attendanceETime attendance.attendanceETime%TYPE;
    v_attendanceST attendance.attendanceST%TYPE;

BEGIN
    FOR rec IN cur_attendance LOOP
        v_studentSeq := rec.교육생번호;
        v_studentName := rec.이름;
        v_attendanceDate := rec.날짜;
        v_attendanceStime := rec.등원시간;
        v_attendanceETime := rec.하원시간;
        v_attendanceST := rec.출결상태;

        DBMS_OUTPUT.PUT_LINE(
            v_studentSeq || ' | ' ||
            v_studentName || ' | ' ||
            TO_CHAR(v_attendanceDate, 'YYYY-MM-DD') || ' | ' ||
            TO_CHAR(v_attendanceStime, 'HH24:MI') || ' | ' ||
            TO_CHAR(v_attendanceETime, 'HH24:MI') || ' | ' ||
            v_attendanceST
        );
    END LOOP;
END r_stuatt_processSeq;
/

BEGIN
    r_stuatt_processSeq(1);
END;
/

























/*
업무 영역	교사
요구사항 명	C-02. 강의스케줄 조회
개요	교사 계정 관리 및 개설 과정, 개설 과목에 사용하게 될 기초 정보를 등록 및 관리한다.
상세설명	
1교사는 자신의 강의 스케줄을 확인할 수 있어야 한다.	
2강의 스케줄은 강의 예정, 강의 중, 강의 종료로 구분해서 확인할 수 있어야 한다. 강의 진행 상태는 날짜를 기준으로 확인한다.	
3강의 스케줄 정보 출력 시 과목번호, 과정명, 과정기간(시작 년월일, 끝 년월일), 강의실과 과목명, 과목기간(시작 년월일, 끝 년월일), 교재명, 교육생 등록 인원을 확인할 수 있어야 한다.	
4교육중인 과정에 등록된 교육생 정보(교육생 이름, 전화번호, 등록일, 수료 또는 중도탈락)을 확인할 수 있어야 한다.	
	
제약사항	
기초 정보에 대한 입력, 출력, 수정, 삭제 기능을 사용할 수 있다.	
*/



/* 교사1,2,3 */
--a. 자신이 진행중인 강의스케줄 조회
CREATE OR REPLACE PROCEDURE teacherInfo (
    pTeacherName IN VARCHAR2
)
IS
BEGIN
-- 강사의 강의 정보 조회 및 출력
    FOR rec IN (
        SELECT 
            t.teacherName AS 교사이름,
            s.subjectName AS 과목명,
            TO_CHAR(ps.prcSubjectSDate, 'YYYY-MM-DD') AS 과목시작날짜,
            TO_CHAR(ps.prcSubjectEDate, 'YYYY-MM-DD') AS 과목종료날짜,
            c.courseName AS 과정명,
            TO_CHAR(p.processSDate, 'YYYY-MM-DD') AS 과정시작날짜,
            TO_CHAR(p.processEDate, 'YYYY-MM-DD') AS 과정종료날짜,
            b.bookName AS 교재명,
            cr.clsRoomName AS 강의실명,
            CASE
                WHEN ps.prcSubjectSDate > SYSDATE THEN '강의예정'
                WHEN ps.prcSubjectSDate <= SYSDATE AND ps.prcSubjectEDate >= SYSDATE THEN '강의중'
                ELSE '강의종료'
            END AS 강의진행여부,
            p.processCount AS 수강인원
        FROM teacher t
        JOIN process p ON t.teacherSeq = p.teacherSeq
        JOIN prcSubject ps ON p.processSeq = ps.processSeq
        JOIN subject s ON ps.subjectSeq = s.subjectSeq
        JOIN course c ON p.courseSeq = c.courseSeq
        JOIN clsRoom cr ON p.clsRoomSeq = cr.clsRoomSeq
        JOIN sbjectBook sb ON s.subjectSeq = sb.subjectSeq
        JOIN book b ON sb.bookSeq = b.bookSeq
        WHERE t.teacherName = pTeacherName
        ORDER BY p.processSDate
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('과정명: ' || rec.과정명);
        DBMS_OUTPUT.PUT_LINE('교사이름: ' || rec.교사이름);
        DBMS_OUTPUT.PUT_LINE('과목명: ' || rec.과목명);
        DBMS_OUTPUT.PUT_LINE('과목시작날짜: ' || rec.과목시작날짜 || ' | 과목종료날짜: ' || rec.과목종료날짜);
        DBMS_OUTPUT.PUT_LINE('강의실명: ' || rec.강의실명);
        DBMS_OUTPUT.PUT_LINE('교재명: ' || rec.교재명);
        DBMS_OUTPUT.PUT_LINE('과정시작날짜: ' || rec.과정시작날짜 || ' | 과정종료날짜: ' || rec.과정종료날짜);
        DBMS_OUTPUT.PUT_LINE('수강인원: ' || rec.수강인원);
        DBMS_OUTPUT.PUT_LINE('강의진행여부: ' || rec.강의진행여부);
        DBMS_OUTPUT.PUT_LINE('--------------------------------------');
    END LOOP;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('해당 강사의 강의 정보가 없습니다.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류 발생: ' || SQLERRM);
END teacherInfo;
/
BEGIN
    teacherInfo('구하늘');
END;
/

set serveroutput on;
-- c2_4 특정 강사의 진행중인 강의 듣는 학생명단 조회(수료 또는 중도탈락)
CREATE OR REPLACE PROCEDURE getCourseStudents (
    pTeacherSeq IN NUMBER,  -- 강사번호
    pProcessSeq IN NUMBER   -- 과정번호
)
IS
BEGIN
    -- 특정 강사의 특정 과정 수강 학생 목록 조회
    FOR rec IN (
        SELECT 
            distinct
            s.studentSeq AS 학생번호,
            s.studentName AS 학생명,
            s.studentTel AS 전화번호,
            TO_CHAR(s.studentDate, 'YYYY-MM-DD') AS 등록일,
            NVL(st.status, '수강중') AS 학생상태
        FROM prcSubject ps 
        INNER JOIN scoreAllot sa ON ps.prcSubjectSeq = sa.prcSubjectSeq
        INNER JOIN teacher t ON t.teacherSeq = sa.teacherSeq
        INNER JOIN subject s ON s.subjectSeq = ps.subjectSeq
        INNER JOIN process p ON p.processSeq = ps.processSeq
        INNER JOIN studentCls sc ON sc.processSeq = p.processSeq
        INNER JOIN student s ON s.studentSeq = sc.studentSeq
        LEFT OUTER JOIN stStatus st ON st.studentSeq = s.studentSeq
        WHERE t.teacherSeq = pTeacherSeq
          AND p.processSeq = pProcessSeq
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('학생번호: ' || rec.학생번호);
        DBMS_OUTPUT.PUT_LINE('학생명: ' || rec.학생명);
        DBMS_OUTPUT.PUT_LINE('전화번호: ' || rec.전화번호);
        DBMS_OUTPUT.PUT_LINE('등록일: ' || rec.등록일);
        DBMS_OUTPUT.PUT_LINE('학생상태: ' || rec.학생상태);
        DBMS_OUTPUT.PUT_LINE('--------------------------------------');
    END LOOP;

EXCEPTION
    -- 데이터가 없는 경우
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('해당 강사 (' || pTeacherSeq || ')의 과정번호 (' || pProcessSeq || ')에 대한 학생 정보가 없습니다.');
    -- 기타 오류 처리
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류 발생: ' || SQLERRM);
END getCourseStudents;
/


BEGIN
    getCourseStudents(6, 1); -- 강사번호 6번, 과정번호 1번 강의 듣는 학생 조회
END;
/


/*
업무 영역	교사
요구사항 명	C-03. 배점 입출력
개요	교사는 특정 과정에 과목의 배점을 입력
상세설명	
1.교사가 강의를 마친 과목에 대한 성적 처리를 위해서 배점 입출력을 할 수 있어야 한다.	
2.교사는 자신이 강의를 마친 과목의 목록 중에서 특정 과목을 선택하고 해당 과목의 배점 정보를 출결, 필기, 실기로 구분해서 등록할 수 있어야 한다. 시험 날짜, 시험 문제를 추가할 수 있어야 한다.	
3.출결, 필기, 실기의 배점 비중은 담당 교사가 과목별로 결정한다.	
4.과목 목록 출력 시 과목번호, 과정명, 과정기간(시작 년월일, 끝 년월일), 강의실, 과목명, 과목기간(시작 년월일, 끝 년월일), 교재명, 출결, 필기, 실기 배점 등이 출력되고, 특정 과목을 과목번호로 선택 시 출결 배점, 필기 배점, 실기 배점, 시험 날짜, 시험 문제를 입력할 수 있는 화면으로 연결되어야 한다.	
	
제약사항	
배점 등록이 안 된 과목인 경우는 과목 정보가 출력될 때 배점 부분은 null 값으로 출력한다.	
출결은 최소 20점 이상이어야 하고, 출결, 필기, 실기의 합은 100점이 되도록 한다.	
*/



/*추가*/
--1. 성적 배점 추가
CREATE OR REPLACE PROCEDURE c_scoreAllot (
    p_prcSubjectSeq scoreAllot.prcSubjectSeq%TYPE,
    p_teacherSeq scoreAllot.teacherSeq%TYPE,
    p_attendAllot scoreAllot.attendAllot%TYPE,
    p_writingAllot scoreAllot.writingAllot%TYPE,
    p_realAllot scoreAllot.realAllot%TYPE
) IS
BEGIN
    INSERT INTO scoreAllot(scoreAllotSeq, prcSubjectSeq, teacherSeq, attendAllot, writingAllot, realAllot)
    VALUES (scoreAllot_Seq.NEXTVAL, p_prcSubjectSeq, p_teacherSeq, p_attendAllot, p_writingAllot, p_realAllot);
END;
/
--개설과정과목번호, 교사번호, 출석배점, 필기배점, 실기배점
BEGIN
    c_scoreAllot(1, 1, 20, 0, 80);
    dbms_output.put_line('삽입 성공');
END;
/


--2. 시험정보 추가
CREATE OR REPLACE PROCEDURE c_test (
    p_subjectSeq test.subjectSeq%TYPE,
    p_teacherSeq test.teacherSeq%TYPE,
    p_testType test.testType%TYPE,
    p_testContext test.testContext%TYPE,
    p_testDate test.testDate%TYPE
) IS
BEGIN
    INSERT INTO test(testSeq, subjectSeq, teacherSeq, testType, testContext, testDate)
    VALUES (test_Seq.NEXTVAL, p_subjectSeq, p_teacherSeq, p_testType, p_testContext, p_testDate);
END;
/
--과목번호, 교사번호, 시험종류(필기,실기), 시험문제, 날짜
BEGIN
    c_test(1, 1, '실기', q'[두 개의 정수 배열이 주어졌을 때, 두 배열의 교집합을 찾는 프로그램을 작성하세요. 단, 교집합의 원소는 중복되지 않으며 정렬된 상태로 출력해야 합니다.]', to_date('24/09/04', 'yy-mm-dd'));
    dbms_output.put_line('삽입 성공');
END;
/



/*조회*/
--1
CREATE OR REPLACE PROCEDURE r_scoreAllot IS
    CURSOR cur_scoreAllot IS
        SELECT 
            s.subjectName AS 과목명,
            scA.attendAllot AS 출결배점,
            scA.writingAllot AS 필기배점,
            scA.realAllot AS 실기배점,
            t.teacherName AS 교사명
        FROM scoreAllot scA
            INNER JOIN teacher t ON t.teacherSeq = scA.teacherSeq
            INNER JOIN prcSubject ps ON scA.prcSubjectSeq = ps.prcSubjectSeq
            INNER JOIN subject s ON ps.subjectSeq = s.subjectSeq;

    v_subjectName subject.subjectName%TYPE;
    v_attendAllot scoreAllot.attendAllot%TYPE;
    v_writingAllot scoreAllot.writingAllot%TYPE;
    v_realAllot scoreAllot.realAllot%TYPE;
    v_teacherName teacher.teacherName%TYPE;
BEGIN
    FOR rec IN cur_scoreAllot LOOP
        v_subjectName := rec.과목명;
        v_attendAllot := rec.출결배점;
        v_writingAllot := rec.필기배점;
        v_realAllot := rec.실기배점;
        v_teacherName := rec.교사명;

        DBMS_OUTPUT.PUT_LINE(
            v_subjectName || ' | ' ||
            v_attendAllot || ' | ' ||
            v_writingAllot || ' | ' ||
            v_realAllot || ' | ' ||
            v_teacherName
        );
    END LOOP;
END r_scoreAllot;
/

BEGIN
    r_scoreAllot;
END;
/

--4
CREATE OR REPLACE PROCEDURE r_subject IS
    CURSOR cur_subject IS
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
            t.teacherSeq = 5  
            AND ps.prcSubjectEDate <= SYSDATE  
            AND p.processSDate <= ps.prcSubjectSDate  
            AND p.processEDate >= ps.prcSubjectEDate;  

    v_subjectSeq subject.subjectSeq%TYPE;
    v_courseName course.courseName%TYPE;
    v_processSDate process.processSDate%TYPE;
    v_processEDate process.processEDate%TYPE;
    v_clsRoomName clsRoom.clsRoomName%TYPE;
    v_subjectName subject.subjectName%TYPE;
    v_prcSubjectSDate prcSubject.prcSubjectSDate%TYPE;
    v_prcSubjectEDate prcSubject.prcSubjectEDate%TYPE;
    v_bookName book.bookName%TYPE;
    v_studentName student.studentName%TYPE;
    v_attendAllot scoreAllot.attendAllot%TYPE;
    v_writingAllot scoreAllot.writingAllot%TYPE;
    v_realAllot scoreAllot.realAllot%TYPE;
BEGIN
    FOR rec IN cur_subject LOOP
        v_subjectSeq := rec.과목번호;
        v_courseName := rec.과정명;
        v_processSDate := rec.과정시작날짜;
        v_processEDate := rec.과정종료날짜;
        v_clsRoomName := rec.강의실명;
        v_subjectName := rec.과목명;
        v_prcSubjectSDate := rec.과목시작날짜;
        v_prcSubjectEDate := rec.과목종료날짜;
        v_bookName := rec.교재명;
        v_studentName := rec.이름;
        v_attendAllot := rec.출석배점;
        v_writingAllot := rec.필기배점;
        v_realAllot := rec.실기배점;

        DBMS_OUTPUT.PUT_LINE(
            v_subjectSeq || ' | ' ||
            v_courseName || ' | ' ||
            v_processSDate || ' | ' ||
            v_processEDate || ' | ' ||
            v_clsRoomName || ' | ' ||
            v_subjectName || ' | ' ||
            v_prcSubjectSDate || ' | ' ||
            v_prcSubjectEDate || ' | ' ||
            v_bookName || ' | ' ||
            v_studentName || ' | ' ||
            v_attendAllot || ' | ' ||
            v_writingAllot || ' | ' ||
            v_realAllot
        );
    END LOOP;
END r_subject;
/
--과목 목록 조회
BEGIN
    r_subject;
END;
/





/*수정*/
--1
CREATE OR REPLACE PROCEDURE u_scoreAllot(
    p_scoreAllotSeq IN scoreAllot.scoreAllotSeq%TYPE,
    p_prcSubjectSeq IN scoreAllot.prcSubjectSeq%TYPE,
    p_teacherSeq IN scoreAllot.teacherSeq%TYPE,
    p_attendAllot IN scoreAllot.attendAllot%TYPE,
    p_writingAllot IN scoreAllot.writingAllot%TYPE,
    p_realAllot IN scoreAllot.realAllot%TYPE
) IS
BEGIN
    UPDATE scoreAllot  
    SET prcSubjectSeq = p_prcSubjectSeq,
        teacherSeq = p_teacherSeq,
        attendAllot = p_attendAllot,
        writingAllot = p_writingAllot,
        realAllot = p_realAllot
    WHERE scoreAllotSeq = p_scoreAllotSeq;
END u_scoreAllot;
/
--과목배점번호기준, 개설과정과목번호, 교사번호, 출석배점, 필기배점, 실기배점 수정문
BEGIN
    u_scoreAllot(1, 1, 1, 20, 0, 80);
    dbms_output.put_line('수정 성공');
END;
/


/*삭제*/
--1
CREATE OR REPLACE PROCEDURE d_scoreAllot(p_scoreAllotSeq IN scoreAllot.scoreAllotSeq%TYPE) IS
    v_attendAllot scoreAllot.attendAllot%TYPE;
    v_writingAllot scoreAllot.writingAllot%TYPE;
    v_realAllot scoreAllot.realAllot%TYPE;
BEGIN
    v_attendAllot := NULL;
    v_writingAllot := NULL;
    v_realAllot := NULL;

    UPDATE scoreAllot
    SET attendAllot = v_attendAllot,
        writingAllot = v_writingAllot,
        realAllot = v_realAllot
    WHERE scoreAllotSeq = p_scoreAllotSeq;
END d_scoreAllot;
/
--과목배점번호 기준으로 삭제
BEGIN
    d_scoreAllot(1);
    dbms_output.put_line('삭제 성공');
END;
/

















/*
업무 영역	교사
요구사항 명	C-04. 성적 입출력
개요	교사는 특정 과목에 학생의 배점을 입력
상세설명	
1.교사가 강의를 마친 과목에 대한 성적 처리를 위해서 성적 입출력을 할 수 있어야 한다.	
2.교사는 자신이 강의를 마친 과목의 목록 중에서 특정 과목을 선택하면, 교육생 정보가 출력되고, 특정 교육생 정보를 선택하면, 해당 교육생의 시험 점수를 입력할 수 있어야 한다. 이때, 출결, 필기, 실기 점수를 구분해서 입력할 수 있어야 한다.	
3.과목 목록 출력시 과목번호, 과정명, 과정기간(시작 년월일, 끝 년월일), 강의실, 과목명, 과목기간(시작 년월일, 끝 년월일), 교재명, 출결, 필기, 실기 배점, 성적 등록 여부 등이 출력되고, 특정 과목을 과목번호로 선택시 교육생 정보(이름, 전화번호, 수료 또는 중도탈락) 및 성적이 출결, 필기, 실기 점수로 구분되어서 출력되어야 한다.	
4.성적 등록 여부는 교육생 전체에 대해서 성적을 등록했는지의 여부를 출력한다.	
	
제약사항	
1.중도 탈락인 경우 중도탈락 날짜가 출력되도록 한다.	
2.중도 탈락 처리된 교육생의 성적인 경우 중도탈락 이후 날짜의 성적은 입력하지 않는다.	
3.과정을 중도 탈락해서 성적 처리가 제외된 교육생이더라도 교육생 명단에는 출력되어야 한다. 중도 탈락 여부를 확인할 수 있도록 해야 한다.	
*/

/*  C-04 교사 - 성적 관리  */
/*추가*/
--성적 등록 (과목성적번호, 교육생번호, 과목번호, 필기점수, 실기점수, 출석점수, 총점수)

CREATE OR REPLACE PROCEDURE c_procscore (
  p_studentSeq       SCORE.STUDENTSEQ%TYPE,
  p_s_subjectSeq       SCORE.SUBJECTSEQ%TYPE,
  p_writingScore     SCORE.WRITINGSCORE%TYPE,
  p_realScore        SCORE.REALSCORE%TYPE,
  p_attendanceScore  SCORE.ATTENDANCESCORE%TYPE,
  p_totalScore       SCORE.TOTALSCORE%TYPE
) IS
BEGIN
  INSERT INTO SCORE (scoreSeq, studentSeq, subjectSeq, writingScore, realScore, attendanceScore, totalScore)
  VALUES (score_seq.NEXTVAL, p_studentSeq, p_s_subjectSeq, p_writingScore, p_realScore, p_attendanceScore, p_totalScore);

END;
/

--성적 등록 (교육생번호, 과목번호, 필기점수, 실기점수, 출석점수, 총점수)
BEGIN
  c_procscore(27, 1, 0, 72, 20, 92);
    DBMS_OUTPUT.PUT_LINE('성적 등록 완료');
END;
/


/*조회*/
--교사 이름을 입력하여 강의를 마친 과목 조회
CREATE OR REPLACE PROCEDURE r_t_teacherName(
    p_t_teacherName teacher.teacherName%TYPE
) IS
    v_subjectSeq subject.subjectSeq%TYPE;
    v_courseName course.courseName%TYPE;
    v_processSDate process.processSDate%TYPE;
    v_processEDate process.processEDate%TYPE;
    v_clsRoomName clsRoom.clsRoomName%TYPE;
    v_subjectName subject.subjectName%TYPE;
    v_prcSubjectSDate prcSubject.prcSubjectSDate%TYPE;
    v_prcSubjectEDate prcSubject.prcSubjectEDate%TYPE;
    v_bookName book.bookName%TYPE;
    v_studentName student.studentName%TYPE;
    v_attendAllot scoreAllot.attendAllot%TYPE;
    v_writingAllot scoreAllot.writingAllot%TYPE;
    v_realAllot scoreAllot.realAllot%TYPE;
    v_gradeStatus VARCHAR2(10);
    
    CURSOR teacher_cursor IS
        SELECT 
            s.subjectSeq,
            c.courseName,
            p.processSDate,
            p.processEDate,
            cr.clsRoomName,
            s.subjectName,
            ps.prcSubjectSDate,
            ps.prcSubjectEDate,
            b.bookName,
            st.studentName,
            sa.attendAllot,
            sa.writingAllot,
            sa.realAllot,
            CASE 
                WHEN sc.studentSeq IS NOT NULL THEN '등록'
                ELSE '미등록'
            END AS gradeStatus
        FROM teacher t
            INNER JOIN process p ON t.teacherSeq = p.teacherSeq
            INNER JOIN Course c ON p.courseSeq = c.courseSeq
            INNER JOIN clsRoom cr ON p.clsRoomSeq = cr.clsRoomSeq
            INNER JOIN prcSubject ps ON p.processSeq = ps.processSeq
            INNER JOIN subject s ON ps.subjectSeq = s.subjectSeq
            INNER JOIN sbjectBook sb ON s.subjectSeq = sb.subjectSeq
            INNER JOIN book b ON sb.bookSeq = b.bookSeq
            INNER JOIN studentCls scs ON p.processSeq = scs.processSeq
            INNER JOIN student st ON scs.studentSeq = st.studentSeq
            LEFT JOIN score sc ON st.studentSeq = sc.studentSeq AND s.subjectSeq = sc.subjectSeq
            INNER JOIN scoreAllot sa ON ps.prcSubjectSeq = sa.prcSubjectSeq
        WHERE 
            t.teacherName = p_t_teacherName
            AND ps.prcSubjectEDate <= SYSDATE
            AND p.processSDate <= ps.prcSubjectSDate
            AND p.processEDate >= ps.prcSubjectEDate;
BEGIN
    OPEN teacher_cursor;
    LOOP
        FETCH teacher_cursor INTO 
            v_subjectSeq, v_courseName, v_processSDate, v_processEDate, v_clsRoomName, v_subjectName,
            v_prcSubjectSDate, v_prcSubjectEDate, v_bookName, v_studentName, v_attendAllot, v_writingAllot,
            v_realAllot, v_gradeStatus;
        
        EXIT WHEN teacher_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('교사 이름을 기준으로 한 강의를 마친 과목 조회');
        DBMS_OUTPUT.PUT_LINE('과목번호: ' || v_subjectSeq || ', 과정명: ' || v_courseName || ', 과정 시작: ' || v_processSDate || ', 과정 종료: ' || v_processEDate);
        DBMS_OUTPUT.PUT_LINE('강의실: ' || v_clsRoomName || ', 과목명: ' || v_subjectName || ', 과목 시작: ' || v_prcSubjectSDate || ', 과목 종료: ' || v_prcSubjectEDate);
        DBMS_OUTPUT.PUT_LINE('교재: ' || v_bookName || ', 학생명: ' || v_studentName || ', 출석배점: ' || v_attendAllot || ', 필기배점: ' || v_writingAllot || ', 실기배점: ' || v_realAllot);
        DBMS_OUTPUT.PUT_LINE('성적등록여부: ' || v_gradeStatus);
        DBMS_OUTPUT.PUT_LINE('-------------------------------------------------');
    END LOOP;
    
    CLOSE teacher_cursor;
END;
/

--교사 이름으로 조회
BEGIN
    r_t_teacherName('구하늘');
END;
/

    
--과목을 조회하여 교육생 정보 출력
CREATE OR REPLACE PROCEDURE r_s_subjectSeq(
    p_s_subjectSeq subject.subjectSeq%TYPE
) IS
    v_studentName student.studentName%TYPE;
    v_studentTel student.studentTel%TYPE;
    v_educationStatus VARCHAR2(20);
    v_attendanceScore score.attendanceScore%TYPE;
    v_writingScore score.writingScore%TYPE;
    v_realScore score.realScore%TYPE;
    
    CURSOR subject_cursor IS
        SELECT 
            st.studentName,
            st.studentTel,
            CASE 
                WHEN ss.status = '수료' OR ss.status IS NULL THEN '수료'
                WHEN ss.stStatusDate >= p.processSDate AND ss.stStatusDate <= p.processEDate THEN '중도탈락'
                WHEN SYSDATE <= p.processSDate THEN '수강예정'
                WHEN SYSDATE >= p.processSDate AND SYSDATE <= p.processEDate THEN '수강중'
                ELSE '수료'
            END AS educationStatus,
            sc.attendanceScore,
            sc.writingScore,
            sc.realScore
        FROM student st
            INNER JOIN studentCls scs ON st.studentSeq = scs.studentSeq
            INNER JOIN process p ON scs.processSeq = p.processSeq
            INNER JOIN prcSubject ps ON p.processSeq = ps.processSeq
            INNER JOIN subject s ON ps.subjectSeq = s.subjectSeq
            LEFT JOIN stStatus ss ON st.studentSeq = ss.studentSeq
            INNER JOIN score sc ON st.studentSeq = sc.studentSeq AND s.subjectSeq = sc.subjectSeq
        WHERE 
            s.subjectSeq = p_s_subjectSeq
            AND p.processSDate <= ps.prcSubjectSDate
            AND p.processEDate >= ps.prcSubjectEDate;
BEGIN
    OPEN subject_cursor;
    LOOP
        FETCH subject_cursor INTO 
            v_studentName, v_studentTel, v_educationStatus, v_attendanceScore, v_writingScore, v_realScore;
        
        EXIT WHEN subject_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('과목번호로 조회된 교육생 정보');
        DBMS_OUTPUT.PUT_LINE('이름: ' || v_studentName || ', 전화번호: ' || v_studentTel || ', 교육생 상태: ' || v_educationStatus);
        DBMS_OUTPUT.PUT_LINE('출석점수: ' || v_attendanceScore || ', 필기점수: ' || v_writingScore || ', 실기점수: ' || v_realScore);
        DBMS_OUTPUT.PUT_LINE('-------------------------------------------------');
    END LOOP;
    
    CLOSE subject_cursor;
END;
/

--과목번호로 조회
BEGIN
    r_s_subjectSeq(41);
END;
/








/*
업무 영역	교사
요구사항 명	C-05. 출결 관리 및 출결 조회
개요	교사는 출결 현황
상세설명	
1.교사가 강의한 과정에 한해 선택하는 경우 모든 교육생의 출결을 조회할 수 있어야 한다.	
2.출결 현황을 기간별(년, 월, 일) 조회할 수 있어야 한다.	
3.특정(특정 과정, 특정 인원) 출결 현황을 조회할 수 있어야 한다.	
	
제약사항	
1.모든 출결 조회는 근태 상황을 구분할 수 있어야 한다.(정상, 지각, 조퇴, 외출, 병가, 기타)	
*/


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














/*
D. 교육생	
업무 영역	교육생
요구사항 명	D-01 교육생 로그인 기능
개요	교육생은 로그인을 통해 시스템의 일부기능을 사용할 수 있다
상세설명	
교육생은 로그인을 통해 개인의 정보와 수강 과정명, 과정기간( 시작년월일, 끝년월일), 강의실 확인 이 가능하다	
	
제약사항	로그인한 개인의 정보만 보여진다
*/

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








/*
업무 영역	교육생
요구사항 명	D-02 교육생 개인성적정보 확인기능
개요	교육생은 로그인 후에 개인 성적정보 확인을 할 수 있다
상세설명	
출력 내용으로 과목번호, 과목명, 과목기간(시작 년월일, 끝 년월일), 교재명, 교사명, 과목별 배점 정보(출결, 필기, 실기 배점), 과목별 성적 정보(출결, 필기, 실기 점수), 과목별 시험날짜, 시험문제가 출력된다	
	
제약사항	로그인한 개인의 정보만 보여진다
*/


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










/*
업무 영역	교육생
요구사항 명	D-03 교육생 출결관리 기능
개요	개인의 출결 관리를 기록할 수 있다
상세설명	
하루에 한번 출석 1회, 수업종료 1회를 기록할 수 있다	
	
제약사항	하루에 단 1회씩 기록이 가능하다
*/


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


----------------------------------------------------------------

--출석 입력하기, 등원 추가
CREATE OR REPLACE PROCEDURE pInsertAttendance(
    pstudentNum IN attendance.studentseq%TYPE
)
IS
    vstudentName student.studentname%TYPE;
    vcount number;
BEGIN
    select 
        studentname into vstudentName
    from student where studentseq = pstudentNum;
    
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
        attendancedate, 
        attendancestime, 
        attendanceetime, 
        attendancest
    ) VALUES (
        attendance_seq.NEXTVAL,     
        pstudentNum,               
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
        DBMS_OUTPUT.PUT_LINE('오류 발생');
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












/*
업무 영역	교육생
요구사항 명	D-04 교육생 출결조회 기능
개요	개인의 출결현황을 조회할 수 있다
상세설명	
개인의 출결현황을 기간별(전체, 월, 일)로 조회할 수 있어야 한다	
내용으로 출결상황(정상, 지각, 조퇴, 외출, 병가, 기타)을 구분할 수 있어야 한다	
	
제약사항	로그인한 개인의 정보만 보여진다
*/


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
--2. 1번 학생의 7월달 출결 조회
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
--3. 1번 학생의 날짜별 출결 조회
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











/*        추가기능           */


--==========================================================
/*  공휴일(추가,조회,수정,삭제)  */
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
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(vholiday_date, 'YYYY-MM-DD') ||' : 이날은 이미 등록된 휴일입니다! 날짜를 올바르게 입력해주세요.');
    ELSE
        INSERT INTO holiday VALUES (holiday_seq.NEXTVAL, vholiday_date, pHolidayName);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(vholiday_date, 'YYYY-MM-DD') || ' : 휴일(' || pHolidayName || ')이 정상적으로 추가되었습니다.');
    END IF;
END pInsertHoliday;
/

-- 호출하기 매개변수 : 년,월,일
begin
    pInsertHoliday(2024,4,15,'쉬는날~');
end;
/

select holidaydate as 날짜, holidayname as 휴일명 from holiday order by holidaydate;



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
    pUpdateHoliday(2024,4,15,'학원 쉬는날');
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
        
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(vholiday_date, 'YYYY-MM-DD') || '"의 휴일이 삭제되었습니다.');
    
    ELSE
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(vholiday_date, 'YYYY-MM-DD') || ' 해당 날짜의 휴일 정보가 없습니다!');
    END IF;
END pDeleteHoliday;
/

-- 호출하기 매개변수 : 년,월,일
begin
    pDeleteHoliday(2024,4,15);
end;
/









--==========================================================
/*  학생이 보유한 자격증 view, pl/sql crud  */
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



--==========================================================
/*  회사 정보 view  */
--==========================================================
/*  회사 정보 view  */

create or replace view vCompanyInfo
as
select 
    s.studentname as "학생명",
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


SELECT * FROM vCompanyInfo where 학생명 = '홍성준';


/*
studentCrtf테이블에 교육생이 어떤자격증을 가지고 있는지 저장하는 테이블이다. 
해당 자격증을 가지고 있는 학생과 해당 자격증이 필요한 기업을 연결하여 보여준다.

학생이 수행한 프로젝트에 사용한 기술스택번호와 기업에 지원하려면 필요한 기술스택을 연결하여 보여준다.

학생이 가지고있는 자격증과 팀에서 사용한 기술스택을 확인하여 관련 기업을 보여준다.
*/

/*
관련 조회는 프로시저가 있습니다!
*/
/* 해당 학생자격증관련 기업 목록  */
CREATE OR REPLACE PROCEDURE studentEnter (
    pstudentName IN VARCHAR2
)
IS
    CURSOR vcursor IS
        SELECT 
            e.enterName, 
            e.enterBuseo, 
            e.enterLocation, 
            e.enterSalary
        FROM studentCrtf sc
        INNER JOIN student s ON sc.studentSeq = s.studentSeq
        INNER JOIN crtf c ON c.crtfSeq = sc.crtfSeq
        INNER JOIN enter e ON c.crtfSeq = e.crtfSeq
        WHERE s.studentName = pstudentName;  
BEGIN  
    FOR rec IN vcursor LOOP
        dbms_output.put_line('기업명: ' || rec.enterName);
        dbms_output.put_line('부서: ' || rec.enterBuseo);
        dbms_output.put_line('위치: ' || rec.enterLocation);
        dbms_output.put_line('연봉: ' || rec.enterSalary);
        dbms_output.put_line('--------------------------------');
    END LOOP;
END studentEnter;
/
BEGIN
    studentEnter('강나라');
END;
/

/*  기업  */
select * from enter;
insert into enter values (enter_Seq.NEXTVAL,1,5,'테스트','테스트','테스트',1);
/*추가*/
create or replace procedure enterInsert(
    pcrtfSep number,
    ptechSep number,
    penterName varchar2,
    penterBuseo varchar2,
    penterLocation varchar2,
    penterSalary number
)
is
begin
    insert into enter values (enter_Seq.NEXTVAL,pcrtfSep,ptechSep,penterName,penterBuseo,penterLocation,penterSalary);
end enterInsert;
/
begin 
    enterInsert(1,5,'테스트','테스트','테스트',1);
    enterSelect;
end;
/

/* 조회 */
select * from enter;
create or replace procedure enterSelect
is
begin
    for rec in (select * from enter) loop
        dbms_output.put_line('기업 : ' || rec.enterName);
        dbms_output.put_line('부서 : ' || rec.enterBuseo);
        dbms_output.put_line('위치 : ' || rec.enterLocation);
        dbms_output.put_line('연봉 :' ||rec.enterSalary);
        dbms_output.put_line('--------------------------------');
    end loop;
end enterSelect;
/
begin
    enterSelect;
end;
/
rollback;

/*수정*/
create or replace procedure enterUpdate(
    ptechSep number,
    penterName varchar2,
    penterBuseo varchar2,
    penterLocation varchar2,
    penterSalary number
)
is
begin
    update enter set enterName = penterName, enterBuseo = penterBuseo, enterLocation = penterLocation, enterSalary = penterSalary  where enterSeq= ptechSep;
end enterUpdate;
/
begin 
    -- 수정할 기업 번호, 기업명, 부서, 위치, 연봉 입력 
    enterUpdate(100,'테스트','테스트','테스트',1);
end;
/
/*삭제*/
create or replace procedure enterDelete(
    ptechSep number
)
is
begin
    delete from enter where enterSeq = ptechSep;
end enterDelete;
/
begin 
    -- 삭제할 기업 번호
    enterDelete(1000);
end;
/

