import duckdb

con = duckdb.connect(':memory:') # duckdb.connect('my_database.duckdb')

# Create
con.execute('''
    CREATE TABLE people (
        id INTEGER,
        name VARCHAR,
        age INTEGER
    );
''')

# Insert
con.execute("INSERT INTO people VALUES (1, 'Alice', 29), (2, 'Bob', 35), (3, 'Charlie', 40);")

# Fetch
result = con.execute("SELECT * FROM people").fetchall()

for row in result:
    print(row)