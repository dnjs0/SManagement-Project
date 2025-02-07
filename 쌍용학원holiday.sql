-- holiday insert
select * from holiday;
delete from holiday;

-- 공휴일 데이터 삽입
INSERT INTO Holiday (holidaySeq, holidayDate, holidayName) VALUES (1, DATE '2024-08-15', '광복절');
INSERT INTO Holiday (holidaySeq, holidayDate, holidayName) VALUES (2, DATE '2024-09-17', '추석 연휴');
INSERT INTO Holiday (holidaySeq, holidayDate, holidayName) VALUES (3, DATE '2024-09-18', '추석');
INSERT INTO Holiday (holidaySeq, holidayDate, holidayName) VALUES (4, DATE '2024-09-19', '추석 연휴');
INSERT INTO Holiday (holidaySeq, holidayDate, holidayName) VALUES (5, DATE '2024-10-03', '개천절');
INSERT INTO Holiday (holidaySeq, holidayDate, holidayName) VALUES (6, DATE '2024-10-09', '한글날');
INSERT INTO Holiday (holidaySeq, holidayDate, holidayName) VALUES (7, DATE '2024-12-25', '성탄절');
INSERT INTO Holiday (holidaySeq, holidayDate, holidayName) VALUES (8, DATE '2025-01-01', '신정');
INSERT INTO Holiday (holidaySeq, holidayDate, holidayName) VALUES (9, DATE '2025-01-27', '설날 연휴');
INSERT INTO Holiday (holidaySeq, holidayDate, holidayName) VALUES (10, DATE '2025-01-28', '설날');
INSERT INTO Holiday (holidaySeq, holidayDate, holidayName) VALUES (11, DATE '2025-01-29', '설날 연휴');
INSERT INTO Holiday (holidaySeq, holidayDate, holidayName) VALUES (12, DATE '2025-03-01', '삼일절');
INSERT INTO Holiday (holidaySeq, holidayDate, holidayName) VALUES (13, DATE '2025-05-05', '어린이날');
INSERT INTO Holiday (holidaySeq, holidayDate, holidayName) VALUES (14, DATE '2025-05-06', '어린이날 대체공휴일');
INSERT INTO Holiday (holidaySeq, holidayDate, holidayName) VALUES (15, DATE '2025-05-08', '석가탄신일');
INSERT INTO Holiday (holidaySeq, holidayDate, holidayName) VALUES (16, DATE '2025-06-06', '현충일');
INSERT INTO Holiday (holidaySeq, holidayDate, holidayName) VALUES (17, DATE '2025-08-15', '광복절');

