SELECT *
FROM cycle 
WHERE cid = 1 AND pid IN (SELECT pid
                          FROM cycle 
                          WHERE cid = 2);      
                          
==실습7                     
SELECT customer.*, product.*, day, cnt
FROM cycle , product, customer 
WHERE cycle.pid = product.pid
  AND cycle.cid = customer.cid
  AND cycle.cid = 1 AND cycle.pid IN (SELECT pid
                                      FROM cycle 
                                      WHERE cid = 2);                                                                                                    
                                      
EXISTS 연산자 : 서브쿼리에서 반환하는 행이 존재하는지 체크하는 연산자
               서브쿼리에서 반환하는 행이 하나라도 존재하면 TRUE
               서브쿼리에서 반환하는 행이 존재하지 않으면 FALSE
특이점 : 1. WHERE절에서 사용
        2. MAIN 테이블의 컬럼이 항으로 사용되지 않음
        3. 비상호연관서브쿼리, 상호연관서브쿼리 둘다 가용 가능하지만
        주로 상호연관 서브쿼리(확인자)와 사용한다
        4. 서브쿼라의 컬럼값은 중요하지 않다.
         ==> 서브쿼리의 행이 존재하는지만 체크
            그래서 관습적으로 SELECT 'X' 를 주로 사용
연산자 : 항이 몇개가 필요한 연산자인자
+ : 피연산자1 + 피연산자2
++ : 피연산자1++
? 3항 연산자 : if 
조건 ? TRUE : FASLE
IN 연산자 : 
컬럼 IN (서브쿼리, 값을 나열하거나);
컬럼 LIKE '패턴문자열' 

EXISTS(서브쿼리)

1. 아래 쿼리에서 서브쿼리는 단독으로 실행 가능 ? O
 > 서브쿼리의 실행결과가 메인쿼리의 행 값과 관계 없이 항상 실행되고 반환되는 행의 수는 1개의 행이다
SELECT *
FROM emp
WHERE EXISTS (SELECT 'X'
              FROM dual);

일반적으로 EXISTS 연산자는 상호연관 서브쿼리에서 실행된다
비상호 연관 서브쿼리는 행 반환하거나 안하거나
1. 사원정보를 조회 하는데
2. WHERE m.empno = e.mgr 조건을 만족하는 사원만 조회
> 매니저 정보가 존재하는 사원 조회 (13건)

SELECT *
FROM emp e
WHERE EXISTS (SELECT 'X'
              FROM emp m
              WHERE m.empno = e.mgr);
> 서브쿼리가 확인자로 사용되었다
 비상호 연관의 경우 서브쿼리가 먼저 실행될 수도 있다
  > 서브쿼리가 제공자로 사용되었다
              
SELECT  m.*
FROM emp e ,emp m
WHERE e.empno = m.mgr;

SELECt *
FROM emp
WHERE mgr IS NOT NULL;

=실습 9
SELECT *
FROM product
WHERE EXISTS (SELECT 'X'
              FROM cycle
              WHERE product.pid = cycle.pid AND cycle.cid =1);
              

SELECT *
FROM product
WHERE pid IN (SELECT pid
              FROM cycle
              WHERE cid =1);
              
=실습 10
SELECT *
FROM product
WHERE NOT EXISTS (SELECT 'X'
              FROM cycle
              WHERE product.pid = cycle.pid AND cycle.cid = 1);
              
집합연산
sql에서 데이터를 확장하는 방법
가로 확장(컬럼을 확장) : JOIN
세로 확장(행을 확장) : 집합연산
                     집합여산을 하기 위해서는 연산에 참여하는 두개의 SQL(집합)이 
                     동일한 컬럼 개수와 타입을 가져야한다.

집합의 개념 
집합의 특징  : 1. 순서가없다    {1,2} = {2,1}
              2. 요소의 중복이 없다 { 1.1.3}= {1.3}

SQL에서 제공하는 집합 연산자
UNION : 합집합 , 두개의 집합을 하나로 합칠 떄 , 두집합에 속하는 요소는 한번만 표현한다. , 중복되는 데이터를 찾아야함 ==> 연산이 필요, 속도가 느림
         {1.2.3} U [1,4,5} = {1.2.3.4.5.}
UNION ALL : 합집합의 정의와 다르게 중복을 허용 , 위의 집합과 아래 집합의 행을 붙이는 행위만 실시, 중복을 찾는 과정이 없기 떄문에 속도면에서 빠르다
> 개발자가 두 집합의 중복이 없다는 것을 알고 있으면 UNION 보다 UNION ALL 을 사용하는게 더 좋다.
INTERSECT : 교집합 , 두개의 집합중 서로 중복되는 요소만 별도의 집합으로 생성
         {1,2,3} 교집합 [1,4,5} = {1}
MINUS : 차집합 , 앞에 선언된 집합의 요소중 뒤에 선언된 집합의 요소를 제거하고 남은 요소로 새로운 집합을 생성
         {1.2.3} - [1,4,5} = {2.3}
         
교환법칙 : 항의 위치를 수정해도 결과가 동일한 연산
            a+b, b+a 
차집합의 경우 교환법칙이 성립되지 않음  
            a-b != b-a
            {1.2.3} - [1,4,5} = {2.3}
            [1,4,5} - {1.2.3} = {4.5}

UNION 연산자
집합연산을 하려는 두개의 집합이 동일하기 때문에 합집하을 하면 중복을 허용하지 않기 떄문에 7566,7698 사번을 갖는 사원이 한번씩만 조회가 된다
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698)

UNION

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698);

UNION ALL 중복을 허용 한다

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698)

UNION ALL

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698);

INTERSECT : 교집합, 두집합에서 공통된 부분만 새로운 집합으로 생성

SELECT empno, ename
FROM emp
WHERE empno IN (7369,7566, 7499)

INTERSECT

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698);

MINUS : 차집합 한쪽 집합에서 다른쪽 집합을 뺀 것
SELECT empno, ename
FROM emp
WHERE empno IN (7369,7566, 7499)

MINUS

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698);


집합연산 특징
1. 컬럼명이 동일하지 않아도 됨  (별칭)
    단 조회 결과는 첫번째 집합의 컬럼을 따른다
2. 정렬이 필요한경우 마지막 집합 위에다가 기술하면 된다.
3. UNION ALL을 제외한 ㅕㄱㅇ우 중복제거 작업이 들어간다
SELECT empno eno, ename
FROM emp
WHERE empno IN (7369,7566, 7499)

MINUS

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698)
ORDER BY ename;


DML INSERT : 테이블에 데이터를 입력하는 SQL 문장
 1. 어떤 테이블에 데이터를 입력할지 테이블을정한다.
 2. 어떤 테이블에 어떤 컬럼에 어떤 값을 입력할 지 정한다
 
 문법
INSERT INTO 테이블 )컬럼1, 컬럼2.....) VALUES (컬럼1값, 컬럽2값....)

dept 테이블에 99번 부서번호를 갖는 ddit를 부서명으로 daejeon 지역에 위치하는 부서를 등록
컬럼명을 나열할 때 테이블 정의에 따른 컬럼 순서를 반드시 따를 필요는 없다 
다만 VALUES 절에 기술한 해당 컬럼에 입력할 값으 ㅣ위치만 지키면 된다
만약 테이블의 모든 컬럼에 대해 값을 입력하고자 할 경우는 컬럼을 나열하지 않아도 된다
단 VALUES 절에 입력할 값을 기술할 순서는 테이블에 정의된 컬럼의 순서와 동일 해야한다
모든 컬럼에 값을 입력하지 않을 수도 있따.
단. 해당 컬럼이 NOT NULL 제약조건이 걸려 있는 경우 컬럼에 반드시 값이 들어가야한다
컬럼에 NOT nULL 제약조건 적용 여부는 DESC 테이블명을 통해 허확인한다
테이블의 컬럼 정의 : DESC 테이블명;

INSERT INTO dept VALUES (98, 'ddit2', '대전');

INSERT INTO dept (deptno, dname, loc) VALUES (99, 'ddit', 'daejeon');

SELECT *
FROM dept;

empno 컬럼에는 NOT NULL 제약 조건이 존재하기 때문에 반드시 값을 입력 해야한다
INSERT INTO emp (ename, job)
        VALUES('borwn','RANGER');
        
date 타입에 대한 insert
emp 테이블 sally 사원을 오늘 날쪼로 입사할떄 신규데이터 입력 job-BANGKR empno-9998

INSERT INTO emp (hiredate, job, empno) VALUES(SYSDATE, 'BANGER', 9998);
INSERT INTO emp (hiredate, job, empno, ename) VALUES(TO_DATE('20200707','YYYYMMDD'), 'BANGER', 9998, 'moon');

SELECT *
FROM emp;

==위에서 실행한 INSERT 구문들이 모두 취소
ROLLBACK;

SELECT 쿼리 결과를 테이블 입력
SELECT 쿼리 결과는 여러건의 행이 될 수도 있다
여러건의 데이터를 하나의 INSERT 구문을 통해서 입력 
문법
INSERT INTO 테이블명(컬럼1, 컬럼2...)
SELECT 컬럼1, 컬럼2
FROM ...

INSERT INTO emp(hiredate, job, empno, ename)
SELECT SYSDATE, 'BANGER', 9998, NULL
FROM dual
UNION ALL
SELECT TO_DATE('20200707','YYYYMMDD'), 'BANGER', 9998, 'moon'
FROM dual;

SELECT COUNT(*)
FROM emp;

UPDATE : 테이블에 존재하는 데이터를 수정하는 것
1. 어떤 테이블을 업데이트 할 건지?
2. 어떤 컬럼을 어떤 값으로 업데이트 할건지
3. 어떤 행에 대해서 업데이트 할건지(SELECT 쿼리의 WHERE절과 동일)

문법
UPDATE 테이블명 SET 컬럼명= 변경할 값1, 컬럼병2 = 변경할 값2 ....
WHERE 변경할 행을 제한할 조건

deptno가 90 ,dname이 ddit, loc가 대전인 데이터를 dept 테이블에 입력한ㄴ 쿼리
INSERT INTO dept VALUES (90,'ddit','daejeon');

부서번호가 90번인 부서의 부서명을 '대덕it', loc 'daejeon'으로업데잍

UPDATE dept SET dname = '대덕it', loc = '대전' 
WHERE deptno = 90;

업데이트 쿼리를 작성할 떄 주의할점
1. WHERE절이 있는지 없는지 확인
   WHERE절이 없다는건 모든 행에대해서 업데이트를 행한다는 의미
2. UPDATE 하기 전에 기술한 WHERE절을 SELECT 절에 저굥ㅇ하여 업데이트 대상
   데이터를 눈으로 확인하고 실행