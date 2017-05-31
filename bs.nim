import os, strutils, algorithm

type
  SupFile = object
    name: string
    size: int
    dylibPath: string
    xmlPath: string
    
proc fileSize(name: string): int =
  try:
    var f = open(name)
    if f == nil: return 0
    result = int(getFileSize(f))
    f.close()
  except:
    result = 0
    
proc cmp(a, b: SupFile): int =
  result = cmp(a.size, b.size)
  
proc main() = 
  var support = newSeq[SupFile]()
  let folder = "/System/Library/Frameworks"
  let bsPath = "/Resources/BridgeSupport/"
  for x in walkDir(folder):
    let pos = rfind(x.path, ".framework")
    if pos != -1:
      let name = x.path.substr(folder.len+1,pos-1)
      let xmlPath = x.path & bsPath & name & ".bridgesupport"
      let dylibPath = x.path & bsPath & name & ".dylib"
      let size = fileSize(xmlPath)
      support.add SupFile(name: name, size: size, dylibPath: dylibPath, xmlPath: xmlPath)
  
  support.sort(cmp)
  for x in support:
    echo x.size, " ", x.name
    echo x.dylibPath
    
main()