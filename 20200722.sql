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
TO_DATE(:yyyymm,'YYYYMM') + (level-1) - (TO_CHAR(TO_DATE(:yyyymm,'YYYYMM') + (level-1),'D')-1) s
FROM dual
CONNECT BY LEVEl <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm,'YYYYMM')),'DD'))
GROUP BY s
ORDER BY s;

WITH dt AS(
    SELECT TO_date('2019/12/01','YYYY/MM/DD') dt FROM dual UNION ALL
    SELECT TO_date('2019/12/02','YYYY/MM/DD') dt FROM dual UNION ALL
    SELECT TO_date('2019/12/03','YYYY/MM/DD') dt FROM dual UNION ALL
    SELECT TO_date('2019/12/04','YYYY/MM/DD') dt FROM dual UNION ALL
    SELECT TO_date('2019/12/05','YYYY/MM/DD') dt FROM dual UNION ALL
    SELECT TO_date('2019/12/06','YYYY/MM/DD') dt FROM dual UNION ALL
    SELECT TO_date('2019/12/07','YYYY/MM/DD') dt FROM dual UNION ALL
    SELECT TO_date('2019/12/08','YYYY/MM/DD') dt FROM dual UNION ALL
    SELECT TO_date('2019/12/09','YYYY/MM/DD') dt FROM dual UNION ALL
    SELECT TO_date('2019/12/10','YYYY/MM/DD') dt FROM dual)
SELECT dt, dt - (TO_CHAR(dt,'d')-1)
FROM dt;




mybatis
SELECT : 결과거 1건이거나 복수거나 
    1건 : sqlSession.seisectOne("네임스페이스.sqlid", 인자 ) ==> overlodaing
         리턴타입 : resultType
    복수 : sqlSession.seisectList("네임스페이스.sqlid", 인자 ) ==> overlodaing
        ==> 리턴타입 LISt < resultType
    
오라클 계층쿼리 : 하나의 테이블(혹은 인라인뷰)에서 특정 행을 기준으로
                다른 행을 찾아가는 문멉
조인 : 테이블 - 테이블 연결
계층쿼리 : 행 - 행 연결

1. 시작점(행)을 설정
2. 시작점과 다른행을 연결시킬 조건을 기술

SELECT *
FROm emp;

1. 시작점 : mgr 정보가 없는 킹
2. 연결 조건 : king을 mgr컬럼으로 하는 사원

 
SELECT LPAD('기준문자열',15)
FROM dual;

SELECT LPAD(' ',(LEVEL-1) * 4) || ename, LEVEL
FROm emp
START WITH mgr IS null
CONNECT BY PRIOR empno = mgr;

최하단 노드에서 상위 노드로 연결하는 상향식 연결 방법
시작점 : SMITH

**PRIOR 키워드는 CONNECT BY 키워드와 떨어져서 사용해도 무관
**PRIOR 키워드는 현재 읽고 있는 행을 지칭하는 키워드
SELECT LPAD(' ',(LEVEL-1) *4) || ename
FROM emp
START WITH  ename = 'SMITH'
CONNECT BY empno = PRIOR mgr;

select *
FROM dept_h;

xx회사 부서부터 시작하는 하향식 계층쿼리 작성, 부서이름과 LEVEL 컬럼을 이용하여
들여쓰기

SELECT LPAD(' ',(LEVEL-1) * 4)|| deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

SELECT LEVEL, deptcd,LPAD(' ',(LEVEL-1) * 4)|| deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptnm = '디자인팀'
CONNECT BY PRIOR p_deptcd = deptcd;