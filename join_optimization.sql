USE `DBT25 A1 PES2UG22CS317 MohammedHassan`;

-- Enable profiling to measure execution time
SET profiling = 1;

-- Original Query 1: Basic join order (Songs -> Albums -> Artists)
SELECT SQL_NO_CACHE s.song_name, a.album_name, ar.artist_name, s.play_count
FROM Songs s
JOIN Albums a ON s.album_id = a.album_id
JOIN Artists ar ON a.artist_id = ar.artist_id
WHERE s.play_count > 1000;

-- Optimized Query 1: Changed join order (Artists -> Albums -> Songs)
SELECT SQL_NO_CACHE s.song_name, a.album_name, ar.artist_name, s.play_count
FROM Artists ar
JOIN Albums a ON ar.artist_id = a.artist_id
JOIN Songs s ON a.album_id = s.album_id
WHERE s.play_count > 1000;

-- Compare execution plans
EXPLAIN ANALYZE
SELECT SQL_NO_CACHE s.song_name, a.album_name, ar.artist_name, s.play_count
FROM Songs s
JOIN Albums a ON s.album_id = a.album_id
JOIN Artists ar ON a.artist_id = ar.artist_id
WHERE s.play_count > 1000;

EXPLAIN ANALYZE
SELECT SQL_NO_CACHE s.song_name, a.album_name, ar.artist_name, s.play_count
FROM Artists ar
JOIN Albums a ON ar.artist_id = a.artist_id
JOIN Songs s ON a.album_id = s.album_id
WHERE s.play_count > 1000;

-- Original Query 2: Simple joins
SELECT SQL_NO_CACHE u.username, p.playlist_name, COUNT(ps.song_id) as song_count
FROM Users u
JOIN Playlists p ON u.user_id = p.user_id
JOIN PlaylistSongs ps ON p.playlist_id = ps.playlist_id
GROUP BY u.username, p.playlist_name;

-- Optimized Query 2: Using LEFT JOINs and subquery
SELECT SQL_NO_CACHE u.username, p.playlist_name,
    (SELECT COUNT(*) 
     FROM PlaylistSongs ps 
     WHERE ps.playlist_id = p.playlist_id) as song_count
FROM Users u
LEFT JOIN Playlists p ON u.user_id = p.user_id
WHERE u.subscription_type = 'premium';

-- Compare execution plans
EXPLAIN ANALYZE
SELECT SQL_NO_CACHE u.username, p.playlist_name, COUNT(ps.song_id) as song_count
FROM Users u
JOIN Playlists p ON u.user_id = p.user_id
JOIN PlaylistSongs ps ON p.playlist_id = ps.playlist_id
GROUP BY u.username, p.playlist_name;

EXPLAIN ANALYZE
SELECT SQL_NO_CACHE u.username, p.playlist_name,
    (SELECT COUNT(*) 
     FROM PlaylistSongs ps 
     WHERE ps.playlist_id = p.playlist_id) as song_count
FROM Users u
LEFT JOIN Playlists p ON u.user_id = p.user_id
WHERE u.subscription_type = 'premium';

-- Show execution times
SHOW PROFILES;

-- Disable profiling
SET profiling = 0;
