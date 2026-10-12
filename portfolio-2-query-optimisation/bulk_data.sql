-- 1) About 20,000 more customers
INSERT INTO customers (full_name, email, phone, city, state, created_at)
SELECT 'Customer ' || g,
       'customer' || g || '@example.com',
       '0801' || lpad(g::text, 7, '0'),
       (ARRAY['Ikeja','Kano','Ibadan','Port Harcourt','Garki','Enugu','Kaduna','Benin City','Abeokuta','Owerri'])[1 + (g % 10)],
       (ARRAY['Lagos','Kano','Oyo','Rivers','FCT','Enugu','Kaduna','Edo','Ogun','Imo'])[1 + (g % 10)],
       NOW() - make_interval(days => (random() * 365)::int)
FROM generate_series(1, 20000) AS g;

-- 2) 1,000 more products
INSERT INTO products (category_id, product_name, price, stock_qty)
SELECT 1 + (g % 3),
       'Product ' || g,
       round((500 + random() * 49500)::numeric, 2),
       (random() * 200)::int
FROM generate_series(1, 1000) AS g;

-- 3) About 100,000 orders (each customer gets between 1 and 9)
INSERT INTO orders (customer_id, order_date, status)
SELECT c.customer_id,
       NOW() - make_interval(days => (random() * 365)::int),
       (ARRAY['Pending','Paid','Shipped','Delivered','Cancelled'])[1 + floor(random() * 5)::int]
FROM customers c
CROSS JOIN LATERAL generate_series(1, 1 + (c.customer_id % 9)) AS g
WHERE c.customer_id > 5;

-- 4) 1 to 3 items in each new order
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
SELECT o.order_id, p.product_id, 1 + (random() * 4)::int, p.price
FROM orders o
CROSS JOIN LATERAL generate_series(1, 1 + (o.order_id % 3)) AS k
JOIN (
    SELECT product_id, price, row_number() OVER (ORDER BY product_id) AS rn
    FROM products
) p ON p.rn = 1 + ((o.order_id * 31 + k * 17) % (SELECT count(*) FROM products))
WHERE o.order_id > 4;

-- 5) One payment for each new order
INSERT INTO payments (order_id, amount, method, payment_status, paid_at)
SELECT o.order_id,
       t.total,
       (ARRAY['Card','Bank Transfer','Pay on Delivery'])[1 + (o.order_id % 3)],
       CASE o.status WHEN 'Cancelled' THEN 'Failed'
                     WHEN 'Pending'   THEN 'Pending'
                     ELSE 'Successful' END,
       CASE WHEN o.status IN ('Paid','Shipped','Delivered')
            THEN o.order_date + interval '1 hour' END
FROM orders o
JOIN (SELECT order_id, SUM(quantity * unit_price) AS total
      FROM order_items GROUP BY order_id) t ON t.order_id = o.order_id
WHERE o.order_id > 4;

-- 6) One delivery for each new order
INSERT INTO deliveries (order_id, delivery_address, delivery_status, delivered_at)
SELECT o.order_id,
       'Address ' || o.order_id || ', ' || c.city || ', ' || c.state,
       CASE o.status WHEN 'Delivered' THEN 'Delivered'
                     WHEN 'Shipped'   THEN 'Shipped'
                     WHEN 'Cancelled' THEN 'Cancelled'
                     ELSE 'Processing' END,
       CASE WHEN o.status = 'Delivered' THEN o.order_date + interval '4 days' END
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
WHERE o.order_id > 4;

-- 7) Tell PostgreSQL to refresh its statistics
ANALYZE;