import random
from datetime import datetime, timedelta
import mysql.connector

def connect_to_db():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="dbms",
        database="DBT25 A1 PES2UG22CS317 MohammedHassan"
    )

def generate_artists(cursor, num_artists=100):
    print("Generating artists...")
    for i in range(2, num_artists + 1):
        cursor.execute("""
            INSERT INTO Artists (artist_id, artist_name, bio, monthly_listeners, verified)
            VALUES (%s, %s, %s, %s, %s)
        """, (i, f'Artist {i}', f'Bio for artist {i}', 
              random.randint(1000, 1000000), random.choice([True, False])))
    return range(1, num_artists + 1)

def generate_albums(cursor, artist_ids, num_albums=200):
    print("Generating albums...")
    start_date = datetime(2020, 1, 1)
    for i in range(2, num_albums + 1):
        release_date = start_date + timedelta(days=random.randint(0, 1000))
        cursor.execute("""
            INSERT INTO Albums (album_id, album_name, artist_id, release_date, album_type, total_tracks)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (i, f'Album {i}', random.choice(artist_ids), release_date,
              random.choice(['single', 'EP', 'album']), random.randint(1, 20)))
    return range(1, num_albums + 1)

def generate_songs(cursor, album_ids, num_songs=1000):
    print("Generating songs...")
    for i in range(2, num_songs + 1):
        cursor.execute("""
            INSERT INTO Songs (song_id, song_name, album_id, duration, track_number, explicit, play_count)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        """, (i, f'Song {i}', random.choice(album_ids),
              random.randint(120, 400), random.randint(1, 20),
              random.choice([True, False]), random.randint(0, 1000000)))
    return range(1, num_songs + 1)

def generate_playlists(cursor, num_playlists=100):
    print("Generating playlists...")
    # Get all user IDs
    cursor.execute("SELECT user_id FROM Users")
    user_ids = [row[0] for row in cursor.fetchall()]
    
    for i in range(2, num_playlists + 1):
        created_date = datetime.now() - timedelta(days=random.randint(0, 365))
        # Simple random assignment without bias
        user_id = random.choice(user_ids)
        cursor.execute("""
            INSERT INTO Playlists (playlist_id, playlist_name, user_id, created_date, is_public, description)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (i, f'Playlist {i}', user_id, created_date,
              random.choice([True, False]), f'Description for playlist {i}'))
    return range(1, num_playlists + 1)

def generate_playlist_songs(cursor, playlist_ids, song_ids, num_records=10000):
    print("Generating playlist songs...")
    records = set()
    while len(records) < num_records:
        records.add((random.choice(playlist_ids), random.choice(song_ids)))
    
    for playlist_id, song_id in records:
        try:
            cursor.execute("""
                INSERT INTO PlaylistSongs (playlist_id, song_id, date_added)
                VALUES (%s, %s, %s)
            """, (playlist_id, song_id, datetime.now() - timedelta(days=random.randint(0, 365))))
        except mysql.connector.IntegrityError:
            continue

def generate_user_library(cursor, song_ids, num_records=10000):
    print("Generating user library...")
    # Get all user IDs
    cursor.execute("SELECT user_id FROM Users")
    user_ids = [row[0] for row in cursor.fetchall()]
    
    records = set()
    target_records = num_records // len(user_ids)  # Equal records per user
    
    # Give each user equal number of songs
    for user_id in user_ids:
        user_records = 0
        while user_records < target_records:
            record = (user_id, random.choice(song_ids))
            if record not in records:
                records.add(record)
                user_records += 1
    
    # Insert the records
    for user_id, song_id in records:
        try:
            cursor.execute("""
                INSERT INTO UserLibrary (user_id, song_id, date_added)
                VALUES (%s, %s, %s)
            """, (user_id, song_id, datetime.now() - timedelta(days=random.randint(0, 365))))
        except mysql.connector.IntegrityError:
            continue

def main():
    conn = connect_to_db()
    cursor = conn.cursor()
    
    try:
        print("Starting data generation...")
        
        artist_ids = generate_artists(cursor)
        conn.commit()
        
        album_ids = generate_albums(cursor, artist_ids)
        conn.commit()
        
        song_ids = generate_songs(cursor, album_ids)
        conn.commit()
        
        playlist_ids = generate_playlists(cursor)
        conn.commit()
        
        generate_playlist_songs(cursor, playlist_ids, song_ids)
        conn.commit()
        
        generate_user_library(cursor, song_ids)
        conn.commit()
        
        # Verify counts
        cursor.execute("SELECT COUNT(*) FROM PlaylistSongs")
        print(f"PlaylistSongs count: {cursor.fetchone()[0]}")
        cursor.execute("SELECT COUNT(*) FROM UserLibrary")
        print(f"UserLibrary count: {cursor.fetchone()[0]}")
        
        # Add user count verification
        cursor.execute("SELECT COUNT(*) FROM Users")
        print(f"Total Users: {cursor.fetchone()[0]}")
        
        cursor.execute("""
            SELECT u.username, COUNT(ul.song_id) as song_count
            FROM Users u
            LEFT JOIN UserLibrary ul ON u.user_id = ul.user_id
            GROUP BY u.user_id, u.username
        """)
        print("\nSongs per user:")
        for row in cursor.fetchall():
            print(f"{row[0]}: {row[1]} songs")
        
    except Exception as e:
        print(f"Error: {e}")
        conn.rollback()
    finally:
        cursor.close()
        conn.close()
        print("Data generation complete!")

if __name__ == "__main__":
    main()
