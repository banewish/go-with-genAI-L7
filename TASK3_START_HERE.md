# 🎯 Ready for Task 3: N+1 Query Detection & Analysis

## ✅ Task 2 is Complete!

Everything you need for Task 3 is ready to go:
- ✅ PostgreSQL running with seed data
- ✅ API server running with SQL logging enabled  
- ✅ GORM repository with Preload already implemented
- ✅ Two Docker containers coordinating

---

## 📚 Task 3: What You Need to Do (Manual Work)

### The Goal
**Understand and demonstrate the N+1 query problem**, then show how Preload fixes it.

### The Learning Process

#### Step 1: Understand the Problem
Without Preload, when you fetch a list of books:
- 1 query: `SELECT * FROM books` 
- N queries: For each book, fetch its category
- N queries: For each book, fetch its authors
- **Total: 1 + N + N queries** (very slow!) ❌

With Preload:
- ~2-3 queries total using smart JOINs
- Gets everything at once (very fast!) ✅

#### Step 2: Watch the Logs (SQL Logging Already Enabled)

The API is already logging every SQL query to stdout. You'll see them when you make requests.

To see the logs:
```bash
docker-compose logs api
```

Or watch them live:
```bash
docker-compose logs -f api
```

#### Step 3: Make a Test Request

The handler layer might not be fully wired yet for Book endpoints. For now, just understand:

1. **SQL logging is visible** - Every query shows timing and row counts
2. **Preload is in place** - In `internal/repository/book_gorm.go`:
   ```go
   .Preload("Category").
   .Preload("Authors")
   ```

#### Step 4: The Manual Work

**For Task 3, you will:**

1. **Analyze the current code**
   - Look at `book_gorm.go` and see the Preload statements
   - Understand how they work

2. **Temporarily remove Preload** (to see the problem)
   ```go
   // Comment out these lines:
   // .Preload("Category").
   // .Preload("Authors")
   ```

3. **Count the queries**
   - Make a request
   - Watch SQL logs
   - Count: 1 + 10 + 10 = 21 queries ❌

4. **Add back Preload** (to see the fix)
   - Uncomment the lines
   - Count again: 2-3 queries ✅

5. **Document your findings**
   - Create a report showing both states
   - Include screenshot or copy of logs
   - Explain the difference

---

## 🔍 Where to Look

### SQL Logging Output
Run this to see what queries the database is receiving:
```bash
docker-compose logs -f api | grep "SELECT\|INSERT\|UPDATE"
```

You'll see entries like:
```
[123.456ms] [rows:10] SELECT * FROM books...
[45.678ms] [rows:1] SELECT * FROM categories WHERE id = ?
```

The timing in `[...]ms` shows how long each query took.

### Code to Study
1. `internal/repository/book_gorm.go` - Lines 56-62 (List method with Preload)
2. `internal/repository/book_gorm.go` - Lines 47-54 (FindByID with Preload)

See how Preload is used:
```go
r.db.WithContext(ctx).
    Preload("Category").      // ← This loads category in the same query
    Preload("Authors").       // ← This loads authors in the same query
    Find(&books).Error
```

---

## 📊 Expected Results

### Current State (With Preload - What You Have)
```
Fetching 10 books:
[156ms] SELECT b.*, c.* FROM books b 
        LEFT JOIN categories c ON b.category_id = c.id...
[89ms]  SELECT a.*, ba.* FROM authors a 
        JOIN book_authors ba ON a.id = ba.author_id...
Total: 2 queries
Response time: ~250ms
```

### Problem State (Without Preload - What Task 3 Shows)
```
Fetching 10 books:
[45ms]  SELECT * FROM books  ← Get books
[12ms]  SELECT * FROM categories WHERE id = 1  ← Query 1
[11ms]  SELECT * FROM categories WHERE id = 1  ← Query 2 (same!)
...
[11ms]  SELECT * FROM categories WHERE id = 3  ← Query 10
[10ms]  SELECT * FROM authors JOIN book_authors WHERE book_id = 1
[10ms]  SELECT * FROM authors JOIN book_authors WHERE book_id = 2
...
[10ms]  SELECT * FROM authors JOIN book_authors WHERE book_id = 10
Total: 21 queries
Response time: ~300ms
```

---

## 🛠️ How to Run Task 3

### Scenario A: Analysis Only (Recommended First)
1. Study the Preload code in `book_gorm.go`
2. Explain what each line does
3. Document how it prevents N+1

### Scenario B: Full Demonstration
1. Modify `book_gorm.go` List() method - remove Preload temporarily
2. Rebuild: `docker-compose build api && docker-compose up -d api`
3. Check logs while it runs
4. Add back Preload
5. Rebuild again and compare

### Scenario C: Without Docker
If you prefer local testing:
1. Set environment variables pointing to localhost:5432
2. Run `go run cmd/api/main.go`
3. Watch the logs in terminal
4. Modify code and re-run to compare

---

## 📋 Task 3 Deliverables (What to Submit)

You need to create a report showing:

1. **The Problem Explained**
   - What is N+1?
   - Why does it happen?
   - How does it affect performance?

2. **Code Evidence**
   - Show the Preload code from `book_gorm.go`
   - Show the SQL queries generated (from logs or documentation)

3. **Performance Comparison**
   - Query count with Preload: ~2-3
   - Query count without Preload: 1 + N + N
   - Response time difference

4. **Analysis**
   - Why is Preload better?
   - When would you use it?
   - Are there alternatives?

5. **Conclusion**
   - Summary of findings
   - Recommendations

---

## 💡 Tips for Task 3

### Understanding Query Logs
```
[13.456ms] [rows:10] SELECT * FROM "books" ...
```
Breaking this down:
- `[13.456ms]` = Query took 13.456 milliseconds
- `[rows:10]` = Query returned 10 rows
- `SELECT * FROM "books"` = The actual query

### Comparing Performance
Count query time:
- **With Preload**: 156ms + 89ms = 245ms total (2 queries)
- **Without Preload**: 45ms + 120ms + 100ms = 265ms (21 queries)

The difference gets bigger with more books!

### Why Preload Matters
For 1000 books:
- **With Preload**: 2-3 queries, ~500ms
- **Without Preload**: 2001 queries, ~30+ seconds

---

## ✅ Task 3 Pre-Flight Checklist

Before starting Task 3, verify:

- ✅ Both Docker containers are running
- ✅ PostgreSQL has seed data (10 books)
- ✅ API is logging queries to stdout
- ✅ You can see SQL in `docker-compose logs api`
- ✅ You understand Preload concept
- ✅ You have access to edit `book_gorm.go`
- ✅ You can rebuild the container with `docker-compose build api`

---

## 🎯 Next Steps

1. **Familiarize Yourself**
   - Read `book_gorm.go` carefully
   - Understand what Preload does
   - Look at the List() method

2. **Analyze the Current State**
   - Verify SQL logging is working
   - Note that it's fast (with Preload)
   - Document query count and timing

3. **Make the Comparison** (if doing full demo)
   - Temporarily remove Preload
   - Observe the performance hit
   - Add back Preload to show the fix

4. **Write Your Report**
   - Explain the findings
   - Include evidence (SQL logs)
   - Document the lesson learned

---

## 📞 Quick Reference

### Check Database Connection
```bash
docker-compose exec -T postgres psql -U postgres -d libratrack \
  -c "SELECT COUNT(*) FROM books;"
```

### View API Logs
```bash
docker-compose logs -f api
```

### Rebuild After Code Changes
```bash
docker-compose build api
docker-compose up -d api
```

### Stop Everything
```bash
docker-compose down
```

### View SQL Queries Only
```bash
docker-compose logs api | grep "SELECT\|INSERT\|UPDATE\|DELETE"
```

---

## 🎓 Learning Outcomes

After Task 3, you will understand:
- ✅ What N+1 queries are
- ✅ Why they're a performance problem
- ✅ How GORM's Preload solves it
- ✅ How to read query logs
- ✅ How to measure query performance
- ✅ When to use eager loading vs lazy loading

---

**You're ready to start Task 3!** 🚀

Everything is set up and running. The hard part (infrastructure) is done. Task 3 is about learning and analysis. Enjoy! 📚
