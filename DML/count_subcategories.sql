SELECT c.title, COUNT(c1.id) AS count_subcategory
FROM categories AS c
LEFT JOIN categories AS c1
	ON c.id = c1.parent_id
GROUP BY c.id, c.title
ORDER BY c.path;