import json
from pathlib import Path

config_file = "config.json"

def getConfig():
    f = Path(__file__).parents[0]/config_file
    with open(f) as json_file:
        data = json.load(json_file)
    return data
