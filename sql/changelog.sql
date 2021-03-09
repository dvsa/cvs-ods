--liquibase formatted sql

--changeset Tanio.Artino:1
create table person (
    id int primary key,
    name varchar(50) not null,
    address1 varchar(50),
    address2 varchar(50),
    city varchar(30)
)

--changeset Tanio.Artino:2
create table people (
    id int primary key,
    name varchar(50) not null,
    address1 varchar(50),
    address2 varchar(50),
    city varchar(30)
)

--changeset Martin.Kemp:3
create table cars (
    id int primary key,
    model varchar(50) not null
)

--changeset Sanjeet:3
create table house (
    id int primary key,
    address varchar(50) not null
)

--changeset Sanjeet:3
create table test (
    id int primary key,
    address varchar(50) not null
)


