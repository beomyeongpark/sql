시험 피드백
더블 쿼테이션 공백 대소문자 구분  
TEST2  < 테이블 인식
dual 에는 dummy 컬럼과 X값을 가지고 있지만
 문자열 결합시에는 사라짐 
 > 일반 dummy 결합하면 그대로 나옴 
 매니저인 사람이 아니라 매니저가 있는 사람들을 조회 
 
 SELECT 'test2' || "d d"
 FROM dual;
 
 방향을 잘못잡음
 SELECT deptno, MAX(sal)
 FROM emp
 GROUP BY deptno
 
 오라클 아우터 조인은
 데이터가 없는쪽에 + 붙인다
 
 != 조인 > 같을때 빼고 모든 경우의 수를 조인
 
 스칼라 서브쿼리는 단일행 단일컬럼 
 

 
 ===수업

개발자가 sql을 dbms에 요청을 하더라도
1. 오라클 서버가 항상 최적의 실행계획을 선택할 수 는 없음
    (응답성이 중요 하기 떄문 : OLTP - 온라인 트랙잭션 프로세싱)
     전체 처리 시간이 중요  :  OLAP - 온라인 분석 프로세싱
                            은행이자 ==> 실행계획을 세우는시간이 30분이상 소요 되기도함)
2. 항상 실행계획을 세우지 않음
    만약에 동일한 sql이 이미 실행된적이 있으면 해당 sql의 시행 계획을 새롭게 세우지 않고
    Shared pool (메모리)에 존재하는 시행계획을 재사용
    
    동일한 SQL : 문자가 완벽하게 동일한 SQL 
                SQL의 실행결과가 같다고 해서 동일한 SQL이 아니다.
                대소문자를 가리고, 공백도 문자로 취급
    EX : SELECT * FROM emp;
         select * FROM emp; 두개의 sql은 서로 다른 sql
         
select /* plan_test */ *
FROM emp
WHERE empno = 7698;

select /* plan_test */ *
FROM emp
WHERE empno = :empno;

오라클에서는 스키마 = 사용자

SELECT *
FROM dictionary;

SELECT *
FROM user_tables;

SELECT *
FROM all_tables;

SELECT *
FROM dba_tables;

DCL :  Data Control Language 시스템 권한 또는 객체 권한을 부여 / 회수
부여
GRANT 권한명 | 롤명 TO 사용자 

회수
REVOKE 권한명 | 룰명 FROM 사용자

DATA DICTIONARY
오라클 서버가 사용자 정보를 관리하기 위해 저장한 데이터를 볼수 있는 view

CATEGORY (접두어)
USER_ : 해당 사용자가 소유한 객체
ALL_ : 해당 사용자가 소유한 객체 + 권한 부여받은ㄴ 객체
DBA_ : 데이터베이스에 설치된 모든 객체(DBA 권한이 이쓴ㄴ 사용자만 가능 SYSTEM)
v% : 성능, 모니터링

