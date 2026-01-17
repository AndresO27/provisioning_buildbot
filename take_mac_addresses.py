import subprocess as sub
import json
import os
import time

output_file = "mac_addresses.txt"

with open("output.log","wb") as f:
    process = sub.Popen(['tcpdump', '-i', 'eno2', '-l'], stdout=f, text=True)
    #output, _ = process.communicate()
    try:
        time.sleep(800)
    finally:
        process.terminate()  
        process.wait(timeout=5)  

nodes={}
lines_list=[]
mac_addresses=[]

with open("output.log", "r") as f:
    tcpdump=f.read().splitlines()

    for line in tcpdump:
        if "BOOTP/DHCP, Request" in line:
            lines_list.append(line)
    for line in lines_list:
        data=line.split()
        if data[8] not in mac_addresses:
            mac_addresses.append(data[8])
        else:
            print(f"Repeated MAC_address",data[8])

for i,mac in enumerate(mac_addresses, 1):
    if mac != '10:da:43:02:6a:66':
        node=f'l{i:02d}'
        nodes[node]=mac.upper()

with open('mac_address_database_ipmi.json','w') as database:
    json.dump(nodes,database,indent=2)

