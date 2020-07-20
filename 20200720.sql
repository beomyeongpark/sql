SELECT NVL(job,'총계'), deptno, SUM(sal+NVL(comm,0))sal
FROM emp
GROUP BY ROLLUP (job,deptno);

GROUPING col : 0,1
0 : 컬럼이 소재 계산에 사용 되지 않았다. GROUP BY 컬럼으로 사용됨
1 : 컬럼이 소재 계산에 사용 되었다.

== job 컬럼이 소재계산으로 사용되어 null값이 나온것인지
정말 커럼의 값이 null인 행들이 group by 된 것인지 알려면
GROUPING 함수ㅡ 사용해야 정확한 값을 알 수 있다.

아래 사용은 잘못된 예
SELECT NVL(job,'총계'), deptno, GROUPING(job), GROUPING(deptno), SUM(sal+NVL(comm,0))sal
FROM emp
GROUP BY ROLLUP (job,deptno);

GROUP(JOB)값이 1이면 '총계', 0이면 JOB

SELECT DECODE(GROUPING(job),1,'총계',0,job) job, deptno, SUM(sal+NVL(comm,0))sal
FROM emp
GROUP BY ROLLUP (job,deptno);

NVL 함수를 사용하지 않고 GROUPING 함수를 사용해야 하는 이유

job,mgr > job > 전체
SELECT job,mgr,GROUPING(job),GROUPING(mgr),SUM(sal)
FROM emp
GROUP BY ROLLUP (job,mgr);


SELECT job, deptno, SUM(sal+NVL(comm,0))sal
FROM emp
GROUP BY ROLLUP (job,deptno);

SELECT CASE
        WHEN GROUPING(job) = 1 THEN '총'
        WHEN GROUPING(job) = 0 THEN job
        END job, CASE
                        WHEN GROUPING(deptno) = 1 AND GROUPING(job) = 1 THEN '계'
                        WHEN GROUPING(deptno) = 1 AND GROUPING(job) = 0 THEN '소계'
                        WHEN GROUPING(deptno) = 0 AND GROUPING(job) = 0 THEN TO_CHAR(deptno)
                        END deptno, SUM(sal) sal_sum
FROM emp
GROUP BY ROLLUP (job,deptno);

SELECT DECODE(GROUPING(job),1,'총',0,job) job,DECODE(1,GROUPING(job),'계',GROUPING(deptno),'소계',deptno) deptno, SUM(sal) sum_sal
FROM emp
GROUP BY ROLLUP (job,deptno);
DECODE(GROUPING(job)+GROUPING(deptno),2,'계',1,'소계',0,deptno)

SELECT deptno,job,sum(sal+NVL(comm,0)) sal
FROM emp
GROUP BY ROLLUP(deptno,job);

==4
SELECT dname, job, sum(sal+NVL(comm,0)) sal
FROM emp,dept
WHERE emp.deptno = dept.deptno
GROUP BY ROLLUP(dname,job);

SELECT dept.dname, a.job, a.sal
FROM
(SELECT deptno,job,sum(sal+NVL(comm,0)) sal
FROM emp
GROUP BY ROLLUP(deptno,job)) a, dept
WHERE a.deptno = dept.deptno(+);

== 5
SELECT DECODE(GROUPING(dname),1,'총합',0,dname) dname, DECODE(1,GROUPING(DNAME),'계',GROUPING(job),'소계',job), sum(sal+NVL(comm,0)) sal
FROM emp,dept
WHERE emp.deptno = dept.deptno
GROUP BY ROLLUP(dname,job);





확좡된 GROUP BY (sqld 시험에서만 잘나오고 실무는 별로)
1. ROLLUP (그다음) 
- 컬럼 기술에 방향성이 존재
- GROUP BY ROLLUP (job,deptno) != GROUP BY ROLLUP (deptno,job)
    GROUP BY JOB deptno           GROUP BY deptno, job
    GROUP BY JOB                  GROUP BY deptno
    GROUP BY                      GROUP BY 
    단점 : 개발자가 필요가 없는 서브 그룹을 임의로 제거할 수 없다.
2. GROUPING SETS (그나마 많이씀) -  필요한 서브그룹으 임의로 지정하는 형태
    -> 복수의 GROUP BY를 하나로 합쳐서 결과를 돌려주는 형태
    GROUP BY GROUPING SETS (col1,col2)
    GROUP BY col1
    UNION ALL
    GROUP BY col2
    
    GROUPING SETS의 경우 ROLLUP과는 다르게 컬럼 나열순서가 데이터자체에 영향을 미치지않는다
    ==> GROUPING SETS((col1,col2) col)
    
3. CUBE (잘안씀)

GROUPING SETS 실습

SELECT job, deptno, SUM(sal+ NVL(comm,0))
FROM emp
GROUP BY GROUPING SETS(job,deptno);

위 쿼리를 UNION ALL

SELECT job, null, SUM(sal+NVL(comm,0))
FROM emp
GROUP BY job
UNION ALL
SELECT null, deptno, SUM(sal+NVL(comm,0))
FROM emp
GROUP BY deptno;

두 결과는 서로 다름
SELECT job, deptno, mgr, SUM(sal+NVL(comm,0))
FROM emp
GROUP BY GROUPING SETS (job, deptno, mgr);

SELECT job, deptno, mgr, SUM(sal+NVL(comm,0))
FROM emp
GROUP BY GROUPING SETS ((job, deptno), mgr);

CUBE 
GROUP BY를 확장한 구문
CUBE절에 나열한 모든 가능한 조합으로 서브그룹을 생성
GROUP BY CUBE(job, deptno)
    GROUP BY job, deptno
    GROUP BY job
    GROUP By      deptno
    GROUP BY 

SELECT job, deptno, SUM(sal+NVL(comm,0))
FROM emp
GROUP BY CUBE(job,deptno);

CUBE의 경우 기술한 컬럼으로 모든 가능한 조합으로 서브그룹을 생성한다
가능한 서브그룹은 2^기술한컬럼개수
기수한 컬럼이 3개만 넘어도 생성되는 서브그룹의 개수가 8개가 넘기 때문에
실제 필요하지 않은 서브그룹이 포함될 가능성이 있다
--> ROLLUO , GRUPING SETS 보다 활용성이 떨어진다

GROUP BY job, ROLLUP(deptno),CUBE(mgr)
=> 내가 필요로하는 서브그룹을 GROUPING SETS 를 통해 정의하면 간단하게 작성가능

SELECT job, deptno, mgr
FROM emp
GROUP BY job, ROLLUP(deptno),CUBE(mgr);
ROLLUP > GROUP BY deptno 
         GROUP BY 
CUME > GROUP BY mgr
       GROUP BY
GROUP BY job, deptno, mgr
GROUP BY job, deptno
GROUP BY job, mgr
GROUP BY job


SELECT job, deptno, mgr, SUM(sal+NVL(comm,0)) sal
FROM emp
GROUP BY job, ROLLUP(job,deptno), CUBE(mgr);
1. 서브그룹 나열

GROUP BY job job deptno, mgr
GROUP BY job job deptno,
GROUP BY job job mgr
GROUP BY job job 
GROUP BY job        mgr
GROUP BY job 




SELECT *
FROM emp_test

1. emp_test 테이블을 삭제
DROP TABLE emp_test;

2. emp 테이블을 이용하여 emp_test 테이블을 생성 (모든행, 모든컬럼)
CREATE TABlE emp_test AS
SELECT *
FROM emp
WHERE 1 = 1;

3. emp_test테이블에 dname (VARCHAR2(14))컬럼을 추가
ALTER TABLE emp_test ADD (dname VARCHAR2(14));

SELECT *
FROM emp_test;

==> WHERE 절이 존재하지 않음 > 모든 행에 대해 업데이트
UPDATE emp_test
   SET dname = (SELECT dname
                FROM dept
                WHERE deptno = emp_test.deptno);
                
실습 1
1.dept_test 테이블을 삭제
DROP TABLE dept_test;
2. dept 테이블을 이용하여 dept_test 생성(모든행, 모든컬럼)
CREATE TABLE dept_test AS
SELECT *
FROM dept;

3. dept_test 테이브에 empcnt(number) 컬럼을 추가
ALTER TABLE dept_test ADD (empcnt number);

SELECT *
FROM dept_test;

4. subqueryㅡㄹ 이용해 dept_test 테이블의 empcnt 컬럼을 해당 부서원수로 update
UPDATE dept_test
  SET empcnt = (SELECT COUNT(*)
                FROM emp
                WHERE deptno = dept_test.deptno);
                
COMMIT;                