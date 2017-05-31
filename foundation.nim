import objc, strutils

{.passL: "-framework Foundation" .}
{.passL: "-framework AppKit" .}
{.passL: "-framework ApplicationServices" .}

const
  NSBorderlessWindowMask*      : cuint = 0
  NSTitledWindowMask*          : cuint = 1 shl 0
  NSClosableWindowMask*        : cuint = 1 shl 1
  NSMiniaturizableWindowMask*  : cuint = 1 shl 2
  NSResizableWindowMask*       : cuint = 1 shl 3

var NSApp* {.importc.}: ID

type
  NSApplicationActivationPolicy* {.size: sizeof(cint).} = enum
    NSApplicationActivationPolicyRegular
    NSApplicationActivationPolicyAccessory
    NSApplicationActivationPolicyProhibited

  CMRect* = object
    x*, y*, w*, h*: float64

  CMPoint* = object
    x*, y*: float64

  CMSize* = object
    w*, h*: float64

const
  NSBackingStoreRetained*   : cuint = 0
  NSBackingStoreNonRetained*: cuint = 1
  NSBackingStoreBuffered*   : cuint = 2

proc newClass*(cls: string): ID =
  objc_msgSend(objc_msgSend(getClass(cls).ID, $$"alloc"), $$"init")

proc NSMakeRect*(x,y,w,h:float64): CMRect =
  result = CMRect(x:x,y:y,w:w,h:h)
