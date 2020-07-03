-- join 실습
SELECT lprod_gu, lprod_nm,prod_id, prod_name
FROM prod,lprod
WHERE prod.prod_lgu = lprod.lprod_gu;

sql 디벨로퍼 페이징처리는 50 

두테이블의 연결 컬럼명이 다르기 때문에 NATURAL JOIN, JOIN WITH USING 사용 불가
SELECT lprod_gu, lprod_nm,prod_id, prod_name
FROM prod JOIN lprod ON (prod_lgu = lprod.lprod_gu);

SELECT buyer_id, buyer_name, prod_id, prod_name
FROM prod, buyer
WHERE prod.prod_buyer = buyer.buyer_id;

SELECT buyer_id, buyer_name, prod_id, prod_name
FROM prod JOIN buyer ON (prod.prod_buyer = buyer.buyer_id);

SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM prod, cart, member
WHERE (prod.prod_id = cart.cart_prod) AND (cart.cart_member = member.mem_id);

SELECT member.mem_id, member.mem_name, prod.prod_id, prod.prod_name, cart.cart_qty
FROM  member JOIN cart ON (cart.cart_member = member.mem_id) 
             JOIN prod ON (prod.prod_id = cart.cart_prod);

customer : 고객
product : 제품
CYCLE(추가) : 고객 제품 애음 주기

SELECT customer.*, pid, day, cnt
FROM customer, cycle
WHERE customer.cid = cycle.cid
AND   cnm IN('brown','sally');

SELECT customer.*,  cycle.pid, pnm, day, cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
AND   cycle.pid = product.pid
AND   cnm IN('brown','sally');


SELECT customer.*, cycle.pid, pnm, SUM(cnt) cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
AND   cycle.pid = product.pid
GROUP BY customer.cnm, cycle.pid, customer.cid,cycle.pid,pnm;


SELECT product.pid, product.pnm, SUM(cnt) cnt
FROM cycle, product
WHERE cycle.pid = product.pid
GROUP BY product.pnm,product.pid;



OUTER <==> INNER JOIN
INNER JOIN : 조인에 성공하는 데이터만 조회하는 조인방법
OUTER JOIN : 조인에 실패 하더라도, 개발자가 지정한 기준이 되는 테이블의 데이터는 나오도록 하는 조인

복습 - 사원의 관리자 이름을 알고싶은 상황
조회 컬럼 : 사원의 사번, 이름, 관리자 사번, 관리자 사번의 이름

동일한 테이블끼리 조인이 되었기 떄문에 : SELF JOIN
조인 조건을 만족하는 데이터만 조회 되었ㄱ 떄문에 : INNER JOIN
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;

King의 경우 PRESIDENT이기 떄문에 mgr 컬럼의 값이 null =>조인 실패
14건의 데이터중 13건의 데이터만 조인 성공

OUTER 조인을 이용하여 조인테이블 중 기준이 되는 테이블을 선택하면
조인에 실패하더라도 기존 테이블의 데이터는 조회 되도록 할 수 있다.

LEFT/RIGHT OUTER
ANSI-SQL 
테이블1 JOIN 테이블2 ON (...)
테이블1 LEFT OUTER JOIN 테이블2 ON (...)
위 쿼리와 아래는 동일
테이블2 RIGHT OuTER JOIN 테이블1 ON

SELECT s.empno, s.ename, m.empno, m.ename
FROM emp s LEFT OUTER JOIN emp m ON (s.mgr = m.empno);