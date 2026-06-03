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
-- 1. Общая сумма заказов по клиентам
SELECT c.surname, c.name, SUM(o.total) AS total_spent
FROM client c
JOIN ordering o ON c.id_client = o.id_client_fk
GROUP BY c.id_client
ORDER BY total_spent DESC;

-- 2. Топ-5 популярных товаров
SELECT p.title, COUNT(po.id_product_fk) AS order_count
FROM product p
JOIN product_ordering po ON p.id_product = po.id_product_fk
GROUP BY p.id_product
ORDER BY order_count DESC
LIMIT 5;
