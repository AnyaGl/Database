CREATE DATABASE StorageDB
COLLATE Cyrillic_General_CI_AS


CREATE TABLE storage (
id_storage int NOT NULL IDENTITY,
name nvarchar(20) NULL,
address nvarchar(50) NOT NULL,
phone nvarchar(12) NOT NULL,
capacity int NOT NULL
)
GO

CREATE TABLE product (
id_product int NOT NULL IDENTITY,
name nvarchar(20) NOT NULL,
description nvarchar(100) NULL,
shelf_life date NOT NULL,
purchase_price smallmoney NOT NULL
)
GO

CREATE TABLE product_in_storage (
id_product int NOT NULL,
id_storage int NOT NULL,
quantity int NOT NULL,
delivery datetime NOT NULL
)
GO

CREATE TABLE storekeeper (
id_employee int NOT NULL IDENTITY,
id_storage int NOT NULL,
name nvarchar(50) NOT NULL,
phone nvarchar(12) NOT NULL,
address nvarchar(50) NOT NULL,
birthday date NOT NULL
)
GO

CREATE TABLE supplier (
id_supplier int NOT NULL IDENTITY,
name nvarchar(20) NOT NULL,
phone nvarchar(12) NOT NULL,
address nvarchar(50) NOT NULL,
owner nvarchar(50) NULL
)
GO

CREATE TABLE product_of_supplier (
id_product int NOT NULL,
id_supplier int NOT NULL,
quantity int NOT NULL
)
GO

ALTER TABLE storage
ADD
PRIMARY KEY(id_storage)

ALTER TABLE product
ADD
PRIMARY KEY(id_product)

ALTER TABLE product_in_storage
ADD
PRIMARY KEY(id_product, id_storage)

ALTER TABLE storekeeper
ADD
PRIMARY KEY(id_employee)

ALTER TABLE supplier
ADD
PRIMARY KEY(id_supplier)

ALTER TABLE product_of_supplier
ADD
PRIMARY KEY(id_product, id_supplier)


ALTER TABLE product_in_storage
ADD
FOREIGN KEY(id_product) REFERENCES product(id_product)
ON DELETE CASCADE

ALTER TABLE product_in_storage
ADD
FOREIGN KEY(id_storage) REFERENCES storage(id_storage)
ON DELETE CASCADE

ALTER TABLE product_of_supplier
ADD
FOREIGN KEY(id_product) REFERENCES product(id_product)
ON DELETE CASCADE

ALTER TABLE product_of_supplier
ADD
FOREIGN KEY(id_supplier) REFERENCES supplier(id_supplier)
ON DELETE CASCADE

ALTER TABLE storekeeper
ADD
FOREIGN KEY(id_storage) REFERENCES storage(id_storage)
ON DELETE CASCADE



---- 1. INSERT ----
-- 1. Без указания списка полей
INSERT [product]
VALUES (N'Молоко', N'Коровье молоко', DATEFROMPARTS ( 2020, 03, 25 ), 50);

INSERT [product]
VALUES (N'Молоко', N'Козье молоко', DATEFROMPARTS ( 2020, 03, 30 ), 100);

INSERT [product]
VALUES (N'Молоко', N'Коровье молоко', DATEFROMPARTS ( 2020, 03, 18 ), 50);

INSERT [product]
VALUES (N'Lays', N'Чипсы', DATEFROMPARTS ( 2021, 04, 5 ), 180);

INSERT [product]
VALUES (N'Шоколад', N'Молочный', DATEFROMPARTS ( 2021, 04, 15 ), 130);

INSERT [storage]
VALUES (N'Продукты', N'ул. Пушкина, д. 8', N'123456789', 1000);

INSERT [storage]
VALUES (N'Продукты', N'ул. Пушкина, д. 8', N'123456789', 2000);

INSERT [storage]
VALUES (N'Овощи', N'ул. Волкова, д. 43', N'5555', 9000);

INSERT [product_in_storage]
VALUES (7, 1, 100, N'2004-05-23T14:25:10');

INSERT [product_in_storage]
VALUES (6, 2, 80, N'2020-05-23T14:30:00');

INSERT [product_in_storage]
VALUES (8, 1, 180, N'2020-03-15T18:30:00');

INSERT [product_in_storage]
VALUES (4, 1, 180, N'2020-03-15T12:45:00');

INSERT [product_in_storage]
VALUES (4, 3, 150, N'2020-03-15T12:45:00');


-- 2. С указанием списка полей
INSERT [product]
	(name, shelf_life, purchase_price)
VALUES (N'Сыр', DATEFROMPARTS ( 2020, 04, 5 ), 150);

INSERT [product]
	(name, shelf_life, purchase_price)
VALUES (N'Шоколад', DATEFROMPARTS ( 2021, 04, 5 ), 180);

INSERT [storage]
	(address, phone, capacity)
VALUES (N'ул. Пушкина, д. 8', N'89658354222', 1500);


-- 3. С чтением значения из другой таблицы
INSERT [supplier]
	(name, phone, address) 
SELECT name, phone, address FROM storage; 



---- 2. DELETE ----
-- 1. Всех записей
DELETE [supplier]

-- 2. По условию
DELETE [product]
WHERE 
	name LIKE N'Молоко';

-- 3. Очистить таблицу
TRUNCATE TABLE [product_in_storage]



---- 3. UPDATE ----
-- 1. Всех записей
UPDATE [storage]
SET address = N'ул. Королева, д.15'

-- 2. По условию обновляя один атрибут
UPDATE [storage]
SET  phone = N'79024542154'
WHERE name IS NULL;

-- 3. По условию обновляя несколько атрибутов
UPDATE [product] 
SET purchase_price += 10
WHERE purchase_price < 120;



---- 4. SELECT ----
-- 1. С определенным набором извлекаемых атрибутов 
SELECT name, purchase_price FROM [product]

-- 2. Со всеми атрибутами (SELECT * FROM...)
SELECT * FROM [storage]

-- 3. С условием по атрибуту (SELECT * FROM ... WHERE atr1 = "")
SELECT * FROM [product]
WHERE purchase_price < 150



---- 5. SELECT ORDER BY + TOP (LIMIT) ----
-- 1. С сортировкой по возрастанию ASC + ограничение вывода количества записей
SELECT TOP 3 * 
FROM [product]
ORDER BY purchase_price ASC

-- 2. С сортировкой по убыванию DESC
SELECT * 
FROM [product]
ORDER BY name DESC

-- 3. С сортировкой по двум атрибутам + ограничение вывода количества записей
SELECT TOP 4 * 
FROM [product]
ORDER BY name, purchase_price

-- 4. С сортировкой по первому атрибуту, из списка извлекаемых
SELECT name, purchase_price
FROM [product]
ORDER BY 1



---- 6. Работа с датами. ----
-- 1. WHERE по дате
SELECT *
FROM [product_in_storage]
WHERE delivery > N'2019-01-01T00:00:00'

-- 2. Извлечь из таблицы не всю дату, а только год. 
SELECT name, YEAR(shelf_life) AS shelf_life
FROM [product]



---- 7. SELECT GROUP BY с функциями агрегации ----
-- 1. MIN
SELECT name, MIN(capacity) AS capacity
FROM [storage]
GROUP BY name

-- 2. MAX
SELECT name, MAX(purchase_price) AS purchase_price
FROM [product]
GROUP BY name

-- 3. AVG
SELECT name, AVG(purchase_price) AS purchase_price
FROM [product]
GROUP BY name

-- 4. SUM
SELECT name, SUM(capacity) AS capacity
FROM [storage]
GROUP BY name

-- 5. COUNT
SELECT name, COUNT(purchase_price)
FROM [product]
WHERE id_product > 5
GROUP BY name



---- 8. SELECT GROUP BY + HAVING ----
-- 1. Написать 3 разных запроса с использованием GROUP BY + HAVING
SELECT name, COUNT(*)
FROM [product]
GROUP BY name
HAVING COUNT(*) > 1

SELECT name, MAX(capacity) AS capacity
FROM [storage]
GROUP BY name
HAVING MAX(capacity) > 1700

SELECT name, AVG(purchase_price)
FROM [product]
WHERE id_product > 5
GROUP BY name
HAVING AVG(purchase_price) > 80



---- 9. SELECT JOIN ----
-- 1. LEFT JOIN двух таблиц и WHERE по одному из атрибутов
SELECT * FROM 
[product_in_storage] p
LEFT JOIN [product] s 
ON p.id_product = s.id_product
WHERE quantity > 80

-- 2. RIGHT JOIN. Получить такую же выборку, как и в 5.1
SELECT TOP 3 * FROM 
[product_in_storage] p
RIGHT JOIN [product] s 
ON p.id_product = s.id_product
ORDER BY purchase_price ASC
-- 5.1 --
SELECT TOP 3 * 
FROM [product]
ORDER BY purchase_price ASC

-- 3. LEFT JOIN трех таблиц + WHERE по атрибуту из каждой таблицы
SELECT * FROM 
(SELECT * FROM [product] WHERE purchase_price < 150) p
LEFT JOIN (SELECT * FROM [product_in_storage] WHERE quantity > 90) ps
ON ps.id_product = p.id_product
LEFT JOIN (SELECT * FROM [storage] WHERE name = N'Продукты') s
ON s.id_storage = ps.id_storage

-- 4. FULL OUTER JOIN двух таблиц
SELECT * FROM 
[storage] s 
FULL OUTER JOIN [product_in_storage] p
ON p.id_storage = s.id_storage



---- 10. Подзапросы ----
-- 1. Написать запрос с WHERE IN (подзапрос)
SELECT * FROM product
WHERE id_product IN (SELECT id_product FROM product_in_storage)

-- 2. Написать запрос SELECT atr1, atr2, (подзапрос) FROM ...
SELECT 
	quantity,
	delivery,
	(SELECT name FROM [product] WHERE [product_in_storage].id_product = [product].id_product)
FROM [product_in_storage]




SELECT * FROM product
SELECT * FROM storage
SELECT * FROM product_in_storage
SELECT * FROM supplier