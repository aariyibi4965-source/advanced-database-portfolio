--Query 1: Top 10 customers by money spent--
SELECT c.customer_id, c.full_name, c.state,
       SUM(oi.quantity * oi.unit_price) AS total_spent
FROM customers c
JOIN orders o       ON o.customer_id = c.customer_id
JOIN order_items oi ON oi.order_id   = o.order_id
WHERE o.status IN ('Paid', 'Shipped', 'Delivered')
GROUP BY c.customer_id, c.full_name, c.state
ORDER BY total_spent DESC
LIMIT 10;
--Query 2:10 best-selling products--
 SELECT p.product_name, cat.category_name, SUM(oi.quantity) AS units_sold
FROM order_items oi
JOIN products p    ON p.product_id   = oi.product_id
JOIN categories cat ON cat.category_id = p.category_id
JOIN orders o      ON o.order_id     = oi.order_id
WHERE o.status <> 'Cancelled'
GROUP BY p.product_name, cat.category_name
ORDER BY units_sold DESC
LIMIT 10;
--Query 3: Sales (revenue) per state--
SELECT c.state,
       COUNT(DISTINCT o.order_id)        AS orders,
       SUM(oi.quantity * oi.unit_price)  AS revenue
FROM customers c
JOIN orders o       ON o.customer_id = c.customer_id
JOIN order_items oi ON oi.order_id   = o.order_id
WHERE o.status IN ('Paid', 'Shipped', 'Delivered')
GROUP BY c.state
ORDER BY revenue DESC;
--
