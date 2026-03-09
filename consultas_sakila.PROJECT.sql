-- =============================================================================
-- DataProject: Lógica Consultas SQL
-- Base de datos: Sakila (PostgreSQL)
-- Descripción: Resolución de las 64 consultas SQL propuestas sobre la BBDD
--              Sakila, una base de datos de ejemplo de una tienda de alquiler
--              de películas.
-- =============================================================================
-- ESQUEMA PRINCIPAL DE TABLAS:
--   actor          → actores (actor_id, first_name, last_name)
--   film           → películas (film_id, title, length, rating, rental_rate...)
--   film_actor     → relación N:M entre actor y film
--   film_category  → relación N:M entre film y category
--   category       → categorías de películas (name)
--   language       → idiomas (language_id, name)
--   inventory      → inventario de copias por película y tienda
--   rental         → registros de alquiler (rental_date, return_date...)
--   payment        → pagos realizados (amount)
--   customer       → clientes (customer_id, first_name, last_name)
--   staff          → empleados
--   store          → tiendas
--   address/city/country → datos de ubicación
-- =============================================================================


-- =============================================================================
-- 1. Crea el esquema de la BBDD
-- =============================================================================
-- El esquema completo se encuentra en el archivo: BBDD_Proyecto_shakila_sinuser.sql
-- Para crearlo, ejecuta ese archivo en tu cliente PostgreSQL:
--   psql -U <usuario> -d <base_de_datos> -f BBDD_Proyecto_shakila_sinuser.sql


-- =============================================================================
-- 2. Muestra los nombres de todas las películas con clasificación 'R'
-- =============================================================================
SELECT title
FROM film
WHERE rating = 'R';


-- =============================================================================
-- 3. Encuentra los nombres de los actores con actor_id entre 30 y 40
-- =============================================================================
SELECT first_name, last_name
FROM actor
WHERE actor_id BETWEEN 30 AND 40;


-- =============================================================================
-- 4. Obtén las películas cuyo idioma coincide con el idioma original
-- =============================================================================
-- Solo hay registros donde language_id = original_language_id
-- (en la BBDD Sakila original_language_id suele ser NULL, por lo que
--  esta consulta devolverá filas únicamente si ambos campos coinciden)
SELECT title, language_id, original_language_id
FROM film
WHERE language_id = original_language_id;


-- =============================================================================
-- 5. Ordena las películas por duración de forma ascendente
-- =============================================================================
SELECT title, length
FROM film
ORDER BY length ASC;


-- =============================================================================
-- 6. Encuentra el nombre y apellido de los actores con 'Allen' en su apellido
-- =============================================================================
SELECT first_name, last_name
FROM actor
WHERE last_name LIKE '%Allen%';


-- =============================================================================
-- 7. Cantidad total de películas por clasificación
-- =============================================================================
SELECT rating, COUNT(*) AS total_peliculas
FROM film
GROUP BY rating
ORDER BY total_peliculas DESC;


-- =============================================================================
-- 8. Películas que son 'PG-13' o tienen duración mayor a 3 horas (180 min)
-- =============================================================================
SELECT title, rating, length
FROM film
WHERE rating = 'PG-13'
   OR length > 180;


-- =============================================================================
-- 9. Variabilidad del coste de reemplazo de las películas (varianza)
-- =============================================================================
SELECT
    ROUND(VARIANCE(replacement_cost)::NUMERIC, 2) AS varianza,
    ROUND(STDDEV(replacement_cost)::NUMERIC, 2)   AS desviacion_estandar
FROM film;


-- =============================================================================
-- 10. Mayor y menor duración de una película
-- =============================================================================
SELECT
    MAX(length) AS duracion_maxima,
    MIN(length) AS duracion_minima
FROM film;


-- =============================================================================
-- 11. Coste del antepenúltimo alquiler ordenado por día
-- =============================================================================
-- El antepenúltimo registro es el tercero empezando desde el final
SELECT p.amount
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
ORDER BY r.rental_date DESC
OFFSET 2 LIMIT 1;


-- =============================================================================
-- 12. Películas que no son 'NC-17' ni 'G'
-- =============================================================================
SELECT title, rating
FROM film
WHERE rating NOT IN ('NC-17', 'G');


-- =============================================================================
-- 13. Promedio de duración de las películas por clasificación
-- =============================================================================
SELECT
    rating,
    ROUND(AVG(length), 2) AS promedio_duracion
FROM film
GROUP BY rating
ORDER BY promedio_duracion DESC;


-- =============================================================================
-- 14. Películas con duración mayor a 180 minutos
-- =============================================================================
SELECT title, length
FROM film
WHERE length > 180
ORDER BY length DESC;


-- =============================================================================
-- 15. ¿Cuánto dinero ha generado en total la empresa?
-- =============================================================================
SELECT ROUND(SUM(amount), 2) AS ingresos_totales
FROM payment;


-- =============================================================================
-- 16. Los 10 clientes con mayor valor de id
-- =============================================================================
SELECT customer_id, first_name, last_name
FROM customer
ORDER BY customer_id DESC
LIMIT 10;


-- =============================================================================
-- 17. Nombre y apellido de los actores en la película 'Egg Igby'
-- =============================================================================
SELECT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f        ON fa.film_id  = f.film_id
WHERE f.title = 'Egg Igby';


-- =============================================================================
-- 18. Nombres únicos de todas las películas
-- =============================================================================
SELECT DISTINCT title
FROM film
ORDER BY title;


-- =============================================================================
-- 19. Películas que son comedias y tienen duración mayor a 180 minutos
-- =============================================================================
SELECT f.title, f.length, c.name AS categoria
FROM film f
JOIN film_category fc ON f.film_id  = fc.film_id
JOIN category c       ON fc.category_id = c.category_id
WHERE c.name = 'Comedy'
  AND f.length > 180;


-- =============================================================================
-- 20. Categorías con promedio de duración superior a 110 minutos
-- =============================================================================
SELECT
    c.name AS categoria,
    ROUND(AVG(f.length), 2) AS promedio_duracion
FROM film f
JOIN film_category fc ON f.film_id      = fc.film_id
JOIN category c       ON fc.category_id = c.category_id
GROUP BY c.name
HAVING AVG(f.length) > 110
ORDER BY promedio_duracion DESC;


-- =============================================================================
-- 21. Media de duración del alquiler de las películas (en días)
-- =============================================================================
SELECT ROUND(AVG(rental_duration), 2) AS media_dias_alquiler
FROM film;


-- =============================================================================
-- 22. Columna con nombre y apellido concatenados de todos los actores
-- =============================================================================
SELECT
    actor_id,
    first_name || ' ' || last_name AS nombre_completo
FROM actor
ORDER BY last_name;


-- =============================================================================
-- 23. Número de alquileres por día, ordenados de forma descendente
-- =============================================================================
SELECT
    DATE(rental_date) AS dia,
    COUNT(*)          AS total_alquileres
FROM rental
GROUP BY DATE(rental_date)
ORDER BY total_alquileres DESC;


-- =============================================================================
-- 24. Películas con duración superior al promedio general
-- =============================================================================
SELECT title, length
FROM film
WHERE length > (SELECT AVG(length) FROM film)
ORDER BY length DESC;


-- =============================================================================
-- 25. Número de alquileres registrados por mes
-- =============================================================================
SELECT
    TO_CHAR(rental_date, 'YYYY-MM') AS mes,
    COUNT(*)                        AS total_alquileres
FROM rental
GROUP BY TO_CHAR(rental_date, 'YYYY-MM')
ORDER BY mes;


-- =============================================================================
-- 26. Promedio, desviación estándar y varianza del total pagado
-- =============================================================================
SELECT
    ROUND(AVG(amount)::NUMERIC,      2) AS promedio,
    ROUND(STDDEV(amount)::NUMERIC,   2) AS desviacion_estandar,
    ROUND(VARIANCE(amount)::NUMERIC, 2) AS varianza
FROM payment;


-- =============================================================================
-- 27. Películas que se alquilan por encima del precio medio
-- =============================================================================
SELECT title, rental_rate
FROM film
WHERE rental_rate > (SELECT AVG(rental_rate) FROM film)
ORDER BY rental_rate DESC;


-- =============================================================================
-- 28. ID de los actores que han participado en más de 40 películas
-- =============================================================================
SELECT actor_id, COUNT(*) AS num_peliculas
FROM film_actor
GROUP BY actor_id
HAVING COUNT(*) > 40
ORDER BY num_peliculas DESC;


-- =============================================================================
-- 29. Todas las películas y cantidad disponible en inventario (si existe)
-- =============================================================================
SELECT
    f.title,
    COUNT(i.inventory_id) AS cantidad_disponible
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
GROUP BY f.title
ORDER BY cantidad_disponible DESC;


-- =============================================================================
-- 30. Actores y número de películas en las que han actuado
-- =============================================================================
SELECT
    a.first_name,
    a.last_name,
    COUNT(fa.film_id) AS num_peliculas
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY num_peliculas DESC;


-- =============================================================================
-- 31. Todas las películas y los actores que han actuado en ellas
--     (incluyendo películas sin actores → LEFT JOIN desde film)
-- =============================================================================
SELECT
    f.title,
    a.first_name,
    a.last_name
FROM film f
LEFT JOIN film_actor fa ON f.film_id  = fa.film_id
LEFT JOIN actor a       ON fa.actor_id = a.actor_id
ORDER BY f.title;


-- =============================================================================
-- 32. Todos los actores y las películas en las que han actuado
--     (incluyendo actores sin películas → LEFT JOIN desde actor)
-- =============================================================================
SELECT
    a.first_name,
    a.last_name,
    f.title
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
LEFT JOIN film f        ON fa.film_id  = f.film_id
ORDER BY a.last_name;


-- =============================================================================
-- 33. Todas las películas y todos los registros de alquiler (CROSS entre
--     film e inventory+rental → se usa LEFT JOIN para obtener todos)
-- =============================================================================
-- Nota: un CROSS JOIN puro film × rental generaría millones de filas sin valor.
-- La consulta con sentido es obtener todas las películas junto con sus alquileres:
SELECT
    f.title,
    r.rental_id,
    r.rental_date,
    r.return_date
FROM film f
LEFT JOIN inventory i ON f.film_id     = i.film_id
LEFT JOIN rental r    ON i.inventory_id = r.inventory_id
ORDER BY f.title, r.rental_date;


-- =============================================================================
-- 34. Los 5 clientes que más dinero se han gastado
-- =============================================================================
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    ROUND(SUM(p.amount), 2) AS total_gastado
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_gastado DESC
LIMIT 5;


-- =============================================================================
-- 35. Actores cuyo primer nombre es 'Johnny'
-- =============================================================================
SELECT first_name, last_name
FROM actor
WHERE first_name = 'Johnny';


-- =============================================================================
-- 36. Renombrar columnas: first_name → Nombre, last_name → Apellido
-- =============================================================================
SELECT
    first_name AS "Nombre",
    last_name  AS "Apellido"
FROM actor;


-- =============================================================================
-- 37. ID del actor más bajo y más alto en la tabla actor
-- =============================================================================
SELECT
    MIN(actor_id) AS id_minimo,
    MAX(actor_id) AS id_maximo
FROM actor;


-- =============================================================================
-- 38. Cuántos actores hay en la tabla actor
-- =============================================================================
SELECT COUNT(*) AS total_actores
FROM actor;


-- =============================================================================
-- 39. Todos los actores ordenados por apellido de forma ascendente
-- =============================================================================
SELECT first_name, last_name
FROM actor
ORDER BY last_name ASC;


-- =============================================================================
-- 40. Las primeras 5 películas de la tabla film
-- =============================================================================
SELECT *
FROM film
LIMIT 5;


-- =============================================================================
-- 41. Actores agrupados por nombre y recuento → ¿cuál es el más repetido?
-- =============================================================================
SELECT
    first_name,
    COUNT(*) AS veces_repetido
FROM actor
GROUP BY first_name
ORDER BY veces_repetido DESC
LIMIT 1;
-- El nombre más repetido es el que aparece en la primera fila del resultado.


-- =============================================================================
-- 42. Todos los alquileres con el nombre del cliente que los realizó
-- =============================================================================
SELECT
    r.rental_id,
    r.rental_date,
    c.first_name,
    c.last_name
FROM rental r
JOIN customer c ON r.customer_id = c.customer_id
ORDER BY r.rental_date;


-- =============================================================================
-- 43. Todos los clientes y sus alquileres, incluyendo los que no tienen
--     (LEFT JOIN desde customer)
-- =============================================================================
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    r.rental_id,
    r.rental_date
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
ORDER BY c.customer_id;


-- =============================================================================
-- 44. CROSS JOIN entre film y category
-- =============================================================================
SELECT
    f.title,
    c.name AS categoria
FROM film f
CROSS JOIN category c;

-- ¿Aporta valor esta consulta?
-- NO aporta valor real. El CROSS JOIN genera el producto cartesiano de todas las
-- películas con todas las categorías (1000 películas × 16 categorías = 16.000 filas),
-- asociando cada película con TODAS las categorías indiscriminadamente, sin ninguna
-- relación real entre ellas. Para obtener la categoría correcta de cada película
-- se debe usar JOIN a través de la tabla film_category.


-- =============================================================================
-- 45. Actores que han participado en películas de la categoría 'Action'
-- =============================================================================
SELECT DISTINCT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa    ON a.actor_id      = fa.actor_id
JOIN film_category fc ON fa.film_id      = fc.film_id
JOIN category c       ON fc.category_id  = c.category_id
WHERE c.name = 'Action'
ORDER BY a.last_name;


-- =============================================================================
-- 46. Actores que NO han participado en ninguna película
-- =============================================================================
SELECT a.first_name, a.last_name
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
WHERE fa.film_id IS NULL;


-- =============================================================================
-- 47. Nombre de los actores y cantidad de películas en las que han participado
-- =============================================================================
SELECT
    a.first_name,
    a.last_name,
    COUNT(fa.film_id) AS num_peliculas
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY num_peliculas DESC;


-- =============================================================================
-- 48. Vista: actor_num_peliculas
-- =============================================================================
CREATE OR REPLACE VIEW actor_num_peliculas AS
SELECT
    a.first_name,
    a.last_name,
    COUNT(fa.film_id) AS num_peliculas
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY num_peliculas DESC;

-- Consulta de la vista:
-- SELECT * FROM actor_num_peliculas;


-- =============================================================================
-- 49. Número total de alquileres realizados por cada cliente
-- =============================================================================
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(r.rental_id) AS total_alquileres
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_alquileres DESC;


-- =============================================================================
-- 50. Duración total de las películas en la categoría 'Action'
-- =============================================================================
SELECT SUM(f.length) AS duracion_total_minutos
FROM film f
JOIN film_category fc ON f.film_id      = fc.film_id
JOIN category c       ON fc.category_id = c.category_id
WHERE c.name = 'Action';


-- =============================================================================
-- 51. Tabla temporal: cliente_rentas_temporal
-- =============================================================================
CREATE TEMP TABLE cliente_rentas_temporal AS
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(r.rental_id) AS total_alquileres
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- Consulta de la tabla temporal:
-- SELECT * FROM cliente_rentas_temporal ORDER BY total_alquileres DESC;


-- =============================================================================
-- 52. Tabla temporal: peliculas_alquiladas (alquiladas al menos 10 veces)
-- =============================================================================
CREATE TEMP TABLE peliculas_alquiladas AS
SELECT
    f.film_id,
    f.title,
    COUNT(r.rental_id) AS num_alquileres
FROM film f
JOIN inventory i ON f.film_id      = i.film_id
JOIN rental r    ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
HAVING COUNT(r.rental_id) >= 10;

-- Consulta de la tabla temporal:
-- SELECT * FROM peliculas_alquiladas ORDER BY num_alquileres DESC;


-- =============================================================================
-- 53. Películas alquiladas por 'Tammy Sanders' que aún no han sido devueltas
-- =============================================================================
SELECT f.title
FROM film f
JOIN inventory i ON f.film_id      = i.film_id
JOIN rental r    ON i.inventory_id = r.inventory_id
JOIN customer c  ON r.customer_id  = c.customer_id
WHERE c.first_name = 'Tammy'
  AND c.last_name  = 'Sanders'
  AND r.return_date IS NULL
ORDER BY f.title ASC;


-- =============================================================================
-- 54. Actores que han actuado en al menos una película de categoría 'Sci-Fi'
-- =============================================================================
SELECT DISTINCT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa    ON a.actor_id      = fa.actor_id
JOIN film_category fc ON fa.film_id      = fc.film_id
JOIN category c       ON fc.category_id  = c.category_id
WHERE c.name = 'Sci-Fi'
ORDER BY a.last_name ASC;


-- =============================================================================
-- 55. Actores que han actuado en películas alquiladas DESPUÉS del primer
--     alquiler de 'Spartacus Cheaper'
-- =============================================================================
SELECT DISTINCT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id     = fa.actor_id
JOIN inventory i   ON fa.film_id     = i.film_id
JOIN rental r      ON i.inventory_id = r.inventory_id
WHERE r.rental_date > (
    SELECT MIN(r2.rental_date)
    FROM rental r2
    JOIN inventory i2 ON r2.inventory_id = i2.inventory_id
    JOIN film f2      ON i2.film_id       = f2.film_id
    WHERE f2.title = 'Spartacus Cheaper'
)
ORDER BY a.last_name ASC;


-- =============================================================================
-- 56. Actores que NO han actuado en ninguna película de la categoría 'Music'
-- =============================================================================
SELECT a.first_name, a.last_name
FROM actor a
WHERE a.actor_id NOT IN (
    SELECT fa.actor_id
    FROM film_actor fa
    JOIN film_category fc ON fa.film_id      = fc.film_id
    JOIN category c       ON fc.category_id  = c.category_id
    WHERE c.name = 'Music'
)
ORDER BY a.last_name;


-- =============================================================================
-- 57. Películas que fueron alquiladas por más de 8 días
-- =============================================================================
SELECT DISTINCT f.title
FROM film f
JOIN inventory i ON f.film_id      = i.film_id
JOIN rental r    ON i.inventory_id = r.inventory_id
WHERE r.return_date IS NOT NULL
  AND (r.return_date - r.rental_date) > INTERVAL '8 days'
ORDER BY f.title;


-- =============================================================================
-- 58. Películas de la misma categoría que 'Animation'
-- =============================================================================
SELECT f.title
FROM film f
JOIN film_category fc ON f.film_id      = fc.film_id
JOIN category c       ON fc.category_id = c.category_id
WHERE c.name = 'Animation'
ORDER BY f.title;


-- =============================================================================
-- 59. Películas con la misma duración que 'Dancing Fever'
-- =============================================================================
SELECT title, length
FROM film
WHERE length = (
    SELECT length FROM film WHERE title = 'Dancing Fever'
)
  AND title <> 'Dancing Fever'
ORDER BY title ASC;


-- =============================================================================
-- 60. Clientes que han alquilado al menos 7 películas distintas
-- =============================================================================
SELECT
    c.first_name,
    c.last_name,
    COUNT(DISTINCT i.film_id) AS peliculas_distintas
FROM customer c
JOIN rental r    ON c.customer_id  = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT i.film_id) >= 7
ORDER BY c.last_name ASC;


-- =============================================================================
-- 61. Cantidad total de películas alquiladas por categoría
-- =============================================================================
SELECT
    c.name AS categoria,
    COUNT(r.rental_id) AS total_alquileres
FROM category c
JOIN film_category fc ON c.category_id  = fc.category_id
JOIN inventory i      ON fc.film_id     = i.film_id
JOIN rental r         ON i.inventory_id = r.inventory_id
GROUP BY c.name
ORDER BY total_alquileres DESC;


-- =============================================================================
-- 62. Número de películas por categoría estrenadas en 2006
-- =============================================================================
SELECT
    c.name AS categoria,
    COUNT(f.film_id) AS num_peliculas
FROM category c
JOIN film_category fc ON c.category_id  = fc.category_id
JOIN film f           ON fc.film_id     = f.film_id
WHERE f.release_year = 2006
GROUP BY c.name
ORDER BY num_peliculas DESC;


-- =============================================================================
-- 63. Todas las combinaciones posibles de trabajadores con tiendas (CROSS JOIN)
-- =============================================================================
SELECT
    s.first_name || ' ' || s.last_name AS empleado,
    st.store_id
FROM staff s
CROSS JOIN store st
ORDER BY empleado, st.store_id;


-- =============================================================================
-- 64. Cantidad total de películas alquiladas por cada cliente
--     (ID, nombre, apellido y cantidad)
-- =============================================================================
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(r.rental_id) AS total_peliculas_alquiladas
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_peliculas_alquiladas DESC;


-- =============================================================================
-- FIN DEL ARCHIVO
-- =============================================================================
