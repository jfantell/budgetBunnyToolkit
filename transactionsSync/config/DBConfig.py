import pymysql
import os

# Configure MySQL database
HOST=os.getenv('DB_HOST')
USER=os.getenv('DB_USER')
PASSWORD=os.getenv('DB_PASSWORD')
DATABASE=os.getenv('DB_NAME')

def getDbConnection():
    return pymysql.connect(host=HOST, user=USER, \
        password=PASSWORD, database=DATABASE)