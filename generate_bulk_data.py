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

def generate_playlist_songs(cursor, num_records=10000):
    # Get existing playlist IDs
    cursor.execute("SELECT playlist_id FROM Playlists")
    playlist_ids = [row[0] for row in cursor.fetchall()]
    
    # Get existing song IDs
    cursor.execute("SELECT song_id FROM Songs")
    song_ids = [row[0] for row in cursor.fetchall()]
    
    # Generate bulk PlaylistSongs data
    for i in range(num_records):
        playlist_id = random.choice(playlist_ids)
        song_id = random.choice(song_ids)
        date_added = datetime.now() - timedelta(days=random.randint(0, 365))
        
        try:
            cursor.execute("""
                INSERT INTO PlaylistSongs (playlist_id, song_id, date_added)
                VALUES (%s, %s, %s)
            """, (playlist_id, song_id, date_added))
        except mysql.connector.IntegrityError:
            continue

def generate_user_library(cursor, num_records=10000):
    # Get existing user IDs
    cursor.execute("SELECT user_id FROM Users")
    user_ids = [row[0] for row in cursor.fetchall()]
    
    # Get existing song IDs
    cursor.execute("SELECT song_id FROM Songs")
    song_ids = [row[0] for row in cursor.fetchall()]
    
    # Generate bulk UserLibrary data
    for i in range(num_records):
        user_id = random.choice(user_ids)
        song_id = random.choice(song_ids)
        date_added = datetime.now() - timedelta(days=random.randint(0, 365))
        
        try:
            cursor.execute("""
                INSERT INTO UserLibrary (user_id, song_id, date_added)
                VALUES (%s, %s, %s)
            """, (user_id, song_id, date_added))
        except mysql.connector.IntegrityError:
            continue

def main():
    conn = connect_to_db()
    cursor = conn.cursor()
    
    generate_playlist_songs(cursor)
    generate_user_library(cursor)
    
    conn.commit()
    cursor.close()
    conn.close()

if __name__ == "__main__":
    main()
