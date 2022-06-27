---- 6장
SELECT first_name, employees.department_id, department_name
FROM employees, departments;

SELECT e.first_name, e.department_id, d.department_name
FROM employees e, departments d;

--- 오라클 조인
-- Equi join
SELECT e.first_name, e.department_id, d.department_name
FROM employees e, departments d
WHERE e.department_id = d.department_id;

SELECT e.first_name, e.salary, m.first_name, m.salary
FROM employees e, employees m
WHERE e.manager_id = m.employee_id AND e.salary>m.salary;

-- self join
SELECT e.first_name AS employee_name,
       m.first_name AS manager_name
FROM employees e, employees m
WHERE e.manager_id = m.employee_id AND e.employee_id = 103;

-- NON_EQUI join
SELECT e.first_name, e.salary, j.job_title
FROM employees e, jobs j
WHERE e.salary BETWEEN j.min_salary AND j.max_salary
ORDER BY e.first_name;

-- OUTER JOIN
SELECT e.employee_id, e.first_name, e.hire_date,
       j.start_date, j.end_date, j.job_id, j.department_id
FROM employees e, job_history j
WHERE e.employee_id = j.employee_id(+)
ORDER BY j.employee_id;

---- ANSI JOIN
-- cross join : 카티션 프로덕트와 동일, 의도적 데이터 복제가 아니면 사용하지 않는 것이 바람직함.
SELECT employee_id, department_name
FROM employees
CROSS JOIN departments;

--natural join
SELECT first_name, job_title
FROM employees
NATURAL JOIN jobs;

SELECT first_name, department_name
FROM employees
NATURAL JOIN departments;

-- USING JOIN
SELECT first_name, department_name
FROM employees
JOIN departments
USING (department_id);

-- ON JOIN
SELECT department_name, street_address, city, state_province
FROM departments d
JOIN locations l
ON d.location_id = l.location_id;

SELECT department_name, first_name
FROM departments d
JOIN employees e ON d.manager_id = e.employee_id;

-- 모든 사원의 이름과 부서 이름, 주소 출력
SELECT e.first_name, d.department_name,
    l.street_address || ',' || l.city || ',' || l.state_province AS address
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN locations l ON d.location_id = l.location_id;

---- where 절과 혼용
-- 103번 부서 사원의 이름과 부서 이름 출력
SELECT e.first_name AS name,
       d.department_name AS department
FROM employees e
JOIN departments d
ON   e.department_id = d.department_id
WHERE employee_id = 103;

-- 103번 부서 사원의 이름, 부서 이름, 주소 출력
SELECT e.first_name AS name, d.department_name AS department,
       l.street_address || ',' || l.city || ',' || l.state_province
       AS address
FROM employees e
JOIN departments d
ON   e.department_id = d.department_id
JOIN locations l
ON   d.location_id = l.location_id
WHERE employee_id = 103;

----- ON 절에 WHERE 추가 : 같은 결과 도출 가능
-- 1번 방식 
SELECT e.first_name AS name, d.department_name AS department,
       l.street_address || ',' || l.city || ',' || l.state_province
       AS address
FROM employees e
JOIN departments d
ON   e.department_id = d.department_id
JOIN locations l
ON   d.location_id = l.location_id AND employee_id = 103;

-- 2번 방식
SELECT e.first_name AS name, d.department_name AS department,
       l.street_address || ',' || l.city || ',' || l.state_province
       AS address
FROM employees e
JOIN departments d
ON   e.department_id = d.department_id AND employee_id = 103
JOIN locations l
ON   d.location_id = l.location_id ;


-- OUTER JOIN 
SELECT e.employee_id, e.first_name, e.hire_date,
       j.start_date, j.end_date, j.job_id, j.department_id
FROM employees e
LEFT OUTER JOIN job_history j
ON   e.employee_id = j.employee_id
ORDER BY e.employee_id;

-- LEFT OUTER jOIN
SELECT department_name, first_name
FROM departments d
LEFT JOIN employees e on d.manager_id = e.employee_id;

-- RIGHT OUTER JOIN
SELECT department_name, first_name
FROM employees e
RIGHT JOIN departments d on d.manager_id = e.employee_id;


---- 연습문제 ----
-- 1.  John 사원의 이름과 부서이름,  부서위치 (city)를  출력하세요.(오라클조인,  안시조인 구문 둘 다 작성하세요)
-- (오라클 조인)
SELECT first_name, department_name, city
FROM employees e, departments d, locations l
WHERE e.department_id = d.department_id AND d.location_id = l.location_id;

-- (안시 조인)
SELECT first_name, department_name, city
FROM employees e
JOIN departments d ON  e.department_id = d.department_id
JOIN locations l ON d.location_id = l.location_id;

-- 2. 103번  사원의 사원번호 ,  이름,  급여,  매니저이름 , 매니저 급여 매니저 부서이름을 출력하세요.(안시조인으로 작성하세요)
SELECT e.employee_id, 
       e.first_name, 
       e.salary, 
       m.first_name AS manager_name, 
       m.salary AS manager_salary,
       d.department_name AS manager_department
FROM employees e
JOIN employees m ON e.manager_id = m.employee_id
JOIN departments d ON m.department_id = d.department_id
WHERE e.employee_id = 103;

-- 3. 90번부서 사원들의 사번,  이름,  급여,  매니저이름,  매니저급여,  매니저부서이름을 출력하세요.
--   (오라클 조인과 안시조인 구문 둘 다 작성하세요)
-- (오라클 조인)
SELECT e.employee_id, e.first_name, e.salary,
       m.first_name, m.salary,d.department_name
FROM employees e, employees m, departments d
WHERE e.manager_id = m.employee_id(+) 
  AND e.department_id = d.department_id(+)
  AND e.department_id = 90;

-- (안시 조인)
SELECT e.employee_id, e.first_name, e.salary,
       m.first_name, m.salary,d.department_name
FROM employees e
LEFT OUTER JOIN employees m ON e.manager_id = m.employee_id
LEFT OUTER JOIN departments d ON e.department_id = d.department_id
WHERE e.department_id = 90;

-- 4. 103번사원이 근무하는 도시는?(안시 조인 구문으로 작성하세요 )
SELECT e.employee_id, CITY
FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    JOIN locations l ON d.location_id = l.location_id
WHERE employee_id = 103;

-- 5. 사원번호가 103인사원의 부서위치 (city)와  매니저의 직무이름 (job_title)을  출력하세요.(안시 조인 구문으로 작성하세요)
SELECT e.employee_id, city, job_title
FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    JOIN locations l ON d.location_id = l.location_id
    JOIN employees m ON e.manager_id =m.employee_id
    JOIN jobs j ON m.job_id = j.job_id
WHERE e.employee_id = 103;

-- 6. 사원의 모든  정보를 조회하는 쿼리문을 작성하세요.  사원의 부서번호는 부서이름으로,
--    직무아이디는 직무이름으로,  매니저아이디는 매니저이름으로 출력하세요.
SELECT * from locations;
SELECT * from departments;
SELECT * from employees;
SELECT * from jobs;

SELECT e.employee_id, e.first_name, e.last_name, e.email, e.phone_number,
       e.hire_date, j.job_title, e.salary, e.commission_pct, m.first_name,
       m.last_name, d.department_name
FROM employees e
LEFT OUTER JOIN departments d ON e.department_id = d.department_id
JOIN jobs j ON e.job_id = j.job_id
LEFT JOIN employees m ON e.manager_id = m.employee_id;


-- 7. 다음 중 오류가 있는 라인은?
--> 테이블 별칭을 준 상태에서는 테이블 명을 그대로 사용할 수 없음.
