import json
import subprocess
import sys


def return_json_obj():
    with open('saves/content.json', 'r', encoding='utf-8') as file:
        return json.loads(file.read())


def write_json_obj(json_obj):
    with open('saves/content.json', 'w', encoding='utf-8') as file:
        json.dump(json_obj, file, indent=4)


def receive_data(return_array=True):
    input_str = ""
    for line in sys.stdin.buffer.readlines():
        input_str += line.decode('utf-8')
    if return_array:
        data_arr = input_str.split(" , ")
        data_arr = [arg.replace("/,", ",") for arg in data_arr]
        return data_arr
    else:
        return input_str



def read():
    json_obj = return_json_obj()
    delimiter = " , "
    for i in range(0, len(json_obj['saves']), 1):
        list_elem = json_obj['saves'][i]
        for attr in list_elem:
            if i == len(json_obj['saves']) - 1 and attr == "after":
                delimiter = ""
            sys.stdout.buffer.write((list_elem[attr].replace(",", "/,") + delimiter).encode('utf-8'))


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


def delete(name):
    json_obj = return_json_obj()
    for i in range(0, len(json_obj['saves']), 1):
        if json_obj['saves'][i]['name'] == name:
            del json_obj['saves'][i]
            write_json_obj(json_obj)
            print("Success", end="")
            return


if len(sys.argv) > 1:
    if sys.argv[1] == 'read':
        read()
    elif sys.argv[1] == 'save':
        save(*receive_data())
    elif sys.argv[1] == 'new':
        new_save(*receive_data())
    elif sys.argv[1] == 'delete':
        delete(receive_data(False))
    else:
        pass
