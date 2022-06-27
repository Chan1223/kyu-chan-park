---- 5장
-- 순위 함수 : RANK(중복순위 계산), DENSE_RANK(중복순위 계산 X), ROW_NUMBER
SELECT employee_id, department_id, salary,
       RANK() OVER (ORDER BY salary DESC) sal_bank,first_name,
       DENSE_RANK() OVER (ORDER BY salary DESC) sal_bank2,
       ROW_NUMBER() OVER (ORDER By salary DESC) sal_number
FROM employees
ORDER BY sal_number;

-- 가상 순위와 분포: CUME_DIST, PERCENT_RANK
SELECT employee_id, department_id, salary,
       CUME_DIST() OVER(ORDER BY salary DESC) sal_cume_dist,
       PERCENT_RANK() OVER (ORDER BY salary DESC) sal_pct_rank
FROM employees;

-- 비율 함수 : RATIO_TO_REPORT(그룹 내 비율을 정함)
SELECT first_name, salary,
       ROUND(RATIO_TO_REPORT(salary) OVER(),4) AS salary_ratio
FROM employees
WHERE job_id = 'IT_PROG';

-- 분배 함수 : NTILE(전체 데이터를 n개 구간으로 나누어 표시함, 균일하지 않으면 위에부터 추가)
SELECT employee_id, department_id, salary,
       NTILE(10) OVER(ORDER BY salary DESC) sal_quart_tile
FROM employees
WHERE department_id = 50;

-- LAG(앞에 값 가져오기), LEAD(뒤에 값 가져오기)
SELECT employee_id,
    LAG(salary,1,0) OVER (ORDER BY salary) AS lower_sal,
    salary,
    LEAD(salary,1,0) OVER (ORDER BY salary) AS higher_sal
FROM employees
ORDER BY salary;

-- LISTAGG(특정 그룹에 속하는 데이터를 한줄로 모두 보고싶을 때 사용)
SELECT department_id,
       LISTAGG(first_name, ' / ') WITHIN GROUP(ORDER BY hire_date) AS names
FROM employees
GROUP BY department_id;


--- 윈도우 절
SELECT employee_id,
       FIRST_VALUE(salary)
            OVER(ORDER BY salary
                ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) lower_sal,
       salary my_Sal, 
       LAST_VALUE(salary)
            OVER(ORDER BY salary
                ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) higher_sal
FROM employees;

--- 선형회귀 함수
-- REGR_AVGX : x가 null인 경우 무시하고 계산
SELECT 
    ROUND(AVG(salary), 2),
    REGR_AVGX(commission_pct, salary)
FROM employees;

-- REGR_COUNT : 두 인수 값이 not null인 경우 count
SELECT
    DISTINCT
        department_id,
        REGR_COUNT(manager_id, department_id)
            OVER(partition by department_id) "REGR_COUNT"
FROM employees;

-- REGR_SLOPE, REGR_INTERCEPT
SELECT 
    job_id, 
    employee_id,
    salary,
    ROUND(SYSDATE-hire_Date) as working_day,
    ROUND(REGR_SLOPE(salary, SYSDATE-hire_date)
        OVER(PARTITION BY job_id), 2) AS "REGR_SLPOE",
    ROUND(REGR_INTERCEPT(salary, SYSDATE-hire_date)
        OVER(PARTITION BY job_id), 2) AS "REGR_INTERCEPT"
FROM employees
WHERE department_id = 80
ORDER BY job_id, employee_id;

-- REGR_R2
SELECT
    DISTINCT
        job_id,
        ROUND(REGR_SLOPE(salary, 2020/01/01-hire_date)
            OVER(PARTITION BY job_id), 2) "REGR_SLOPE",
        ROUND(REGR_INTERCEPT(salary, 2020/01/01-hire_date)
            OVER(PARTITION BY job_id), 2) "REGR_INTERCEPT",
        ROUND(REGR_R2(salary, 2020/01/01-hire_date)
            OVER(PARTITION BY job_id), 2) "REGR_R2"
FROM employees
where department_id =80;

--- pivot table
--sales_data 테이블 생성
CREATE TABLE sales_data(
    employee_id     NUMBER(6),
    week_id         NUMBER(2),
    week_day        VARCHAR2(10),
    sales           NUMBER(8, 2)
);

INSERT INTO sales_data values(1101, 4, 'SALES_MON', 100); 
INSERT INTO sales_data values(1101, 4, 'SALES_TUE', 150); 
INSERT INTO sales_data values(1101, 4, 'SALES_WED', 80); 
INSERT INTO sales_data values(1101, 4, 'SALES_THU', 60); 
INSERT INTO sales_data values(1101, 4, 'SALES_FRI', 120); 
INSERT INTO sales_data values(1102, 5, 'SALES_MON', 300); 
INSERT INTO sales_data values(1102, 5, 'SALES_TUE', 300); 
INSERT INTO sales_data values(1102, 5, 'SALES_WED', 230); 
INSERT INTO sales_data values(1102, 5, 'SALES_THU', 120); 
INSERT INTO sales_data values(1102, 5, 'SALES_FRI', 150);
commit; 

select * from sales_data;

--sales 테이블 생성
CREATE TABLE sales(
    employee_id         NUMBER(6),
    week_id             NUMBER(2),
    sales_mon           NUMBER(8, 2),
    sales_tue           NUMBER(8, 2),
    sales_wed           NUMBER(8, 2),
    sales_thu           NUMBER(8, 2),
    sales_fri           NUMBER(8, 2)
);

INSERT INTO sales VALUES(1101, 4, 100, 150, 80, 60, 120);
INSERT INTO sales VALUES(1102, 5, 300, 300, 230, 120, 150);
COMMIT; 
SELECT * FROM sales;

--- pivot
SELECT *
FROM sales_data
PIVOT
(
    SUM(sales)
    FOR week_day IN('SALES_MON' AS sales_mon,
                    'SALES_TUE' AS sales_tue,
                    'SALES_WED' AS sales_wed,
                    'SALES_THU' AS sales_thu,
                    'SALES_FRI' AS sales_fri)
)
ORDER BY employee_id, week_id;

-- sales를 sale_data 처럼 표현하기
-- 정말 많은 데이터를 가져와야 할 때, 미리 SQL에서 처리해야할 때 사용
SELECT employee_id, week_id, week_day, sales
FROM sales
UNPIVOT
(
 sales
 FOR week_day
 IN(sales_mon, sales_tue, sales_wed, sales_thu, sales_fri)
);


-- 1.모든 사원의 부서 번호, 이름, 급여, 부서별 급여 순위를 출력하세요. 
--   중복순위 사원이 있으면 차순위는 없습니다. 
--   이 결과에 이전 순위 사원의 급여를 추가하여 출력하세요.
SELECT department_id,
       first_name, 
       salary,
       RANK() 
              OVER(ORDER BY department_id DESC) rank,
       LAG(salary, 1, 0)
              OVER(ORDER BY salary DESC) prev,
       FIRST_VALUE(salary)
              OVER( PARTITION BY department_id
                    ORDER BY salary DESC
                    ROWS 1 PRECEDING) AS prev1,
       LEAD(salary, 1, 0)
              OVER(ORDER BY salary DESC) post
FROM employees
ORDER BY department_id;

-- 2. 170번 사원의 사원번호 직전 사원의 이름을 출력하세요
SELECT first_name
FROM employees
WHERE employee_id =(
    SELECT before_id
    FROM
        (
        SELECT employee_id,
        LAG(employee_id, 1, 0) OVER (ORDER BY employee_id) AS before_id
        FROM employees
        )
    WHERE employee_id = 170
    );
    
-- 3. 모든 사원의 급여 정보를 출력하세요. 
-- 출력할 때 각 사원이 근무하는 부서의 가장 적은 급여, 그리고 가장 큰 급여, 
-- 그리고 부서에서 급여가 가장 많은 사원과의 급여 차이를 출력하세요.
SELECT employee_id, department_id,
       FIRST_VALUE(salary)
            OVER(PARTITION BY department_id
                 ORDER BY salary
                 ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS lower_sal,
      salary AS my_sal,
      LAST_VALUE(salary)
            OVER(PARTITION BY department_id
                 ORDER BY salary
                 ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS higher_sal,
      LAST_VALUE(salary)
            OVER(PARTITION BY department_id
                 ORDER BY salary
                 ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) - salary AS diff_sal                 
FROM employees;