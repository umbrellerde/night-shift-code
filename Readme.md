# Setup

run `pipenv shell` to create a shell within the right env, or just use the editor tooling to do that automatically

# Getting the Data

**Our** data:

Get the SQL dump into `data/short/gcf_data.sql`, read it into `sqlite.db` using https://github.com/dumblob/mysql2sqlite: `mysql2sqlite gcf_data.sql | sqlite3 sqlite.db`.
Then run `python prepare_short.py` to prepare the raw data for analysis.

**Sebs** data:

Read what to do in `/sebs`