import base64
import datetime
import json
from typing import Any, Dict, Optional
import uuid
import requests
from robin_stocks import robinhood as rh  # Verify with your account and the official docs
try:
    from dotenv import load_dotenv
except Exception:
    # python-dotenv is not installed; provide a no-op fallback to avoid import errors.
    def load_dotenv(*args, **kwargs):
        return False
import os
import time

def main():
    while True:
        print("Loop tick...")
        time.sleep(1)  # wait 1 second

if __name__ == "__main__":
    main()