GRANT
ALL
ON DATABASE "cidenet-db" TO postgres;

/*
drop table if exists countries cascade;

drop table if exists department cascade;

drop table if exists employees cascade;

drop table if exists identification_type cascade;

drop table if exists users_trace cascade;

drop type if exists status_user;

drop function if exists insert_employees(uuid, varchar, varchar, varchar, varchar, integer, integer, varchar, varchar,
    varchar, varchar, integer) cascade;

create table identification_type (
                                     id serial primary key ,
                                     abbreviation varchar(5) unique not null ,
                                     name varchar unique not null
);
INSERT INTO public.identification_type (id, abbreviation, name) VALUES (1, 'CC', 'Cedula de Ciudadania');
INSERT INTO public.identification_type (id, abbreviation, name) VALUES (2, 'TI', 'Tarjeta de Identidad');
INSERT INTO public.identification_type (id, abbreviation, name) VALUES (3, 'CE', 'Cedula de Extranjeria');
INSERT INTO public.identification_type (id, abbreviation, name) VALUES (4, 'P', 'Pasaporte');


create table department (
                            id serial primary key ,
                            abbreviation varchar(5) unique not null ,
                            name varchar unique not null
);
INSERT INTO public.department (id, abbreviation, name) VALUES (1, 'ADM', 'Administracion');
INSERT INTO public.department (id, abbreviation, name) VALUES (2, 'FIN', 'Financiera');
INSERT INTO public.department (id, abbreviation, name) VALUES (3, '', 'COMPRAS');
INSERT INTO public.department (id, abbreviation, name) VALUES (4, 'INF', 'Infraestructura');
INSERT INTO public.department (id, abbreviation, name) VALUES (5, 'OP', 'Operacion');
INSERT INTO public.department (id, abbreviation, name) VALUES (6, 'TH', 'Talento Humano');
INSERT INTO public.department (id, abbreviation, name) VALUES (7, 'SV', 'Servicios Varios');


create table countries
(
    id serial primary key,
    abbreviation varchar(5) unique not null ,
    name varchar unique not null,
    domain varchar unique not null
);
INSERT INTO public.countries (id, abbreviation, name, domain) VALUES (1, 'COL', 'Colombia', '@cidenet.com.co');
INSERT INTO public.countries (id, abbreviation, name, domain) VALUES (2, 'USA', 'Estados Unidos', '@cidenet.com.us');

create type status_user as enum ('enable', 'disable', 'stand-by');

create table employees
(
    id                     uuid         not null
        primary key,
    name             varchar(20)  not null,
    others_names           varchar(20),
    last_name        varchar(20)  not null,
    second_last_name       varchar(20)  not null,
    countries_id           integer
        constraint employees_countries_fk
            references countries
            on update cascade,
    identification_type_id integer
        constraint employees_identification_fk
            references identification_type
            on update cascade,
    identification_number  varchar(20)  not null,
    mail                   varchar(300) not null
        unique,
    admission              date    not null CHECK ( (admission <= current_timestamp) and (admission > current_timestamp - interval '1 month')),
    registration           timestamp    not null CHECK (registration >= admission),
    department_id          integer
        constraint employees_department_fk
            references department
            on update cascade on delete cascade,
    status                 status_user default 'enable'
);
INSERT INTO public.employees (id, name, others_names, last_name, second_last_name, countries_id, identification_type_id, identification_number, mail, admission, registration, department_id, status) VALUES ('2314cdbe-c6c2-4a16-a70b-92c149452eb1', 'Laura', 'Daniela', 'Aguado', 'Rendon', 1, 1, '00010', 'laura.daniela0@cidenet.com.co', '2022-01-03', '2022-01-12 18:08:05.000000', 4, 'enable');
INSERT INTO public.employees (id, name, others_names, last_name, second_last_name, countries_id, identification_type_id, identification_number, mail, admission, registration, department_id, status) VALUES ('a28bb51d-961a-4a09-97b8-90a847627afe', 'Andres', 'Lucca', 'Kennedy', 'Rendon', 1, 1, '1116238356', 'andres.kennedy@cidenet.com.co', '2022-01-03', '2022-01-12 18:08:05.000000', 4, 'enable');
INSERT INTO public.employees (id, name, others_names, last_name, second_last_name, countries_id, identification_type_id, identification_number, mail, admission, registration, department_id, status) VALUES ('0603848a-e623-4e60-b961-383fcb039cb1', 'Aura', '', 'Cadena', 'Rendon', 1, 1, '1116238356', 'aura.cadena@cidenet.com.co', '2022-01-03', '2022-01-12 18:08:05.000000', 4, 'enable');
INSERT INTO public.employees (id, name, others_names, last_name, second_last_name, countries_id, identification_type_id, identification_number, mail, admission, registration, department_id, status) VALUES ('4f8eec07-7bd4-4072-8f19-47b35b9be438', 'Luis', 'Lucca', 'Ocampo', 'Rendon', 2, 1, '1116238356', 'luis.ocampo@cidenet.com.us', '2022-01-03', '2022-01-12 18:08:05.000000', 4, 'enable');
INSERT INTO public.employees (id, name, others_names, last_name, second_last_name, countries_id, identification_type_id, identification_number, mail, admission, registration, department_id, status) VALUES ('68d9e5ac-a147-41e7-a94f-2562cfb951df', 'Carlos', 'Lucca', 'Mendoza', 'Rendon', 1, 1, '1116238356', 'carlos.mendoza@cidenet.com.co', '2022-01-03', '2022-01-12 18:08:05.000000', 4, 'enable');
INSERT INTO public.employees (id, name, others_names, last_name, second_last_name, countries_id, identification_type_id, identification_number, mail, admission, registration, department_id, status) VALUES ('90b37096-2518-4ade-bdc3-f25393e65124', 'Gian', '', 'Lopez', 'Rendon', 2, 1, '1116238356', 'gian.lopez@cidenet.com.us', '2022-01-03', '2022-01-12 18:08:05.000000', 4, 'enable');
INSERT INTO public.employees (id, name, others_names, last_name, second_last_name, countries_id, identification_type_id, identification_number, mail, admission, registration, department_id, status) VALUES ('03fdc57f-e9bf-47d0-a25a-255f4a7f894b', 'Gian', 'Lucca', 'Aguado', 'Rendon', 2, 1, '1116238356', 'gian.aguado@cidenet.com.us', '2022-01-03', '2022-01-12 18:08:05.000000', 4, 'enable');
INSERT INTO public.employees (id, name, others_names, last_name, second_last_name, countries_id, identification_type_id, identification_number, mail, admission, registration, department_id, status) VALUES ('60e1ec05-49c6-4944-807e-afc96d26c4bf', 'Nancy', 'Lucca', 'Parra', 'Ocampo', 1, 1, '1001', 'nancy.parra@cidenet.com.co', '2022-01-03', '2022-01-12 18:08:05.000000', 4, 'enable');
INSERT INTO public.employees (id, name, others_names, last_name, second_last_name, countries_id, identification_type_id, identification_number, mail, admission, registration, department_id, status) VALUES ('c822c1e2-247d-4bb2-83fd-daf82773afd2', 'alberto', 'alfoso', 'de la calle', 'Ruiz', 1, 1, '01', 'alberto.delacalle@cidenet.com.co', '2022-01-03', '2022-01-12 13:00:00.000000', 4, 'enable');


create table users_trace
(
    id uuid primary key,
    user_id uuid not null
        constraint employees_fk
            references employees
            on update cascade on delete cascade,
    fields jsonb not null,
    modification  timestamp not null
);

create or replace function insert_employees(
    uuid_i uuid,
    name_i varchar, --validate in  back
    others_names_i varchar, --validate in  back
    last_name_i varchar, --validate in  back
    second_last_name_i varchar, --validate in  back
    countries_id_i int,
    identification_type_id_i int,
    identification_number_i varchar,
    email_cut_i  varchar, -- part generated in back
    admission_i varchar, --validate in  back
    registration_i varchar, --validate in  back
    department_id_i int
    )
    returns varchar
    language plpgsql
as
$$
DECLARE
    string varchar;
    i_count_mail bigint = 0;
    i_count bigint = 0;

BEGIN

    -- PRUEBA
    /*
    select * from insert_employees(
            '2014cdbe-c6c2-4a16-a70b-92c149452eb2',
            'Laura',
            'Daniela',
            'Aguado',
            'Rendon',
            1,
            1,
            '000101',
            'laura.daniela',
            '2022-01-03',
            '2022-01-12 18:08:05.000000',
            4
    );
    */

    -----------------------------------       VALIDATE IDENTIFICATION       -----------------------------------
    string := ' SELECT COUNT(*) FROM employees WHERE identification_type_id = ' || identification_type_id_i::varchar || ' AND  identification_number = '||chr(39)|| identification_number_i ||chr(39) ;
    --raise notice ' SUB QUERY 2 -> %', string;
    EXECUTE string into i_count;

    IF i_count != 0 then
        RETURN 'invalid identification';
    end if;
    -----------------------------------   END  VALIDATE IDENTIFICATION       -----------------------------------


    -----------------------------------      BUILD EMAIL      -----------------------------------
    string := ' SELECT domain FROM countries WHERE id = ' || countries_id_i::varchar ;
    --raise notice ' SUB QUERY 3 -> %', string;
    EXECUTE string into string;

    IF string is null then
        RETURN 'error in build email';
    end if;

    string := email_cut_i || identification_number_i::varchar|| '.' || identification_type_id_i::varchar  || string;
    --raise notice ' EMAIL -> %', string;

    -----------------------------------  END  BUILD EMAIL      -----------------------------------

     INSERT INTO employees values (
                                        uuid_i,
                                        name_i ,
                                        others_names_i ,
                                        last_name_i ,
                                        second_last_name_i ,
                                        countries_id_i ,
                                        identification_type_id_i,
                                        identification_number_i ,
                                        string  ,
                                        admission_i::date ,
                                        registration_i::timestamp,
                                        department_id_i
    );

    RETURN 'finished successfully';

EXCEPTION
    WHEN unique_violation THEN
        GET STACKED DIAGNOSTICS string = CONSTRAINT_NAME;
        RAISE EXCEPTION '%', string;
    WHEN others THEN
        ROLLBACK;
        RAISE EXCEPTION
            USING ERRCODE = sqlstate
                ,MESSAGE = 'insert_employees() [' || sqlstate || '] : ' || sqlerrm;
END
$$;

create or replace function select_employees(
    search_i varchar, --name , others_names, last_name, second_last_name, identification_number, mail
    countries_i varchar[],
    identifications_types_i varchar[],
    departments_i varchar[],
    status_i varchar,
    cursor_i varchar,
    limit_i int
)
    returns table
            (
                total_rows              int,
                uuid_o                  uuid,
                name_o                  varchar,
                others_names_o          varchar,
                last_name_o             varchar,
                second_last_name_o      varchar,
                country_o               varchar,
                identification_type_o   varchar,
                identification_number_o varchar,
                mail_o                  varchar,
                department_o            varchar,
                status                  status_user
            )
    language plpgsql
as
$$
DECLARE
    i_iterator int = 1;
    i_total    bigint ;
    s_select   varchar;
    s_from     varchar;
    s_where    varchar;
    s_sql      varchar;

BEGIN


    /*
     select * from select_employees(
        '',
        array [''],
        array [''],
        array [''],
        'enable',
        '(''Gian'',''03fdc57f-e9bf-47d0-a25a-255f4a7f894b'')',
        2
    );
     */


    s_from := ' FROM employees e, countries c, identification_type i, department d ';
    s_where := ' WHERE  e.countries_id = c.id AND e.identification_type_id = i.id AND e.department_id = d.id ';


    -- FILTRO DE BUSQUEDA -------------- BY --> name , others_names, last_name, second_last_name, identification_number, mail
    if (search_i != '') then
        s_where := s_where
                       || ' AND ( '
                       || '  lower(e.name) LIKE ' || chr(39) || '%' || lower(search_i) || '%' || chr(39)
                       || ' OR lower(e.others_names) LIKE ' || chr(39) || '%' || lower(search_i) || '%' || chr(39)
                       || ' OR  lower(e.last_name) LIKE ' || chr(39) || '%' || lower(search_i) || '%' || chr(39)
                       || ' OR  lower(e.second_last_name) LIKE ' || chr(39) || '%' || lower(search_i) || '%' || chr(39)
                       || ' OR  lower(e.identification_number) LIKE ' || chr(39) || '%' || lower(search_i) || '%' ||
                   chr(39)
                       || ' OR  lower(e.mail) LIKE ' || chr(39) || '%' || lower(search_i) || '%' || chr(39)
            || ' ) ';
    end if;
    -- FIN FILTRO DE BUSQUEDA -------------------------------------


    --  FILTRO DE PAISES -------------------------------------
    -- los arrays empieza su indece en 1
    if array_length(countries_i, 1) > 0 then
        if countries_i[1] != '' then
            s_where := s_where || ' AND (  c.id = ' || chr(39) || countries_i[1] || chr(39) || ' ';
            loop
                i_iterator := i_iterator + 1;
                exit when i_iterator > array_length(countries_i, 1);
                s_where := s_where || ' OR  c.id = ' || chr(39) || countries_i[i_iterator] || chr(39) || ' ';
            end loop;
            s_where := s_where || ' ) ' || ' ';
        end if;
    end if;
    i_iterator := 1;
    --   FIN FILTRO DE PAISES-------------------------------------


    --  FILTRO DE TIPO DE DOCUMENTO -------------------------------------
    if array_length(identifications_types_i, 1) > 0 then
        if identifications_types_i[1] != '' then
            s_where := s_where || ' AND (  i.id = ' || chr(39) || identifications_types_i[1] || chr(39) || ' ';
            loop
                i_iterator := i_iterator + 1;
                exit when i_iterator > array_length(identifications_types_i, 1);
                s_where := s_where || ' OR  i.id = ' || chr(39) || identifications_types_i[i_iterator] || chr(39) ||
                           ' ';
            end loop;
            s_where := s_where || ' ) ' || ' ';
        end if;
    end if;
    i_iterator := 1;
    --   FIN FILTRO DE DOCUMENTO-------------------------------------


    --  FILTRO DE DEPARTAMENTOS -------------------------------------
    if array_length(departments_i, 1) > 0 then
        if departments_i[1] != '' then
            s_where := s_where || ' AND (  d.id = ' || chr(39) || departments_i[1] || chr(39) || ' ';
            loop
                i_iterator := i_iterator + 1;
                exit when i_iterator > array_length(departments_i, 1);
                s_where := s_where || ' OR  d.id = ' || chr(39) || departments_i[i_iterator] || chr(39) || ' ';
            end loop;
            s_where := s_where || ' ) ' || ' ';
        end if;
    end if;
    i_iterator := 1;
    --   FIN FILTRO DE DEPARTAMENTOS -------------------------------------


    --   FIN FILTRO ESTADO
    if status_i != '' then
        s_where := s_where || ' AND  e.status  = ' || chr(39) || status_i || chr(39);
    end if;


    -- COUNT TOTAL
    execute ' SELECT count(*) ' || s_from || s_where into i_total;

    s_select := ' SELECT ' || i_total::varchar || '::int as total , e.id, e.name,e.others_names,e.last_name,e.second_last_name,c.name,i.name,' ||
                ' e.identification_number,e.mail,d.name,e.status';

        -- PAGINACION   -----------------------------
            if cursor_i != '' then
    s_where := s_where || ' AND  (e.name, e.id)  >  ' || cursor_i;
end if;
    -- FIN PAGINACION   -----------------------------


    if limit_i > 0 then
        s_sql := s_select || s_from || s_where || ' ORDER BY e.name, e.id LIMIT ' || limit_i::varchar;
    else
        s_sql := s_select || s_from || s_where || ' ORDER BY e.name, e.id ' ;
    end if;


    -- raise notice 'QUERY -> %', s_sql;
    RETURN QUERY EXECUTE s_sql;

EXCEPTION
    WHEN others THEN
        ROLLBACK;
        RAISE EXCEPTION
            USING ERRCODE = sqlstate
                ,MESSAGE = 'select_employees() [' || sqlstate || '] : ' || sqlerrm;
END
$$;


create or replace function update_employee(
    uuid_i uuid,
    name_i varchar,
    others_names_i varchar,
    last_name_i varchar,
    second_last_name_i varchar,
    countries_id_i int,
    identification_type_id_i int,
    identification_number_i varchar,
    department_id_i int,
    status_i status_user,
    uuid_trace_i uuid
)
    returns varchar
    language plpgsql
as
$$
DECLARE
    s_json                  json;
    s_sql                   varchar;
    --
    name_                   varchar;
    others_names_           varchar;
    last_name_              varchar;
    second_last_name_       varchar;
    countries_id_           int;
    identification_type_id_ int;
    identification_number_  varchar;
    department_id_          int;
    status_                 status_user;
    --
    mail_                   varchar;
    domain                  varchar;
    --
    update_row              bool = false ;
    build_email             bool = false ;


BEGIN

    -- TRAER EL REGISTRO ACTUAL
    s_sql := 'SELECT  name,others_names,last_name,second_last_name, countries_id,' ||
             'identification_type_id,identification_number,department_id,status, mail ' ||
             ' FROM employees WHERE  id = ' || chr(39) || uuid_i || chr(39) || '';
    --raise notice ' s_sql %', s_sql;
    Execute s_sql
        into name_,others_names_,last_name_,second_last_name_,
            countries_id_,identification_type_id_,identification_number_,
            department_id_,status_,mail_;

    if name_i != name_ then
        update_row := true;
        build_email := true;
        --raise notice ' log 1';
    end if;
    if not (update_row) and (others_names_i != others_names_) then
        update_row := true;
        --raise notice ' log 2';
    end if;
    if not (update_row) and (last_name_i != last_name_) then
        update_row := true;
        build_email := true;
        --raise notice ' log 3';
    end if;
    if not (update_row) and (second_last_name_i != second_last_name_) then
        update_row := true;
        --raise notice ' log 4';
    end if;
    if not (update_row) and (identification_type_id_i != identification_type_id_) then
        update_row := true;
        build_email := true;
        -- raise notice ' log 5';
    end if;
    if not (update_row) and (identification_number_i != identification_number_) then
        build_email := true;
        update_row := true;
        --raise notice ' log 6';
    end if;
    if not (update_row) and (department_id_i != department_id_) then
        update_row := true;
        --raise notice ' log 7';
    end if;
    if not (update_row) and (status_i != status_) then
        update_row := true;
        --raise notice ' log 8';
    end if;
    if not (update_row) and (countries_id_i != countries_id_) then
        update_row := true;
        build_email := true;
        --raise notice ' log 9';
    end if;

    if not (update_row) then
        return 'no update';
    end if;

    -----------------------------------    DYNAMIC  BUILD EMAIL      -----------------------------------
    if build_email then

        if countries_id_i = 0 then

            s_sql := ' SELECT domain FROM countries WHERE id = ' || countries_id_::varchar;
            --raise notice ' SUB QUERY 3 -> %', s_sql;
            EXECUTE s_sql into domain;
        else

            s_sql := ' SELECT domain FROM countries WHERE id = ' || countries_id_i::varchar;
            --raise notice ' SUB QUERY 3 -> %', s_sql;
            EXECUTE s_sql into domain;
        end if;

        IF domain is null then
            RETURN 'error in build email';
        end if;

        if name_i = '' then
            mail_ := name_;
        else
            mail_ := name_i;
        end if;

        if last_name_i = '' then
            mail_ := mail_ || '.' || last_name_;
        else
            mail_ := mail_ || '.' || last_name_i;
        end if;

        if identification_number_i = '' then
            mail_ := mail_ || identification_number_;
        else
            mail_ := mail_ || identification_number_i;
        end if;

        if identification_type_id_i = 0 then
            mail_ := mail_ || '.' || identification_type_id_::varchar;
        else
            mail_ := mail_ || '.' || identification_type_id_i::varchar;
        end if;

        mail_ := mail_ || domain;

        --raise notice ' EMAIL -> %', mail_;
    end if;

    -----------------------------------  END  BUILD EMAIL      -----------------------------------

    -- ACTUALIZAR A NUEVO REGISTRO
    UPDATE "employees"
    SET "name"                   = COALESCE(NULLIF(name_i, ''), "name"),
        "others_names"           = COALESCE(NULLIF(others_names_i, ''), "others_names"),
        "last_name"              = COALESCE(NULLIF(last_name_i, ''), "last_name"),
        "second_last_name"       = COALESCE(NULLIF(second_last_name_i, ''), "second_last_name"),
        "countries_id"           = COALESCE(NULLIF(countries_id_i, 0), "countries_id"),
        "identification_type_id" = COALESCE(NULLIF(identification_type_id_i, 0), "identification_type_id"),
        "identification_number"  = COALESCE(NULLIF(identification_number_i, ''), "identification_number"),
        "mail"                   = COALESCE(NULLIF(mail_, ''), "mail"),
        "admission"              = "admission",
        "registration"           = "registration",
        "department_id"          = COALESCE(NULLIF(department_id_i, 0), "department_id"),
        "status"                 = (COALESCE(NULLIF((status_i::varchar), ''), "mail"))::status_user

    WHERE id = uuid_i;


    s_json := '{"name": "' || name_ || '", ' ||
              '"others_names": "' || others_names_ || '", ' ||
              '"last_name": "' || last_name_ || '", ' ||
              '"second_last_name": "' || second_last_name_ || '", ' ||
              '"countries_id": "' || countries_id_ || '", ' ||
              '"identification_type_id": "' || identification_type_id_ || '", ' ||
              '"identification_number": "' || identification_number_ || '", ' ||
              '"mail": "' || mail_ || '", ' ||
              '"department_id": "' || department_id_ || '", ' ||
              '"status": "' || status_ || '" ' ||
              ' }';


    INSERT INTO users_trace
    values (uuid_trace_i,
            uuid_i,
            s_json::jsonb,
            current_timestamp);

    return 'finish';

EXCEPTION
    WHEN others THEN
        ROLLBACK;
        RAISE EXCEPTION
            USING ERRCODE = sqlstate
                ,MESSAGE = 'update_employee [' || sqlstate || '] : ' || sqlerrm;
END
$$;


 */