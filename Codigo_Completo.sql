-------------------------------------------------------------
-- AZULES: ESTRUCTURA Y RESTRICCIONES DECLARATIVAS
-------------------------------------------------------------

--------------------------
-- TABLAS
--------------------------

CREATE TABLE Usuarios (
id_usuario INT NOT NULL,
nombre VARCHAR2(150) NOT NULL,
correo VARCHAR2(150) NOT NULL,
contrasena VARCHAR2(200) NOT NULL,
rol VARCHAR2(30) NOT NULL
);

CREATE TABLE Estudiantes (
id_estudiante INT NOT NULL,
id_usuario INT NOT NULL,
carrera VARCHAR2(100) NOT NULL,
semestre INT NOT NULL
);

CREATE TABLE Tutores (
id_tutor INT NOT NULL,
id_usuario INT NOT NULL,
experiencia VARCHAR2(200) NOT NULL,
tarifa_hora NUMBER(10,2) NOT NULL,
calificacion_promedio NUMBER(5,2) NOT NULL
);

CREATE TABLE Disponibilidades (
id_disponibilidad INT NOT NULL,
id_tutor INT NOT NULL,
fecha DATE NOT NULL,
hora_inicio DATE NOT NULL,
hora_fin DATE NOT NULL,
estado VARCHAR2(20) NOT NULL 
);

CREATE TABLE Especialidades (
id_especialidad INT NOT NULL,
nombre VARCHAR2(120) NOT NULL,
descripcion VARCHAR2(300) NOT NULL
);

CREATE TABLE Materias (
id_materia INT NOT NULL,
nombre VARCHAR2(120) NOT NULL,
id_especialidad INT NOT NULL
);

CREATE TABLE Reservas (
id_reserva INT NOT NULL,
id_estudiante INT NOT NULL,
id_tutor INT NOT NULL,
id_materia INT NOT NULL,
fecha_reserva DATE NOT NULL,
estado VARCHAR2(20) NOT NULL
);

CREATE TABLE Sesiones (
id_sesion INT NOT NULL,
id_reserva INT NOT NULL,
fecha_inicio DATE NOT NULL,
fecha_fin DATE NOT NULL,
estado VARCHAR2(20) NOT NULL
);

CREATE TABLE Pagos (
id_pago INT NOT NULL,
id_sesion INT NOT NULL,
monto NUMBER(12,2) NOT NULL,
fecha_pago DATE NOT NULL,
estado VARCHAR2(20) NOT NULL
);

CREATE TABLE Resenias (
id_resenia INT NOT NULL,
id_reserva INT NOT NULL,
calificacion NUMBER(3,1) NOT NULL,
comentario VARCHAR2(500) NOT NULL,
fecha_resenia DATE NOT NULL
);

--------------------------
-- RESTRICCIONES 
--------------------------

-- PRIMARY KEYS

ALTER TABLE Usuarios
ADD CONSTRAINT pk_usuario PRIMARY KEY (id_usuario);

ALTER TABLE Estudiantes    
ADD CONSTRAINT pk_estudiante PRIMARY KEY (id_estudiante);

ALTER TABLE Tutores   
ADD CONSTRAINT pk_tutor PRIMARY KEY (id_tutor);

ALTER TABLE Disponibilidades 
ADD CONSTRAINT pk_disponibilidad PRIMARY KEY (id_disponibilidad);

ALTER TABLE Especialidades
ADD CONSTRAINT pk_especialidad PRIMARY KEY (id_especialidad);

ALTER TABLE Materias
ADD CONSTRAINT pk_materia PRIMARY KEY (id_materia);

ALTER TABLE Reservas      
ADD CONSTRAINT pk_reserva PRIMARY KEY (id_reserva);

ALTER TABLE Sesiones      
ADD CONSTRAINT pk_sesion PRIMARY KEY (id_sesion);

ALTER TABLE Pagos      
ADD CONSTRAINT pk_pago PRIMARY KEY (id_pago);

ALTER TABLE Resenias       
ADD CONSTRAINT pk_resenia PRIMARY KEY (id_resenia);

-- UNIQUE

ALTER TABLE Usuarios
ADD CONSTRAINT uq_usuario_correo UNIQUE (correo);


-- FOREIGN KEYS

ALTER TABLE Estudiantes
ADD CONSTRAINT fk_estudiante_usuario FOREIGN KEY (id_usuario)
REFERENCES Usuario (id_usuario);

ALTER TABLE Tutores
ADD CONSTRAINT fk_tutor_usuario FOREIGN KEY (id_usuario)
REFERENCES Usuario (id_usuario);

ALTER TABLE Disponibilidades
ADD CONSTRAINT fk_disponibilidad_tutor FOREIGN KEY (id_tutor)
REFERENCES Tutor (id_tutor);

ALTER TABLE Materias
ADD CONSTRAINT fk_materia_especialidad FOREIGN KEY (id_especialidad)
REFERENCES Especialidad (id_especialidad);

ALTER TABLE Reservas
ADD CONSTRAINT fk_reserva_estudiante FOREIGN KEY (id_estudiante)
REFERENCES Estudiante (id_estudiante);

ALTER TABLE Reservas
ADD CONSTRAINT fk_reserva_tutor FOREIGN KEY (id_tutor)
REFERENCES Tutor (id_tutor);

ALTER TABLE Reservas
ADD CONSTRAINT fk_reserva_materia FOREIGN KEY (id_materia)
REFERENCES Materia (id_materia);

ALTER TABLE Sesiones
ADD CONSTRAINT fk_sesion_reserva FOREIGN KEY (id_reserva)
REFERENCES Reserva (id_reserva);

ALTER TABLE Pagos
ADD CONSTRAINT fk_pago_sesion FOREIGN KEY (id_sesion)
REFERENCES Sesion (id_sesion);

ALTER TABLE Resenias
ADD CONSTRAINT fk_resenia_reserva FOREIGN KEY (id_reserva)
REFERENCES Reserva (id_reserva);

-- CHECKs

ALTER TABLE Tutores
ADD CONSTRAINT ck_tutor_tarifa 
CHECK (tarifa_hora >= 0);

ALTER TABLE Tutores
ADD CONSTRAINT ck_tutor_calificacion 
CHECK (calificacion_promedio BETWEEN 0 AND 100);

ALTER TABLE Reservas
ADD CONSTRAINT ck_reserva_estado
CHECK (estado IN ('En espera', 'Confirmada', 'Cancelada', 'Finalizada'));

ALTER TABLE Sesiones
ADD CONSTRAINT ck_sesion_estado
CHECK (estado IN ('Programada','En curso','Finalizada','Cancelada'));

ALTER TABLE Pagos
ADD CONSTRAINT ck_pago_estado 
CHECK (estado IN ('En espera','Pagado','Fallido'));



-- Inserción de datos de ejemplo(10.000 datos por tabla)(PoblarOk)

-------------------------------------------------------------
-- 10.000 USUARIOS
-------------------------------------------------------------

DECLARE
BEGIN
    FOR i IN 1..10000 LOOP
        INSERT INTO USUARIOS (id_usuario, nombre, correo, contrasena, rol)
        VALUES (
            i,
            'Usuario ' || i,
            'usuario' || i || '@mail.com',
            'pass' || i,
            CASE 
                WHEN MOD(i, 2) = 0 THEN 'Estudiante'
                ELSE 'Tutor'
            END
        );
    END LOOP;
END;
/
-------------------------------------------------------------
-- 10.000 ESTUDIANTES (usuarios pares)
-------------------------------------------------------------
DECLARE
    v_id NUMBER := 2; 
BEGIN
    FOR i IN 1..10000 LOOP
        INSERT INTO ESTUDIANTES (id_estudiante, id_usuario, carrera, semestre)
        VALUES (
            i,
            v_id,
            'Carrera ' || MOD(i, 20),
            MOD(i, 10) + 1
        );
        v_id := v_id + 2;
    END LOOP;
END;
/
-------------------------------------------------------------
-- 10.000 TUTORES (usuarios impares)
-------------------------------------------------------------
DECLARE
    v_id NUMBER := 1;
BEGIN
    FOR i IN 1..10000 LOOP
        INSERT INTO TUTORES (id_tutor, id_usuario, experiencia, tarifa_hora, calificacion_promedio)
        VALUES (
            i,
            v_id,
            'Experiencia ' || i,
            MOD(i, 50) + 10,
            MOD(i, 5) * 10
        );
        v_id := v_id + 2;
    END LOOP;
END;
/
-------------------------------------------------------------
-- 10.000 ESPECIALIDADES
-------------------------------------------------------------
DECLARE
BEGIN
    FOR i IN 1..10000 LOOP
        INSERT INTO ESPECIALIDADES (id_especialidad, nombre, descripcion)
        VALUES (
            i,
            'Especialidad ' || i,
            'Descripcion de especialidad ' || i
        );
    END LOOP;
END;
/
-------------------------------------------------------------
-- 10.000 MATERIAS
-------------------------------------------------------------
DECLARE
BEGIN
    FOR i IN 1..10000 LOOP
        INSERT INTO MATERIAS (id_materia, nombre, id_especialidad)
        VALUES (
            i,
            'Materia ' || i,
            MOD(i, 10000) + 1
        );
    END LOOP;
END;
/
-------------------------------------------------------------
-- 10.000 RESERVAS
-------------------------------------------------------------
DECLARE
BEGIN
    FOR i IN 1..10000 LOOP
        INSERT INTO RESERVAS (id_reserva, id_estudiante, id_tutor, id_materia, fecha_reserva, estado)
        VALUES (
            i,
            MOD(i, 10000) + 1,
            MOD(i + 1, 10000) + 1,
            MOD(i + 2, 10000) + 1,
            SYSDATE - MOD(i, 365),
            'Confirmada'
        );
    END LOOP;
END;
/
-------------------------------------------------------------
-- 10.000 SESIONES
-------------------------------------------------------------
DECLARE
BEGIN
    FOR i IN 1..10000 LOOP
        INSERT INTO SESIONES (id_sesion, id_reserva, fecha_inicio, fecha_fin, estado)
        VALUES (
            i,
            MOD(i, 10000) + 1,
            SYSDATE - MOD(i, 365),
            SYSDATE - MOD(i, 365) + 1/24,
            'Finalizada'
        );
    END LOOP;
END;
/
-------------------------------------------------------------
-- 10.000 PAGOS
-------------------------------------------------------------
DECLARE
BEGIN
    FOR i IN 1..10000 LOOP
        INSERT INTO PAGOS (id_pago, id_sesion, monto, fecha_pago, estado)
        VALUES (
            i,
            MOD(i, 10000) + 1,
            MOD(i, 100) + 20,
            SYSDATE - MOD(i, 365),
            'Pagado'
        );
    END LOOP;
END;
/
-------------------------------------------------------------
-- 10.000 RESEÑAS
-------------------------------------------------------------
DECLARE
BEGIN
    FOR i IN 1..10000 LOOP
        INSERT INTO RESENIAS (id_resenia, id_reserva, calificacion, comentario, fecha_resenia)
        VALUES (
            i,
            MOD(i, 10000) + 1,
            MOD(i, 5) + 1,
            'Comentario ' || i,
            SYSDATE - MOD(i, 365)
        );
    END LOOP;
END;
/

COMMIT;

---------------------------------------------------------------------
-- PoblarNoOk
---------------------------------------------------------------------

------------------------------------------------------------
-- 1. PRIMARY KEY DUPLICADA → Usuarios.id_usuario
------------------------------------------------------------

-- Todos fallan porque id_usuario = 1 ya existe
INSERT INTO Usuarios VALUES (1,'A','a@mail.com','x','Est'); -- PK duplicada
INSERT INTO Usuarios VALUES (1,'B','b@mail.com','x','Est'); -- PK duplicada
INSERT INTO Usuarios VALUES (1,'C','c@mail.com','x','Est'); -- PK duplicada
INSERT INTO Usuarios VALUES (1,'D','d@mail.com','x','Est'); -- PK duplicada
INSERT INTO Usuarios VALUES (1,'E','e@mail.com','x','Est'); -- PK duplicada
INSERT INTO Usuarios VALUES (1,'F','f@mail.com','x','Est'); -- PK duplicada
INSERT INTO Usuarios VALUES (1,'G','g@mail.com','x','Est'); -- PK duplicada
INSERT INTO Usuarios VALUES (1,'H','h@mail.com','x','Est'); -- PK duplicada
INSERT INTO Usuarios VALUES (1,'I','i@mail.com','x','Est'); -- PK duplicada
INSERT INTO Usuarios VALUES (1,'J','j@mail.com','x','Est'); -- PK duplicada


------------------------------------------------------------
-- 2. UNIQUE CORREO VIOLADO
------------------------------------------------------------

-- Todos fallan porque el correo "correo@mail.com" se repite
INSERT INTO Usuarios VALUES (2,'Juan','correo@mail.com','123','Est'); -- correo repetido
INSERT INTO Usuarios VALUES (3,'Ana','correo@mail.com','123','Est'); -- correo repetido
INSERT INTO Usuarios VALUES (4,'Luis','correo@mail.com','123','Est'); -- correo repetido
INSERT INTO Usuarios VALUES (5,'Ana','correo@mail.com','123','Est'); -- correo repetido
INSERT INTO Usuarios VALUES (6,'Sara','correo@mail.com','123','Est'); -- correo repetido
INSERT INTO Usuarios VALUES (7,'Leo','correo@mail.com','123','Est'); -- correo repetido
INSERT INTO Usuarios VALUES (8,'Lia','correo@mail.com','123','Est'); -- correo repetido
INSERT INTO Usuarios VALUES (9,'Sam','correo@mail.com','123','Est'); -- correo repetido
INSERT INTO Usuarios VALUES (10,'Kim','correo@mail.com','123','Est'); -- correo repetido
INSERT INTO Usuarios VALUES (11,'Dan','correo@mail.com','123','Est'); -- correo repetido


------------------------------------------------------------
-- 3. FOREIGN KEY → Estudiantes.id_usuario REFERENCIA A TABLA *NO EXISTENTE* "Usuario"
------------------------------------------------------------

-- Todos fallan porque “Usuario” NO existe (la tabla correcta es Usuarios)
INSERT INTO Estudiantes VALUES (1,100,'Ing',5); -- FK referencia tabla inexistente
INSERT INTO Estudiantes VALUES (2,101,'Medicina',3); -- tabla inexistente
INSERT INTO Estudiantes VALUES (3,102,'Derecho',4); -- tabla inexistente
INSERT INTO Estudiantes VALUES (4,103,'Química',1); -- tabla inexistente
INSERT INTO Estudiantes VALUES (5,104,'Arte',2); -- tabla inexistente
INSERT INTO Estudiantes VALUES (6,105,'Ing',6); -- tabla inexistente
INSERT INTO Estudiantes VALUES (7,106,'Ing',7); -- tabla inexistente
INSERT INTO Estudiantes VALUES (8,107,'Ing',8); -- tabla inexistente
INSERT INTO Estudiantes VALUES (9,108,'Ing',2); -- tabla inexistente
INSERT INTO Estudiantes VALUES (10,109,'Ing',1); -- tabla inexistente


------------------------------------------------------------
-- 4. FOREIGN KEY → Tutores.id_usuario REFERENCIA A TABLA INEXISTENTE "Usuario"
------------------------------------------------------------

INSERT INTO Tutores VALUES (1,200,'Expert',50,80); -- FK tabla inexistente
INSERT INTO Tutores VALUES (2,201,'Avanzado',60,90); -- tabla inexistente
INSERT INTO Tutores VALUES (3,202,'Básico',20,50); -- tabla inexistente
INSERT INTO Tutores VALUES (4,203,'10 años',40,65); -- tabla inexistente
INSERT INTO Tutores VALUES (5,204,'6 años',70,78); -- tabla inexistente
INSERT INTO Tutores VALUES (6,205,'2 años',10,88); -- tabla inexistente
INSERT INTO Tutores VALUES (7,206,'7 años',75,82); -- tabla inexistente
INSERT INTO Tutores VALUES (8,207,'8 años',90,95); -- tabla inexistente
INSERT INTO Tutores VALUES (9,208,'9 años',95,99); -- tabla inexistente
INSERT INTO Tutores VALUES (10,209,'5 años',60,60); -- tabla inexistente


------------------------------------------------------------
-- 5. CHECK → Tarifas negativas (ck_tutor_tarifa)
------------------------------------------------------------

INSERT INTO Tutores VALUES (20,1,'Expert',-1,80); -- tarifa negativa
INSERT INTO Tutores VALUES (21,1,'Expert',-10,80); -- tarifa negativa
INSERT INTO Tutores VALUES (22,1,'Expert',-5,80); -- tarifa negativa
INSERT INTO Tutores VALUES (23,1,'Expert',-100,80); -- tarifa negativa
INSERT INTO Tutores VALUES (24,1,'Expert',-0.1,80); -- tarifa negativa
INSERT INTO Tutores VALUES (25,1,'Expert',-999,80); -- tarifa negativa
INSERT INTO Tutores VALUES (26,1,'Expert',-40,80); -- tarifa negativa
INSERT INTO Tutores VALUES (27,1,'Expert',-22,80); -- tarifa negativa
INSERT INTO Tutores VALUES (28,1,'Expert',-3,80); -- tarifa negativa
INSERT INTO Tutores VALUES (29,1,'Expert',-14,80); -- tarifa negativa


------------------------------------------------------------
-- 6. CHECK → calificacion_promedio FUERA DE 0–100
------------------------------------------------------------

INSERT INTO Tutores VALUES (30,1,'Exp',50,101); -- >100
INSERT INTO Tutores VALUES (31,1,'Exp',60,150); -- >100
INSERT INTO Tutores VALUES (32,1,'Exp',10,120); -- >100
INSERT INTO Tutores VALUES (33,1,'Exp',10,-1);  -- <0
INSERT INTO Tutores VALUES (34,1,'Exp',10,-5);  -- <0
INSERT INTO Tutores VALUES (35,1,'Exp',10,-100); -- <0
INSERT INTO Tutores VALUES (36,1,'Exp',10,200); -- >100
INSERT INTO Tutores VALUES (37,1,'Exp',10,999); -- >100
INSERT INTO Tutores VALUES (38,1,'Exp',10,300); -- >100
INSERT INTO Tutores VALUES (39,1,'Exp',10,-10); -- <0


------------------------------------------------------------
-- 7. CHECK → Reserva.estado inválido
------------------------------------------------------------

INSERT INTO Reservas VALUES (1,1,1,1,SYSDATE,'Pendiente'); -- estado inválido
INSERT INTO Reservas VALUES (2,1,1,1,SYSDATE,'Procesando'); -- inválido
INSERT INTO Reservas VALUES (3,1,1,1,SYSDATE,'OK'); -- inválido
INSERT INTO Reservas VALUES (4,1,1,1,SYSDATE,'Error'); -- inválido
INSERT INTO Reservas VALUES (5,1,1,1,SYSDATE,'Fallo'); -- inválido
INSERT INTO Reservas VALUES (6,1,1,1,SYSDATE,'Aprobada'); -- inválido
INSERT INTO Reservas VALUES (7,1,1,1,SYSDATE,'Negada'); -- inválido
INSERT INTO Reservas VALUES (8,1,1,1,SYSDATE,'Nada'); -- inválido
INSERT INTO Reservas VALUES (9,1,1,1,SYSDATE,'X'); -- inválido
INSERT INTO Reservas VALUES (10,1,1,1,SYSDATE,' '); -- inválido


------------------------------------------------------------
-- 8. CHECK → Sesion.estado inválido
------------------------------------------------------------

INSERT INTO Sesiones VALUES (1,1,SYSDATE,SYSDATE,'Invalido'); -- no permitido
INSERT INTO Sesiones VALUES (2,1,SYSDATE,SYSDATE,'Listo'); -- no permitido
INSERT INTO Sesiones VALUES (3,1,SYSDATE,SYSDATE,'Stop'); -- no permitido
INSERT INTO Sesiones VALUES (4,1,SYSDATE,SYSDATE,'On'); -- no permitido
INSERT INTO Sesiones VALUES (5,1,SYSDATE,SYSDATE,'Off'); -- no permitido
INSERT INTO Sesiones VALUES (6,1,SYSDATE,SYSDATE,'Cancel'); -- no permitido
INSERT INTO Sesiones VALUES (7,1,SYSDATE,SYSDATE,'Terminado'); -- no permitido
INSERT INTO Sesiones VALUES (8,1,SYSDATE,SYSDATE,'None'); -- no permitido
INSERT INTO Sesiones VALUES (9,1,SYSDATE,SYSDATE,'Fake'); -- no permitido
INSERT INTO Sesiones VALUES (10,1,SYSDATE,SYSDATE,'X'); -- no permitido


------------------------------------------------------------
-- 9. CHECK → Pago.estado inválido
------------------------------------------------------------

INSERT INTO Pagos VALUES (1,1,10,SYSDATE,'Enviado'); -- no permitido
INSERT INTO Pagos VALUES (2,1,10,SYSDATE,'Ok'); -- no permitido
INSERT INTO Pagos VALUES (3,1,10,SYSDATE,'Listo'); -- no permitido
INSERT INTO Pagos VALUES (4,1,10,SYSDATE,'Error'); -- no permitido
INSERT INTO Pagos VALUES (5,1,10,SYSDATE,'Fallo'); -- no permitido
INSERT INTO Pagos VALUES (6,1,10,SYSDATE,'Pago'); -- no permitido
INSERT INTO Pagos VALUES (7,1,10,SYSDATE,'Completado'); -- no permitido
INSERT INTO Pagos VALUES (8,1,10,SYSDATE,'Negado'); -- no permitido
INSERT INTO Pagos VALUES (9,1,10,SYSDATE,'X'); -- no permitido
INSERT INTO Pagos VALUES (10,1,10,SYSDATE,' '); -- no permitido


------------------------------------------------------------
-- 10. FOREIGN KEY → Reservas referencing tablas inexistentes (Tutor, Estudiante, Materia)
------------------------------------------------------------

INSERT INTO Reservas VALUES (20,999,999,999,SYSDATE,'Confirmada'); -- Todas FK fallan
INSERT INTO Reservas VALUES (21,500,500,500,SYSDATE,'Confirmada'); -- fk estudiante no existe
INSERT INTO Reservas VALUES (22,1,500,500,SYSDATE,'Confirmada'); -- fk tutor no existe
INSERT INTO Reservas VALUES (23,1,1,500,SYSDATE,'Confirmada'); -- fk materia no existe
INSERT INTO Reservas VALUES (24,200,1,1,SYSDATE,'Confirmada'); -- estudiante inexistente
INSERT INTO Reservas VALUES (25,300,200,1,SYSDATE,'Confirmada'); -- estudiante y tutor inexistentes
INSERT INTO Reservas VALUES (26,400,1,200,SYSDATE,'Confirmada'); -- estudiante y materia inexistentes
INSERT INTO Reservas VALUES (27,1,400,200,SYSDATE,'Confirmada'); -- tutor y materia inexistentes
INSERT INTO Reservas VALUES (28,999,1,1,SYSDATE,'Confirmada'); -- estudiante inexistente
INSERT INTO Reservas VALUES (29,1,999,1,SYSDATE,'Confirmada'); -- tutor inexistente

----------------------------------------------------------------
-- Eliminacion 
----------------------------------------------------------------
-- Eliminación de datos

DELETE FROM Resenias;
DELETE FROM Pagos;
DELETE FROM Sesiones;
DELETE FROM Reservas;
DELETE FROM Materias;
DELETE FROM Especialidades;
DELETE FROM Disponibilidades;
DELETE FROM Tutores;
DELETE FROM Estudiantes;
DELETE FROM Usuarios;

-- Eliminación de tablas en orden correcto

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Resenia CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE Pago CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE Sesion CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE Reserva CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE Materia CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE Especialidad CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE Disponibilidad CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE Tutor CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE Estudiante CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE Usuario CASCADE CONSTRAINTS';
END;
/

-------------------------------------------------------------
-- Consultas
-------------------------------------------------------------

-------------------------------------------------------------
-- Operativas
-------------------------------------------------------------

-- 1. Listar todos los usuarios
SELECT * FROM Usuarios;

-- 2. Listar tutores con su experiencia
SELECT nombre, experiencia
FROM Tutores t
JOIN Usuarios u ON t.id_usuario = u.id_usuario;

-- 3. Consultar correos de estudiantes
SELECT u.nombre, u.correo
FROM Estudiantes e
JOIN Usuarios u ON u.id_usuario = e.id_usuario;

-- 4. Tutores con calificación mayor a 80
SELECT u.nombre, t.calificacion_promedio
FROM Tutores t
JOIN Usuarios u ON u.id_usuario = t.id_usuario
WHERE calificacion_promedio > 80;

-- 5. Materias con su especialidad
SELECT m.nombre AS materia, e.nombre AS especialidad
FROM Materias m
JOIN Especialidades e ON m.id_especialidad = e.id_especialidad;

-- 6. Disponibilidad de un tutor específico
SELECT u.nombre, d.fecha, d.hora_inicio, d.hora_fin
FROM Disponibilidades d
JOIN Tutores t ON d.id_tutor = t.id_tutor
JOIN Usuarios u ON t.id_usuario = u.id_usuario
WHERE t.id_tutor = 1;

-- 7. Reservas con sus estudiantes
SELECT r.id_reserva, u.nombre AS estudiante, r.estado
FROM Reservas r
JOIN Estudiantes e ON r.id_estudiante = e.id_estudiante
JOIN Usuarios u ON u.id_usuario = e.id_usuario;

-- 8. Sesiones realizadas en una fecha
SELECT *
FROM Sesiones
WHERE TRUNC(fecha_inicio) = TRUNC(SYSDATE);

-- 9. Pagos realizados
SELECT id_pago, monto, fecha_pago
FROM Pagos
WHERE estado = 'Pagado';

-- 10. Reseñas de un estudiante
SELECT r.id_resenia, r.calificacion, r.comentario
FROM Resenias r
JOIN Reservas re ON r.id_reserva = re.id_reserva
JOIN Estudiantes e ON re.id_estudiante = e.id_estudiante
WHERE e.id_estudiante = 1;

-- 11. Consultar disponibilidad por fecha
SELECT *
FROM Disponibilidades
WHERE fecha = TO_DATE('2025-01-01','YYYY-MM-DD');

-- 12. Materias de una especialidad
SELECT nombre
FROM Materias
WHERE id_especialidad = 1;

-- 13. Buscar usuario por rol
SELECT nombre, correo
FROM Usuarios
WHERE rol = 'Tutor';

-- 14. Reservas confirmadas
SELECT *
FROM Reservas
WHERE estado = 'Confirmada';

-- 15. Sesiones activas
SELECT *
FROM Sesiones
WHERE estado = 'En curso';

-- 16. Pagos pendientes
SELECT *
FROM Pagos
WHERE estado = 'En espera';

-- 17. Consultar tutor por nombre
SELECT t.id_tutor, u.nombre
FROM Tutores t
JOIN Usuarios u ON t.id_usuario = u.id_usuario
WHERE u.nombre LIKE '%a%';

-- 18. Estudiantes por semestre
SELECT nombre, semestre
FROM Estudiantes e
JOIN Usuarios u ON e.id_usuario = u.id_usuario
WHERE semestre = 3;

-- 19. Disponibilidad activa
SELECT *
FROM Disponibilidades
WHERE estado = 'Disponible';

-- 20. Reseñas con mala calificación
SELECT *
FROM Resenias
WHERE calificacion < 3;

-------------------------------------------------------------
-- Gerenciales
-------------------------------------------------------------

-- 1. Número de usuarios por rol
SELECT rol, COUNT(*) AS total
FROM Usuarios
GROUP BY rol;

-- 2. Promedio de calificación de todos los tutores
SELECT AVG(calificacion_promedio) AS promedio_general
FROM Tutores;

-- 3. Estadísticas de reservas por estado
SELECT estado, COUNT(*) AS total
FROM Reservas
GROUP BY estado;

-- 4. Total de pagos por mes
SELECT TO_CHAR(fecha_pago, 'YYYY-MM'), SUM(monto) AS total_pagado
FROM Pagos
GROUP BY TO_CHAR(fecha_pago, 'YYYY-MM');

-- 5. Ranking de tutores por calificación
SELECT u.nombre, t.calificacion_promedio
FROM Tutores t
JOIN Usuarios u ON t.id_usuario = u.id_usuario
ORDER BY calificacion_promedio DESC;

-- 6. Cantidad de sesiones realizadas por tutor
SELECT u.nombre, COUNT(*) AS sesiones_realizadas
FROM Sesiones s
JOIN Reservas r ON s.id_reserva = r.id_reserva
JOIN Tutores t ON r.id_tutor = t.id_tutor
JOIN Usuarios u ON t.id_usuario = u.id_usuario
GROUP BY u.nombre;

-- 7. Estudiantes que más reservas realizan
SELECT u.nombre, COUNT(*) AS total_reservas
FROM Reservas r
JOIN Estudiantes e ON r.id_estudiante = e.id_estudiante
JOIN Usuarios u ON e.id_usuario = u.id_usuario
GROUP BY u.nombre
ORDER BY total_reservas DESC;

-- 8. Materias más reservadas
SELECT m.nombre, COUNT(*) AS veces_reservada
FROM Reservas r
JOIN Materias m ON r.id_materia = m.id_materia
GROUP BY m.nombre
ORDER BY veces_reservada DESC;

-- 9. Ingresos totales del sistema
SELECT SUM(monto) AS ingresos_totales
FROM Pagos
WHERE estado = 'Pagado';

-- 10. Ingresos por tutor
SELECT u.nombre, SUM(p.monto) AS ingresos
FROM Pagos p
JOIN Sesiones s ON p.id_sesion = s.id_sesion
JOIN Reservas r ON s.id_reserva = r.id_reserva
JOIN Tutores t ON r.id_tutor = t.id_tutor
JOIN Usuarios u ON t.id_usuario = u.id_usuario
GROUP BY u.nombre;

-- 11. Horas totales impartidas por tutor
SELECT u.nombre, SUM(EXTRACT(HOUR FROM (fecha_fin - fecha_inicio))) AS horas
FROM Sesiones s
JOIN Reservas r ON s.id_reserva = r.id_reserva
JOIN Tutores t ON r.id_tutor = t.id_tutor
JOIN Usuarios u ON t.id_usuario = u.id_usuario
GROUP BY u.nombre;

-- 12. Media de tarifa por especialidad
SELECT e.nombre AS especialidad, AVG(t.tarifa_hora) AS tarifa_promedio
FROM Tutores t
JOIN Especialidades e ON e.id_especialidad = e.id_especialidad
GROUP BY e.nombre;

-- 13. Top 5 tutores más reservados
SELECT u.nombre, COUNT(*) AS reservas
FROM Reservas r
JOIN Tutores t ON r.id_tutor = t.id_tutor
JOIN Usuarios u ON t.id_usuario = u.id_usuario
GROUP BY u.nombre
ORDER BY reservas DESC
FETCH FIRST 5 ROWS ONLY;

-- 14. Mes con más sesiones
SELECT TO_CHAR(fecha_inicio,'YYYY-MM') AS mes, COUNT(*) AS total
FROM Sesiones
GROUP BY TO_CHAR(fecha_inicio,'YYYY-MM')
ORDER BY total DESC;

-- 15. Promedio de calificación por tutor
SELECT u.nombre, AVG(r.calificacion) AS promedio_calificacion
FROM Resenias r
JOIN Reservas rs ON rs.id_reserva = r.id_reserva
JOIN Tutores t ON rs.id_tutor = t.id_tutor
JOIN Usuarios u ON t.id_usuario = u.id_usuario
GROUP BY u.nombre;

-- 16. Total de estudiantes por carrera
SELECT carrera, COUNT(*) AS total
FROM Estudiantes
GROUP BY carrera;

-- 17. Semestre promedio de los estudiantes
SELECT AVG(semestre) AS semestre_promedio
FROM Estudiantes;

-- 18. Cantidad de reservas por materia y mes
SELECT m.nombre AS materia, TO_CHAR(r.fecha_reserva,'YYYY-MM') AS mes, COUNT(*) AS cantidad
FROM Reservas r
JOIN Materias m ON r.id_materia = m.id_materia
GROUP BY m.nombre, TO_CHAR(r.fecha_reserva,'YYYY-MM');

-- 19. Tutores con más ingresos que el promedio
SELECT u.nombre, SUM(p.monto) AS total
FROM Pagos p
JOIN Sesiones s ON p.id_sesion = s.id_sesion
JOIN Reservas r ON r.id_reserva = s.id_reserva
JOIN Tutores t ON r.id_tutor = t.id_tutor
JOIN Usuarios u ON t.id_usuario = u.id_usuario
GROUP BY u.nombre
HAVING SUM(p.monto) > (
    SELECT AVG(monto) FROM Pagos WHERE estado='Pagado'
);

-- 20. Porcentaje de reservas canceladas
SELECT 
    (SELECT COUNT(*) FROM Reservas WHERE estado='Cancelada') * 100.0 /
    (SELECT COUNT(*) FROM Reservas) AS porcentaje_canceladas
FROM dual;

-------------------------------------------------------------
--SECCIÓN VERDE: PROCEDIMENTALES Y PRUEBAS(CORREGIR TODO LO VERDE)
-------------------------------------------------------------

-------------------------------------------------------------
-- TUPLAS
-------------------------------------------------------------

CREATE SEQUENCE seq_usuario START WITH 3 INCREMENT BY 1;
CREATE SEQUENCE seq_estudiante START WITH 2 INCREMENT BY 1;
CREATE SEQUENCE seq_tutor START WITH 2 INCREMENT BY 1;
CREATE SEQUENCE seq_disponibilidad START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_especialidad START WITH 2 INCREMENT BY 1;
CREATE SEQUENCE seq_materia START WITH 2 INCREMENT BY 1;
CREATE SEQUENCE seq_reserva START WITH 2 INCREMENT BY 1;
CREATE SEQUENCE seq_sesion START WITH 2 INCREMENT BY 1;
CREATE SEQUENCE seq_pago START WITH 2 INCREMENT BY 1;
CREATE SEQUENCE seq_resenia START WITH 2 INCREMENT BY 1;


-------------------------------------------------------------
-- ACCIONES
-------------------------------------------------------------

-- Procedimiento para registrar usuarios

CREATE OR REPLACE PROCEDURE sp_registrar_usuario(
    p_nombre IN VARCHAR2,
    p_correo IN VARCHAR2,
    p_contrasena IN VARCHAR2,
    p_rol IN VARCHAR2
) AS
BEGIN
    INSERT INTO Usuario (id_usuario, nombre, correo, contrasena, rol)
    VALUES (seq_usuario.NEXTVAL, p_nombre, p_correo, p_contrasena, p_rol);
    COMMIT;
END;
/

-- Procedimiento para crear una reserva

CREATE OR REPLACE PROCEDURE sp_crear_reserva(
    p_id_estudiante IN INT,
    p_id_tutor IN INT,
    p_id_materia IN INT
) AS
BEGIN
    INSERT INTO Reserva (id_reserva, id_estudiante, id_tutor, id_materia, fecha_reserva, estado)
    VALUES (seq_reserva.NEXTVAL, p_id_estudiante, p_id_tutor, p_id_materia, SYSDATE, 'En espera');
    COMMIT;
END;
/

-- Función para calcular las ganancias totales de un tutor

CREATE OR REPLACE FUNCTION fn_ganancia_tutor(p_id_tutor INT)
RETURN NUMBER IS
    v_total NUMBER;
BEGIN
    SELECT NVL(SUM(p.monto), 0)
    INTO v_total
    FROM Pago p
    JOIN Sesion s ON p.id_sesion = s.id_sesion
    JOIN Reserva r ON s.id_reserva = r.id_reserva
    WHERE r.id_tutor = p_id_tutor;
    RETURN v_total;
END;
/

-------------------------------------------------------------
-- DISPARADORES
-------------------------------------------------------------

-- Trigger para asignar ID automático a usuarios

CREATE OR REPLACE TRIGGER trg_usuario_autoinc
BEFORE INSERT ON Usuario
FOR EACH ROW
BEGIN
    :NEW.id_usuario := seq_usuario.NEXTVAL;
END;
/

-- Trigger para asignar ID automático a estudiantes

CREATE OR REPLACE TRIGGER trg_estudiante_autoinc
BEFORE INSERT ON Estudiante
FOR EACH ROW
BEGIN
    :NEW.id_estudiante := seq_estudiante.NEXTVAL;
END;
/

-- Trigger para asignar ID automático a tutores

CREATE OR REPLACE TRIGGER trg_tutor_autoinc
BEFORE INSERT ON Tutor
FOR EACH ROW
BEGIN
    :NEW.id_tutor := seq_tutor.NEXTVAL;
END;
/

-- Trigger que impide eliminar usuarios con reservas activas

CREATE OR REPLACE TRIGGER trg_no_borrar_con_reservas
BEFORE DELETE ON Usuario
FOR EACH ROW
DECLARE
    v_count INT;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM Reserva r
    JOIN Estudiante e ON r.id_estudiante = e.id_estudiante
    WHERE e.id_usuario = :OLD.id_usuario;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'No se puede eliminar el usuario: tiene reservas asociadas.');
    END IF;
END;
/

-------------------------------------------------------------
-- TUPLASOK
-- (Inserciones válidas)
-------------------------------------------------------------

INSERT INTO Usuario VALUES (3, 'Carlos Ruiz', 'carlos@correo.com', 'abc123', 'E');
INSERT INTO Estudiante VALUES (2, 3, 'Ingeniería Electrónica', 3);
INSERT INTO Tutor VALUES (2, 2, '5 años de experiencia en física', 80000, 95);
INSERT INTO Materia VALUES (2, 'Álgebra Lineal', 1);
INSERT INTO Reserva VALUES (2, 1, 2, 2, SYSDATE, 'En espera');
INSERT INTO Sesion VALUES (2, 2, SYSDATE, SYSDATE + 1/24, 'Programada');
INSERT INTO Pago VALUES (2, 2, 80000, SYSDATE, 'Pagado');
INSERT INTO Resenia VALUES (2, 2, 100, 'Muy buena clase', SYSDATE);
COMMIT;

-------------------------------------------------------------
-- TUPLASNOOK
-- (Inserciones inválidas que deben generar error)
-------------------------------------------------------------

-- Intentar insertar un correo duplicado

INSERT INTO Usuario VALUES (4, 'Pedro', 'carlos@correo.com', 'pass', 'E');

-- Intentar insertar un tutor con tarifa negativa

INSERT INTO Tutor VALUES (3, 2, 'Sin experiencia', -10000, 80);

-- Intentar insertar una reserva con estado no válido

INSERT INTO Reserva VALUES (3, 1, 1, 1, SYSDATE, 'Pendiente');


-------------------------------------------------------------
-- ACCIONESOK
-- (Ejecución de procedimientos válidos)
-------------------------------------------------------------

BEGIN
    sp_registrar_usuario('Ana Torres', 'ana@correo.com', 'clave', 'T');
END;
/

BEGIN
    sp_crear_reserva(1, 1, 1);
END;
/

SELECT fn_ganancia_tutor(1) AS GananciaTutor FROM DUAL;


-------------------------------------------------------------
-- DISPARADORESOK
-- (Comprobación de triggers activos)
-------------------------------------------------------------

-- trg_usuario_autoinc

INSERT INTO Usuario (nombre, correo, contrasena, rol)
VALUES ('Carlos Pérez', 'carlos@uni.edu', '1234', 'Estudiante');

SELECT * FROM Usuario ORDER BY id_usuario DESC;

-- Varios usuarios para ver incremento continuo

INSERT INTO Usuario (nombre, correo, contrasena, rol)
VALUES ('Ana Ríos', 'ana.rios@correo.com', 'pass1', 'Tutor');

INSERT INTO Usuario (nombre, correo, contrasena, rol)
VALUES ('Miguel Torres', 'miguel.t@correo.com', 'pass2', 'Administrador');

SELECT id_usuario, nombre
FROM Usuario
ORDER BY id_usuario DESC;

-- ignorando el id

INSERT INTO Usuario (id_usuario, nombre, correo, contrasena, rol)
VALUES (NULL, 'Laura Molina', 'laura@correo.com', 'claveX', 'Estudiante');

SELECT * FROM Usuario
WHERE nombre = 'Laura Molina';


-- trg_estudiante_autoinc

INSERT INTO Usuario (nombre, correo, contrasena, rol)
VALUES ('Carlos Pérez', 'carlos@uni.edu', '1234', 'Estudiante');

SELECT * FROM Usuario ORDER BY id_usuario DESC;

-- Ingresar 2 estudiantes al mismo tiempo(asegurarse que el id_usuario1 existe)


INSERT INTO Estudiante (programa, semestre, id_usuario)
VALUES ('Derecho', 2, 1);

INSERT INTO Estudiante (programa, semestre, id_usuario)
VALUES ('Medicina', 1, 1);

SELECT id_estudiante, programa
FROM Estudiante
ORDER BY id_estudiante DESC;

-- Valores null

INSERT INTO Estudiante (programa, semestre, id_usuario)
VALUES ('Arquitectura', 5, (SELECT MIN(id_usuario) FROM Usuario));

SELECT *
FROM Estudiante
WHERE programa = 'Arquitectura';


-- trg_tutor_autoinc

INSERT INTO Tutor (especialidad, id_usuario)
VALUES ('Matemáticas', 1); 

SELECT * FROM Tutor ORDER BY id_tutor DESC;

-- Continuidad secuencias

INSERT INTO Tutor (especialidad, id_usuario)
VALUES ('Física', 1);

INSERT INTO Tutor (especialidad, id_usuario)
VALUES ('Biología', 1);

SELECT id_tutor, especialidad
FROM Tutor
ORDER BY id_tutor DESC;


-- Insert usuario diferente

-- Asegúrate de que existan varios usuarios
INSERT INTO Tutor (especialidad, id_usuario)
VALUES ('Química', (SELECT MIN(id_usuario) FROM Usuario));

SELECT *
FROM Tutor
WHERE especialidad = 'Química';

-- trg_no_borrar_con_reservas

INSERT INTO Usuario (nombre, correo, contrasena, rol)
VALUES ('Juan Gomez', 'juan@correo.com', 'abcd', 'Estudiante');

INSERT INTO Estudiante (programa, semestre, id_usuario)
VALUES ('Sistemas', 3, (SELECT MAX(id_usuario) FROM Usuario));

INSERT INTO Reserva (id_estudiante, fecha, estado)
VALUES (
    (SELECT MAX(id_estudiante) FROM Estudiante),
    SYSDATE,
    'Activa'
);

DELETE FROM Usuario
WHERE id_usuario = (SELECT MAX(id_usuario) FROM Usuario);

-- trg_no_borrar_con_reservas (si borra)

INSERT INTO Usuario (nombre, correo, contrasena, rol)
VALUES ('Usuario Sin Reservas', 'libre@correo.com', 'xyz', 'Estudiante');

SELECT MAX(id_usuario) FROM Usuario;


-------------------------------------------------------------
-- DISPARADORESNOOK
-------------------------------------------------------------

-- Intentar eliminar usuario con reservas activas

DELETE FROM Usuario WHERE id_usuario = 1;

-- Intentar insertar un tutor con tarifa excesiva (trigger experimental)

ALTER TRIGGER trg_validar_tarifa ENABLE;
INSERT INTO Tutor VALUES (5, 2, 'Experto en programación', 300000, 90);
ALTER TRIGGER trg_validar_tarifa DISABLE;


-------------------------------------------------------------
-- XDISPARADORES
-- (Eliminación de triggers existentes)
-------------------------------------------------------------

BEGIN
    EXECUTE IMMEDIATE 'DROP TRIGGER trg_usuario_autoinc';
    EXECUTE IMMEDIATE 'DROP TRIGGER trg_estudiante_autoinc';
    EXECUTE IMMEDIATE 'DROP TRIGGER trg_tutor_autoinc';
    EXECUTE IMMEDIATE 'DROP TRIGGER trg_no_borrar_con_reservas';
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Algunos triggers no existían o ya fueron eliminados.');
END;
/

-- ON DELETE CASCADE para Estudiante.id_usuario

ALTER TABLE Estudiante
ADD CONSTRAINT fk_estudiante_usuario
FOREIGN KEY (id_usuario)
REFERENCES Usuario(id_usuario)
ON DELETE CASCADE;

-- ON DELETE SET NULL para Tutor.id_usuario

ALTER TABLE Curso
ADD CONSTRAINT fk_curso_tutor
FOREIGN KEY (id_tutor)
REFERENCES Tutor(id_tutor)
ON DELETE SET NULL;

-- Sin acción específica para Estudiante.id_usuario

ALTER TABLE Estudiante
ADD CONSTRAINT fk_estudiante_usuario
FOREIGN KEY (id_usuario)
REFERENCES Usuario(id_usuario);

-------------------------------------------------------------
-- PRUEBAS DE ACEPTACIÓN (FUNCIONALES)
-------------------------------------------------------------

-- CONSULTAR TUTORES MEJOR CALIFICADOS (Top 10)
SELECT *
FROM (
    SELECT 
        u.nombre AS tutor,
        t.calificacion_promedio,
        COUNT(s.id_sesion) AS sesiones_realizadas
    FROM Tutores t
    JOIN Usuarios u ON u.id_usuario = t.id_usuario
    JOIN Reservas r ON r.id_tutor = t.id_tutor
    JOIN Sesiones s ON s.id_reserva = r.id_reserva
    JOIN Resenias re ON re.id_reserva = r.id_reserva
    GROUP BY u.nombre, t.calificacion_promedio
    HAVING COUNT(s.id_sesion) >= 5
    ORDER BY t.calificacion_promedio DESC, COUNT(s.id_sesion) DESC
)
WHERE ROWNUM <= 10;

-- PRUEBA 1: Debe retornar los 10 tutores mejor calificados
SELECT COUNT(*) AS total_tutores
FROM (
    SELECT u.nombre
    FROM Tutores t
    JOIN Usuarios u ON t.id_usuario = u.id_usuario
    JOIN Reservas r ON r.id_tutor = t.id_tutor
    JOIN Sesiones s ON s.id_reserva = r.id_reserva
    GROUP BY u.nombre, t.calificacion_promedio
    HAVING COUNT(*) >= 5
) WHERE ROWNUM <= 10;

-- PRUEBA 2: Verificar ordenamiento secundario por sesiones
SELECT *
FROM (
    SELECT u.nombre, t.calificacion_promedio, COUNT(*) AS sesiones
    FROM Tutores t
    JOIN Usuarios u ON t.id_usuario = u.id_usuario
    JOIN Reservas r ON r.id_tutor = t.id_tutor
    JOIN Sesiones s ON s.id_reserva = r.id_reserva
    GROUP BY u.nombre, t.calificacion_promedio
) ORDER BY calificacion_promedio DESC, sesiones DESC;

-- PRUEBA 3: Ranking de tutores enseñando "Álgebra Lineal"
SELECT u.nombre, t.calificacion_promedio, COUNT(*) AS sesiones
FROM Tutores t
JOIN Usuarios u ON t.id_usuario = u.id_usuario
JOIN Reservas r ON r.id_tutor = t.id_tutor
JOIN Materias m ON m.id_materia = r.id_materia
JOIN Sesiones s ON s.id_reserva = r.id_reserva
WHERE m.nombre = 'Álgebra Lineal'
GROUP BY u.nombre, t.calificacion_promedio
ORDER BY t.calificacion_promedio DESC;

-- PRUEBA 4: Tutores con menos de 5 sesiones NO deben aparecer
SELECT COUNT(*)
FROM (
    SELECT t.id_tutor
    FROM Tutores t
    JOIN Reservas r ON r.id_tutor = t.id_tutor
    JOIN Sesiones s ON s.id_reserva = r.id_reserva
    GROUP BY t.id_tutor
    HAVING COUNT(*) < 5
)
WHERE id_tutor IN (
    /* ranking real */
    SELECT id_tutor
    FROM (
        SELECT t.id_tutor, COUNT(*) AS sesiones
        FROM Tutores t
        JOIN Reservas r ON r.id_tutor = t.id_tutor
        JOIN Sesiones s ON s.id_reserva = r.id_reserva
        GROUP BY t.id_tutor
    ) WHERE sesiones >= 5
);

-- CONSULTAR MATERIAS CON MAYOR DEMANDA
SELECT m.nombre AS materia,
       COUNT(*) AS reservas_totales,
       SUM(CASE WHEN s.estado = 'Finalizada' THEN 1 ELSE 0 END) AS sesiones_completadas,
       ROUND((SUM(CASE WHEN s.estado = 'Finalizada' THEN 1 ELSE 0 END) / COUNT(*)) * 100,2) AS tasa_conversion,
       AVG(p.monto) AS precio_promedio,
       SUM(p.monto) AS ingresos_totales,
       COUNT(DISTINCT t.id_tutor) AS tutores_activos
FROM Reservas r
JOIN Materias m ON r.id_materia = m.id_materia
JOIN Sesiones s ON s.id_reserva = r.id_reserva
JOIN Pagos p ON p.id_sesion = s.id_sesion
JOIN Tutores t ON t.id_tutor = r.id_tutor
GROUP BY m.nombre
ORDER BY reservas_totales DESC;

-- PRUEBA 1: Debe listar todas las materias ordenadas por número de reservas
SELECT nombre, reservas
FROM (
    SELECT m.nombre, COUNT(*) AS reservas
    FROM Reservas r
    JOIN Materias m ON r.id_materia = m.id_materia
    GROUP BY m.nombre
    ORDER BY reservas DESC
);

-- PRUEBA 2: Materias sin reservas deben aparecer con 0
SELECT m.nombre
FROM Materias m
LEFT JOIN Reservas r ON m.id_materia = r.id_materia
WHERE r.id_reserva IS NULL;

-- PRUEBA 3: Validar cálculo de tasa de conversión por materia
SELECT m.nombre,
       COUNT(*) AS reservas,
       SUM(CASE WHEN s.estado = 'Finalizada' THEN 1 ELSE 0 END) AS finalizadas,
       ROUND((SUM(CASE WHEN s.estado = 'Finalizada' THEN 1 ELSE 0 END) / COUNT(*)) * 100,2) AS tasa_ok
FROM Reservas r
JOIN Materias m ON r.id_materia = m.id_materia
JOIN Sesiones s ON s.id_reserva = r.id_reserva
GROUP BY m.nombre;

-- PRUEBA 4: Verificar el precio promedio por materia
SELECT m.nombre, AVG(p.monto) AS precio_promedio
FROM Pagos p
JOIN Sesiones s ON p.id_sesion = s.id_sesion
JOIN Reservas r ON r.id_reserva = s.id_reserva
JOIN Materias m ON m.id_materia = r.id_materia
GROUP BY m.nombre;

-- PRUEBA 5: Validar tutores activos por materia
SELECT m.nombre, COUNT(DISTINCT t.id_tutor) AS tutores_activos
FROM Reservas r
JOIN Materias m ON r.id_materia = m.id_materia
JOIN Tutores t ON t.id_tutor = r.id_tutor
GROUP BY m.nombre;

-- EXPORTAR REPORTE A CSV (puede hacerse por spool)
SPOOL reporte_materias.csv

SELECT m.nombre, COUNT(*) AS reservas
FROM Reservas r
JOIN Materias m ON r.id_materia = m.id_materia
GROUP BY m.nombre;

SPOOL OFF;


