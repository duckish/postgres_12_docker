FROM debian:buster

RUN apt-get update && apt-get install -y gnupg2 vim wget curl

#RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8

RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main" > /etc/apt/sources.list.d/pgdg.list

#RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" > /etc/apt/sources.list.d/pgdg.list

RUN apt-get update && apt-get install -y software-properties-common postgresql-13 postgresql-client-13 postgresql-contrib-13 python3-pip libpq-dev

USER postgres

RUN    /etc/init.d/postgresql start &&\
    psql --command "CREATE USER dbuser WITH SUPERUSER PASSWORD 'dbpass';" &&\
    psql --command "CREATE DATABASE dbname WITH OWNER=dbuser;" 

RUN ls -al /etc/postgresql/
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/13/main/pg_hba.conf

RUN echo "listen_addresses='*'" >> /etc/postgresql/13/main/postgresql.conf

RUN pip3 install psycopg2

EXPOSE 5432

VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

CMD ["/usr/lib/postgresql/13/bin/postgres", "-D", "/var/lib/postgresql/13/main", "-c", "config_file=/etc/postgresql/13/main/postgresql.conf"]
