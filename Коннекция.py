import psycopg2 as pg


con = pg.connect(user = "postgres", password = "admin")


cur = con.cursor()
cur.execute("SELECT * FROM Flight")
for line in cur.fetchall():
    print(line)







