import psycopg2 as pg


cons = []
for i in range(80):
    con = pg.connect(user = "postgres", password = "admin")
    cons.append(con)

    cur = con.cursor()
    cur.execute("SELECT * FROM Flight")
    con.close()
    print(i)

input()






