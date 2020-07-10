UPDATE : 상수값으로 업데이트 ==> 서브쿼리 사용가능
INSERT INTO emp (empno, ename, job) VALUES (9999, 'brown', 'BANGER');


9999번 사번번호를 갖는 사원의 deptno와 job컬럼의 값을 SMITH사원의 deptno와 job 값으로 업데이트


UPDATE emp SET deptno = (SELECT deptno
                         FROM emp
                        WHERE ename = 'SMITH'),
                job = (SELECT job
                         FROM emp
                        WHERE ename = 'SMITH')
WHERE empno = 9999;             

-==> UPDATE 쿼리 : 실행할 때 왼쪽 SELECT 쿼리가 2개가 포함됨 > 비효율적
    고정된 값을 업데이트 하는게 아니라 다른 테이블에 있는 값을 통해서 업데이트 할떄
    비효율이 존재
    ==> MERGE 구문을 통해 보다 효율적으로 업데이트가 가능
    
DELETE : 테이블의 행을 삭제할 떄 사용하는 SQL
        특정 컬럼만 삭제하는 거는 UPDATE
        DELETE 구문은 행 자체를 삭제
1. 어떤 테이블에서 삭제할지
2. 테이블의 어떤 행을 삭제할지

문법
DELETE [FROM] 테이블명
WHERE 삭제할 행을 선택하는 조건;

UPDATE 쿼리 실습시 9999번 사원을 등록 함, 해당 사원을 삭제하는 쿼리를 작성
DELETE emp
WHERE empno=9999;

DELETE 쿼리도 SELECT 쿼리 작성시 사용한 WHERE 절과 동일
서브쿼리 사용 가능

사원중에 mgr가 7698인 사원들만 삭제

DELETE emp
WHERE empno IN (SELECT empno
             FROM emp
             WHERE mgr = 7698);
             
ROLLBACK;

DBMS의 경우 데이터의 복구를 위해서
DML 구문을 실행할 떄마다 로그를 생성

대량의 데이터를 지울 떄는 로그 기록도 부하가 되기 떄문에 
개발환경에서는 테이블의 모든 데이터를 지우는 경우에 한해서 
TRUNCATE TABLE 테이블명; 명령을 통해
로그를 남지기 않고 빠르게 삭제가 가능하다
단. 로그가 없기 떄문에 복구가 불가능하다.

CREATE TABLE emp_copy as
SELECT *
FROM emp;

SELECT *
FROM emp_copy;

TRUNCATE TABLE emp_copy;


DML [Data Manipuiation[조작] Language] : 데이터를 다루는 SQL
SELECT, INSERT, UPDATE, DELETE

DDL (Data Definition[정의] Language] : 데이터를 정의하는 sQL
DDL은 자동 커밋, ROLLBACK 불가
es :  테이블 생성 DDL 실행 == > 롤백이불가
    ==> 테이블 삭제 DDL 실행

데이터가 들어갈 공간(table) 생성, 삭제
컬럼추가
각종 객체 생성, 수정, 삭제

테이블 삭제
문법
DROP 객체종류 객체이름;
DROP TABLE emp_copy;
삭제한 테이블과 관련된 데이터는 삭제
(나중에 배울 내용 제약조건) 이런 것들도 다같이 삭제
테이블과 관련된 내용은 삭제;

INSERT INTO emp (empno, ename) VALUES (9999, 'brown');

SELECT COUNT(*)
FROM emp;

DROP TABLE batch;
(COMMIT);
ROLLBACK;

SELECT COUNT(*)
FROM emp

DML문과 DDL문을 혼합해서 사용 할 경우 바생할 수 있는 문제점
==> 의도와 다르게 DML문에 대해서 COMMIT이 되 수 있다.

테이브 생성
문법
CREATE TABLE 테이블명 (
    컬럼명1 컬럼1타입
    컬럼명2 컬럼2타입
    컬럼명3 컬럼3타입 DEFAULT 기본값
    );
    
ranger라는 이름의 테이블 새성;
CREATE TABLE ranger (
    ranger_no NUMBER,
    ranger_nm VARCHAR2(50),
    reg_dt DATE DEFAULT SYSDATE
    );
    
INSERT INTO ranger (ranger_no, ranger_nm) VALUES (1,'brown');

SELECT *
FROM ranger;

데이터 무결성 : 잘못된 데이터가 들어가는 것을 방지하는 성격
ex :1. 사원 테이블에 중복된 사원번호가 등록되는 것을 방지
    2. 반드시 이벽이 되어야 되는 커럼의 값을 확인
==> 파일시스템이 갖을 수 없는 성격

오라클에서 제공하는 데이터 무결성을 지키기 위해 제공하는 제약조건 5가지(4가지)
1. NOT NULL
    해당 컬럼에 값이 NULL 들어오는 것을 제약, 방지
    (ex, emp 테이블의 empno 컬럼)
    
2. UNIQUE 
    전체 행중에 해당 컬럼의 값이 중복이 되면 안된다.
    (ㄷex. emp 테이블에서 empno 컬럼이 중복되면 안된다)
    단 NULL에 대한 중복은 허용 한다.
3. PRIMARY KEY  = UNIQUE + NOT NULL
4. FOREIGN KEY 
    연관된 테이블에 해당 데이터가 존재해야만 입력이 가능
    emp 테이브과 dept 테이블은 deptno 컬럼으로 연결이 되어있음
    emp 테이블에 데이터를 입력할 떄 dept 테이브에 존재하지 않는 deptno 값을
    입력하는 것을 방지
5. CHECK 제약 조건
    컬럼에 들어오는 값을 정해진 로직에 따라서 제어
    ex 어떤 테이브에 성별 컬럼이 존재하면
    남성 = M 여성 = F
    M,F 두가지 값만 저장될 수 있도록 제어
    
    C 성별을 입력하면 시스템 요구사항을 정의할 떄
    정의하지 않은 값이기 떄문에 추후 문제가 될 수 도있다.
    
제약조건 생성 방법
1. 테이블 생성시, 컬럼 옆에 기술하는 경우
    > 상대적으로 세세하게 제어하는건 불가
2. 테이블 생성시, 모든 컬럼을ㄹ 기술하고 나서
    제약조건만 별도로 기술
    1.번 방법보다 세세하게 제어하는게 가능
3. 테이블 생성이후,
    객체 수정명령을 통해 제약조건을 추가
    
1번방법으로 PRIMARY KEY 생성    
dept 테이블과 동일한 컬럼명, 타입으로 dept_test라는 테이블 이름으로 생성
1. dept 테이블 컬럼의 구성 정보 확인
DESC dept;

CREATE TABLE dept_test(
    DEPTNO    NUMBER(2) PRIMARY KEY,
    DNAME     VARCHAR2(14),
    LOC       VARCHAR2(13) 
);
    
SELECT *
FROM dept_test;

PRIMARY KEY 제약조건 확인
UNIQUE + NOT NULL

1. NULL값 입력 테스트
PRIMARY KEY 제약조건에 의해 deptno컬럼에는 null값이 들어갈 수 없다
INSERT INTO dept_test VALUES (null, 'ddit', 'daejeon');

2. 값중복 테스트
INSERT INTO dept_test VALUES (99, 'ddit', 'daejeon');
deptno 컬럼의 값이 88인 데이터가 이미 존재하기 떄문에 
중복 데이터로 입력이 불가능
INSERT INTO dept_test VALUES (99, 'ddit2', '대전');

현 시점에서 dept 테이블에는 deptno컬럼에 PRIMARY KEY 제약이 걸려 있지 않은 상황
10번부서 추가로 등록
INSERT INTO dept VALUES (10, 'ddit', 'daejeon');



테이블 생성시 제약조건 명을 설정한 경우

컬럼명 컬럼타임 CONSTRAINT 제약조건이름 제약조건타입(PRIMARY KEY)
PRIMARY KEY 제약조건 명명 규칙 : PK_테이블명
CREATE TABLE dept_test(
    DEPTNO    NUMBER(2) CONSTRAINT pk_detp_test PRIMARY KEY,
    DNAME     VARCHAR2(14),
    LOC       VARCHAR2(13) 
);

INSERT INTO dept_test VALUES (99, 'ddit2', 'daejeon');
SELECT *
FROM dept_test;
INSERT INTO dept_test VALUES (99, 'ddit2', '대전');