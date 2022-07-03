--- 4장
-- AVG, SUM, MIN, MAX
SELECT AVG(salary), MAX(salary), MIN(salary), SUM(salary)
FROM employees
WHERE job_id LIKE 'SA%';

-- 날짜
SELECT MIN(hire_date), MAX(hire_date)
FROM employees;

-- 텍스트
SELECT MIN(first_name), MAX(last_name)
FROM employees;
-- 특수문자>숫자>영어(대문자)>영어(소문자)>한글 순으로 인식
-- ASCII CODE 기준이기 때문

-- 숫자 기준
SELECT MAX(salary)
FROM employees;

--- COUNT
SELECT COUNT(*) FROM employees;
SELECT COUNT(commission_pct) FROM employees;

--- STDDEV, VARIANCE
SELECT SUM(salary) 합계,
       ROUND(AVG(salary), 2) 평균,
       ROUND(STDDEV(salary), 2) 표준편차,
       ROUND(VARIANCE(salary), 2) 분산
FROM employees;

-- 그룹함수와 null 값: count(*)를 제외한 모든 그룹 함수는 열에 있는 null값을 연산에서 제외함
SELECT
    ROUND(SUM(salary * commission_pct), 2) sum_bonus,
    COUNT(*) count,
		-- 단순 AVG를 할 경우 null값이 담긴 count가 제외되고 평균이 구해져 값이 커짐
    ROUND(AVG(salary * commission_pct), 2) avg_bonus1,
		-- 별도로 count(*)를 사용해 null값이 담긴 데이터를 포함하여 나누어 줌
    ROUND(SUM(salary * commission_pct)/count(*), 2) avg_bonus2,
		-- NVL 사용으로 동일한 값을 얻을 수 있음을 확인
    ROUND(AVG(NVL(salary * commission_pct,0)), 2) nvl_bonus
FROM employees;

-- GROUP BY
SELECT department_id, ROUND(AVG(salary), 2)
FROM employees
GROUP BY department_id;

SELECT department_id, job_id, SUM(salary)
FROM employees
GROUP BY department_id, job_id
ORDER BY department_id;

-- 부서별 소속 사원의 수를 알고 싶을 때
SELECT department_id, COUNT(first_name)
FROM employees
GROUP BY department_id;

-- having
SELECT department_id, ROUND(AVG(salary), 2)
FROM employees
HAVING AVG(salary) > 2000
GROUP BY department_id;

SELECT department_id, ROUND(AVG(salary), 2)
FROM employees
GROUP BY department_id
HAVING AVG(salary) > 8000;

SELECT job_id, AVG(salary) PAYROLL
FROM employees
WHERE job_id NOT LIKE 'SA%'
GROUP BY job_id
HAVING AVG(salary) >8000
ORDER BY AVG(salary);

-- GROUPING SETS
SELECT department_id, job_id, ROUND(AVG(salary), 2)
FROM employees
GROUP BY GROUPING SETS(department_id, job_id);

SELECT department_id, job_id, manager_id, ROUND(AVG(salary),2) AS avg_sal
FROM employees
GROUP BY GROUPING SETS ((department_id, job_id),
                        (job_id, manager_id));

--- ROLLUP, CUBE
-- ROLLUP
SELECT department_id, job_id, ROUND(AVG(salary),2), COUNT(*)
FROM employees
GROUP BY ROLLUP(department_id, job_id);

-- CUBE
SELECT department_id, job_id, ROUND(AVG(salary), 2), COUNT(*)
FROM employees
GROUP BY CUBE(department_id, job_id);

-- GROUPING : null값일 경우 1로 출력해줌.
SELECT
    DECODE(GROUPING(department_id), 1, '소계',
           TO_CHAR(department_id)) AS 부서,
    DECODE(GROUPING(job_id), 1, '소계', job_id) AS 직무,
    ROUND(AVG(salary),2) AS 평균,
    COUNT(*) AS 사원의수
FROM employees
GROUP BY CUBE(department_id, job_id)
ORDER BY 부서, 직무;

-- GROUPING_ID
SELECT
    DECODE(GROUPING_ID(department_id, job_id),
           2, '소계', 3, '합계',
           TO_CHAR(department_id)) AS 부서번호,
    DECODE(GROUPING_ID(department_id, job_id),
           1, '소계', 3, '합계',
           job_id) AS 직무,
    GROUPING_ID(department_id, job_id) AS GID,
    ROUND(AVG(salary), 2) AS 평균,
    COUNT(*) AS 사원의수
FROM employees
GROUP BY CUBE(department_id, job_id)
ORDER BY 부서번호, 직무;


-- 1. 직무별 급여 평균을 출력하세요.
SELECT job_id, AVG(salary)
FROM employees
GROUP BY job_id;

-- 2. 부서별 사원의 수를 출력하세요.
SELECT department_id, COUNT(first_name)
FROM employees
GROUP BY department_id
ORDER BY department_id;

-- 3. 부서별, 직무별 사원의 수를 각각 출력하세요.
SELECT department_id, job_id, COUNT(first_name)
FROM employees
GROUP BY GROUPING SETS(department_id, job_id)
ORDER BY department_id, job_id;

-- 4. 부서별 급여 표준편차를 출력하세요.
SELECT department_id, ROUND(STDDEV(salary), 2)
FROM employees
GROUP BY department_id;

-- 5. 사원의 수가 4명 이상인 부서의 아이디와 사원의 수를 출력하세요.
SELECT department_id, count(first_name)
FROM employees
GROUP BY department_id
HAVING count(first_name) >= 4;

-- 6. 50번부서의 직무별 사원의 수를 출력하세요.
SELECT job_id, count(first_name)
FROM employees
WHERE department_id = 50
GROUP BY job_id;

-- 7. 50번 부서에서 직무별 사원의 수가 10명 이하인 직무아이디와 사원의 수를 출력하세요.
SELECT job_id, count(first_name)
FROM employees
WHERE department_id = 50
GROUP BY job_id
HAVING count(first_name) <= 10;

-- 8. 사원목록 중 입사년도 별로 사원들의 급여 평균과 사원수를 출력하세요.
-- 조건1) 입사년도가 빠른 순으로 정렬하세요.
SELECT TO_CHAR(hire_date, 'YYYY') AS hire, ROUND(AVG(salary), 2) 급여평균, count(first_name) 사원수
FROM employees
GROUP BY TO_CHAR(hire_date, 'YYYY')
ORDER BY hire;

-- 9. 사원목록 중 입사년도와 입사월 별로 사원들의 급여 평균과 사원수를 출력하세요.
-- 조건1) 입사년도가 빠른 순으로 정렬한 이후,  입사년도가 같다면 입사월을 기준으로 정렬하세요.
-- 조건2) 입사년도를 기준으로 급여평균과 사원수의 총 합계를 구하세요.
SELECT TO_CHAR(hire_date, 'YYYY') year,
       TO_CHAR(hire_date, 'MM') mon,
       ROUND(AVG(salary), 2),
       count(first_name)
FROM employees
GROUP BY CUBE(TO_CHAR(hire_date, 'YYYY'), TO_CHAR(hire_date, 'MM'))
ORDER BY year, mon;

-- 10. 사원목록 중 입사년도와 입사월 별로 사원들의 급여 평균과 사원수를 출력하세요.
-- 조건1) 입사년도가 빠른 순으로 정렬한 이후, 입사년도가 같다면 입사월을 기준으로 정렬하세요
-- 조건2) 입사년도와 입사월을 기준으로 급여평균과 사원수의 총  합계를 구하세요.  
--       단,  입사년도의 합계는 ‘합계’,  입사월의 합계는 ‘소계’,  입사월의 전체 합계는 ‘합계’로 출력하세요.
SELECT DECODE(GROUPING(TO_CHAR(hire_date, 'YYYY')),
              1, '합계', TO_CHAR(hire_date, 'YYYY')) year,
       DECODE(GROUPING_ID(TO_CHAR(hire_date, 'YYYY'), TO_CHAR(hire_date, 'MM')),
              1, '소계',
              3, '합계', TO_CHAR(hire_date, 'MM')) mon,
       ROUND(AVG(salary), 2) 급여,
       COUNT(first_name) 사원수
FROM employees
GROUP BY CUBE(TO_CHAR(hire_date, 'YYYY'), TO_CHAR(hire_date, 'MM'))
ORDER BY year, mon;

-- 11. 사원목록 중 입사년도와 입사월 별로 사원들의 급여 평균과 사원수를 출력하세요 .
-- 조건1) 입사년도가 빠른 순으로 정렬한 이후, 입사년도가 같다면 입사 월을 기준으로 정렬하세요.
-- 조건2) 입사년도와 입사월을 기준으로 급여평균과 사원수의 총 합계를 구하세요 . 
--       단, 입사년도의 합계는 ‘소계’, 입사월의 합계는 ‘합계’로 출력하세요.
-- 조건3) 2개 이상의 열에 대한 집계를 확인하는 GROUPING_ID 값 을 출력하세요 . 이 열의 이름은 ‘GID’입니다.
SELECT DECODE(GROUPING(TO_CHAR(hire_date, 'YYYY')),
              1, '소계', TO_CHAR(hire_date, 'YYYY'))AS year,
       DECODE(GROUPING(TO_CHAR(hire_date, 'MM')),
              1, '합계', TO_CHAR(hire_date, 'MM')) AS mon,
       GROUPING_ID(TO_CHAR(hire_date, 'YYYY'), TO_CHAR(hire_date, 'MM')) AS GID,
       ROUND(AVG(salary),2) AS sal,
       COUNT(first_name) AS 사원수
FROM employees
GROUP BY 
    CUBE(TO_CHAR(hire_date, 'YYYY'), TO_CHAR(hire_date, 'MM'))
ORDER BY year, mon;