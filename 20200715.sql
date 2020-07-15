view -sql(쿼리) 논리적인 데이터 정의, 실체가 없다
        view 구성하는 테이블의 데이터가 연결되면 view 결과도 달라진다
SEQUENCE 중복되지 않는 정수값을 반환해주는 객체
         유일한 값이 필요할 때 사용할 수 있는 객체
         nextval, currval
INDEX - 테이블의 일부 컬럼을 기준으로 미리 정렬해 놓은 데이터         
        - 테이블 없이 단독적으로 생성 불가, 특정 테이블에 종속
         table 삭제를 하면 관련 인덱스도 같이 삭제
         null 이면 인덱스에 저장을못함

DB 구조에서 중요한 전제 조건
1. DB에서 I/O의 기준은 행단위가 아니라 block 단위
    한건의 데이터를 조회하더라도, 해당 행이 존재하는 block 전체를 읽는다.

데이터 접근 방식
1. table full access
    multi block io > 읽어야할 블럭을 여러개를 한번에 읽어 들이는 방식
                    (일반적으로 8 = 16block)
    사용자가 원하는 데이터의 결과가 table의 모든 데이터를 다 읽어야 처리가 가능할 경우
    ==> 인덱스 보다 여러 블럭을 한번에 많이 조회하는 table full access 방식이
    유리할 수 있다.
    전제조건은 mgr, sal, comm 컬럼으로 인덱스가 없을 떄
    mgr, sal, comm 정보를 table에서만 획득이 가능할 떄
    ex: 
    SELECT COUNT(mgr), SUM(sal), SUM(comm), AVG(sal)
    FROM emp;
2. index 접근, index 접근후 table access
    single block io > 읽어야할 행이 있는 데이터 block만 읽어서 처리하는 방식
    소수의 몇건 데이터를 사용자가 조회할 경우, 그리고 조건에 맞는 인덱스가 존재할 경우
    빠르게 응답을 받을 수 있다
    
    하지만 single block 빈번하게 일어나게 되면 multi block io보다 오히려 느리다
2. extent, 공간할당 기준

현재 상태
인덱스 : idx_nu_emp01 ( empno)

emp 테이블의 job 커럼을 기준으로 2번쨰 nu idx 만들기
CREATE INDEX idx_nu_emp_02 ON emp (job);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
    AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);

emp 테이블의 job, ename 컬럼을로 복합 nu idx 생성
CREATE INDEX idx_nu_emp_03 ON emp (job, ename);
현재 상태 : 인덱스 3개 , empno, job, job ename

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
  AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);


EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
  AND ename LIKE '%C';

SELECT *
FROM TABLE(dbms_xplan.display);

인덱스 추가
emp 테이블에 ename, job컬럼을 기준으로 nu_idx 인덱스 생성 04
CREATE INDEX un_idx_emp04 ON emp(ename, job);

현재 인덱스 4개 : empno, job , job ename, ename job

복합 컬럼의 인덱스의 결합순서가 미치는 영향

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
  AND ename LIKE 'C%';
  
  EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
  AND ename LIKE '%C';

SELECT *
FROM TABLE(dbms_xplan.display);

3번 인덱스 삭제
DROP INDEX idx_nu_emp_03;

다시 실행
  EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
  AND ename LIKE 'J%';

SELECT *
FROM TABLE(dbms_xplan.display);

조인에서의 인덱스 활용
ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
ALTER TABLE emp ADD --CONSTRAINT fk_emp_dept FOREIGN KEY (deptno) REFERENCE dept (deptno);
                    CONSTRAINT fk_emp_dept FOREIGN KEY (deptno) REFERENCES dept (deptno);

emp : pk_emp (empno)
dept : pk_dept (deptno)

접근 방식 emp 1.table full access 2. 인덱스 * 4 : 방법 5가지 존재
         dept 1.table full access 2.인덱스 *1 : 방법 2가지존재
        가능한 경우 10가지
        방향성 emp, dept를 먼저 처리할지 ==> 20가지
        
EXPLAIN PLAN FOR        
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND emp.empno = 7788;
  
SELECT *
FROM TABLE(dbms_xplan.display);

EXPLAIN PLAN FOR        
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

  
SELECT *
FROM TABLE(dbms_xplan.display);

==실습
CREATE TABLE dept_test2 AS
SELECT *
FROM dept;


CREATE UNIQUE INDEX idx_u_dept_test2_01 ON dept_test2 (deptno);
CREATE INDEX idx_nu_dept_test2_02 ON dept_test2 (dname);
CREATE INDEX idx_nu_dept_test2_03 ON dept_test2 (deptno, dname);

DROP INDEX idx_u_dept_test2_01;
DROP INDEX idx_nu_dept_test2_02;
DROP INDEX idx_nu_dept_test2_03;

1번 > empno
2번 > ename 
3번 > empno
4버 > deptno
5번 > empno, deptno ?
6번 > deptno 

EXPLAIN PLAN FOR
SELECt *
FROM emp
WHERE ename = 'SMITH';

SELECT *
FROM TABLE(dbms_xplan.display);

EXPLAIN PLAN FOR
SELECt *
FROM emp
WHERE empno = 7369;

SELECT *
FROM TABLE(dbms_xplan.display);


CREATE INDEX idx_nu_emp05 ON emp (empno, sal);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 3000
AND deptno = 10;

SELECT *
FROM TABLE(dbms_xplan.display);


EXPLAIN PLAN FOR
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND emp.deptno = 20
  AND emp.empno LIKE 7369 || '%';
  
EXPLAIN PLAN FOR
SELECT b.*
FROM emp a, emp b
WHERE a.mgr = b.EMPNO
  AND a.deptno = 10;;
  
  
EXPLAIN PLAN FOR
SELECT deptno, TO_CHAR(hiredate,'yyyymm'), COUNT(*) cnt
FROM emp
GROUP BY deptno, TO_CHAR(hiredate,'yyyymm');
  
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7369;


===
1. empno =
2. ename =
3. deptno =, empno LIKE //선행조건에 = 가 오는게좋음
4. sal(between) , deptno ( = )
5. deptno = , empno = 
6. deptno, hiredate 컬럼으로 구성된 인덱스가 있을경우 table 접근이 필요 없음

1. empno
2. ename
3. deptno , empno
   deptno, sal
   deptno, hiredate
   
   
1. empno
2. ename
3. deptno , empno, sal, hiredate

emp 테이블에 데이터가 5처남ㄴ건
10, 20, 30 데이터는 각각 50건씪만 존재 == > 인덱스
40번 데이터 4950만건 => table full access


Synonym
오라클 객체에 별칭을 생성 
test.v_emp > v_emp

생성 방법
CREATE SYNONYM 시노님이름 FRO 원본객체이름;
PUBLIC : 모든 사용자가 사용할 수 있는 시노님
        권한이 있어야 생성가능
PRIVATE [DEFAULT] : 해당 사용자만 사용할 수 있는 시노님        
        
삭제방법
DROP SYNONYM 시노님이름

권한 주기 
GRANT CREATE SYNONYM TO hr;