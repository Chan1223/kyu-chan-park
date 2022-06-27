--- 7장
-- nancy 보다 급여를 많이 받는 사람
SELECT first_name, salary
FROM employees
WHERE salary > (SELECT salary
                FROM   employees
                WHERE first_name = 'Nancy');

--- 단일 행 서브쿼리
-- 103번 사원의 직무와 같은 사원의 이름, 직무 ,입사일 출력                
SELECT first_name, job_id, hire_date
FROM employees
WHERE job_id = (SELECT job_id
                FROM employees
                WHERE employee_id = 103);
-- 다중 행 서브쿼리
-- ANY
SELECT first_name, salary
FROM employees
WHERE salary > ANY(SELECT salary
                   FROM employees
                   WHERE first_name = 'David');

-- IN
SELECT first_name, department_id, job_id
FROM employees
WHERE department_id IN (SELECT department_id
                        FROM employees
                        WHERE first_name= 'David');

-- EXIST                
SELECT first_name, department_id, job_id
FROM employees e
WHERE EXISTS (SELECT *
              FROM departments d
              WHERE d.manager_id = e.employee_id);

-- 상호연관 서브쿼리                        
SELECT first_name, salary
FROM employees a
WHERE salary > (SELECT avg(salary)
                FROM employees b
                WHERE b.department_id = a.department_id);

-- 스칼라 서브쿼리                
SELECT first_name, 
    (SELECT department_name
     FROM departments d
     WHERE d.department_id=e.department_id) department_name
FROM employees e
ORDER BY first_name;

SELECT first_name, department_name
FROM employees e
JOIN departments d ON (e.department_id = d.department_id)
ORDER BY first_name;

-- 인라인 뷰
SELECT row_number, first_name, salary
FROM (SELECT frist_name, salary,
             row_number() OVER (ORDER BY salary DESC) AS row_number
             FROM employees)
WHERE row_number BETWEEN 1 AND 10;

-- 3중 쿼리
SELECT rownum, first_name, salary
FROM (SELECT first_name, salary
      FROM employees
      ORDER BY salary DESC)
WHERE rownum BETWEEN 1 AND 10;

-- rownum은 1행부터 데이터를 읽기 때문에 중간부터 읽어올 수 없음
SELECT rownum, first_name, salary
FROM (SELECT first_name, salary
      FROM employees
      ORDER BY salary DESC)
WHERE rownum BETWEEN 11 AND 20;

--- 3중 쿼리
SELECT rnum, first_name, salary
FROM (SELECT first_name, salary, rownum AS rnum
      FROM (SELECT first_name, salary
            FROM employees
            ORDER BY salary DESC)
      )
WHERE rnum BETWEEN 11 AND 20;

-- 분석함수로 위 구문과 동일하게 만든 구문
SELECT row_number, first_name, salary
FROM (SELECT first_name, salary,
      row_number() OVER (ORDER BY salary DESC) AS row_number
      FROM employees)
WHERE row_number BETWEEN 11 AND 20;

-- FETCH 절을 이용해서 작성하는게 퍼포먼스적으로 더 나음
SELECT first_name,salary
FROM employees
ORDER BY salary DESC
OFFSET 10 ROWS
FETCH FIRST 10 ROWS ONLY;
-- FEST FIRST 10 PERCENT ROWS ONLY 라고 작성할 수 있음(10퍼센트에 해당하는 값 불러오기)


--- 계층형 쿼리
SELECT employee_id,
       LPAD(' ', 3*(LEVEL-1)) || first_name || ' ' || last_name,
       LEVEL
FROM employees
START WITH manager_id IS NULL
CONNECT BY PRIOR employee_id = manager_id;

-- 같은 매니저를 갖는 사원들을 이름순으로 정렬해서 출력
SELECT employee_id,
       LPAD(' ', 3*(LEVEL-1)) || first_name || ' ' || last_name,
       LEVEL
FROM employees
START WITH manager_id IS NULL
CONNECT BY PRIOR employee_id = manager_id
ORDER BY first_name;

-- 관계 추적 용도로 활용 가능
SELECT employee_id,
       LPAD(' ', 3*(LEVEL-1)) || first_name || ' ' || last_name,
       LEVEL
FROM employees
START WITH employee_id = 113
CONNECT BY PRIOR manager_id = employee_id;

------ 연습문제 ------
-- 1. 20번 부서에 근무하는 사원들의 매니저와 매니저가 같은 사원들의 정보를 출력하세요.
SELECT *
FROM employees
WHERE manager_id = ANY (SELECT manager_id
                    FROM employees
                    WHERE department_id = 50);
-- 2. 가장 많은 급여를 받은 사람의 이름을 출력하세요.
SELECT first_name
FROM employees
WHERE salary = (SELECT max(salary)
                FROM employees);

-- 3. 급여 순으로(내림차순)  3위부터 5위까지 출력하세요.(rownum 이용)
SELECT rnum, first_name, salary
FROM (SELECT rownum AS rnum, first_name, salary
      FROM (SELECT first_name, salary
            FROM employees
            ORDER BY salary DESC)
      )
WHERE rnum BETWEEN 3 AND 5;

-- 4. . 부서별 부서의 평균이상 급여를 받는 사원의 부서번호,  이름,  급여,  평균급여를 출력하세요
SELECT department_id, first_name, salary, 
    (SELECT ROUND(AVG(salary),2)
     FROM employees e
     WHERE e.department_id = a.department_id ) AS avg_sal
FROM employees a
WHERE salary >= (SELECT AVG(salary)
                 FROM employees b
                 WHERE b.department_id = a.department_id)
ORDER BY department_id;
