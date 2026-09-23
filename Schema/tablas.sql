CREATE TABLE products (
    product_id INT PRIMARY KEY,
    category VARCHAR(50),
    brand VARCHAR(50),
    base_price DECIMAL(10,2),
    launch_date DATE,
    is_premium BOOLEAN
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    signup_date DATE,
    country VARCHAR (2),
    age INT,
    gender VARCHAR(20),
    loyalty_tier VARCHAR(50),
    acquisition_channel VARCHAR(50)
);

CREATE TABLE campaigns (
    campaign_id INT PRIMARY KEY,
    channel VARCHAR(50),
    objective VARCHAR(50),
    start_date DATE,
    end_date DATE,
    target_segment VARCHAR(100),
    expected_uplift DECIMAL(6,3)
);

CREATE TABLE events (
    event_id INT PRIMARY KEY,
    timestamp TIMESTAMP,
    customer_id INT REFERENCES customers(customer_id),
    session_id INT,
    event_type VARCHAR(50),
    product_id INT REFERENCES products(product_id),
    device_type VARCHAR(50),
    traffic_source VARCHAR(50),
    campaign_id INT REFERENCES campaigns(campaign_id),
    page_category VARCHAR(50),
    session_duration_sec DECIMAL(10,2),
    experiment_group VARCHAR(50)
);

CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    timestamp TIMESTAMP,
    customer_id INT REFERENCES customers(customer_id),
    product_id INT REFERENCES products(product_id),
    quantity INT,
    discount_applied DECIMAL(10,2),
    gross_revenue DECIMAL(12,2),
    campaign_id INT REFERENCES campaigns(campaign_id),
    refund_flag BOOLEAN
);