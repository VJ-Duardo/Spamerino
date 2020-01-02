import json
import subprocess
import sys


def return_json_obj():
    with open('saves/content.json', 'r', encoding='utf-8') as file:
        return json.loads(file.read())


def write_json_obj(json_obj):
    with open('saves/content.json', 'w', encoding='utf-8') as file:
        json.dump(json_obj, file, indent=4)


def read():
    json_obj = return_json_obj()
    send_list = ['spamerino.exe', 'data']
    for i in range(0, len(json_obj['saves']), 1):
        list_elem = json_obj['saves'][i]
        send_list.extend((list_elem['name'], list_elem['content'], list_elem['before'], list_elem['after']))

    subprocess.call(send_list)


def save(name, content, before, after):
    json_obj = return_json_obj()
    for i in range(0, len(json_obj['saves']), 1):
        if json_obj['saves'][i]['name'] == name:
            json_obj['saves'][i]['content'] = content
            json_obj['saves'][i]['before'] = before
            json_obj['saves'][i]['after'] = after
            write_json_obj(json_obj)
            print("Success", end="")
            return

def new_save(name, content, before, after):
    json_obj = return_json_obj()
    new_entry = {"name": name,
                 "content": content,
                 "before": before,
                 "after": after}
    json_obj['saves'].append(new_entry)
    write_json_obj(json_obj)
    print("Success", end="")



if sys.argv[1] == 'read':
    read()
elif sys.argv[1] == 'save':
    save(sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5])
elif sys.argv[1] == 'new':
    new_save(sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5])
else:
    pass
