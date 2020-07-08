"" > 대소문자, 특수문자, 공백

dual > 행이하나 , 테스트하기 좋음, dummy 컬럼하나만 존재

SELECT 'TEST1' || dummy
FROM dual;

table에 어떤 컬림이 있는지 알고 싶을 떄 
1. 모든컬럼 조회
2. DESC
3. 툴에서 테이블 직접 눌러보기

ORDER BY 시 null값은 가장 큰값으로 인식한다

LAST_DAY(sysdate+55)  

============수업===================

1. GROUP BY 여러개의 행을 하나의 행으로 묶는 행위
2. JOIN
3. 서브쿼리 



SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp);


사원이 속한 부서의 급여 평균보다 높은 급여를 받는 사원 정보 조회

SELECT *
FROM emp
WHERE sal > ();

전체사원의 정보를 조히, 조인 없이 해당 사원이 속한 부서의 부서이름 가져오고
SELECT empno, ename, deptno, (SElECT dname FROM dept WHERE deptno = emp.deptno) 
FROM emp;

SELECT *
FROM emp a
WHERE sal > (SELECT AVG(sal)
             FROM emp b
             WHERE emp.deptno = a.deptno);
             
SELECT *
FROM emp 
WHERE deptno IN (SELECT deptno
                 FROM emp b
                 WHERE b.ename IN ('SMITH','WARD'));
                 
SELECT *
FROM emp
WHERE deptno = (SELECT deptno
                 FROM emp b
                 WHERE b.ename IN ('SMITH')) 
   OR deptno = (SELECT deptno
                 FROM emp b
                 WHERE b.ename IN ('WARD'));
                 
단일 값비교는 = 
복수행(단일컬럼) 비교는 IN 

IN, NOT IN 이용시 NULL값의 존재 유무에 따라 원하지 안는 결과가 나올 수 도있다

NULL 과 IN, NULL과 NOT IN

empno IN (9999, null);
NOT IN => AND
IN => OR


WHERE mgr IN(7902, null)
==> mgr = 7902 OR mgr = null;
====> mgr값이 7902이거나 (mgr값이 null인 데이터);

SELECT *
FROM emp
WHERE mgr IN(7902, null);


WHERE mgr NOT IN(7902, null);
==> NOT( mgr = 7902 OR mgr = null)
===> mgr != 7902 AND mgr != null


pairwise, non-pairwise

한행의 컬럼 값을 하나씩 비교하는 것 : non-pairwise
한행의 복수 컬럼을 비교하는 것 : pairwise
SELECT *
FROM emp
WHERE job IN ('MANAGER', 'CLERK');

SELECT *
FROM emp
WHERE (mgr, deptno) IN (SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN (7499, 7782));

위 6개 아래 7개

SELECT *
FROM emp
WHERE mgr IN (SELECT mgr
                        FROM emp
                        WHERE empno IN (7499, 7782))
  AND deptno IN (SELECT deptno
                        FROM emp
                        WHERE empno IN (7499, 7782));
                        
pairwise  많이 쓰는 형태는 아니지만 가끔씩 쿼리가 불가능 할 떄 가 있음 
7698, 30
7839, 10

non pairwise 
7698   30
7698   10
7839   30
7839   10

상호 연관 서브쿼리 - 실행순서가 정해져 있다 main > sub
비상호 연관 서브쿼리 - 실행순서가 정해져 있지 않다 , main > sub , sub > main

INSERT INTO dept VALUES (99, 'ddit', 'daejeon');

== 실습4
SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno
                      FROM emp
                      WHERE emp.deptno = dept.deptno);

SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno
                      FROM emp
                      GROUP BY deptno);                                       
                 
SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno
                      FROM emp);                 
                      
== 실습 5
SELECT *
FROM product
WHERE pid NOT IN (SELECT pid
                  FROM cycle
                  WHERE cid = 1
                  GROUP BY pid);

SELECT *
FROM cycle a
WHERE cid = 1 AND pid IN (SELECT pid
                         FROM cycle b
                         WHERE cid = 1)
              AND pid IN (SELECT pid
                         FROM cycle b
                         WHERE cid = 2);          
                         
SELECT *
FROM cycle
WHERE cid =1;

SELECT *
FROM cycle
WHERE cid =2;
                    