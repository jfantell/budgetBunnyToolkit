from config.DBConfig import getDbConnection

def generateSqlColumnStr(columnNames):
    columnNamesStr = ",".join(columnNames)
    columnNamesStr = '(' + columnNamesStr + ')'
    return columnNamesStr

def generateSqlValuePlaceholderStr(columnNames):
    valuesPlaceholderStr = "(" + ",".join(['%s' for _ in range(len(columnNames))]) + ")"
    return valuesPlaceholderStr

def generateSqlRecords(transactions_df):
    records = transactions_df.fillna('').reset_index().values.tolist()
    return records

def addDataToDB(account, transactions_df):
    columnNames = transactions_df.reset_index().columns
    columnNamesStr = generateSqlColumnStr(columnNames)
    valuesPlaceholderStr = generateSqlValuePlaceholderStr(columnNames)
    records = generateSqlRecords(transactions_df)
    with getDbConnection() as connection:
        with connection.cursor() as cursor:
            sql = f"INSERT IGNORE INTO `Transactions` {columnNamesStr} VALUES {valuesPlaceholderStr}"
            cursor.executemany(sql, records)
        connection.commit()
        print(f"Added transactions to DB for {account['Username']}")    