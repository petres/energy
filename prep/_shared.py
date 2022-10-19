import json
from pathlib import Path

configFile = "config.json"


def getConfig():
    f = Path(__file__).parents[0]/configFile
    with open(f) as json_file:
        data = json.load(json_file)
    return data