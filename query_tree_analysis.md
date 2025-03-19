# Complex Query Analysis and Optimization

## Selected Query
```sql
SELECT s.song_name, a.album_name, ar.artist_name
FROM Songs s
JOIN Albums a ON s.album_id = a.album_id
JOIN Artists ar ON a.artist_id = ar.artist_id
WHERE s.play_count > 1000 AND ar.verified = TRUE;
```

## Part 1: Query Analysis

### Parse Tree
```
SELECT
├── PROJECTION (song_name, album_name, artist_name)
├── JOIN
│   ├── JOIN
│   │   ├── Songs (s)
│   │   ├── ON (s.album_id = a.album_id)
│   │   └── Albums (a)
│   ├── ON (a.artist_id = ar.artist_id)
│   └── Artists (ar)
└── WHERE
    └── AND
        ├── s.play_count > 1000
        └── ar.verified = TRUE
```

### Relational Algebra Expression
```
π song_name, album_name, artist_name (
    σ play_count > 1000 ∧ verified = TRUE (
        Songs ⋈ album_id Albums ⋈ artist_id Artists
    )
)
```

### Initial Query Tree
```
           PROJECT (song_name, album_name, artist_name)
                        |
                      JOIN
                    /      \
                   /        \
                JOIN      Artists
              /     \         |
           Songs  Albums   σ verified=TRUE
             |
    σ play_count>1000
```

## Part 2: Query Optimization

### Optimization Steps

1. **Push Selection Operations Down**
```
           PROJECT (song_name, album_name, artist_name)
                        |
                      JOIN
                    /      \
                   /        \
                JOIN     σ verified=TRUE
              /     \         |
    σ play_count>1000  Albums  Artists
             |
           Songs
```

2. **Reorder Joins Based on Table Sizes**
   - Artists (smallest) → Albums → Songs (largest)
```
           PROJECT (song_name, album_name, artist_name)
                        |
                      JOIN
                    /      \
                   /        \
                JOIN     σ play_count>1000
              /     \         |
    σ verified=TRUE  Albums   Songs
             |
          Artists
```

3. **Add Index Support**
   - Create index on Songs(play_count)
   - Use existing indexes on album_id and artist_id
```sql
CREATE INDEX idx_songs_playcount ON Songs(play_count);
```

### Final Optimized Query
```sql
SELECT s.song_name, a.album_name, ar.artist_name
FROM Artists ar
JOIN Albums a ON ar.artist_id = a.artist_id
JOIN Songs s ON a.album_id = s.album_id
WHERE ar.verified = TRUE 
AND s.play_count > 1000;
```

## Performance Impact

1. **Selection Push-Down**
   - Reduces intermediate result sizes
   - Filters data earlier in execution

2. **Join Reordering**
   - Starts with smallest table (Artists)
   - Minimizes intermediate result sizes
   - Reduces memory usage

3. **Index Usage**
   - Enables index scan instead of table scan
   - Improves join performance
   - Speeds up WHERE clause evaluation

## Execution Plan Comparison

### Before Optimization
```
-> Nested loop join
   -> Table scan on Songs
   -> Index lookup on Albums
   -> Index lookup on Artists
```

### After Optimization
```
-> Nested loop join
   -> Index scan on Artists (verified=TRUE)
   -> Index lookup on Albums using artist_id
   -> Index lookup on Songs using album_id and play_count
```
