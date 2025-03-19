USE `DBT25 A1 PES2UG22CS317 MohammedHassan`;

-- Select all data and count rows from the Users table
SELECT * FROM Users;
SELECT COUNT(*) AS TotalUsers FROM Users;

-- Select all data and count rows from the Artists table
SELECT * FROM Artists;
SELECT COUNT(*) AS TotalArtists FROM Artists;

-- Select all data and count rows from the Albums table
SELECT * FROM Albums;
SELECT COUNT(*) AS TotalAlbums FROM Albums;

-- Select all data and count rows from the Songs table
SELECT * FROM Songs;
SELECT COUNT(*) AS TotalSongs FROM Songs;

-- Select all data and count rows from the Playlists table
SELECT * FROM Playlists;
SELECT COUNT(*) AS TotalPlaylists FROM Playlists;

-- Select all data and count rows from the PlaylistSongs table
SELECT * FROM PlaylistSongs;
SELECT COUNT(*) AS TotalPlaylistSongs FROM PlaylistSongs;

-- Select all data and count rows from the UserLibrary table
SELECT * FROM UserLibrary;
SELECT COUNT(*) AS TotalUserLibraryEntries FROM UserLibrary;

-- Multi-table join queries (3 tables)
-- Query 1: Get all songs with their album and artist details
SELECT * FROM Songs s
JOIN Albums a ON s.album_id = a.album_id
JOIN Artists ar ON a.artist_id = ar.artist_id;

-- Query 2: Select specific columns from songs, albums, and artists
SELECT s.song_name, s.duration, a.album_name, ar.artist_name, ar.monthly_listeners
FROM Songs s
JOIN Albums a ON s.album_id = a.album_id
JOIN Artists ar ON a.artist_id = ar.artist_id
WHERE s.explicit = FALSE AND ar.verified = TRUE;

-- Query 3: Find user playlist details with song and album information
SELECT u.username, p.playlist_name, s.song_name, a.album_name
FROM Users u
JOIN Playlists p ON u.user_id = p.user_id
JOIN PlaylistSongs ps ON p.playlist_id = ps.playlist_id
JOIN Songs s ON ps.song_id = s.song_id
JOIN Albums a ON s.album_id = a.album_id
WHERE p.is_public = TRUE;

-- Query 4: Count songs per artist with album details
SELECT ar.artist_name, a.album_name, COUNT(s.song_id) as song_count
FROM Artists ar
JOIN Albums a ON ar.artist_id = a.artist_id
JOIN Songs s ON a.album_id = s.album_id
GROUP BY ar.artist_id, a.album_id
HAVING song_count > 5;

-- Query 5: User library analysis
SELECT u.username, ar.artist_name, COUNT(ul.song_id) as songs_saved
FROM Users u
JOIN UserLibrary ul ON u.user_id = ul.user_id
JOIN Songs s ON ul.song_id = s.song_id
JOIN Albums a ON s.album_id = a.album_id
JOIN Artists ar ON a.artist_id = ar.artist_id
GROUP BY u.user_id, ar.artist_id
ORDER BY songs_saved DESC;

-- Run EXPLAIN for each query
EXPLAIN SELECT * FROM Songs s
JOIN Albums a ON s.album_id = a.album_id
JOIN Artists ar ON a.artist_id = ar.artist_id;

EXPLAIN SELECT s.song_name, s.duration, a.album_name, ar.artist_name, ar.monthly_listeners
FROM Songs s
JOIN Albums a ON s.album_id = a.album_id
JOIN Artists ar ON a.artist_id = ar.artist_id
WHERE s.explicit = FALSE AND ar.verified = TRUE;

EXPLAIN SELECT u.username, p.playlist_name, s.song_name, a.album_name
FROM Users u
JOIN Playlists p ON u.user_id = p.user_id
JOIN PlaylistSongs ps ON p.playlist_id = ps.playlist_id
JOIN Songs s ON ps.song_id = s.song_id
JOIN Albums a ON s.album_id = a.album_id
WHERE p.is_public = TRUE;

EXPLAIN SELECT ar.artist_name, a.album_name, COUNT(s.song_id) as song_count
FROM Artists ar
JOIN Albums a ON ar.artist_id = a.artist_id
JOIN Songs s ON a.album_id = s.album_id
GROUP BY ar.artist_id, a.album_id
HAVING song_count > 5;

EXPLAIN SELECT u.username, ar.artist_name, COUNT(ul.song_id) as songs_saved
FROM Users u
JOIN UserLibrary ul ON u.user_id = ul.user_id
JOIN Songs s ON ul.song_id = s.song_id
JOIN Albums a ON s.album_id = a.album_id
JOIN Artists ar ON a.artist_id = ar.artist_id
GROUP BY u.user_id, ar.artist_id
ORDER BY songs_saved DESC;

-- Index Scan Examples
-- Query 6: Using primary key (index scan)
SELECT * FROM Users WHERE user_id = 1;
EXPLAIN SELECT * FROM Users WHERE user_id = 1;

-- Query 7: Range scan on date
SELECT * FROM Albums WHERE release_date BETWEEN '2020-01-01' AND '2020-07-31';
EXPLAIN SELECT * FROM Albums WHERE release_date BETWEEN '2020-01-01' AND '2020-07-31';

-- Query 8: Index scan on foreign key
SELECT s.song_name, a.album_name 
FROM Songs s 
JOIN Albums a ON s.album_id = a.album_id 
WHERE s.album_id = 1;
EXPLAIN SELECT s.song_name, a.album_name 
FROM Songs s 
JOIN Albums a ON s.album_id = a.album_id 
WHERE s.album_id = 1;

-- Table Scan Examples
-- Query 9: Full table scan with LIKE (case-insensitive search)
SELECT * FROM Songs WHERE LOWER(song_name) LIKE LOWER('%love%');
EXPLAIN SELECT * FROM Songs WHERE LOWER(song_name) LIKE LOWER('%love%');

-- Query 10: Table scan with calculation
SELECT song_name, duration/60 as minutes 
FROM Songs 
WHERE duration/60 > 6.5;
EXPLAIN SELECT song_name, duration/60 as minutes 
FROM Songs 
WHERE duration/60 > 6.5;

-- Mixed Scan Example
-- Query 11: Combination of index and table scan
SELECT u.username, COUNT(ps.song_id) as playlist_songs
FROM Users u
LEFT JOIN Playlists p ON u.user_id = p.user_id
LEFT JOIN PlaylistSongs ps ON p.playlist_id = ps.playlist_id
WHERE u.subscription_type = 'premium'
GROUP BY u.user_id, u.username
HAVING COUNT(ps.song_id) > 10;

EXPLAIN SELECT u.username, COUNT(ps.song_id) as playlist_songs
FROM Users u
LEFT JOIN Playlists p ON u.user_id = p.user_id
LEFT JOIN PlaylistSongs ps ON p.playlist_id = ps.playlist_id
WHERE u.subscription_type = 'premium'
GROUP BY u.user_id, u.username
HAVING COUNT(ps.song_id) > 10;