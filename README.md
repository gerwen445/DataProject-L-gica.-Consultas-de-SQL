# DataProject: Consultas SQL — Sakila 

Proyecto de consultas SQL sobre la base de datos **Sakila**, que simula una tienda de alquiler de películas. El objetivo es practicar consultas desde las más básicas hasta JOINs, subconsultas, vistas y tablas temporales.

---

## Archivos

- `BBDD_Proyecto_shakila_sinuser.sql` → Script para crear la base de datos
- `consultas_sakila.sql` → Las 64 consultas resueltas

---

## Base de datos

La BBDD contiene información sobre películas, actores, clientes, alquileres y pagos. Las tablas principales son:

- `film` → películas
- `actor` + `film_actor` → actores y su relación con las películas
- `category` + `film_category` → categorías
- `customer` → clientes
- `rental` → alquileres
- `payment` → pagos
- `inventory` → copias disponibles por tienda
- `staff` + `store` → empleados y tiendas

---


## Consultas resueltas

64 consultas en total que cubren:

- SELECTs básicos con filtros y ORDER BY
- Funciones de agregación (COUNT, SUM, AVG, MAX, MIN, VARIANCE, STDDEV)
- GROUP BY y HAVING
- JOINs (INNER, LEFT, CROSS)
- Subconsultas
- Vistas y tablas temporales

---

## Stack

- PostgreSQL
- DBeaver
