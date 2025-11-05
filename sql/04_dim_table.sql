CREATE OR REPLACE PROCEDURE star_schema.dim_table()
 LANGUAGE plpgsql
AS $procedure$
/*
* Author:  Doan Yen
* Created: 
* Purpose: 
*/
DECLARE
  ERR_NUM TEXT;  
  ERR_MSG VARCHAR(100);
  START_TIME DATE;
BEGIN
  START_TIME := CURRENT_DATE;

				  -- Làm mới dim_payment_type
				  EXECUTE 'TRUNCATE TABLE star_schema.dim_payment_type';
				  INSERT INTO star_schema.dim_payment_type(payment_type_id, payment_type)
				  WITH payment_type AS (
				    SELECT DISTINCT payment_type
				    FROM sales_data_raw.olist_order_payments_dataset
				  )
				  SELECT ROW_NUMBER() OVER (ORDER BY payment_type), payment_type
				  FROM payment_type;
				
				  -- Làm mới dim_order_status
				  EXECUTE 'TRUNCATE TABLE star_schema.dim_order_status';
				  INSERT INTO star_schema.dim_order_status(order_status_id, order_status)
				  WITH order_status AS (
				    SELECT DISTINCT order_status
				    FROM sales_data_raw.olist_orders_dataset
				  )
				  SELECT ROW_NUMBER() OVER (ORDER BY order_status), order_status
				  FROM order_status;
				
				  -- Làm mới dim_product
				  EXECUTE 'TRUNCATE TABLE star_schema.dim_product';
				  INSERT INTO star_schema.dim_product(product_id, product_category_name_english)
				  WITH product_table AS (
				    SELECT DISTINCT product_category_name_english
				    FROM sales_data_raw.product_category_translation
				  )
				  SELECT ROW_NUMBER() OVER (ORDER BY product_category_name_english), product_category_name_english
				  FROM product_table;
				
				  -- Làm mới dim_seller
				  EXECUTE 'TRUNCATE TABLE star_schema.dim_seller';
				  INSERT INTO star_schema.dim_seller(seller_id, seller)
				  WITH seller AS (
				    SELECT DISTINCT seller_zip_code_prefix || '-' || seller_city AS seller
				    FROM sales_data_raw.olist_sellers_dataset
				  )
				  SELECT ROW_NUMBER() OVER (ORDER BY seller), seller
				  FROM seller;
				
				  -- Ghi log thành công
INSERT INTO star_schema.report_execution_logs(
   date_id, procedure_name, report_name, run_date, finished_time, run_status, err_cd
)
  VALUES (
CAST(TO_CHAR(CURRENT_DATE, 'YYYYMMDD') AS INT),
 'star_schema.dim_table',
  'dim_table',
START_TIME,
   CURRENT_DATE,
  1,
 NULL
);
EXCEPTION
  WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS
      ERR_MSG = MESSAGE_TEXT,
      ERR_NUM = RETURNED_SQLSTATE;

    INSERT INTO star_schema.report_execution_logs(
      date_id, procedure_name, report_name, run_date, finished_time, run_status, err_cd, err_msg
    )
    VALUES (
      CAST(TO_CHAR(CURRENT_DATE, 'YYYYMMDD') AS INT),
      'star_schema.dim_table',
      'dim_table',
      START_TIME,
      CURRENT_DATE,
      -1,
      ERR_NUM,
      ERR_MSG
    );
END; 
$procedure$
;
