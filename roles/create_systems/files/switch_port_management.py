from __future__ import print_function

import serial


class Switch(object):

    def __init__(self, port="/dev/ttyS1", password=""):
        super(Switch, self).__init__()

        self._dev = serial.Serial(port=port, baudrate=9600, bytesize=8,
                                  parity='N', xonxoff=False, timeout=1)

        self._password = password+'\n'
        self._connected = False
        self._iobuff = [""]

    def connect(self):
        print("Connecting...", end="")

        self.disconnect()
        self._dev.writelines(['enable\n', self._password, 'configure terminal\n'])
        self._dev.flush()
        self._iobuff = "".join(self._dev.readlines())

        if self._iobuff[-1] is "#":
            self._connected = True
            print("Done!")

    def disconnect(self):
        while self._iobuff[-1] is not ">":
            self._dev.writelines(['exit\n'])
            self._dev.flush()
            self._iobuff = "".join(self._dev.readlines())

        self._connected = False

    def enable_port(self, start, stop=False):
        self._switch_port("enable", start, stop)

    def disable_port(self, start, stop=False):
        self._switch_port("disable", start, stop)

    def _switch_port(self, command, start, stop=False):
        if not self.is_connected:
            self.connect()

        command = command+"\n"

        if not stop:
            stop = start

        for pn in range(start, stop+1):
            port = '0/1/'+str(pn)+'\n'
            self._dev.writelines(['interface ethernet '+port, command, 'exit\n'])

        self._dev.flush()
        self._iobuff = "".join(self._dev.readlines())

    def print_brief(self, start, stop=False):

        print('Port   Link     State     Dupl Speed   Trunk Tag P MAC            Name')

        if not stop:
            stop = start

        for pn in range(start, stop+1):
            port = '0/1/'+str(pn)+'\n'
            self._dev.write("show interfaces brief ethernet "+port)
            self._dev.flush()

        self._iobuff = self._dev.readlines()
        print("".join(self._iobuff[3::4]))

    @property
    def is_connected(self):
        return self._connected


# if __name__ == '__main__':
#     ser = Switch(password="calvin")
#     ser.connect()
#     ser.disable_port(1, 48)
#     ser.print_brief(8)
#     ser.enable_port(8)
#     ser.print_brief(1, 48)
#     ser.disconnect()
