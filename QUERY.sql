create SCHEMA ingenieria;
set search_path = ingenieria,public;

create SCHEMA "Ingenieria de Sistemas";
create SCHEMA "Ingenieria Civil";
create SCHEMA "Ingenieria Electronica";
create SCHEMA "Ingenieria Mecanica";
create SCHEMA "biblioteca";


set search_path = ingenieria,public;


CREATE TABLE Profesores (
    id_p BIGINT CHECK(id_p>0),
    nom_p VARCHAR(100) NOT NULL,
    dir_p VARCHAR(200),
    tel_p VARCHAR(10),
    profesion VARCHAR(100),
    PRIMARY KEY (id_p)
);

CREATE TABLE Carreras (
    id_carr BIGINT CHECK(id_carr>0),
    nom_carr VARCHAR(100) NOT NULL,
    reg_calif VARCHAR(50),
    creditos BIGINT NOT NULL,
    PRIMARY KEY (id_carr)
);

CREATE TABLE Asignaturas (
    cod_a BIGINT CHECK(cod_a>0),
    nom_a VARCHAR(100) NOT NULL,
    int_h BIGINT CHECK(int_h between 0 and 4)default 0,
    creditos_a BIGINT NOT NULL CHECK (creditos_a between 0 and 4)default 0,
    PRIMARY KEY (cod_a)
);

CREATE TABLE Imparte (
    grupo BIGINT CHECK(grupo>0),
    id_p BIGINT NOT NULL,
    cod_a BIGINT NOT NULL,
    horario VARCHAR(50),
    PRIMARY KEY (grupo,id_p,cod_a),
    FOREIGN KEY (id_p) REFERENCES Profesores(id_p),
    FOREIGN KEY (cod_a) REFERENCES Asignaturas(cod_a)
);

CREATE TABLE Inscribe (
    cod_e BIGINT NOT NULL,
    grupo BIGINT NOT NULL,
    cod_a BIGINT NOT NULL,
    id_p BIGINT NOT NULL,
    n1 FLOAT CHECK (n1 BETWEEN 0 AND 5) DEFAULT 0,
    n2 FLOAT CHECK (n2 BETWEEN 0 AND 5) DEFAULT 0,
    n3 FLOAT CHECK (n3 BETWEEN 0 AND 5) DEFAULT 0,
    UNIQUE(cod_e, cod_a),
    PRIMARY KEY (cod_e, grupo, cod_a, id_p),
    FOREIGN KEY (grupo, id_p, cod_a) REFERENCES Imparte(grupo, id_p ,cod_a)
);


CREATE TABLE Referencia (
    cod_a BIGINT NOT NULL,
    isbn BIGINT NOT NULL,
    PRIMARY KEY (cod_a, isbn),
    FOREIGN KEY (cod_a) REFERENCES Asignaturas(cod_a)
);

set search_path = "Ingenieria de Sistemas",public;

CREATE TABLE Estudiantes (
    cod_e BIGINT CHECK(cod_e>0),
    id_carr BIGINT,
    nom_e VARCHAR(100) NOT NULL,
    dir_e VARCHAR(200),
    tel_e VARCHAR(10),
    fech_nac DATE,
    PRIMARY KEY (cod_e),
    FOREIGN KEY (id_carr) REFERENCES Ingenieria.Carreras(id_carr) 
);

set search_path = "Ingenieria Civil",public;
CREATE TABLE Estudiantes (
    cod_e BIGINT CHECK(cod_e>0),
    id_carr BIGINT NOT NULL,
    nom_e VARCHAR(100) NOT NULL,
    dir_e VARCHAR(200),
    tel_e VARCHAR(10),
    fech_nac DATE,
    PRIMARY KEY (cod_e),
    FOREIGN KEY (id_carr) REFERENCES Ingenieria.Carreras(id_carr) 
);

set search_path = "Ingenieria Electronica",public;
CREATE TABLE Estudiantes (
    cod_e BIGINT CHECK(cod_e>0),
    id_carr BIGINT NOT NULL,
    nom_e VARCHAR(100) NOT NULL,
    dir_e VARCHAR(200),
    tel_e VARCHAR(10),
    fech_nac DATE,
    PRIMARY KEY (cod_e),
    FOREIGN KEY (id_carr) REFERENCES Ingenieria.Carreras(id_carr) 
);
set search_path = "Ingenieria Mecanica",public;
CREATE TABLE Estudiantes (
    cod_e BIGINT CHECK(cod_e>0),
    id_carr BIGINT NOT NULL,
    nom_e VARCHAR(100) NOT NULL,
    dir_e VARCHAR(200),
    tel_e VARCHAR(10),
    fech_nac DATE,
    PRIMARY KEY (cod_e),
    FOREIGN KEY (id_carr) REFERENCES Ingenieria.Carreras(id_carr) 
);


set search_path = biblioteca,public;


CREATE TABLE Libros (
    isbn BIGINT CHECK(isbn>0),
    titulo VARCHAR(200) NOT NULL,
    edicion VARCHAR(50),
    editorial VARCHAR(100),
    PRIMARY KEY (isbn)
);

CREATE TABLE Autores (
    id_aut BIGINT CHECK(id_aut>0),
    nom_autor VARCHAR(100) NOT NULL,
    nacionalidad VARCHAR(100),
    PRIMARY KEY (id_aut)
);
CREATE TABLE Escriben (
    isbn BIGINT NOT NULL,
    id_aut BIGINT NOT NULL,
    PRIMARY KEY (isbn,id_aut),
    
    FOREIGN KEY (isbn) REFERENCES Libros(isbn),

    FOREIGN KEY (id_aut) REFERENCES Autores(id_aut) 
);



CREATE TABLE Ejemplares (
    isbn BIGINT ,
    num_ej BIGINT CHECK(num_ej>0),
    PRIMARY KEY (isbn, num_ej),
    FOREIGN KEY (isbn) REFERENCES Libros(isbn) 
);


CREATE TABLE Presta (
    fecha_prst DATE,
    fech_dev DATE,
    cod_e BIGINT NOT NULL,
    isbn BIGINT NOT NULL,
    num_ej BIGINT NOT NULL,
    PRIMARY KEY (fecha_prst, cod_e, num_ej, isbn),
    FOREIGN KEY (isbn) REFERENCES Libros(isbn),
    FOREIGN KEY (isbn, num_ej) REFERENCES Ejemplares(isbn, num_ej)
);

-- VISTAS
select * from estudiante; 
SET search_path = ingenieria, public; 

CREATE VIEW globalestudiantes AS

SELECT 'Ingeniería de Sistemas' AS programa, cod_e, nom_e, dir_e, tel_e, fech_nac, id_carr
FROM "Ingenieria de Sistemas".estudiantes
UNION ALL
SELECT 'Ingeniería Civil' AS programa, cod_e, nom_e, dir_e, tel_e, fech_nac, id_carr
FROM "Ingenieria Civil".estudiantes
UNION ALL
SELECT 'Ingeniería Electrónica' AS programa, cod_e, nom_e, dir_e, tel_e, fech_nac, id_carr
FROM "Ingenieria Electronica".estudiantes
UNION ALL
SELECT 'Ingeniería Mecánica' AS programa, cod_e, nom_e, dir_e, tel_e, fech_nac, id_carr
FROM "Ingenieria Mecanica".estudiantes;


set search_path = ingenieria, public;



create view listado_facultad_asig as

select e.cod_e, e.nom_e, a.nom_a, a.cod_a, i.grupo
from EstudiantesGlobal e
join inscribe i on e.cod_e = i.cod_e
join asignaturas a on i.cod_a = a.cod_a;


create VIEW nombre_vista AS lo que va a ahacer la vista;


-- 2. Consultar el listado de estudiantes de la facultad con sus asignaturas y notas (listado_facultad_notas)
create view listado_facultad_notas as
select e.cod_e, e.nom_e, a.nom_a, a.cod_a, i.grupo, i.n1, i.n2, i.n3
from  EstudiantesGlobal e
join inscribe i on e.cod_e = i.cod_e
join asignaturas a on i.cod_a = a.cod_a;

-- 3. Ver la información de los libros prestados por la biblioteca (prestamos_universidad)
set search_path = biblioteca, public;
create view prestamos_universidad as
select p.fecha_prst, p.fech_dev, p.cod_e, l.titulo, l.editorial, l.isbn
from presta p
join ejemplares e on p.isbn = e.isbn and p.num_ej = e.num_ej
join libros l on p.isbn = l.isbn;

-- Vistas para el Profesor



-- 1. Consultar la lista de sus estudiantes con información de las asignaturas y las notas (lista_estudiantes)
SET search_path = ingenieria, public;
create view lista_estudiantes as
select a.cod_a, a.nom_a, i.grupo, e.cod_e, e.nom_e, i.n1, i.n2, i.n3,
    (COALESCE(i.n1, 0) * 0.35 + COALESCE(i.n2, 0) * 0.35 + COALESCE(i.n3, 0) * 0.3)::real as definitiva
from GlobalEstudiantes e
join inscribe i on e.cod_e = i.cod_e
join asignaturas a on i.cod_a = a.cod_a
where i.id_p::text = current_user;




-- 2. Consultar libros, autores y quienes los escriben (consulta_escribe)
set search_path = biblioteca, public;
create view consulta_escribe as
select l.titulo, l.isbn, a.nom_autor
from libros l
join escriben e on l.isbn = e.isbn
join autores a on e.id_aut = a.id_aut;

-- Vistas para el Estudiante

-- 1. Puede consultar sus notas (notasEstud)    
SET search_path = ingenieria, public;
create view notasEstud as
select a.cod_a, a.nom_a, i.grupo, i.n1, i.n2, i.n3,
    (COALESCE(i.n1, 0) * 0.35 + COALESCE(i.n2, 0) * 0.35 + COALESCE(i.n3, 0) * 0.3)::real as definitiva
from inscribe i
join asignaturas a on i.cod_a = a.cod_a
where i.cod_e::text = current_user;

-- 2. Puede consultar sus préstamos, incluyendo fecha de préstamo y devolución (consultar_prest_est)
SET search_path = biblioteca, public;
create view consultar_prest_est as
select p.fecha_prst, p.fech_dev, l.titulo, l.editorial
from presta p
join libros l on p.isbn = l.isbn
where p.cod_e::text = current_user;

SET search_path = ingenieria, public;
create view info_profesores as 
select *
from profesores
where id_p::text=current_user;

-------------------------------------------------------- ROLES ------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

set search_path = ingenieria, public;

-- Rol estudiantes
create role estudiantesIng;
grant usage on schema ingenieria to estudiantesIng;
grant select on ingenieria.notasEstud to estudiantesIng; -- notasEstud es una vista

-- Rol profesores
create role profesoresIng;
grant usage on schema ingenieria to profesoresIng; 
grant select, update (profesion, nom_p, dir_p, tel_p) on ingenieria.info_profesores to profesoresIng; -- infoProfesores es una vista

-------------------------------------------------------- Biblioteca -------------------------------------------------
set search_path = biblioteca, public;

create user bibliotecau with password 'bibliotecau';
grant usage on schema biblioteca to bibliotecau;
grant usage on schema ingenieria to bibliotecau;		  

GRANT SELECT ON ingenieria.GlobalEstudiantes TO bibliotecau;

GRANT SELECT ON biblioteca.presta TO bibliotecau;

GRANT USAGE ON SCHEMA biblioteca to profesoresIng;
GRANT SELECT ON biblioteca.autores TO profesoresIng;
GRANT SELECT ON biblioteca.libros TO profesoresIng;

GRANT USAGE ON SCHEMA biblioteca to estudiantesIng;
GRANT SELECT ON biblioteca.autores TO estudiantesIng;


---------------------------------------------------------------------------------------------------------------------
------------------------------------------ TRIGGERS Y PROCEDIMIENTOS ------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

set search_path = ingenieria, public;

-- Funcion para crear los usuarios de estudiantes
CREATE OR REPLACE FUNCTION crear_usuarios() RETURNS void AS
$BODY$
DECLARE f ingenieria.GlobalEstudiantes%rowtype;
DECLARE r ingenieria.profesores%rowtype;
BEGIN
	FOR f IN SELECT * FROM ingenieria.GlobalEstudiantes
	LOOP
		if (f.cod_e::text not in (select usename from pg_user)) then
			execute 'create user "'||f.cod_e||'" with password '||''''||f.cod_e||'''';
			execute 'grant estudiantesIng to "'||f.cod_e||'"'; 
		end if;
	END LOOP;
	FOR r IN SELECT * FROM ingenieria.profesores
	LOOP
		if (r.id_p::text not in (select usename from pg_user)) then
			execute 'create user "'||r.id_p||'" with password '||''''||r.id_p||'''';
			execute 'grant profesoresIng to "'||r.id_p||'"'; 
		end if;
	END LOOP;
RETURN;
END
$BODY$
LANGUAGE 'plpgsql' ;

-- Funcion que permite al profesor actualizar unicamente las notas de sus estudiantes 
create or replace function update_est() returns trigger as $update_est$
declare
begin
    update ingenieria.inscribe set 
    n1 = NEW.n1, n2 = NEW.n2, n3 = NEW.n3 
    where cod_e = OLD.cod_e and cod_a = OLD.cod_a and cod_e in (select cod_e from ingenieria.lista_estudiantes where id_p::text = current_user);
    RETURN NEW;
end;
$update_est$
language plpgsql;

-- Trigger asociado al update sobre inscribe
create trigger update_est_trg
instead of update on lista_estudiantes
for each row execute procedure update_est();
-- Validacion insert en Inscribe
CREATE OR REPLACE FUNCTION insert_inscribe() RETURNS
TRIGGER AS $insert_inscribe$
BEGIN
	IF (new.cod_e in (select cod_e from ingenieria.GlobalEstudiantes)) THEN
		RETURN NEW;
	ELSE 
		RETURN NULL;
	END IF;
END;
$insert_inscribe$ LANGUAGE plpgsql;

-- Trigger asociado al insert en la tabla inscribe
CREATE TRIGGER insert_inscribe_trg BEFORE
UPDATE OR INSERT
ON inscribe FOR EACH row
EXECUTE PROCEDURE insert_inscribe();
		

-- Ejecutar
set search_path = ingenieria, public;
select crear_usuarios();