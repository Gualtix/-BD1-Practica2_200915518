/*1. Mostrar el nombre del hospital, su direccion y el numero de fallecidos por
cada hospital registrado*/

SELECT 
    COUNT(V.fk_hospital) AS MUERTOS,
    H.nombre    AS HOSPI,
    H.direccion AS DIR
    FROM VICTIMA V
    INNER JOIN HOSPITAL H
    ON (V.fk_hospital = H.id)
    WHERE (V.fk_hospital IS NOT NULL)
    GROUP BY V.fk_hospital,H.nombre,H.direccion;

/*2. Mostrar el nombre, apellido de todas las victimas en cuarentena que
presentaron una efectividad mayor a 5 en el tratamiento Transfusiones de
sangre?*/

SELECT 
    V.nombre    AS Nombre,
    V.apellido  AS Apellido,
    V.estado    AS Estado,
    TRAT.nombre AS TRAT,
    AST.efectividad_en_victima AS EfectividadEnVictima
    FROM 
    VICTIMA V
    INNER JOIN ASIGNACION_TRATAMIENTO AST ON (V.id = AST.fk_victima) 
    INNER JOIN TRATAMIENTO TRAT ON (TRAT.id = AST.fk_tratamiento)
    WHERE AST.efectividad_en_victima > 5 AND V.estado = 'En cuarentena' AND TRAT.nombre ='Transfusiones de sangre'
    GROUP BY V.nombre,V.apellido,V.estado,TRAT.nombre,AST.efectividad_en_victima;

/*3. Mostrar el nombre, apellido y direccion de las victimas fallecidas con mas de
tres personas asociadas*/

SELECT 
    V.nombre     AS Nombre,
    V.apellido   AS Apellido,
    V.direccion  AS Direccion,
    COUNT(V.id)  AS N_Asociados
    FROM VICTIMA V
    INNER JOIN REUNION REU ON(V.id = REU.fk_victima)
    WHERE V.fecha_muerte IS NOT NULL
    GROUP BY V.nombre,V.apellido,V.direccion
    HAVING COUNT(V.id) > 3;
  

/*4. Mostrar el nombre y apellido de todas las victimas en estado Suspendida
que tuvieron contacto fisico de tipo Beso con mas de 2 de sus asociados*/

SELECT 
    V.nombre     AS Nombre,
    V.apellido   AS Apellido,
    V.estado     AS Estado,
    CONT.nombre  AS Conacto,
    COUNT(V.id)  AS N_Contactos
    FROM VICTIMA V
    INNER JOIN REUNION REU ON(V.id = REU.fk_victima)
    INNER JOIN DETALLE_REUNION DR ON (REU.id = DR.fk_reunion)
    INNER JOIN CONTACTO CONT ON (DR.fk_contacto = CONT.id)
    WHERE(CONT.nombre = 'Beso' AND V.estado = 'Sospecha' ) 
    GROUP BY V.nombre,V.apellido,V.estado,CONT.nombre
    HAVING COUNT(V.id) > 2;

/*5. Top 5 de victimas que mas tratamientos se han aplicado del tratamiento
Oxigeno*/
SELECT 
    V.nombre     AS Nombre,
    V.apellido   AS Apellido,
    T.nombre     AS Tratamiento,
    COUNT(V.id)  AS Cantidad
    FROM VICTIMA V
    INNER JOIN ASIGNACION_TRATAMIENTO AST ON(V.id = AST.fk_victima)
    INNER JOIN TRATAMIENTO T ON(T.id = AST.fk_tratamiento)
    WHERE T.nombre = 'Oxigeno'
    GROUP BY V.nombre,V.apellido,T.nombre
    ORDER BY COUNT(V.id) DESC  FETCH FIRST 5 ROWS ONLY;


/*6. Mostrar el nombre, el apellido y la fecha de fallecimiento de todas las
victimas que se movieron por la direccion 1987 Delphine Well a los cuales
se les aplico "Manejo de la presion arterial" como tratamiento*/
SELECT 
    V.nombre         AS Nombre,
    V.apellido       AS Apellido,
    V.fecha_muerte   AS Fecha_Fallecimiento,
    UBI.direccion    AS Direccion,
    T.nombre         AS Tratamiento
    FROM VICTIMA V
    INNER JOIN ASIGNACION_UBICACION   ASU ON (V.id = ASU.fk_victima)
    INNER JOIN UBICACION              UBI ON (ASU.fk_ubicacion = UBI.id)
    INNER JOIN ASIGNACION_TRATAMIENTO AST ON (V.id = AST.fk_victima)
    INNER JOIN TRATAMIENTO            T ON(AST.fk_tratamiento = T.id)
    WHERE UBI.direccion = '1987 Delphine Well' AND T.nombre = 'Manejo de la presion arterial'
    GROUP BY V.nombre,V.apellido,V.fecha_muerte,UBI.direccion,T.nombre


/*7. Mostrar nombre, apellido y direccion de las victimas que tienen menos de 2
allegados los cuales hayan estado en un hospital y que se le hayan aplicado
unicamente dos tratamientos*/


SELECT 
    V.nombre         AS Nombre,
    V.apellido       AS Apellido,
    V.direccion      AS Direccion,
    COUNT(V.id)      AS N_Asociados,
    (SELECT COUNT(*) FROM ASIGNACION_TRATAMIENTO WHERE ASIGNACION_TRATAMIENTO.fk_victima = V.id) AS N_Tratamientos
    FROM VICTIMA V
    INNER JOIN REUNION                REU ON(V.id = REU.fk_victima)
    GROUP BY V.nombre,V.apellido,V.direccion
    HAVING COUNT(V.id) >= 2 ;














SELECT 
    V.nombre         AS Nombre,
    V.apellido       AS Apellido,
    V.direccion      AS Direccion,
    COUNT(V.id)      AS N_Asociados,
    (SELECT COUNT(*) FROM ASIGNACION_TRATAMIENTO WHERE ASIGNACION_TRATAMIENTO.fk_victima = V.id) AS N_Tratamientos
    FROM VICTIMA V
    INNER JOIN REUNION                REU ON(V.id = REU.fk_victima)
    GROUP BY V.nombre,V.apellido,V.direccion
    HAVING COUNT(V.id) >= 2 ;
    
    
    
    
    
SELECT 
    V.nombre         AS Nombre,
    V.apellido       AS Apellido,
    V.direccion      AS Direccion,
    COUNT(V.id)      AS N_Asociados,
    COUNT(AST.id)    AS N_Tratamientos
    FROM VICTIMA V
    INNER JOIN REUNION                REU ON(V.id = REU.fk_victima)
    INNER JOIN ASIGNACION_TRATAMIENTO AST ON(V.id = AST.fk_victima)
    GROUP BY V.nombre,V.apellido,V.direccion
    HAVING COUNT(V.id) >=2 ;    
    
 
    
    
/*8. Mostrar el numero de mes,de la fecha de la primera sospecha, nombre y
apellido de las victimas que mas tratamientos se han aplicado y las que
menos. (Todo en una sola consulta)*/

/*9. Mostrar el porcentaje de victimas que le corresponden a cada hospital*/

SELECT 
    H.nombre                       AS HOSP,
    COUNT(H.id)                    AS N_Victimas,
    (SELECT COUNT(*) FROM VICTIMA WHERE VICTIMA.fk_hospital IS NOT NULL) AS TOTAL_VICTIMA,
    ROUND((COUNT(H.id)/ (SELECT COUNT(*) FROM VICTIMA WHERE VICTIMA.fk_hospital IS NOT NULL) )*100,2) AS LOLI
    FROM HOSPITAL H
    INNER JOIN VICTIMA V ON (V.fk_hospital = H.id)
    WHERE V.fk_hospital IS NOT NULL
    GROUP BY H.nombre;



/*10.Mostrar el porcentaje del contacto fisco mas comun de cada hospital de la
siguiente manera: nombre de hospital, nombre del contacto fisico,
porcentaje de victimas*/



