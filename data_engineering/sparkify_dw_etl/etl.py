# load libraries
import os
import glob
import psycopg2
import pandas as pd
from sql_queries import *

# define function to process & update song file data to DB
def process_song_file(cur, filepath):
    """
    This function processes the data from the song files, 
    and update them into DB tables; 'songs' & 'artists'.
    
    Inputs:
    - cur: DB connection cursor
    - filepath: pathname of song file
    """
    # open song file
    df = pd.read_json(filepath, lines=True)

    # insert song record
    song_data = df[['song_id','title','artist_id','year','duration']].values[0]
    cur.execute(song_table_insert, song_data)
    
    # insert artist record
    artist_data = df[['artist_id', 'artist_name', 'artist_location', 'artist_latitude', 'artist_longitude']].values[0]
    cur.execute(artist_table_insert, artist_data)

# define function to process & update log file data to DB
def process_log_file(cur, filepath):
    """
    This function processes the data from log files,
    and updates them into DB tables; 'time', 'songs', 'songplays'.
    
    Input:
    - cur: DB connection cursor
    - filepath: pathname of log file
    """
    
    # open log file
    df = pd.read_json(filepath, lines=True)

    # filter by NextSong action
    df = df.loc[df.page=='NextSong'].copy()
    
    # convert timestamp column to datetime
    from datetime import datetime
    df['datetime'] = df.ts.apply(lambda x: datetime.fromtimestamp(x/1000))
    
    # insert time data records
    ## create different time columns
    df['hour'] = df.datetime.dt.hour
    df['day'] = df.datetime.dt.day
    df['week of year'] = df.datetime.dt.week
    df['month'] = df.datetime.dt.month
    df['year'] = df.datetime.dt.year
    df['weekday'] = df.datetime.dt.weekday
    ## create dictionary with the new columns
    time_data = (df[['datetime','hour','day','week of year','month','year','weekday']])
    column_labels = (['start_time','hour','day','week of year','month','year','weekday'])
    time_df_dict = dict()
    for column in column_labels:
        if column == 'start_time':
            time_df_dict[column] = time_data['datetime']
        else:
            time_df_dict[column] = time_data[column]
    ## convert the dictionary to dataframe
    time_df = pd.DataFrame(time_df_dict)
    ## insert data into DB table using the dataframe
    for i, row in time_df.iterrows():
        cur.execute(time_table_insert, list(row))

    # load user table
    user_df = df[['userId','firstName','lastName','gender','level']]

    # insert user records
    for i, row in user_df.iterrows():
        cur.execute(user_table_insert, row)

    # insert songplay records
    for index, row in df.iterrows():
        
        # get songid and artistid from song and artist tables
        cur.execute(song_select, (row.song, row.artist, row.length))
        results = cur.fetchone()
        
        if results:
            songid, artistid = results
        else:
            songid, artistid = None, None

        # insert songplay record
        songplay_data = [row.datetime, row.userId, row.level, songid, artistid, row.location, row.sessionId, row.userAgent]
        cur.execute(songplay_table_insert, songplay_data)

# define function to find json files and apply function on them
def process_data(cur, conn, filepath, func):
    """
    This function finds json files recursively based on the 
    given filepath. 
    And the given function is executed with the found filepath.
    
    Input:
    - cur: DB connection cursor
    - conn: DB connection variable
    - filepath: directory pathname for files
    - func: function to process files & update DB tables
    """
    # get all files matching extension from directory
    all_files = []
    for root, dirs, files in os.walk(filepath):
        files = glob.glob(os.path.join(root,'*.json'))
        for f in files :
            all_files.append(os.path.abspath(f))

    # get total number of files found
    num_files = len(all_files)
    print('{} files found in {}'.format(num_files, filepath))

    # iterate over files and process
    for i, datafile in enumerate(all_files, 1):
        func(cur, datafile)
        conn.commit()
        print('{}/{} files processed.'.format(i, num_files), end='\r')
        
    print('') # placeholder to display the last printed line

# define function for ETL processes
def main():
    """
    This function contains the ETL processes. 
    """
    # connect to DB
    conn = psycopg2.connect("host=127.0.0.1 dbname=sparkifydb user=student password=student")
    cur = conn.cursor()

    # find song files & log files to update DB tables
    process_data(cur, conn, filepath='data/song_data', func=process_song_file)
    process_data(cur, conn, filepath='data/log_data', func=process_log_file)

    # close DB connection
    conn.close()


if __name__ == "__main__":
    main()