CREATE TABLE IF NOT EXISTS sales_data_raw.olist_customers_dataset (
    customer_id VARCHAR NOT NULL,
    customer_unique_id VARCHAR,
    customer_zip_code_prefix VARCHAR(10),
    customer_city VARCHAR,
    customer_state VARCHAR(2),
    created_date DATE
);

CREATE TABLE IF NOT EXISTS sales_data_raw.olist_geolocation_dataset (
    geolocation_zip_code_prefix VARCHAR(10) NOT NULL,
    geolocation_lat DOUBLE PRECISION,
    geolocation_lng DOUBLE PRECISION,
    geolocation_city VARCHAR,
    geolocation_state VARCHAR(2),
    created_date DATE
);

CREATE TABLE IF NOT EXISTS sales_data_raw.olist_order_items_dataset (
    order_id VARCHAR NOT NULL,
    order_item_id INTEGER NOT NULL,
    product_id VARCHAR,
    seller_id VARCHAR,
    shipping_limit_date TIMESTAMP,
    price DOUBLE PRECISION,
    freight_value DOUBLE PRECISION,
    created_date DATE
);

CREATE TABLE IF NOT EXISTS sales_data_raw.olist_order_payments_dataset (
    order_id VARCHAR NOT NULL,
    payment_sequential INTEGER NOT NULL,
    payment_type VARCHAR,
    payment_installments INTEGER,
    payment_value DOUBLE PRECISION,
    created_date DATE
);

CREATE TABLE IF NOT EXISTS sales_data_raw.olist_order_reviews_dataset (
    review_creation_date TIMESTAMP,
    created_date DATE,
    review_id VARCHAR,
    review_answer_timestamp VARCHAR,
    order_id VARCHAR,
    review_score INTEGER
);

CREATE TABLE IF NOT EXISTS sales_data_raw.olist_orders_dataset (
    order_id VARCHAR NOT NULL,
    customer_id VARCHAR,
    order_status VARCHAR,
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP,
    created_date DATE
);

CREATE TABLE IF NOT EXISTS sales_data_raw.olist_products_dataset (
    product_id VARCHAR NOT NULL,
    product_category_name VARCHAR,
    product_name_lenght INTEGER,
    product_description_lenght INTEGER,
    product_photos_qty INTEGER,
    product_weight_g INTEGER,
    product_length_cm INTEGER,
    product_height_cm INTEGER,
    product_width_cm INTEGER,
    created_date DATE
);

CREATE TABLE IF NOT EXISTS sales_data_raw.olist_sellers_dataset (
    seller_id VARCHAR NOT NULL,
    seller_zip_code_prefix VARCHAR(10),
    seller_city VARCHAR,
    seller_state VARCHAR(2),
    created_date DATE
);

CREATE TABLE IF NOT EXISTS sales_data_raw.product_category_translation (
    product_category_name VARCHAR NOT NULL,
    product_category_name_english VARCHAR,
    created_date DATE
);

CREATE TABLE IF NOT EXISTS sales_data_raw.report_execution_logs (
    date_id VARCHAR NOT NULL,    
    procedure_name VARCHAR NOT NULL,
    report_name VARCHAR NOT NULL,
    run_date TIMESTAMP NOT NULL,
    finished_time TIMESTAMP,
    run_status VARCHAR(20),
    err_cd VARCHAR(50),
    err_msg TEXT
);
