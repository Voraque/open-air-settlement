import contextlib, importlib.util, io, json, pathlib, stat, tempfile, types, unittest
from unittest.mock import patch
spec=importlib.util.spec_from_file_location('backup',pathlib.Path(__file__).with_name('backup-server.py'))
b=importlib.util.module_from_spec(spec);spec.loader.exec_module(b)

class Stream(io.BytesIO):
    def prefetch(self,*args):pass
class SFTP:
    files={'server.properties':b'level-name=world\n', 'world/level.dat':b'world data', 'mods/example.jar':b'mod bytes'}
    fail=False
    def listdir(self,path):
        prefix='' if path=='.' else path+'/'
        return sorted({p[len(prefix):].split('/')[0] for p in self.files if p.startswith(prefix)})
    def lstat(self,path):return types.SimpleNamespace(st_mode=stat.S_IFREG if path in self.files else stat.S_IFDIR,st_size=len(self.files.get(path,b'')))
    def open(self,path,*args):
        if self.fail and path=='world/level.dat':raise OSError('Simulated interrupted transfer')
        return Stream(self.files[path])
class SSH:
    def load_system_host_keys(self):pass
    def load_host_keys(self,*args):pass
    def save_host_keys(self,path):pathlib.Path(path).write_text('test')
    def set_missing_host_key_policy(self,*args):pass
    def connect(self,*args,**kwargs):pass
    def close(self):pass
    def open_sftp(self):return SFTP()
class Panel:
    events=[]
    def __init__(self,*args):pass
    def status(self):return 'online'
    def tool(self,name):self.events.append(name)
    def wait(self,*args):pass

class BackupTests(unittest.TestCase):
    def setUp(self):
        Panel.events=[];SFTP.fail=False
        self.tmp=tempfile.TemporaryDirectory();self.root=pathlib.Path(self.tmp.name)
        self.args=types.SimpleNamespace(dependencies='',destination=str(self.root/'private'),panel_env='',server='',host='',port=1,sftp_env='',check=False,record=str(self.root/'public'/'latest.json'))
        fake=types.SimpleNamespace(SSHClient=SSH,AutoAddPolicy=lambda:None,RejectPolicy=lambda:None)
        self.patches=[patch.object(b,'Panel',Panel),patch.object(b,'players',return_value=0),patch.object(b,'env',return_value={'host':'test','port':'22','username':'private','password':'secret'}),patch.dict('sys.modules',{'paramiko':fake})]
        for p in self.patches:p.start()
    def tearDown(self):
        for p in reversed(self.patches):p.stop()
        self.tmp.cleanup()
    def run_backup(self):
        with contextlib.redirect_stdout(io.StringIO()) as output:b.run(self.args)
        return json.loads(output.getvalue())
    def test_success_verifies_and_restarts(self):
        result=self.run_backup()
        self.assertEqual(result['status'],'verified');self.assertEqual(Panel.events,['stop_server','start_server'])
        self.assertEqual(result['files'],3)
        self.assertNotIn('secret',pathlib.Path(self.args.record).read_text())
        self.assertFalse((self.root/'private'/'backup.lock').exists())
        self.assertEqual(len(list((self.root/'private').glob('*.zip'))),1)
    def test_offline_backup_does_not_start_server(self):
        with patch.object(Panel,'status',return_value='offline'):
            result=self.run_backup()
        self.assertEqual(result['status'],'verified')
        self.assertFalse(result['server_restarted'])
        self.assertEqual(Panel.events,['stop_server'])
    def test_busy_does_not_stop_or_publish(self):
        with patch.object(b,'players',return_value=2):self.assertEqual(self.run_backup()['status'],'deferred')
        self.assertEqual(Panel.events,[]);self.assertFalse(pathlib.Path(self.args.record).exists())
    def test_failed_download_attempts_restart_and_keeps_partial(self):
        SFTP.fail=True
        with self.assertRaises(OSError):self.run_backup()
        self.assertEqual(Panel.events,['stop_server','start_server'])
        self.assertFalse(pathlib.Path(self.args.record).exists())
        self.assertEqual(list((self.root/'private').glob('*.zip')),[])
        self.assertTrue((self.root/'private'/'backup.lock').exists())
    def test_existing_lock_prevents_overlap(self):
        dest=pathlib.Path(self.args.destination);dest.mkdir();(dest/'backup.lock').write_text('existing')
        with self.assertRaises(FileExistsError):self.run_backup()
        self.assertEqual(Panel.events,[])

if __name__=='__main__':unittest.main()
