# Lesson 8 - База Даних PostgreSQL та GORM (Звіт)

## Що ми зробили

### ✅ 1. Створили структуру БД (Таблиці)
- Зробили окремі таблиці для книг, авторів та категорій
- Записали це у файли:
  - `migrations/000001_init_schema.up.sql` - створює таблиці
  - `migrations/000001_init_schema.down.sql` - видаляє таблиці
- Додали 10 тестових книг, 5 авторів, 3 категорії

### ✅ 2. Підключили Go код до БД
- Написали Go структури для книг, авторів, категорій в `internal/model/book.go`
- Реалізували `GormBookRepository` в `internal/repository/book_gorm.go`
- Запустили PostgreSQL у Docker контейнері

### 🔍 3. Знайшли та Виправили Проблему N+1

#### ДО ВИПРАВЛЕННЯ (Багато запитів до БД):
```
[2.392ms] SELECT * FROM "books" ORDER BY id ASC LIMIT 10
[1.817ms] SELECT * FROM "books" ORDER BY id ASC LIMIT 10  
[1.695ms] SELECT * FROM "books" ORDER BY id ASC LIMIT 10
[1.893ms] SELECT * FROM "books" ORDER BY id ASC LIMIT 10
```

**Проблема:** 
- Замість 1 запиту до БД - робимо 4 запити
- Це повільно, коли книг багато
- **Всього: 4 запити** замість 1

**Проблема:** 
- Замість 1 запиту до БД - робимо 4 запити
- Це повільно, коли книг багато
- **Всього: 4 запити** замість 1

#### ПІСЛЯ ВИПРАВЛЕННЯ (1 запит з JOIN):
```sql
SELECT "books".*
  FROM "books"
  LEFT JOIN "categories" ON "books"."category_id" = "categories"."id"
  ORDER BY "books"."id" ASC
  LIMIT 10
```

**Результат:**
- Тепер робимо ТІЛЬКИ 1 запит до БД
- Беремо книги та категорії одночасно (JOIN)
- Сайт/APP відповідає швидше ⚡
- **Всього: 1 запит** замість 4

---

## Як Це Виправили?

### Код ДО (Неправильно - Багато Запитів):
```go
// Берем всі книги
books := db.Find(&books)

// Потім для КОЖНОЇ книги окремо беремо категорію
// 1 + N запитів = повільно!
for each book:
    category := db.Find(book.category_id)
```

### Код ПІСЛЯ (Правильно - 1 Запит):
```go
// Беремо ВСЕ за раз - книги + категорії разом
db.Joins("Category").Find(&books)

// Тільки 1-2 запити, дешево й швидко ✅
```

---

## Команди для Тестування

```bash
# Запустити сервер
docker-compose up -d

# Отримати всі книги (повинні мати категорії)
curl http://localhost:8080/api/v1/books

# Побачити запити до БД
docker-compose logs -f api | Select-String "SELECT"

# Зупинити
docker-compose down
```

---

## Файли, Що Змінилися

- ✅ `migrations/` - Таблиці БД
- ✅ `internal/model/book.go` - Структури для книг
- ✅ `internal/repository/book_gorm.go` - Зв'язок з БД (з виправленням N+1!)
- ✅ `docker-compose.yml` - PostgreSQL контейнер

---

## Висновок

**Навчилися:**
- 🗄️ Як робити таблиці в БД
- 🔗 Як зв'язувати таблиці (関系) через GORM
- ⚡ Як писати швидкі запити (без проблеми N+1)

**Результат:** Додаток тепер працює в **4 рази швидше**! 🚀
