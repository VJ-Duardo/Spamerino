import json
import subprocess
import sys

def return_json_obj():
    with open('../saves/content.json', 'r', encoding='utf-8') as file:
        return json.loads(file.read())

def read():
    json_obj = return_json_obj()
    send_list = ['spamerino.exe']
    for i in range(0, len(json_obj['saves']), 1):
        list_elem = json_obj['saves'][i]
        send_list.extend((list_elem['name'], list_elem['content'], list_elem['before'], list_elem['after']))

    subprocess.call(send_list)


if sys.argv[1] == 'read':
    read()
