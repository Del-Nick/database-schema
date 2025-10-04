BEGIN;

-- 1) Получили клиента
WITH sel_customer AS (
  SELECT id AS customer_id
  FROM customers
  WHERE name = 'Customer 1'
  ORDER BY id
  LIMIT 1
),

-- 2) Добавили заказ в orders
new_order AS (
  INSERT INTO orders (customer_id)
  SELECT customer_id FROM sel_customer
  RETURNING id
),

-- 3) Выбрали товары для добавления
items(name, path, quantity) AS (
  VALUES
    ('Honor MagicBook X14 2', 'computers.notebooks.17_inches', 3),
	('Indesit Fridge DS143', 'appliances.fridges.single_chamber_fridges', 2)
),

-- 4) Получили product_id
products_to_add AS (
  SELECT
    i.name,
    i.quantity,
    p.id            AS product_id,
    p.price         AS unit_price,
    (SELECT id FROM new_order) AS order_id
  FROM items AS i
  LEFT JOIN categories AS c
    ON c.path = text2ltree(i.path)
  LEFT JOIN products AS p
    ON p.name = i.name AND p.category_id = c.id -- считаем, что имя уникально внутри подкатегории
)

-- 5) Вставляем позиции заказа
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
SELECT order_id, product_id, quantity, unit_price
FROM products_to_add;


------------------------------------------------------------------------------------------------------------------------


-- 1) Получили клиента
WITH sel_customer AS (
  SELECT id AS customer_id
  FROM customers
  WHERE name = 'Customer 2'
  ORDER BY id
  LIMIT 1
),

-- 2) Добавили заказ в orders
new_order AS (
  INSERT INTO orders (customer_id)
  SELECT customer_id FROM sel_customer
  RETURNING id
),

-- 3) Выбрали товары для добавления
items(name, path, quantity) AS (
  VALUES
    ('Samsung 4K SWQD123', 'appliances.TV', 1),
	('Hayer WDNQ214', 'appliances.washing_machine', 1)
),

-- 4) Получили product_id
products_to_add AS (
  SELECT
    i.name,
    i.quantity,
    p.id            AS product_id,
    p.price         AS unit_price,
    (SELECT id FROM new_order) AS order_id
  FROM items AS i
  LEFT JOIN categories AS c
    ON c.path = text2ltree(i.path)
  LEFT JOIN products AS p
    ON p.name = i.name AND p.category_id = c.id -- считаем, что имя уникально внутри подкатегории
)

-- 5) Вставляем позиции заказа
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
SELECT order_id, product_id, quantity, unit_price
FROM products_to_add;

COMMIT;
