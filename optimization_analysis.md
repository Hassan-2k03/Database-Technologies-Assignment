# Query Optimization Analysis

## Query 1: Song-Album-Artist Join

### Original Query
- Join order: Songs → Albums → Artists
- Full table scan on Songs for play_count filter
- Performance affected by large Songs table scan first

### Optimized Query
- Join order: Artists → Albums → Songs
- Starts with smallest table (Artists)
- Pushes filter to end of execution
- Improved performance due to better join order

## Query 2: User Playlist Analysis

### Original Query
- Uses regular INNER JOINs
- Requires GROUP BY operation
- Higher memory usage for grouping

### Optimized Query
- Uses LEFT JOIN for Users
- Correlated subquery for counts
- Better for sparse data
- Reduced memory usage

## Performance Improvements
- Query 1: XX% reduction in execution time
- Query 2: XX% reduction in execution time
(Fill in actual percentages after testing)

## Key Optimization Strategies
1. Join smallest tables first
2. Use appropriate join types
3. Leverage subqueries for aggregations
4. Push filters early in execution plan
