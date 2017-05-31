import xmlparser, xmltree, tables, parseutils, strutils, strtabs

type
  BSParser* = object
  
proc parseNode(self: var BSParser, node: XmlNode)  

#proc parseAttr(self: var BSParser, attrs: XmlAttributes) =
#  for key, val in pairs(attrs):
#    if key == "style":
#      self.parseStyle(val)
#    else:
#      discard self.parseAttr(key, val)
proc parseStruct(self: var BSParser, node: XmlNode) =
  for key, val in pairs(node.attrs):
    echo key, " ", val
    
proc parseChildren(self: var BSParser, node: XmlNode) =
  if node.len > 0:
    for n in node:
      self.parseNode(n)
      
proc startElement(self: var BSParser, node: XmlNode) =
  case node.tag
  of "struct":
    self.parseStruct(node)
  of "method": discard
  of "informal_protocol": discard
  of "class": discard
  of "enum": discard
  of "depends_on": discard
  of "cftype": discard
  of "opaque": discard
  of "constant": discard
  of "string_constant": discard
  of "enum": discard
  of "function": discard
  of "function_alias": discard
  of "class": discard
  else:
    #echo node.tag
    self.parseChildren(node)
  
proc parseNode(self: var BSParser, node: XmlNode) =
  case node.kind
  of xnElement:
    self.startElement(node)
  of xnText:
    echo "xnText"
  else:
    echo "KIND: ", node.kind
    
proc parse*(self: var BSParser, fileName: string) =
  try:
    var root = loadXml(fileName)
    self.parseNode(root)
  except:
    echo getCurrentExceptionMsg()
    
var p: BSParser
p.parse("master\\bridgesupport\\Foundation.bridgesupport")