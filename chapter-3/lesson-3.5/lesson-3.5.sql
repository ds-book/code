-- ===============================
-- Материализованные представления
-- ===============================

-- Создадим материализованное представление
CREATE MATERIALIZED VIEW vw_city_top_5_materialize
AS
SELECT c2.name AS city_name,
    count(*) AS patient_count,
    min(p.age) AS min_age,
    round(avg(p.age)) AS avg_days,
    max(p.age) AS max_age
   FROM pat p
     LEFT JOIN centers c ON c.id = p.center_id
     LEFT JOIN cities c2 ON c2.id = c.city_id
  GROUP BY c2.name
 HAVING count(*) > 1
  ORDER BY (count(*)) DESC, (round(avg(p.age)))
 LIMIT 5;

-- Создадим обычное представление
CREATE VIEW vw_city_top_5
AS
SELECT c2.name AS city_name,
    count(*) AS patient_count,
    min(p.age) AS min_age,
    round(avg(p.age)) AS avg_days,
    max(p.age) AS max_age
   FROM pat p
     LEFT JOIN centers c ON c.id = p.center_id
     LEFT JOIN cities c2 ON c2.id = c.city_id
  GROUP BY c2.name
 HAVING count(*) > 1
  ORDER BY (count(*)) DESC, (round(avg(p.age)))
 LIMIT 5;

 -- Посмотрим на результат материализованного представления
SELECT city_name, patient_count, min_age, avg_days, max_age
FROM public.vw_city_top_5_materialize;

-- Посмотрим на результат обычного представления
SELECT city_name, patient_count, min_age, avg_days, max_age
FROM public.vw_city_top_5;

-- Теперь обновим исходную таблицу с пациентами
-- Добавим к дате взятия образца 1 год
update pat set datestrain = datestrain + interval '1 year';

-- Посмотрим на результат материализованного представления
SELECT city_name, patient_count, min_age, avg_days, max_age
FROM public.vw_city_top_5_materialize;

-- Посмотрим на результат обычного представления
SELECT city_name, patient_count, min_age, avg_days, max_age
FROM public.vw_city_top_5;

-- Чтобы материализованное представление отображало реальные данные,
-- его нужно обновить
REFRESH MATERIALIZED VIEW vw_city_top_5_materialize;

-- Посмотрим на результат материализованного представления
SELECT city_name, patient_count, min_age, avg_days, max_age
FROM public.vw_city_top_5_materialize;

-- Посмотрим на результат обычного представления
SELECT city_name, patient_count, min_age, avg_days, max_age
FROM public.vw_city_top_5;

-- Сравним оба представления по тому, как обрабатывается запрос
EXPLAIN ANALYZE SELECT * from vw_city_top_5;
EXPLAIN ANALYZE SELECT * from vw_city_top_5_materialize;





-- ==================================================
-- Наборы группирования: GROUPING SETS, CUBE и ROLLUP
-- ==================================================

-- Обычная группировка

select c2.name as city_name, p.diag, count(1) as cnt
from pat p
inner join centers c on p.center_id = c.id
inner join cities c2 on c.city_id = c2.id
group by c2.name, p.diag
order by c2.name, p.diag

-- GROUPING SETS
select c2.name as city_name, p.diag, count(1) as cnt
from pat p
inner join centers c on p.center_id = c.id
inner join cities c2 on c.city_id = c2.id
group by grouping sets ((c2.name), (p.diag), ())
order by c2.name, p.diag

-- Сгрупируем для подсчета итогов в рамках групп
select c2.name as city_name, p.diag, count(1) as cnt
from pat p
inner join centers c on p.center_id = c.id
inner join cities c2 on c.city_id = c2.id
group by grouping sets ((c2.name, p.diag), (c2.name), (p.diag), ())
order by c2.name, p.diag

-- Добавим заполняющий текст
select
	coalesce(c2.name, 'ВСЕГО') as city_name,
	coalesce(p.diag, 'ВСЕГО') as diag,
	count(1) as cnt
from pat p
inner join centers c on p.center_id = c.id
inner join cities c2 on c.city_id = c2.id
group by grouping sets ((c2.name, p.diag), (c2.name), (p.diag), ())
order by c2.name, p.diag

-- ROLLUP

select c2.name as city_name, p.diag, count(1) as cnt
from pat p
inner join centers c on p.center_id = c.id
inner join cities c2 on c.city_id = c2.id
group by rollup (c2.name, p.diag)
order by c2.name, p.diag

-- CUBE

select c2.name as city_name, p.diag, count(1) as cnt
from pat p
inner join centers c on p.center_id = c.id
inner join cities c2 on c.city_id = c2.id
group by cube (c2.name, p.diag)
order by c2.name, p.diag





-- ====
-- WITH
-- ====

-- WITH SELECT

-- Задача подсчитать количество пациентов в каждом центре,
-- долю пациентов в каждом центре относительно пациентов города
-- для 5 городов с наибольшим количеством пациентов

with city_pat as (
  -- считаем количество пациентов в каждом городе
  select
    c2.name as city_name , count(1) as city_pat_count
  from pat p
    inner join centers c on p.center_id = c.id
    inner join cities c2 on c.city_id = c2.id
  group by c2.name
), top_city as (
  -- выбираем топ 5 городов, чтобы найти id центров
  select *
    from city_pat
    order by city_pat_count desc
    limit 5
)
-- посчитаем долю пациентов центра от города в целом
select
c.center_name, t.city_name,
count(1) as pat_center,
t.city_pat_count as pat_city,
round(100* count(1) / t.city_pat_count,2)  as pat_percent
from pat p
  inner join centers c on p.center_id = c.id
  inner join cities c2 on c.city_id = c2.id
  inner join top_city t on c2.name = t.city_name
group by c.center_name, t.city_name, t.city_pat_count

-- WITH RECURSIVE

-- Пример, суммирующий числа от 1 до 100:
WITH RECURSIVE t(n) AS (
    VALUES (1)
  UNION ALL
    SELECT n+1 FROM t WHERE n < 100
)
SELECT sum(n) FROM t;

-- Справочник препаратов

SELECT recid, atc_code, atc_name, atc_name_eng, num, high
FROM public.atx;

-- Посмотрим на самые верхние уровни в классификации
SELECT recid, atc_code, atc_name, atc_name_eng, num, high
FROM public.atx
where high is null;

-- Получим препараты первых трех уровней
WITH RECURSIVE search_tree(recid, atc_code, atc_name, high, depth) AS (
    SELECT t.recid, t.atc_code, t.atc_name, t.high, 0
    FROM public.atx t
    where recid = 1
  UNION ALL
    SELECT t.recid, t.atc_code, t.atc_name, t.high, t2.depth + 1
    FROM public.atx t, search_tree t2
    WHERE t.high = t2.recid and t2.depth < 2
)
SELECT * FROM search_tree ORDER BY depth;





-- ===============
-- ОКОННЫЕ ФУНКЦИИ
-- ===============

-- функция row_number нумерует строки в рамках окна
SELECT study_subject_id as id, drug_name, datestart, dose, freq,
	row_number() OVER (	PARTITION BY study_subject_id ORDER BY datestart )
FROM public.therapy_now
	WHERE drug_name IS NOT NULL
		AND study_subject_id IN (1071,735,905,759,1797)
ORDER BY study_subject_id, datestart

-- функция dense_rank ранжирует строки без пропусков
SELECT study_subject_id as id, drug_name, datestart, dose, freq,
	dense_rank() OVER ( PARTITION BY study_subject_id ORDER BY datestart )
FROM public.therapy_now
	WHERE drug_name IS NOT NULL
		AND study_subject_id IN (1071,735,905,759,1797)
ORDER BY study_subject_id, datestart

-- функция rank ранжирует строки с пропусками
SELECT study_subject_id as id, drug_name, datestart, dose, freq,
	rank() OVER ( PARTITION BY study_subject_id ORDER BY datestart )
FROM public.therapy_now
	WHERE drug_name IS NOT NULL
		AND study_subject_id IN (1071,735,905,759,1797)
ORDER BY study_subject_id, datestart

-- Можем не указывать партицию, тогда оконные функции будут применяться на весь запрос
SELECT study_subject_id as id, drug_name, datestart, dose, freq,
 row_number() OVER ( ORDER BY study_subject_id, datestart )
FROM public.therapy_now
	WHERE drug_name IS NOT NULL
		AND study_subject_id IN (1071,735,905,759,1797)
ORDER BY study_subject_id, datestart

-- Можем не указывать также и порядок сортировки
SELECT study_subject_id as id, drug_name, datestart, dose, freq,
 row_number() OVER ()
FROM public.therapy_now
	WHERE drug_name IS NOT NULL
		AND study_subject_id IN (1071,735,905,759,1797)
ORDER BY study_subject_id, datestart

-- Задавать условие WHERE к оконной функции можно только через подзапросы
-- Здесь мы выбираем первый назначенный препарат
SELECT *
FROM (
	SELECT study_subject_id as id, drug_name, datestart, dose, freq,
		row_number() OVER (
			PARTITION BY study_subject_id
			ORDER BY datestart )
	FROM public.therapy_now
		WHERE drug_name IS NOT NULL
			AND study_subject_id IN (1071,735,905,759,1797)
	ORDER BY study_subject_id, datestart
) t
WHERE t.row_number = 1

-- Одно окно для разных функций можно выносить в алиас
SELECT study_subject_id as id, drug_name, datestart, dose, freq,
	row_number() OVER w,
	rank() OVER w,
	dense_rank() OVER w
FROM public.therapy_now
	WHERE drug_name IS NOT NULL
		AND study_subject_id IN (1071,735,905,759,1797)
WINDOW W as ( PARTITION BY study_subject_id ORDER BY datestart )
ORDER BY study_subject_id, datestart





-- ==================
-- ПРОИЗВОДИТЕЛЬНОСТЬ
-- ==================

-- Тестовая таблица в миллион строк
drop table if exists foo;
CREATE TABLE foo (c1 integer, c2 text, c3 integer);
INSERT INTO foo
  SELECT i, md5(random()::text), floor(random() * 10 + 1)
  FROM generate_series(1, 1000000) AS i;

-- Попробуем прочитать данные
EXPLAIN SELECT * FROM foo;

--Попробуем добавить 10 строк.
INSERT INTO foo
  SELECT i, md5(random()::text), floor(random() * 10 + 1)
  FROM generate_series(1, 10) AS i;

EXPLAIN SELECT * FROM foo;

-- Значения rows не изменились, потому что не обновлялась статистика по таблице
ANALYZE foo;
EXPLAIN SELECT * FROM foo;

-- Результаты работы ANALYZE
select * from pg_catalog.pg_stats
where tablename = 'foo';

-- Результат на реальных данных
EXPLAIN (ANALYZE) SELECT * FROM foo;

select * from pg_catalog.pg_stats
where tablename = 'foo';

-- Добавим в запрос условие
DROP index if EXISTS foo_c1_idx;

EXPLAIN SELECT * FROM foo WHERE c1 > 700000;
EXPLAIN (ANALYZE) SELECT * FROM foo WHERE c1 > 700000;

-- Создадим индекс
CREATE index foo_c1_idx ON foo(c1);
EXPLAIN (ANALYZE) SELECT * FROM foo WHERE c1 > 700000;

-- Добавим новое условие
EXPLAIN SELECT * FROM foo WHERE c1 < 500 AND c2 LIKE 'abcd%';
EXPLAIN SELECT * FROM foo WHERE c2 LIKE 'abcd%';

-- Создадим индекс и по второму полю
drop index  if exists foo_c2_idx;
CREATE index foo_c2_idx ON foo(c2);
EXPLAIN (ANALYZE) SELECT * FROM foo WHERE c2 LIKE 'abcd%';

-- Индекс не используется потому, что база данных для текстовых полей использует формат UTF-8.
-- При создании индекса в таких случаях надо использовать класс оператора text_pattern_ops
drop index foo_c2_idx;
CREATE index foo_c2_idx ON foo(c2 text_pattern_ops);
EXPLAIN SELECT * FROM foo WHERE c2 LIKE 'abcd%';

-- Выберем только поле, включенное в индекс
EXPLAIN SELECT c1 FROM foo WHERE c1 < 500;

-- Запрос с сортировкой без индекса
DROP INDEX foo_c1_idx;
EXPLAIN (ANALYZE) SELECT * FROM foo ORDER BY c1;

-- Запрос с сортировкой с индексом
CREATE index foo_c1_idx ON foo(c1);
EXPLAIN (ANALYZE) SELECT * FROM foo ORDER BY c1;

-- Запрос с LIMIT
DROP INDEX foo_c2_idx;
EXPLAIN (ANALYZE) SELECT * FROM foo WHERE c2 LIKE 'ab%';
EXPLAIN (ANALYZE) SELECT * FROM foo WHERE c2 LIKE 'ab%' LIMIT 10;

CREATE INDEX foo_c2_idx ON foo(c2 text_pattern_ops);
EXPLAIN (ANALYZE) SELECT * FROM foo WHERE c2 LIKE 'ab%';
EXPLAIN (ANALYZE) SELECT * FROM foo WHERE c2 LIKE 'ab%' LIMIT 10;

-- Запросы с JOIN
-- Создадим новую таблицу
CREATE TABLE bar (c1 integer, c2 boolean);
INSERT INTO bar
  SELECT i, i%2=1
  FROM generate_series(1, 500000) AS i;
ANALYZE bar;

-- Без индекса
EXPLAIN (ANALYZE) SELECT * FROM foo JOIN bar ON foo.c1=bar.c1;

-- С индексом
CREATE index bar_c1_idx ON bar(c1);
EXPLAIN (ANALYZE) SELECT * FROM foo JOIN bar ON foo.c1=bar.c1;

-- LEFT JOIN
SET enable_seqscan TO on;
EXPLAIN (ANALYZE) SELECT * FROM foo LEFT JOIN bar ON foo.c1=bar.c1;
-- Запрес seq scan
SET enable_seqscan TO off;
EXPLAIN (ANALYZE) SELECT * FROM foo LEFT JOIN bar ON foo.c1=bar.c1;
-- Уменьшим объем рабочей памяти
SET work_mem TO '15MB';
SET enable_seqscan TO ON;
EXPLAIN (ANALYZE) SELECT * FROM foo LEFT JOIN bar ON foo.c1=bar.c1;

-- Агрегирующие функции Count
DROP INDEX foo_c2_idx;
EXPLAIN SELECT count(*) FROM foo;
EXPLAIN (ANALYZE) SELECT count(*) FROM foo;

-- Агрегирующие функции MAX
EXPLAIN SELECT max(c2) FROM foo;
EXPLAIN (ANALYZE) SELECT max(c2) FROM foo;

CREATE index foo_c2_idx ON foo(c2);

EXPLAIN (ANALYZE) SELECT count(*) FROM foo;
EXPLAIN (ANALYZE) SELECT max(c2) FROM foo;

-- Агрегирующие фукнции с GROUP BY
DROP INDEX foo_c2_idx;
EXPLAIN (ANALYZE) SELECT c2, count(*) FROM foo GROUP BY c2;

-- Увеличим память
SET work_mem TO '200MB';
EXPLAIN (ANALYZE) SELECT c2, count(*) FROM foo GROUP BY c2;

-- Добавим индекс
RESET work_mem;
CREATE index foo_c2_idx ON foo(c2);
EXPLAIN (ANALYZE) SELECT c2, count(*) FROM foo GROUP BY c2;


-- ==================
-- ПОЛЕЗНЫЕ ЗАПРОСЫ
-- ==================

-- Поиск медленных запросов
SELECT * FROM pg_stat_statements
ORDER BY total_time DESC;

-- Ищем отсутствующие индексы
SELECT
  relname,
  seq_scan - idx_scan AS too_much_seq,
  CASE
    WHEN
      seq_scan - coalesce(idx_scan, 0) > 0
    THEN
      'Missing Index?'
    ELSE
      'OK'
  END,
  pg_relation_size(relname::regclass) AS rel_size, seq_scan, idx_scan
FROM
  pg_stat_all_tables
WHERE
  schemaname = 'public'
  AND pg_relation_size(relname::regclass) > 80000
ORDER BY
  too_much_seq DESC;


-- Ищем ненужные индексы
SELECT
  indexrelid::regclass as index,
  relid::regclass as table,
  'DROP INDEX ' || indexrelid::regclass || ';' as drop_statement
FROM
  pg_stat_user_indexes
  JOIN
    pg_index USING (indexrelid)
WHERE
  idx_scan = 0
  AND indisunique is false;
