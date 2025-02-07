BEGIN
  FOR c IN (SELECT table_name FROM user_tables) LOOP
    EXECUTE IMMEDIATE ('DROP TABLE ' || c.table_name || ' CASCADE CONSTRAINTS');
  END LOOP;
END;
/



/* 관리자 */
CREATE TABLE Admin (
	AdminSeq NUMBER NOT NULL, /* 관리자번호 */
	AdminName VARCHAR2(30) NOT NULL, /* 관리자명 */
	AdminTel VARCHAR2(30) NOT NULL, /* 전화번호 */
	AdminPw NUMBER NOT NULL /* 주민번호뒷자리 */
);


CREATE UNIQUE INDEX PK_Admin
	ON Admin (
		AdminSeq ASC
	);

ALTER TABLE Admin
	ADD
		CONSTRAINT PK_Admin
		PRIMARY KEY (
			AdminSeq
		);



/* 공휴일 */
CREATE TABLE holiday (
	holidaySeq NUMBER NOT NULL, /* 공휴일번호 */
	holidayDate DATE, /* 날짜 */
	holidayName VARCHAR2(100) /* 공휴일명 */
);


CREATE UNIQUE INDEX PK_holiday
	ON holiday (
		holidaySeq ASC
	);

ALTER TABLE holiday
	ADD
		CONSTRAINT PK_holiday
		PRIMARY KEY (
			holidaySeq
		);

/* 교사 */
CREATE TABLE teacher (
	teacherSeq NUMBER NOT NULL, /* 교사번호 */
	teacherName VARCHAR2(30), /* 교사명 */
	teacherPw NUMBER, /* 주민번호뒷자리 */
	teacherTel VARCHAR2(30) /* 전화번호 */
);

CREATE UNIQUE INDEX PK_teacher
	ON teacher (
		teacherSeq ASC
	);

ALTER TABLE teacher
	ADD
		CONSTRAINT PK_teacher
		PRIMARY KEY (
			teacherSeq
		);
        

/* 교재 */
CREATE TABLE book (
	bookSeq NUMBER NOT NULL, /* 교재번호 */
	bookName VARCHAR2(1000) NOT NULL, /* 교재명 */
	bookPublisher VARCHAR2(100), /* 출판사명 */
	bookAuthor VARCHAR2(100), /* 저자 */
	bookYear DATE /* 발행연도 */
);


CREATE UNIQUE INDEX PK_book
	ON book (
		bookSeq ASC
	);

ALTER TABLE book
	ADD
		CONSTRAINT PK_book
		PRIMARY KEY (
			bookSeq
		);



/* 과목 */
CREATE TABLE subject (
	subjectSeq NUMBER NOT NULL, /* 과목번호 */
	subjectName VARCHAR2(1000) NOT NULL, /* 과목명 */
	subjectEsn VARCHAR2(10) DEFAULT '선택' NOT NULL /* 필수여부(필수,선택) */
);


CREATE UNIQUE INDEX PK_subject
	ON subject (
		subjectSeq ASC
	);

ALTER TABLE subject
	ADD
		CONSTRAINT PK_subject
		PRIMARY KEY (
			subjectSeq
		);
     

/* 과목별교재 */
CREATE TABLE sbjectBook (
	sbjectBookSeq NUMBER NOT NULL, /* 과목별교재번호 */
	subjectSeq NUMBER NOT NULL, /* 과목번호 */
	bookSeq NUMBER NOT NULL /* 교재번호 */
);


CREATE UNIQUE INDEX PK_sbjectBook
	ON sbjectBook (
		sbjectBookSeq ASC
	);

ALTER TABLE sbjectBook
	ADD
		CONSTRAINT PK_sbjectBook
		PRIMARY KEY (
			sbjectBookSeq
		);

ALTER TABLE sbjectBook
	ADD
		CONSTRAINT FK_subject_TO_sbjectBook
		FOREIGN KEY (
			subjectSeq
		)
		REFERENCES subject (
			subjectSeq
		);

ALTER TABLE sbjectBook
	ADD
		CONSTRAINT FK_book_TO_sbjectBook
		FOREIGN KEY (
			bookSeq
		)
		REFERENCES book (
			bookSeq
		);

/* 교사가능과목 */
CREATE TABLE tSubject (
	tSubjectSeq NUMBER NOT NULL, /* 교사가능과목번호 */
	teacherSeq NUMBER NOT NULL, /* 교사번호 */
	subjectSeq NUMBER NOT NULL /* 과목번호 */
);

CREATE UNIQUE INDEX tSubject
	ON tSubject (
		tSubjectSeq ASC
	);

ALTER TABLE tSubject
	ADD
		CONSTRAINT tSubject
		PRIMARY KEY (
			tSubjectSeq
		);

ALTER TABLE tSubject
	ADD
		CONSTRAINT FK_teacher_TO_tSubject
		FOREIGN KEY (
			teacherSeq
		)
		REFERENCES teacher (
			teacherSeq
		);

ALTER TABLE tSubject
	ADD
		CONSTRAINT FK_subject_TO_tSubject
		FOREIGN KEY (
			subjectSeq
		)
		REFERENCES subject (
			subjectSeq
		);
        

/* 강의실 */
CREATE TABLE clsRoom (
	clsRoomSeq NUMBER NOT NULL, /* 강의실번호 */
	clsRoomName VARCHAR(20) NOT NULL, /* 강의실명 */
	clsRoomPpl NUMBER NOT NULL /* 강의실인원 */
);

CREATE UNIQUE INDEX PK_clsRoom
	ON clsRoom (
		clsRoomSeq ASC
	);

ALTER TABLE clsRoom
	ADD
		CONSTRAINT PK_clsRoom
		PRIMARY KEY (
			clsRoomSeq
		);



/* 과정 */
CREATE TABLE Course (
	courseSeq NUMBER NOT NULL, /* 과정번호 */
	courseName VARCHAR2(1000) NOT NULL /* 과정명 */
);

CREATE UNIQUE INDEX PK_Course
	ON Course (
		courseSeq ASC
	);

ALTER TABLE Course
	ADD
		CONSTRAINT PK_Course
		PRIMARY KEY (
			courseSeq
		);


/* 교육생 */
CREATE TABLE student (
	studentSeq NUMBER NOT NULL, /* 교육생번호 */
	studentName VARCHAR2(50), /* 이름 */
	studentPw NUMBER, /* 주민번호뒷자리 */
	studentTel VARCHAR2(30), /* 전화번호 */
	studentDate DATE DEFAULT sysdate /* 등록일 */
);

CREATE UNIQUE INDEX PK_student
	ON student (
		studentSeq ASC
	);

ALTER TABLE student
	ADD
		CONSTRAINT PK_student
		PRIMARY KEY (
			studentSeq
		);
        
        


/* 교육생상태리스트 */
CREATE TABLE stStatus (
	stStatusSeq NUMBER NOT NULL, /* 교육생상태리스트번호 */
	studentSeq NUMBER NOT NULL, /* 교육생번호 */
	status VARCHAR2(50), /* 상태(수료,중도탈락) */
	stStatusDate DATE /* 날짜(수료,중도탈락) */
);



CREATE UNIQUE INDEX PK_stStatus
	ON stStatus (
		stStatusSeq ASC
	);

ALTER TABLE stStatus
	ADD
		CONSTRAINT PK_stStatus
		PRIMARY KEY (
			stStatusSeq
		);

ALTER TABLE stStatus
	ADD
		CONSTRAINT FK_student_TO_stStatus
		FOREIGN KEY (
			studentSeq
		)
		REFERENCES student (
			studentSeq
		);
        


/* 과목성적 */
CREATE TABLE score (
	scoreSeq NUMBER NOT NULL, /* 과목성적번호 */
	studentSeq NUMBER NOT NULL, /* 교육생번호 */
	subjectSeq NUMBER NOT NULL, /* 과목번호 */
	writingScore NUMBER, /* 필기점수 */
	realScore NUMBER, /* 실기점수 */
	attendanceScore NUMBER, /* 출석점수 */
	totalScore NUMBER /* 총점수 */
);



CREATE UNIQUE INDEX PK_score
	ON score (
		scoreSeq ASC
	);

ALTER TABLE score
	ADD
		CONSTRAINT PK_score
		PRIMARY KEY (
			scoreSeq
		);

ALTER TABLE score
	ADD
		CONSTRAINT FK_student_TO_score
		FOREIGN KEY (
			studentSeq
		)
		REFERENCES student (
			studentSeq
		);

ALTER TABLE score
	ADD
		CONSTRAINT FK_subject_TO_score
		FOREIGN KEY (
			subjectSeq
		)
		REFERENCES subject (
			subjectSeq
		);
        

/* 지원금 */
CREATE TABLE money (
	moneySeq NUMBER NOT NULL, /* 지원금번호 */
	studentSeq NUMBER NOT NULL, /* 교육생번호 */
	moneyMonth DATE, /* 월 */
	receivedMoney NUMBER /* 지원금 */
);


CREATE UNIQUE INDEX PK_money
	ON money (
		moneySeq ASC
	);

ALTER TABLE money
	ADD
		CONSTRAINT PK_money
		PRIMARY KEY (
			moneySeq
		);

ALTER TABLE money
	ADD
		CONSTRAINT FK_student_TO_money
		FOREIGN KEY (
			studentSeq
		)
		REFERENCES student (
			studentSeq
		);
        

/* 시험정보 */
CREATE TABLE test (
	testSeq NUMBER NOT NULL, /* 시험정보번호 */
	subjectSeq NUMBER NOT NULL, /* 과목번호 */
	teacherSeq NUMBER NOT NULL, /* 교사번호 */
	testType VARCHAR2(10), /* 시험종류(필기,실기) */
	testContext VARCHAR2(3000), /* 시험문제 */
	testDate DATE /* 날짜 */
);

CREATE UNIQUE INDEX PK_test
	ON test (
		testSeq ASC
	);

ALTER TABLE test
	ADD
		CONSTRAINT PK_test
		PRIMARY KEY (
			testSeq
		);

ALTER TABLE test
	ADD
		CONSTRAINT FK_teacher_TO_test
		FOREIGN KEY (
			teacherSeq
		)
		REFERENCES teacher (
			teacherSeq
		);

ALTER TABLE test
	ADD
		CONSTRAINT FK_subject_TO_test
		FOREIGN KEY (
			subjectSeq
		)
		REFERENCES subject (
			subjectSeq
		);
        

/* 개설과정 */
CREATE TABLE process (
	processSeq NUMBER NOT NULL, /* 개설과정번호 */
	courseSeq NUMBER NOT NULL, /* 과정번호 */
	clsRoomSeq NUMBER NOT NULL, /* 강의실번호 */
	teacherSeq NUMBER NOT NULL, /* 교사번호 */
	processSDate DATE, /* 과정시작날짜 */
	processEDate DATE, /* 과정종료날짜 */
	processCount NUMBER /* 수강정원 */
);


CREATE UNIQUE INDEX PK_process
	ON process (
		processSeq ASC
	);

ALTER TABLE process
	ADD
		CONSTRAINT PK_process
		PRIMARY KEY (
			processSeq
		);

ALTER TABLE process
	ADD
		CONSTRAINT FK_Course_TO_process
		FOREIGN KEY (
			courseSeq
		)
		REFERENCES Course (
			courseSeq
		);

ALTER TABLE process
	ADD
		CONSTRAINT FK_clsRoom_TO_process
		FOREIGN KEY (
			clsRoomSeq
		)
		REFERENCES clsRoom (
			clsRoomSeq
		);

ALTER TABLE process
	ADD
		CONSTRAINT FK_teacher_TO_process
		FOREIGN KEY (
			teacherSeq
		)
		REFERENCES teacher (
			teacherSeq
		);
        



--

        


/* 개설과정과목 */
CREATE TABLE prcSubject (
	prcSubjectSeq NUMBER NOT NULL, /* 개설과정과목번호 */
	processSeq NUMBER NOT NULL, /* 개설과정번호 */
	subjectSeq NUMBER NOT NULL, /* 과목번호 */
	prcSubjectSDate DATE, /* 과목시작날짜 */
	prcSubjectEDate DATE /* 과목종료날짜 */
);



CREATE UNIQUE INDEX PK_prcSubject
	ON prcSubject (
		prcSubjectSeq ASC
	);

ALTER TABLE prcSubject
	ADD
		CONSTRAINT PK_prcSubject
		PRIMARY KEY (
			prcSubjectSeq
		);

ALTER TABLE prcSubject
	ADD
		CONSTRAINT FK_process_TO_prcSubject
		FOREIGN KEY (
			processSeq
		)
		REFERENCES process (
			processSeq
		);

ALTER TABLE prcSubject
	ADD
		CONSTRAINT FK_subject_TO_prcSubject
		FOREIGN KEY (
			subjectSeq
		)
		REFERENCES subject (
			subjectSeq
		);
        


/* 과목배점 */
CREATE TABLE scoreAllot (
	scoreAllotSeq NUMBER NOT NULL, /* 과목배점번호 */
	prcSubjectSeq NUMBER NOT NULL, /* 개설과정과목번호 */
	teacherSeq NUMBER NOT NULL, /* 교사번호 */
	attendAllot NUMBER, /* 출석배점 */
	writingAllot NUMBER, /* 필기배점 */
	realAllot NUMBER /* 실기배점 */
);


CREATE UNIQUE INDEX PK_scoreAllot
	ON scoreAllot (
		scoreAllotSeq ASC
	);

ALTER TABLE scoreAllot
	ADD
		CONSTRAINT PK_scoreAllot
		PRIMARY KEY (
			scoreAllotSeq
		);

ALTER TABLE scoreAllot
	ADD
		CONSTRAINT FK_teacher_TO_scoreAllot
		FOREIGN KEY (
			teacherSeq
		)
		REFERENCES teacher (
			teacherSeq
		);

ALTER TABLE scoreAllot
	ADD
		CONSTRAINT FK_prcSubject_TO_scoreAllot
		FOREIGN KEY (
			prcSubjectSeq
		)
		REFERENCES prcSubject (
			prcSubjectSeq
		);
        
        
/* 교육생수강정보 */
CREATE TABLE studentCls (
	studentClsSeq NUMBER NOT NULL, /* 교육생수강정보번호  */
	studentSeq NUMBER NOT NULL, /* 교육생번호 */
	processSeq NUMBER NOT NULL /* 개설과정번호 */
);


CREATE UNIQUE INDEX PK_studentCls
	ON studentCls (
		studentClsSeq ASC
	);

ALTER TABLE studentCls
	ADD
		CONSTRAINT PK_studentCls
		PRIMARY KEY (
			studentClsSeq
		);
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
ALTER TABLE studentCls
	ADD
		CONSTRAINT FK_student_TO_studentCls
		FOREIGN KEY (
			studentSeq
		)
		REFERENCES student (
			studentSeq
		);
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
ALTER TABLE studentCls
	ADD
		CONSTRAINT FK_process_TO_studentCls
		FOREIGN KEY (
			processSeq
		)
		REFERENCES process (
			processSeq
		);        
        
--=========================================================================================================================================================        
--=========================================================================================================================================================
-- 나중에 만들 기능관련 테이블 
--=========================================================================================================================================================        
--=========================================================================================================================================================


/* 교사평가 */
CREATE TABLE tGrade (
	tGradeSeq NUMBER NOT NULL, /* 교사평가번호 */
	teacherSeq NUMBER NOT NULL, /* 교사번호 */
	studentSeq NUMBER NOT NULL, /* 교육생번호 */
	tGradeScore NUMBER, /* 점수(1~10) */
	tGradeRw VARCHAR2(1000) /* 한줄평 */
);

CREATE UNIQUE INDEX PK_tGrade
	ON tGrade (
		tGradeSeq ASC
	);

ALTER TABLE tGrade
	ADD
		CONSTRAINT PK_tGrade
		PRIMARY KEY (
			tGradeSeq
		);

ALTER TABLE tGrade
	ADD
		CONSTRAINT FK_teacher_TO_tGrade
		FOREIGN KEY (
			teacherSeq
		)
		REFERENCES teacher (
			teacherSeq
		);

ALTER TABLE tGrade
	ADD
		CONSTRAINT FK_student_TO_tGrade
		FOREIGN KEY (
			studentSeq
		)
		REFERENCES student (
			studentSeq
		);
        

/* 과정평가 */
CREATE TABLE cGrade (
	cGradeSeq NUMBER NOT NULL, /* 과정평가번호 */
	processSeq NUMBER NOT NULL, /* 개설과정번호 */
	studentSeq NUMBER NOT NULL, /* 교육생번호 */
	cGradeScore NUMBER, /* 점수(1~10) */
	cGradeRw VARCHAR2(1000) /* 한줄평 */
);


CREATE UNIQUE INDEX PK_cGrade
	ON cGrade (
		cGradeSeq ASC
	);

ALTER TABLE cGrade
	ADD
		CONSTRAINT PK_cGrade
		PRIMARY KEY (
			cGradeSeq
		);

ALTER TABLE cGrade
	ADD
		CONSTRAINT FK_student_TO_cGrade
		FOREIGN KEY (
			studentSeq
		)
		REFERENCES student (
			studentSeq
		);

ALTER TABLE cGrade
	ADD
		CONSTRAINT FK_process_TO_cGrade
		FOREIGN KEY (
			processSeq
		)
		REFERENCES process (
			processSeq
		);


/* 교육생평가 */
CREATE TABLE sGrade (
	sGradeSeq NUMBER NOT NULL, /* 교육생평가번호 */
	teacherSeq NUMBER NOT NULL, /* 교사번호 */
	studentSeq NUMBER NOT NULL, /* 교육생번호 */
	sGradeScore NUMBER, /* 학생평균점수 */
	sGradeRw VARCHAR2(1000) /* 한줄평 */
);


CREATE UNIQUE INDEX PK_sGrade
	ON sGrade (
		sGradeSeq ASC
	);

ALTER TABLE sGrade
	ADD
		CONSTRAINT PK_sGrade
		PRIMARY KEY (
			sGradeSeq
		);

ALTER TABLE sGrade
	ADD
		CONSTRAINT FK_student_TO_sGrade
		FOREIGN KEY (
			studentSeq
		)
		REFERENCES student (
			studentSeq
		);

ALTER TABLE sGrade
	ADD
		CONSTRAINT FK_teacher_TO_sGrade
		FOREIGN KEY (
			teacherSeq
		)
		REFERENCES teacher (
			teacherSeq
		);
        

/* 자격증 */
CREATE TABLE crtf (
	crtfSeq NUMBER NOT NULL, /* 자격증번호 */
	crtfName VARCHAR2(200) NOT NULL, /* 자격증명 */
	crtfService VARCHAR2(200) /* 인증기관 */
);



CREATE UNIQUE INDEX PK_crtf
	ON crtf (
		crtfSeq ASC
	);

ALTER TABLE crtf
	ADD
		CONSTRAINT PK_crtf
		PRIMARY KEY (
			crtfSeq
		);
        


/* 교육생자격증 */
CREATE TABLE studentCrtf (
	studentCrtfSeq NUMBER NOT NULL, /* 교육생자격증번호 */
	crtfSeq NUMBER NOT NULL, /* 자격증번호 */
	studentSeq NUMBER NOT NULL, /* 교육생번호 */
	studentCrtfDate DATE /* 취득일 */
);



CREATE UNIQUE INDEX PK_studentCrtf
	ON studentCrtf (
		studentCrtfSeq ASC
	);

ALTER TABLE studentCrtf
	ADD
		CONSTRAINT PK_studentCrtf
		PRIMARY KEY (
			studentCrtfSeq
		);

ALTER TABLE studentCrtf
	ADD
		CONSTRAINT FK_crtf_TO_studentCrtf
		FOREIGN KEY (
			crtfSeq
		)
		REFERENCES crtf (
			crtfSeq
		);

ALTER TABLE studentCrtf
	ADD
		CONSTRAINT FK_student_TO_studentCrtf
		FOREIGN KEY (
			studentSeq
		)
		REFERENCES student (
			studentSeq
		);
        


/* 주요기술스택 */
CREATE TABLE tech (
	techSeq NUMBER NOT NULL, /* 주요기술스택번호 */
	techName VARCHAR2(200) /* 기술명(자바.파이썬,AWS등) */
);


CREATE UNIQUE INDEX PK_tech
	ON tech (
		techSeq ASC
	);

ALTER TABLE tech
	ADD
		CONSTRAINT PK_tech
		PRIMARY KEY (
			techSeq
		);
        


/* 팀 */
CREATE TABLE team (
	teamSeq NUMBER NOT NULL, /* 팀번호 */
	testSeq NUMBER NOT NULL, /* 시험정보번호 */
	studentSeq NUMBER NOT NULL, /* 교육생번호 */
	teamName VARCHAR2(200) /* 팀이름 */
);


CREATE UNIQUE INDEX PK_team
	ON team (
		teamSeq ASC
	);

ALTER TABLE team
	ADD
		CONSTRAINT PK_team
		PRIMARY KEY (
			teamSeq
		);

ALTER TABLE team
	ADD
		CONSTRAINT FK_test_TO_team
		FOREIGN KEY (
			testSeq
		)
		REFERENCES test (
			testSeq
		);

ALTER TABLE team
	ADD
		CONSTRAINT FK_student_TO_team
		FOREIGN KEY (
			studentSeq
		)
		REFERENCES student (
			studentSeq
		);

-- 기업
CREATE TABLE enter (
    enterSeq NUMBER NOT NULL, --기업번호 /
    crtfSeq NUMBER NOT NULL, --/ 자격증번호 /
    techSeq NUMBER NOT NULL, --/ 주요기술스택번호 /
    enterName VARCHAR2(100), --/ 기업명 /
    enterBuseo VARCHAR2(300), --/ 부서 /
    enterLocation VARCHAR2(100),-- / 위치 /
    enterSalary NUMBER --/ 초봉
);


CREATE UNIQUE INDEX PK_enter
    ON enter (
        enterSeq ASC
    );

ALTER TABLE enter
    ADD
        CONSTRAINT PK_enter
        PRIMARY KEY (
            enterSeq
        );

ALTER TABLE enter
    ADD
        CONSTRAINT FK_tech_TO_enter
        FOREIGN KEY (
            techSeq
        )
        REFERENCES tech (
            techSeq
        );

ALTER TABLE enter
    ADD
        CONSTRAINT FK_crtf_TO_enter
        FOREIGN KEY (
            crtfSeq
        )
        REFERENCES crtf (
            crtfSeq
        );


-- 프로젝트


/* 프로젝트 */
CREATE TABLE project (
	projectSeq NUMBER NOT NULL, /* 프로젝트번호 */
	teamSeq NUMBER NOT NULL, /* 팀번호 */
	techSeq NUMBER NOT NULL, /* 주요기술스택번호 */
	projectName VARCHAR2(300), /* 프로젝트명 */
	projectDate DATE, /* 수행기간 */
	projectContent VARCHAR2(2000) /* 프로젝트설명 */
);


CREATE UNIQUE INDEX PK_project
	ON project (
		projectSeq ASC
	);

ALTER TABLE project
	ADD
		CONSTRAINT PK_project
		PRIMARY KEY (
			projectSeq
		);

ALTER TABLE project
	ADD
		CONSTRAINT FK_team_TO_project
		FOREIGN KEY (
			teamSeq
		)
		REFERENCES team (
			teamSeq
		);

ALTER TABLE project
	ADD
		CONSTRAINT FK_tech_TO_project
		FOREIGN KEY (
			techSeq
		)
		REFERENCES tech (
			techSeq
		);
        
        
/* 츨결 */
CREATE TABLE attendance (
	attendanceSeq NUMBER NOT NULL, /* 출결번호 */
	studentSeq NUMBER NOT NULL, /* 교육생번호 */
    processSeq NUMBER NOT NULL, /* 과정번호 */
	attendanceDate DATE, /* 날짜 */
	attendanceStime DATE, /* 등원시간 */
	attendanceETime DATE, /* 하원시간 */
	attendanceST VARCHAR2(20) /* 상태(정상,지각,조퇴,외출,병가,기타) */
);

desc attendance;

ALTER TABLE attendance
	ADD
		CONSTRAINT PK_attendance
		PRIMARY KEY (
			attendanceSeq
		);
        
ALTER TABLE attendance
	ADD
		CONSTRAINT FK_process_TO_attendance
		FOREIGN KEY (
			processSeq
		)
		REFERENCES process (
			processSeq
		);

ALTER TABLE attendance
	ADD
		CONSTRAINT FK_student_TO_attendance
		FOREIGN KEY (
			studentSeq
		)
		REFERENCES student (
			studentSeq
		);