/*
 File: PaintingView.m
 Abstract: The class responsible for the finger painting. The class wraps the 
 CAEAGLLayer from CoreAnimation into a convenient UIView subclass. The view 
 content is basically an EAGL surface you render your OpenGL scene into.
 Version: 1.11
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2010 Apple Inc. All Rights Reserved.
 
 */

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>

#import "PaintingView.h"


//CLASS IMPLEMENTATIONS:

// A class extension to declare private methods
@interface PaintingView (private)

- (BOOL)createFramebuffer;
- (void)destroyFramebuffer;

@end

@implementation PaintingView

@synthesize  location;
@synthesize  previousLocation;
@synthesize presentationDelegate;


// Implement this to override the default layer class (which is [CALayer class]).
// We do this so that our view will be backed by a layer that is capable of OpenGL ES rendering.
+ (Class) layerClass
{
	return [CAEAGLLayer class];
}

// The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
-(id)initWithFrame:(CGRect)frame photoSize:(CGSize)size delegate:(id)delegate drawQueue:(NSOperationQueue *)_drawQueue{
	
	
	
    
    if ((self = [super initWithFrame:frame])) {
		
		drawOperation=nil;
		
		drawQueue=[_drawQueue retain];
		
		

		
		
		CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
		
		eaglLayer.opaque = NO;
		// In this application, we want to retain the EAGLDrawable contents after a call to presentRenderbuffer.
		eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
										[NSNumber numberWithBool:YES], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
		
		context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
		
		if (!context || ![EAGLContext setCurrentContext:context]) {
			[self release];
			return nil;
		}
		CGImageRef		brushImage;
		CGContextRef	brushContext;
		GLubyte			*brushData;
		size_t			height;
		
		
		// Create a texture from an image
		// First create a UIImage object from the data in a image file, and then extract the Core Graphics image
		
		brushUIImage = [[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Particle.png"]];
		
		brushImage = brushUIImage.CGImage;
		
		//		brushImage = [UIImage imageNamed:@"Particle.png"].CGImage;
		
		// Get the width and height of the image
		width = CGImageGetWidth(brushImage);
		height = CGImageGetHeight(brushImage);
		
		// Texture dimensions must be a power of 2. If you write an application that allows users to supply an image,
		// you'll want to add code that checks the dimensions and takes appropriate action if they are not a power of 2.
		
		// Make sure the image exists
		if(brushImage) {
			// Allocate  memory needed for the bitmap context
			brushData = (GLubyte *) calloc(width * height * 4, sizeof(GLubyte));
			// Use  the bitmatp creation function provided by the Core Graphics framework. 
			brushContext = CGBitmapContextCreate(brushData, width, height, 8, width * 4, CGImageGetColorSpace(brushImage), kCGImageAlphaPremultipliedLast);
			// After you create the context, you can draw the  image to the context.
			CGContextDrawImage(brushContext, CGRectMake(0.0, 0.0, (CGFloat)width, (CGFloat)height), brushImage);
			// You don't need the context at this point, so you need to release it to avoid memory leaks.
			CGContextRelease(brushContext);
			// Use OpenGL ES to generate a name for the texture.
			glGenTextures(1, &brushTexture);
			// Bind the texture name. 
			glBindTexture(GL_TEXTURE_2D, brushTexture);
			// Set the texture parameters to use a minifying filter and a linear filer (weighted average)
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
			//			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
			// Specify a 2D texture image, providing the a pointer to the image data in memory
			glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, brushData);
			// Release  the image data; it's no longer needed
			free(brushData);
		}
		glPointSize(width / brushScale);
		[brushUIImage release];
		
		glDisable(GL_DITHER);
		glEnable(GL_TEXTURE_2D);
		glEnableClientState(GL_VERTEX_ARRAY);
		
		glEnable(GL_BLEND);
		// Set a blending function appropriate for premultiplied alpha pixel data
		glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
		
		glEnable(GL_POINT_SPRITE_OES);
		glTexEnvf(GL_POINT_SPRITE_OES, GL_COORD_REPLACE_OES, GL_TRUE);
		
		
		
		glMatrixMode(GL_PROJECTION);
		
		glViewport(0, 0, frame.size.width ,  frame.size.height );
		
		
		imageSize=size;
		
		// 그림판(가상 버퍼)의 사이즈를 정한다.
		// 가로가 1024보다 작아지면 화면해상도보다 낮은 사이즈의 버퍼를 가지므로 보기가 안좋아 진다.
		// 따라서 가로를 1024로 두고 세로를 이미지 사이즈에 비례하여 맞춘다.
		bufferSize=CGSizeMake(1024, 1024*(imageSize.height/imageSize.width));
		
		glOrthof(0, bufferSize.width, 0, bufferSize.height, -1, 1);
		
		glMatrixMode(GL_MODELVIEW);
		
		
		[self performSelectorInBackground:@selector(createFramebuffer:) withObject:delegate];
		
		
	}
	
	return self;
}

// If our view is resized, we'll be asked to layout subviews.
// This is the perfect opportunity to also update the framebuffer so that it is
// the same size as our display area.
-(void)layoutSubviews
{
}

- (BOOL)createFramebuffer:(id)delegate
{
	
	[EAGLContext setCurrentContext:context];
	
	// Generate IDs for a framebuffer object and a color renderbuffer
	glGenFramebuffersOES(1, &viewFramebuffer);
	glGenRenderbuffersOES(1, &viewRenderbuffer);
	
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	// This call associates the storage for the current render buffer with the EAGLDrawable (our CAEAGLLayer)
	// allowing us to draw into a buffer that will later be rendered to screen wherever the layer is (which corresponds with our view).
	[context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(id<EAGLDrawable>)self.layer];
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
	
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
	
	// For this sample, we also need a depth buffer, so we'll create and attach one via another renderbuffer.
	
	// depth buffer 필요 없다고 판단 - 주석처리.
	//	glGenRenderbuffersOES(1, &depthRenderbuffer);
	//	glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
	//	glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, backingWidth, backingHeight);
	//	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer);
	
	
	if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES)
	{
		NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
		return NO;
	}
	
	[self performSelector:@selector(drawSavedData:) withObject:delegate];
	
	
	return YES;
}

// Clean up any buffers we have allocated.
- (void)destroyFramebuffer
{
	glDeleteFramebuffersOES(1, &viewFramebuffer);
	viewFramebuffer = 0;
	glDeleteRenderbuffersOES(1, &viewRenderbuffer);
	viewRenderbuffer = 0;
	
	//	depth버퍼는 안만들었으므로 또 주석처리
	//	if(depthRenderbuffer)
	//	{
	//		glDeleteRenderbuffersOES(1, &depthRenderbuffer);
	//		depthRenderbuffer = 0;
	//	}
}

// Releases resources when they are not longer needed.
- (void) dealloc
{
	if(drawOperation){
		[drawOperation cancel];
		[drawOperation release];
	}
	[drawQueue release];
	
	if (brushTexture)
	{
		glDeleteTextures(1, &brushTexture);
		brushTexture = 0;
	}
	
	[self destroyFramebuffer];
	
	if([EAGLContext currentContext] == context)
	{
		[EAGLContext setCurrentContext:nil];
	}
	
	[context release];

	
	[super dealloc];
}

// Erases the screen
- (void) erase
{
	
	[EAGLContext setCurrentContext:context];
	
	// Clear the buffer
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	glClearColor(0.0, 0.0, 0.0, 0.0);
	glClear(GL_COLOR_BUFFER_BIT);
	
	// Display the buffer
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];
}

// Drawings a line onscreen based on where the user touches
- (void) renderLineFromPoint:(CGPoint)start toPoint:(CGPoint)end
{
	GLfloat*		vertexBuffer = NULL;
	static NSUInteger	vertexMax = 64;
	NSUInteger			vertexCount = 0,
	count,
	i;
	
	[EAGLContext setCurrentContext:context];
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	
	// Allocate vertex array buffer
	if(vertexBuffer == NULL)
		vertexBuffer = malloc(vertexMax * 2 * sizeof(GLfloat));
	
	// Add points to the buffer so there are drawing points every X pixels
	count = MAX(ceilf(sqrtf((end.x - start.x) * (end.x - start.x) + (end.y - start.y) * (end.y - start.y)) / kBrushPixelStep), 1);
	for(i = 0; i < count; ++i) {
		if(vertexCount == vertexMax) {
			vertexMax = 2 * vertexMax;
			vertexBuffer = realloc(vertexBuffer, vertexMax * 2 * sizeof(GLfloat));
		}
		
		vertexBuffer[2 * vertexCount + 0] = start.x + (end.x - start.x) * ((GLfloat)i / (GLfloat)count);
		vertexBuffer[2 * vertexCount + 1] = start.y + (end.y - start.y) * ((GLfloat)i / (GLfloat)count);
		
		vertexCount += 1;
	}
	
//		전송하기
		NSLog(@"전송해댜 ");

		// currentPenInfo
		// vertexBuffer
		// vertexCount
		[presentationDelegate sendServerDrawInfoPen:currentPenInfo start:start end:end];
		

	glColor4f(brushRed,
			  brushGreen,
			  brushBlue,
			  1
			  );
	if(1>0)glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
	if(1==0)glBlendFunc(1, 0);
	
	glPointSize(width/5.0f);
	
	
	// Render the vertex array
	glVertexPointer(2, GL_FLOAT, 0, vertexBuffer);
	glDrawArrays(GL_POINTS, 0, vertexCount);
	[drawingData.countArr addObject:[NSNumber numberWithInt:count]];
	[drawingData.infoArr addObject:currentPenInfo];
	
	drawingData.dataArr=realloc(drawingData.dataArr, [drawingData.countArr count] * sizeof(GLfloat*));
	drawingData.dataArr[[drawingData.countArr count]-1]=vertexBuffer;
	
	
	// Display the buffer
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];
}


// Drawings a line onscreen based on where the user touches
- (void) drawFromServerStart:(CGPoint)start toPoint:(CGPoint)end penInfo:(NSMutableData *)penInfo
{
	GLfloat*		vertexBuffer = NULL;
	static NSUInteger	vertexMax = 64;
	NSUInteger			vertexCount = 0,
	count,
	i;
	
	[EAGLContext setCurrentContext:context];
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	
	// Allocate vertex array buffer
	if(vertexBuffer == NULL)
		vertexBuffer = malloc(vertexMax * 2 * sizeof(GLfloat));
	
	// Add points to the buffer so there are drawing points every X pixels
	count = MAX(ceilf(sqrtf((end.x - start.x) * (end.x - start.x) + (end.y - start.y) * (end.y - start.y)) / kBrushPixelStep), 1);
	for(i = 0; i < count; ++i) {
		if(vertexCount == vertexMax) {
			vertexMax = 2 * vertexMax;
			vertexBuffer = realloc(vertexBuffer, vertexMax * 2 * sizeof(GLfloat));
		}
		
		vertexBuffer[2 * vertexCount + 0] = start.x + (end.x - start.x) * ((GLfloat)i / (GLfloat)count);
		vertexBuffer[2 * vertexCount + 1] = start.y + (end.y - start.y) * ((GLfloat)i / (GLfloat)count);
		
		vertexCount += 1;
	}

	const CGFloat *infoFloat=[penInfo bytes];
	
	glColor4f(infoFloat[0] * infoFloat[4],
			  infoFloat[1] * infoFloat[4],
			  infoFloat[2] * infoFloat[4],
			  infoFloat[4]
			  );
	if(infoFloat[4]>0)glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
	if(infoFloat[4]==0)glBlendFunc(1, 0);
	
	glPointSize(width/infoFloat[3]);

	// Render the vertex array
	glVertexPointer(2, GL_FLOAT, 0, vertexBuffer);
	glDrawArrays(GL_POINTS, 0, vertexCount);
	[drawingData.countArr addObject:[NSNumber numberWithInt:count]];
	[drawingData.infoArr addObject:penInfo];
	
	drawingData.dataArr=realloc(drawingData.dataArr, [drawingData.countArr count] * sizeof(GLfloat*));
	drawingData.dataArr[[drawingData.countArr count]-1]=vertexBuffer;
	
	
	// Display the buffer
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];
}


// 화면과 그려진 데이터를 지운다
-(void)resetData{
	
//	pageInfo.drawData = [[[NSMutableArray alloc] init] autorelease];
//	[pageInfo parseFromDrawData];
	[self erase];
}

// 저장된 데이터를 화면에 출력해준다
-(void)drawSavedData:(id)delegate{
	NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
	
	// 이전 화면을 그리고 있는 경우 취소한다
	if(drawOperation){
		[drawOperation cancel];
		[drawOperation release];
	}
	
	// 화면을 그리는 Operation을 만들어 작업 큐에 추가한다
//	drawOperation=[[DrawingSavedDataOperation alloc] initWithContext:context Framebuffer:viewFramebuffer Renderbuffer:viewRenderbuffer pageInfo:pageInfo width:width];
//	[drawOperation setDelegate:delegate];
//	[drawQueue addOperation:drawOperation];
	[pool release];
} 

// Handles the start of a touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"touch!");
	//	CGRect bounds = [self bounds];
	if([touches count]==3){
		[super touchesBegan:touches withEvent:event];
		return;
		
	}
	
    UITouch*	touch = [[event touchesForView:self] anyObject];
	firstTouch = YES;
	if([[event allTouches] count]>1)return;
	
	// Convert touch point from UIView referential to OpenGL one (upside-down flip)
	location = [touch locationInView:self];
	location.x*=bufferSize.width/self.frame.size.width;
	location.y*=bufferSize.width/self.frame.size.width;
	location.y = bufferSize.height - location.y;
	
	
	NSLog(@"start %f %f %f %f %f %@",brushRed,brushGreen,brushGreen,brushAlpha,brushScale,self);
	// 색상, 굵기, 투명도 저장
	currentPenInfo=[[NSMutableData alloc] init];
	[currentPenInfo appendBytes:&brushRed length:sizeof(CGFloat)];
	[currentPenInfo appendBytes:&brushGreen length:sizeof(CGFloat)];
	[currentPenInfo appendBytes:&brushBlue length:sizeof(CGFloat)];
	[currentPenInfo appendBytes:&brushScale length:sizeof(CGFloat)];
	[currentPenInfo appendBytes:&brushAlpha length:sizeof(CGFloat)];
	
	
	
	// 선 정보 저장을 위한 NSData
	currentDrawing= [[NSMutableData alloc] init];
	[currentDrawing appendBytes:&location length:sizeof(CGPoint)];
	
	//[self renderLineFromPoint:location toPoint:location];
	
}

// Handles the continuation of a touch.
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{  
	if([[event allTouches] count]>1)return;
	
	
	
	UITouch*			touch = [[event touchesForView:self] anyObject];
	
	// Convert touch point from UIView referential to OpenGL one (upside-down flip)
	previousLocation=location;
	if (firstTouch) {
		firstTouch = NO;
		//		previousLocation = [touch previousLocationInView:self];
		
	} else {
		location = [touch locationInView:self];
		location.x*=bufferSize.width/self.frame.size.width;
		location.y*=bufferSize.width/self.frame.size.width;
	    location.y = bufferSize.height - location.y;
		//		previousLocation = [touch previousLocationInView:self];
		
	}
	//	previousLocation.x*=imageSize.width/self.frame.size.width;
	//	previousLocation.y*=imageSize.width/self.frame.size.width;
	//	previousLocation.y = imageSize.height - previousLocation.y;
	
	
	NSLog(@"touch moved");
	[currentDrawing appendBytes:&location length:sizeof(CGPoint)];
	// Render the stroke
	[self renderLineFromPoint:previousLocation toPoint:location];
}

// Handles the end of a touch event when the touch is a tap.
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if([[event allTouches] count]>1)return;
	NSLog(@"touch ended drawing - %@ pen - %@",currentDrawing,currentPenInfo);
	
	//    UITouch*	touch = [[event touchesForView:self] anyObject];
	if (firstTouch) {
		firstTouch = NO;
		//		previousLocation = [touch previousLocationInView:self];
		//		previousLocation.x*=imageSize.width/self.frame.size.width;
		//		previousLocation.y*=imageSize.width/self.frame.size.width;
		//		previousLocation.y = imageSize.height - previousLocation.y;
		
		[self renderLineFromPoint:location toPoint:location];
	}
	
//	[pageInfo. drawData addObject:currentPenInfo];
	[currentPenInfo release];
	currentPenInfo=nil;
	
//	[pageInfo.drawData addObject:currentDrawing];
	[currentDrawing release];
	currentDrawing=nil;
}

// Handles the end of a touch event.
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	
	if (!firstTouch&&currentPenInfo&&currentDrawing) {
//		[pageInfo. drawData addObject:currentPenInfo];
		[currentPenInfo release];
		
//		[pageInfo. drawData addObject:currentDrawing];
		[currentDrawing release];
	}
	// If appropriate, add code necessary to save the state of the application.
	// This application is not saving state.
}


- (void)setBrushColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
	
	brushRed=red;
	brushGreen=green;
	brushBlue=blue;
	[EAGLContext setCurrentContext:context];
	
	NSLog(@"칼라 세팅 %f %f %f %@",brushRed,brushGreen,brushBlue,self);
	
	// Set the brush color using premultiplied alpha values
	glColor4f(red	* brushAlpha,
			  green * brushAlpha,
			  blue	* brushAlpha,
			  brushAlpha);
}

-(void)setBrushAlpha:(CGFloat)alpha{
	if(alpha==0)glBlendFunc(1, 0);
	else glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
	
	brushAlpha=alpha;
	[EAGLContext setCurrentContext:context];
	
	// Set the brush color using premultiplied alpha values
	glColor4f(brushRed	* brushAlpha,
			  brushGreen * brushAlpha,
			  brushBlue	* brushAlpha,
			  brushAlpha);
}

-(void)setBrushScale:(CGFloat)scale{
	brushScale=scale;
	[EAGLContext setCurrentContext:context];
	glPointSize(width / brushScale);
}

-(void)startDrawing{
	drawing=YES;
}

-(void)stopDrawing{
	drawing=NO;
//	[pageInfo saveDrawing];
	
}





-(void)setDrawingData:(DrawingData *)_drawingData{

	[drawingData release];
	drawingData=[_drawingData retain];
	
	CGFloat r,g,b,alpha,scale;

	
	[EAGLContext setCurrentContext:context];
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	
	glClearColor(0.0, 0.0, 0.0, 0.0);
	glClear(GL_COLOR_BUFFER_BIT);
	
	for(NSUInteger i=0;i<[drawingData.infoArr count];i++){
//		if([self isCancelled])break;
		CGFloat *infoFloat=(CGFloat *)[[drawingData.infoArr objectAtIndex:i] bytes];
		
		
		if(i==0||r!=infoFloat[0]||g!=infoFloat[1]||b!=infoFloat[2]||alpha!=infoFloat[4]){
			
			glColor4f(infoFloat[0] * infoFloat[4],
					  infoFloat[1] * infoFloat[4],
					  infoFloat[2] * infoFloat[4],
					  infoFloat[4]
					  );
			if((i==0||alpha==0)&&infoFloat[4]>0)glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
			if((i==0||alpha>0)&&infoFloat[4]==0)glBlendFunc(1, 0);
			
			r=infoFloat[0];
			g=infoFloat[1];
			b=infoFloat[2];
			alpha=infoFloat[4];
			
		}
		if(i==0||scale!=infoFloat[3]){
			glPointSize(width/infoFloat[3]);
			scale=infoFloat[3];
		}
		
		// Render the vertex array
		glVertexPointer(2, GL_FLOAT, 0, drawingData.dataArr[i]);
		glDrawArrays(GL_POINTS, 0, [[drawingData.countArr objectAtIndex:i] intValue]);
		
		
		
	}
	
	//	메인 쓰레드에서 진행되므로 뒤로 밀려있는 사이에 cancel이 되느것 같아서
	//	printContex 안에서 isCancelled를 체크
	//	if([self isCancelled]==NO){
	// 화면에 뿌릴땐 메인 쓰레드에서 해준다

	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];

//	[delegate performSelector:@selector(loadComplete)];

	
}



@end


/*
 페이지에 저장된 펜 그리기 기록을 다시 그려주는 작업 Class
 그리기 기록은 시작할때 모두 파일로부터 읽어와 배열화 되어있으므로
 그려주기만 한다.
 */
/*
@implementation DrawingSavedDataOperation
@synthesize delegate;

-(id)initWithContext:(EAGLContext *)_context Framebuffer:(GLuint)_viewFramebuffer Renderbuffer:(GLuint)_viewRenderbuffer pageInfo:(FCPageInfo *)_pageInfo width:(CGFloat)_width{
	self=[super init];
	
	context=[_context retain];
	viewRenderbuffer=_viewRenderbuffer;
	viewFramebuffer=_viewFramebuffer;
	pageInfo=[_pageInfo retain];
	
	width=_width;
	return self;
}

-(void)main{
	
	NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
	
	[EAGLContext setCurrentContext:context];
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	
	glClearColor(0.0, 0.0, 0.0, 0.0);
	glClear(GL_COLOR_BUFFER_BIT);
	
	for(NSUInteger i=0;i<[pageInfo.infoArr	count];i++){
		if([self isCancelled])break;
		CGFloat *infoFloat=(CGFloat *)[[pageInfo.infoArr objectAtIndex:i] bytes];
		
		
		if(i==0||r!=infoFloat[0]||g!=infoFloat[1]||b!=infoFloat[2]||alpha!=infoFloat[4]){
			
			glColor4f(infoFloat[0] * infoFloat[4],
					  infoFloat[1] * infoFloat[4],
					  infoFloat[2] * infoFloat[4],
					  infoFloat[4]
					  );
			if((i==0||alpha==0)&&infoFloat[4]>0)glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
			if((i==0||alpha>0)&&infoFloat[4]==0)glBlendFunc(1, 0);
			
			r=infoFloat[0];
			g=infoFloat[1];
			b=infoFloat[2];
			alpha=infoFloat[4];
			
		}
		if(i==0||scale!=infoFloat[3]){
			glPointSize(width/infoFloat[3]);
			scale=infoFloat[3];
		}
		
		// Render the vertex array
		glVertexPointer(2, GL_FLOAT, 0, pageInfo.dataArr[i]);
		glDrawArrays(GL_POINTS, 0, [[pageInfo.countArr objectAtIndex:i] intValue]);
		
		
		
	}
	
	//	메인 쓰레드에서 진행되므로 뒤로 밀려있는 사이에 cancel이 되느것 같아서
	//	printContex 안에서 isCancelled를 체크
	//	if([self isCancelled]==NO){
	// 화면에 뿌릴땐 메인 쓰레드에서 해준다
	[self performSelectorOnMainThread:@selector(printContext) withObject:nil waitUntilDone:NO];
	//	}
	[pool release];
	
}

-(void)printContext{
	if([self isCancelled])return;
	// Display the buffer
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];
	NSLog(@"is mainthread ? %d",[NSThread isMainThread]);
	NSLog(@"delegate has gone?? %@",delegate);
	NSLog(@"is cancelled? %d",[self isCancelled]);
	[delegate performSelector:@selector(loadComplete)];
}

-(void)dealloc{
	[context release];
	[pageInfo release];
	[super dealloc];
}

@end*/