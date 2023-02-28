import os
import plaid
from plaid.api import plaid_api

######### PLAID API CONFIG SETUP #################
CLIENTID = os.getenv('PLAID_CLIENTID')
SECRET = os.getenv('PLAID_SECRET')

# Available environments are
# 'Production'
# 'Development'
# 'Sandbox'
configuration = plaid.Configuration(
    host=plaid.Environment.Development,
    api_key={
        'clientId': CLIENTID,
        'secret': SECRET,
    }
)
api_client = plaid.ApiClient(configuration)
client = plaid_api.PlaidApi(api_client)
