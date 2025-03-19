# Query Execution Plan Analysis

## Index Scan Queries

### Query 6: Primary Key Lookup
- Uses PRIMARY key index on Users table
- Single row access (const join type)
- Very efficient for single record retrieval

### Query 7: Range Scan
- Uses date range on Albums table
- May benefit from adding an index on release_date
- Currently performs table scan due to lack of index

### Query 8: Foreign Key Index
- Uses index on album_id for joining Songs and Albums
- Efficient join operation using index
- ref join type indicates index usage

## Table Scan Queries

### Query 9: LIKE Pattern Search
- Full table scan required due to leading wildcard
- Cannot use indexes effectively
- Higher cost for large tables

### Query 10: Calculated Field
- Full table scan required
- Cannot use indexes due to calculation in WHERE clause
- Consider materialized columns for frequent calculations

## Mixed Scan Query

### Query 11: Complex Join
- Uses indexes for joining Users and Playlists
- Temporary table created for GROUP BY
- File sort required for aggregation
- Mixed efficiency due to complex operations

## Index Performance Comparison

### Complex Join Query 1
Before indexing:
- Full table scan on Songs table
- Using join buffer for Albums and Artists joins
- Higher rows examined count

After indexing:
- Uses idx_songs_playcount for initial filtering
- Uses idx_songs_albumid and idx_albums_artistid for efficient joins
- Reduced rows examined
- Improved join operations using indexes

### User Playlist Analysis
Before indexing:
- Full table scan on Users
- Join buffer used for Playlists and PlaylistSongs
- Temporary table for GROUP BY

After indexing:
- Uses idx_users_subtype for filtering premium users
- Efficient joins using idx_playlists_userid and idx_playlistsongs_playlistid
- Reduced temporary table size
- Better join performance
