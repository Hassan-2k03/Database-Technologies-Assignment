USE `DBT25 A1 PES2UG22CS317 MohammedHassan`;

-- Clear all existing data
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE PlaylistSongs;
TRUNCATE TABLE UserLibrary;
TRUNCATE TABLE Playlists;
TRUNCATE TABLE Songs;
TRUNCATE TABLE Albums;
TRUNCATE TABLE Artists;
TRUNCATE TABLE Users;
SET FOREIGN_KEY_CHECKS = 1;

-- Insert base users (you + 10 others)
INSERT INTO Users (user_id, username, email, password_hash, subscription_type, date_joined) VALUES
(1, 'PES2UG22CS317', 'mohammedhassan@pes.edu', SHA2('pass123', 256), 'premium', '2024-01-01'),
(2, 'john_doe', 'john@example.com', SHA2('pass456', 256), 'free', '2024-01-02'),
(3, 'emma_smith', 'emma@example.com', SHA2('pass789', 256), 'premium', '2024-01-03'),
(4, 'alex_brown', 'alex@example.com', SHA2('pass101', 256), 'family', '2024-01-04'),
(5, 'sarah_wilson', 'sarah@example.com', SHA2('pass102', 256), 'free', '2024-01-05'),
(6, 'mike_davis', 'mike@example.com', SHA2('pass103', 256), 'premium', '2024-01-06'),
(7, 'lisa_miller', 'lisa@example.com', SHA2('pass104', 256), 'family', '2024-01-07'),
(8, 'david_jones', 'david@example.com', SHA2('pass105', 256), 'free', '2024-01-08'),
(9, 'anna_white', 'anna@example.com', SHA2('pass106', 256), 'premium', '2024-01-09'),
(10, 'james_taylor', 'james@example.com', SHA2('pass107', 256), 'free', '2024-01-10'),
(11, 'maria_garcia', 'maria@example.com', SHA2('pass108', 256), 'premium', '2024-01-11');

-- Insert one base artist
INSERT INTO Artists (artist_id, artist_name, bio, monthly_listeners, verified) 
VALUES (1, 'Base Artist', 'First artist in the system', 1000000, true);

-- Insert base albums with varied release dates
INSERT INTO Albums (album_id, album_name, artist_id, release_date, album_type, total_tracks) 
VALUES 
(1, 'First Album', 1, '2024-01-01', 'album', 1),
(2, 'Second Album', 1, '2023-06-15', 'album', 1),
(3, 'Third Album', 1, '2022-12-25', 'album', 1);

-- Insert sample songs with "love" in their names
INSERT INTO Songs (song_id, song_name, album_id, duration, track_number, explicit, play_count) VALUES 
(1001, 'First Song', 1, 180, 1, false, 0),
(1002, 'Love Story', 1, 240, 2, false, 1000),
(1003, 'Endless Love', 2, 195, 1, false, 500),
(1004, 'Love Me Like You Do', 2, 235, 2, false, 2000),
(1005, 'True Love', 3, 210, 1, false, 1500);

-- Insert one base playlist
INSERT INTO Playlists (playlist_id, playlist_name, user_id, created_date, is_public, description) 
VALUES (1, 'My First Playlist', 1, NOW(), true, 'Base playlist');
