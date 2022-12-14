-- Consultar sobre cuál es el tipo de préstamo de mayor importe
SELECT 
    loan_type,
    loan_totaL 
FROM prestamo 
WHERE loan_total = (
    SELECT 
        MAX(CAST(loan_total as INT)) 
    FROM prestamo
    );

-- Seleccionar las cuentas con saldo negativo
SELECT *
FROM cuenta
WHERE balance<0

-- Seleccionar el nombre, apellido y edad de los clientes que tengan en el apellido la letra Z
SELECT 
    customer_name,
    customer_surname,
    CURRENT_DATE - strftime(dob) AS edad
FROM cliente 
WHERE customer_surname LIKE '%z%';

-- Seleccionar el nombre, apellido, edad y nombre de sucursal de las personas cuyo nombre sea “Brendan” y el resultado ordenarlo por nombre de sucursal
SELECT 
    customer_name,
    customer_surname,
    CURRENT_DATE - strftime(dob) AS Edad,
    branch_name AS Sucursal
FROM sucursal
INNER JOIN cliente ON sucursal.branch_id=cliente.branch_id
WHERE customer_name='Brendan'
ORDER BY branch_name

--Seleccionar de la tabla de préstamos, los préstamos con un importe mayor a $80.000 y los préstamos prendarios
SELECT *
FROM prestamo
WHERE loan_total>8000000 AND loan_type="PRENDARIO"

-- Seleccionar los prestamos cuyo importe sea mayor que el importe medio de todos los prestamos
SELECT *
FROM prestamo
WHERE loan_total > (
    SELECT 
        AVG(loan_total)
    FROM prestamo
    )

-- Contar la cantidad de clientes menores a 50 años
SELECT 
    COUNT(*) AS Menores_de_50_años 
FROM cliente
WHERE CURRENT_DATE - strftime(dob) < 50

-- Seleccionar las primeras 5 cuentas con saldo mayor a 8.000$
SELECT * 
FROM cuenta
WHERE balance >=8000 
ORDER BY balance
LIMIT 5

-- Seleccionar los préstamos que tengan fecha en abril, junio y agosto, ordenándolos por importe
SELECT *
FROM prestamo 
WHERE 
    loan_date LIKE '%-04-%' 
    OR loan_date LIKE '%-06-%' 
    OR loan_date LIKE '%-08-%' 
ORDER BY loan_total DESC

-- Obtener el importe total de los prestamos agrupados por tipo de préstamos. Por cada tipo de préstamo de la tabla préstamo, calcular la suma de susimportes. Renombrar la columna como loan_total_accu
SELECT 
    loan_type, 
    SUM(loan_total) loan_total_accu
FROM prestamo
WHERE loan_type IN ("HIPOTECARIO","PERSONAL","PRENDARIO")
GROUP BY loan_type

-- Listar la cantidad de clientes por nombre de sucursal ordenando de mayor a menor
SELECT 
    COUNT(*) clientes,
    branch_name
FROM cliente
INNER JOIN sucursal ON cliente.branch_id = sucursal.branch_id 
GROUP BY branch_name
ORDER BY clientes DESC

-- Obtener la cantidad de empleados por cliente por sucursal en un número real
-- REVISAR
SELECT
    COUNT(*) empleados,
    branch_name,
    customer_id
FROM empleado
INNER JOIN cliente ON sucursal.branch_id=cliente.branch_id
INNER JOIN sucursal ON empleado.branch_id=sucursal.branch_id
GROUP BY branch_name,customer_name

-- Obtener la cantidad de tarjetas de crédito por tipo por sucursal
SELECT
    COUNT(*) tarjetas,
    branch_name,
    tipo_tarjeta
FROM tarjeta
INNER JOIN cliente ON tarjeta.cliente_id=cliente.customer_id
INNER JOIN sucursal ON cliente.branch_id=sucursal.branch_id
GROUP BY branch_name,tipo_tarjeta

-- Obtener el promedio de créditos otorgado por sucursal
SELECT
    AVG(loan_total) AS prom_loan,
    branch_name
FROM prestamo
INNER JOIN cliente ON prestamo.customer_id=cliente.customer_id
INNER JOIN sucursal ON sucursal.branch_id=cliente.branch_id
GROUP BY branch_name

-- Cheques otorgados por sucursal
SELECT
    COUNT(*) cheques_otorgados,
    branch_name
FROM prestamo
INNER JOIN cliente ON prestamo.customer_id=cliente.customer_id
INNER JOIN sucursal ON sucursal.branch_id=cliente.branch_id
GROUP BY branch_name
