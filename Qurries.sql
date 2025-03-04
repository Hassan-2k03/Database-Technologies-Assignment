-- Active: 1731390564563@@127.0.0.1@3306@dbt25 a1 pes2ug22cs317 mohammedhassan
-- Creation of the database. 
CREATE DATABASE `DBT25 A1 PES2UG22CS317 MohammedHassan` ;

-- Domain selected music. [Music Streaming Service]

-- Users Table
CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    subscription_type ENUM('free', 'premium', 'family') DEFAULT 'free',
    date_joined DATE
);

-- Artists Table
CREATE TABLE Artists (
    artist_id INT PRIMARY KEY,
    artist_name VARCHAR(100) NOT NULL,
    bio TEXT,
    monthly_listeners INT DEFAULT 0,
    verified BOOLEAN DEFAULT FALSE
);

-- Albums Table
CREATE TABLE Albums (
    album_id INT PRIMARY KEY,
    album_name VARCHAR(100) NOT NULL,
    artist_id INT,
    release_date DATE,
    album_type ENUM('single', 'EP', 'album'),
    total_tracks INT,
    FOREIGN KEY (artist_id) REFERENCES Artists(artist_id)
);

-- Songs Table
CREATE TABLE Songs (
    song_id INT PRIMARY KEY,
    song_name VARCHAR(100) NOT NULL,
    album_id INT,
    duration INT,  -- Duration in seconds
    track_number INT,
    explicit BOOLEAN DEFAULT FALSE,
    play_count INT DEFAULT 0,
    FOREIGN KEY (album_id) REFERENCES Albums(album_id)
);

-- Playlists Table
CREATE TABLE Playlists (
    playlist_id INT PRIMARY KEY,
    playlist_name VARCHAR(100) NOT NULL,
    user_id INT,
    created_date DATETIME,
    is_public BOOLEAN DEFAULT TRUE,
    description TEXT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- PlaylistSongs Table (Junction table)
CREATE TABLE PlaylistSongs (
    playlist_id INT,
    song_id INT,
    date_added DATETIME,
    PRIMARY KEY (playlist_id, song_id),
    FOREIGN KEY (playlist_id) REFERENCES Playlists(playlist_id),
    FOREIGN KEY (song_id) REFERENCES Songs(song_id)
);

-- UserLibrary Table (Liked/Saved content)
CREATE TABLE UserLibrary (
    user_id INT,
    song_id INT,
    date_added DATETIME,
    PRIMARY KEY (user_id, song_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (song_id) REFERENCES Songs(song_id)
);

