from __future__ import print_function

from switch_port_management import Switch
import string
import yaml
import subprocess as sub
import time


class System(dict):
    def __init__(self):
        super(System, self).__init__()
        self.update({'local': 'Z0', 'port': 0, 'name': 'W0',
                     'ipmi_mac': '00:00:00:00', 'ipmi_ip': '000.000.0.00'})

    def set_local(self, local):
        self['local'] = local

    def set_port(self, port):
        self['port'] = port

    def set_name(self, name):
        self['name'] = name

    def set_ipmi_ip(self, ipmi_ip):
        self['ipmi_ip'] = ipmi_ip

    def set_ipmi_mac(self, switch):

        p = sub.Popen(('tcpdump', '-i', 'em1', 'port', 'bootps', '-c', '1'), stdout=sub.PIPE)

        switch.enable_port(self.port)

        for row in iter(p.stdout.readline, b""):
            ipmi_mac = row.rstrip()

        switch.disable_port(self.port)

        self['ipmi_mac'] = ipmi_mac[ipmi_mac.find('from')+4:ipmi_mac.find('(')].strip()

        p.terminate()

    @property
    def local(self):
        return self['local']

    @property
    def port(self):
        return self['port']

    @property
    def name(self):
        return self['name']


if __name__ == '__main__':

    # Connect to the switch and disable all ports to start clean
    ser = Switch(password='calvin')
    ser.connect()
    ser.disable_port(1, 48)

    # enable master port
    ser.enable_port(8)
    time.sleep(60)

    # Create the mapping for all ports
    portmap = {k: v for (k, v) in zip(['C', 'A', 'B', 'F'], [range(i+9, i, -2) for i in range(8, 39, 10)])}
    portmap.update({k: v for (k, v) in zip(['G', 'H', 'I', 'J'], [range(i, i+9, 2) for i in range(10, 41, 10)])})
    portmap.update({'E': [8, 7, 5, 3, 1], 'D': []})

    # Special systems (masters and login nodes)
    special = ['E1', 'E2', 'E3']

    # Get systems information
    counter = 0
    data = []
    for key in string.ascii_uppercase[0:10]:
        for i, port in enumerate(portmap[key]):
            system = System()
            local = key+str(i + 1)

            if local not in special:
                counter += 1
                system.set_local(local)
                system.set_name('w' + str("%02d" % (counter,)))
                system.set_port(port)
                system.set_ipmi_ip('172.16.0.' + str(counter + 3))
                system.set_ipmi_mac(ser)
                print("Getting info of: ", system.name, " Port: ", system.port)
                data.append(system)

    # Master2
    system = System()
    system.set_local('E2')
    system.set_name('master2')
    system.set_port(7)
    system.set_ipmi_ip('172.16.0.2')
    system.set_ipmi_mac(ser)
    print("Getting info of: ", system.name, " Port: ", system.port)
    data.append(system)

    # Login
    system = System()
    system.set_local('E3')
    system.set_name('login')
    system.set_port(5)
    system.set_ipmi_ip('172.16.0.3')
    system.set_ipmi_mac(ser)
    print("Getting info of: ", system.name, " Port: ", system.port)
    data.append(system)

    # Open data base
    data_base = open('../vars/training_database.yaml', mode='w')
    
    # Write yml file
    yaml.dump({'systems': data}, data_base)
    
