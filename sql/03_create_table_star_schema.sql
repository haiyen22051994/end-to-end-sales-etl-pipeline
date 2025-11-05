CREATE TABLE IF NOT EXISTS star_schema.report_execution_logs (
    date_id VARCHAR NOT NULL,    
    procedure_name VARCHAR NOT NULL,
    report_name VARCHAR NOT NULL,
    run_date TIMESTAMP NOT NULL,
    finished_time TIMESTAMP,
    run_status VARCHAR(20),
    err_cd VARCHAR(50),
    err_msg TEXT
);

CREATE TABLE IF NOT EXISTS star_schema.dim_date (
    date_id INT,
    date_value VARCHAR(50),
    daylongname VARCHAR(50),
    dayshortname VARCHAR(50),
    monthlongname VARCHAR(50),
    monthshortname VARCHAR(50),
    calendaryear INT
);

CREATE TABLE IF NOT EXISTS star_schema.dim_payment_type (
    payment_type_id INT NOT NULL,
    payment_type TEXT
);

CREATE TABLE IF NOT EXISTS star_schema.dim_order_status (
    order_status_id INT NOT NULL,
    order_status TEXT
);

CREATE TABLE IF NOT EXISTS star_schema.dim_product (
    product_id INT NOT NULL,
    product_category_name_english TEXT
);

CREATE TABLE IF NOT EXISTS star_schema.dim_seller (
    seller_id INT NOT NULL,
    seller TEXT
);

CREATE TABLE IF NOT EXISTS star_schema.fact_order (
    order_purchase_date_id VARCHAR NOT NULL,
    order_status_id INTEGER,
    payment_type_id INTEGER,
    product_id INTEGER,
    seller_id INTEGER,
    payment_installments INTEGER,
    total_order INTEGER,
    total_customer INTEGER,
    total_payment_value NUMERIC(10, 2),
    review_score INTEGER,
    total_delivered_late INTEGER,
    total_seller INTEGER        
);
