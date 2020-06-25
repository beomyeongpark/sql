expression : 컬럼값을 가공하건, 존재하지 않는 새로운 상수값(정해진 값)을 표현 
            연산을 통해 새로운 컬럼을 조회
            연산을 하더라도 sql 조회 결과에만 나올 뿐이고 실제 테이블의 데이터에는 영향응 주지않음
            SELECT 구문은 테이블의 데이터에 영향을 주지않음.

SELECT *
FROM emp;

SELECT  *
FROM  dept;

SELECT sal, sal+500, sal-500, sal/5, 500
FROM emp;

날짜에 사칙연산 : 수학적으로 정의되어 있지 않음
SQL에서는 날짜데이터 +- 정수 > 정수를 일수 취급

2020년 6월 25일 + 5 : 2020년 6월 25읿부터 6일 이후 날짜
2020년 6월 25일 - 5 : 2020년 6월 25읿부터 6일 이전 날짜

데이터 베이스에서 주로 사양하는 데이터 타입 : 문자, 숫자, 날짜

SELECT *
FROM emp;
empno : 숫자
ename : 문자
job : 문자
mgr : 숫자
hiredate : 날짜
sal : 숫자
comm : 숫자
deptno : 숫자

테이블의 컬럼구성 정보 확인 :
DESC 테이블명 (DESCRIBE 테이블명)

DESC emp;

SELECT hiredate, hiredate+5, hiredate-5
FROM emp;

users 테이블의 컬럼 타입을 확인하고
reg_dt 칼럼값에 5일뒤 날짜를 새로운 칼럼으로 표현
조회컬럼 : userid, reg_dt,reg_dt +5

DESC users;

SELECT userid, reg_dt, reg_dt +5
FROM users;

null : 아직 모르는 값, 할당되지 않은 값 ( 숫자타임 0과 다르고 문자타입 공백과 다르다)
null을 피연산자로 하는 연산의 결과는 항상 null
null + 500 = null

emp 테이블에서 sal 컬럼과 comm 컬럼의 합을 새로운 컬럼으로 표현
조회 empno,ename, sal, comm, sal+comm

ALIAS : 컬럼이나, expression에 새로운 이름을 부여 | 컬럼, expression [AS} 별칭 
컬럼명 소문자나 공백을 넣고싶은 경우는 "컬럼 or 별칭 "

SELECT empno, ename, sal, comm, sal+comm AS sum
FROM emp;

SELECT prod_id AS id, prod_name AS name
FROM prod;

SELECT *
FROM lprod;

SELECT lprod_gu AS gu, lprod_nm AS nm
FROM lprod;

SELECT buyer_id AS 바이어아이디, buyer_name AS 이름
FROM buyer;

literal : 갑자체
literal 표기법 : 값을 표현하는 방법 
ex : test 라는 문자열을 표기하는 방법
java > "test"
sql > 'test'

번외
자바 대입연산자 : =
pl/sql 대입 연산자 : :=
언어마다 표기, literal 표기법이 다르기 떄문에 언어에서 지정하는 방식을 잘 따라야 한다.

문자열 연산 : 결합 
java : +
sql : ||
sql 연산 함수 : concat(문자열1,문자열2)

users테이블의 userid 컬럼과 usernm 컬럼을 결합

SELECT userid,usernm, userid || '_' || usernm AS id_name, CONCAT(userid,usernm) AS concat_id_name
FROM users;

SELECT '아이디:' || userid
FROM users;

SELECT 'SELECT * FROM '||table_name  || ';' AS a 
FROM user_tables;

SELECT CONCAT(CONCAT('SELECT * FROM ',table_name),';') as A
FROM user_tables;

WHERE : 테이블에서 조회할 행의 조건을 기술
        WHERE 절에 기술한 조건이 참일 떄 해당 행을 조회한다.
        SQL에서 가장 어려운 부분, 많은 응용이 발생하는 부분 
SELECT *
FROM users
WHERE userid = 'brown';

emp 테이블에서 deptno 컬럼의 값이 30보다 크거나 같은 행을 조히, 컬럼은 모든컬럼

SELECT *
FROM emp
WHERE deptno >=30;

emp 총 행수 : 14

DATE 타입에 대한 WHERE절 조건 기술
emp 테이블에서 hiredate 1982년 1월 1일 이후인 사람들만 조회

SQL 에서 DATE 리터럴 표기법 : 'rr/mm/dd'
단 서버 설정마다 표기법이 다르다.
한국 yy/mm/dd
미국 mm/dd/yy
문자열을 DATE 타입으로 변경해주는 함수를 주로 사용
TO_DATE('날짜문자열','첫번째 인자의 형식')

리터럴표기
SELECT *
FROM emp
WHERE hiredate >= '82/01/01';

함수사용
SELECT *
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01','yyyy/mm/dd');

BETWEEN AND : 두 값 사이에 위치한 값을 참으로 인식 BETWEEN 값 AND 값 / 처음값과 2번째 값을 포함하고 사이에 있는 수

emp 테이블에서 sal 값이 1000보다 크거나 같고 2000보다 작거나 같음 사원들만 조회

SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

SELECT *
FROM emp
WHERE sal >=1000 AND <=1000;

SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN TO_DATE('1982/01/01','YYYY/MM/DD') AND TO_DATe('1983/01/01','YYYY/MM/DD');

SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01','YYYY/MM/DD') 
  AND hiredate <= TO_DATe('1983/01/01','YYYY/MM/DD');

IN 연산자 : 비교값이 나열된 값에 포함될 떄 참으로 인식 비교값 IN(값1,값2,값3...)

사원의 소속 부서가 10번 혹은 20번

SELECT *
FROM emp
WHERe deptno IN(10, 20);

SELECT *
FROM emp
WHERe deptno =10
   OR deptno =20;

