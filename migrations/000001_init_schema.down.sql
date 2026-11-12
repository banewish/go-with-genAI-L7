-- Drop indexes first
DROP INDEX IF EXISTS idx_book_authors_author_id;
DROP INDEX IF EXISTS idx_book_authors_book_id;
DROP INDEX IF EXISTS idx_books_category_id;

-- Drop tables in reverse order of dependencies
DROP TABLE IF EXISTS book_authors;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS authors;
