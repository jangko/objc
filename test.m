#import <Cocoa/Cocoa.h>
#include <OpenGL/gl.h>
#include <OpenGL/glu.h>

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

-(void) drawRect: (NSRect) bounds
{

  GLint  x1 = 0;
  GLint  y1 = 0;
  GLint  x2 = 320;
  GLint  y2 = 300;

  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT); // Clear color and depth buffers
  glMatrixMode(GL_MODELVIEW);                          // To operate on model-view matrix
  glLoadIdentity();                 // Reset the model-view matrix

  glColor3f(1.0f, 0.0f, 1.0f);
  glBegin(GL_POLYGON);
  glVertex2i(x1, y1);
  glVertex2i(x2, y1);
  glVertex2i(x2, y2);
  glVertex2i(x1, y2);
  glEnd();

  glFlush();
  glSwapAPPLE();
}

- (void) reshape
{
  // get info about the new frame
  NSRect  frame = [self frame];

  // compute pixels units
  const int factor = 2 ; // should use cocoa conversion functions here!!!
  const int width   = (int)(frame.size.width * factor),
            height  = (int)(frame.size.height * factor);

  // Compute aspect ratio of the new window
  if(height == 0) {
    return;              // To prevent divide by 0
  }

  // Set the viewport to cover the new window
  glViewport(0, 0, width, height);

  // Set the aspect ratio of the clipping volume to match the viewport
  glMatrixMode(GL_PROJECTION);  // To operate on the Projection matrix
  glLoadIdentity();            // Reset
  // Enable perspective projection with fovy, aspect, zNear and zFar
  //gluPerspective(45.0, width / height, 0.1, 100.0)
  gluOrtho2D(0.0, (GLdouble)width, 0.0, (GLdouble)height);

  //glMatrixMode(GL_MODELVIEW)
  //glLoadIdentity()
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

- (void) keyDown:(NSEvent *)event
{
  NSLog(@"%d", event.keyCode);
  [[self nextResponder] keyDown:event];
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

    glClearColor(0.0, 0.0, 0.0, 1.0);                 // Set background color to black and opaque
    glClearDepth(1.0);                                // Set background depth to farthest
    glEnable(GL_DEPTH_TEST);                          // Enable depth testing for z-culling
    glDepthFunc(GL_LEQUAL);                           // Set the type of depth-test
    glShadeModel(GL_SMOOTH) ;                         // Enable smooth shading
    glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);// Nice perspective corrections

    [NSApp run];
	}
}
