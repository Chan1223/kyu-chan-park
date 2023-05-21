---- 5��
-- ���� �Լ� : RANK(�ߺ����� ���), DENSE_RANK(�ߺ����� ��� X), ROW_NUMBER
SELECT employee_id, department_id, salary,
       RANK() OVER (ORDER BY salary DESC) sal_bank,first_name,
       DENSE_RANK() OVER (ORDER BY salary DESC) sal_bank2,
       ROW_NUMBER() OVER (ORDER By salary DESC) sal_number
FROM employees
ORDER BY sal_number;

-- ���� ������ ����: CUME_DIST, PERCENT_RANK
SELECT employee_id, department_id, salary,
       CUME_DIST() OVER(ORDER BY salary DESC) sal_cume_dist,
       PERCENT_RANK() OVER (ORDER BY salary DESC) sal_pct_rank
FROM employees;

-- ���� �Լ� : RATIO_TO_REPORT(�׷� �� ������ ����)
SELECT first_name, salary,
       ROUND(RATIO_TO_REPORT(salary) OVER(),4) AS salary_ratio
FROM employees
WHERE job_id = 'IT_PROG';

-- �й� �Լ� : NTILE(��ü �����͸� n�� �������� ������ ǥ����, �������� ������ �������� �߰�)
SELECT employee_id, department_id, salary,
       NTILE(10) OVER(ORDER BY salary DESC) sal_quart_tile
FROM employees
WHERE department_id = 50;

-- LAG(�տ� �� ��������), LEAD(�ڿ� �� ��������)
SELECT employee_id,
    LAG(salary,1,0) OVER (ORDER BY salary) AS lower_sal,
    salary,
    LEAD(salary,1,0) OVER (ORDER BY salary) AS higher_sal
FROM employees
ORDER BY salary;

-- LISTAGG(Ư�� �׷쿡 ���ϴ� �����͸� ���ٷ� ��� ������� �� ���)
SELECT department_id,
       LISTAGG(first_name, ' / ') WITHIN GROUP(ORDER BY hire_date) AS names
FROM employees
GROUP BY department_id;


--- ������ ��
SELECT employee_id,
       FIRST_VALUE(salary)
            OVER(ORDER BY salary
                ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) lower_sal,
       salary my_Sal, 
       LAST_VALUE(salary)
            OVER(ORDER BY salary
                ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) higher_sal
FROM employees;

--- ����ȸ�� �Լ�
-- REGR_AVGX : x�� null�� ��� �����ϰ� ���
SELECT 
    ROUND(AVG(salary), 2),
    REGR_AVGX(commission_pct, salary)
FROM employees;

-- REGR_COUNT : �� �μ� ���� not null�� ��� count
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
--sales_data ���̺� ����
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

--sales ���̺� ����
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

-- sales�� sale_data ó�� ǥ���ϱ�
-- ���� ���� �����͸� �����;� �� ��, �̸� SQL���� ó���ؾ��� �� ���
SELECT employee_id, week_id, week_day, sales
FROM sales
UNPIVOT
(
 sales
 FOR week_day
 IN(sales_mon, sales_tue, sales_wed, sales_thu, sales_fri)
);


-- 1.��� ����� �μ� ��ȣ, �̸�, �޿�, �μ��� �޿� ������ ����ϼ���. 
--   �ߺ����� ����� ������ �������� �����ϴ�. 
--   �� ����� ���� ���� ����� �޿��� �߰��Ͽ� ����ϼ���.
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

-- 2. 170�� ����� �����ȣ ���� ����� �̸��� ����ϼ���
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
    
-- 3. ��� ����� �޿� ������ ����ϼ���. 
-- ����� �� �� ����� �ٹ��ϴ� �μ��� ���� ���� �޿�, �׸��� ���� ū �޿�, 
-- �׸��� �μ����� �޿��� ���� ���� ������� �޿� ���̸� ����ϼ���.
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