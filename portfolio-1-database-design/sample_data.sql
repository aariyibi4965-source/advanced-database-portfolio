INSERT INTO categories (category_name) VALUES
('Phones & Accessories'), ('Fashion'), ('Home & Kitchen');

INSERT INTO customers (full_name, email, phone, city, state) VALUES
('Chinedu Okafor', 'chinedu.okafor@example.com', '08010000001', 'Ikeja', 'Lagos'),
('Amina Bello',    'amina.bello@example.com',    '08010000002', 'Kano', 'Kano'),
('Tunde Adebayo',  'tunde.adebayo@example.com',  '08010000003', 'Ibadan', 'Oyo'),
('Ngozi Eze',      'ngozi.eze@example.com',      '08010000004', 'Port Harcourt', 'Rivers'),
('Fatima Yusuf',   'fatima.yusuf@example.com',   '08010000005', 'Garki', 'FCT');

INSERT INTO products (category_id, product_name, price, stock_qty) VALUES
(1, 'Fast Charger 20W',         8500.00, 120),
(1, 'Wireless Earbuds',        18500.00,  60),
(2, 'Ankara Fabric (6 yards)', 12000.00,  80),
(2, 'Men Canvas Sneakers',     15000.00,  45),
(3, 'Non-stick Frying Pan',     9500.00,  70),
(3, 'Electric Kettle 1.8L',    14000.00,  30);

INSERT INTO orders (customer_id, status) VALUES
(1, 'Delivered'), (2, 'Shipped'), (3, 'Paid'), (4, 'Pending');

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 2,  8500.00),
(1, 2, 1, 18500.00),
(2, 3, 2, 12000.00),
(3, 5, 1,  9500.00),
(3, 6, 1, 14000.00),
(4, 4, 1, 15000.00);

INSERT INTO payments (order_id, amount, method, payment_status, paid_at) VALUES
(1, 35500.00, 'Card',            'Successful', '2026-10-01 10:15'),
(2, 24000.00, 'Bank Transfer',   'Successful', '2026-10-02 09:40'),
(3, 23500.00, 'Card',            'Successful', '2026-10-03 16:05'),
(4, 15000.00, 'Pay on Delivery', 'Pending',    NULL);

INSERT INTO deliveries (order_id, delivery_address, delivery_status, delivered_at) VALUES
(1, 'Plot 12, Allen Avenue, Ikeja, Lagos', 'Delivered',  '2026-10-05 14:30'),
(2, 'No. 5 Zaria Road, Kano',              'Shipped',    NULL),
(3, '14 Ring Road, Ibadan',                'Processing', NULL),
(4, '21 Aba Road, Port Harcourt',          'Processing', NULL);