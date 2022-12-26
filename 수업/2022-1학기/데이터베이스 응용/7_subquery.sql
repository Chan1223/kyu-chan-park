--- 7��
-- nancy ���� �޿��� ���� �޴� ���
SELECT first_name, salary
FROM employees
WHERE salary > (SELECT salary
                FROM   employees
                WHERE first_name = 'Nancy');

--- ���� �� ��������
-- 103�� ����� ������ ���� ����� �̸�, ���� ,�Ի��� ���                
SELECT first_name, job_id, hire_date
FROM employees
WHERE job_id = (SELECT job_id
                FROM employees
                WHERE employee_id = 103);
-- ���� �� ��������
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

-- ��ȣ���� ��������                        
SELECT first_name, salary
FROM employees a
WHERE salary > (SELECT avg(salary)
                FROM employees b
                WHERE b.department_id = a.department_id);

-- ��Į�� ��������                
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

-- �ζ��� ��
SELECT row_number, first_name, salary
FROM (SELECT frist_name, salary,
             row_number() OVER (ORDER BY salary DESC) AS row_number
             FROM employees)
WHERE row_number BETWEEN 1 AND 10;

-- 3�� ����
SELECT rownum, first_name, salary
FROM (SELECT first_name, salary
      FROM employees
      ORDER BY salary DESC)
WHERE rownum BETWEEN 1 AND 10;

-- rownum�� 1����� �����͸� �б� ������ �߰����� �о�� �� ����
SELECT rownum, first_name, salary
FROM (SELECT first_name, salary
      FROM employees
      ORDER BY salary DESC)
WHERE rownum BETWEEN 11 AND 20;

--- 3�� ����
SELECT rnum, first_name, salary
FROM (SELECT first_name, salary, rownum AS rnum
      FROM (SELECT first_name, salary
            FROM employees
            ORDER BY salary DESC)
      )
WHERE rnum BETWEEN 11 AND 20;

-- �м��Լ��� �� ������ �����ϰ� ���� ����
SELECT row_number, first_name, salary
FROM (SELECT first_name, salary,
      row_number() OVER (ORDER BY salary DESC) AS row_number
      FROM employees)
WHERE row_number BETWEEN 11 AND 20;

-- FETCH ���� �̿��ؼ� �ۼ��ϴ°� �����ս������� �� ����
SELECT first_name,salary
FROM employees
ORDER BY salary DESC
OFFSET 10 ROWS
FETCH FIRST 10 ROWS ONLY;
-- FEST FIRST 10 PERCENT ROWS ONLY ��� �ۼ��� �� ����(10�ۼ�Ʈ�� �ش��ϴ� �� �ҷ�����)


--- ������ ����
SELECT employee_id,
       LPAD(' ', 3*(LEVEL-1)) || first_name || ' ' || last_name,
       LEVEL
FROM employees
START WITH manager_id IS NULL
CONNECT BY PRIOR employee_id = manager_id;

-- ���� �Ŵ����� ���� ������� �̸������� �����ؼ� ���
SELECT employee_id,
       LPAD(' ', 3*(LEVEL-1)) || first_name || ' ' || last_name,
       LEVEL
FROM employees
START WITH manager_id IS NULL
CONNECT BY PRIOR employee_id = manager_id
ORDER BY first_name;

-- ���� ���� �뵵�� Ȱ�� ����
SELECT employee_id,
       LPAD(' ', 3*(LEVEL-1)) || first_name || ' ' || last_name,
       LEVEL
FROM employees
START WITH employee_id = 113
CONNECT BY PRIOR manager_id = employee_id;

------ �������� ------
-- 1. 20�� �μ��� �ٹ��ϴ� ������� �Ŵ����� �Ŵ����� ���� ������� ������ ����ϼ���.
SELECT *
FROM employees
WHERE manager_id = ANY (SELECT manager_id
                    FROM employees
                    WHERE department_id = 50);
-- 2. ���� ���� �޿��� ���� ����� �̸��� ����ϼ���.
SELECT first_name
FROM employees
WHERE salary = (SELECT max(salary)
                FROM employees);

-- 3. �޿� ������(��������)  3������ 5������ ����ϼ���.(rownum �̿�)
SELECT rnum, first_name, salary
FROM (SELECT rownum AS rnum, first_name, salary
      FROM (SELECT first_name, salary
            FROM employees
            ORDER BY salary DESC)
      )
WHERE rnum BETWEEN 3 AND 5;

-- 4. . �μ��� �μ��� ����̻� �޿��� �޴� ����� �μ���ȣ,  �̸�,  �޿�,  ��ձ޿��� ����ϼ���
SELECT department_id, first_name, salary, 
    (SELECT ROUND(AVG(salary),2)
     FROM employees e
     WHERE e.department_id = a.department_id ) AS avg_sal
FROM employees a
WHERE salary >= (SELECT AVG(salary)
                 FROM employees b
                 WHERE b.department_id = a.department_id)
ORDER BY department_id;
