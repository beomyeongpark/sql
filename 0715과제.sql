1. empno =
2. empno LIKE, emp.deptno 
3. dept. deptno =
4. emp.deptno, sal between
5. emp.deptno, dept.loc

1. empno
2. (emp.deptno,sal)
3. (dept.deptno,loc)
CREATE INDEX idx_nu_emp06 ON emp (deptno,sal);
CREATE INDEX idx_nu_dept01 ON dept (deptno,loc);

SELECT *
FROM TABLE(dbms_xplan.display);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7688;

EXPLAIN PLAN FOR
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND emp.deptno = 10
  AND emp. empno LIKE 7688 || '%';
  
EXPLAIN PLAN FOR
SELECT *
FROM dept
WHERE deptno = 10;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 3000
  AND deptno = 10;
  
EXPLAIN PLAN FOR
SELECT *
FROM emp,dept
WHERE emp.deptno = dept.deptno
  AND emp.deptno = 10
  AND dept.loc = '%';