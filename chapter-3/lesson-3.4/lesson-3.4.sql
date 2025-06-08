-- ==========
-- ПРИМЕР ЗАПРОСА
-- ==========

SELECT
	c.city_name , tn.drug_name , 				-- выбор столбцов
	COUNT(*) AS counter							-- агрегирующая функция
FROM public.pat p 								-- источник данных
	INNER JOIN public.therapy_now tn 			-- объединение таблиц
		ON tn.study_subject_id = p.study_subject_id
	LEFT JOIN public.centers c
		ON p.center_id = c.id
WHERE 											-- условие на отбор строк
	p.sex = '2 - Ж' AND tn.drug_name IS NOT NULL
GROUP BY 										-- группировка строк
	c.city_name , tn.drug_name
HAVING 											-- условие для отбора строк
	COUNT(*) > 3									-- после группировки
ORDER BY counter DESC, city_name ASC, drug_name	-- сортировка строк
LIMIT 10 OFFSET 5;								-- ограничение вывода строк

-- ==========
-- ОБЪЕДИНЕНИЕ
-- ==========

-- Таблица с пациентами содержит осложнения
-- Получим 51 пациента
SELECT study_subject_id, compl_icd, compl
FROM public.pat
where center_id = 18;

-- Посмотрим все значения осложнений, какие есть
select distinct center_id, compl_icd, compl
FROM public.pat
where center_id = 18;

-- В таблице icd хранится справочник МКБ-10
select mkb_code, mkb_name
from icd ;

-- Объединим пациентов со справочником МКБ-10
-- Получим 20 пациентов
SELECT p.study_subject_id, p.compl_icd, p.compl, i.mkb_code , i.mkb_name
FROM public.pat p
inner join public.icd i on p.compl_icd = i.mkb_code
where center_id = 18;

-- Если имена столбцов уникальны, можно не писать псевдонимы в select
SELECT study_subject_id, compl_icd, compl, mkb_code , mkb_name
FROM public.pat p
inner join public.icd i on p.compl_icd = i.mkb_code
where center_id = 18;

-- Выберем всех пациентов и допишем к ним справочник
-- Получим 51 пациента
SELECT study_subject_id, compl_icd, compl, mkb_code , mkb_name
FROM public.pat p
left join public.icd i on p.compl_icd = i.mkb_code
where center_id = 18;

-- Выберем весь справочник и допишем к ним пациентов
SELECT study_subject_id, compl_icd, compl, mkb_code , mkb_name
FROM public.pat p
right join public.icd i on p.compl_icd = i.mkb_code


-- Добавим условие по центру
-- Получим 20 пациентов
SELECT study_subject_id, compl_icd, compl, mkb_code , mkb_name
FROM public.pat p
right join public.icd i on p.compl_icd = i.mkb_code
where center_id = 18;


-- C JOIN можно применять группировку
SELECT mkb_code , mkb_name , count(*) as cnt
FROM public.pat p
left join public.icd i on p.compl_icd = i.mkb_code
where center_id = 18
group by mkb_code, mkb_name
having count(*) > 5
order by cnt desc
;

-- ==========
-- СОЕДИНЕНИЕ
-- ==========

-- Осложнения из 18 центра

select distinct mkb_code , mkb_name
FROM public.pat p
left join public.icd i on p.compl_icd = i.mkb_code
where center_id = 18;

select distinct mkb_code , mkb_name
FROM public.pat p
left join public.icd i on p.compl_icd = i.mkb_code
where center_id = 512;

-- UNION
select distinct mkb_code , mkb_name
FROM public.pat p
left join public.icd i on p.compl_icd = i.mkb_code
where center_id = 18
UNION
select distinct mkb_code , mkb_name
FROM public.pat p
left join public.icd i on p.compl_icd = i.mkb_code
where center_id = 512;

-- UNION ALL
select distinct mkb_code , mkb_name
FROM public.pat p
left join public.icd i on p.compl_icd = i.mkb_code
where center_id = 18
union ALL
select distinct mkb_code , mkb_name
FROM public.pat p
left join public.icd i on p.compl_icd = i.mkb_code
where center_id = 512;

-- INTERSECT
select distinct mkb_code , mkb_name
FROM public.pat p
left join public.icd i on p.compl_icd = i.mkb_code
where center_id = 18
intersect
select distinct mkb_code , mkb_name
FROM public.pat p
left join public.icd i on p.compl_icd = i.mkb_code
where center_id = 512;

-- EXCEPT
select distinct mkb_code , mkb_name
FROM public.pat p
left join public.icd i on p.compl_icd = i.mkb_code
where center_id = 18
except
select distinct mkb_code , mkb_name
FROM public.pat p
left join public.icd i on p.compl_icd = i.mkb_code
where center_id = 512;



-- ================
-- Условные функции
-- ================

-- COALESCE - Осложнения у пациента
SELECT p.study_subject_id as id, compl,
	COALESCE(compl, 'Неизвестно')
FROM pat p
WHERE study_subject_id
	IN (2265, 2270, 2271, 2269, 1504 )

-- NULLIF - Осложнения у пациента
SELECT p.study_subject_id as id, compl,
	NULLIF(compl, 'Неизвестно')
FROM pat p
WHERE study_subject_id
	IN (2265, 2270, 2271, 2269, 1504 )

-- Завершение исследования пациентом
SELECT
p.study_subject_id as id,
fv.datefill as study_complete
FROM pat p
	LEFT JOIN final_visit fv ON p.study_subject_id = fv.study_subject_id
WHERE p.study_subject_id BETWEEN 960 AND 967
ORDER BY p.study_subject_id


SELECT
p.study_subject_id as id,
coalesce(fv.datefill::text, 'Не завершил исследование') as study_complete
FROM pat p
	LEFT JOIN final_visit fv ON p.study_subject_id = fv.study_subject_id
WHERE p.study_subject_id BETWEEN 960 AND 967
ORDER BY p.study_subject_id

-- ====
-- CASE
-- ====

-- ПЕРЕКОДИРОВАНИЕ

SELECT id, age,
  CASE
    WHEN age >= 18 AND age <= 44 THEN 'молодой возраст'
    WHEN age >= 45 AND age <= 59 THEN 'средний возраст'
    WHEN age >= 60 AND age <= 74 THEN 'пожилой возраст'
    WHEN age >= 75 AND age <= 90 THEN 'старческий возраст'
    WHEN age > 90 THEN 'долгожители'
    ELSE 'дети'
  END as age_text
FROM (
	SELECT p.study_subject_id as id,
	date_part('year',
age(coalesce (datestrain, datesymp, datediag),  datebirth )
		) as age
	FROM pat p
) t

-- ОЧИСТКА ДАННЫХ

SELECT study_subject_id ,  strain,
CASE
	WHEN strain is null THEN 'Не выделен'
	WHEN strain = 'Klebsiella spp.;Другой' THEN 'Klebsiella spp.'
	ELSE strain
END as strain_normalized
FROM pat

-- СОРТИРОВКА РЕЗУЛЬТАТОВ

SELECT *
FROM pat p
ORDER BY  CASE
    WHEN compl is null  THEN 'без осложнений'
    WHEN compl = 'Нет'  THEN 'без осложнений'
    WHEN compl = 'Неизвестно'  THEN 'без осложнений'
    ELSE 'с осложнениями'
  END






-- ================
-- ФУНКЦИИ ДЛЯ РАБОТЫ С МАССИВАМИ
-- ================

-- Раскладывание значений на несколько строк

SELECT distinct
study_subject_id ,
compl,
unnest(  string_to_array(compl, ';')) compl_single
FROM pat
WHERE strpos(compl, ';') > 0
ORDER BY study_subject_id, compl_single

-- Сворачивание нескольких строк в одно значение

SELECT study_subject_id , STRING_AGG(compl_single, ';') as compl
FROM (
	SELECT distinct
	study_subject_id ,
	unnest(  string_to_array(compl, ';')) compl_single
	FROM pat
	WHERE strpos(compl, ';') > 0
	ORDER BY study_subject_id, compl_single
) t
GROUP BY study_subject_id



-- ==========
-- ПОДЗАПРОСЫ
-- ==========

-- Подзапросы: отдельное значение
SELECT c2."name" as city_name,
	Count(study_subject_id) as cnt,
	ROUND((count(study_subject_id) /
		(
		SELECT Count(study_subject_id) FROM pat
		)::decimal) * 100, 2) as prc
FROM pat p
	LEFT JOIN centers c ON p.center_id = c.id
	LEFT JOIN cities c2 ON c.city_id = c2.id
GROUP BY c2."name"
ORDER BY prc DESC


-- Подзапросы: таблица
SELECT p.diag, q.mnnname, SUM(q.cnt) as cnt
FROM pat p
INNER JOIN (
	SELECT study_subject_id, dr.mnnname, Count(1) as cnt
	FROM public.therapy_now tn INNER JOIN data_rls dr ON tn.drug_name = dr.tradename
	WHERE drug_name is not null
	GROUP BY study_subject_id, dr.mnnname
) q ON p.study_subject_id = q.study_subject_id
GROUP BY p.diag, q.mnnname
ORDER BY p.diag, cnt DESC

-- Подзапросы: одномерный массив
SELECT c2."name" as city_name,
	Count(study_subject_id) as cnt
FROM pat p
	LEFT JOIN centers c ON p.center_id = c.id
	LEFT JOIN cities c2 ON c.city_id = c2.id
WHERE p.study_subject_id IN (
		SELECT study_subject_id
		FROM public.therapy_now
		WHERE drug_name is not null )
GROUP BY c2."name"
ORDER BY cnt DESC


