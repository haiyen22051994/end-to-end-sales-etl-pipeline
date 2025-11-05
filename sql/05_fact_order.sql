CREATE OR REPLACE PROCEDURE star_schema.fact_order()
 LANGUAGE plpgsql
AS $procedure$
/*
* Author:  Doan Yen
* Created: 
* Purpose: Load dữ liệu vào fact_order và ghi log
*/
DECLARE
  ERR_NUM TEXT;  
  ERR_MSG VARCHAR(100);
  START_TIME DATE;
BEGIN
  START_TIME := CURRENT_DATE;

  -- Làm mới dữ liệu
  EXECUTE 'TRUNCATE TABLE star_schema.fact_order';

  INSERT INTO star_schema.fact_order(
										    order_purchase_date_id, order_status_id, payment_type_id, product_id, seller_id,
										    payment_installments, total_order, total_customer, total_payment_value, review_score, total_delivered_late,total_seller
										  )
							  SELECT 
							    TO_CHAR(a.order_purchase_timestamp, 'yyyymmdd') AS order_purchase_date_id,
							    b1.order_status_id,
							    b2.payment_type_id,
							    b3.product_id,
							    b4.seller_id,
							    a1.payment_installments,
							    COUNT(DISTINCT a.order_id) AS total_order,
							    COUNT(DISTINCT a.customer_id) AS total_customer,
							    SUM(a1.payment_value) AS total_payment_value,
							    a2.review_score AS review_score,
							    SUM(
							      CASE 
							        WHEN a.order_delivered_customer_date IS NULL THEN 0
							        WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1
							        ELSE 0 
							      END
							    ) AS total_delivered_late,
							    count(DISTINCT a3.seller_id) as total_seller
							  FROM sales_data_raw.olist_orders_dataset a
							  LEFT JOIN sales_data_raw.olist_order_payments_dataset a1 ON a.order_id = a1.order_id 
							  LEFT JOIN sales_data_raw.olist_order_reviews_dataset a2 ON a.order_id = a2.order_id 
							  LEFT JOIN sales_data_raw.olist_order_items_dataset a3 ON a.order_id = a3.order_id 
							  LEFT JOIN sales_data_raw.olist_products_dataset a4 ON a3.product_id = a4.product_id 
							  LEFT JOIN sales_data_raw.product_category_translation a5 ON a4.product_category_name = a5."﻿product_category_name"
							  LEFT JOIN sales_data_raw.olist_sellers_dataset a6 ON a3.seller_id = a6.seller_id 
							  LEFT JOIN star_schema.dim_order_status b1 ON a.order_status = b1.order_status 
							  LEFT JOIN star_schema.dim_payment_type b2 ON b2.payment_type = a1.payment_type 
							  LEFT JOIN star_schema.dim_product b3 ON a5.product_category_name_english = b3.product_category_name_english 
							  LEFT JOIN star_schema.dim_seller b4 ON a6.seller_zip_code_prefix || '-' || a6.seller_city = b4.seller 
							  GROUP BY 
							    TO_CHAR(a.order_purchase_timestamp, 'yyyymmdd'),
							    b1.order_status_id,
							    b2.payment_type_id,
							    b3.product_id,
							    b4.seller_id,
							    a1.payment_installments,
							    a2.review_score ;
INSERT INTO star_schema.report_execution_logs(
  date_id, procedure_name, report_name, run_date, finished_time, run_status, err_cd
)
VALUES (
  CAST(TO_CHAR(CURRENT_DATE, 'YYYYMMDD') AS INT),
  'star_schema.fact_order',
  'fact_order',
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
      'star_schema.fact_order',
      'fact_order',
      START_TIME,
      CURRENT_DATE,
      -1,
      ERR_NUM,
      ERR_MSG
    );
END;
$procedure$
;
