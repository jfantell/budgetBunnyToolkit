from config.DBConfig import getDbConnection
import os

USERNAME = os.getenv('SAMPLE_USERNAME')

with getDbConnection().cursor() as cursor:
    sql = f"""SELECT Username, AccountId, Accounts.UserId, Accounts.PlaidAccessCode, AccountName FROM Accounts
            INNER JOIN Users ON Accounts.UserId = Users.UserId WHERE Users.Username = '{USERNAME}';"""
    cursor.execute(sql)
    accountRecords = cursor.fetchall()
    print(accountRecords)