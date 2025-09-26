PGPASSWORD='' psql \
  -h "<db-endpoint>" \
  -p 5432 \
  -U admin \
  -d postgres


# Show current database and user
SELECT current_database(), current_user;

# Show server version
SELECT version();

# Create a  table
CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    enrolled_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

# Insert some data
INSERT INTO students (name, email) 
VALUES 
('Alice', 'alice@example.com'),
('Bob', 'bob@example.com');

## Query data
# Select all rows
SELECT * FROM students;

# Select with condition
SELECT * FROM students WHERE name = 'Alice';
