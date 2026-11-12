# ✅ Database Setup Complete - Ready for Task 3

## 🐳 PostgreSQL Status

**✅ Container**: `libratrack-db` is running and healthy
**📊 Port**: 5432 (listening on localhost)
**🔑 Credentials**:
- User: `postgres`
- Password: `postgres`
- Database: `libratrack`

---

## 🔍 Verify Database Setup (Using pgAdmin4)

### Step 1: Open pgAdmin4
1. Go to http://localhost:5050 (if running locally)
2. Or use your installed pgAdmin4 application

### Step 2: Add New Server Connection
1. Right-click "Servers" → **Register** → **Server**
2. Fill in:
   - **Name**: `libratrack-dev`
   - **Host name/address**: `localhost`
   - **Port**: `5432`
   - **Username**: `postgres`
   - **Password**: `postgres`
   - **Save password**: ✓ Yes

### Step 3: Verify Tables Exist
1. Expand: Servers → libratrack-dev → Databases → libratrack → Schemas → public → Tables
2. You should see:
   - ✅ `authors`
   - ✅ `book_authors`
   - ✅ `books`
   - ✅ `categories`

### Step 4: Verify Seed Data

Run these queries in pgAdmin4 Query Tool:

```sql
-- Check categories
SELECT * FROM categories;
-- Expected: 3 rows (Fiction, Non-Fiction, Science Fiction)

-- Check authors  
SELECT COUNT(*) as author_count FROM authors;
-- Expected: 5 rows

-- Check books
SELECT COUNT(*) as book_count FROM books;
-- Expected: 10 rows

-- Check relationships
SELECT COUNT(*) as relationship_count FROM book_authors;
-- Expected: 9 rows
```

---

## 🚀 Next: Task 3 - N+1 Query Detection & Fix

### What is N+1?
When you fetch a list of books, the normal way would be:
- 1 query: `SELECT * FROM books` → Gets 10 books
- N queries: For each book, `SELECT * FROM authors WHERE ...` → 10 more queries
- N queries: For each book, `SELECT * FROM categories WHERE ...` → 10 more queries
- **Total: 1 + 10 + 10 = 21 queries** ❌

With `Preload()`:
- Single smart query with JOINs → Gets everything at once
- **Total: 2-3 queries** ✅

### Task 3 Steps:

1. **Enable SQL Logging** (see the actual queries being run)
2. **Test with current code** (with Preload already enabled)
3. **Observe**: You'll see only 2-3 queries
4. **This shows you WHY Preload matters**

---

## 🛠️ Getting the Go App Ready

### Step 1: Download Dependencies
```bash
cd go-with-genAI-L8
go mod download
go mod tidy
```

### Step 2: Add SQL Logging to main.go (for Task 3)

We'll modify `cmd/api/main.go` to add GORM logging.

**Update this section in main.go**:

```go
import (
    "gorm.io/gorm"
    "gorm.io/gorm/logger"    // ← ADD THIS
)

// In ConnectDB function in config.go:
db, err := gorm.Open(postgres.Open(c.GetDSN()), &gorm.Config{
    Logger: logger.Default.LogMode(logger.Info),  // ← ADD THIS LINE
})
```

This will print every SQL query to stdout, so you can see them!

### Step 3: Run the App
```bash
go run cmd/api/main.go
```

**Expected output**:
```
✅ Connected to PostgreSQL: localhost:5432/libratrack
📊 Connection pool: MaxOpenConns=25, MaxIdleConns=5
🚀 listening on :8080
```

### Step 4: Test with Curl (or Postman)
```bash
# List all books (this is where N+1 happens)
curl http://localhost:8080/api/v1/books

# OR create a book
curl -X POST http://localhost:8080/api/v1/books \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Test Book",
    "category_id": 1,
    "author_ids": [1, 2]
  }'
```

### Step 5: Watch the SQL Logs
Look at your terminal where the API is running. You should see SQL queries:
- With Preload: 2-3 queries total
- Without Preload: 1 + N + N queries

---

## 📝 Quick Checklist Before Task 3

- ✅ Docker container running: `docker-compose ps` shows healthy
- ✅ PostgreSQL accessible: Can connect from pgAdmin4
- ✅ Seed data loaded: 10 books, 5 authors, 3 categories
- ✅ Go dependencies installed: `go mod download`
- ✅ Code has Preload statements (already added in book_gorm.go)

---

## 🎯 Task 3 Will Show:

1. **Current state**: Queries with Preload (fast) ✅
2. **The problem**: Temporarily remove Preload to see N+1 ❌
3. **The fix**: Add back Preload (fast again) ✅
4. **The learning**: Understand query optimization deeply

---

## ⚡ Quick Commands Reference

```bash
# Check Docker status
docker-compose ps

# View PostgreSQL logs
docker-compose logs postgres

# View API logs
docker-compose logs api

# Stop everything
docker-compose down

# Stop only PostgreSQL
docker-compose stop postgres

# Restart everything
docker-compose restart

# Remove everything (careful!)
docker-compose down -v
```

---

## 📞 Troubleshooting

### "Connection refused"
- Check: `docker-compose ps` shows healthy
- Restart: `docker-compose restart postgres`
- Wait 10 seconds for health check

### "database libratrack does not exist"
- The migrations should have created it
- If not, manually run `migrations/000001_init_schema.up.sql` in pgAdmin4

### "No tables in database"
- Run SQL migration in pgAdmin4
- Copy content of `migrations/000001_init_schema.up.sql`
- Paste into Query Tool and Execute

---

## ✅ Ready for Task 3!

Once you've verified the database and your app can run, we're ready to:
1. Enable SQL logging
2. Test the N+1 behavior
3. Demonstrate the fix with Preload
4. Write the analysis report

Let me know when you're ready! 🚀
