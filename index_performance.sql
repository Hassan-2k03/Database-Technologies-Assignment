USE `DBT25 A1 PES2UG22CS317 MohammedHassan`;

-- Store original query execution plans
-- Complex join query 1 (Before indexing)
EXPLAIN SELECT s.song_name, a.album_name, ar.artist_name, s.play_count
FROM Songs s
JOIN Albums a ON s.album_id = a.album_id
JOIN Artists ar ON a.artist_id = ar.artist_id
WHERE s.play_count > 1000;

-- Create strategic indexes
CREATE INDEX idx_songs_playcount ON Songs(play_count);
CREATE INDEX idx_albums_artistid ON Albums(artist_id);
CREATE INDEX idx_songs_albumid ON Songs(album_id);

-- Compare execution plan after indexing
-- Complex join query 1 (After indexing)
EXPLAIN SELECT s.song_name, a.album_name, ar.artist_name, s.play_count
FROM Songs s
JOIN Albums a ON s.album_id = a.album_id
JOIN Artists ar ON a.artist_id = ar.artist_id
WHERE s.play_count > 1000;

-- Second comparison: User playlist analysis
-- Before indexing
EXPLAIN SELECT u.username, COUNT(ps.song_id) as total_songs
FROM Users u
JOIN Playlists p ON u.user_id = p.user_id
JOIN PlaylistSongs ps ON p.playlist_id = ps.playlist_id
WHERE u.subscription_type = 'premium'
GROUP BY u.username;

-- Create relevant indexes
CREATE INDEX idx_users_subtype ON Users(subscription_type);
CREATE INDEX idx_playlists_userid ON Playlists(user_id);
CREATE INDEX idx_playlistsongs_playlistid ON PlaylistSongs(playlist_id);

-- After indexing
EXPLAIN SELECT u.username, COUNT(ps.song_id) as total_songs
FROM Users u
JOIN Playlists p ON u.user_id = p.user_id
JOIN PlaylistSongs ps ON p.playlist_id = ps.playlist_id
WHERE u.subscription_type = 'premium'
GROUP BY u.username;

-- Clean up (optional) - only drop custom indexes that aren't foreign key constraints
DROP INDEX idx_songs_playcount ON Songs;
DROP INDEX idx_users_subtype ON Users;

-- Note: These indexes are used by foreign keys and should not be dropped:
-- idx_playlists_userid
-- idx_playlistsongs_playlistid
-- idx_songs_albumid
-- idx_albums_artistid
