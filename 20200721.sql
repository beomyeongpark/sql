1.확장된 GROUP BY
==> 서브그룹을 자동으로 생성
    만약 이런 구문이 없으면 개발자가 직접 SELECT 쿼리를 여러개 작성해서 UNION ALL시행 
    ==> 동일한 테이블 여러번 조회 = > 성능저하
    
1.ROLLUP 
    1.1 ROLLUP절에 기술한 컬럼을 오른쪽에서 부터 지워나가며 서브그룹을 생성
    1.2 생성되는 서브 그룹 : ROLLUP절에 기술한 컬럼 개수 + 1
    1.3 ROLLUP절에 기술한 컬럼의 순서가 결과에 영향을 미친다
    
    
2. GROUPING SETS
    2.1 사용자가 원하는 서브그룹을 직접 지정하는 형태
    2.2 컬럼 기술의 순서는 결과 집합에 영향을 미치지 않음 (집합)
    
3. CUBE
    3.1 CUBE절에 기술한 컬럼의 가능한 모든 조합으로 서브그룹을 생성
    3-2 잘안쓴다.. 서브그룹이 너무 많이 생성됨
        2^CUBW절에 기술한 컬럼개수
        
1. dept_test테이블의 empcnt 컬럼 삭제
ALTER TABLE dept_test DROP COLUMN empcnt;

2. 2개의 신규 데이터 입력
INSERT INTO dept_test VALUES(99, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES(98, 'ddit2', 'daejeon');

3. 부서중에 직원이 속하지 않은 부서를 삭제

DELETE dept_test
WHERE deptno NOT IN (SELECT deptno
                     FROM   emp
                     GROUP BY deptno);
                     
DELETE dept_test
WHERE deptno NOT IN (SELECt deptno 
                     FROM emp
                     WHERE deptno = dept_test.deptno);
              
DELETE dept_test
WHERE NOT EXISTS (SELECT 'X'
                    FROM emp
                   WHERE emp.deptno = dept_test.deptno);
                   
UPDATE emp_test a
   SET sal = sal+200
WHERe sal < (SELECT AVG(sal)
             FROM emp_test b
             WHERE a.deptno = b.deptno);

ROLLBACK;

SELECT DISTINCT deptno, empno
FROM emp;
DISTINCT 중복제거


WITH : 쿼리 블럭을 생성하고
같이 시행되는 SQL에서 해당 쿼리 블럭을 반복적으로 사용할 때 성능 향상 효과를 기대할 수 있다
WITH절에 기술된 쿼리 블럭은 메모리에 한번만 올리기 때문에
쿼리에서 반복적으로 사용하더라도 시제 데이터를 가져오는 작업은 한번만 발생
하지만 하나의 쿼리에서 동이한 서브쿼리가 반복적으로 사용 된다는 것은 쿼리를 잘못 작성할
가능성이 높다는 뜻이므로, WITH절로 해결하기 보다는 쿼리를 다른 방식으로 작성할 수 없는지
먼저 고려해볼 것을 추천

회사의DB를 다른 외부인에게 오픈하 수 없기 떄문에, 외부인에게 도움을 구하고자 하때
테이블을 대신할 목적으로 많이 사용 

사용방법 : 쿼리 블럭은 콤마(,)를 통해 여러개를 동시에 선언하는 것도 가능 
WITH 쿼리블럭이름 AS {
     SELECT 쿼리
}
SELECT *
FROM 쿼리블럭이름
             
      
/202007
1. 2020 7월의 일수 구하기 ;
2. 첫째날 시작, 요일 ,주차 구하기 
3. 주차별로 그룹, 최소 or 최대 아무거나 쓰기
iw는 월요일부터 
SELECT     MAX(DECODE(d,1,dt)) sun, 
           MAX(DECODE(d,2,dt)) mon, 
           MAX(DECODE(d,3,dt)) tue, 
           MAX(DECODE(d,4,dt)) wed,
           MAX(DECODE(d,5,dt)) thr, 
           MAX(DECODE(d,6,dt)) fri, 
           MAX(DECODE(d,7,dt)) sat
FROM
(SELECt TO_DATE(:yyyymm,'YYYYMM') + (level-1) dt, 
TO_CHAR(TO_DATE(:yyyymm,'YYYYMM') + (level-1),'D') d, 
TO_CHAR(TO_DATE(:yyyymm,'YYYYMM') + (level-1),'IW') iw
FROM dual
CONNECT BY LEVEl <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm,'YYYYMM')),'DD'))
GROUP BY DECODE(d,1,iw+1,iw)
ORDER BY DECODE(d,1,iw+1,iw);




실습 1

SELECT *
FROM sales;

DESC sales;

SELECT NVL(SUM(DECODE(TO_CHAR(dt,'mm'),1,sales)),0) jan,
       NVL(SUM(DECODE(TO_CHAR(dt,'mm'),2,sales)),0) feb,
       NVL(SUM(DECODE(TO_CHAR(dt,'mm'),3,sales)),0) mar,
       NVL(SUM(DECODE(TO_CHAR(dt,'mm'),4,sales)),0) apr,
       NVL(SUM(DECODE(TO_CHAR(dt,'mm'),5,sales)),0) may,
       NVL(SUM(DECODE(TO_CHAR(dt,'mm'),6,sales)),0) hum
FROM sales;

실습 2
SELECt     (DECODE(d,1,dt)) sun, 
           (DECODE(d,2,dt)) mon, 
           (DECODE(d,3,dt)) tue, 
           (DECODE(d,4,dt)) wed,
           (DECODE(d,5,dt)) thr, 
           (DECODE(d,6,dt)) fri, 
           (DECODE(d,7,dt)) sat
FROM 
(SELECt TO_DATE(:yyyymm,'YYYYMM') - ((NEXT_DAY(LAST_DAY(TO_DATE(:yyyymm,'YYYYMM')),7)) - (NEXT_DAY((TO_DATE(:yyyymm,'YYYYMM')),1) -8) - (TO_CHAR(LAST_DAY(TO_DATE(:yyyymm,'YYYYMM')),'DD'))) + 1 + (level-1) dt, 
TO_CHAR(TO_DATE(:yyyymm,'YYYYMM') - ((NEXT_DAY(LAST_DAY(TO_DATE(:yyyymm,'YYYYMM')),7)) - (NEXT_DAY((TO_DATE(:yyyymm,'YYYYMM')),1) -8) - (TO_CHAR(LAST_DAY(TO_DATE(:yyyymm,'YYYYMM')),'DD'))) + 1 + (level-1),'D') d, 
TO_CHAR(TO_DATE(:yyyymm,'YYYYMM') - ((NEXT_DAY(LAST_DAY(TO_DATE(:yyyymm,'YYYYMM')),7)) - (NEXT_DAY((TO_DATE(:yyyymm,'YYYYMM')),1) -8) - (TO_CHAR(LAST_DAY(TO_DATE(:yyyymm,'YYYYMM')),'DD'))) + 1 + (level-1),'IW') iw
FROM dual
CONNECT BY LEVEL <= NEXT_DAY(LAST_DAY(TO_DATE(:yyyymm,'YYYYMM')),7) - (NEXT_DAY((TO_DATE(:yyyymm,'YYYYMM')),1) -7));
--GROUP BY DECODE(d,1,iw+1,iw)
--ORDER BY DECODE(d,1,iw+1,iw);

SELECT NEXT_DAY(LAST_DAY(TO_DATE(:yyyymm,'YYYYMM')),7) - (NEXT_DAY((TO_DATE(:yyyymm,'YYYYMM')),1)-8)
FROM dual;

