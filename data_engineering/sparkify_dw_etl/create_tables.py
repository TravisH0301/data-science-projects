# import libraries
import psycopg2
from sql_queries import create_table_queries, drop_table_queries

# define function to create DB
def create_database(): 
    """
    This function creates a DB and returns the connection cursor.
    """
    
    # connect to DB
    conn = psycopg2.connect("host=127.0.0.1 dbname=studentdb user=student password=student")
    conn.set_session(autocommit=True)
    cur = conn.cursor()
    
    # create sparkify database with UTF8 encoding
    cur.execute("DROP DATABASE IF EXISTS sparkifydb")
    cur.execute("CREATE DATABASE sparkifydb WITH ENCODING 'utf8' TEMPLATE template0")

    # close connection to default database
    conn.close()    
    
    # connect to sparkify database
    conn = psycopg2.connect("host=127.0.0.1 dbname=sparkifydb user=student password=student")
    cur = conn.cursor()
    
    return cur, conn

# define function to drop tables in DB
def drop_tables(cur, conn):
    """
    This query drops tables according to the given drop table query.
    """
    for query in drop_table_queries:
        cur.execute(query)
        conn.commit()

# define function to create tables in DB
def create_tables(cur, conn):
    """
    This function creates tables according to the given create table query.
    """
    for query in create_table_queries:
        cur.execute(query)
        conn.commit()

# define function for main processes
def main():
    # create database & create connection cursor
    cur, conn = create_database()
    
    # drop & create tables
    drop_tables(cur, conn)
    create_tables(cur, conn)

    # close DB connection
    conn.close()


if __name__ == "__main__":
    main()
