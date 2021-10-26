# Sparkify ETL Process for Song Analytics

## Purpose 
This project aims to create a database with collection of songs and users information for the analytics team to 
understand what songs users are listening to.
With this data warehouse, the analytics team can quickly acquire relevant information and conduct
analysis to find insights to understand more about the user behaviour and thus improve user experience accordingly.

## Database Design 
This database consists of 5 DB tables:
- songplays: fact table containing info about users and their songs information 
- users: dimension table containing user info
- songs: dimension table containing song info
- artists: dimension table containing artist info
- time: dimension table containing time info

These 5 tables are structured in star schema as shown as below. 
![DB ER Diagram](ER Diagram.jpg)

This star schema allows denormalisation of the database, and increases query performance for the analytics.

## ETL Process
The ETL pipeline relies on the local json files of the song data and user log data. It processes the data 
from these files, and update them into the relevant tables. 

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
