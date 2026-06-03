-- Таблица должностей
CREATE TABLE position (
    id_position serial NOT NULL PRIMARY KEY,
    title varchar(500) NOT NULL,
    salary decimal NOT NULL,
    access_category varchar(500) NOT NULL
);

-- Таблица складов
CREATE TABLE warehouse (
    id_warehouse serial NOT NULL PRIMARY KEY,
    address varchar(500) NOT NULL,
    phone varchar(500) NOT NULL
);

-- Связь товаров и складов
CREATE TABLE product_warehouse (
    id_product_warehouse serial NOT NULL PRIMARY KEY,
    id_product_fk serial NOT NULL,
    id_warehouse_fk serial NOT NULL
);

-- Чат поддержки
CREATE TABLE support_chat (
    id_support_chat serial NOT NULL PRIMARY KEY,
    id_employee_fk serial NOT NULL,
    id_client_fk serial NOT NULL,
    status varchar(500)
);

-- Отзывы
CREATE TABLE review (
    id_review serial NOT NULL PRIMARY KEY,
    id_client_fk serial NOT NULL,
    id_product_fk serial NOT NULL,
    review_content varchar(500),
    rating integer NOT NULL
);

-- Связь товаров и заказов (многие ко многим)
CREATE TABLE product_ordering (
    id_product_ordering serial NOT NULL PRIMARY KEY,
    id_product_fk serial NOT NULL,
    id_ordering_fk serial NOT NULL
);

-- Магазины
CREATE TABLE store (
    id_store serial NOT NULL PRIMARY KEY,
    address varchar(500) NOT NULL,
    phone varchar(500) NOT NULL
);

-- Связь документов и заказов
CREATE TABLE document_ordering (
    id_document_ordering serial NOT NULL PRIMARY KEY,
    id_document_fk serial NOT NULL,
    id_ordering_fk serial NOT NULL
);

-- Связь клиентов и адресов
CREATE TABLE client_address (
    id_client_address serial NOT NULL PRIMARY KEY,
    id_address_fk serial NOT NULL,
    id_client_fk serial NOT NULL
);

-- Документы
CREATE TABLE document (
    id_document serial NOT NULL PRIMARY KEY,
    id_employee_fk serial NOT NULL,
    creation_date date NOT NULL,
    link varchar(500) NOT NULL
);

-- Сообщения в чате
CREATE TABLE message (
    id_message serial NOT NULL PRIMARY KEY,
    id_support_chat serial NOT NULL,
    message_text text NOT NULL,
    sending_time time NOT NULL,
    sender_type varchar(500) NOT NULL
);

-- Скидочная карта
CREATE TABLE discount_card (
    id_discount_card serial NOT NULL PRIMARY KEY,
    id_client_fk serial NOT NULL,
    id_discount_level_fk serial NOT NULL
);

-- Сотрудники
CREATE TABLE employee (
    id_employee serial NOT NULL PRIMARY KEY,
    id_position_fk serial NOT NULL,
    surname varchar(500) NOT NULL,
    name varchar(500) NOT NULL,
    patronymic varchar(500) NOT NULL,
    phone varchar(500) NOT NULL,
    registration_address varchar(500) NOT NULL,
    date_of_employment date NOT NULL,
    end_date_of_the_agreement date
);

-- Связь товаров и магазинов
CREATE TABLE product_store (
    id_product_store serial NOT NULL PRIMARY KEY,
    id_store_fk serial NOT NULL,
    id_product_fk serial NOT NULL
);

-- Связь сотрудников и заказов
CREATE TABLE employee_ordering (
    id_employee_ordering serial NOT NULL PRIMARY KEY,
    id_employee_fk serial NOT NULL,
    id_ordering_fk serial NOT NULL
);

-- Товары
CREATE TABLE product (
    id_product serial NOT NULL PRIMARY KEY,
    id_supplier_fk serial NOT NULL,
    title varchar(500) NOT NULL,
    price decimal NOT NULL,
    size integer NOT NULL,
    description text,
    material varchar(500) NOT NULL,
    colour varchar(500) NOT NULL
);

-- Уровни скидочных карт
CREATE TABLE discount_card_level (
    id_discount_card_level serial NOT NULL PRIMARY KEY,
    title varchar(500) NOT NULL,
    discount integer NOT NULL
);

-- Поставщики
CREATE TABLE supplier (
    id_supplier serial NOT NULL PRIMARY KEY,
    name_of_organization varchar(500) NOT NULL,
    phone varchar(500) NOT NULL,
    address varchar(500)
);

-- Заказы
CREATE TABLE ordering (
    id_ordering serial NOT NULL PRIMARY KEY,
    id_store_fk serial NOT NULL,
    id_employee_fk serial NOT NULL,
    id_address_fk serial NOT NULL,
    id_client_fk serial NOT NULL,
    id_discount_card_fk serial,
    total decimal NOT NULL,
    order_date date NOT NULL,
    status varchar(500) NOT NULL,
    delivery_method varchar(500) NOT NULL
);

-- Брак
CREATE TABLE marriage (
    id_marriage serial NOT NULL PRIMARY KEY,
    id_product_fk serial NOT NULL,
    date date,
    type_of_marriage varchar(500) NOT NULL,
    description varchar(500),
    id_ordering_fk serial NOT NULL
);

-- Связь товаров и категорий
CREATE TABLE product_category (
    id_product_category serial NOT NULL PRIMARY KEY,
    id_category_of_product_fk serial NOT NULL,
    id_product_fk serial NOT NULL
);

-- Данные для входа клиентов
CREATE TABLE access_data (
    id_access_data serial NOT NULL PRIMARY KEY,
    id_client_fk serial NOT NULL,
    login varchar(500) NOT NULL,
    password varchar(500) NOT NULL
);

-- Категории товаров
CREATE TABLE category_of_product (
    id_category_of_product serial NOT NULL PRIMARY KEY,
    description text NOT NULL
);

-- Транзакции
CREATE TABLE transaction (
    id_transaction serial NOT NULL PRIMARY KEY,
    id_ordering_fk serial NOT NULL,
    order_date date NOT NULL
);

-- Клиенты
CREATE TABLE client (
    id_client serial NOT NULL PRIMARY KEY,
    surname varchar(500) NOT NULL,
    name varchar(500) NOT NULL,
    patronymic varchar(500),
    phone varchar(500) NOT NULL,
    mail varchar(500)
);

-- Адреса
CREATE TABLE address (
    id_address serial NOT NULL PRIMARY KEY,
    id_client_fk serial NOT NULL,
    delivery_address varchar(500) NOT NULL
);

-- Внешние ключи
ALTER TABLE access_data ADD CONSTRAINT access_data_id_client_fk FOREIGN KEY (id_client_fk) REFERENCES client (id_client);
ALTER TABLE client_address ADD CONSTRAINT client_address_id_address_fk FOREIGN KEY (id_address_fk) REFERENCES address (id_address);
ALTER TABLE discount_card ADD CONSTRAINT discount_card_id_client_fk FOREIGN KEY (id_client_fk) REFERENCES client (id_client);
ALTER TABLE discount_card ADD CONSTRAINT discount_card_id_discount_level_fk FOREIGN KEY (id_discount_level_fk) REFERENCES discount_card_level (id_discount_card_level);
ALTER TABLE document_ordering ADD CONSTRAINT document_ordering_id_document_fk FOREIGN KEY (id_document_fk) REFERENCES document (id_document);
ALTER TABLE document_ordering ADD CONSTRAINT document_ordering_id_ordering_fk FOREIGN KEY (id_ordering_fk) REFERENCES ordering (id_ordering);
ALTER TABLE employee_ordering ADD CONSTRAINT employee_ordering_id_employee_fk FOREIGN KEY (id_employee_fk) REFERENCES employee (id_employee);
ALTER TABLE employee_ordering ADD CONSTRAINT employee_ordering_id_ordering_fk FOREIGN KEY (id_ordering_fk) REFERENCES ordering (id_ordering);
ALTER TABLE marriage ADD CONSTRAINT marriage_id_ordering_fk FOREIGN KEY (id_ordering_fk) REFERENCES ordering (id_ordering);
ALTER TABLE ordering ADD CONSTRAINT ordering_id_employee_fk FOREIGN KEY (id_employee_fk) REFERENCES employee (id_employee);
ALTER TABLE ordering ADD CONSTRAINT ordering_id_store_fk FOREIGN KEY (id_store_fk) REFERENCES store (id_store);
ALTER TABLE product_category ADD CONSTRAINT product_category_id_category_of_product_fk FOREIGN KEY (id_category_of_product_fk) REFERENCES category_of_product (id_category_of_product);
ALTER TABLE product_ordering ADD CONSTRAINT product_ordering_id_ordering_fk FOREIGN KEY (id_ordering_fk) REFERENCES ordering (id_ordering);
ALTER TABLE product_store ADD CONSTRAINT product_store_id_store_fk FOREIGN KEY (id_store_fk) REFERENCES store (id_store);
ALTER TABLE product_warehouse ADD CONSTRAINT product_warehouse_id_warehouse_fk FOREIGN KEY (id_warehouse_fk) REFERENCES warehouse (id_warehouse);
ALTER TABLE support_chat ADD CONSTRAINT support_chat_id_employee_fk FOREIGN KEY (id_employee_fk) REFERENCES employee (id_employee);
ALTER TABLE employee ADD CONSTRAINT employee_id_position_fk FOREIGN KEY (id_position_fk) REFERENCES position (id_position);
ALTER TABLE document ADD CONSTRAINT document_id_employee_fk FOREIGN KEY (id_employee_fk) REFERENCES employee (id_employee);
ALTER TABLE message ADD CONSTRAINT message_id_support_chat_fk FOREIGN KEY (id_support_chat) REFERENCES support_chat (id_support_chat);
ALTER TABLE support_chat ADD CONSTRAINT support_chat_id_client_fk FOREIGN KEY (id_client_fk) REFERENCES client (id_client);
ALTER TABLE ordering ADD CONSTRAINT ordering_id_discount_card_fk FOREIGN KEY (id_discount_card_fk) REFERENCES discount_card (id_discount_card);
ALTER TABLE ordering ADD CONSTRAINT ordering_id_client_fk FOREIGN KEY (id_client_fk) REFERENCES client (id_client);
ALTER TABLE ordering ADD CONSTRAINT ordering_id_address_fk FOREIGN KEY (id_address_fk) REFERENCES address (id_address);
ALTER TABLE address ADD CONSTRAINT address_id_client_fk FOREIGN KEY (id_client_fk) REFERENCES client (id_client);
ALTER TABLE client_address ADD CONSTRAINT client_address_id_client_fk FOREIGN KEY (id_client_fk) REFERENCES client (id_client);
ALTER TABLE transaction ADD CONSTRAINT transaction_id_ordering_fk FOREIGN KEY (id_ordering_fk) REFERENCES ordering (id_ordering);
ALTER TABLE product_ordering ADD CONSTRAINT product_ordering_id_product_fk FOREIGN KEY (id_product_fk) REFERENCES product (id_product);
ALTER TABLE product_store ADD CONSTRAINT product_store_id_product_fk FOREIGN KEY (id_product_fk) REFERENCES product (id_product);
ALTER TABLE product ADD CONSTRAINT product_id_supplier_fk FOREIGN KEY (id_supplier_fk) REFERENCES supplier (id_supplier);
ALTER TABLE product_category ADD CONSTRAINT product_category_id_product_fk FOREIGN KEY (id_product_fk) REFERENCES product (id_product);
ALTER TABLE product_warehouse ADD CONSTRAINT product_warehouse_id_product_fk FOREIGN KEY (id_product_fk) REFERENCES product (id_product);
ALTER TABLE review ADD CONSTRAINT review_id_product_fk FOREIGN KEY (id_product_fk) REFERENCES product (id_product);
ALTER TABLE review ADD CONSTRAINT review_id_client_fk FOREIGN KEY (id_client_fk) REFERENCES client (id_client);
ALTER TABLE marriage ADD CONSTRAINT marriage_id_product_fk FOREIGN KEY (id_product_fk) REFERENCES product (id_product);
