from dotenv import load_dotenv

# Load environmental variables
load_dotenv('../.env')

from typing import Dict
import pandas as pd
from multiprocessing import Pool
import os
from dataScripts.splitTransaction import splitTransactionByCategory
from dataScripts.dataAcquisition import acquireTransactions, getAccountsForUsername
from dataScripts.dataCleaning import processTransactionsForDB
from dataScripts.dataUploading import addDataToDB

def executeSync(account: Dict):
    try:
        transactions = acquireTransactions(account)

        # Convert each transaction from a Plaid Transaction object to 
        # a dictionary such that we can work with the transactions
        # in a Pandas dataframe
        transactions_dict_list = []
        for tx in transactions:
            transactions_dict_list.append(tx.to_dict())

        # Create a Pandas dataframe from the transactions
        transactions_df = pd.DataFrame.from_dict(transactions_dict_list)

        # Clean Data For Database
        transactions_df = processTransactionsForDB(transactions_df, account['Username'], account['AccountName'])

        # Split transactions
        splitTransactionByCategory(transactions_df)

        # Add Data to DB
        addDataToDB(account, transactions_df)
        return 0
    except Exception as e:
        print(f"An error has occured processing transactions for {account['Username']}")
        print(e)
        return 1

def scheduleSync():
    usernamesStr = os.getenv('USERNAMES')
    usernames  = usernamesStr.split(',')
    for username in usernames:
        accountRecords = getAccountsForUsername(username)
        with Pool(5) as p:
            print(p.map(executeSync, accountRecords))

if __name__ == '__main__':
    scheduleSync()