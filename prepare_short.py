import pandas as pd
import sqlite3

print("please run mysql2sqlite gcf_data_2102.sql | sqlite3 sqlite.db in data/short first")
con = sqlite3.connect("data/short/sqlite.db")
df = pd.read_sql_query("SELECT * FROM data", con)
df.to_pickle("data/short/pickle")