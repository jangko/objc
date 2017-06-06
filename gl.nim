import glut, opengl, glu, math, nimBMP

type 
  App = ref object
    w, h: GLint
    data: string
    texid: GLuint
    
var app: App
var val = 0

proc display() {.cdecl.} =
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT) # Clear color and depth buffers
  glMatrixMode(GL_MODELVIEW)                          # To operate on model-view matrix
  glLoadIdentity()                 # Reset the model-view matrix
  
  var
    x1 = GLint(0)
    y1 = GLint(0)
    x2 = GLint(320)
    y2 = GLint(300)
    
  glEnable(GL_TEXTURE_2D)
  glBindTexture(GL_TEXTURE_2D, app.texid)
  
  val = val and 0xff
  for i in 0.. <app.data.len div 2:
    app.data[i] = chr(val)
  inc val
  
  #glPixelStorei(GL_UNPACK_ROW_LENGTH, app.w)
  #glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER,  GL_LINEAR)  
  glTexSubImage2D(GL_TEXTURE_2D, 0.GLint, 0.GLint, 0.GLint, 
    app.w, app.h, GL_RGBA, GL_UNSIGNED_BYTE, app.data[0].addr)
  
  glColor3f(1.0f, 1.0f, 1.0f)
  glBegin(GL_POLYGON)
  glTexCoord2i(0,0); glVertex2i(x1, y1)
  glTexCoord2i(app.w, 0); glVertex2i(x2, y1)
  glTexCoord2i(app.w, app.h); glVertex2i(x2, y2)
  glTexCoord2i(0, app.h); glVertex2i(x1, y2)
  glEnd()
  
  glFlush()
  
  glutSwapBuffers() # Swap the front and back frame buffers (double buffering)

proc reshape(width: GLsizei, height: GLsizei) {.cdecl.} =
  # Compute aspect ratio of the new window
  if height == 0:
    return                # To prevent divide by 0

  # Set the viewport to cover the new window
  glViewport(0, 0, width, height)

  # Set the aspect ratio of the clipping volume to match the viewport
  glMatrixMode(GL_PROJECTION)  # To operate on the Projection matrix
  glLoadIdentity()             # Reset
  # Enable perspective projection with fovy, aspect, zNear and zFar
  #gluPerspective(45.0, width / height, 0.1, 100.0)
  gluOrtho2D(0.0, width.GLDouble, 0.0, height.GLDouble)

  #glMatrixMode(GL_MODELVIEW)
  #glLoadIdentity()

proc main() =  
  var
    cmdCount {.importc: "cmdCount".}: cint
    cmdLine {.importc: "cmdLine".}: cstringArray

  var bmp = loadBMP32("spheres2.bmp")
  app = new(App)
  app.w = bmp.width.GLint
  app.h = bmp.height.GLint
  app.data = bmp.data
  
  glutInit(addr cmdCount, cmdLine)
  glutInitDisplayMode(GLUT_DOUBLE)
  glutInitWindowSize(600, 480)
  glutInitWindowPosition(50, 50)
  discard glutCreateWindow("OpenGL Example")

  glutDisplayFunc(display)
  glutReshapeFunc(reshape)

  loadExtensions()
  
  glEnable(GL_TEXTURE_2D)
  app.texid = 0
  glGenTextures(1, addr(app.texid))
  glBindTexture(GL_TEXTURE_2D, app.texid)
  glPixelStorei(GL_UNPACK_ROW_LENGTH, app.w)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER,  GL_LINEAR)
  glTexImage2D(GL_TEXTURE_2D,
    GLint(0), GL_RGBA8.GLint, 
    app.w, app.h, 
    GLint(0), GL_RGBA, 
    GL_UNSIGNED_BYTE, app.data[0].addr)
  
  glMatrixMode(GL_TEXTURE)
  glLoadIdentity()
  glScalef(1.0/app.w.GLfloat, 1.0/app.h.GLfloat, 1.0)
  
  glClearColor(0.0, 0.0, 0.0, 1.0)                  # Set background color to black and opaque
  glClearDepth(1.0)                                 # Set background depth to farthest
  glEnable(GL_DEPTH_TEST)                           # Enable depth testing for z-culling
  glDepthFunc(GL_LEQUAL)                            # Set the type of depth-test
  glShadeModel(GL_SMOOTH)                           # Enable smooth shading
  glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST) # Nice perspective corrections
  
  var a: ptr int
  echo log2(sizeof(a).float64)
  glutMainLoop()
  
  glDeleteTextures(1, addr(app.texid))
  
main()