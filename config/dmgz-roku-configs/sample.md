Copy and paste into a new file called secrets.env

ROBINHOOD_API_KEY = "your key"
BASE64_PRIVATE_KEY = "your key"
ROBINHOOD_API_KEY_TEST = "your key"
BASE64_PRIVATE_KEY_TEST = "your key"
BASE64_PRIVATE_KEY_ORIG = "your key"
PUBLIC_KEY_BASE64 = "your key"
PRIVATE_KEY_BASE64_4_20_2025 = "your key"
PUBLIC_KEY_BASE64_4_20_202 = "your key"
API_KEY_REAL = "your key"

Save as secrets.env

Sample Code

        import os
        from dotenv import load_dotenv  

            load_dotenv(dotenv_path='../config/dmgz-roku-configs/secrets.env')
            API_KEY = os.getenv('ROBINHOOD_API_KEY_TEST')
            BASE64_PRIVATE_KEY = os.getenv('BASE64_PRIVATE_KEY_TEST')
