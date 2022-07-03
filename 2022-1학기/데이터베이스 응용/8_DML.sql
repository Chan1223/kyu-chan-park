-- 8��
-- create table
CREATE TABLE emp1 AS SELECT * FROM employees;

SELECT COUNT(*) FROM emp1;


-- create table with WHERE : �����ʹ� ������������ ������ ��������
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

-- �ٸ� ���̺�κ��� �� ����
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

-- ���̺� �� ����
SELECT employee_id, first_name, salary
FROM emps
WHERE employee_id = 103;

UPDATE emps
SET salary=salary * 1.1
WHERE employee_id = 103;

-- ���������� ���� �� ����
UPDATE emps
SET (job_id, salary, manager_id) =
    (SELECT job_id, salary, manager_id
     FROM emps
     WHERE employee_id = 108)
WHERE employee_id = 109;

--- DELETE
DELETE FROM emps
WHERE employee_id =103;

-- �ٸ� ���̺��� �̿��� �� ����
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


----- �������� -------
-- 1. EMPLOYEES ���̺� �ִ�  �����͸� ��  ������ ����  �����ϰ� �ͽ��ϴ�.  �����ȣ, ����̸�,
--    �޿�,  ���ʽ�����  �����ϱ�  ����  ������  �����͸�  ����  ���̺��� EMP_SALARY_INFO�̶�� �̸����� �����ϼ���.
--    �׸��� �����ȣ,  ����̸�,  �Ի���, �μ���ȣ�� �����ϱ� ���� ������ �����͸� ���� ���̺��� EMP_HIREDATE_INFO��� �̸����� �����ϼ���.
CREATE TABLE EMP_SALARY_INFO AS
    SELECT employee_id, first_name, salary, commission_pct FROM employees where 1=1;

CREATE TABLE emp_hiredate_info AS
    SELECT employee_id, first_name, hire_date, department_id FROM employees where 1=1;

select * FROM emp_salary_info;
SELECT * FROM emp_hiredate_info;

-- 2. EMPLOYEES ���̺� ���� �����͸� �߰��ϼ���. �����ȣ :  1030   �� :  KilDong     �̸� :  Hong     �̸��� :  HONGKD     
--    ��ȭ��ȣ :  010-1234-5678     �Ի��� :  2018/03/20     �������̵� :  IT_PROG     �޿� :  6000     ���ʽ��� :  0.2     
--    �Ŵ�����ȣ :  103     �μ���ȣ :  60
create table emp1 as select * from employees where 1=1;
select * from emp1;

INSERT INTO emp1 
VALUES (1030, 'KilDong', 'Hong', 'HONGKD', 010-1234-5678, '18/03/20', 'IT_PROG', 6000, 0.2, 103, 60);

-- 3. 1030�� ����� �޿��� 10% �λ��Ű����.
UPDATE emp1 SET salary=salary* 1.1 WHERE employee_id = 1030;

-- 4. 1030�� ����� ������ �����ϼ���.
DELETE FROM emp1 WHERE employee_id = 1030;

-- 5. ������̺��� �̿��Ͽ�,  2001����� 2003������� ������ �ٹ��� ������� ������̵�, �̸�, �Ի���, ������ ����ϼ���.
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

-- 6. ���� 5���� ����3�� �񱳿����ڸ� ����Ͽ�,  INSERT FIRST �������� �ۼ��ϼ���.
INSERT FIRST
    WHEN hire_date <= '01/12/31' THEN
        INTO emp_yr_2001 VALUES (employee_id, first_name, hire_date, yr)
    WHEN hire_date <= '02/12/31' THEN
        INTO emp_yr_2002 VALUES (employee_id, first_name, hire_date, yr)
    WHEN hire_date <= '03/12/31' THEN
        INTO emp_yr_2003 VALUES (employee_id, first_name, hire_date, yr)    
    SELECT employee_id, first_name, hire_date,
        TO_CHAR(hire_date, 'RRRR') as yr FROM employees;

-- 7. Employees ���̺��� ����� ������ �Ʒ��� �� ���̺� ���� �����ϼ��� .     
--    ����1) emp_personal_info ���̺��� employee_id, first_name, last_name, email, phone_number�� ����ǵ��� �ϼ���.
--    ����2) emp_office_info ���̺��� employee_id, hire_date, salary, commission_pct,
--    manager_id, department_id�� ����ǵ��� �ϼ���.
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

-- 8. Employees ���̺��� ����� ������ �Ʒ��� �� ���̺� ���� �����ϼ��� .     
--   ����1) ���ʽ��� �ִ� ������� ������ emp_comm ���̺� �����ϼ��� .
--   ����2) ���ʽ��� ���� ������� ������ emp_nocomm ���̺� �����ϼ���.
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