-- 1. Используя операторы языка SQL, создайте табличку “sales”. Заполните ее данными

CREATE TABLE sales 
(
	sale_id INT PRIMARY KEY AUTO_INCREMENT,
	phone_id INT NOT NULL,
	count INT NOT NULL,
	FOREIGN KEY (phone_id) REFERENCES phones (phone_id)
);

INSERT sales(phone_id, count)
VALUES (2, 310), (3, 17), (5, 23), (1, 31), (6, 70), (3, 1660), (4, 80), (2, 66), (4, 88), (6, 200);

-- 2. Сгруппируйте значений количества в 3 сегмента — меньше 100, 100-300 и больше 300.

SELECT sales_group, GROUP_CONCAT(model SEPARATOR ', ') AS models
FROM
	(SELECT phone_id, model, sales_total,
		(CASE
			WHEN sales_total<100 THEN "маленький заказ"
            WHEN sales_total>=100 AND sales_total<=300 THEN "средний заказ"
            ELSE "большой заказ"
        END) AS sales_group
	FROM
		(SELECT sales.phone_id, CONCAT(phones.vendor, " ", phones.model) AS model, SUM(sales.count) AS sales_total
		FROM sales, phones
		WHERE phones.phone_id = sales.phone_id
		GROUP BY phone_id) AS temp1) AS temp2
GROUP BY sales_group;


-- 3. Создайте таблицу “orders”, заполните ее значениями. Покажите “полный” статус заказа, используя оператор CASE

CREATE TABLE orders
(
	order_id INT PRIMARY KEY AUTO_INCREMENT,
	create_data TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	update_data TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	customer_name VARCHAR (100) NOT NULL,
	order_status INT NOT NULL DEFAULT 1 
);

INSERT orders(customer_name)
VALUES ("К.С"), ("П.С"), ("В.А"), ("Х.Ж"),
	("К.А"), ("А.А"), ("З.А"), ("Е.П"), ("П.Р");

UPDATE orders SET order_status=2 WHERE order_id=1;
UPDATE orders SET order_status=3 WHERE order_id=4;
UPDATE orders SET order_status=4 WHERE order_id=2;
UPDATE orders SET order_status=0 WHERE order_id=8;
UPDATE orders SET order_status=-1 WHERE order_id=6;

SELECT order_id, create_data, update_data, customer_name, 
(CASE
	WHEN order_status=1 THEN "Формируется"
    WHEN order_status=0 THEN "Завершен"
    WHEN order_status=2 THEN "Подтвержден"
    WHEN order_status=3 THEN "Оплачен"
    WHEN order_status=4 THEN "Доставке"
    WHEN order_status=-1 THEN "Отменен"
    ELSE "Ошибка"
END) AS full_status
FROM orders;

-- 4. Чем NULL отличается от 0?

-- NULL это пустое значение (в поле ничего не храниться), а 0 это конкретное значение полей числовых типов
