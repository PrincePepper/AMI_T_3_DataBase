import psycopg2 as pg
import psycopg2.pool as pool

pg_pool = pool.SimpleConnectionPool(1, 20, user = "postgres", password = "admin")
con = pg_pool.getconn()

cur = con.cursor()
cur.execute("UPDATE flight SET spacecraft_id = 6 WHERE id = 209")
con.commit()

pg_pool.putconn(con)


