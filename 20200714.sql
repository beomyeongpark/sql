DDL
 오라클 객체
 1. table : 데이터를 저장할 수 있는 공간
    제약조건
    -NOT NULL. UNIQUE, PRIMARY KEY, FOREIGN KEY, CHECK 
 2. VIEW  : SQL(쿼리) ==> 실제 데이터가 존재하는 것이 아님
            논리적인 데이터 집합의 정의 
    * VIEW TABLE < 잘못된 표현 
    IN-LINE VIEW
view 생성 문법
CREATE              TABLE 
CREATE              INDEX
CREATE [OR REPLACE] VIEW 뷰이름 [column1, column2...] AS 
SELECT 쿼리;

emp테이블에서 급여정보인 sal, eomm 컬럼을 제왜하고 나머지 6개 컬럼만 조회할 수 있는 SELECT 쿼리를 
v_emp 이름의 view로 생성

view 생성할 수 있는 권한 부여

GRANT CREATE VIEW TO test; (시스템 계정)

CREATE OR REPLACE VIEW v_emp AS 
SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp;

오라클 view 객체를 생성하여 조회
SELECT *
FROM v_emp;

IN_LINE VIEW를 이용하여 조회
SELECT *
FROM (SELECT empno, ename, job, mgr, hiredate, deptno
      FROM emp);

view 객체를 통해 얻을수 있는 이점
1. 코드를 재사용 할 수 있다.
2. SQL 코드가 짧아진다

hr 계정에게 emp 테이블이 아니라 v_emp에 대한 접근권한을 부여
hr 계정에서는 emp 테이블의 sal, comm 컬럼을 볼 수가 없다.
==> 급여정보에 대한 부분을 비 관련자로부터 차단을 할 수가 있다.

hr 계정에 볼 수 있는 권한 부여
GRANT SELECT ON v_emp TO hr;

hr 계정에서 테스트
SELECt *
FROM test.v_emp;

emp 테이블의 SELECT 권한을 hr에게 준적이 없기 때문에 에러
SELECT *
FROM test.emp;

1. emp테이블에 신규 사원을 입력 ( 기존 15, 추가 16건)
2. view를 조회하면 ?  16건 
    view라고 하는것은 실체가 없는 데이터 집합을 정의하는 sql 이기 떄문에 
    해당 sql에서 사용하는 테이블의 데이터가 변경이 되면 view에도 영향을 미친다.
    
부서명, 사원번호, 사원이름, 담당업무, 입사일자
다섯개의 컬럼을 갖는 view를 v_emp_dept 로 생성

CREATE OR REPLACE VIEW v_emp_dept AS
SELECT dname, empno, ename, job, hiredate
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECt *
FROM v_emp_dept;

VIEW 삭제
DROP VIEW 뷰이름

SEQUENCE :  중복되지 않는 정수값을 반환해주는 오라클 객체 
시작값(default 1, 혹은 개발자가 설정 가능) 부터 1씩 순차적으로 증가한 값을 반환

문법 
CREATE SEQUENCE 시퀀스 명
[옵션 ...]

CREATE SEQUENCE seq_emp;
시퀀스 객체를 통해 중복되지 않는 값을 조회
시퀀스 객체에서 제공하는 함수
> 중복을 허용하지 않으려고 사용

1. nextval (next value)
 => 시퀀스 객체의 다읍 값을 요청하는 함수
 > 함수르 호출하면 시퀀스 객체의 값이 하나 증가하여 다음번 호출시
 증가된 값을 반환하게 된다
2. currval (current value)
 => nextval 함수를 사용하고 나서 사용할수 있는 함수 
 => nextval을 통해 얻은 값을 다시 확인 할 떄 사용
  시퀀스 객체가 다음에 리턴할 값에 대해 영향을 미치지 않는다.
  
  nextval 사용하기전에 currval 사용할 경우 >? 에러 
  SELECT seq_emp.currval
  FROM dual;
  
  SELECT seq_emp.nextval
  FROM dual;
  
  SELECT seq_emp.currval
  FROM dual;
  
  테이블 : 정렬이 안되어 있음 (집합)
  ==> ORDER BY
  
  emp 테이블에서 empno = 7698 인 데이터를 조회
  EXPLAIN PLAN FOR
  SELECT *
  FROM emp
  WHERE empno = 7698;
  
  SELECT *
  FROM TABLE(dbms_xplan.display);
  
  ROWID 특수컬럼 : 행의 주소 
  1. c언어의 포인터
   java : Tv tv - new Tv();
  SELECT ROWID,emp.*
  FROM emp
  WHERE empno=7698;
  
  ROWID 값을 알고 있으면 테이블에 빠르게 접근 하는 것이 가능
   EXPLAIN PLAN FOR
  SELECT *
  FROM emp
  WHERE ROWID = 'AAAE5gAAFAAAACNAAF';
  
  SELECT *
  FROM TABLE(dbms_xplan.display);
  
  emp 테이블의 PRIMARY KEY 제약조건을통해 empno 커럼으로
  인덱스가 생성이 되어 있는 상태
  
  SELECT *
  FROM emp
  WHERE empno = 7698;
  
  emp 테이블에 primary key 제약조건을 생성하고 나서 변경된 점
  * 오라클 입장에서 데이터를 조회할 떄 사용할 수 있는 전략이 하나더 생김
  1. table full scan
  2. pk_emp_empno 인덱스를 이용하여 사용자가 원하는 행을 빠르게 찾아가서
  필요한 컬럼들은 인덱스에 저장된 rowid를 이용하여 테이블의 행으로 바로 접근
  
  
   EXPLAIN PLAN FOR
  SELECT empno
  FROM emp
  WHERE empno = '7698';
  
  SELECT *
  FROM TABLE(dbms_xplan.display);
  
  empno 컬럼의 인덱스를 unique 인덱스가 아닌 일반 인덱스(중복이 가능한)로 생성한 경우
  1. fk_emp_dept 제약조건 삭제
  2. pk_emp_empno 제약조건 삭제
  
  ALTER TABLE emp DROP CONSTRAINT fk_emp_deptno;
  ALTER TABLE emp DROP CONSTRAINT pk_emp_empno;
  
  1. NON UNIQUE 인덱스 생성 (중복 가능)
  UNIQUE : 명명 규칙 : IDX_U_테이블명_01;
  NON UNIQUE : IDX_NU_테이블명_01;
  CREATE [UNIQUE] INDEX 인덱스명 ON 테이블 (인덱스로 구성할 컬럼)
  
  CREATE INDEX idx_nu_emp_01 ON emp (empno);
  
  EXPLAIN PLAN FOR
  SELECT *
  FROM emp
  WHERE empno = 7698;
  
  SELECT *
  FROM TABLE(dbms_xplan.display);