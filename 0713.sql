제약조건 생성 방법
DROP TABLE dept_test
CREATE TABLE dept_test(
    DEPTNO    NUMBER(2),
    DNAME     VARCHAR2(14),
    LOC       VARCHAR2(13) 
);

제약조건 생성방법 2번 : 테이블 생성시 컬럼 기술이후 별도로 제약조건을 기술하는 방법
dept_test 테이블의 deptno컬럼을 대상으로 PRIMARY KEY 제약 조건생성
CREATE TABLE dept_test(
    DEPTNO    NUMBER(2),
    DNAME     VARCHAR2(14),
    LOC       VARCHAR2(13) ,
    
    CONSTRAINT pk_dept_test PRIMARY KEY (DEPTNO)
);

동일한 값을 갖는 쿼리 2개ㅡㄹ 생성하여 2개워 쿼리가 정상적으로 작동하는지 테스느
INSERT INTO dept_test VALUES (99,'brown','daejeon');
INSERT INTO dept_test VALUES (99,'ABC','daejeon');
SELECT *
FROM dept_test;

NOT NULL 제약조건 : 컬럼 레벨에 기술, 테이블 기술 없음, 테이블 수정시 변경 가능
INSERT INTO dept_test VALUES (99,NULL,'daejeon');
DROP TABLE dept_test;
CREATE TABLE dept_test(
    DEPTNO    NUMBER(2) CONSTRAINT pk_dept_dest PRIMARY KEY,
    DNAME     VARCHAR2(14) NOT NULL,
    LOC       VARCHAR2(13) 
);

INSERT INTO dept_test VALUES (99,NULL,'daejeon');

UNIQUE : 해당 컬럼의 값이 다른 행에 나오지 않도록(중복되지 않도록)
        데이터 무결성을 지켜주는 조건
        (ex : 사번, 학번 )
수업시간 UNIQUE 제약조건 명명 규칙 : UK_테이블명_해당컬럼명        
DROP TABLE dept_test;
CREATE TABLE dept_test(
    DEPTNO    NUMBER(2) CONSTRAINT pk_dept_dest PRIMARY KEY,
    DNAME     VARCHAR2(14) ,
    LOC       VARCHAR2(13) ,
    
    CONSTRAINT uk_dept_test_dname UNIQUE(DNAME,LOC)
);        
dname , loc를 결합해서 중복되는 데이터가 없으면 됨
ddit, daejeon
ddit, daejeon
위의 두개는 중복

아래 두개는 부서명은 동일하지만 loc정보가 다르기 떄문에 dname,loc조합은 서로 다른 데이터
ddit, 대전
ddit, daejeon

dname, loc 컬럼 조합으로 중복된 데이터가 들어가는지 안들어가는지 테스트

dname. loc 컬럼조합ㅇ의 값이 동일한 데이터인 경우 ==> 에러 (UNIQUE) 제약 조건
INSERt INTO dept_test VALUES (90,'ddit','daejeon');
INSERt INTO dept_test VALUES (99,'ddit','daejeon');

dname. loc 컬럼조합ㅇ의 값이 하나의 컬럼만 동일한 데이터인 경우 ==> 성공
INSERt INTO dept_test VALUES (99,'ddit','daejeon');
INSERt INTO dept_test VALUES (98,'ddit','대전');

FOREIGN KEY : 참조키
한 테이블의 컬럼의 값의 참조하는 테이블의 컬럼 값중에 존재하는 값만 입력되도록 제어하는 제약조건

즉 FOREIGN KEY 경우 두개의 테아블간의 제약조건
*참조되는 테이블의 컬럼에는 (dept_test.deptno)) 인덱스가 생성되어 있어야 한다..
자세한 내용은 INDEX 편에서 다시 확인
=> UNIQUE 제약조건 생성시 자동으로 인덱스 생성 

DROP TABLE dept_test;
CREATE TABLE dept_test(
    DEPTNO    NUMBER(2),
    DNAME     VARCHAR2(14),
    LOC       VARCHAR2(13) ,
    
    CONSTRAINT pk_dept_test PRIMARY KEY (DEPTNO)
    
);

INSERT INTO dept_test VALUES(1, 'ddit', 'daejeon');

dept_test테이블의 deptno 컬럼을 참조하는 emp_test 테이블 생성
DROP emp_test;
CREATE TABLE emp_test(
     empno NUMBER(4),
    ename VARCHAR(10),
    deptno NUMBER(2) REFERENCE dept_test (deptno)
);

1.dept_test 테이블에는 부서번호가 1번인 부서가 존재
2.emp_test테이블의 deptno 컬럼으로 dept_test.deptno 컬럼을 참조
==? emp_test 테이블의 deptno 커럼에는 dept_test.deptno컬럼에 존재하는
값만 입력하는 것이 가능

dept_test 테이블에 존재하는 부서번호로 emp_test테이블에 입력하는 경우
INSERT INTO emp_test VALUES(9999.'brown',1);

dept_text 테이블에 존재하지 않는 부서번호ㅗㄹ emp_test 테이블에 입력하는 경우
INSERT INTO emp_test VALUES(9999,'sally',2);




FK 제약조건을 테이블 컬럼 기술이후에 별도로 기술하는 경우
CONSTRAINT 제약조건명 제약조건 타입 (대상컬럼) REFERENCES 참조테이블(참조테이블의 컬럼명)
명명 규칙 : FK_타겟테이블명_참조테이블명(IDX)
DROP TABLE emp_test;
CREATE TABLE emp_test(
     empno NUMBER(4),
    ename VARCHAR(10),
    deptno NUMBER(2),
    
    CONSTRAINT fk_emp_test_dept_test FOREIGN KEY (deptno) REFERENCES dept_test (deptno)
);

dept_test 테이블에 존재하는 부서번호로 emp_test테이블에 입력하는 경우
INSERT INTO emp_test VALUES(9999,'brown',1);

dept_text 테이블에 존재하지 않는 부서번호ㅗㄹ emp_test 테이블에 입력하는 경우
INSERT INTO emp_test VALUES(9999,'sally',2);

참조되고 있는 부모쪽 데이터를 삭제하는 경우
dept_test 테이블에 1번 부서가 존재하고ㅓ
emp_test 테이블의 brown 사원이 1번 부서에 속한 상태에서
1번 부서를 삭제하는 경우
FK의 기본 설정에서는 참조하는 데이터가 없어 질수 없기 떄문에  에러발생

SELECt *
FROM emp_test;

DELETE dept_test
WHERE deptno = 1;

FK 생성시 옵션
0. DEFAULT : 무결성이 위배되는 ㄱㅇ우 에러
1. ON DELETE CASCADE : 부모 데이터를 삭제할 경우 참조하고있는 자식 데이터를 같이 삭제
    dept_test 테이블의 1번 부서를 삭제하면 1번 부서에 소속된 brown사원도 삭제
2. ON DELETE SET NULL : 부모 데이터를 삭제할 경우 참조하는 자식 데이터의 컬럼을 NULL로 수정

1.
DROP TABLE emp_test;
CREATE TABLE emp_test(
     empno NUMBER(4),
    ename VARCHAR(10),
    deptno NUMBER(2),
    
    CONSTRAINT fk_emp_test_dept_test FOREIGN KEY (deptno) REFERENCES dept_test (deptno)
    ON DELETE CASCADE
);

INSERT INTO emp_test VALUES(9999,'brown',1);

부모 데이터 삭제

DELETE dept_test
WHERE deptno = 1;

2.
DROP TABLE emp_test;
CREATE TABLE emp_test(
     empno NUMBER(4),
    ename VARCHAR(10),
    deptno NUMBER(2),
    
    CONSTRAINT fk_emp_test_dept_test FOREIGN KEY (deptno) REFERENCES dept_test (deptno)
    ON DELETE SET NULL
);
INSERT INTO dept_test VALUES(1,'ddit','daejeon');
INSERT INTO emp_test VALUES(9999,'brown',1);

부모 데이터 삭제

DELETE dept_test
WHERE deptno = 1;

SELECT *
FROM emp_test;

CHECK 제약조건 : 컬럼에 이볅되는 값을 검증하는 제약 조건
    ex: salary 컬럼(급여)이 음수가 입력되는 ㅓㄳ은 부자연 스러움
    성별 컬럼에 남, 여가 아닌 값이 들어오는 것은 데이터가 잘못된 것
    직원 구분이 정직원, 임시직 2개가 존재할때 다른 값이 드어오면 논리적으로 어긋남)
    
    DROP TABLE emp_test;
CREATE TABLE emp_test(
     empno NUMBER(4),
    ename VARCHAR(10),
   --sal NUMBER(7, 2) CHECK (sal >0)
   sal NUMBER(7,2) CONSTRAINT sal_no_zeor CHECK (sal > 0)
);

sal 값이 음수인 데이터 입력

INSERT INTO emp_test VALUES(9999,'brown', -3);

테이블생성 + [제약조건 포함]
: CTAS 
CREATE TABLE 테이블명 AS
SELECT .....

백업 예시
CREATE TABLE member_20200713 AS
SELECT *
FROM member;

member에 작업


CTAS 명령을 이용하여 EMP 테이블의 모든 데이터를 바탕으로 EMP_TEST 테이블 생성
DROP TABLE emp_test;

CREATE TABLE emp_test AS
SELECT *
FROM emp;

SELECT *
FROM emp_test;

== 테이름 컬럼 구조만 복사하고 싶을떄 WHERE절에 항상 FALSE가 되는 조건을 기수하여 생성 가능
CREATE TABLE emp_test2 AS
SELECT *
FROM emp
WHERE 1 != 1;

생성된 테이블 변경
컬럼 작업
1. 존재하지 않았던 새로운 컬럼 추가
    => 테이블의 컬럼 기술순서를 제어하는건 불가
    >> 신규로 추가하는컬럼의 경우 컬럼순서가 항상 테이블의 마지막
    >> 설계를 할떄 컬럼순서에 충분히 고려, 누락된 컬럼이 없는지도 고려
    
2. 존재하는 커럼 삭제
    >> 제약조건(FK) 주의 
3. 존재하는 컬럼 변경
    > 컬럼명 변경 > FK와 관계 없이 알아서 적용해줌
    > 그 외적인 부분에서는 사실상 불가능 하다고 생각하면 편함
        (데이터가 이미 들어가 있는 테이블의 경우)
        - 1. 컬럼 사이즈 변경
        - 2. 컬럼 타입변경
    ==> 설계시 충분한 고려
    
제약 조건 작업
1. 제약조건 추가
2. 제약조건 삭제
3. 제약조건 비활성화/활성화

DROP TABLE emp_test;

CREATE TABLE emp_test(
     empno NUMBER(4),
    ename VARCHAR(10),
    deptno NUMBER(2)
);

테이블 수정
ALTER TABLE 테이블명 ........

1. 신규 컬럼 추가
ALTER TABLE emp_test ADD (hp VARCHAR2(11));

SELECt *
FROM emp_test;

2. 컬럼 수정(MODIFY)
> 데이터가 존재하지 않을 떄는 비교적 자유롭게 수정 가능
ALTER TABLE emp_test MODIFY (  hp VARCHAR(5));
ALTER TABLE emp_test MODIFY (  hp NUMBER);

컬럼 기본값 설정
ALTER TABLE emp_test MODIFY (  hp DEFAULT 123);
 INSERT INTO emp_test (empno, ename, deptno) VALUES (9999,'brown',NULL);
 
 SELECT *
 FROM emp_test;
 
 컬럼명칭 변경 (RENAME COLUMN 현재컬럼명 TO 변경할 컬럼명)
 ALTER TABLE emp_test RENAME COLUMN hp TO cel;;
 
컬럼 삭제 (DROP, DROP COLUMN)
ALTER TABLE emp_test DROP cel;
ALTEr TABLE emp_test DROP COLUMN cel;

3. 제약조건 추가, 삭제 (ADD, DROP)
            +
 테이블 레벨의 제약조건 생성
 
 ALTER TABLE 테이블명 ADD CONSTRAINT 제약조건명 제약조건타입 대상컬럼
 
 DROP TABLE emp_test;
CREATE TABLE emp_test(
     empno NUMBER(4),
    ename VARCHAR(10),
    deptno NUMBER(2)
);

테이블 수정을 통해서 emp_test 테이블의 empno 컬럼에 PRIMARY KEY 제약조건 추가
ALTER TABLE emp_test ADD CONSTRAINT pk_emp_test PRIMARY KEY (empno)

제약조건 삭제 DROP
ALTER TABLE emp_test DROP CONSTRAINT pk_emp_test;

제약조건 화성화 비활성화
제약조건 DROP은 제약조건 자체를 삭제하는 행위
제약조건 비활성화는 제약조건 자체는 남겨두지만, 사용하지는 않는 형태
때가되면 다시 활성화 하여 데이터 무겨성에 대한 부분을 강제할 수 있음

DROP TABLE emp_test;
CREATE TABLE emp_test(
     empno NUMBER(4),
    ename VARCHAR(10),
    deptno NUMBER(2)
);

테이블 수정명령을 통해 emp_test테이블의 empno컬럼으로 PRIMARY KEY 제약 생성
ALTER TABLE emp_test ADD CONSTRAINT pk_test_empno PRIMARY KEY (empno);

제약조건을 활성화/비활성화 (ENABLE  / DISABLE)

ALTER TABLE emp_test DISABLE CONSTRAINT pk_test_empno;;

비활성화 되었기 떄문에 empno 컬럼에 중복되는 값입력이가능

INSERT INTO emp VALUE(9999,'brown',NULL);
INSERT INTO emp VALUE(9999,'sally',NULL);

활성화
ALTEr TABLE emp_test ENABLE CONSTRAINT pk_test_empno;

=테이블 정보
SELECT *
FROM user_tables;

SELECT *
FROM user_constraints;

=제약조건검색
SELECT *
FROM user_cons_columns
WHERE TABLE_NAME = 'CYCLE';

= 테이블에 대한 comments
SELECT *
FROM user_tab_comments;

= 컬럼에 대한 comments
SELECt *
FROM user_col_comments;

테이블, 컬럼 주석 달기
COMMENT ON TABLE 테이블명 IS '주석';
COMMENT ON COLUMN 테이블명.컬럼명 IS '주석';

emp_test 테이블, 컬럼에 주석
COMMENT ON TABLE emp_test IS '사원_복제';
COMMENT ON COLUMN emp_test.deptno IS '부서번호';
COMMENT ON COLUMN emp_test.ename IS '사원이름';
COMMENT ON COLUMN emp_test.empno IS '사번';

SELECt *
FROM user_col_comments
WHERe table_name = 'EMP_TEST';

SELECT t.*, u.COLUMN_NAME,u.COMMENTS
FROM user_tab_comments t, user_col_comments u
WHERE u.table_name = t.table_name
  AND  t.TABLE_NAME IN ('CYCLE','CUSTOMER','DAILY','PRODUCT');

ALTER TABLE dept ADD CONSTRAINT pk_dept_deptno PRIMARY KEY (deptno);
ALTER TABLE emp ADD CONSTRAINT pk_emp_empno PRIMARY KEY (empno);
ALTER TABLE emp ADD CONSTRAINT fk_emp_dept FOREIGN KEY (deptno) REFERENCES dept (deptno);
