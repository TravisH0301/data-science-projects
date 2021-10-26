# Sparkify Data Warehouse ETL

## Purpose 
This project aims to create a data warehouse using ETL pipeline with the collection of song and user information from Sparkify*.<br>
The data warehouse is designed for analytics purpose with focus on query performance.

*Sparkify is a fake music streaming service invented by Udacity.

## Database Design 
This database consists of 5 tables in a star schema with 1 fact table and 4 dimension tables.
![DB ER Diagram](er_diagram.png)<br>
- songplays: fact table containing information about users and songs the users listened to
- users: dimension table containing user information
- songs: dimension table containing song information
- artists: dimension table containing artist information
- time: dimension table containing time information

The star schema is used to improve query performance for the analytics by denormalising the database.

## ETL Process
The ETL pipeline relies on the local json files of the song data and user log data. 
It extracts and processes the data from these files, and update them into the relevant tables. 

## Repository
There are 5 files including this README text file in the repository.
- README.md: readme text file with project explanation and instructions to run 
- ER Diagram.jpg: image of DB ER digram
- sql_queries.py: Python script containing all SQL queries for the ETL process
- create_tables.py: Python script to drop & create DB tables
- etl.py: Python script to process song files & log files to update DB

## How to Run
The ETL process can be carried out in the following orders:
1. Place song files to './data/song_data/' & log files to './data/log_data/'
2. Open command prompt
3. Run 'python create_tables.py'
4. Run 'python etl.py'

## Dependency
- Python (==3.6.3)
- PostgreSQL DB
