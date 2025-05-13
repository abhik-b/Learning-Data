# OList Brazil Ecommerce Data Analysis

This is the data schema of the dataset.
![image](https://i.imgur.com/HRhd2Y0.png)

So let me give you a overview of this massive dataset. it has multiple sheets.

olist_geolocation_dataset:

- geolocation_zip_code_prefix: first 5 digits of zip code, number
- geolocation_lat: latitude, number
- geolocation_lng: longitude
- geolocation_city: city name, string
- geolocation_state: state code, string

olist_order_items_dataset:

- order_id: order unique identifier,
- order_item_id: sequential number identifying number of items included in the same order,
- product_id: product unique identifier
- shipping_limit_date: Shows the seller shipping limit date for handling the order over to the logistic partner.
- price: item price
- freight_value: item freight value item (if an order has more than one item the freight value is splitted between items)

olist_order_payments_dataset:

- order_id: unique identifier of an order.
- payment_sequential: a customer may pay an order with more than one payment method. If he does so, a sequence will be created to accommodate all payments.
- payment_type: method of payment chosen by the customer.
- payment_installments: number of installments chosen by the customer.
- payment_value: transaction value.

olist_order_reviews_dataset:

- review_id: unique review
- order_id: unique order identifier
- review_score: Note ranging from 1 to 5 given by the customer on a satisfaction survey.
- review_comment_title: Comment title from the review left by the customer, in Portuguese.
- review_comment_message: Comment message from the review left by the customer, in Portuguese.

olist_orders_dataset:

- order_id: unique identifier of the order.
- customer_id: key to the customer dataset. Each order has a unique customer_id.
- order_status: Reference to the order status (delivered, shipped, etc).
- order_purchase_timestamp: Shows the purchase timestamp.
- order_approved_at: Shows the payment approval timestamp.
- order_delivered_carrier_date: Shows the order posting timestamp. When it was handled to the logistic partner.
- order_delivered_customer_date: Shows the actual order delivery date to the customer.
- order_estimated_delivery_date: Shows the estimated delivery date that was informed to customer at the purchase moment.

olist_products_dataset:

- product_id: unique product identifier
- product_category_name: root category of product, in Portuguese.
- product_name_lenght: number of characters extracted from the product name.
- product_description_lenght: number of characters extracted from the product description.
- product_photos_qty: number of product published photos
- product_weight_g: product weight measured in grams.
- product_length_cm: product length measured in centimeters.
- product_height_cm: product height measured in centimeters.
- product_width_cm: product width measured in centimeters.

olist_sellers_dataset:

- seller_id: seller unique identifier
- seller_zip_code_prefix: first 5 digits of seller zip code
- seller_city: seller city name
- seller_state : seller state

product_category_name_translation:

- product_category_name: category name in Portuguese
- product_category_name_english: category name in

olist_customers_dataset:

- customer_id: key to the orders dataset. Each order has a unique customer_id.
- customer_unique_id: unique identifier of a customer.
- customer_zip_code_prefix: first five digits of customer zip code
- customer_city: customer city name
- customer_state: customer state

# General Business Questions?

### What is the total revenue generated?

### What is the average order value (AOV)?

### How many total orders were placed?

### What is the average shipping cost per order?

### Which product categories generate the most revenue?

### Which categories have the highest average order value?
