import objc, strutils

{.passL: "-framework Foundation" .}

proc main() =
  #var images = copyImageNames()
  #for x in images:
  #  let parts = x.split("/")
  #  if parts[parts.len - 1] == "Foundation":
  #    var c = copyClassNamesForImage(x)
  #    for x in c:
  #      echo x
  #var x = getClassList()
  #for c in x:
  #  echo getName(c)
    
  
  var c = getClass("NSString")
  var v = c.ivarList()
  for i in v:
    echo i
    
  #var props = c.propertyList()
  #for x in props:
  #  echo x
  #
  #echo "---"
  #echo getName(c)
  #var list = c.methodList()
  #for x in list:
  #  echo x
  #
  #var m = getMetaClass("NSString")
  #echo m.getName()
  #var mlist = m.methodList()
  #for x in mlist:
  #  echo x
  #  let args = x.argumentTypes()
  #  for y in args:
  #    echo y
  
main()