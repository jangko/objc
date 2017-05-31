import objc, foundation, strutils

type
  NSObject = object of RootObj
    id: ID

  NSWindow = object of NSObject

  NSWindowController = object of NSObject

  NSView = object of NSObject

  NSTextView = object of NSView

  NSString = object of NSObject

proc `@`*(a: string): NSString =
  result.id = objc_msgSend(getClass("NSString").ID, !"stringWithUTF8String:", a.cstring)

proc objc_alloc(cls: string): ID =
  objc_msgSend(getClass(cls).ID, !"alloc")

proc autorelease(obj: NSObject) =
  discard objc_msgSend(obj.id, !"autorelease")

proc init(x: typedesc[NSWindow], rect: CMRect, mask: cuint, backing: cuint, xdefer: BOOL): NSWindow =
  var wnd = objc_alloc("NSWindow")
  result.id = wnd.objc_msgSend(!"initWithContentRect:styleMask:backing:defer:", rect, mask, backing, xdefer)

proc init(x: typedesc[NSWindowController], window: NSWindow): NSWindowController =
  var ctrl = objc_alloc("NSWindowController")
  result.id = ctrl.objc_msgSend(!"initWithWindow:", window.id)

proc contentView(self: NSWindow, view: NSView) =
  discard objc_msgSend(self.id, !"setContentView:", view.id)

proc init(x: typedesc[NSTextView], rect: CMRect): NSTextView =
  var view = objc_alloc("NSTextView")
  result.id = view.objc_msgSend(!"initWithFrame:", rect)

proc insertText(self: NSTextView, text: string) =
  discard objc_msgSend(self.id, !"insertText:", @text.id)

proc exec(cls: string, cmd: SEL) =
  discard objc_msgSend(getClass(cls).ID, cmd)

proc `[]`(obj: NSObject, cmd: SEL) =
  discard objc_msgSend(obj.id, cmd)

proc `[]`(id: ID, cmd: SEL) =
  discard objc_msgSend(id, cmd)

proc main() =
  var pool = newClass("NSAutoReleasePool")
  exec("NSApplication", !"sharedApplication")

  if NSApp.isNil:
    echo "Failed to initialized NSApplication...  terminating..."
    return

  var windowStyle = NSTitledWindowMask or NSClosableWindowMask or
    NSMiniaturizableWindowMask or NSResizableWindowMask

  var windowRect = NSMakeRect(100,100,400,400)
  var window = NSWindow.init(windowRect, windowStyle, NSBackingStoreBuffered, NO)
  window.autorelease()

  var windowController = NSWindowController.init(window)
  windowController.autorelease()

  var textView = NSTextView.init(windowRect)
  textView.autorelease()
  textView.insertText("Hello OSX/Cocoa World!")

  window.contentView(textView)
  window[!"orderFrontRegardless"]
  NSApp[!"run"]

  pool[!"drain"]

main()
