import psycopg2.pool as pool
import random

pg_pool = pool.SimpleConnectionPool(1, 20, user = "postgres", password = "admin")
for i in range(100):
    try:
        con = pg_pool.getconn()
        cur = con.cursor()
        cur.execute("SELECT * FROM Flight")
        print(i)
        a = 1 / random.randint(0, 3)
    except ZeroDivisionError:
        print("Деление на 0")
    finally:
        pg_pool.putconn(con)


input()






