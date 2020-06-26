WHERE 절에서 사용 가능한 연산자 : LIKE
사용용도 : 문자의 일부분으로 검색을 하고 싶을 떄 사용
         ex : ename 컬럼의 값이 s로 시작하는 사원들을 조회
사용방법 : 컬럼 LIKE '패턴문자열'
마스킵 문자열 : % : 문자가 없거나, 어떤 문자든지 여러개의 문자열
                  's%' : s로 시작하는 모든 문자열
                      S,SS,SMITH
               _ : 어떤 문자든 딱 하나의 문자를 의미
                    's_' : s로시작하고 두번쨰 문자가 어떤 문자든 하나의 문자가 오는 2자리의 문자열
                    's____' : s로시작하고 문자열의 길이가 5글자인 문자열

emp테이블에서 ename 컬럼의 값이 s로 시작하는 사원들만 조회

SELECT *
FROM emp
WHERE ename LIKE 'S%';

SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '신%';

SELECT mem_id,mem_name
FROM member
WHERE mem_name Like '%이%';

UPDATE member set mem_name = '쁜이'
WHERE mem_id = 'b001';

SELECT *
FROM member;

UPDATE member SET mem_name = '신이환'
WHERE mem_id = 'c001';

NULL 비교 : =연산자로 불가 > IS 로 가능
NULL을 = 비교하여 조회

SELECT empno,ename, comm
FROM emp;
WHERE comm = NULL;

NULL 에 대한 비교는 IS 사용
SELECT empno,ename, comm
FROM emp
WHERE comm IS NULL;

emp 테이블에서 comm 값이 NULL이 아닌 데이터를 조회 > NOT 사용
SELECT empno,ename, comm
FROM emp
WHERE comm IS NOT NULL;

논리연산자 : AND, OR , NOT
AND : 참 거짓 판단식 - 식 두개를 동시에 만족하는 행만 참 , 
OR : 참 거짓 판단식 - 식 두개중에 하나라도 만족하면 참
NOT : 조건을 반대로 해석하는 부정형 연산
     MOT IN, IS NOT NULL

SELECT *
FROM emp;

emp 테이블에서 mgr 컬럼 값이 7698 이면서 sal 컬럼의 값이 1000보다 큰 사원 조회
2가지 조건을 동시에 만족하는 사원 리스ㅡㅌ
SELECT *
FROM emp
WHERE mgr = 7698 AND sal > 1000;

SELECT *
FROM emp
WHERE mgr = 7698 OR sal > 1000;


emp 테이블에서 mgr가 7698, 7839가 아닌 사원들을 조회 - NULL 값은 비교할수 없기 떄문에 나오지 않음 
SELECT *
FROM emp
WHERE mgr  != 7698 AND mgr != 7839;

SELECT *
FROM emp
WHERE mgr NOT IN(7698,7839);

mgr 사번이 7698이 아니고, 7839가 아니고, NULL이 아닌 직원들을 조회
SELECT *
FROM emp
WHERE mgr NOT IN(7698,7839,NULL);

IN(7698,7839,NULL) > mgr = 7698 or mgr = 7839 or mgr = NULL
 NOT IN(7698,7839,NULL) >  mgr != 7698 AND mgr != 7839 AND mgr != NULL > 마지막부분이 항상 false 임
SELECT *
FROM emp
WHERE job = 'SALESMAN' AND hiredate > TO_DATE('1981/06/01','yyyy/mm/dd');

SELECT *
FROM emp
WHERE deptno != 10 AND hiredate > TO_DATE('1981/06/01','yyyy/mm/dd');

SELECT *
FROM emp
WHERE deptno NOT IN (10) AND hiredate > TO_DATE('1981/06/01','yyyy/mm/dd');

SELECT *
FROM emp
WHERE deptno IN (20,30) AND hiredate > TO_DATE('1981/06/01','yyyy/mm/dd');

SELECT *
FROM emp
WHERE job = 'SALESMAN' OR hiredate > TO_DATE('1981/06/01','yyyy/mm/dd');

SELECT *
FROM emp
WHERE job = 'SALESMAN' OR empno LIKE '78%'; -- 형변환 : 명시적, 묵시적 여기선 묵시적 

SELECT *
FROM emp
WHERE job = 'SALESMAN' OR empno = 78 OR (empno >= 780 AND empno <= 789) OR (empno >=7800 AND empno <= 7899);

SELECT *
FROM emp
WHERE job = 'SALESMAN' OR empno LIKE '78%' AND hiredate > TO_DATE('1981/06/01','yyyy/mm/dd');

실행 순서
3 SELECT 
1 FROM 
2 WHERE

정렬
RDBMS 집합적인 사상을 따른다
집합에는 순서가 없다 {1, 3, 5} == {3, 5, 1}
집합에는 중복이 없다 {1, 3, 5, 1} == {3, 5, 1}

정렬 방법
ORDER BY > oredr by 1,2,3.... > 컬럼 alias 컬럼번호 다가능 , ASC 오름차순 (기본), DESC 내림차순 
                                          (SELECT 절에 나열된 컬럼의 인덱스 번호)

SELECT *
FROM emp
ORDER BY ename;

SELECT *
FROM emp
ORDER BY ename desc;

별칭으로 ORDER BY
SELECT empno, ename, sal, sal*12 AS salary
FROM emp
ORDER BY salary;

SELECT절에 기술된 컬럼순서로 정렬 - 추천하지 않음
SELECT empno, ename, sal, sal*12 AS salary
FROM emp
ORDER BY 4;

SELECT *
FROM dept
ORDER BY dname;

SELECT *
FROM dept
ORDER BY loc desc;

SELECT *
FROM emp
WHERE comm IS NOT NULL AND comm != 0 -- comm > 0 으로 표현 가능
ORDER BY comm DESC,empno DESC;