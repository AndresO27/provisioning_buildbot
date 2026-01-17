#!/bin/env python

from switch_port_management import Switch

if __name__ == '__main__':
     ser = Switch(password="calvin")
     ser.connect()
     ser.enable_port(1, 48)
     ser.disconnect()
