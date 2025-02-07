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
