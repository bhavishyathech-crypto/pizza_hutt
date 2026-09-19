-- Pizza Hut Sales Analysis | Business Analysis Queries
USE pizzahut;

-- 1. Total sales revenue (based on available order-detail records)
SELECT ROUND(SUM(od.quantity * p.price), 2) AS total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id;

-- 2. Total pizzas sold
SELECT SUM(quantity) AS total_pizzas_sold
FROM order_details;

-- 3. Orders with line-item data
SELECT COUNT(DISTINCT order_id) AS orders_with_line_items
FROM order_details;

-- 4. Average order value for orders with line-item data
SELECT ROUND(SUM(order_revenue) / COUNT(*), 2) AS average_order_value
FROM (
    SELECT od.order_id, SUM(od.quantity * p.price) AS order_revenue
    FROM order_details od
    JOIN pizzas p ON od.pizza_id = p.pizza_id
    GROUP BY od.order_id
) x;

-- 5. Daily order volume
SELECT o.order_date, COUNT(DISTINCT od.order_id) AS orders
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.order_date
ORDER BY o.order_date;

-- 6. Monthly revenue
SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS month,
       ROUND(SUM(od.quantity * p.price), 2) AS revenue
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month;

-- 7. Revenue by pizza category
SELECT pt.category,
       ROUND(SUM(od.quantity * p.price), 2) AS revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY revenue DESC;

-- 8. Revenue by pizza size
SELECT p.size,
       SUM(od.quantity) AS pizzas_sold,
       ROUND(SUM(od.quantity * p.price), 2) AS revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY revenue DESC;

-- 9. Top 10 pizza types by revenue
SELECT pt.name,
       pt.category,
       SUM(od.quantity) AS quantity_sold,
       ROUND(SUM(od.quantity * p.price), 2) AS revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.pizza_type_id, pt.name, pt.category
ORDER BY revenue DESC
LIMIT 10;

-- 10. Top 10 pizza types by quantity sold
SELECT pt.name,
       pt.category,
       SUM(od.quantity) AS quantity_sold
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.pizza_type_id, pt.name, pt.category
ORDER BY quantity_sold DESC
LIMIT 10;

-- 11. Revenue by hour of day
SELECT HOUR(o.order_time) AS order_hour,
       COUNT(DISTINCT o.order_id) AS orders
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY HOUR(o.order_time)
ORDER BY order_hour;

-- 12. Revenue by category as a percentage of available sales
SELECT pt.category,
       ROUND(SUM(od.quantity * p.price), 2) AS revenue,
       ROUND(100 * SUM(od.quantity * p.price) /
             (SELECT SUM(od2.quantity * p2.price)
              FROM order_details od2 JOIN pizzas p2 ON od2.pizza_id = p2.pizza_id), 2) AS revenue_pct
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY revenue DESC;

-- 13. Day-of-week order pattern
SELECT DAYNAME(o.order_date) AS day_name,
       COUNT(DISTINCT o.order_id) AS orders
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY DAYOFWEEK(o.order_date), DAYNAME(o.order_date)
ORDER BY DAYOFWEEK(o.order_date);

-- 14. Highest-value individual order (available detail records)
SELECT od.order_id,
       ROUND(SUM(od.quantity * p.price), 2) AS order_value
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY od.order_id
ORDER BY order_value DESC
LIMIT 10;
