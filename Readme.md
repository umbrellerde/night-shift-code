# Setup

run `pipenv shell` to create a shell within the right env, or just use the editor tooling to do that automatically

# Getting the Data

**Our** data:

Get the SQL dump into `data/short/gcf_data.sql`, read it into `sqlite.db` using https://github.com/dumblob/mysql2sqlite: `mysql2sqlite gcf_data.sql | sqlite3 sqlite.db`.
Then run `python prepare_short.py` to prepare the raw data for analysis.

**Sebs** data:

Read what to do in `/sebs`

# Research

If you use this software in a publication, please cite it as:
## Text
Trever Schirmer, Nils Japke, Sofia Greten, Tobias Pfandzelter, and David Bermbach. The Night Shift: Understanding performance variability of cloud serverless platforms. In Proceedings of the 1st Workshop on Serverless Systems, Applications and Methodologies, SESAME ’23, New York, NY, USA, May 2023. ACM.
## BibTeX
```
@inproceedings{schirmer_2023_nightShift,
    author = "Schirmer, Trever and Japke, Nils and Greten, Sofia and Pfandzelter, Tobias and Bermbach, David",
    title = "The Night Shift: Understanding Performance Variability of Cloud Serverless Platforms",
    booktitle = "Proceedings of the 1st Workshop on Serverless Systems, Applications and Methodologies",
    month = may,
    year = 2023,
    publisher = "ACM",
    address = "New York, NY, USA",
    series = "SESAME '23",
    location = "Rome, Italy",
    numpages = "6",
    url = "https://doi.org/10.1145/3592533.3592808",
    doi = "10.1145/3592533.3592808",
}
```
