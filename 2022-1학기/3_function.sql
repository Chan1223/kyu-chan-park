---- 3장
--- 문자열 함수
-- LOWER : 소문자로, INITCAP : initial 대문자, UPPER : 대문자
SELECT last_name, LOWER(last_name), INITCAP(last_name), UPPER(last_name)
FROM employees;
WHERE LOWER(last_name) = 'austin';


-- length : 글자수 출력, lengthb : 글자 총 바이트 수 입력, INSTR : 찾는 문자의 위치 반환(없을 경우 0 출력)
SELECT first_name, LENGTH(first_name), INSTR(first_name, 'a')
FROM employees;

-- substr : 부분 문자열 출력, subtstrb : 부분 문자열 바이트 출력, concat : ||와 같은 기능, 문자열 연결
SELECT first_name, SUBSTR(first_name, 1, 3), CONCAT(first_name, last_name)
FROM employees;

-- lpad, rpad : padding 기능, 모자란 글자를 좌/우부터 채우게 해줌 
SELECT 
    RPAD(first_name, 10, '=') AS name,
    LPAD(salary, 10, '*') AS sal
FROM employees;

-- ltrim, rtrim : 좌 / 우 공백 제거, 특정 문자열을 끊기지 않을 때까지 찾아서 제거함
SELECT LTRIM('JavaSpecialist', 'Jav') FROM dual;
SELECT LTRIM('       JavaSpecialist') FROM dual;
SELECT RTRIM('JavaSpecialist      ') FROM dual;

-- replace : 특정 글자를 다른 글자로 대체, translate : 2번인자의 문자열을 3번으로 변경)
SELECT REPLACE('JavaSpecialist', 'Java', 'Bigdata') FROM dual;
SELECT REPLACE('Java Specialist', ' ', '') FROM dual;
SELECT TRANSLATE('javaspecialist', 'abdert', 'ertabd') FROM dual;

--- 중간문제
-- EMPLOYEES 테이블에서 JOB_ID가 it_prog인 사원의 이름과 급여를 출력하세요.
-- 1) 비교하기 위한 값은 소문자로 입력해야 합니다.
--   (힌트 : LOWER 함수 이용)
-- 2)  이름은 앞  3문자까지 출력하고 나머지는 *로  출력합니다.  이  열의  열  별칭은 name입니다. 
--   (힌트 :  RPAD 함수와 SUBSTR 함수 또는 SUBSTR 함수와 LENGTH 함수 이용)
-- 3) 급여는 전체 10자리로 출력하되 나머지 자리는 *로  출력합니다.  이  열의 열  별칭은 salary입니다.
--   (힌트 :  LPAD 함수 이용)
SELECT RPAD(SUBSTR(first_name, 1, 3), 10, '*') AS name, LPAD(salary, 10, '*') AS salary
FROM employees
WHERE LOWER(job_id) = 'it_prog'; 

---- 정규표현식
-- 테이블 생성
CREATE TABLE test_regexp(col1 VARCHAR2(10));
-- 데이터 삽입
INSERT INTO test_regexp VALUES('ABCDE01234');
INSERT INTO test_regexp VALUES('01234ABCDE');
INSERT INTO test_regexp VALUES('abcde01234');
INSERT INTO test_regexp VALUES('01234abcde');
INSERT INTO test_regexp VALUES('1-234-5678');
INSERT INTO test_regexp VALUES('234-567890');

DROP TABLE test_regexp;

SELECT *
FROM test_regexp
WHERE REGEXP_LIKE(col1, '[0-9][a-z]');

SELECT *
FROM test_regexp
WHERE REGEXP_LIKE(col1, '[0-9]{3}-[0-9]{4}$');

-- REGEXP_INSTR
INSERT INTO test_regexp VALUES('@!=)(9&%$#');
INSERT INTO test_regexp VALUES('자바3');

SELECT col1,
    REGEXP_INSTR(col1, '[0-9]') AS data1,
    REGEXP_INSTR(col1, '%') AS data2
FROM test_regexp;

-- REGEXP_SUBSTR
SELECT col1,
    REGEXP_SUBSTR(col1, '[C-Z]+')
FROM test_regexp;

-- REGEXP_REPLACE
SELECT col1, REGEXP_REPLACE(col1, '[0-2]+', '*')
FROM test_regexp;

---중간 문제
-- 1. EMPLOYEES 테이블의 PHONE_NUMBER 열에서 XXX.XXX.XXXX형식 전화번호를 출력합니다.
SELECT phone_number
FROM employees
WHERE REGEXP_LIKE(phone_number,'[0-9]{3}.[0-9]{3}.[0-9]{4}$') ;

-- 2. XXX.XXX.XXXX형식  전화번호를 갖는  사원의  이름과 전화번호를 출력하되 전화번호 맨 뒤 4자리를 *로  마스킹해서 출력하라.  
--    그리고 맨 뒤 4자리만 별도로 출력하라.
SELECT first_name, 
    REGEXP_REPLACE(phone_number, '[0-9]{4}', '****') AS masking, 
    REGEXP_SUBSTR(phone_number, '[0-9]{4}$') AS last_numb
FROM employees
WHERE REGEXP_LIKE(phone_number, '[0-9]{3}.[0-9]{3}.[0-9]{4}');

--- 숫자함수
-- 반올림(ROUND)
SELECT ROUND(45.932, 2), ROUND(45.923, 0), ROUND(45.923, -1)
FROM dual;

-- 내림(TRUNC)
SELECT TRUNC(45.932, 2), TRUNC(45.923, 0), TRUNC(45.923, -1)
FROM dual; 


--- 날짜 함수
-- SYSDATE
SELECT SYSDATE FROM dual;
-- SYSTIMESTAMP
SELECT SYSTIMESTAMP FROM dual;

-- 날짜 연산
SELECT first_name, ROUND((SYSDATE - hire_date)/7, 2) as "weeks"
FROM employees
WHERE department_id = 50;

-- MONTHS_BETWEEN
SELECT first_name, SYSDATE, hire_date,
        MONTHS_BETWEEN(SYSDATE, hire_date) AS "work_month"
FROM employees
WHERE first_name='Diana';

-- ADD_MONTHS
SELECT first_name, hire_date, ADD_MONTHS(hire_date, 100)
FROM employees
WHERE first_name = 'Diana';

-- NEXT_DAY
SELECT SYSDATE, NEXT_DAY(SYSDATE, '월')
FROM dual;

-- LAST_DAY
SELECT SYSDATE, LAST_DAY(SYSDATE)
FROM dual;

-- ROUND, TRUNC
SELECT TRUNC(SYSDATE, 'Month')
FROM dual;

SELECT TRUNC(SYSDATE, 'Year')
FROM dual;

SELECT ROUND(TO_DATE('17/02/15'), 'Month')
FROM dual;

SELECT TRUNC(TO_DATE('17/03/06'), 'Month')
FROM dual;

--- 변환 함수
SELECT first_name, TO_CHAR(hire_date, 'MM/YY') AS hiredmonth
FROM employees;

SELECT first_name,
        TO_CHAR(hire_date, 'YYYY"년" MM"월" DD"일"') as hiredate
FROM employees;

SELECT first_name,
        TO_CHAR(hire_date, 
                'fmDdspth "of" Month YYYY fmHH:MI:SS AM',
                'NLS_DATE_LANGUAGE = english') AS hiredate
FROM employees;

SELECT first_name, last_name, TO_CHAR(salary, '$999,999') AS salary
FROM employees
WHERE first_name = 'David';

-- 자리가 적을 때 ### 으로 표시됨
SELECT TO_CHAR(2000000, '$999,999') AS salary
FROM dual;

SELECT first_name, last_name, salary*0.123456 SALARY1,
        TO_CHAR(salary*0.123456, '$999,999.99') salary2
FROM employees
WHERE first_name = 'David';

--- TO_NUMBER
-- 에러 발생(문자열로 인식되기 때문)
SELECT '$5,500.00' - 4000 FROM dual;
-- 제대로 된 코드
SELECT to_number('$5,500.00', '$99,999.99') - 4000 
FROM dual;

--- TO_DATE
SELECT first_name, hire_date
FROM employees
WHERE hire_date=TO_DATE('2003/06/17', 'YYYY/MM/DD');

--- NVL(특정 값이 null일 경우 다른 값으로 대체
SELECT first_name,
        salary + salary*NVL(commission_pct, 0) AS annual
FROM employees;

-- NVL2 : 특정 열이 null 이 아니면 1번 값, null일 경우 2번 값 출력
SELECT first_name,
        NVL2(commission_pct, salary+(salary*commission_pct), salary) ann_sal
FROm employees;

--- COALESCE
SELECT first_name,
        COALESCE(salary + (salary* commission_pct), salary) AS ann_sal
FROM employees;

-- LNNVL : 결과가 TRUE 면 FALSE 반환, 결과가 FALSE / UNKNOWN(NULL)이면 TRUE 반환
SELECT first_name, COALESCE(salary*commission_pct, 0) AS bonus
FROM employees
WHERE LNNVL(salary*commission_pct >= 650);
--- LNNVL이기 때문에 650 아래의 값들만 보여주고 나머지는 COALESCE로 인해 0으로 출력.

-- DECODE: 특정 열에 해당하면 해당 값을 넣어줌
SELECT job_id, salary,
        DECODE(job_id, 'IT_PROG', salary*1.1,
                       'FI_MGR', salary*1.15,
                       'FI_ACCOUNT', salary*1.2,
                       salary)
        AS Salary
FROM employees;

-- CASE THEN: if ~ else 와 유사함
SELECT job_id, salary,
CASE WHEN(job_id = 'IT_PROG') THEN salary*1.1
     WHEN(job_id = 'FI_MGR') THEN salary*1.15
     WHEN(job_id = 'FI_ACCOUNT') THEN salary*1.2
     ELSE salary
END AS revised_salary
FROM employees;

--- 중간문제
-- 1~12월의 마지막 날을 출력하라
SELECT 
    TO_CHAR(LAST_DAY(TO_DATE('01', 'MM')), 'DD') AS "01",
    TO_CHAR(LAST_DAY(TO_DATE('02', 'MM')), 'DD') AS "02",
    TO_CHAR(LAST_DAY(TO_DATE('03', 'MM')), 'DD') AS "03",
    TO_CHAR(LAST_DAY(TO_DATE('04', 'MM')), 'DD') AS "04",
    TO_CHAR(LAST_DAY(TO_DATE('05', 'MM')), 'DD') AS "05",
    TO_CHAR(LAST_DAY(TO_DATE('06', 'MM')), 'DD') AS "06",
    TO_CHAR(LAST_DAY(TO_DATE('07', 'MM')), 'DD') AS "07",
    TO_CHAR(LAST_DAY(TO_DATE('08', 'MM')), 'DD') AS "08",
    TO_CHAR(LAST_DAY(TO_DATE('09', 'MM')), 'DD') AS "09",
    TO_CHAR(LAST_DAY(TO_DATE('10', 'MM')), 'DD') AS "10",
    TO_CHAR(LAST_DAY(TO_DATE('11', 'MM')), 'DD') AS "11",
    TO_CHAR(LAST_DAY(TO_DATE('12', 'MM')), 'DD') AS "12"
FROM dual;

--- 중첩함수 : UNION, UNION ALL(중복된 정보 출력), INTERSECTION, MINUS
SELECT employee_id, first_name
FROM employees
WHERE hire_date Like '04%'
UNION ALL
SELECT employee_id, first_name
FROM employees
WHERE department_id = 20;

----- 연습문제 -----
-- 1. 이메일에 lee를 포함하는 사원의 모든 정보를 출력하세요
SELECT *
FROM employees
WHERE LOWER(email) LIKE '%lee%';

-- 2. 매니저 아이디가 103인 사원들의 이름과 급여, 직무 아이디 출력.
SELECT first_name, salary, job_id
FROM employees
WHERE manager_id = 103;

-- 3. 80번 부서에 근무하면서 직무가 SA_MAN인 사원의 정보와 20번 부서에 근무하면서 매니저 아이디가 100인사원의 정보를 출력하세요.  
--    쿼리문 하나로 출력해야 합니다.
SELECT *
FROM employees
WHERE (department_id = 80 AND job_id = 'SA_MAN') or (department_id = 20 AND manager_id = 100);

-- 4. 모든 사원의 전화번호를 ###-###-#### 형식으로 출력
SELECT TRANSLATE(phone_number, '.', '-')
FROM employees
WHERE REGEXP_LIKE(phone_number, '[0-9]{3}.[0-9]{3}.[0-9]{4}');

-- 5. 직무가 IT_PROG인  사원들 중에서 급여가 5000 이상인 사원들의 
-- 이름(Full Name), 급여  지급액,  입사일(2005-02-15형식),  근무한 일수를 출력하세요.  
-- 이름순으로 정렬하며,이름은 최대 20자리,  남는 자리는 *로 채우고 
-- 급여 지급액은 소수점 2자리를 포함한 최대 8자리,  $표시,  남는 자리는 0으로 채워 출력하세요.
SELECT RPAD(first_name || ' ' || last_name, 20, '*') AS "Full Name", 
       TO_CHAR(salary, '$099,999.99') AS salary, 
       TO_CHAR(hire_date, 'YYYY-MM-DD') AS hire_date,
       ROUND(SYSDATE - hire_Date, 0) AS "근무일수"
FROM employees
WHERE job_id = 'IT_PROG' AND salary >= 5000
ORDER BY "Full Name";

-- 6. 30번  부서 사원의 이름(full name)과  급여,  입사일,  현재까지 근무 개월 수를 출력하세요.  
--    이름은 최대 20자로 출력하고 이름 오른쪽에 남는 공백을 *로  출력하세요.  
--    급여는 상여금을 포함하고 소수점 2자리를 포함한 총  8자리로 출력하고 
--    남은 자리는 0으로 채우며 세자리마다 ,(콤마)  구분기호를 포함하고,  금액 앞에 $를  포함하도록 출력하세요. 
--    입사일은 2005년03월15일  형식으로 출력하세요.  
--    근무 개월 수는 소수점 이하는 버리고 출력하세요.  급여가 큰 사원부터 작은 순서로 출력하세요.
SELECT RPAD(first_name || ' ' || last_name, 20, '*') AS fullname,
       TO_CHAR(COALESCE(salary * commission_pct, salary), '$099,999.00') AS SAL,
       TO_CHAR(hire_date, 'YYYY"년"MM"월"DD"일"') AS hire_Date,
       TRUNC((SYSDATE - hire_date) / 30) AS "근무개월 수"
FROM employees
WHERE department_id = 30
ORDER BY SAL DESC;

-- 7. 80번  부서에 근무하면서 salary가  10000보다 큰  사원들의  이름과  
--    급여  지급액(salary  + salary *  commission_pct)을  출력하세요.  
--    이름은  Full  Name으로 출력하며 17자리로 출력하세요.  남은 자리는 *로  채우세요.  
--    급여는 소수점  2자리를 포함한 총7자리로 출력하며,  남은 자리는 0으로  채우세요.  
--    금액  앞에  $  표시를 하며 급여 순으로 정렬하세요.
SELECT RPAD(first_name || ' ' || last_name, 17, '*') AS fullname,
       TO_CHAR(salary + salary*commission_pct, '$09,999.99') AS sal
FROM employees
WHERE department_id =80 and salary > 10000
ORDER BY sal DESC;


-- 8. 60번부서 사원의 이름과 현재 일자를 기준으로 현재까지 근무한 근무년차를 5년차,  10년차,  15년차로 표시하세요.  
--    5년~  9년  근무한  사원은 5년차로 표시합니다.  나머지는 기타로 표시합니다.  근무년차는 근무개월수/12로 계산합니다.
-- DECODE 사용한 경우
SELECT first_name, 
       DECODE(TRUNC((MONTHS_BETWEEN(SYSDATE, hire_date) / 12) / 5),
               1, '5년차',
               2, '10년차',
               3, '15년차', 
               '기타') AS "근무년차"
FROM employees
WHERE department_id = 60;

-- CASE WHEN ELSE 사용하는 경우
SELECT first_name AS 이름,   
CASE WHEN TRUNC(TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date))/12) < 5 THEN '기타'
     WHEN TRUNC(TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date))/12) < 10 THEN '5년차'
     WHEN TRUNC(TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date))/12) < 15 THEN '10년차'
     ELSE '15년차'
END AS 근무년수
FROM employees
WHERE department_id = 60;

-- 9.Lex가 입사한지 1000일째 되는 날은?
SELECT hire_date+ 1000
FROM employees
WHERE first_name Like 'Lex';

-- 10.5월에 입사한 사원의 이름과 입사일을 출력하세요.
SELECT first_name, hire_date
FROM employees
WHERE REGEXP_LIKE(hire_date, '/05/');

-- 11. 사원목록 중 이름과 급여를 출력하세요.
-- 조건1) 입사한 연도를 출력한 열을 만드세요. 이 열의 이름은 ‘year’이고,  “(입사년도)년 입사”형식으로 출력하세요.
-- 조건2) 입사한 요일을 출력한 열을 만드세요. 이 열의 이름은 ‘day’이고,  “요일”형식으로 출력하세요.
-- 조건3) 입사일이 2010년 이후인 사원은 급여를 10%, 2005년 이후인 사원은 급여를 5%를 인상하세요.  
--       이 열의 이름은 ‘INCREASING_SALARY’입니다.
-- 조건4) INCREASING_SALARY 열의 형식은 앞에 ‘$’기호가 붙고, 세 자리마다 콤마(,)를 넣어주세요.
SELECT first_name, 
       CASE WHEN TO_NUMBER(TO_CHAR(hire_date, 'YY')) BETWEEN 2005 and 2010 
                THEN TO_CHAR(salary*1.05, '$999,999')
            WHEN TO_NUMBER(TO_CHAR(hire_date, 'YY')) > 2010 
                THEN TO_CHAR(salary*1.1, '$999,999')
       ELSE TO_CHAR(salary, '$999,999')
       END AS increasing_salary,
       TO_CHAR(hire_date, 'YYYY"년 입사"') AS year,
       TO_CHAR(hire_date, 'DAY') AS day
FROM employees;

-- 12. 사원의 이름,  급여,  입사년도 ,  인상된 급여를 출력하세요.
-- 조건1) 입사한 연도를 출력하세요.  이 열의 이름은 ‘year’이고,  “(입사년도)년 입사”형식으로 출력하세요.
-- 조건2) 입사일이 2010년인 사원은 급여를 10%, 2005년인 사원은 급여를 5%를  인상하세요.  
--       이 열의 이름은 ‘INCREASING_SALARY2’입니다.
SELECT first_name,
       salary,
       TO_CHAR(hire_date, 'YYYY"년 입사"') AS year,
       CASE WHEN TO_CHAR(hire_date, 'YYYY') = 2010 THEN salary * 1.1
            WHEN TO_CHAR(hire_date, 'YYYY') = 2005 THEN salary * 1.05
       ELSE salary
       END AS INCREASING_Salary2
FROM employees;

-- 13. 위치목록 중 주(state) 열에 값이 null이라면 국가 아이디를 출력하세요.
SELECT COUNTRY_ID, NVL(state_province, country_id ) AS STATE
FROM locations;