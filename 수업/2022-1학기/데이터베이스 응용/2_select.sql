---- 1장
SELECT COUNT (*) FROM employees;

---- 2장
-- 테이블 확인하기
DESC employees;

-- 테이블 명 대문자로 만들기
SELECT first_name "EMployee Name", 
       salary*12 "Annual Salaray"
FROM employees;

-- ||를 이용한 join
SELECT first_name || ' ' || last_name || '''s salary is $' || salary AS "Employee Details"
FROM employees;

-- DISTINCT를 활용하여 중복 행 제외하고 표시
SELECT DISTINCT department_id
FROM employees;

-- ROWID, ROWNUM 의사열(Pseudo column)
SELECT ROWID, ROWNUM, employee_id, first_name
FROM employees;

-- WHERE절
SELECT first_name, job_id, department_id
FROM employees
WHERE job_id= 'IT_PROG';

SELECT first_name, last_name, hire_date
FROM employees
WHERE last_name = 'King';

-- WHERE 절을 이용한 비교연산자 사용
SELECT first_name, salary, hire_date
FROM employees
WHERE salary >= 15000;

SELECT first_name, salary, hire_date
FROM employees
WHERE hire_date = '04/01/30';

SELECT first_name, salary, hire_date
FROM employees
WHERE first_name = 'Steven';

-- BETWEEN 연산자
SELECT first_name, salary
FROM employees
WHERE salary BETWEEN 10000 AND 12000;

SELECT first_name, salary
FROM employees
WHERE hire_date BETWEEN '03/01/01' AND '03/12/13';

SELECT first_name, salary, hire_date
FROM employees
WHERE first_name BETWEEN 'A' AND 'Bzzzzzzzzzz';

-- IN 연산자
SELECT employee_id, first_name, salary, manager_id
FROM employees
WHERE manager_id IN(101, 102, 103);

SELECT first_name, last_name, job_id, department_id
FROM employees
WHERE job_id IN ('IT_PROG', 'FI_MGR', 'AD_VP');

-- LIKE 연산자
SELECT first_name, last_name, department_id
FROM employees
WHERE job_id like 'IT%';

-- %는 문자가 없거나 하나 이상인 것을 나타냄
SELECT first_name, hire_date
FROM employees
WHERE hire_date LIKE '03%';

-- _는 한 글자가 있음을 나타냄
SELECT first_name, email
FROM employees
WHERE email LIKE '_A%';

-- ESCAPE 문자를 사용해서 와일드카드 문자를 문자열 자체로 인식시키기 가능
SELECT first_name, job_id
FROM employees
WHERE job_id Like 'SA\_M%' ESCAPE '\';

-- IS NULL 연산자
-- IS NULL 사용
SELECT first_name, manager_id
FROM employees
WHERE manager_id IS NULL;

-- IS NOT NULL 사용
SELECT first_name, manager_id, commission_pct
FROM employees
WHERE commission_pct IS NOT NULL;

--- 논리 연산자
-- AND 사용
SELECT first_name, job_id, salary
FROM employees
WHERE job_id = 'IT_PROG' AND salary >= 5000;

-- OR 사용
SELECT first_name, job_id, salary
FROM employees
WHERE job_id = 'IT_PROG' OR salary >= 5000;

-- OR 보다  AND가 우선순위가 높아 수식이 이상하게 읽힐 수 있음.
SELECT first_name, job_id, salary
FROM employees
WHERE job_id = 'IT_PROG'
OR job_id = 'FI_MGR'
AND salary >= 6000;
-- 위 코드는 job_id 가 FI_MGR 이면서 salary 가 6000이 넘는 직원 + job_id가 IT_PROG 인 인원의 목록이 나오게 됨

--- 제대로 된 코드
SELECT first_name, job_id, salary
FROM employees
WHERE (job_id = 'IT_PROG' OR job_id = 'FI_MGR')
AND salary >= 6000;

--- 데이터 정렬
-- 오름차순 정렬(default)
SELECT first_name, hire_date
FROM employees
ORDER BY hire_date;

-- 내림차순 정렬(DESC 사용)
SELECT first_name, hire_date
FROM employees
ORDER BY hire_date DESC;

-- 아래 3개 구문 모두 동일한 결과값 출력(salary*12, annual, 2)
SELECT first_name, salary *12 AS annual
FROM employees
ORDER BY salary*12;

SELECT first_name, salary *12 AS annual
FROM employees
ORDER BY annual;

SELECT first_name, salary *12 AS annual
FROM employees
ORDER BY 2;

---- 연습문제 -----
-- 1. 모든 사원의 사원번호, 이름, 입사일, 급여를 출력하세요.
SELECT employee_id, first_name, hire_date, salary
FROM employees;

-- 2. 모든 사원의 이름과 성을 붙여 출력하세요. 열 별칭은 name으로 하세요. 
SELECT first_name || ' ' || last_name AS name
FROm employees;

-- 3. 50번 부서 사원의 모든 정보를 출력하세요. 
SELECT *
FROM employees
WHERE department_id = 50;

SELECT *
FROM employees
WHERE department_id LIKE 50;

-- 4. 50번 부서 사원의 이름, 부서번호, 직무아이디를 출력하세요. 
SELECT first_name, department_id, job_id
FROM employees
WHERE department_id = 50;

-- 5. 모든 사원의 이름, 급여 그리고 300달러 인상된 급여를 출력하세요. 
SELECT first_name, salary, salary + 300
FROM employees;

-- 6. 급여가 10000보다 큰 사원의 이름과 급여를 출력하세요. 
SELECT first_name, salary
FROM employees
WHERE salary >= 10000;

-- 7. 보너스를 받는 사원의 이름과 직무, 보너스율을 출력하세요. 
SELECT first_name, job_id, commission_pct
FROM employees
WHERE commission_pct IS NOT NULL;

-- 8. 2003년도 입사한 사원의 이름과 입사일 그리고 급여를 출력하세요.(BETWEEN 연산자 사용) 
SELECT first_name, hire_date, salary
FROM employees
WHERE hire_date BETWEEN '03/01/01' and '03/12/31';

SELECT first_name, hire_date, salary
FROM employees
WHERE hire_date BETWEEN '2003/01/01' AND '2003/12/31';

-- 9. 2003년도 입사한 사원의 이름과 입사일 그리고 급여를 출력하세요.(LIKE 연산자 사용) 
SELECT first_name, hire_date, salary
FROM employees
WHERE hire_date LIKE '03%';

SELECT first_name, hire_date, salary
FROM employees
WHERE hire_date LIKE '03/%';

-- 10. 모든 사원의 이름과 급여를 급여가 많은 사원부터 적은 사원순서로 출력하세요. 
SELECT first_name, salary
FROM employees
ORDER BY salary DESC;

-- 11. 위 질의를 60번 부서의 사원에 대해서만 질의하세요. 
SELECT first_name, salary
FROM employees
WHERE department_id = 60
ORDER BY salary DESC;

-- 12. 직무아이디가 IT_PROG 이거나, SA_MAN인 사원의 이름과 직무아이디를 출력하세요. 
SELECT first_name, job_id
FROM employees
WHERE (job_id = 'IT_PROG') or (job_id = 'SA_MAN');

-- 13. Steven King 사원의 정보를 “Steven King 사원의 급여는 24000달러 입니다” 형식으로 출력하세요. 
SELECT first_name || ' ' || last_name || ' 사원의 급여는 ' || salary || '달러 입니다' AS result
FROM employees
WHERE first_name = 'Steven' AND last_name = 'King';

-- 14. 매니저(MAN) 직무에 해당하는 사원의 이름과 직무아이디를 출력하세요. 
SELECT first_name, job_id
FROM employees
WHERE job_id LIKE '%MAN%';

-- 15. 매니저(MAN) 직무에 해당하는 사원의 이름과 직무아이디를 직무아이디 순서대로 출력하세요.
SELECT first_name, job_id
FROM employees
WHERE job_id LIKE '%MAN'
ORDER BY job_id;