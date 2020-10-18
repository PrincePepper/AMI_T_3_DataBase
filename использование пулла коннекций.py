import psycopg2 as pg
import psycopg2.pool as pool

pg_pool = pool.SimpleConnectionPool(1, 20, user = "postgres", password = "admin")
cons = []
for i in range(100):
    con = pg_pool.getconn()
    cons.append(con)

    cur = con.cursor()
    cur.execute("SELECT * FROM Flight")
    print(i)

input()






