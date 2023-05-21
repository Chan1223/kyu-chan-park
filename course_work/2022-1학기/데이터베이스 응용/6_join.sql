---- 6��
SELECT first_name, employees.department_id, department_name
FROM employees, departments;

SELECT e.first_name, e.department_id, d.department_name
FROM employees e, departments d;

--- ����Ŭ ����
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
-- cross join : īƼ�� ���δ�Ʈ�� ����, �ǵ��� ������ ������ �ƴϸ� ������� �ʴ� ���� �ٶ�����.
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

-- ��� ����� �̸��� �μ� �̸�, �ּ� ���
SELECT e.first_name, d.department_name,
    l.street_address || ',' || l.city || ',' || l.state_province AS address
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN locations l ON d.location_id = l.location_id;

---- where ���� ȥ��
-- 103�� �μ� ����� �̸��� �μ� �̸� ���
SELECT e.first_name AS name,
       d.department_name AS department
FROM employees e
JOIN departments d
ON   e.department_id = d.department_id
WHERE employee_id = 103;

-- 103�� �μ� ����� �̸�, �μ� �̸�, �ּ� ���
SELECT e.first_name AS name, d.department_name AS department,
       l.street_address || ',' || l.city || ',' || l.state_province
       AS address
FROM employees e
JOIN departments d
ON   e.department_id = d.department_id
JOIN locations l
ON   d.location_id = l.location_id
WHERE employee_id = 103;

----- ON ���� WHERE �߰� : ���� ��� ���� ����
-- 1�� ��� 
SELECT e.first_name AS name, d.department_name AS department,
       l.street_address || ',' || l.city || ',' || l.state_province
       AS address
FROM employees e
JOIN departments d
ON   e.department_id = d.department_id
JOIN locations l
ON   d.location_id = l.location_id AND employee_id = 103;

-- 2�� ���
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


---- �������� ----
-- 1.  John ����� �̸��� �μ��̸�,  �μ���ġ (city)��  ����ϼ���.(����Ŭ����,  �Ƚ����� ���� �� �� �ۼ��ϼ���)
-- (����Ŭ ����)
SELECT first_name, department_name, city
FROM employees e, departments d, locations l
WHERE e.department_id = d.department_id AND d.location_id = l.location_id;

-- (�Ƚ� ����)
SELECT first_name, department_name, city
FROM employees e
JOIN departments d ON  e.department_id = d.department_id
JOIN locations l ON d.location_id = l.location_id;

-- 2. 103��  ����� �����ȣ ,  �̸�,  �޿�,  �Ŵ����̸� , �Ŵ��� �޿� �Ŵ��� �μ��̸��� ����ϼ���.(�Ƚ��������� �ۼ��ϼ���)
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

-- 3. 90���μ� ������� ���,  �̸�,  �޿�,  �Ŵ����̸�,  �Ŵ����޿�,  �Ŵ����μ��̸��� ����ϼ���.
--   (����Ŭ ���ΰ� �Ƚ����� ���� �� �� �ۼ��ϼ���)
-- (����Ŭ ����)
SELECT e.employee_id, e.first_name, e.salary,
       m.first_name, m.salary,d.department_name
FROM employees e, employees m, departments d
WHERE e.manager_id = m.employee_id(+) 
  AND e.department_id = d.department_id(+)
  AND e.department_id = 90;

-- (�Ƚ� ����)
SELECT e.employee_id, e.first_name, e.salary,
       m.first_name, m.salary,d.department_name
FROM employees e
LEFT OUTER JOIN employees m ON e.manager_id = m.employee_id
LEFT OUTER JOIN departments d ON e.department_id = d.department_id
WHERE e.department_id = 90;

-- 4. 103������� �ٹ��ϴ� ���ô�?(�Ƚ� ���� �������� �ۼ��ϼ��� )
SELECT e.employee_id, CITY
FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    JOIN locations l ON d.location_id = l.location_id
WHERE employee_id = 103;

-- 5. �����ȣ�� 103�λ���� �μ���ġ (city)��  �Ŵ����� �����̸� (job_title)��  ����ϼ���.(�Ƚ� ���� �������� �ۼ��ϼ���)
SELECT e.employee_id, city, job_title
FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    JOIN locations l ON d.location_id = l.location_id
    JOIN employees m ON e.manager_id =m.employee_id
    JOIN jobs j ON m.job_id = j.job_id
WHERE e.employee_id = 103;

-- 6. ����� ���  ������ ��ȸ�ϴ� �������� �ۼ��ϼ���.  ����� �μ���ȣ�� �μ��̸�����,
--    �������̵�� �����̸�����,  �Ŵ������̵�� �Ŵ����̸����� ����ϼ���.
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


-- 7. ���� �� ������ �ִ� ������?
--> ���̺� ��Ī�� �� ���¿����� ���̺� ���� �״�� ����� �� ����.
