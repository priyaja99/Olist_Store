-- Data Import:-------------------------------------------------------------------------------------------------

create database olist_database;

use olist_database;

-- Tables Created -----------

-- olist_orders_dataset
-- olist_order_reviews_dataset
-- olist_customers_dataset
-- olist_order_payments_dataset
-- olist_order_items_dataset
-- olist_products_dataset

create table olist_orders_dataset (order_id varchar(100), customer_id varchar(100), order_status varchar(100),
order_purchase_timestamp datetime, order_approved_at datetime, order_delivered_carrier_date datetime, 
order_delivered_customer_date datetime, order_estimated_delivery_date datetime);


drop table  olist_orders_dataset;
select * from  olist_orders_dataset;


create table olist_order_reviews_dataset(review_id varchar(100), order_id varchar(100), review_score int,
review_creation_date datetime, review_answer_timestamp datetime , date_diff decimal);
drop table olist_order_reviews_dataset;

select * from olist_order_reviews_dataset;



create table olist_customers_dataset(customer_id varchar(100), customer_unique_id varchar(100), customer_zip_code_prefix int ,
 customer_city varchar(100),
customer_state varchar(100));

select * from olist_customers_dataset;

create table olist_order_payments_dataset (order_id varchar(100), payment_sequential int, payment_type varchar(100), payment_installments int,
payment_value decimal );

select * from olist_order_payments_dataset;

create table olist_order_items_dataset (order_id varchar(100), order_item_id int , product_id varchar (100),
 seller_id varchar(100),shipping_limit_date datetime, 
price decimal, freight_value decimal);

select * from olist_order_items_dataset;

create table olist_products_dataset ( product_id varchar(100), product_category_name varchar(100),
 product_name_lenght int, product_description_lenght int,
product_photos_qty int, product_weight_g int, product_length_cm int, product_height_cm int, product_width_cm int);

select * from olist_products_dataset;

-- 1st ----KPI's ------------------------------------------------------------------------------------------------------------------------------------------
-- Weekday vs weekend (order_purchases_timestamp) payment_statistics
select count(payment_value) as weekday_count,sum(payment_value) as sum_of_payment_value,avg(payment_value) as avg_of_payment_value,
max(payment_value) as max_payment_value, min(payment_value) as min_payment_value,
stddev(payment_value) as std_of_payment_value from olist_orders_dataset
left join olist_order_payments_dataset
using (order_id)
where weekday(order_purchase_timestamp) <5;

select count(order_purchase_timestamp) as weekend_count,sum(payment_value) as sum_of_payment_value,
avg(payment_value) as avg_of_payment_value,max(payment_value) as max_payment_value, min(payment_value) as min_payment_value,
std(payment_value) as std_of_payment_value from olist_orders_dataset
right join olist_order_payments_dataset
using (order_id)
where weekday(order_purchase_timestamp) >=5;

-- 2nd KPI's -------------------------------------------------------------------------------------------------------------------------
-- number of order with review score 5 and payment type as credit_card
select count(order_id) as no_of_orders, review_score,payment_type from olist_order_payments_dataset
join olist_order_reviews_dataset 
using (order_id)
where payment_type = 'credit_card' and review_score = 5 ;

-- 3rd KPI's -----------------------------------------------------------------------------------------------------------------------------------------

select avg(datediff(order_delivered_customer_date,order_purchase_timestamp)) as avg_day from olist_orders_dataset
join olist_order_items_dataset
using (order_id)
join olist_products_dataset
using (product_id)
where product_category_name = 'pet_shop';


-- 4th KPI's -----------------------------------------------------------------------------------------------------------------------------------------
select customer_city, avg(price) as Avg_price, avg (payment_value) as avg_payment_value from
olist_order_items_dataset
join olist_orders_dataset
using (order_id)
join olist_order_payments_dataset
using (order_id)
join olist_customers_dataset
using (customer_id)
where customer_city = 'sao paulo' ;

-- 5th KPI's -----------------------------------------------------------------------------------------------------------------------------------------

select  review_score, avg(date_diff) as shipping_days  from olist_orders_dataset
join olist_order_reviews_dataset
using (order_id)
group by review_score order by review_score asc ;


