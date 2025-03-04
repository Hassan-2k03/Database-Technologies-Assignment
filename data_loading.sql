USE `DBT25 A1 PES2UG22CS317 MohammedHassan`;

-- Clear existing data (if any)
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE PlaylistSongs;
TRUNCATE TABLE UserLibrary;
TRUNCATE TABLE Playlists;
TRUNCATE TABLE Songs;
TRUNCATE TABLE Albums;
TRUNCATE TABLE Artists;
TRUNCATE TABLE Users;
SET FOREIGN_KEY_CHECKS = 1;

-- Insert Users including your information
INSERT INTO Users (user_id, username, email, password_hash, subscription_type, date_joined) VALUES
(1, 'PES2UG22CS317', 'mohammedhassan@pes.edu', SHA2('pass1', 256), 'premium', '2024-01-01'),
(2, 'user002', 'user2@email.com', SHA2('pass2', 256), 'free', '2024-01-02'),
(3, 'user003', 'user3@email.com', SHA2('pass3', 256), 'premium', '2024-01-03'),
(4, 'user004', 'user4@email.com', SHA2('pass4', 256), 'free', '2024-01-04'),
(5, 'user005', 'user5@email.com', SHA2('pass5', 256), 'family', '2024-01-05');

-- Insert Artists
INSERT INTO Artists (artist_id, artist_name, bio, monthly_listeners, verified) VALUES
(1, 'Artist One', 'Popular artist bio', 1000000, true),
(2, 'Artist Two', 'Emerging artist', 500000, false),
(3, 'Artist Three', 'Rock band from LA', 750000, true),
(4, 'Artist Four', 'Pop sensation', 2000000, true),
(5, 'Artist Five', 'Independent artist', 100000, false);

-- Insert Albums
INSERT INTO Albums (album_id, album_name, artist_id, release_date, album_type, total_tracks) VALUES
(1, 'First Album', 1, '2023-01-01', 'album', 12),
(2, 'Second Album', 2, '2023-02-01', 'EP', 6),
(3, 'Third Album', 1, '2023-03-01', 'album', 10),
(4, 'Fourth Album', 3, '2023-04-01', 'single', 1),
(5, 'Fifth Album', 4, '2023-05-01', 'album', 15);

-- Insert Songs
INSERT INTO Songs (song_id, song_name, album_id, duration, track_number, explicit, play_count) VALUES
(1, 'Song One', 1, 180, 1, false, 1000000),
(2, 'Song Two', 1, 210, 2, true, 500000),
(3, 'Song Three', 2, 195, 1, false, 750000),
(4, 'Song Four', 2, 200, 2, false, 300000),
(5, 'Song Five', 3, 185, 1, true, 900000);

-- Insert Playlists
INSERT INTO Playlists (playlist_id, playlist_name, user_id, created_date, is_public, description) VALUES
(1, 'My Favorites', 1, NOW(), true, 'My favorite songs'),
(2, 'Workout Mix', 2, NOW(), true, 'High energy playlist'),
(3, 'Chill Vibes', 1, NOW(), true, 'Relaxing music'),
(4, 'Party Mix', 3, NOW(), false, 'Weekend party songs'),
(5, 'Study Music', 4, NOW(), true, 'Focus and concentration');

-- Insert some initial playlist songs
INSERT INTO PlaylistSongs (playlist_id, song_id, date_added) VALUES
(1, 1, NOW()),
(1, 2, NOW()),
(2, 3, NOW()),
(2, 4, NOW()),
(3, 5, NOW());

-- Insert some initial user library entries
INSERT INTO UserLibrary (user_id, song_id, date_added) VALUES
(1, 1, NOW()),
(1, 2, NOW()),
(2, 3, NOW()),
(3, 4, NOW()),
(4, 5, NOW());
