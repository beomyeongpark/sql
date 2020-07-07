OUTER JOIN < = > INNER JOIN

INNER JOIN : 조인 조건을 만족하는 (조인에 성공하는) 데이터만 조회
OUTER JOIN : 조인 조건을 만족하지 않더라도 (조인에 실패하더라도) 기준이 되는 테이블 쪽의 데이터(컬럼)은 조회가 되도록 하는 조인 방식

OUTER JOIN

LEFT OUTER JOIN : 종인 키워드의 왼쪽에 위치하는 테이블을 기준삼아 OUTER JOIN 시행
RIGHT OUTEr JOIN : 종인 키워드의 오른쪽에 위치하는 테이블을 기준삼아 OUTER JOIN 시행
FULL OTER JOIN : LEFT + RIGHT  - 중복되는것 제외  < 쓰는경우 거의 없다.

ANSI-SQL 
FROM 테이블1 LEFT OUTER DOIN 테이블2 ON (조인 조건)

ORACLE-SQL : 데이터가 없는데 나와야하는 테이블의 컬럼
FROM 테이블1, 테이블2
WHERE 테이블1.걸럼 = 테이블2.컬럼(+)

ANSI-SQL OUTER
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno);

ORACLE-SQL OUTER (킹의 mgr 정보가 없기 떄문에)
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e , emp m
WHERE e.mgr = m.empno(+);


OUTER JOIN시 조인조건(ON 절에 기술)과 일반조건(WHERE 절에 기술)적용시 주의사함
1. OUTER JOIN을 사용하는데 WHERE 절에 별도의 다른 조건을 기술할 경우 원하는 결과가 안나올 수 있다.
> OUTER JOIN의 결과가 무시

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno AND m.deptno = 10);

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno);

조인 조건을 WHERE 절로 변경할 경우 - OUTER JOIN을 적용하지 않은 아래 쿼리와 동일한 결과
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno)
WHERE m.deptno = 10;

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno(+) 
  AND m.deptno = 10;

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno)
WHERE m.deptno = 10;

ORACLE SQL
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno(+) 
  AND m.deptno(+) = 10;


RIGHT OUTER JOIN  : 기준 테이블이 오른쪽, 아래의 null은 매니저가 아닌사람들
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e RIGHT JOIN emp m ON (e.mgr = m.empno);

FROM emp e LEFT JOIN emp m ON (e.mgr = m.empno); : 14건
FROM emp e RIGHT JOIN emp m ON (e.mgr = m.empno); : 21건 

fULL OUTER JOIN : LEFT+OUTER - 중복제거

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e FULL JOIN emp m ON (e.mgr = m.empno);

ORACLE SQL 에서는 FULL OUTTER 문법을 제공하지 않음 - 아래는 오류
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERe e.mgr(+) = m.empno(+);

집합 에ㅅ ㅓ중복 개념이없다
A = {1,3,5}
B = {2,3,4}
A U B = }1,2,3,4,5}

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT JOIN emp m ON (e.mgr = m.empno)
UNION
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e RIGHT JOIN emp m ON (e.mgr = m.empno)
MINUS
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e FULL JOIN emp m ON (e.mgr = m.empno);

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT JOIN emp m ON (e.mgr = m.empno)
UNION
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e RIGHT JOIN emp m ON (e.mgr = m.empno)
INTERSECT
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e FULL JOIN emp m ON (e.mgr = m.empno);

WHERE : 행을 제한
JOIN
GROUP FUNCTION

시도 : 서욱특별시, 충청남도
시군구 : 강남구, 청주시
스토어 구분

발전지수 = kcf+버거킹+맥도널드/ 롯데리아
순위, 시도, 시군구, 비가 도시발전지수(소수점 2자리)
정렬은 순위가 높은 행이 가장 먼저 나오도록
1, 서울특별시, 강남구, 9.32
2, 서울특별시, 강남구, 5.14
....


1-1 . 프렌차이즈별로 SELECT 쿼리 분리 한 경우

SELECT sido, sigungu, COUNT(*) kfc
FROM fastfood
WHERE gb = 'KFC'
GROUP BY sido, sigungu;

3개테이블 join 

1-2, kfc, 맥도날드, 버거킹 : 1개의 sql로, 롯데리아 1개
SELECT sido, sigungu, COUNT(*) m
FROM fastfood
WHERE gb IN('맥도날드','KFC','버거킹')
GROUP BY sido, sigungu, m;

SELECT sido, sigungu, COUNT(*) d
FROM fastfood
WHERE gb = '롯데리아'
GROUP BY sido, sigungu, d;

2개 join 

1-3, 모든 쿼리를 SELECT 하나로

SELECT sido, sigungu, ROUND((NVL(SUM(DECODE(gb, 'KFC', 1)),0) + 
                    NVL(SUM(DECODE(gb, '맥도날드', 1)),0) +
                    NVL(SUM(DECODE(gb, '버거킹', 1)),0)) / 
                          NVL(SUM(DECODE(gb, '롯데리아', 1)),1),2) score
FROM fastfood
WHERE gb IN('버거킹','맥도날드','롯데리아','KFC')
GROUP BY sido, sigungu
ORDER BY score DESC;

SELECT *
FROM bugerstore;
