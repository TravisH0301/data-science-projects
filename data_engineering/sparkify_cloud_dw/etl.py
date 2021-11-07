import configparser
import psycopg2
from sql_queries import copy_table_queries, insert_table_queries


def load_staging_tables(cur, conn):
    """
    This function loads song and event datasets from S3 into
    the staging tables in Redshift.
    """
    print('Loading dataset into staging tables...')
    for i, query in enumerate(copy_table_queries):
        cur.execute(query)
        conn.commit()
        print(f'{i+1}/{len(copy_table_queries)} queries completed.')


def insert_tables(cur, conn):
    """
    This function populates tables using the data in the 
    staging tables in Redshift.
    """
    print('Populating tables...')
    for i, query in enumerate(insert_table_queries):
        cur.execute(query)
        conn.commit()
        print(f'{i+1}/{len(insert_table_queries)} queries completed.')


def main():
    config = configparser.ConfigParser()
    config.read('dwh.cfg')

    conn = psycopg2.connect("host={} dbname={} user={} password={} port={}".format(*config['CLUSTER'].values()))
    cur = conn.cursor()
    
    load_staging_tables(cur, conn)
    insert_tables(cur, conn)

    conn.close()


if __name__ == "__main__":
    main()