import base64
import datetime
import json
from typing import Any, Dict, Optional
import uuid
import requests
import os
import time
from nacl.signing import SigningKey

def main():
    while True:
        print("... Loop tick...BTC price fetch ...")
        print("Fetching BTC price... TASK START")
        print("We need to keep the loop running as long running task for testing" )
        print("... Observible log entry ...")
        time.sleep(1)  # wait 1 second
        print("... order = api_trading_client.setup_order... TESTING LOG ENTRY ...")
        # TASK 101: Fetch BTC price from a public API
        try:
            
            url = "https://api.coindesk.com/v1/bpi/currentprice.json"
            response = requests.get(url)
            data = response.json()
            btc_price = data["bpi"]["USD"]["rate"]
            print(f"Current BTC Price in USD: {btc_price}")
            print("BTC Price (USD):", data["bpi"]["USD"]["rate"])

        except requests.RequestException as e:
            print(f"Error fetching BTC price: {e}")

if __name__ == "__main__":
    main()