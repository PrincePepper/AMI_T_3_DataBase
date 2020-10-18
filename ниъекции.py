import psycopg2 as pg
import psycopg2.pool as pool

pg_pool = pool.SimpleConnectionPool(1, 20, user = "postgres", password = "admin")
con = pg_pool.getconn()

id = input()

cur = con.cursor()
cur.execute("SELECT * FROM flight WHERE id = %s", (id,))
for i in cur.fetchall():
    print(i)
con.commit()

pg_pool.putconn(con)




# 1; DROP TABLE student CASCADE; --
# cur.execute("SELECT * FROM flight WHERE id = %s", (id,))
