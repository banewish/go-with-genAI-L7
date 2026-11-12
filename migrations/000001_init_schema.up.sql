-- Create authors table
CREATE TABLE IF NOT EXISTS authors (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    bio TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create categories table
CREATE TABLE IF NOT EXISTS categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create books table with normalized structure
CREATE TABLE IF NOT EXISTS books (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    isbn VARCHAR(20),
    category_id INTEGER NOT NULL,
    published_date DATE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_books_category FOREIGN KEY (category_id) 
        REFERENCES categories(id) ON DELETE RESTRICT
);

-- Create join table for Many-to-Many relationship between books and authors
CREATE TABLE IF NOT EXISTS book_authors (
    book_id INTEGER NOT NULL,
    author_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (book_id, author_id),
    CONSTRAINT fk_book_authors_book FOREIGN KEY (book_id) 
        REFERENCES books(id) ON DELETE CASCADE,
    CONSTRAINT fk_book_authors_author FOREIGN KEY (author_id) 
        REFERENCES authors(id) ON DELETE CASCADE
);

-- Create indexes for optimal query performance
CREATE INDEX idx_books_category_id ON books(category_id);
CREATE INDEX idx_book_authors_book_id ON book_authors(book_id);
CREATE INDEX idx_book_authors_author_id ON book_authors(author_id);

-- Seed data
INSERT INTO categories (name) VALUES
    ('Fiction'),
    ('Non-Fiction'),
    ('Science Fiction');

INSERT INTO authors (full_name, bio) VALUES
    ('George Orwell', 'British author of dystopian novels'),
    ('Jane Austen', 'English novelist of the Romantic era'),
    ('Isaac Asimov', 'American biochemist and prolific science fiction author'),
    ('Haruki Murakami', 'Japanese contemporary fiction writer'),
    ('Margaret Atwood', 'Canadian author known for speculative fiction');

INSERT INTO books (title, isbn, category_id, published_date, description) VALUES
    ('1984', '978-0451524935', 1, '1949-06-08', 'A dystopian novel set in a totalitarian society'),
    ('Pride and Prejudice', '978-0141439518', 1, '1813-01-28', 'A romantic novel of manners'),
    ('Foundation', '978-0553293357', 3, '1951-06-01', 'Science fiction involving a galactic empire'),
    ('Norwegian Wood', '978-0099448366', 1, '1987-09-04', 'A narrative centered around several nostalgic scenes'),
    ('The Handmaid''s Tale', '978-0385490818', 1, '1985-06-17', 'Speculative fiction set in a dystopian future'),
    ('Robot Dreams', '978-0553278256', 3, '1986-01-01', 'Collection of science fiction short stories'),
    ('Sense and Sensibility', '978-0141435244', 1, '1811-10-30', 'A romantic novel about two sisters'),
    ('The End of Eternity', '978-0553293371', 3, '1955-06-01', 'A science fiction novel exploring time travel'),
    ('Kafka on the Shore', '978-0099458319', 1, '2002-09-12', 'A contemporary fiction work'),
    ('Dune', '978-0441172719', 3, '1965-06-01', 'Epic science fiction about political intrigue on a desert planet');

-- Insert book-author relationships
INSERT INTO book_authors (book_id, author_id) VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5),
    (6, 3),
    (7, 2),
    (8, 3),
    (9, 4);
