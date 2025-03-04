USE `DBT25 A1 PES2UG22CS317 MohammedHassan`;

-- 1. COUNT and SELECT * queries for all tables
SELECT 'Users' as TableName, COUNT(*) as RowCount FROM Users;
SELECT 'Artists' as TableName, COUNT(*) as RowCount FROM Artists;
SELECT 'Albums' as TableName, COUNT(*) as RowCount FROM Albums;
SELECT 'Songs' as TableName, COUNT(*) as RowCount FROM Songs;
SELECT 'Playlists' as TableName, COUNT(*) as RowCount FROM Playlists;
SELECT 'PlaylistSongs' as TableName, COUNT(*) as RowCount FROM PlaylistSongs;
SELECT 'UserLibrary' as TableName, COUNT(*) as RowCount FROM UserLibrary;

-- Display all data from each table
SELECT * FROM Users;
SELECT * FROM Artists;
SELECT * FROM Albums;
SELECT * FROM Songs;
SELECT * FROM Playlists;
SELECT * FROM PlaylistSongs;
SELECT * FROM UserLibrary;

-- 2. Queries forcing table scans (no index usage)
-- Find all premium users who joined in 2024
EXPLAIN
SELECT * FROM Users 
WHERE YEAR(date_joined) = 2024 AND subscription_type = 'premium';

-- Find artists with more monthly listeners than average
EXPLAIN
SELECT * FROM Artists 
WHERE monthly_listeners > (SELECT AVG(monthly_listeners) FROM Artists);

-- 3. Multi-table joins with SELECT *
-- Join Users, Playlists, and PlaylistSongs
EXPLAIN
SELECT *
FROM Users u
JOIN Playlists p ON u.user_id = p.user_id
JOIN PlaylistSongs ps ON p.playlist_id = ps.playlist_id;

-- Join Artists, Albums, and Songs
EXPLAIN
SELECT *
FROM Artists a
JOIN Albums al ON a.artist_id = al.artist_id
JOIN Songs s ON al.album_id = s.album_id;

-- 4. Multi-table joins with specific columns and conditions
-- Find song details with artist and album info for songs with high play counts
EXPLAIN
SELECT 
    s.song_name,
    al.album_name,
    a.artist_name,
    s.play_count
FROM Songs s
JOIN Albums al ON s.album_id = al.album_id
JOIN Artists a ON al.artist_id = a.artist_id
WHERE s.play_count > 500000
ORDER BY s.play_count DESC;

-- Find playlist details with user and song information
EXPLAIN
SELECT 
    u.username,
    p.playlist_name,
    s.song_name,
    ps.date_added
FROM Users u
JOIN Playlists p ON u.user_id = p.user_id
JOIN PlaylistSongs ps ON p.playlist_id = ps.playlist_id
JOIN Songs s ON ps.song_id = s.song_id
WHERE u.subscription_type = 'premium'
ORDER BY ps.date_added DESC;

-- 5. Analysis of query performance
-- Show the execution plan for a complex query
EXPLAIN ANALYZE
SELECT 
    a.artist_name,
    COUNT(DISTINCT al.album_id) as album_count,
    COUNT(DISTINCT s.song_id) as song_count,
    SUM(s.play_count) as total_plays
FROM Artists a
LEFT JOIN Albums al ON a.artist_id = al.artist_id
LEFT JOIN Songs s ON al.album_id = s.album_id
GROUP BY a.artist_id, a.artist_name
HAVING total_plays > 1000000
ORDER BY total_plays DESC;
