import pandas as pd
import os

USER1_SHARE_COLUMN = os.getenv('USER1_SHARE_COLUMN')
USER2_SHARE_COLUMN = os.getenv('USER2_SHARE_COLUMN')

def splitTransactionByCategory(df: pd.DataFrame):
    categories_to_split = [
        'Travel',
        'Food and Drink',
        'Supermarkets and Groceries',
        'Utilities',
        'Gas Stations',
        'Insurance',
        'Pet'
    ]
    df.loc[df['PrimaryCategory'].isin(categories_to_split),USER1_SHARE_COLUMN]= df['Amount'] / 2.
    df.loc[df['PrimaryCategory'].isin(categories_to_split),USER2_SHARE_COLUMN] = df['Amount'] / 2.