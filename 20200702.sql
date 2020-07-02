GROUP BY 함수 특징
1. NULL은 그룹함수 연산에서 제외가 된다
부서번호별 사원의 sal,comm 칼럼의 총 합을 구하기

SELECT deptno, SUM(sal + comm), SUM(sal + NVL(comm,0)), SUM(sal) + SUM(comm)
FROM emp
GROUP BY deptno;

NULL 처리의 효율 
SELECT deptno, SUM(sal + comm), SUM(sal) + SUM(comm), SUM(sal) + NVL(SUM(comm),0), SUM(sal)  + SUM(NVL(comm,0))
FROM emp
GROUP BY deptno;

3. DECODE or CASE 안에 3중첩 하지말아라(칠거지악)
 인라인뷰 남발하지마라 (칠거지악)
인라인뷰 안쓸수 있으면 안쓰는게 좋음
가독성 떨어지고 길어짐
--실습
SELECT MAX(sal), MIN(sal), ROUND(AVG(sal),2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
FROM emp;

SELECT deptno, MAX(sal), MIN(sal), ROUND(AVG(sal),2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
FROM emp
GROUP BY deptno;


SELECT DECODE(deptno, 30, 'SALES', 20, 'RESEARCH', 10, 'ACCOUNTING') dname, MAX(sal), MIN(sal), ROUND(AVG(sal),2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
FROM emp
GROUP BY deptno;

SELECT TO_CHAR(hiredate,'YYYYMM') hire_yyyymm, COUNT(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate,'YYYYMM');

SELECT TO_CHAR(hiredate,'YYYY') hire_yyyy, COUNT(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate,'YYYY');

SELECT COUNT(*) cnt
FROM dept;

SELECT COUNT(*) cnt
FROM (SELECT deptno
      FROM emp
      GROUP BY deptno);

SELECT COUNT(COUNT(deptno))
FROM emp
GROUP BY deptno;


SELECT SUM(sal)
FROM emp
GROUP BY deptno;

---
JOIN : 컬럼을 확장하는 방법 (데이터를 연결), 다른 테이블의 컬럼을 가져온다.
RDBMS가 중복을 최소화 하는 구조이기 떄문에 하나의 테이블에 데이터를 전부 담지 않고 목적에 맞게 설계한 테이블에 데이터가 분산이된다.
하지만 데이터를 조회 할 떄 다른 테이블의 데이터를 연결하여 하나행 컬럼을 가져올 수 있다.

ANSI-SQL : American National Standards Institute - SQL
ORACLE-SQL 문법 

JOIN : ANSI-SQL, ORACLE SQL의 차이가 다소 발생

ANSI-SQL join
NATURAL JOIN : 조인하고자 하는 테이블간 컬럼명이 동일할 경우 해당 컬럼으로 행을 연결 , 컬럼 이름뿐만 아니라 데이터 타입도 동일해야함.
문법
SELECT 컬럼...
FROM 테이블1 NATURAL JOIN 테이블2

emp,dept 두 테이블의 공통된 이름을 갖는 컬럼 : deptno;
한정자로 어디테이블에서 왔는지 구분
join 조건의 테이블은 한정자 사용 못함

SELECT emp.empno, emp.ename, deptno, dept.dname
FROM emp NATURAL JOIN dept;

위의 쿼리를 ORACLE 버전으로 수정
오라클에서는 조인 조건을 WHERE절에 기술 
행을 제한하는 조건, 조인 조건 > WHERE 절에 기술
join 조건 한정자 필수?

SELECT emp.*, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT emp.*, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno != dept.deptno;

ANSI - SQL : JOIN WITH USING
조인 테이블간 동일한 이름의 컬럼이 복수개 인데
이름이 같은 컬럼중 일부로만 조인 하고 싶을 떄 사용

SELECT *
FROM emp JOIN dept USING (deptno);

위를 ORACLE로

SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

ANSI-SQL : JOIN WITH ON
위에서 배운 NATURAL JOIN, JOIN WITH USING의 경우 조인 테이블의 조인컬럼이 이름이 같아야 한다는 제약조건이 있음
설계상 두 테이블의 컬럼 이름이 다를수도 있음. 컬럼 이름이다를 경우 개발자가 직접 조인 조건을 기술할 수 있도록 제공 해주는 문법

SELECT *
FROM emp JOIN dept ON (emp.deptno = dept.deptno);
위의 하나면 해결가능 

SELECT * 
FROM emp, dept
WHERE emp.deptno = dept.deptno;
오라클은 하나뿐이라 이것만 알면된다

SELF-JOIN : 동일한 테이블끼리 조인 할 떄 지칭하는 별칭, 별도의 키워드가 아니다

사원번호, 사원이름, 사원의 상사 사원번호, 사원의 상사 이름 // king은 상사가 없기떄문에 조인 실패 총 행의 수는 13
SELECT e.ename, e.mgr, e.empno, m.ename
FROM emp  e JOIN emp m ON (e.mgr = m.empno); 

-- 12
사원중 사원의 번호가 7369~7699인 사원만 대상으로 해당 사원의
사원번호, 이름, 상사의 사원번호, 상사의 이름

SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp  e JOIN emp m ON (e.mgr = m.empno)
WHERE e.empno >= 7369 AND e.empno <= 7699;

SELECT a.*, emp.ename
FROM (SELECT empno, ename, mgr
      FROM emp
      WHERE empno BETWEEN 7369 AND 7699) a, emp
WHERE a.mgr = emp.empno;

SELECT a.*, emp.ename
FROM (SELECT empno, ename, mgr
      FROM emp
      WHERE empno BETWEEN 7369 AND 7699) a JOIN emp ON (a.mgr = emp.empno);
      
NON-EQUI JOIN : 조인 조건이 =이 아닌조합
!= : 값이 다를떄 연결

-급여등급 salgrade는 중복되면 안됌
SELECT *
FROM salgrade;

SELECT empno, ename, sal, grade
FROM emp, salgrade
WHERE sal BETWEEN losal AND hisal;

-- 실습

SELECT empno, ename, emp.deptno, dname
FROM emp,dept
WHERE emp.deptno = dept.deptno;


SELECT a.*
FROM (SELECT empno, ename, emp.deptno, dname
      FROM emp, dept
      WHERE emp.deptno = dept.deptno) a
WHERE deptno IN(10,30);

SELECT empno, ename, emp.deptno, dname
FROM emp,dept
WHERE emp.deptno = dept.deptno
    AND emp.deptno IN(10,30);
