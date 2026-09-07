"""Private, stopped-server snapshots; prints only a sanitized result."""
import argparse, datetime as dt, hashlib, json, os, pathlib, re, shutil, socket, stat, struct, sys, time, urllib.request, zipfile

def env(path):
    return {k.strip().lower():v.strip().strip('"').strip("'") for line in pathlib.Path(path).read_text().splitlines() if '=' in line and not line.lstrip().startswith('#') for k,v in [line.split('=',1)]}

def varint(n):
    out=bytearray()
    while True:
        b=n&127; n >>= 7; out.append(b|(128 if n else 0))
        if not n: return bytes(out)

def recv(s,n):
    out=b''
    while len(out)<n:
        chunk=s.recv(n-len(out))
        if not chunk: raise RuntimeError('Status connection closed')
        out+=chunk
    return out

def readint(s):
    n=0
    for i in range(5):
        b=recv(s,1)[0]; n|=(b&127)<<(7*i)
        if b<128:return n
    raise RuntimeError('Invalid status packet')

def players(host,port):
    with socket.create_connection((host,port),timeout=15) as s:
        h=host.encode(); packet=b'\0'+varint(767)+varint(len(h))+h+struct.pack('>H',port)+b'\x01'
        s.sendall(varint(len(packet))+packet+b'\x01\x00')
        size=readint(s)
        if size>1024*1024 or readint(s)!=0:raise RuntimeError('Invalid status response')
        data=json.loads(recv(s,readint(s)))
        count=data['players']['online']
        if not isinstance(count,int) or count<0:raise RuntimeError('Unknown player count')
        return count

class Panel:
    def __init__(self,path,server):
        self.server=server
        self.headers={'Authorization':'Bearer '+env(path)['token'],'Content-Type':'application/json','Accept':'application/json, text/event-stream','User-Agent':'Mozilla/5.0'}
        self.call('initialize',{'protocolVersion':'2024-11-05','capabilities':{},'clientInfo':{'name':'local-backup','version':'1'}})
    def call(self,method,params):
        req=urllib.request.Request('https://api.fadehost.com/mcp',data=json.dumps({'jsonrpc':'2.0','id':1,'method':method,'params':params}).encode(),headers=self.headers)
        with urllib.request.urlopen(req,timeout=60) as r:
            if r.headers.get('Mcp-Session-Id'):self.headers['Mcp-Session-Id']=r.headers['Mcp-Session-Id']
            raw=r.read().decode()
        if raw.startswith(('event:','data:')):raw=next(l[6:] for l in raw.splitlines() if l.startswith('data:'))
        result=json.loads(raw)
        if 'error' in result or result.get('result',{}).get('isError'):raise RuntimeError('Server management request failed: '+method)
        return result['result']
    def tool(self,name):return self.call('tools/call',{'name':name,'arguments':{'server':self.server}})
    def status(self):
        result=self.tool('get_server')
        report=result.get('structuredContent',{}).get('report','') or '\n'.join(c.get('text','') for c in result.get('content',[]))
        match=re.search(r'^Status:\s*(.+)$',report,re.M)
        if not match:raise RuntimeError('Unknown server status')
        return match[1].strip().lower()
    def wait(self,target,timeout=240):
        until=time.monotonic()+timeout
        while time.monotonic()<until:
            if self.status() in target:return
            time.sleep(5)
        raise RuntimeError('Server did not reach expected state')

def run(a):
    sys.path.insert(0,a.dependencies)
    import paramiko
    root=pathlib.Path(a.destination).resolve();root.mkdir(parents=True,exist_ok=True)
    lock=root/'backup.lock'
    # An interrupted run requires inspection before removing this lock.
    with lock.open('x') as f:f.write(str(os.getpid()))
    stopped=False; complete=False; ssh=None; panel=None
    try:
        panel=Panel(a.panel_env,a.server)
        status=panel.status()
        if status!='online':
            print(json.dumps({'status':'deferred','reason':'server_not_online','server_status':status}));return
        count=players(a.host,a.port)
        if count:
            print(json.dumps({'status':'deferred','reason':'players_online','players':count}));return
        cfg=env(a.sftp_env)
        ssh=paramiko.SSHClient();ssh.load_system_host_keys()
        known=root/'known_hosts'
        if known.exists():ssh.load_host_keys(str(known))
        # Trust on first use; subsequent runs reject a changed host key.
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy() if not known.exists() else paramiko.RejectPolicy())
        ssh.connect(cfg['host'],port=int(cfg['port']),username=cfg['username'],password=cfg['password'],timeout=20,look_for_keys=False,allow_agent=False)
        if not known.exists():ssh.save_host_keys(str(known))
        sftp=ssh.open_sftp()
        with sftp.open('server.properties') as f:props={k:v for l in f.read().decode().splitlines() if '=' in l and not l.startswith('#') for k,v in [l.split('=',1)]}
        world=props.get('level-name','world')
        if '/' in world or '\\' in world or world in ('.','..'):raise RuntimeError('Unsafe world directory')
        available=set(sftp.listdir('.'))
        roots=[world]+[p for p in ['mods','config','defaultconfigs','moonlight-global-datapacks','server.properties','ops.json','whitelist.json','banned-players.json','banned-ips.json','eula.txt','fabric-server-launcher.properties'] if p in available]
        inventory=[]
        def walk(path):
            attr=sftp.lstat(path)
            if stat.S_ISDIR(attr.st_mode):
                for child in sorted(sftp.listdir(path)):
                    if child in ('.','..') or '/' in child or '\\' in child:raise RuntimeError('Unsafe server path')
                    walk(path+'/'+child)
            elif stat.S_ISREG(attr.st_mode):inventory.append((path,attr.st_size))
            else:raise RuntimeError('Unexpected server symlink or special file')
        for path in roots:walk(path)
        if shutil.disk_usage(root).free<sum(size for _,size in inventory)*2+2*1024**3:raise RuntimeError('Insufficient free disk space')
        if a.check:
            print(json.dumps({'status':'ready','players':count,'files':len(inventory),'source_bytes':sum(s for _,s in inventory)}));return
        # Recheck immediately before stopping; scheduled runs never knowingly kick players.
        if players(a.host,a.port):
            print(json.dumps({'status':'deferred','reason':'players_joined'}));return
        stamp=dt.datetime.now(dt.timezone.utc).strftime('%Y%m%dT%H%M%SZ')
        pending=root/('oas-server-'+stamp+'.zip.partial'); archive=pending.with_suffix('')
        stopped=True # Also recover if the stop response is lost.
        panel.tool('stop_server');panel.wait({'offline','stopped'})
        # Re-enumerate after the final world save.
        inventory.clear()
        for path in roots:walk(path)
        entries=[]
        with zipfile.ZipFile(pending,'w',zipfile.ZIP_DEFLATED,compresslevel=1,allowZip64=True) as z:
            for path,size in inventory:
                digest=hashlib.sha256(); copied=0
                with sftp.open(path,'rb') as src,z.open(path,'w',force_zip64=True) as dst:
                    src.prefetch(size)
                    while True:
                        chunk=src.read(1024*1024)
                        if not chunk:break
                        dst.write(chunk);digest.update(chunk);copied+=len(chunk)
                if copied!=size:raise RuntimeError('Incomplete file transfer')
                entries.append({'path':path,'bytes':copied,'sha256':digest.hexdigest()})
            z.writestr('BACKUP-MANIFEST.json',json.dumps({'created_utc':stamp,'minecraft':'1.21.1','loader':'fabric','world_directory':world,'files':entries},indent=2))
        panel.tool('start_server');panel.wait({'online'});stopped=False
        # Full readback verifies ZIP CRC and every file checksum before promotion.
        with zipfile.ZipFile(pending) as z:
            for entry in entries:
                with z.open(entry['path']) as f:
                    digest=hashlib.file_digest(f,'sha256').hexdigest()
                if digest!=entry['sha256']:raise RuntimeError('Archive verification failed')
        with pending.open('rb') as f:checksum=hashlib.file_digest(f,'sha256').hexdigest()
        pending.rename(archive)
        record={'status':'verified','created_utc':stamp,'archive':archive.name,'archive_bytes':archive.stat().st_size,'source_bytes':sum(e['bytes'] for e in entries),'files':len(entries),'sha256':checksum,'consistency':'server stopped after save','verification':'full archive readback and per-file SHA-256','server_restarted':True}
        archive.with_suffix('.json').write_text(json.dumps(record,indent=2)+'\n')
        if a.record:
            recordpath=pathlib.Path(a.record);recordpath.parent.mkdir(parents=True,exist_ok=True);recordpath.write_text(json.dumps(record,indent=2)+'\n')
        complete=True
        print(json.dumps(record))
    finally:
        try:
            if stopped and panel:
                panel.tool('start_server');panel.wait({'online'})
        finally:
            if ssh:ssh.close()
            # Keep a lock on failure after stopping: the next run must inspect recovery.
            if not stopped:lock.unlink(missing_ok=True)

if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__)
    for name in ['panel-env','sftp-env','server','host','destination','dependencies']:p.add_argument('--'+name,required=True)
    p.add_argument('--port',type=int,default=25565);p.add_argument('--record');p.add_argument('--check',action='store_true')
    run(p.parse_args())
