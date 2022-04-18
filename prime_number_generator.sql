-- 10^7 простых чисел генерируется за ~ 5 минут
-- 1) в первом запросе генерируем числовую последовательность
-- 2) Во втором запросе генерируем простые числа из этой числовой последовательности

IF OBJECT_ID('tempdb..#numbers') IS NOT NULL
	DROP TABLE #numbers
;
SELECT numbers.number 
INTO #numbers
FROM(SELECT DISTINCT
		 ISNULL(T.t * 1000000, 0) + ISNULL(U.u * 100000, 0) + ISNULL(V.v * 10000, 0) + ISNULL(W.w * 1000, 0) + ISNULL(X.x * 100, 0) + ISNULL(Y.y * 10, 0) + Z.z + 2 AS number
	FROM
		(SELECT 0 z UNION  SELECT 1 UNION  SELECT 2 UNION  SELECT 3 UNION  SELECT 4 UNION  SELECT 5 UNION  SELECT 6 UNION  SELECT 7 UNION  SELECT 8 UNION  SELECT 9) Z 
		FULL OUTER JOIN (SELECT Y.y FROM 
			(SELECT 0 y UNION  SELECT 1 UNION  SELECT 2 UNION  SELECT 3 UNION  SELECT 4 UNION  SELECT 5 UNION  SELECT 6 UNION  SELECT 7 UNION  SELECT 8 UNION  SELECT 9)
			Y WHERE @limit > 10) Y ON 1=1
		FULL OUTER JOIN (SELECT X.x FROM
			(SELECT 0 x UNION  SELECT 1 UNION  SELECT 2 UNION  SELECT 3 UNION  SELECT 4 UNION  SELECT 5 UNION  SELECT 6 UNION  SELECT 7 UNION  SELECT 8 UNION  SELECT 9)
			X WHERE @limit > 100) X ON 1=1
		FULL OUTER JOIN (SELECT W.w FROM (
			SELECT 0 w UNION  SELECT 1 UNION  SELECT 2 UNION  SELECT 3 UNION  SELECT 4 UNION  SELECT 5 UNION  SELECT 6 UNION  SELECT 7 UNION  SELECT 8 UNION  SELECT 9)
			W WHERE @limit > 1000) W ON 1=1
		FULL OUTER JOIN (SELECT V.v FROM
			(SELECT 0 v UNION  SELECT 1 UNION  SELECT 2 UNION  SELECT 3 UNION  SELECT 4 UNION  SELECT 5 UNION  SELECT 6 UNION  SELECT 7 UNION  SELECT 8 UNION  SELECT 9)
			V WHERE @limit > 10000) V ON 1=1
		FULL OUTER JOIN (SELECT U.u FROM
			(SELECT 0 u UNION  SELECT 1 UNION  SELECT 2 UNION  SELECT 3 UNION  SELECT 4 UNION  SELECT 5 UNION  SELECT 6 UNION  SELECT 7 UNION  SELECT 8 UNION  SELECT 9)
			U WHERE @limit > 100000) U ON 1=1
		FULL OUTER JOIN (SELECT T.t FROM
			(SELECT 0 t UNION  SELECT 1 UNION  SELECT 2 UNION  SELECT 3 UNION  SELECT 4 UNION  SELECT 5 UNION  SELECT 6 UNION  SELECT 7 UNION  SELECT 8 UNION  SELECT 9)
			T WHERE @limit > 1000000) T ON 1=1
) AS numbers
WHERE numbers.number <= @limit
	AND (numbers.number % 10 = 1
		 OR numbers.number % 10 = 3
		 OR numbers.number % 10 = 7
		 OR numbers.number % 10 = 9)
;
CREATE INDEX id_number ON #numbers(number)
;
SELECT 
	COUNT(prime_numbers.prime_number) AS count_prime_numbers
FROM(
	SELECT
		numbers1.number AS prime_number
	FROM
		#numbers AS numbers1
		JOIN #numbers AS numbers2
			ON numbers2.number <= SQRT(numbers1.number)
			AND numbers1.number % 2 <> 0 AND numbers1.number % 3 <> 0 AND numbers1.number % 5 <> 0 AND numbers1.number % 7 <> 0
	GROUP BY numbers1.number
	HAVING MIN(numbers1.number % numbers2.number) > 0

	UNION  SELECT 2 WHERE @limit >= 2
	UNION  SELECT 3 WHERE @limit >= 3
	UNION  SELECT 5 WHERE @limit >= 5
	UNION  SELECT 7 WHERE @limit >= 7

) AS prime_numbers
;
DROP TABLE #numbers
