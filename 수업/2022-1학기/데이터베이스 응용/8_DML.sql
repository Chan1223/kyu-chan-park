-- 8장
-- create table
CREATE TABLE emp1 AS SELECT * FROM employees;

SELECT COUNT(*) FROM emp1;


-- create table with WHERE : 데이터는 못가져오지만 구조는 가져와짐
CREATE TABLE emp2 AS SELECT * FROM employees WHERE 1= 2;

SELECT COUNT(*) FROM emp2;

DROP TABLE emp1;

DROP TABLE emp2;


--- insert
DESC departments;
CREATE TABLE depart1 AS SELECT * FROM departments;

INSERT INTO depart1
VALUES (280, 'Data Analytics', null, 1700);
SELECT * FROM depart1;

ROLLBACK;

SELECT * FROM depart1;
DROP TABLE depart1;

-- 다른 테이블로부터 행 복사
CREATE TABLE managers AS
 SELECT employee_id, first_name, job_id, salary, hire_date
 FROM employees
 WHERE 1=2;
    
INSERT INTO managers
    (employee_id, first_name, job_id, salary, hire_date)
    SELECT employee_id, first_name, job_id, salary, hire_date
    FROM employees
    WHERE job_id LIKE '%MAN';
    
select * from managers;
DROP TABLE managers;


-- UPDATE
CREATE TABLE emps AS SELECT * FROM employees;

ALTER TABLE emps
    ADD (CONSTRAINT emps_emp_id_pk PRIMARY KEY (employee_id),
         CONSTRAINT emps_manager_fk FOREIGN KEY (manager_id)
                     REFERENCES emps(employee_id)
);
DROP TABLE emps;
SELECT * FROM emps;

-- 테이블 행 갱신
SELECT employee_id, first_name, salary
FROM emps
WHERE employee_id = 103;

UPDATE emps
SET salary=salary * 1.1
WHERE employee_id = 103;

-- 서브쿼리로 다중 열 갱신
UPDATE emps
SET (job_id, salary, manager_id) =
    (SELECT job_id, salary, manager_id
     FROM emps
     WHERE employee_id = 108)
WHERE employee_id = 109;

--- DELETE
DELETE FROM emps
WHERE employee_id =103;

-- 다른 테이블을 이용한 행 삭제
CREATE TABLE depts AS
    SELECT * FROM departments;
    
DESC depts;

DELETE FROM emps
WHERE department_id=
                    (SELECT department_id
                     FROM depts
                     WHERE department_name = 'Shipping');
-- RETURNING
VARIABLE emp_name VARCHAR2(50);
VARIABLE emp_sal NUMBER;
VARiABLE;

variable emp_name
datatype VARCHAR2(50)

variable emp_sal
dataype NUMBER

DELETE emps
WHERE employee_id =109
RETURNING first_name, salary INTO :emp_name, :emp_sal;

PRINT emp_name;

--- MERGE
CREATE TABLE emps_it AS SELECT * FROM employees WHERE 1=2;

INSERT INTO emps_it
    (employee_id, first_name, last_name, email, hire_date, job_id)
VALUES
    (105, 'David', 'Kim', 'DAVIDKIM', '06/03/04', 'IT_PROG');

-- MERGE
MERGE INTO emps_it a
    USING (SELECT * FROM employees WHERE job_id = 'IT_PROG') b
    ON (a.employee_id = b.employee_id)
WHEN MATCHED THEN
    UPDATE SET
        a.phone_number = b.phone_number,
        a.hire_date = b.hire_date,
        a.job_id = b.job_id,
        a.salary = b.salary,
        a.commission_pct = b.commission_pct,
        a.manager_id = b.manager_id,
        a.department_id = b.department_id
WHEN NOT MATCHED THEN
    INSERT VALUES
        (b.employee_id, b.first_name, b.last_name, b.email,
         b.phone_number, b.hire_date, b.job_id, b.salary,
         b.commission_pct, b.manager_id, b.department_id);
SELECT * fROM emps_it;

-- MULTIPLE INSERT
CREATE TABLE emp2 AS SELECT * FROM employees WHERE 1=2;
CREATE TABLE emp3 AS SELECT * FROM employees WHERE 1=2;

INSERT ALL
    INTO emp2
        VALUES (300, 'Kildong', 'Hong', 'KHONG', '011.624.7902',
          TO_DATE('2015-05-11', 'YYYY-MM-DD'), 'IT_PROG', 6000,
          null, 100, 90)
    INTO emp3
        VALUES (400, 'Kilseo', 'Hong', 'KSHONG', '011.3402.7902',
         TO_DATE('2015-06-20', 'YYYY-MM-DD'), 'IT_PROG', 5500,
         null, 100, 90)
    SELECT * FROM dual;
SELECT * FROM emp2;
SELECT * FROM emp3;

DROP TABLE emp2;


DROP TABLE emp3;

--- condtional insert all
CREATE TABLE emp_10 AS SELECT * FROM employees WHERE 1=2;

CREATE TABLE emp_20 AS SELECT * FROM employees WHERE 1=2;
DROP TABLE emp_10;
DROP TABLE emp_20;


----- 연습문제 -------
-- 1. EMPLOYEES 테이블에 있는  데이터를 열  단위로 나눠  저장하고 싶습니다.  사원번호, 사원이름,
--    급여,  보너스율을  저장하기  위한  구조와  데이터를  갖는  테이블을 EMP_SALARY_INFO이라는 이름으로 생성하세요.
--    그리고 사원번호,  사원이름,  입사일, 부서번호를 저장하기 위한 구조와 데이터를 갖는 테이블을 EMP_HIREDATE_INFO라는 이름으로 생성하세요.
CREATE TABLE EMP_SALARY_INFO AS
    SELECT employee_id, first_name, salary, commission_pct FROM employees where 1=1;

CREATE TABLE emp_hiredate_info AS
    SELECT employee_id, first_name, hire_date, department_id FROM employees where 1=1;

select * FROM emp_salary_info;
SELECT * FROM emp_hiredate_info;

-- 2. EMPLOYEES 테이블에 다음 데이터를 추가하세요. 사원번호 :  1030   성 :  KilDong     이름 :  Hong     이메일 :  HONGKD     
--    전화번호 :  010-1234-5678     입사일 :  2018/03/20     직무아이디 :  IT_PROG     급여 :  6000     보너스율 :  0.2     
--    매니저번호 :  103     부서번호 :  60
create table emp1 as select * from employees where 1=1;
select * from emp1;

INSERT INTO emp1 
VALUES (1030, 'KilDong', 'Hong', 'HONGKD', 010-1234-5678, '18/03/20', 'IT_PROG', 6000, 0.2, 103, 60);

-- 3. 1030번 사원의 급여를 10% 인상시키세요.
UPDATE emp1 SET salary=salary* 1.1 WHERE employee_id = 1030;

-- 4. 1030번 사원의 정보를 삭제하세요.
DELETE FROM emp1 WHERE employee_id = 1030;

-- 5. 사원테이블을 이용하여,  2001년부터 2003년까지의 연도에 근무한 사원들의 사원아이디, 이름, 입사일, 연도를 출력하세요.
CREATE TABLE emp_yr_2001 (
    employee_id NUMBER(6.0),
    first_name VARCHAR2(20),
    hire_date DATE,
    yr VARCHAR(20));

CREATE TABLE emp_yr_2002 (
    employee_id NUMBER(6.0),
    first_name VARCHAR2(20),
    hire_date DATE,
    yr VARCHAR(20));

CREATE TABLE emp_yr_2003 (
    employee_id NUMBER(6.0),
    first_name VARCHAR2(20),
    hire_date DATE,
    yr VARCHAR(20));    
seLECT * FROM emp_yr_2001;
seLECT * FROM emp_yr_2002;
seLECT * FROM emp_yr_2003;

INSERT ALL
    WHEN TO_CHAR(hire_date, 'RRRR') = '2001' THEN
     INTO emp_yr_2001 VALUES (employee_id, first_name, hire_date, yr)
    WHEN TO_CHAR(hire_date, 'RRRR') = '2002' THEN
     INTO emp_yr_2002 VALUES (employee_id, first_name, hire_date, yr)
    WHEN TO_CHAR(hire_date, 'RRRR') = '2003' THEN
     INTO emp_yr_2003 VALUES (employee_id, first_name, hire_date, yr)
    SELECT employee_id, first_name, hire_date, 
           TO_CHAR(hire_date, 'RRRR') as yr FROM employees;

-- 6. 문제 5의의 조건3을 비교연산자를 사용하여,  INSERT FIRST 구문으로 작성하세요.
INSERT FIRST
    WHEN hire_date <= '01/12/31' THEN
        INTO emp_yr_2001 VALUES (employee_id, first_name, hire_date, yr)
    WHEN hire_date <= '02/12/31' THEN
        INTO emp_yr_2002 VALUES (employee_id, first_name, hire_date, yr)
    WHEN hire_date <= '03/12/31' THEN
        INTO emp_yr_2003 VALUES (employee_id, first_name, hire_date, yr)    
    SELECT employee_id, first_name, hire_date,
        TO_CHAR(hire_date, 'RRRR') as yr FROM employees;

-- 7. Employees 테이블의 사원들 정보를 아래의 두 테이블에 나눠 저장하세요 .     
--    조건1) emp_personal_info 테이블에는 employee_id, first_name, last_name, email, phone_number가 저장되도록 하세요.
--    조건2) emp_office_info 테이블에는 employee_id, hire_date, salary, commission_pct,
--    manager_id, department_id가 저장되도록 하세요.
CREATE TABLE emp_personal_info AS 
SELECT employee_id, first_name, last_name, email, phone_number
FROM employees
WHERE 1=2;

CREATE TABLE emp_office_info AS
SELECT employee_id, hire_date, salary, commission_pct, manager_id, department_id
FROM employees
WHERE 1=2 ;

INSERT ALL
    INTO emp_personal_info
     VALUES (employee_id, first_name, last_name, email, phone_number)
    INTO emp_office_info
     VALUES (employee_id, hire_date, salary, commission_pct, manager_id, department_id)
    SELECT * FROM employees;

SELECT * FROM emp_office_info;
SELECT * FROM emp_personal_info;

-- 8. Employees 테이블의 사원들 정보를 아래의 두 테이블에 나눠 저장하세요 .     
--   조건1) 보너스가 있는 사원들의 정보는 emp_comm 테이블에 저장하세요 .
--   조건2) 보너스가 없는 사원들의 정보는 emp_nocomm 테이블에 저장하세요.
CREATE TABLE emp_comm AS SELECT * FROM employees WHERE 1=2;
CREATE TABLE emp_nocomm AS SELECT * FROM employees WHERE 1=2;

INSERT ALL
    WHEN commission_pct IS NULL THEN
        INTO emp_comm
            VALUES (employee_id, first_name, last_name, email,
                    phone_number, hire_date, job_id, salary,
                    commission_pct, manager_id, department_id)
    WHEN commission_pct IS NOT NULL THEN
        INTO emp_nocomm
            VALUES (employee_id, first_name, last_name, email,
                    phone_number, hire_date, job_id, salary,
                    commission_pct, manager_id, department_id)
    SELECT * FROM employees;
SELECT * FROM emp_comm;
SELECT * FROM emp_nocomm;