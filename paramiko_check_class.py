class Connection:
    def __init__(self, host, port, user, password):
        self.host = host
        self.port = int(port) if port else 22
        self.user = user
        self.password = password
        ssh = paramiko.SSHClient()
        ssh.load_system_host_keys()
        ssh.set_missing_host_key_policy(paramiko.WarningPolicy())
        self.ssh = ssh
        self.connected = False
        self.connect()
    def connect(self):
        try:
            self.ssh.connect(hostname=self.host, port=self.port, username=self.user, password=self.password)
        except Exception as e:
            print(e)
            traceback.print_exc()
            try:
                client.close()
            except:
                pass
            sys.exit()
    def run(self, cmd):
        chan = self.ssh.get_transport().open_session()
        chan.exec_command(cmd)
        stdout = "".join(chan.makefile('r'))
        stderr = "".join(chan.makefile_stderr('r'))
        return chan.recv_exit_status(), stdout, stderr
