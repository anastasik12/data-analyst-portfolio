# Проектирование базы данных «Магазин одежды»

**Цель:** спроектировать реляционную базу данных для автоматизации работы магазина одежды (товары, заказы, клиенты, сотрудники, скидки, отзывы, поддержка).

**Инструменты:** ChartDB, PostgreSQL, SQL.

---

## Состав проекта

| Файл | Описание |
|------|----------|
| `conceptual_diagram.png` | Концептуальная модель (18 сущностей, 3 справочника) |
| `logical_diagram.png` | Логическая модель (атрибуты, первичные/внешние ключи) |
| `physical_diagram.png` | Физическая модель (таблицы, типы данных, связи) |
| `schema.sql` | SQL-скрипт создания таблиц и внешних ключей (PostgreSQL) |
| `queries.sql` | Примеры аналитических запросов (JOIN, GROUP BY, подзапросы) |
| `conceptual_entities.md` | Описание всех сущностей концептуальной модели |
| `logical_relationships.md` | Описание связей между сущностями (с типами) |
| `docs/report.pdf` | Полный отчёт (объединённый ПР4 + ПР5 + физическая реализация) |

---

## Этапы проектирования

### 1. Концептуальная модель
- Выделены основные бизнес-сущности (Товар, Заказ, Клиент, Сотрудник и др.).
- Определены **нормативно-справочные сущности**: категория товара, должность, уровень скидочной карты.
- Диаграмма: `conceptual_diagram.png`  
- Детальное описание: `conceptual_entities.md`

### 2. Логическая модель
- Уточнены атрибуты, первичные и внешние ключи.
- Заданы типы связей (один-ко-многим, многие-ко-многим).
- Диаграмма: `logical_diagram.png`  
- Описание связей: `logical_relationships.md`

### 3. Физическая модель (PostgreSQL)
- Созданы таблицы с конкретными типами данных (`serial`, `varchar`, `decimal`, `date`).
- Реализованы ограничения целостности (`PRIMARY KEY`, `FOREIGN KEY`).
- SQL-скрипт: `schema.sql`  
- Физическая ER-диаграмма: `physical_diagram.png`

---

## Примеры запросов (из `queries.sql`)

```sql
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
