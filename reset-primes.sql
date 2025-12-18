drop database primes;
create database primes;

\c primes

begin;

drop schema if exists primes cascade;
create schema primes;

set search_path to primes;

drop sequence if exists asc_ident cascade;

create sequence asc_ident as int;

drop table if exists primes;

create table primes (
    ident int default nextval('asc_ident'),
    prime int
);

-- alter table primes alter column ident set default nextval('asc_ident');
-- alter sequence asc_ident owned by primes.ident;

commit;

