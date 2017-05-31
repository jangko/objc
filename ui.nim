import objc, strutils

{.passL: "-framework Foundation" .}
{.passL: "-framework AppKit" .}
{.passL: "-framework ApplicationServices" .}

type
  AppDelegate = object
    isa: Class
    window: ID

  CMPoint = object
    x, y: float64

  CMSize = object
    w, h: float64

  CMRect = object
    x, y, w, h: float64

const
  NSBorderlessWindowMask  = 0
  NSTitledWindowMask      = 1 shl 0
  NSClosableWindowMask    = 1 shl 1
  NSMiniaturizableWindowMask  = 1 shl 2
  NSResizableWindowMask   = 1 shl 3

var NSApp {.importc.}: ID
var AppDel: Class
var ViewClass: Class

proc NSRectFill(rect: CMRect) {.importc.}

proc drawRect(self: ID, cmd: SEL, rect: CMRect) {.cdecl.} =
  var red = objc_msgSend(getClass("NSColor").ID, !"redColor")

  var rect1 = CMRect(x:21, y:21, w:210, h:210)
  discard objc_msgSend(red, !"set")
  NSRectFill(rect1)
  
proc initView() =
  ViewClass = allocateClassPair(getClass("NSView"), "View", 0)
  discard ViewClass.addMethod(!"drawRect:", cast[IMP](drawRect), "v!:")
  ViewClass.registerClassPair()

proc didFinishLaunching(self: ptr AppDelegate, cmd: SEL, notification: ID): BOOL {.cdecl.} =
  self.window = objc_msgSend(getClass("NSWindow").ID, !"alloc")
  
  # Create an instance of the window.
  var
    cmd = !"initWithContentRect:styleMask:backing:defer:"
    mask = (NSTitledWindowMask or NSClosableWindowMask or NSResizableWindowMask or NSMiniaturizableWindowMask)
    rect = CMRect(x:0,y:0,w:1024,h:460)
    
  self.window = objc_msgSend(self.window, cmd, rect, mask, 0, false)
  
  # Create an instance of our view class.
  # Relies on the view having declared a constructor that allocates a class pair for it.
  rect = CMRect(x:0, y:0, w:320, h:480)
  var view  = objc_msgSend(getClass("View").ID, !"alloc")
  var frame = objc_msgSend(view, !"initWithFrame:", rect)
  
  # here we simply add the view to the window.
  discard objc_msgSend(self.window, !"setContentView:", frame)
  discard objc_msgSend(self.window, !"becomeFirstResponder")
  
  # Shows our window in the bottom-left hand corner of the screen.
  discard objc_msgSend(self.window, !"makeKeyAndOrderFront:", self)
  result = YES

proc main() =
  initView()
  
  AppDel = allocateClassPair(getClass("NSObject"), "AppDelegate", 0)
  discard AppDel.addMethod(!"applicationDidFinishLaunching:", cast[IMP](didFinishLaunching), "i!:!")
  AppDel.registerClassPair()
  
  discard objc_msgSend(getClass("NSApplication").ID, !("sharedApplication"))
  
  if NSApp.isNil:
    echo "Failed to initialized NSApplication...  terminating..."
    return
  
  var appDel = objc_msgSend(getClass("AppDelegate").ID, !"alloc")
  appDel = objc_msgSend(appDel, !"init")
  
  discard objc_msgSend(NSApp, !("setDelegate:"), appDel)
  discard objc_msgSend(NSApp, !("run"))
  
main()
