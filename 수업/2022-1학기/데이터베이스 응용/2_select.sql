---- 1��
SELECT COUNT (*) FROM employees;

---- 2��
-- ���̺� Ȯ���ϱ�
DESC employees;

-- ���̺� �� �빮�ڷ� �����
SELECT first_name "EMployee Name", 
       salary*12 "Annual Salaray"
FROM employees;

-- ||�� �̿��� join
SELECT first_name || ' ' || last_name || '''s salary is $' || salary AS "Employee Details"
FROM employees;

-- DISTINCT�� Ȱ���Ͽ� �ߺ� �� �����ϰ� ǥ��
SELECT DISTINCT department_id
FROM employees;

-- ROWID, ROWNUM �ǻ翭(Pseudo column)
SELECT ROWID, ROWNUM, employee_id, first_name
FROM employees;

-- WHERE��
SELECT first_name, job_id, department_id
FROM employees
WHERE job_id= 'IT_PROG';

SELECT first_name, last_name, hire_date
FROM employees
WHERE last_name = 'King';

-- WHERE ���� �̿��� �񱳿����� ���
SELECT first_name, salary, hire_date
FROM employees
WHERE salary >= 15000;

SELECT first_name, salary, hire_date
FROM employees
WHERE hire_date = '04/01/30';

SELECT first_name, salary, hire_date
FROM employees
WHERE first_name = 'Steven';

-- BETWEEN ������
SELECT first_name, salary
FROM employees
WHERE salary BETWEEN 10000 AND 12000;

SELECT first_name, salary
FROM employees
WHERE hire_date BETWEEN '03/01/01' AND '03/12/13';

SELECT first_name, salary, hire_date
FROM employees
WHERE first_name BETWEEN 'A' AND 'Bzzzzzzzzzz';

-- IN ������
SELECT employee_id, first_name, salary, manager_id
FROM employees
WHERE manager_id IN(101, 102, 103);

SELECT first_name, last_name, job_id, department_id
FROM employees
WHERE job_id IN ('IT_PROG', 'FI_MGR', 'AD_VP');

-- LIKE ������
SELECT first_name, last_name, department_id
FROM employees
WHERE job_id like 'IT%';

-- %�� ���ڰ� ���ų� �ϳ� �̻��� ���� ��Ÿ��
SELECT first_name, hire_date
FROM employees
WHERE hire_date LIKE '03%';

-- _�� �� ���ڰ� ������ ��Ÿ��
SELECT first_name, email
FROM employees
WHERE email LIKE '_A%';

-- ESCAPE ���ڸ� ����ؼ� ���ϵ�ī�� ���ڸ� ���ڿ� ��ü�� �νĽ�Ű�� ����
SELECT first_name, job_id
FROM employees
WHERE job_id Like 'SA\_M%' ESCAPE '\';

-- IS NULL ������
-- IS NULL ���
SELECT first_name, manager_id
FROM employees
WHERE manager_id IS NULL;

-- IS NOT NULL ���
SELECT first_name, manager_id, commission_pct
FROM employees
WHERE commission_pct IS NOT NULL;

--- �� ������
-- AND ���
SELECT first_name, job_id, salary
FROM employees
WHERE job_id = 'IT_PROG' AND salary >= 5000;

-- OR ���
SELECT first_name, job_id, salary
FROM employees
WHERE job_id = 'IT_PROG' OR salary >= 5000;

-- OR ����  AND�� �켱������ ���� ������ �̻��ϰ� ���� �� ����.
SELECT first_name, job_id, salary
FROM employees
WHERE job_id = 'IT_PROG'
OR job_id = 'FI_MGR'
AND salary >= 6000;
-- �� �ڵ�� job_id �� FI_MGR �̸鼭 salary �� 6000�� �Ѵ� ���� + job_id�� IT_PROG �� �ο��� ����� ������ ��

--- ����� �� �ڵ�
SELECT first_name, job_id, salary
FROM employees
WHERE (job_id = 'IT_PROG' OR job_id = 'FI_MGR')
AND salary >= 6000;

--- ������ ����
-- �������� ����(default)
SELECT first_name, hire_date
FROM employees
ORDER BY hire_date;

-- �������� ����(DESC ���)
SELECT first_name, hire_date
FROM employees
ORDER BY hire_date DESC;

-- �Ʒ� 3�� ���� ��� ������ ����� ���(salary*12, annual, 2)
SELECT first_name, salary *12 AS annual
FROM employees
ORDER BY salary*12;

SELECT first_name, salary *12 AS annual
FROM employees
ORDER BY annual;

SELECT first_name, salary *12 AS annual
FROM employees
ORDER BY 2;

---- �������� -----
-- 1. ��� ����� �����ȣ, �̸�, �Ի���, �޿��� ����ϼ���.
SELECT employee_id, first_name, hire_date, salary
FROM employees;

-- 2. ��� ����� �̸��� ���� �ٿ� ����ϼ���. �� ��Ī�� name���� �ϼ���. 
SELECT first_name || ' ' || last_name AS name
FROm employees;

-- 3. 50�� �μ� ����� ��� ������ ����ϼ���. 
SELECT *
FROM employees
WHERE department_id = 50;

SELECT *
FROM employees
WHERE department_id LIKE 50;

-- 4. 50�� �μ� ����� �̸�, �μ���ȣ, �������̵� ����ϼ���. 
SELECT first_name, department_id, job_id
FROM employees
WHERE department_id = 50;

-- 5. ��� ����� �̸�, �޿� �׸��� 300�޷� �λ�� �޿��� ����ϼ���. 
SELECT first_name, salary, salary + 300
FROM employees;

-- 6. �޿��� 10000���� ū ����� �̸��� �޿��� ����ϼ���. 
SELECT first_name, salary
FROM employees
WHERE salary >= 10000;

-- 7. ���ʽ��� �޴� ����� �̸��� ����, ���ʽ����� ����ϼ���. 
SELECT first_name, job_id, commission_pct
FROM employees
WHERE commission_pct IS NOT NULL;

-- 8. 2003�⵵ �Ի��� ����� �̸��� �Ի��� �׸��� �޿��� ����ϼ���.(BETWEEN ������ ���) 
SELECT first_name, hire_date, salary
FROM employees
WHERE hire_date BETWEEN '03/01/01' and '03/12/31';

SELECT first_name, hire_date, salary
FROM employees
WHERE hire_date BETWEEN '2003/01/01' AND '2003/12/31';

-- 9. 2003�⵵ �Ի��� ����� �̸��� �Ի��� �׸��� �޿��� ����ϼ���.(LIKE ������ ���) 
SELECT first_name, hire_date, salary
FROM employees
WHERE hire_date LIKE '03%';

SELECT first_name, hire_date, salary
FROM employees
WHERE hire_date LIKE '03/%';

-- 10. ��� ����� �̸��� �޿��� �޿��� ���� ������� ���� ��������� ����ϼ���. 
SELECT first_name, salary
FROM employees
ORDER BY salary DESC;

-- 11. �� ���Ǹ� 60�� �μ��� ����� ���ؼ��� �����ϼ���. 
SELECT first_name, salary
FROM employees
WHERE department_id = 60
ORDER BY salary DESC;

-- 12. �������̵� IT_PROG �̰ų�, SA_MAN�� ����� �̸��� �������̵� ����ϼ���. 
SELECT first_name, job_id
FROM employees
WHERE (job_id = 'IT_PROG') or (job_id = 'SA_MAN');

-- 13. Steven King ����� ������ ��Steven King ����� �޿��� 24000�޷� �Դϴ١� �������� ����ϼ���. 
SELECT first_name || ' ' || last_name || ' ����� �޿��� ' || salary || '�޷� �Դϴ�' AS result
FROM employees
WHERE first_name = 'Steven' AND last_name = 'King';

-- 14. �Ŵ���(MAN) ������ �ش��ϴ� ����� �̸��� �������̵� ����ϼ���. 
SELECT first_name, job_id
FROM employees
WHERE job_id LIKE '%MAN%';

-- 15. �Ŵ���(MAN) ������ �ش��ϴ� ����� �̸��� �������̵� �������̵� ������� ����ϼ���.
SELECT first_name, job_id
FROM employees
WHERE job_id LIKE '%MAN'
ORDER BY job_id;