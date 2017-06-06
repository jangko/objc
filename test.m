#import <Cocoa/Cocoa.h>

@interface MyWindow: NSWindow

- (BOOL) canBecomeKeyWindow;
- (BOOL) canBecomeMainWindow;
@end

@implementation MyWindow
- (BOOL) canBecomeKeyWindow
{
  return YES;
}
- (BOOL) canBecomeMainWindow
{
  return YES;
}

@end

@interface AppDelegate : NSObject <NSApplicationDelegate>{
}
@end

@implementation AppDelegate
- (BOOL) applicationShouldTerminateAfterLastWindowClosed: (NSNotification*) aNotification {
  return YES;
}

@end

@interface MyView: NSOpenGLView {
}
@end

@implementation MyView
-(BOOL) acceptFirstResponder
{
  return YES;
}

- (void) reshape
{
}

- (void)mouseDown:(NSEvent *)theEvent
{
      [[self nextResponder] mouseDown:theEvent];
}

- (void)mouseUp:(NSEvent *)theEvent
{
      [[self nextResponder] mouseUp:theEvent];
}

- (void)mouseDragged:(NSEvent *)theEvent
{
      [[self nextResponder] mouseDragged:theEvent];
}
@end

NSOpenGLPixelFormat * createPixelFormat(  )
{
   NSOpenGLPixelFormatAttribute attrs[] =
   {
      NSOpenGLPFADoubleBuffer,
      NSOpenGLPFADepthSize, 24,
      //NSOpenGLPFASupersample,
      //NSOpenGLPFASampleBuffers, (NSOpenGLPixelFormatAttribute)1,
      //NSOpenGLPFASamples, (NSOpenGLPixelFormatAttribute)4,
      NSOpenGLPFAAccumSize,  32,
      //NSOpenGLPFAOpenGLProfile,  NSOpenGLProfileVersion3_2Core,
      0
   };

   NSOpenGLPixelFormat *
      pf =  [[[NSOpenGLPixelFormat alloc] initWithAttributes:attrs] autorelease ];

   if ( pf == NULL )
   {
      NSLog(@"cocoglut: error: cannot create required pixel format for the OpenGL view.");
      exit(1);
   }

   return pf ;
}


int main(int argc, const char * argv[])
{
	@autoreleasepool
	{
    [NSApplication sharedApplication];

    [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];

    NSUInteger windowStyle = NSTitledWindowMask | NSClosableWindowMask |
      NSMiniaturizableWindowMask | NSResizableWindowMask;

    NSRect windowRect = NSMakeRect(100,100,400,400);
    MyWindow* window = [ [MyWindow alloc] initWithContentRect: windowRect
                                           styleMask: windowStyle
                                             backing: NSBackingStoreBuffered
                                               defer: YES];


    [window setTitle: @"Hello"];
    [window display];
    [window orderFrontRegardless];

    NSOpenGLPixelFormat *pf = createPixelFormat( ) ;

    MyView * newView = [[MyView alloc] initWithFrame:windowRect pixelFormat: pf];

    [newView setWantsBestResolutionOpenGLSurface: YES] ;

    [window setContentView: newView ];
    [window makeFirstResponder: newView];
    window.initialFirstResponder = newView;
    [window makeKeyWindow];

    AppDelegate* appDel = [[AppDelegate alloc] init];
    [NSApp setDelegate: appDel];
    [NSApp run];
	}
}
