CREATE TABLE categories (
    category_id   SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    full_name   VARCHAR(150) NOT NULL,
    email       VARCHAR(150) NOT NULL UNIQUE,
    phone       VARCHAR(20),
    city        VARCHAR(80),
    state       VARCHAR(80),
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
    product_id   SERIAL PRIMARY KEY,
    category_id  INT NOT NULL REFERENCES categories(category_id),
    product_name VARCHAR(200) NOT NULL,
    price        NUMERIC(12,2) NOT NULL CHECK (price > 0),
    stock_qty    INT NOT NULL DEFAULT 0 CHECK (stock_qty >= 0)
);

CREATE TABLE orders (
    order_id    SERIAL PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES customers(customer_id),
    order_date  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status      VARCHAR(20) NOT NULL DEFAULT 'Pending'
                CHECK (status IN ('Pending','Paid','Shipped','Delivered','Cancelled'))
);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id      INT NOT NULL REFERENCES orders(order_id),
    product_id    INT NOT NULL REFERENCES products(product_id),
    quantity      INT NOT NULL CHECK (quantity > 0),
    unit_price    NUMERIC(12,2) NOT NULL
);

CREATE TABLE payments (
    payment_id     SERIAL PRIMARY KEY,
    order_id       INT NOT NULL UNIQUE REFERENCES orders(order_id),
    amount         NUMERIC(12,2) NOT NULL,
    method         VARCHAR(30) NOT NULL
                   CHECK (method IN ('Card','Bank Transfer','Pay on Delivery')),
    payment_status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    paid_at        TIMESTAMP
);

CREATE TABLE deliveries (
    delivery_id      SERIAL PRIMARY KEY,
    order_id         INT NOT NULL UNIQUE REFERENCES orders(order_id),
    delivery_address VARCHAR(255) NOT NULL,
    delivery_status  VARCHAR(20) NOT NULL DEFAULT 'Processing',
    delivered_at     TIMESTAMP
);