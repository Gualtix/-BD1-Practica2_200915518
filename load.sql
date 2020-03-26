/*******************************************************************************************************************************************/
/*HOSPITALES N = 77 */
CREATE OR REPLACE PROCEDURE LOAD_HOSPITALES AS
    cnt NUMBER := 0;
    CURSOR HOSPITALES IS SELECT * FROM TMP;
    BEGIN
        FOR HOSP IN HOSPITALES
        LOOP
            BEGIN
                cnt := cnt + 1;
                INSERT INTO HOSPITAL(id,nombre,direccion) VALUES (cnt,HOSP.NOMBRE_HOSPITAL,HOSP.DIRECCION_HOSPITAL);
                COMMIT;
                EXCEPTION WHEN OTHERS THEN
                cnt := cnt - 1;
            END;
        END LOOP;
END LOAD_HOSPITALES;
/
/*******************************************************************************************************************************************/
/*******************************************************************************************************************************************/
/*TRATAMIENTOS N = 5 */
CREATE OR REPLACE PROCEDURE LOAD_TRATAMIENTOS AS
    cnt number := 0;
    CURSOR TRATAMIENTOS IS SELECT * FROM TMP;
BEGIN
    FOR TRAT IN TRATAMIENTOS
    LOOP
        BEGIN
            cnt := cnt + 1;
            INSERT INTO TRATAMIENTO(id,nombre,efectividad) VALUES (cnt,TRAT.TRATAMIENTO,TRAT.EFECTIVIDAD);
            COMMIT;
            EXCEPTION WHEN OTHERS THEN
            cnt := cnt - 1;
        END;
    END LOOP;
END LOAD_TRATAMIENTOS;
/
/*******************************************************************************************************************************************/
/*******************************************************************************************************************************************/
/*CONTACTOS N = 8 */
CREATE OR REPLACE PROCEDURE LOAD_CONTACTOS AS
    cnt number := 0;
    CURSOR CONTACTOS IS SELECT * FROM TMP;
BEGIN
    FOR CONT IN CONTACTOS
    LOOP
        BEGIN
            cnt := cnt + 1;
            INSERT INTO CONTACTO(id,nombre) VALUES (cnt,CONT.CONTACTO_FISICO);
            COMMIT;
            EXCEPTION WHEN OTHERS THEN
            cnt := cnt - 1;
        END;
    END LOOP;
END LOAD_CONTACTOS;
/
/*******************************************************************************************************************************************/
/*******************************************************************************************************************************************/
/*UBICACIONES*/
/*N = 120*/
CREATE OR REPLACE PROCEDURE LOAD_UBICACIONES AS
    cnt number := 0;
    CURSOR UBICACIONES IS SELECT * FROM TMP;
BEGIN
    FOR UBI IN UBICACIONES
    LOOP
        BEGIN
            cnt := cnt + 1;
            INSERT INTO UBICACION(id,direccion) VALUES (cnt,UBI.UBICACION_VICTIMA);
            COMMIT;
            EXCEPTION WHEN OTHERS THEN
            cnt := cnt - 1;
        END;
    END LOOP;
END LOAD_UBICACIONES;
/
/*******************************************************************************************************************************************/
/*******************************************************************************************************************************************/
/*ASOCIADOS N = 500*/
CREATE OR REPLACE PROCEDURE LOAD_ASOCIADOS AS
    cnt number := 0;
    CURSOR ASOCIADOS IS SELECT * FROM TMP;
BEGIN
    FOR ASO IN ASOCIADOS
    LOOP
        BEGIN
            cnt := cnt + 1;
            INSERT INTO ASOCIADO(id,nombre,apellido) VALUES (cnt,ASO.NOMBRE_ASOCIADO,ASO.APELLIDO_ASOCIADO);
            COMMIT;
            EXCEPTION WHEN OTHERS THEN
            cnt := cnt - 1;
        END;
    END LOOP;
END LOAD_ASOCIADOS;
/
/*******************************************************************************************************************************************/
/*******************************************************************************************************************************************/
/*VICTIMAS*/
/*N = 1000*/
CREATE OR REPLACE PROCEDURE LOAD_VICTIMAS AS
    cnt number := 0;
    id_hospital number := 0;
    CURSOR VICTIMAS IS SELECT * FROM TMP;
BEGIN
    FOR VICTI IN VICTIMAS
    LOOP
        BEGIN
            cnt := cnt + 1;

            BEGIN
                SELECT id INTO id_hospital FROM HOSPITAL WHERE HOSPITAL.nombre = VICTI.NOMBRE_HOSPITAL;
                EXCEPTION WHEN NO_DATA_FOUND THEN
                id_hospital := NULL;
            END;
            INSERT INTO VICTIMA(
                id,
                nombre,
                apellido,
                direccion,
                fecha_primera_sospecha,
                fecha_confirmacion,
                fecha_muerte,
                estado,
                fk_hospital
                )
            VALUES (
                cnt,
                VICTI.NOMBRE_VICTIMA,
                VICTI.APELLIDO_VICTIMA,
                VICTI.DIRECCION_VICTIMA,
                TO_DATE(VICTI.FECHA_PRIMERA_SOSPECHA,'YYYY-MM-DD HH24:MI:SS'),
                TO_DATE(VICTI.FECHA_CONFIRMACION,'YYYY-MM-DD HH24:MI:SS'),
                TO_DATE(VICTI.FECHA_MUERTE,'YYYY-MM-DD HH24:MI:SS'),
                VICTI.ESTADO_VICTIMA,
                id_hospital
                );
            COMMIT;
            EXCEPTION WHEN OTHERS THEN
            BEGIN
                cnt := cnt - 1;
            END;
        END;
    END LOOP;
END LOAD_VICTIMAS;
/
/*******************************************************************************************************************************************/
/*******************************************************************************************************************************************/
/*REUNION*/
/*N = 4505*/
CREATE OR REPLACE PROCEDURE LOAD_REUNIONES AS
    cnt number := 0;
    id_Victima  number := 0;
    id_Asociado number := 0;
    CURSOR REUNIONES IS SELECT * FROM TMP;
BEGIN
    FOR REU IN REUNIONES
    LOOP
        BEGIN
            cnt := cnt + 1;
            BEGIN
                SELECT id INTO id_Victima  FROM VICTIMA  WHERE VICTIMA.nombre  = REU.NOMBRE_VICTIMA  AND VICTIMA.apellido  = REU.APELLIDO_VICTIMA;
                EXCEPTION WHEN NO_DATA_FOUND THEN
                id_Victima := NULL;
            END;
            BEGIN
                SELECT id INTO id_Asociado FROM ASOCIADO WHERE ASOCIADO.nombre = REU.NOMBRE_ASOCIADO AND ASOCIADO.apellido = REU.APELLIDO_ASOCIADO;
                EXCEPTION WHEN NO_DATA_FOUND THEN
                id_Asociado := NULL;
            END;
            INSERT INTO REUNION(id,fecha_conocido,fk_victima,fk_asociado) 
            VALUES (
                cnt,
                TO_DATE(REU.FECHA_CONOCIO,'YYYY-MM-DD HH24:MI:SS'),
                id_Victima,
                id_Asociado
                );
            COMMIT;
            EXCEPTION WHEN OTHERS THEN
            cnt := cnt - 1;
        END;
    END LOOP;
END LOAD_REUNIONES;
/
/*******************************************************************************************************************************************/
/*******************************************************************************************************************************************/
/*DETALLE_REUNION*/
/*N =  12447*/
CREATE OR REPLACE PROCEDURE LOAD_DETALLE_REUNIONES AS
    cnt number := 0;
    id_victima  number := 0;
    id_asociado number := 0;
    id_reunion  number := 0;
    id_contacto number := 0;
    CURSOR DET_REU IS SELECT * FROM TMP;
BEGIN
    FOR DTR IN DET_REU
    LOOP
        BEGIN

            IF (DTR.NOMBRE_VICTIMA = NULL) THEN
                CONTINUE;
            END IF;

            IF (DTR.NOMBRE_ASOCIADO = NULL) THEN
                CONTINUE;
            END IF;

            IF (DTR.CONTACTO_FISICO = NULL) THEN
                CONTINUE;
            END IF;

            cnt := cnt + 1;
            
            SELECT id INTO id_victima  FROM VICTIMA  WHERE(VICTIMA.nombre = DTR.NOMBRE_VICTIMA AND VICTIMA.apellido = DTR.APELLIDO_VICTIMA);
            SELECT id INTO id_asociado FROM ASOCIADO WHERE(ASOCIADO.nombre = DTR.NOMBRE_ASOCIADO AND ASOCIADO.apellido = DTR.APELLIDO_ASOCIADO);
            SELECT id INTO id_reunion  FROM REUNION  WHERE(REUNION.fk_victima = id_victima AND REUNION.fk_asociado = id_asociado);
            SELECT id into id_contacto FROM CONTACTO WHERE(CONTACTO.nombre = DTR.CONTACTO_FISICO);
        
            INSERT INTO DETALLE_REUNION(id,fecha_inicio_contacto,fecha_fin_contacto,fk_contacto,fk_reunion) 
            VALUES(
                cnt,
                TO_DATE(DTR.FECHA_INICIO_CONTACTO,'YYYY-MM-DD HH24:MI:SS'),
                TO_DATE(DTR.FECHA_FIN_CONTACTO,'YYYY-MM-DD HH24:MI:SS'),
                id_contacto,
                id_reunion
            );
            COMMIT;
            EXCEPTION WHEN OTHERS THEN
            cnt := cnt - 1;
        END;
    END LOOP;
END LOAD_DETALLE_REUNIONES;
/
/*******************************************************************************************************************************************/
/*******************************************************************************************************************************************/
/*ASIGNACION_UBICACIONES*/
/*N = 10137*/
CREATE OR REPLACE PROCEDURE LOAD_ASIGNACION_UBICACIONES AS
    cnt number := 0;
    id_victima    number := 0;
    id_ubicacion  number := 0;
    CURSOR ASUBIS IS SELECT * FROM TMP;
BEGIN
    FOR ABI IN ASUBIS
    LOOP
        BEGIN

            IF (ABI.NOMBRE_VICTIMA = NULL) THEN
                CONTINUE;
            END IF;

            IF (ABI.UBICACION_VICTIMA = NULL) THEN
                CONTINUE;
            END IF;

            IF (ABI.FECHA_LLEGADA = NULL) THEN
                CONTINUE;
            END IF;

            IF (ABI.FECHA_RETIRO = NULL) THEN
                CONTINUE;
            END IF;

            cnt := cnt + 1;

            SELECT id INTO id_victima   FROM VICTIMA   WHERE(VICTIMA.nombre = ABI.NOMBRE_VICTIMA AND VICTIMA.apellido = ABI.APELLIDO_VICTIMA);
            SELECT id INTO id_ubicacion FROM UBICACION WHERE(UBICACION.direccion = ABI.UBICACION_VICTIMA);

            INSERT INTO ASIGNACION_UBICACION(id,fecha_llegada,fecha_retiro,fk_victima,fk_ubicacion)
            VALUES(
                cnt,
                TO_DATE(ABI.FECHA_LLEGADA,'YYYY-MM-DD HH24:MI:SS'),
                TO_DATE(ABI.FECHA_RETIRO,'YYYY-MM-DD HH24:MI:SS'),
                id_victima,
                id_ubicacion
            );
            COMMIT;
            EXCEPTION WHEN OTHERS THEN
            cnt := cnt - 1;
        END;
    END LOOP;
END LOAD_ASIGNACION_UBICACIONES;
/
/*******************************************************************************************************************************************/
/*******************************************************************************************************************************************/
/*ASIGNACION_TRATAMIENTO*/
/*N = 6219*/
CREATE OR REPLACE PROCEDURE LOAD_ASIGNACION_TRATAMIENTOS AS
    cnt number := 0;
    id_victima      number := 0;
    id_tratamiento  number := 0;
    CURSOR ASTRAT IS SELECT * FROM TMP;
BEGIN
    FOR AST IN ASTRAT
    LOOP
        BEGIN
            IF (AST.FECHA_INICIO_TRATAMIENTO = NULL) THEN
                CONTINUE;
            END IF;

            IF (AST.FECHA_FIN_TRATAMIENTO = NULL) THEN
                CONTINUE;
            END IF;

            IF (AST.EFECTIVIDAD_EN_VICTIMA = NULL) THEN
                CONTINUE;
            END IF;

            IF (AST.NOMBRE_VICTIMA = NULL) THEN
                CONTINUE;
            END IF;

            IF (AST.TRATAMIENTO = NULL) THEN
                CONTINUE;
            END IF;

            cnt := cnt + 1;

            SELECT id INTO id_victima     FROM VICTIMA     WHERE(VICTIMA.nombre = AST.NOMBRE_VICTIMA AND VICTIMA.apellido = AST.APELLIDO_VICTIMA);
            SELECT id INTO id_tratamiento FROM TRATAMIENTO WHERE(TRATAMIENTO.nombre = AST.TRATAMIENTO);

            INSERT INTO ASIGNACION_TRATAMIENTO(id,fecha_inicio_tratamiento,fecha_fin_tratamiento,efectividad_en_victima,fk_victima,fk_tratamiento)
            VALUES(
                cnt,
                AST.FECHA_INICIO_TRATAMIENTO,
                AST.FECHA_FIN_TRATAMIENTO,
                AST.EFECTIVIDAD_EN_VICTIMA,
                id_victima,
                id_tratamiento
            );
            COMMIT;
            EXCEPTION WHEN OTHERS THEN
            cnt := cnt - 1;
        END;
    END LOOP;
END LOAD_ASIGNACION_TRATAMIENTOS;
/
/*******************************************************************************************************************************************/
/*******************************************************************************************************************************************/

SELECT * FROM TMP FETCH FIRST 500 ROWS ONLY;

EXEC LOAD_HOSPITALES;
SELECT * FROM HOSPITAL ORDER BY ID;

EXEC LOAD_TRATAMIENTOS;
SELECT * FROM TRATAMIENTO ORDER BY ID;

EXEC LOAD_CONTACTOS;
SELECT * FROM CONTACTO ORDER BY ID;

EXEC LOAD_UBICACIONES;
SELECT * FROM UBICACION ORDER BY ID;

EXEC LOAD_ASOCIADOS;
SELECT * FROM ASOCIADO ORDER BY ID;

EXEC LOAD_VICTIMAS;
SELECT * FROM VICTIMA ORDER BY ID;

EXEC LOAD_REUNIONES;
SELECT * FROM REUNION ORDER BY ID;

EXEC LOAD_DETALLE_REUNIONES;
SELECT * FROM DETALLE_REUNION ORDER BY ID;

EXEC LOAD_ASIGNACION_UBICACIONES;
SELECT * FROM ASIGNACION_UBICACION ORDER BY ID;

EXEC LOAD_ASIGNACION_TRATAMIENTOS;
SELECT * FROM ASIGNACION_TRATAMIENTO ORDER BY ID;
/*******************************************************************************************************************************************/

SET SERVEROUTPUT ON;
alter session set nls_date_format='YYYY-MM-DD HH24:MI:SS';

--dbms_output.put_line( DTR.NOMBRE_VICTIMA || ' : ' ||  DTR.NOMBRE_ASOCIADO || ' : ' || DTR.CONTACTO_FISICO);
