-- Pizza Hut Sales Analysis | Database Schema
-- Source: Dump20260919.sql

CREATE DATABASE IF NOT EXISTS pizzahut;
USE pizzahut;

DROP TABLE IF EXISTS order_details;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS pizzas;
DROP TABLE IF EXISTS pizza_types;

CREATE TABLE order_details (
    order_detail_id INT NOT NULL,
    order_id INT NOT NULL,
    pizza_id TEXT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (order_detail_id)
);

CREATE TABLE orders (
    order_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_time TIME NOT NULL,
    PRIMARY KEY (order_id)
);

CREATE TABLE pizza_types (
    pizza_type_id TEXT,
    name TEXT,
    category TEXT,
    ingredients TEXT
);

CREATE TABLE pizzas (
    pizza_id TEXT,
    pizza_type_id TEXT,
    size TEXT,
    price DOUBLE DEFAULT NULL
);
