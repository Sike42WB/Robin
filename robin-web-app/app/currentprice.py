import requests

tempLink = "https://data-api.coindesk.com//onchain/v2/data/by/address?chain_asset=ETH&address=0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2&asset_lookup_priority=SYMBOL&quote_asset=USD"

response = requests.get(
    "https://min-api.cryptocompare.com/data/price",
    params={"fsym":"BTC","tsyms":"USD,JPY,EUR","api_key":"b0770f4d6f634c2ad5dfd3d512fb60d5614229fb16608cc172823c9a5382c4e6"},
    headers={"Content-type":"application/json; charset=UTF-8"}
)

json_response = response.json()