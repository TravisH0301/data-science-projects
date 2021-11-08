import configparser


# load AWS config file
config = configparser.ConfigParser()
config.read('dwh.cfg')
role_arn = config.get('IAM_ROLE', 'ARN')

# drop table queries
staging_events_table_drop = "DROP TABLE IF EXISTS stg_events"
staging_songs_table_drop = "DROP TABLE IF EXISTS stg_songs"
songplay_table_drop = "DROP TABLE IF EXISTS songplays"
user_table_drop = "DROP TABLE IF EXISTS users"
song_table_drop = "DROP TABLE IF EXISTS songs"
artist_table_drop = "DROP TABLE IF EXISTS artists"
time_table_drop = "DROP TABLE IF EXISTS time"

# queries to create tables
staging_events_table_create= ("""CREATE TABLE IF NOT EXISTS stg_events
(
    artist VARCHAR,
    auth VARCHAR,
    firstName VARCHAR,
    gender VARCHAR,
    itemInSession INT,
    lastName VARCHAR,
    length DECIMAL,
    level VARCHAR,
    location VARCHAR,
    method VARCHAR ,
    page VARCHAR,
    registration DECIMAL,
    sessionId INT,
    song VARCHAR,
    status INT ,
    ts BIGINT,
    userAgent VARCHAR,
    userId INT
) DISTSTYLE AUTO;
""")

staging_songs_table_create = ("""CREATE TABLE IF NOT EXISTS stg_songs
(
    num_songs INT, 
    artist_id VARCHAR, 
    artist_latitude VARCHAR,
    artist_longitude VARCHAR, 
    artist_location VARCHAR, 
    artist_name VARCHAR,
    song_id VARCHAR,
    title VARCHAR,
    duration DECIMAL,
    year INT
) DISTSTYLE AUTO;
""")

songplay_table_create = ("""CREATE TABLE IF NOT EXISTS songplays
(
    songplay_id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    start_time TIMESTAMP NOT NULL SORTKEY,
    user_id INT NOT NULL,
    level VARCHAR NOT NULL,
    song_id VARCHAR NOT NULL,
    artist_id VARCHAR NOT NULL,
    session_id INT NOT NULL,
    location VARCHAR,
    user_agent VARCHAR NOT NULL
) DISTSTYLE AUTO;
""")

user_table_create = ("""CREATE TABLE IF NOT EXISTS users
(
    user_id INT NOT NULL PRIMARY KEY, 
    first_name VARCHAR NOT NULL, 
    last_name VARCHAR NOT NULL, 
    gender VARCHAR NOT NULL, 
    level VARCHAR NOT NULL
) DISTSTYLE AUTO;
""")

song_table_create = ("""CREATE TABLE IF NOT EXISTS songs
(
    song_id VARCHAR NOT NULL PRIMARY KEY, 
    title VARCHAR NOT NULL, 
    artist_id VARCHAR NOT NULL, 
    year INT SORTKEY, 
    duration DECIMAL NOT NULL
) DISTSTYLE AUTO;
""")

artist_table_create = ("""CREATE TABLE IF NOT EXISTS artists
(
    artist_id VARCHAR NOT NULL PRIMARY KEY, 
    name VARCHAR NOT NULL, 
    location VARCHAR , 
    latitude VARCHAR, 
    longitude VARCHAR
) DISTSTYLE AUTO;
""")

time_table_create = ("""CREATE TABLE IF NOT EXISTS time
(
    start_time TIMESTAMP NOT NULL PRIMARY KEY SORTKEY, 
    hour SMALLINT NOT NULL, 
    day SMALLINT NOT NULL, 
    week SMALLINT NOT NULL, 
    month SMALLINT NOT NULL, 
    year INT NOT NULL, 
    weekday SMALLINT NOT NULL
) DISTSTYLE AUTO;
""")

# queries to load data to staging tables

staging_events_copy = ("""
    COPY stg_events FROM 's3://udacity-dend/log_data/'
    credentials 'aws_iam_role={}'
    format as json 's3://udacity-dend/log_json_path.json' region 'us-west-2';
""").format(role_arn)

staging_songs_copy = ("""
    COPY stg_songs FROM 's3://udacity-dend/song_data/'
    credentials 'aws_iam_role={}'
    format as json 'auto' region 'us-west-2';
""").format(role_arn)

# queries to transform and load data into tables

songplay_table_insert = ("""
    INSERT INTO songplays (start_time, user_id, level, song_id, artist_id, session_id, location, user_agent)
    SELECT 
        TIMESTAMP 'epoch' + se.ts/1000 * INTERVAL '1 second',
        se.userId,
        se.level,
        ss.song_id,
        ss.artist_id,
        se.sessionId,
        se.location,
        se.userAgent
    FROM 
        stg_events se
        INNER JOIN stg_songs ss ON 
        (
            se.song = ss.title
            AND se.artist = ss.artist_name
            AND se.length = ss.duration
        )
    WHERE 
        se.ts IS NOT NULL
        AND se.userId IS NOT NULL
        AND se.level IS NOT NULL
        AND ss.song_id IS NOT NULL
        AND ss.artist_id IS NOT NULL
        AND se.sessionId IS NOT NULL
        AND se.userAgent IS NOT NULL;
""")
    
user_table_insert = ("""
    INSERT INTO users (user_id, first_name, last_name, gender, level)
    SELECT
        DISTINCT userId,
        firstName,
        lastName,
        gender,
        level
    FROM stg_events
    WHERE
        page = 'NextSong'
        AND userID IS NOT NULL
        AND firstName IS NOT NULL
        AND lastName IS NOT NULL
        AND gender IS NOT NULL;
""")

song_table_insert = ("""
    INSERT INTO songs (song_id, title, artist_id, year, duration)
    SELECT
        DISTINCT song_id,
        title,
        artist_id,
        year,
        duration
    FROM stg_songs
    WHERE
        song_id IS NOT NULL
        AND title IS NOT NULL
        AND artist_id IS NOT NULL
        AND duration IS NOT NULL;
""")

artist_table_insert = ("""
    INSERT INTO artists (artist_id, name, location, latitude, longitude)
    SELECT
        DISTINCT artist_id,
        artist_name,
        artist_location,
        artist_latitude,
        artist_longitude
    FROM stg_songs
    WHERE
        artist_id IS NOT NULL
        AND artist_name IS NOT NULL;
""")

time_table_insert = ("""
    INSERT INTO time (start_time, hour, day, week, month, year, weekday)
    SELECT
        DISTINCT sub.start_time,
        EXTRACT (HOUR FROM sub.start_time), 
        EXTRACT (DAY FROM sub.start_time),
        EXTRACT (WEEK FROM sub.start_time), 
        EXTRACT (MONTH FROM sub.start_time),
        EXTRACT (YEAR FROM sub.start_time), 
        EXTRACT (WEEKDAY FROM sub.start_time)
    FROM 
    ( 
        SELECT TIMESTAMP 'epoch' + ts/1000 * INTERVAL '1 second' AS start_time
        FROM stg_events
    ) sub
    WHERE start_time IS NOT NULL;
""")

# define lists of queries
create_table_queries = [staging_events_table_create, staging_songs_table_create, songplay_table_create, user_table_create, song_table_create, artist_table_create, time_table_create]
drop_table_queries = [staging_events_table_drop, staging_songs_table_drop, songplay_table_drop, user_table_drop, song_table_drop, artist_table_drop, time_table_drop]
copy_table_queries = [staging_events_copy, staging_songs_copy]
insert_table_queries = [songplay_table_insert, user_table_insert, song_table_insert, artist_table_insert, time_table_insert]
