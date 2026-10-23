-- Portfolio 3: Transactions and Concurrency (Kasuwa Express)

-- Experiment 1: successful order (COMMIT)
BEGIN;
INSERT INTO orders (customer_id, status) VALUES (1, 'Paid');
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
SELECT currval(pg_get_serial_sequence('orders', 'order_id')), product_id, 2, price
FROM products WHERE product_id = 1;
UPDATE products SET stock_qty = stock_qty - 2 WHERE product_id = 1;
INSERT INTO payments (order_id, amount, method, payment_status, paid_at)
SELECT currval(pg_get_serial_sequence('orders', 'order_id')), 2 * price, 'Card', 'Successful', NOW()
FROM products WHERE product_id = 1;
INSERT INTO deliveries (order_id, delivery_address, delivery_status)
SELECT currval(pg_get_serial_sequence('orders', 'order_id')), 'Plot 12, Allen Avenue, Ikeja, Lagos', 'Processing';
COMMIT;

-- Experiment 2: failed order (ROLLBACK)
BEGIN;
INSERT INTO orders (customer_id, status) VALUES (2, 'Paid');
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
SELECT currval(pg_get_serial_sequence('orders', 'order_id')), product_id, 100, price
FROM products WHERE product_id = 6;
UPDATE products SET stock_qty = stock_qty - 100 WHERE product_id = 6;  -- fails: stock cannot go below 0
ROLLBACK;

-- Experiment 3A: lost update (two sessions, no locking)
-- TAB A: BEGIN; SELECT stock_qty FROM products WHERE product_name = 'Concurrency Test Item';
-- TAB B: BEGIN; SELECT stock_qty FROM products WHERE product_name = 'Concurrency Test Item';
-- TAB A: UPDATE products SET stock_qty = 9 WHERE product_name = 'Concurrency Test Item'; COMMIT;
-- TAB B: UPDATE products SET stock_qty = 9 WHERE product_name = 'Concurrency Test Item'; COMMIT;
-- Final stock is 9 but should be 8

-- Experiment 3B: row locking with FOR UPDATE
-- TAB A: BEGIN; SELECT stock_qty FROM products WHERE product_name = 'Concurrency Test Item' FOR UPDATE;
-- TAB B: BEGIN; SELECT ... FOR UPDATE;   (waits for TAB A)
-- TAB A: UPDATE products SET stock_qty = 9 WHERE product_name = 'Concurrency Test Item'; COMMIT;
-- TAB B: (receives 9) UPDATE products SET stock_qty = 8 WHERE product_name = 'Concurrency Test Item'; COMMIT;
-- Final stock is 8 (correct)

-- Experiment 4: isolation levels
-- TAB A: BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ; SELECT ...;   (10)
-- TAB B: UPDATE products SET stock_qty = 5 WHERE product_name = 'Concurrency Test Item';
-- TAB A: SELECT ...;  (still 10 under REPEATABLE READ; would show 5 under READ COMMITTED)