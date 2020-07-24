계층쿼리
1.CONNECT BY LEVEL <, <= 정수
    :시작행, 연결될 다음 행과의 조건이 없음
        ==> CROSS JOIN과 유사
2. START WITH CONNECT BY : 일반적인 계층 쿼리
                            시작 행 지정, 연결될 다음 행과의 조건을 기술
                            
CREATE TABLE imsi(
 E VARCHAR2(2)
);

INSERT INTO imsi VALUES('a')
INSERT INTO imsi VALUES('b')
COMMIT;

LEVEL의 시작 : 1

SELECT e, LEVEL, LTRIM(SYS_CONNECT_BY_PATH(e,'-'), '-')
FROM imsi
CONNECT BY LEVEL <=3;

== 행이 1개로 나오면 복제 (레벨은 다름)
== 행이 2개이상이면 가능한 모든조합 (레벨은 다름)
SELECT dummy, LEVEL
FROM dual
CONNECT BY LEVEL <=10;

CONNECT BY LEVEL은 dual 테이브과 자주쓴다



LAG(col) : 파티션별 이전 행의 특정 컬럼 값을 가져오는 함수
LEAD(col) : 파티션별 이후 행의 특정 커럼 값으 가져오는 함수

전체 사원의 급여 순위가 자신보다 1단계 낮은 사람의 급여 값을 5번째 컬럼으로 생성
(단, 급여가 같을 경우 입사일자가 빠른사원이 우선순위가 높다)
SELECT empno, ename, hiredate, sal
FROM emp
ORDER BY sal DESC,hiredate;

SELECT empno, ename, hiredate, sal, 
       LEAD(sal) OVER( ORDER BY sal DESC, hiredate) lead_sal,
       LAG(sal) OVER( ORDER BY sal DESC, hiredate) lag_sal
FROM emp;

SELECT empno, ename, hiredate, job, LAG(sal) OVER(PARTITION BY job ORDER BY sal DESC) lag_sal
FROM emp;





SELECT c.*, b.sal
FROM
(SELECT ROWNUM rn, a.*
FROM
(SELECT empno,ename, hiredate, sal
FROM emp
ORDER BY sal DESC) a) c,
(SELECT DECODE(rn,rn,rn+1) ab,sal
FROM
(SELECT ROWNUM rn, sal
FROM
(SELECT sal
FROM emp
ORDER BY sal DESC))
WHERE DECODE(rn,rn,rn+1) BETWEEN 2 AND 14) b
WHERE c.rn = b.ab(+)
ORDER BY b.sal DESC NULLs FIRST


WUNDOWING : 파티션 내의 행들을 세부적으로 선별하는 범위를 기술
UNBOUNDED PRECEDING : 현재 행을 기준으로 선행(이전)하는 모든 행들
CURRENT ROW : 현재행
UNBOUNDED FOLLOWING : 현재행을 기준으로 이후 모든 행들
;
SELECT empno, ename, sal
FROM emp
ORDER BY sal;

SELECT empno, ename, sal, 
SUM(sal) OVER (ORDER BY sal ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum,
SUM(sal) OVER (ORDER BY sal ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) c_sum2
FROM emp;

SELECT empno, ename, deptno ,sal, 
SUM(sal) OVER (PARTITION BY deptno ORDER BY sal,empno RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum4
FROM emp;

WINDOWING 기본 설정값이 존재 : RANGE UNBOUNDED PRECEDING AND CURRENT ROW
SELECT empno, ename, sal, SUM(sal) OVER (ORDER BY sal) c_sum
FROM emp;

SELECT empno, ename, deptno, sal,
    SUM(sal) OVEr ( ORDER BY sal ROWS UNBOUNDED PRECEDING) row_sum,
    SUM(sal) OVEr ( ORDER BY sal RANGE UNBOUNDED PRECEDING) range_sum,
    SUM(sal) OVEr ( ORDER BY sal ) c_sum
FROM emp;


모델링 과정 (요구사항 파악 이후)
개념모델 -  ==> 논리모델 - 물리모델
노닐모델의 요약판

논리 모델 : 시스템에서 필요로하는 엔터티(테이블), 엔터티의 속성, 엔터티간의 관계를 기술
            데이터가 어떻게 저장될지는 관심사항이 아니다 ==> 물리 모델에서 고려할 사항
            논리 모델에서는 데이터의 전반적인 큰 틀을 설계
물리 모델 : 논리 모델을 갖고 해당 시스템이 사용할 데이터베이스를 고려하여 최적화된 
            테이블, 컬럼, 제약조건을 설계하는 단계
            
논리 모델              :    물리 모델            
엔터티(entity) type          테이블
속성(attribute)              컬럼
식별자                        키 => 행을 구분할수 있는 유일한 값
관계(relation)             제약조건

관계 차수 : 1-N, N-N == > 1:N으로 변경할 대상
          수직바, 까마귀발
관계 옵션 : mandatory(필수), optional(옵션) o표기 
요구사항(요구사항 기술서, 장표, 인터뷰)에서 명사 ==> 엔터티 or 속성일 확률이 높다.

개발원x,근무-ㅁ,교직원(교수, 행정직원)O,이름O,hpO,집주소O,이메일O,강의,과목

담당 과목 : 어떤 교수자가 어떤 과목을 담당하는지
교직원번호  과목번호

새 비식별 관계 = > FK
명명규칙
엔터티 : 단수 명사,
        서술식 표현은 잘못된 방법