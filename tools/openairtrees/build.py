import argparse,json,pathlib,subprocess,tempfile,zipfile
B=pathlib.Path(__file__).parent
p=argparse.ArgumentParser();p.add_argument('--javac',required=True);p.add_argument('--dynamic-trees',required=True);p.add_argument('--output',required=True);p.add_argument('--runtime-root',required=True,help='Fabric 1.21.1 server folder containing libraries, mods and .fabric remapped server jar');a=p.parse_args()
meta=json.loads((B/'resources/fabric.mod.json').read_text())
with tempfile.TemporaryDirectory(prefix='openairtrees-build-') as tmp:
 classes=pathlib.Path(tmp)
 import os
 runtime=pathlib.Path(a.runtime_root)
 jars=[pathlib.Path(a.dynamic_trees),*sorted((runtime/'.fabric/remappedJars').rglob('server-intermediary.jar')),*sorted((runtime/'libraries').rglob('*.jar')),*sorted((runtime/'mods').glob('*.jar')),*sorted((runtime/'.fabric/processedMods').glob('*.jar'))]
 args=['--release','21','-proc:none','-cp',os.pathsep.join(map(str,jars)),'-d',str(classes),*[str(x) for x in sorted((B/'java').rglob('*.java'))]]
 argfile=classes/'javac.args';argfile.write_text('\n'.join(json.dumps(x) for x in args),encoding='utf-8')
 subprocess.run([a.javac,'@'+str(argfile)],check=True)
 argfile.unlink()
 entries={}
 for root in [B/'resources',classes]:
  for f in sorted(root.rglob('*')):
   if f.is_file():
    data=f.read_bytes()
    if root==B/'resources' and f.suffix in ['.json','.txt']:data=data.replace(b'\r\n',b'\n')
    entries[f.relative_to(root).as_posix()]=data
 entries['LICENSE-DynamicTrees.txt']=(B/'LICENSE-DynamicTrees.txt').read_bytes().replace(b'\r\n',b'\n')
 out=pathlib.Path(a.output);out.parent.mkdir(parents=True,exist_ok=True)
 with zipfile.ZipFile(out,'w',zipfile.ZIP_DEFLATED) as z:
  for name,data in sorted(entries.items()):
   info=zipfile.ZipInfo(name,date_time=(2026,9,7,0,0,0));info.compress_type=zipfile.ZIP_DEFLATED;z.writestr(info,data)
print(json.dumps({'output':str(out),'version':meta['version'],'entries':len(entries)}))
