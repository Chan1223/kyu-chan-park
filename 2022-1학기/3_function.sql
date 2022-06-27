---- 3��
--- ���ڿ� �Լ�
-- LOWER : �ҹ��ڷ�, INITCAP : initial �빮��, UPPER : �빮��
SELECT last_name, LOWER(last_name), INITCAP(last_name), UPPER(last_name)
FROM employees;
WHERE LOWER(last_name) = 'austin';


-- length : ���ڼ� ���, lengthb : ���� �� ����Ʈ �� �Է�, INSTR : ã�� ������ ��ġ ��ȯ(���� ��� 0 ���)
SELECT first_name, LENGTH(first_name), INSTR(first_name, 'a')
FROM employees;

-- substr : �κ� ���ڿ� ���, subtstrb : �κ� ���ڿ� ����Ʈ ���, concat : ||�� ���� ���, ���ڿ� ����
SELECT first_name, SUBSTR(first_name, 1, 3), CONCAT(first_name, last_name)
FROM employees;

-- lpad, rpad : padding ���, ���ڶ� ���ڸ� ��/����� ä��� ���� 
SELECT 
    RPAD(first_name, 10, '=') AS name,
    LPAD(salary, 10, '*') AS sal
FROM employees;

-- ltrim, rtrim : �� / �� ���� ����, Ư�� ���ڿ��� ������ ���� ������ ã�Ƽ� ������
SELECT LTRIM('JavaSpecialist', 'Jav') FROM dual;
SELECT LTRIM('       JavaSpecialist') FROM dual;
SELECT RTRIM('JavaSpecialist      ') FROM dual;

-- replace : Ư�� ���ڸ� �ٸ� ���ڷ� ��ü, translate : 2�������� ���ڿ��� 3������ ����)
SELECT REPLACE('JavaSpecialist', 'Java', 'Bigdata') FROM dual;
SELECT REPLACE('Java Specialist', ' ', '') FROM dual;
SELECT TRANSLATE('javaspecialist', 'abdert', 'ertabd') FROM dual;

--- �߰�����
-- EMPLOYEES ���̺��� JOB_ID�� it_prog�� ����� �̸��� �޿��� ����ϼ���.
-- 1) ���ϱ� ���� ���� �ҹ��ڷ� �Է��ؾ� �մϴ�.
--   (��Ʈ : LOWER �Լ� �̿�)
-- 2)  �̸��� ��  3���ڱ��� ����ϰ� �������� *��  ����մϴ�.  ��  ����  ��  ��Ī�� name�Դϴ�. 
--   (��Ʈ :  RPAD �Լ��� SUBSTR �Լ� �Ǵ� SUBSTR �Լ��� LENGTH �Լ� �̿�)
-- 3) �޿��� ��ü 10�ڸ��� ����ϵ� ������ �ڸ��� *��  ����մϴ�.  ��  ���� ��  ��Ī�� salary�Դϴ�.
--   (��Ʈ :  LPAD �Լ� �̿�)
SELECT RPAD(SUBSTR(first_name, 1, 3), 10, '*') AS name, LPAD(salary, 10, '*') AS salary
FROM employees
WHERE LOWER(job_id) = 'it_prog'; 

---- ����ǥ����
-- ���̺� ����
CREATE TABLE test_regexp(col1 VARCHAR2(10));
-- ������ ����
INSERT INTO test_regexp VALUES('ABCDE01234');
INSERT INTO test_regexp VALUES('01234ABCDE');
INSERT INTO test_regexp VALUES('abcde01234');
INSERT INTO test_regexp VALUES('01234abcde');
INSERT INTO test_regexp VALUES('1-234-5678');
INSERT INTO test_regexp VALUES('234-567890');

DROP TABLE test_regexp;

SELECT *
FROM test_regexp
WHERE REGEXP_LIKE(col1, '[0-9][a-z]');

SELECT *
FROM test_regexp
WHERE REGEXP_LIKE(col1, '[0-9]{3}-[0-9]{4}$');

-- REGEXP_INSTR
INSERT INTO test_regexp VALUES('@!=)(9&%$#');
INSERT INTO test_regexp VALUES('�ڹ�3');

SELECT col1,
    REGEXP_INSTR(col1, '[0-9]') AS data1,
    REGEXP_INSTR(col1, '%') AS data2
FROM test_regexp;

-- REGEXP_SUBSTR
SELECT col1,
    REGEXP_SUBSTR(col1, '[C-Z]+')
FROM test_regexp;

-- REGEXP_REPLACE
SELECT col1, REGEXP_REPLACE(col1, '[0-2]+', '*')
FROM test_regexp;

---�߰� ����
-- 1. EMPLOYEES ���̺��� PHONE_NUMBER ������ XXX.XXX.XXXX���� ��ȭ��ȣ�� ����մϴ�.
SELECT phone_number
FROM employees
WHERE REGEXP_LIKE(phone_number,'[0-9]{3}.[0-9]{3}.[0-9]{4}$') ;

-- 2. XXX.XXX.XXXX����  ��ȭ��ȣ�� ����  �����  �̸��� ��ȭ��ȣ�� ����ϵ� ��ȭ��ȣ �� �� 4�ڸ��� *��  ����ŷ�ؼ� ����϶�.  
--    �׸��� �� �� 4�ڸ��� ������ ����϶�.
SELECT first_name, 
    REGEXP_REPLACE(phone_number, '[0-9]{4}', '****') AS masking, 
    REGEXP_SUBSTR(phone_number, '[0-9]{4}$') AS last_numb
FROM employees
WHERE REGEXP_LIKE(phone_number, '[0-9]{3}.[0-9]{3}.[0-9]{4}');

--- �����Լ�
-- �ݿø�(ROUND)
SELECT ROUND(45.932, 2), ROUND(45.923, 0), ROUND(45.923, -1)
FROM dual;

-- ����(TRUNC)
SELECT TRUNC(45.932, 2), TRUNC(45.923, 0), TRUNC(45.923, -1)
FROM dual; 


--- ��¥ �Լ�
-- SYSDATE
SELECT SYSDATE FROM dual;
-- SYSTIMESTAMP
SELECT SYSTIMESTAMP FROM dual;

-- ��¥ ����
SELECT first_name, ROUND((SYSDATE - hire_date)/7, 2) as "weeks"
FROM employees
WHERE department_id = 50;

-- MONTHS_BETWEEN
SELECT first_name, SYSDATE, hire_date,
        MONTHS_BETWEEN(SYSDATE, hire_date) AS "work_month"
FROM employees
WHERE first_name='Diana';

-- ADD_MONTHS
SELECT first_name, hire_date, ADD_MONTHS(hire_date, 100)
FROM employees
WHERE first_name = 'Diana';

-- NEXT_DAY
SELECT SYSDATE, NEXT_DAY(SYSDATE, '��')
FROM dual;

-- LAST_DAY
SELECT SYSDATE, LAST_DAY(SYSDATE)
FROM dual;

-- ROUND, TRUNC
SELECT TRUNC(SYSDATE, 'Month')
FROM dual;

SELECT TRUNC(SYSDATE, 'Year')
FROM dual;

SELECT ROUND(TO_DATE('17/02/15'), 'Month')
FROM dual;

SELECT TRUNC(TO_DATE('17/03/06'), 'Month')
FROM dual;

--- ��ȯ �Լ�
SELECT first_name, TO_CHAR(hire_date, 'MM/YY') AS hiredmonth
FROM employees;

SELECT first_name,
        TO_CHAR(hire_date, 'YYYY"��" MM"��" DD"��"') as hiredate
FROM employees;

SELECT first_name,
        TO_CHAR(hire_date, 
                'fmDdspth "of" Month YYYY fmHH:MI:SS AM',
                'NLS_DATE_LANGUAGE = english') AS hiredate
FROM employees;

SELECT first_name, last_name, TO_CHAR(salary, '$999,999') AS salary
FROM employees
WHERE first_name = 'David';

-- �ڸ��� ���� �� ### ���� ǥ�õ�
SELECT TO_CHAR(2000000, '$999,999') AS salary
FROM dual;

SELECT first_name, last_name, salary*0.123456 SALARY1,
        TO_CHAR(salary*0.123456, '$999,999.99') salary2
FROM employees
WHERE first_name = 'David';

--- TO_NUMBER
-- ���� �߻�(���ڿ��� �νĵǱ� ����)
SELECT '$5,500.00' - 4000 FROM dual;
-- ����� �� �ڵ�
SELECT to_number('$5,500.00', '$99,999.99') - 4000 
FROM dual;

--- TO_DATE
SELECT first_name, hire_date
FROM employees
WHERE hire_date=TO_DATE('2003/06/17', 'YYYY/MM/DD');

--- NVL(Ư�� ���� null�� ��� �ٸ� ������ ��ü
SELECT first_name,
        salary + salary*NVL(commission_pct, 0) AS annual
FROM employees;

-- NVL2 : Ư�� ���� null �� �ƴϸ� 1�� ��, null�� ��� 2�� �� ���
SELECT first_name,
        NVL2(commission_pct, salary+(salary*commission_pct), salary) ann_sal
FROm employees;

--- COALESCE
SELECT first_name,
        COALESCE(salary + (salary* commission_pct), salary) AS ann_sal
FROM employees;

-- LNNVL : ����� TRUE �� FALSE ��ȯ, ����� FALSE / UNKNOWN(NULL)�̸� TRUE ��ȯ
SELECT first_name, COALESCE(salary*commission_pct, 0) AS bonus
FROM employees
WHERE LNNVL(salary*commission_pct >= 650);
--- LNNVL�̱� ������ 650 �Ʒ��� ���鸸 �����ְ� �������� COALESCE�� ���� 0���� ���.

-- DECODE: Ư�� ���� �ش��ϸ� �ش� ���� �־���
SELECT job_id, salary,
        DECODE(job_id, 'IT_PROG', salary*1.1,
                       'FI_MGR', salary*1.15,
                       'FI_ACCOUNT', salary*1.2,
                       salary)
        AS Salary
FROM employees;

-- CASE THEN: if ~ else �� ������
SELECT job_id, salary,
CASE WHEN(job_id = 'IT_PROG') THEN salary*1.1
     WHEN(job_id = 'FI_MGR') THEN salary*1.15
     WHEN(job_id = 'FI_ACCOUNT') THEN salary*1.2
     ELSE salary
END AS revised_salary
FROM employees;

--- �߰�����
-- 1~12���� ������ ���� ����϶�
SELECT 
    TO_CHAR(LAST_DAY(TO_DATE('01', 'MM')), 'DD') AS "01",
    TO_CHAR(LAST_DAY(TO_DATE('02', 'MM')), 'DD') AS "02",
    TO_CHAR(LAST_DAY(TO_DATE('03', 'MM')), 'DD') AS "03",
    TO_CHAR(LAST_DAY(TO_DATE('04', 'MM')), 'DD') AS "04",
    TO_CHAR(LAST_DAY(TO_DATE('05', 'MM')), 'DD') AS "05",
    TO_CHAR(LAST_DAY(TO_DATE('06', 'MM')), 'DD') AS "06",
    TO_CHAR(LAST_DAY(TO_DATE('07', 'MM')), 'DD') AS "07",
    TO_CHAR(LAST_DAY(TO_DATE('08', 'MM')), 'DD') AS "08",
    TO_CHAR(LAST_DAY(TO_DATE('09', 'MM')), 'DD') AS "09",
    TO_CHAR(LAST_DAY(TO_DATE('10', 'MM')), 'DD') AS "10",
    TO_CHAR(LAST_DAY(TO_DATE('11', 'MM')), 'DD') AS "11",
    TO_CHAR(LAST_DAY(TO_DATE('12', 'MM')), 'DD') AS "12"
FROM dual;

--- ��ø�Լ� : UNION, UNION ALL(�ߺ��� ���� ���), INTERSECTION, MINUS
SELECT employee_id, first_name
FROM employees
WHERE hire_date Like '04%'
UNION ALL
SELECT employee_id, first_name
FROM employees
WHERE department_id = 20;

----- �������� -----
-- 1. �̸��Ͽ� lee�� �����ϴ� ����� ��� ������ ����ϼ���
SELECT *
FROM employees
WHERE LOWER(email) LIKE '%lee%';

-- 2. �Ŵ��� ���̵� 103�� ������� �̸��� �޿�, ���� ���̵� ���.
SELECT first_name, salary, job_id
FROM employees
WHERE manager_id = 103;

-- 3. 80�� �μ��� �ٹ��ϸ鼭 ������ SA_MAN�� ����� ������ 20�� �μ��� �ٹ��ϸ鼭 �Ŵ��� ���̵� 100�λ���� ������ ����ϼ���.  
--    ������ �ϳ��� ����ؾ� �մϴ�.
SELECT *
FROM employees
WHERE (department_id = 80 AND job_id = 'SA_MAN') or (department_id = 20 AND manager_id = 100);

-- 4. ��� ����� ��ȭ��ȣ�� ###-###-#### �������� ���
SELECT TRANSLATE(phone_number, '.', '-')
FROM employees
WHERE REGEXP_LIKE(phone_number, '[0-9]{3}.[0-9]{3}.[0-9]{4}');

-- 5. ������ IT_PROG��  ����� �߿��� �޿��� 5000 �̻��� ������� 
-- �̸�(Full Name), �޿�  ���޾�,  �Ի���(2005-02-15����),  �ٹ��� �ϼ��� ����ϼ���.  
-- �̸������� �����ϸ�,�̸��� �ִ� 20�ڸ�,  ���� �ڸ��� *�� ä��� 
-- �޿� ���޾��� �Ҽ��� 2�ڸ��� ������ �ִ� 8�ڸ�,  $ǥ��,  ���� �ڸ��� 0���� ä�� ����ϼ���.
SELECT RPAD(first_name || ' ' || last_name, 20, '*') AS "Full Name", 
       TO_CHAR(salary, '$099,999.99') AS salary, 
       TO_CHAR(hire_date, 'YYYY-MM-DD') AS hire_date,
       ROUND(SYSDATE - hire_Date, 0) AS "�ٹ��ϼ�"
FROM employees
WHERE job_id = 'IT_PROG' AND salary >= 5000
ORDER BY "Full Name";

-- 6. 30��  �μ� ����� �̸�(full name)��  �޿�,  �Ի���,  ������� �ٹ� ���� ���� ����ϼ���.  
--    �̸��� �ִ� 20�ڷ� ����ϰ� �̸� �����ʿ� ���� ������ *��  ����ϼ���.  
--    �޿��� �󿩱��� �����ϰ� �Ҽ��� 2�ڸ��� ������ ��  8�ڸ��� ����ϰ� 
--    ���� �ڸ��� 0���� ä��� ���ڸ����� ,(�޸�)  ���б�ȣ�� �����ϰ�,  �ݾ� �տ� $��  �����ϵ��� ����ϼ���. 
--    �Ի����� 2005��03��15��  �������� ����ϼ���.  
--    �ٹ� ���� ���� �Ҽ��� ���ϴ� ������ ����ϼ���.  �޿��� ū ������� ���� ������ ����ϼ���.
SELECT RPAD(first_name || ' ' || last_name, 20, '*') AS fullname,
       TO_CHAR(COALESCE(salary * commission_pct, salary), '$099,999.00') AS SAL,
       TO_CHAR(hire_date, 'YYYY"��"MM"��"DD"��"') AS hire_Date,
       TRUNC((SYSDATE - hire_date) / 30) AS "�ٹ����� ��"
FROM employees
WHERE department_id = 30
ORDER BY SAL DESC;

-- 7. 80��  �μ��� �ٹ��ϸ鼭 salary��  10000���� ū  �������  �̸���  
--    �޿�  ���޾�(salary  + salary *  commission_pct)��  ����ϼ���.  
--    �̸���  Full  Name���� ����ϸ� 17�ڸ��� ����ϼ���.  ���� �ڸ��� *��  ä�켼��.  
--    �޿��� �Ҽ���  2�ڸ��� ������ ��7�ڸ��� ����ϸ�,  ���� �ڸ��� 0����  ä�켼��.  
--    �ݾ�  �տ�  $  ǥ�ø� �ϸ� �޿� ������ �����ϼ���.
SELECT RPAD(first_name || ' ' || last_name, 17, '*') AS fullname,
       TO_CHAR(salary + salary*commission_pct, '$09,999.99') AS sal
FROM employees
WHERE department_id =80 and salary > 10000
ORDER BY sal DESC;


-- 8. 60���μ� ����� �̸��� ���� ���ڸ� �������� ������� �ٹ��� �ٹ������� 5����,  10����,  15������ ǥ���ϼ���.  
--    5��~  9��  �ٹ���  ����� 5������ ǥ���մϴ�.  �������� ��Ÿ�� ǥ���մϴ�.  �ٹ������� �ٹ�������/12�� ����մϴ�.
-- DECODE ����� ���
SELECT first_name, 
       DECODE(TRUNC((MONTHS_BETWEEN(SYSDATE, hire_date) / 12) / 5),
               1, '5����',
               2, '10����',
               3, '15����', 
               '��Ÿ') AS "�ٹ�����"
FROM employees
WHERE department_id = 60;

-- CASE WHEN ELSE ����ϴ� ���
SELECT first_name AS �̸�,   
CASE WHEN TRUNC(TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date))/12) < 5 THEN '��Ÿ'
     WHEN TRUNC(TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date))/12) < 10 THEN '5����'
     WHEN TRUNC(TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date))/12) < 15 THEN '10����'
     ELSE '15����'
END AS �ٹ����
FROM employees
WHERE department_id = 60;

-- 9.Lex�� �Ի����� 1000��° �Ǵ� ����?
SELECT hire_date+ 1000
FROM employees
WHERE first_name Like 'Lex';

-- 10.5���� �Ի��� ����� �̸��� �Ի����� ����ϼ���.
SELECT first_name, hire_date
FROM employees
WHERE REGEXP_LIKE(hire_date, '/05/');

-- 11. ������ �� �̸��� �޿��� ����ϼ���.
-- ����1) �Ի��� ������ ����� ���� ���弼��. �� ���� �̸��� ��year���̰�,  ��(�Ի�⵵)�� �Ի硱�������� ����ϼ���.
-- ����2) �Ի��� ������ ����� ���� ���弼��. �� ���� �̸��� ��day���̰�,  �����ϡ��������� ����ϼ���.
-- ����3) �Ի����� 2010�� ������ ����� �޿��� 10%, 2005�� ������ ����� �޿��� 5%�� �λ��ϼ���.  
--       �� ���� �̸��� ��INCREASING_SALARY���Դϴ�.
-- ����4) INCREASING_SALARY ���� ������ �տ� ��$����ȣ�� �ٰ�, �� �ڸ����� �޸�(,)�� �־��ּ���.
SELECT first_name, 
       CASE WHEN TO_NUMBER(TO_CHAR(hire_date, 'YY')) BETWEEN 2005 and 2010 
                THEN TO_CHAR(salary*1.05, '$999,999')
            WHEN TO_NUMBER(TO_CHAR(hire_date, 'YY')) > 2010 
                THEN TO_CHAR(salary*1.1, '$999,999')
       ELSE TO_CHAR(salary, '$999,999')
       END AS increasing_salary,
       TO_CHAR(hire_date, 'YYYY"�� �Ի�"') AS year,
       TO_CHAR(hire_date, 'DAY') AS day
FROM employees;

-- 12. ����� �̸�,  �޿�,  �Ի�⵵ ,  �λ�� �޿��� ����ϼ���.
-- ����1) �Ի��� ������ ����ϼ���.  �� ���� �̸��� ��year���̰�,  ��(�Ի�⵵)�� �Ի硱�������� ����ϼ���.
-- ����2) �Ի����� 2010���� ����� �޿��� 10%, 2005���� ����� �޿��� 5%��  �λ��ϼ���.  
--       �� ���� �̸��� ��INCREASING_SALARY2���Դϴ�.
SELECT first_name,
       salary,
       TO_CHAR(hire_date, 'YYYY"�� �Ի�"') AS year,
       CASE WHEN TO_CHAR(hire_date, 'YYYY') = 2010 THEN salary * 1.1
            WHEN TO_CHAR(hire_date, 'YYYY') = 2005 THEN salary * 1.05
       ELSE salary
       END AS INCREASING_Salary2
FROM employees;

-- 13. ��ġ��� �� ��(state) ���� ���� null�̶�� ���� ���̵� ����ϼ���.
SELECT COUNTRY_ID, NVL(state_province, country_id ) AS STATE
FROM locations;