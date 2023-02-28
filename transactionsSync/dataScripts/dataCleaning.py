import pandas as pd

merchantNamesForShopping = [
    'Amazon',
    'Marshalls'
]

def extractPrimaryCategory(transaction):
    category = transaction.category
    transactionName = transaction.name
    primaryCategory = 'Unknown'
    if 'Food and Drink' in category or \
        'Food and Beverage' in category in category:
        primaryCategory = 'Food and Drink'
    elif 'Supermarkets and Groceries' in category \
        or 'Warehouses and Wholesale Stores' in category:
        primaryCategory = 'Supermarkets and Groceries'
    elif 'Recreation' in category:
        primaryCategory = 'Recreation'
    elif 'Gas Stations' in category:
        primaryCategory = 'Gas Stations'
    elif 'Cable' in category or 'Utilities' in category:
        primaryCategory = 'Utilities'
    elif 'Travel' in category:
        primaryCategory = 'Travel'
    elif any(merchantName in transactionName for merchantName in merchantNamesForShopping):
        primaryCategory = 'Shopping'
    elif 'Payment,Credit Card' in category:
        primaryCategory = 'Credit Card'
    elif 'Automotive' in category:
        primaryCategory = 'Automotive'
    elif 'Pharmacies' in category:
        primaryCategory = 'Pharmacies'
    elif 'Transfer' in category:
        primaryCategory = 'Transfer'
    elif 'Insurance' in category:
        primaryCategory = 'Insurance'
    elif 'Business Services' in category:
        primaryCategory = 'Business Services'
    elif 'Personal Care' in category:
        primaryCategory = 'Personal Care'
    elif 'Shops,Digital Purchase' in category or 'Service' in category:
        primaryCategory = 'Service'
    elif 'Education' in category:
        primaryCategory = 'Education'
    return primaryCategory

def splitLocationInfo(row):
    return row['address'], row['city'], \
        row['region'], row['postal_code'], \
        row['lat'], row['lon'], row['country'], \
        row['store_number']

def processTransactionsForDB(transactions_df, accountOwnerUsername, accountName):
    # Convert category values from lists to strings
    transactions_df['category'] = transactions_df['category'].apply(lambda x: ",".join(x))
    # Create a primary category column
    transactions_df.insert(5, "primary_category", [extractPrimaryCategory(transaction) \
        for transaction in transactions_df.itertuples()], True)
    # Re-order columns to match order of columns in db table
    transactions_df = transactions_df[['transaction_id', 'name', 'merchant_name','primary_category', \
        'category','category_id','account_id','account_owner','amount','pending','authorized_datetime', \
            'datetime','pending_transaction_id','iso_currency_code', 'unofficial_currency_code', \
                'payment_channel','payment_meta', 'location','transaction_code','transaction_type', \
                    'check_number', 'personal_finance_category']]
    # Rename certain columns to match names in db table
    transactions_df = transactions_df.rename(columns={'category':'categories','pending':'is_pending'})
    # Convert all column names to camel case form
    transactions_df.columns = map(lambda x: x.title().replace('_',''), transactions_df.columns)
    # Add columns not included in the Plaid API
    transactions_df['ShouldHide'] = False
    transactions_df['IsForecastedTransaction'] = False
    transactions_df['ShouldEstimate'] = True
    transactions_df['Aggregate'] = False
    transactions_df['Placeholder'] = False
    transactions_df['IsFinalized'] = False
    transactions_df['Description'] = None
    # Split location into multiple columns
    transactions_df[['Address', 'City','Region', 'PostalCode', 'Lat', 'Lon', 'Country', 'StoreNumber']] = \
        transactions_df["Location"].apply(lambda x: pd.Series(splitLocationInfo(x)))
    # Drop original location and paymentMeta columns
    transactions_df.drop(columns=['Location','PaymentMeta'],inplace=True)
    # Account Owner should be username
    transactions_df['AccountOwner'] = accountOwnerUsername
    transactions_df['AccountName'] = accountName
    # Replace nans with nones for SQL compatibility 
    transactions_df['Lat'] = None
    transactions_df['Lon'] = None
    # Dates need to be strings for SQL compatibility
    transactions_df['AuthorizedDatetime'] = transactions_df['AuthorizedDatetime'].astype(str)
    transactions_df['Datetime'] = transactions_df['Datetime'].astype(str)
    # Make TransactionId the table index
    transactions_df = transactions_df.set_index('TransactionId',drop=True)
    return transactions_df