
import psycopg2

mobiles = [
    {"id":5, "model": "s6", "price": 120 },
    {"id":6, "model": "s7", "price": 121 },
    {"id":7, "model": "s8", "price": 122 }
]
try:
    connection = psycopg2.connect(user="dbuser",
                                  password="dbpass",
                                  host="localhost",
                                  port="5432",
                                  database="dbname")

    cursor = connection.cursor()

    cursor.execute('''CREATE TABLE mobile
                      (ID INT PRIMARY KEY     NOT NULL,
                       MODEL           VARCHAR (50) UNIQUE NOT NULL,
                       PRICE           INT);''')
    connection.commit()

    postgres_insert_query = """ INSERT INTO mobile (ID, MODEL, PRICE) VALUES (%s,%s,%s)"""
    for i in mobiles:
        record_to_insert = (i["id"], i["model"], i["price"])
        cursor.execute(postgres_insert_query, record_to_insert)

    connection.commit()
    count = cursor.rowcount
    print (count, "Record inserted successfully into mobile table")

except (Exception, psycopg2.Error) as error :
    if(connection):
        print("Failed to insert record into mobile table", error)

finally:
    #closing database connection.
    if(connection):
        cursor.close()
        connection.close()
        print("PostgreSQL connection is closed")