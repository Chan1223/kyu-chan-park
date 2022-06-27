--- 4��
-- AVG, SUM, MIN, MAX
SELECT AVG(salary), MAX(salary), MIN(salary), SUM(salary)
FROM employees
WHERE job_id LIKE 'SA%';

-- ��¥
SELECT MIN(hire_date), MAX(hire_date)
FROM employees;

-- �ؽ�Ʈ
SELECT MIN(first_name), MAX(last_name)
FROM employees;
-- Ư������>����>����(�빮��)>����(�ҹ���)>�ѱ� ������ �ν�
-- ASCII CODE �����̱� ����

-- ���� ����
SELECT MAX(salary)
FROM employees;

--- COUNT
SELECT COUNT(*) FROM employees;
SELECT COUNT(commission_pct) FROM employees;

--- STDDEV, VARIANCE
SELECT SUM(salary) �հ�,
       ROUND(AVG(salary), 2) ���,
       ROUND(STDDEV(salary), 2) ǥ������,
       ROUND(VARIANCE(salary), 2) �л�
FROM employees;

-- �׷��Լ��� null ��: count(*)�� ������ ��� �׷� �Լ��� ���� �ִ� null���� ���꿡�� ������
SELECT
    ROUND(SUM(salary * commission_pct), 2) sum_bonus,
    COUNT(*) count,
		-- �ܼ� AVG�� �� ��� null���� ��� count�� ���ܵǰ� ����� ������ ���� Ŀ��
    ROUND(AVG(salary * commission_pct), 2) avg_bonus1,
		-- ������ count(*)�� ����� null���� ��� �����͸� �����Ͽ� ������ ��
    ROUND(SUM(salary * commission_pct)/count(*), 2) avg_bonus2,
		-- NVL ������� ������ ���� ���� �� ������ Ȯ��
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

-- �μ��� �Ҽ� ����� ���� �˰� ���� ��
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

-- GROUPING : null���� ��� 1�� �������.
SELECT
    DECODE(GROUPING(department_id), 1, '�Ұ�',
           TO_CHAR(department_id)) AS �μ�,
    DECODE(GROUPING(job_id), 1, '�Ұ�', job_id) AS ����,
    ROUND(AVG(salary),2) AS ���,
    COUNT(*) AS ����Ǽ�
FROM employees
GROUP BY CUBE(department_id, job_id)
ORDER BY �μ�, ����;

-- GROUPING_ID
SELECT
    DECODE(GROUPING_ID(department_id, job_id),
           2, '�Ұ�', 3, '�հ�',
           TO_CHAR(department_id)) AS �μ���ȣ,
    DECODE(GROUPING_ID(department_id, job_id),
           1, '�Ұ�', 3, '�հ�',
           job_id) AS ����,
    GROUPING_ID(department_id, job_id) AS GID,
    ROUND(AVG(salary), 2) AS ���,
    COUNT(*) AS ����Ǽ�
FROM employees
GROUP BY CUBE(department_id, job_id)
ORDER BY �μ���ȣ, ����;


-- 1. ������ �޿� ����� ����ϼ���.
SELECT job_id, AVG(salary)
FROM employees
GROUP BY job_id;

-- 2. �μ��� ����� ���� ����ϼ���.
SELECT department_id, COUNT(first_name)
FROM employees
GROUP BY department_id
ORDER BY department_id;

-- 3. �μ���, ������ ����� ���� ���� ����ϼ���.
SELECT department_id, job_id, COUNT(first_name)
FROM employees
GROUP BY GROUPING SETS(department_id, job_id)
ORDER BY department_id, job_id;

-- 4. �μ��� �޿� ǥ�������� ����ϼ���.
SELECT department_id, ROUND(STDDEV(salary), 2)
FROM employees
GROUP BY department_id;

-- 5. ����� ���� 4�� �̻��� �μ��� ���̵�� ����� ���� ����ϼ���.
SELECT department_id, count(first_name)
FROM employees
GROUP BY department_id
HAVING count(first_name) >= 4;

-- 6. 50���μ��� ������ ����� ���� ����ϼ���.
SELECT job_id, count(first_name)
FROM employees
WHERE department_id = 50
GROUP BY job_id;

-- 7. 50�� �μ����� ������ ����� ���� 10�� ������ �������̵�� ����� ���� ����ϼ���.
SELECT job_id, count(first_name)
FROM employees
WHERE department_id = 50
GROUP BY job_id
HAVING count(first_name) <= 10;

-- 8. ������ �� �Ի�⵵ ���� ������� �޿� ��հ� ������� ����ϼ���.
-- ����1) �Ի�⵵�� ���� ������ �����ϼ���.
SELECT TO_CHAR(hire_date, 'YYYY') AS hire, ROUND(AVG(salary), 2) �޿����, count(first_name) �����
FROM employees
GROUP BY TO_CHAR(hire_date, 'YYYY')
ORDER BY hire;

-- 9. ������ �� �Ի�⵵�� �Ի�� ���� ������� �޿� ��հ� ������� ����ϼ���.
-- ����1) �Ի�⵵�� ���� ������ ������ ����,  �Ի�⵵�� ���ٸ� �Ի���� �������� �����ϼ���.
-- ����2) �Ի�⵵�� �������� �޿���հ� ������� �� �հ踦 ���ϼ���.
SELECT TO_CHAR(hire_date, 'YYYY') year,
       TO_CHAR(hire_date, 'MM') mon,
       ROUND(AVG(salary), 2),
       count(first_name)
FROM employees
GROUP BY CUBE(TO_CHAR(hire_date, 'YYYY'), TO_CHAR(hire_date, 'MM'))
ORDER BY year, mon;

-- 10. ������ �� �Ի�⵵�� �Ի�� ���� ������� �޿� ��հ� ������� ����ϼ���.
-- ����1) �Ի�⵵�� ���� ������ ������ ����, �Ի�⵵�� ���ٸ� �Ի���� �������� �����ϼ���
-- ����2) �Ի�⵵�� �Ի���� �������� �޿���հ� ������� ��  �հ踦 ���ϼ���.  
--       ��,  �Ի�⵵�� �հ�� ���հ衯,  �Ի���� �հ�� ���Ұ衯,  �Ի���� ��ü �հ�� ���հ衯�� ����ϼ���.
SELECT DECODE(GROUPING(TO_CHAR(hire_date, 'YYYY')),
              1, '�հ�', TO_CHAR(hire_date, 'YYYY')) year,
       DECODE(GROUPING_ID(TO_CHAR(hire_date, 'YYYY'), TO_CHAR(hire_date, 'MM')),
              1, '�Ұ�',
              3, '�հ�', TO_CHAR(hire_date, 'MM')) mon,
       ROUND(AVG(salary), 2) �޿�,
       COUNT(first_name) �����
FROM employees
GROUP BY CUBE(TO_CHAR(hire_date, 'YYYY'), TO_CHAR(hire_date, 'MM'))
ORDER BY year, mon;

-- 11. ������ �� �Ի�⵵�� �Ի�� ���� ������� �޿� ��հ� ������� ����ϼ��� .
-- ����1) �Ի�⵵�� ���� ������ ������ ����, �Ի�⵵�� ���ٸ� �Ի� ���� �������� �����ϼ���.
-- ����2) �Ի�⵵�� �Ի���� �������� �޿���հ� ������� �� �հ踦 ���ϼ��� . 
--       ��, �Ի�⵵�� �հ�� ���Ұ衯, �Ի���� �հ�� ���հ衯�� ����ϼ���.
-- ����3) 2�� �̻��� ���� ���� ���踦 Ȯ���ϴ� GROUPING_ID �� �� ����ϼ��� . �� ���� �̸��� ��GID���Դϴ�.
SELECT DECODE(GROUPING(TO_CHAR(hire_date, 'YYYY')),
              1, '�Ұ�', TO_CHAR(hire_date, 'YYYY'))AS year,
       DECODE(GROUPING(TO_CHAR(hire_date, 'MM')),
              1, '�հ�', TO_CHAR(hire_date, 'MM')) AS mon,
       GROUPING_ID(TO_CHAR(hire_date, 'YYYY'), TO_CHAR(hire_date, 'MM')) AS GID,
       ROUND(AVG(salary),2) AS sal,
       COUNT(first_name) AS �����
FROM employees
GROUP BY 
    CUBE(TO_CHAR(hire_date, 'YYYY'), TO_CHAR(hire_date, 'MM'))
ORDER BY year, mon;