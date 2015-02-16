DROP DATABASE IF EXISTS weekendlab;
CREATE DATABASE IF NOT EXISTS weekendlab;

\connect weekendlab

CREATE TABLE IF NOT EXISTS squads (
  id serial PRIMARY KEY,
  name varchar(50),
  mascot varchar(50)
);

CREATE TABLE IF NOT EXISTS students (
  id serial PRIMARY KEY,
  squad_id integer REFERENCES squads (id),
  name varchar(50),
  mascot varchar(50)
);
