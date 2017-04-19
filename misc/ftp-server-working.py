import time,sys
# root_folder=('D:/Films',"C:/users/cibin/Downloads")
root_folder=sys.argv[1]
# root_folder='D:/Films'
print(root_folder)
time.sleep(4)
# sys.exit()
import get_IP
import pyperclip
from pyftpdlib.authorizers import DummyAuthorizer
from pyftpdlib.handlers import FTPHandler
from pyftpdlib.servers import FTPServer
import time
import logging
import threading
SLEEP_TIME = 900
user=('user','12345')

class FtpThread(threading.Thread):
    def __init__(self, user_list):
        self.user_list = user_list
        self.killswitch = 0
        threading.Thread.__init__(self)
    def run(self,*args,**kwargs):
        global SLEEP_TIME
        authorizer = DummyAuthorizer()
        authorizer.add_user(user[0], user[1], root_folder, perm="elradfmw")
        # authorizer.add_anonymous("/home/nobody")

        handler = FTPHandler
        handler.authorizer = authorizer
        ip_list=get_IP.getWinIP()
        wifi_ip=str(ip_list[min(len(ip_list,1))]) # first IP is mostly LAN IP
        print("Access at url ftp://" + wifi_ip + ":21 Timeout: " + str(SLEEP_TIME/60) + " mins")
        pyperclip.copy(str("ftp://" + wifi_ip + ":21 Timeout: " + str(SLEEP_TIME/60) + " mins  username:" + user[0]))
        # logging.basicConfig(filename='F:/CBN/misc/fdm dwnlds/ftp.log', level=logging.INFO)
        handler.banner = "pyftpdlib based ftpd ready."
        address = (wifi_ip, 21)
        self.server = FTPServer(address, handler)
        self.server.max_cons = 3
        self.server.max_cons_per_ip = 5
        self.server.serve_forever()

    def stop(self):
        self.server.close_all()
    
    
if __name__ == '__main__':
    try:
        ftp_server = FtpThread("")
        ftp_server.start()
        time.sleep(SLEEP_TIME)
        ftp_server.stop()
        print("Shut down")
    except:
        print ("Unexpected error:", sys.exc_info()[0])
        time.sleep(5)
