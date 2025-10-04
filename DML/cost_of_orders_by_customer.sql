SELECT c.name, SUM(i.quantity * i.unit_price)
FROM orders as o
JOIN customers AS c
    ON c.id = o.customer_id
JOIN order_items AS i
    ON i.order_id = o.id
GROUP BY c.name;