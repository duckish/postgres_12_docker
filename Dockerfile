FROM debian:buster

RUN apt-get update && apt-get install -y gnupg2 vim

RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8

RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main" > /etc/apt/sources.list.d/pgdg.list

RUN apt-get update && apt-get install -y software-properties-common postgresql-12 postgresql-client-12 postgresql-contrib-12 python3-pip libpq-dev

USER postgres

RUN    /etc/init.d/postgresql start &&\
    psql --command "CREATE USER dbuser WITH SUPERUSER PASSWORD 'dbpass';" &&\
    psql --command "CREATE DATABASE dbname WITH OWNER=dbuser;" 

RUN ls -al /etc/postgresql/
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/12/main/pg_hba.conf

RUN echo "listen_addresses='*'" >> /etc/postgresql/12/main/postgresql.conf

RUN pip3 install psycopg2

EXPOSE 5432

VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

CMD ["/usr/lib/postgresql/12/bin/postgres", "-D", "/var/lib/postgresql/12/main", "-c", "config_file=/etc/postgresql/12/main/postgresql.conf"]
