
--==========================--
--Создание собственных типов--
--==========================--

-- Перечисление
CREATE TYPE public.gender AS ENUM ('мужской','женский','неизвестно');

-- домен
CREATE DOMAIN public.positiveint AS integer CHECK (VALUE > 0) ;

-- расширение для UUID
-- для использования типа uuid сначала нужно установить модуль
CREATE EXTENSION "uuid-ossp";
SELECT uuid_generate_v4();
SELECT '2b3b9d53-9b71-4fbc-a3c1-065fca534c67'::uuid;
SELECT PG_TYPEOF('2b3b9d53-9b71-4fbc-a3c1-065fca534c67');
SELECT PG_TYPEOF('2b3b9d53-9b71-4fbc-a3c1-065fca534c67'::uuid);

-- домен с использованием расширений
CREATE EXTENSION citext;
CREATE DOMAIN email AS citext
  CHECK ( value ~ '^[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$' );

SELECT 'asdf@foobar.com'::email;
SELECT 'asdf@foob,,ar.com'::email;
SELECT 'asd@f@foobar.com'::email;

-- =========== --
-- ТИПЫ ДАННЫХ --
-- =========== --

SELECT PG_TYPEOF(100); -- integer
SELECT CAST(100 AS TEXT) -- преобразует число “100” в текст
SELECT '01/01/2021'::DATE -- преобразует строку в дату
SELECT '12.34'::float8::numeric::money; -- результат $12.34

-- ====== --
-- Строки --
-- ====== --

SELECT 'abc' LIKE 'abc';  -- true
SELECT 'abc' LIKE 'a%';  -- true
SELECT 'abc' LIKE '_b_';  -- true
SELECT 'abc' LIKE 'c';  -- false
SELECT 'abc' ILIKE '%c%';  -- true

--Возвращает положение указанной подстроки
SELECT STRPOS('Hello world!', 'world'); -- 7
--Возвращает длину строки:
SELECT CHARACTER_LENGTH('Hello world!'); -- 12
--Заменяет подстроку:
SELECT OVERLAY('Hello world!' PLACING 'Max' FROM 7 FOR 5); -- Hello Max!
SELECT replace('Hello world!', 'world', 'XX') -- Hello XX!
SELECT replace(replace('Hello world!', '!', '') , 'world', '') -- Hello

-- Выбор уникальных значений атрибута sex таблицы pat
SELECT DISTINCT sex FROM public.pat ;
-- Уберем цифры из пола
SELECT DISTINCT regexp_replace(sex, '[\d] - ', '') as sex FROM public.pat ;

--Извлекает подстроку:
SELECT SUBSTRING('Hello world!' FROM 7 FOR 5); -- world

--Соединение строк
SELECT 'Post' || 'greSQL'; -- PostgreSQL
SELECT concat('Post', 'greSQL'); -- PostgreSQL

--Выражение LOWER и UPPER приводит все символы строки в верхний/нижний регистр: 
SELECT lower('BIGTEXT') || upper('smallText') -- bigtextSMALLTEXT


-- Получение родового названия микроорганизма
SELECT DISTINCT strain FROM public.pat;

-- Уберем лишние символы
SELECT DISTINCT
	replace(replace(strain, ';', '') , 'Другой', '')
	as strain
FROM public.pat;

-- Отсечем строку начиная с пробела
SELECT DISTINCT
substring(
	replace(replace(strain, ';', '') , 'Другой', '')
	FROM 1
	FOR STRPOS(replace(replace(strain, ';', '') , 'Другой', ''), ' ')
)
as strain
FROM public.pat;

-- Удалим лишние пробелы
SELECT DISTINCT
trim(
	substring(
		replace(replace(strain, ';', '') , 'Другой', '')
		FROM 1
		FOR STRPOS(replace(replace(strain, ';', '') , 'Другой', ''), ' ')
	)
)
as strain
FROM public.pat;

-- Добавим spp.
SELECT DISTINCT
trim(
	substring(
		replace(replace(strain, ';', '') , 'Другой', '')
		FROM 1
		FOR STRPOS(replace(replace(strain, ';', '') , 'Другой', ''), ' ')
	)
) || ' spp.'
as strain
FROM public.pat;

-- ==== --
-- Даты --
-- ==== --

SELECT EXTRACT(YEAR FROM '2000-12-16'::DATE);
SELECT EXTRACT(YEAR FROM TO_DATE('28.02.2020', 'DD.MM.YYYY'));
SELECT EXTRACT(CENTURY FROM TIMESTAMP '2000-12-16 12:21:13');

SELECT date_part('year', '2020-02-28'::date);
SELECT date_part('hour', INTERVAL '4 hours 3 minutes');
SELECT date_part('year', TO_DATE('28.02.2020', 'DD.MM.YYYY')) ;
SELECT date_part('year', AGE( '2022-11-12'::date, '2000-11-12'::date));

-- получить месяц с учетом года
select date_trunc('month', '2021-02-15'::date) ;

-- получить число с учетом года
select date_trunc('day', '2021-02-15'::date) ;

-- Получение текущего времени
SELECT CURRENT_DATE;
SELECT CURRENT_TIME;
SELECT CURRENT_TIMESTAMP;
SELECT now();