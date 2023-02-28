from typing import Dict
from plaid.model.transactions_get_request import TransactionsGetRequest
from plaid.model.transactions_get_request_options import TransactionsGetRequestOptions
from datetime import datetime
import pymysql
from config.PlaidConfig import client
from config.DBConfig import getDbConnection

START_DATE = datetime.strptime('2020-01-01', '%Y-%m-%d').date()
END_DATE = datetime.strptime('2024-01-01', '%Y-%m-%d').date()

def acquireTransactions(account: Dict):
    # Fetch the data from the Plaid API
    # Transactions will be fetched in batches of 100
    request = TransactionsGetRequest(
            access_token=account['PlaidAccessCode'],
            start_date=START_DATE,
            end_date=END_DATE,
            options=TransactionsGetRequestOptions()
    )
    response = client.transactions_get(request)
    transactions = response['transactions']

    # Manipulate the count and offset parameters to paginate
    # transactions and retrieve all available data
    while len(transactions) < response['total_transactions']:
        request = TransactionsGetRequest(
                    access_token=account['PlaidAccessCode'],
                    start_date=datetime.strptime('2020-01-01', '%Y-%m-%d').date(),
                    end_date=datetime.strptime('2023-01-01', '%Y-%m-%d').date(),
                    options=TransactionsGetRequestOptions(
                    offset=len(transactions)
                )
        )
        response = client.transactions_get(request)
        transactions.extend(response['transactions'])
    
    print(f"Acquired {len(transactions)} transactions from Plaid for {account['Username']}")
    return transactions

def getAccountsForUsername(username: str):
    with getDbConnection() as connection:
        with connection.cursor(pymysql.cursors.DictCursor) as cursor:
            sql = f"""SELECT Username, AccountId, Accounts.UserId, Accounts.PlaidAccessCode, AccountName FROM Accounts
                    INNER JOIN Users ON Accounts.UserId = Users.UserId WHERE Users.Username = '{username}';"""
            cursor.execute(sql)
            accountRecords = cursor.fetchall()
            return accountRecords