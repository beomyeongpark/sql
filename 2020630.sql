날짜관련 오라클 내장함수
내장함수 : 탑재가 되어있다, 오라클에서 제공해주는 함수 ( 많이 사용하니까, 개발자가 별도록 개발하지 않도록)

MONTHs_BETWEEN(date1,date2) : 두 날짜 사이의 개월수를 반환 < 잘안씀  ==> 날짜가다르면 1.23개월 이런식으로 실수m 떨어짐
ADD_MONTHs(date1,NUMBER) : date1 날짜에 NUMBER 만큼의 개월수를 더하고, 밴 날짜를 반환 < 제일 많이사용
NEXT_DAY(date1, 주간요일(1~7)): date1 이후에 등장하는 첫번째 주간요일의 날짜 ==> 20200630,6 ==> 20200703 < 자주사용
LAST_DAY(date) : date1 날짜가 속한 월의 마지막 날짜 반환 ==> 20200605 > 20200630  < 자주사용
                모든 달의 첫번째 날짜는 1일 
                달의 마지막 날짜는 다른 경우가 있다.
                윤년의 경우 2월달이 29일임
                FIRST_DAY는 없음 

SELECT ename, TO_CHAR(hiredate,'YYYY-MM-DD') hiredate,
       MONTHS_BETWEEN(SYSDATE,hiredate)
FROM emp; 

ADD_MONTHS;

SELECT ADD_MONTHS(SYSDATE, 5) art5, ADD_MONTHS(SYSDATE, -5) bef5
FROM dual;

NEXT_DAY : 해당 날짜 이후에 등장하는 첫번째 주간요일의 날짜
//실습기준 20200630 
SELECT NEXT_DAY(SYSDATE, 7)
FROM dual;

LAST_DAY: 해당 일자가 속한 월의 마지막 일자를 반환
실습당일의 날짜가 월의 마지막이라 임의의 문자열로 테스트 20200605

SELECT LAST_DAY(TO_DATE('2020/06/05','YYYY/MM/DD'))
FROM dual;

FIRST_DAY구현
1. SYSDATE를 문자로 변경 포맷은 YYYYMM >TO_CHAR(SYSDATE,'YYYYMM')
2. 1번의 결과에다가 문자열 결합을 통해 '01'문자를 뒤에 붙여준다 TO_CHAR(SYSDATE,'YYYYMM') || '01'
    YYYYMMDD
3. 2번의 결과를 날짜 타입으로 변경 1+2

SYSDATE : 20200630 > 20200601

SELECT TO_DATE(TO_CHAR(SYSDATE,'YYYYMM') || '01','YYYY/MM/DD')
FROM dual;

SELECT :yyyymm PARAM, TO_CHAR(LAST_DAY(TO_DATE(:yyyymm,'YYYYMM')),'DD') DT
FROM dual;


실행 계획 : DBMS가 요청받은 SQL을 처리하기 위해 세운 절차
            SQL 자체에는 로직이 없다. (어떻게 처리 해라??가 없다. JAVA랑 다른점)
            읽는 방법 
            1. 위에서 아래로
            2. 단 자식 노드가 있으면 자식 노드 부터 읽는다.
                자식노드 : 들여쓰기가 된 노드
실행계획 보는 방법 
1. 실행 계획을 생성
EXPLAIN PLAN FOR
실행계획을 보고자 하는 SQL;
2. 실행계획을 보는 단계
SELECT *
FROM TABLE(dbms_xplan.display);

empno 컬럼은 NUMBER 타입이지만 형변환 과정을 보기 위하여 의도적으로 문자열 상수 비교를 진행

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = '7369'; 

SELECT *
FROM TABLE(dbms_xplan.display);


--
EXPLAIN PLAN FOR
SELECT * 
FROM emp
WHERE TO_CHAR(empno) = '7369';

SELECT *
FROM TABLE(dbms_xplan.display);

EXPLAIN PLAN FOR
SELECT * 
FROM emp
WHERE empno = 7300 + '69';

SELECT *
FROM TABLE(dbms_xplan.display);


6,000,000 <==> 6000000
국제화 : i18n
날짜 국가별로 형식이 다르다
한국 : yyyy-mm-dd
미국 ㅣ mm-dd-yyyy
숫자 
한국 : 5,000,000.00
독일 : 9.000.000,00

sql(number) 칼럼의 값을 문자열 포맷팅 적용

SELECT ename, sal, TO_NUMBER(TO_CHAR(sal,'L9,000.00'),'L9,999.00')
FROM emp;

NULL과 관련된 함수 : NULL값을 다른값으로 치환 하거나, 혹은 강제로 NULL을 만드는 것 
                    모두 외우기보다는 편한거 하나 쓰는걸 추천
1. NVL(expr1, expr2)
    if( expr1 == null)
         expr2를 반환 return;
         else
         expr1를 반환
         
SELECT empno, sal, comm, NVL(comm, 0),
        sal + comm, sal + NVL(comm, 0)
FROM emp;


2. NVL2(expr1, expr2, expr3)
if (expr1 != null)
    return expr2
    else
    return expr3

SELECT empno, sal, comm, NVL2(comm, comm, 0),
        sal + comm, sal + NVL2(comm, comm, 0), NVL2(comm, comm+sal, sal)
FROM emp;

3. NULLIF(expr1, expr2) : null 값을 생성하는 목적
if(expr1 == epxr2 )
    return null;
else 
    return expr1;
    
SELECT ename, sal, comm, NULLIF(sal, 3000)
FROM emp;


4. COALESCE(expr1,expr2......)
인자중에 가장 처음으로 null값이 아닌 값을 갖는 인자를 반환
COALESCE(null. null, 30, null, 50) => 30

if( expr 1= null)
    return expr1;
else
    COALESCE(expr2, ....)

SELECT COALESCE(null, null, 30, null, 50)
FROM dual;

null 처리 실습
emp 테이블에 14명의 사원이 존재, 한명을 추가(insert)

INSERT INTO emp (empno, ename, hiredate) VALUES (9999, 'brown', NULL);

조회컬럼 : ename, mgr, mgr컬럼 값이 NULL이면 111로 치환 NULL이 아니면 mgr 컬럼, hiredate, hiredate가 NULL이면 SYSDATE 아니면 hiredate
SELECT ename, mgr, NVL(mgr, 111), hiredate, NVL(hiredate, SYSDATE)
FROM emp;

SELECT empno, ename, mgr, NVL(mgr, 9999), NVL2(mgr, mgr, 9999), COALESCE(mgr, 9999)
FROM emp;

SELECT userid, usernm, reg_dt, NVL(reg_dt,SYSDATE) n_reg_dt
FROM users
WHERE userid != 'brown';

SELECT ROUND(6/28 *100,2) || '%'
FROM dual;

SQL 조건문 
CASE
    WHEN 조건문(참 거짓을 판단할 수 있는 문장) THEN 반환할 값
    WHEN 조건문(참 거짓을 판단할 수 있는 문장) THEN 반환할 값
    WHEN 조건문(참 거짓을 판단할 수 있는 문장) THEN 반환할 값
    WHEN 조건문(참 거짓을 판단할 수 있는 문장) THEN 반환할 값
    ELSE  모든 WHEN절을 만족시키지 못할때 반활 기본 값
END  ==> 하나의 컬럼으로 취급

emp테이블에 저장된 job 컬럼의 값을 기준으로 급여(sal)를 인상시키려고 한다
sal 컬럼과 함께 인상된 sal 컬럼의 값을 비교하고 싶은 상황
급여 인상기준 
job이 SALESMAN sal * 1.05 
job이 MANAGER sal * 1.10
job이 PRESIDENT sal * 1.20
나머지 기타 직군은 그대로 

SELECT ename, job, sal, 
        CASE
            WHEN job = 'SALESMAN' THEN sal * 1.05
            WHEN job = 'MANAGER' THEN sal * 1.10
            WHEN job = 'PRESUDENT' THEN sal * 1.20
            ELSE sal
        END
FROM emp;

SELECT empno, ename, 
        CASE
            WHEN deptno = 10 THEN 'ACCOUNTING'
            WHEN deptno = 20 THEN 'RESEARCB'
            WHEN deptno = 30 THEN 'SALES'
            WHEN deptno = 40 THEN 'OPERATLONS'
            ELSE 'DDIT'
        END AS dname
FROM emp;


