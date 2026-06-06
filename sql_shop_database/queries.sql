-- 1. Топ-3 товара в каждой категории по выручке (оконная функция RANK)
WITH ranked_products AS (
    SELECT 
        p.category_name,
        p.product_name,
        SUM(oi.price * oi.quantity) AS total_revenue,
        RANK() OVER (PARTITION BY p.category_name ORDER BY SUM(oi.price * oi.quantity) DESC) AS rank
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    GROUP BY p.category_name, p.product_name
)
SELECT category_name, product_name, total_revenue
FROM ranked_products
WHERE rank <= 3;

-- 2. Для каждого заказа — дата предыдущего заказа того же клиента (LAG)
SELECT 
    o.order_id,
    o.customer_id,
    o.order_date,
    LAG(o.order_date) OVER (PARTITION BY o.customer_id ORDER BY o.order_date) AS previous_order_date
FROM orders o;

-- 3. Скользящее среднее суммы заказа за последние 3 дня
WITH daily_revenue AS (
    SELECT 
        o.order_date,
        SUM(oi.price * oi.quantity) AS daily_total
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.order_date
)
SELECT 
    order_date,
    daily_total,
    AVG(daily_total) OVER (ORDER BY order_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_3d
FROM daily_revenue;

-- 4. Выручка по категориям (JOIN, GROUP BY)
SELECT 
    p.category_name,
    SUM(oi.price * oi.quantity) AS category_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.category_name
ORDER BY category_revenue DESC;
