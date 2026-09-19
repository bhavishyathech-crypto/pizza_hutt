-- Pizza Hut Sales Analysis | Data Quality Checks
USE pizzahut;

-- 1. Row counts
SELECT 'orders' AS table_name, COUNT(*) AS row_count FROM orders
UNION ALL SELECT 'order_details', COUNT(*) FROM order_details
UNION ALL SELECT 'pizza_types', COUNT(*) FROM pizza_types
UNION ALL SELECT 'pizzas', COUNT(*) FROM pizzas;

-- 2. Date range in orders
SELECT MIN(order_date) AS first_order_date, MAX(order_date) AS last_order_date
FROM orders;

-- 3. Orders without any order-detail records
SELECT COUNT(*) AS orders_without_details
FROM orders o
LEFT JOIN order_details od ON o.order_id = od.order_id
WHERE od.order_id IS NULL;

-- 4. Order-detail rows whose pizza_id is not present in the pizza catalogue
SELECT COUNT(*) AS orphan_pizza_ids
FROM order_details od
LEFT JOIN pizzas p ON od.pizza_id = p.pizza_id
WHERE p.pizza_id IS NULL;

-- 5. Pizza catalogue rows whose pizza_type_id is not present in pizza_types
SELECT COUNT(*) AS orphan_pizza_type_ids
FROM pizzas p
LEFT JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
WHERE pt.pizza_type_id IS NULL;

-- 6. Check for non-positive quantity values
SELECT COUNT(*) AS invalid_quantities
FROM order_details
WHERE quantity <= 0;
