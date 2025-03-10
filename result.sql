use hr;


--1. Consultar los empleados del departamento de ventas que no tienen comisión.
-- Utilizaremos inner join para poder saber el id del departamento ventas
select * 
from employees e 
inner join departments d 
on e.department_id = d.department_id 
and d.department_name = 'Sales' 
and e.commission_pct is NULL;
-- ninguno

--2. Consultar los empleados que ingresaron a trabajar en 1987
-- Utilizamos el operador Between para buscar en un rango, en este caso de fechas, donde también hay que tener en cuenta el formato de la fecha
select * 
from employees 
where hire_date between '1987-01-01' and '1987-12-31';

--3. Consultar los empleados cuyo ingreso (salario + comisión) supera los 2500. 
-- Primero vamos a crear una función que nos calcule el ingreso Total, que sería la suma del salario y el porcentaje de comisión aplicado al salario tambien
create function calcularIngreso(salario decimal(8,2),porcentaje decimal(8,2))
RETURNS decimal(8,2) DETERMINISTIC
-- DETERMINISTIC indica que para los mismos valores de entrada, la función siempre devolverá el mismo resultado (no depende de datos externos ni cambia con el tiempo).
RETURN salario*porcentaje+salario;
-- tipo DECIMAL(8,2), que significa: 8 dígitos en total, 2 dígitos después del punto decimal.
-- Después crearemos la sentencia utilizando la función en la clausula WHERE
-- Debemos tener en cuenta que el campo commission_pct puede ser NULL, asi que si el valor es NULL le pasaremos un 0.
select * 
from employees  
where if(commission_pct is NULL, calcularIngreso(salary,0), calcularIngreso(salary,commission_pct)) > 2500;
-- El if es una función condicional que evalúa si el valor de commission_pct es NULL. Si es NULL, utiliza el valor 0 para calcular el ingreso. Si no es NULL, utiliza el valor de commission_pct. Como un operador ternario.

--4. Consultar los empleados cuya penúltima letra de su nombre es E.
-- Utilizamos la función substring(palabra, posicion inicial, cuantos caracteres selecciono) y la función char_length que me devuelve la longitud de la palabra
select * 
from employees 
where substring(first_name,CHAR_LENGTH(first_name)-1,1)='e';

--5. Consultar los empleado que la segunda letra de su nombre puede ser A, i, o, u.
-- SOLUCION RECOMENDADA. La misma funcion substring utilizando el operador IN y la lista de caracteres a comparar en la clausula WHERE
select * 
from employees 
where substring(first_name,2,1) in ('a','i','o','u'); 

-- Ejemplo de uso con el operador OR en la clausula WHERE
select * 
from employees 
where substring(first_name,2,1)='a' 
or substring(first_name,2,1)='i'
Or substring(first_name,2,1)='o' 
Or substring(first_name,2,1)='u';

--6. Se necesita saber cuánto es el gasto total en salarios por cada departamento.
-- Utilizamos inner join para sacar el nombre del departamento por el que agrupamos. 
select d.department_name, SUM(e.salary) as gastoTotal
from employees e
inner join departments d
on e.department_id = d.department_id
group by d.department_name;

--7. Desarrolle una consulta que liste las ciudades de la región Europe donde trabajan nuestros empleados.
-- Sentencia con 2 inner join y la condicion de que la region sea Europe
select r.region_id, c.country_name, l.city 
from locations l 
inner join countries c 
inner join regions r 
on l.country_id = c.country_id 
and c.region_id = r.region_id 
and r.region_name = 'Europe';

--8. Se necesita saber el salario máximo, mínimo y el salario promedio por departamento.
--El group solo permite en el select los campos por los q agrupas y funciones de grupo aplicadas a campos
select department_id, max(salary),min(salary),avg(salary)
from employees
group by department_id;