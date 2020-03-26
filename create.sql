/********************************************************************************************************/
DROP TABLE ASIGNACION_TRATAMIENTO;
DROP TABLE TRATAMIENTO;
DROP TABLE DETALLE_REUNION;
DROP TABLE REUNION;
DROP TABLE CONTACTO;
DROP TABLE ASIGNACION_UBICACION;
DROP TABLE UBICACION;
DROP TABLE ASOCIADO;
DROP TABLE VICTIMA;
DROP TABLE HOSPITAL;
/********************************************************************************************************/
/********************************************************************************************************/
CREATE TABLE HOSPITAL(
    id        NUMBER PRIMARY KEY,
    nombre    VARCHAR2(250) NOT NULL UNIQUE,
    direccion VARCHAR2(250) NOT NULL
);

CREATE TABLE VICTIMA(
    id                     NUMBER PRIMARY KEY,
    nombre                 VARCHAR2(250) NOT NULL,
    apellido               VARCHAR2(250) NOT NULL,
    direccion              VARCHAR2(250) NOT NULL,
    fecha_primera_sospecha DATE          NOT NULL,
    fecha_confirmacion     DATE          NOT NULL,
    fecha_muerte           DATE          NULL,
    estado                 VARCHAR2(250) NOT NULL,
    fk_hospital            NUMBER        NULL
);

ALTER TABLE VICTIMA ADD FOREIGN KEY (fk_hospital) REFERENCES HOSPITAL(id);
ALTER TABLE VICTIMA ADD CONSTRAINT VicU UNIQUE (nombre,apellido);

CREATE TABLE ASOCIADO(
    id NUMBER PRIMARY KEY,
    nombre   VARCHAR2(250) NOT NULL, 
    apellido VARCHAR2(250) NOT NULL
);

ALTER TABLE ASOCIADO ADD CONSTRAINT AsoU UNIQUE (nombre,apellido);

CREATE TABLE UBICACION(
    id NUMBER PRIMARY KEY,
    direccion VARCHAR2(250) NOT NULL UNIQUE
);

CREATE TABLE ASIGNACION_UBICACION(
    id NUMBER     PRIMARY KEY,
    fecha_llegada DATE   NOT NULL,
    fecha_retiro  DATE   NOT NULL,
    fk_victima    NUMBER NOT NULL,
    fk_ubicacion  NUMBER NOT NULL
);

ALTER TABLE ASIGNACION_UBICACION ADD FOREIGN KEY (fk_victima)   REFERENCES VICTIMA(id);
ALTER TABLE ASIGNACION_UBICACION ADD FOREIGN KEY (fk_ubicacion) REFERENCES UBICACION(id);

CREATE TABLE CONTACTO(
    id        NUMBER PRIMARY KEY,
    nombre    VARCHAR2(250) NOT NULL UNIQUE
);

CREATE TABLE REUNION(
    id             NUMBER PRIMARY KEY,
    fecha_conocido DATE   NOT NULL,
    fk_victima     NUMBER NOT NULL,
    fk_asociado    NUMBER NOT NULL
);

ALTER TABLE REUNION ADD FOREIGN KEY (fk_victima)  REFERENCES VICTIMA(id);
ALTER TABLE REUNION ADD FOREIGN KEY (fk_asociado) REFERENCES ASOCIADO(id);
ALTER TABLE REUNION ADD CONSTRAINT ReU UNIQUE (fk_victima,fk_asociado);

CREATE TABLE DETALLE_REUNION(
    id                    NUMBER PRIMARY KEY,
    fecha_inicio_contacto DATE   NOT NULL,
    fecha_fin_contacto    DATE   NOT NULL,
    fk_contacto           NUMBER NOT NULL,
    fk_reunion            NUMBER NOT NULL
);

ALTER TABLE DETALLE_REUNION ADD FOREIGN KEY (fk_contacto) REFERENCES CONTACTO(id);
ALTER TABLE DETALLE_REUNION ADD FOREIGN KEY (fk_reunion)  REFERENCES REUNION(id);

CREATE TABLE TRATAMIENTO(
    id NUMBER   PRIMARY KEY,
    nombre      VARCHAR2(250) NOT NULL UNIQUE,
    efectividad NUMBER        NOT NULL
);

CREATE TABLE ASIGNACION_TRATAMIENTO(
    id                       NUMBER PRIMARY KEY,
    fecha_inicio_tratamiento DATE   NOT NULL,
    fecha_fin_tratamiento    DATE   NOT NULL,
    efectividad_en_victima   NUMBER NOT NULL,
    fk_victima               NUMBER NOT NULL,
    fk_tratamiento           NUMBER NOT NULL
);

ALTER TABLE ASIGNACION_TRATAMIENTO ADD FOREIGN KEY (fk_victima)     REFERENCES VICTIMA(id);
ALTER TABLE ASIGNACION_TRATAMIENTO ADD FOREIGN KEY (fk_tratamiento) REFERENCES TRATAMIENTO(id);

/********************************************************************************************************/
