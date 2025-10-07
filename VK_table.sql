-- Создаем представление с допполями (время дня и день недели).

CREATE OR REPLACE VIEW vk_page AS 
SELECT id, date, EXTRACT(ISODOW FROM date) as days_of_week, EXTRACT(hour FROM date) as time_of_day, likes,
EXTRACT(epoch FROM (date - LAG(date) OVER (ORDER BY date)))/3600 AS diff_hours
FROM "VK";
SELECT * FROM vk_page;
-- Запрос, группирующий посты по времени суток.COUNT(*) - считаем количество постов в определенный день 
-- сортируем по среднему арифмитическому количеству лайков
SELECT CASE
			WHEN time_of_day < 6 THEN 'ночь'
			WHEN time_of_day < 12 THEN 'утро'
			WHEN time_of_day < 18 THEN 'день'
			ELSE 'вечер'
			END as time_day, 
		COUNT(*) as count_post, ROUND(AVG(likes),2) as avg_likes
FROM vk_page
GROUP BY time_day
ORDER BY avg_likes DESC;
-- Аналогичный запрос, но уже по дням недели. 
SELECT days_of_week, COUNT(*) as count_post, ROUND(AVG(likes),2) as avg_likes
FROM vk_page
GROUP BY days_of_week
ORDER BY avg_likes DESC;
--Запрос, группирующий посты по интервалу выхода постов. С помощью LAG и EPOCH вычисляем разницу с предыдущим постом
-- задаем интервал и вносим разницу в определенный интервал (3 часа, но можно изменить на любой другой интервал) 

SELECT ROUND(diff_hours/3)*3 as interval_h, COUNT(*) as count_post, ROUND(AVG(likes),2) as avg_likes
FROM vk_page
WHERE diff_hours IS NOT NULL
GROUP BY interval_h
ORDER BY interval_h;




DROP VIEW vk_page;