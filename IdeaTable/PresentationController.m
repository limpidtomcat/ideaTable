//
//  PresentationController.m
//  IdeaTable
//
//  Created by Woo Chang ha on 11. 10. 23..
//  Copyright (c) 2011년 O.o.Z. All rights reserved.
//

#import "PresentationController.h"
#import "UserInfo.h"
@implementation PresentationController
@synthesize drawingDataArray;
@synthesize paintView;
@synthesize pdfViewController;
@synthesize documentManager;
@synthesize isMaster;
@synthesize clientObject;
@synthesize waitingViewDelegate;
@synthesize userList;



-(id)initWithPdfUrl:(NSURL *)url{
	self=[super init];
	if(self){
		/** Instancing the documentManager */
		documentManager = [[MFDocumentManager alloc]initWithFileUrl:url];
		
		/** Instancing the readerViewController */
		pdfViewController = [[PDFViewController alloc]initWithDocumentManager:documentManager presentationDelegate:self];
		//	[pdfViewController setOverlayEnabled:NO];

//		[pdfViewController setWaitingViewDelegate:waitingViewDelegate];

		[pdfViewController setDocumentDelegate:self];
		
//		[documentManager.docu
//		 CG
		

		CGPDFDocumentRef pdf=CGPDFDocumentCreateWithURL((CFURLRef)url);
		
		CGPDFPageRef pdfPage=CGPDFDocumentGetPage(pdf, 1);
		CGRect pdfRect= CGPDFPageGetBoxRect(pdfPage, kCGPDFBleedBox);

		pdfSize=pdfRect.size;

	
		drawingDataArray= [[NSMutableArray alloc] init];
		
		for(NSUInteger i=0;i<[documentManager numberOfPages];i++){
			DrawingData *data=[[DrawingData alloc] init];
			[drawingDataArray addObject:data];
			[data release];
		}
		NSLog(@"array - %@",drawingDataArray);

		
		paintView=[[PaintingView alloc] initWithFrame:CGRectMake(0, 0, 320, 460) photoSize:pdfSize delegate:self drawQueue:nil];
		//	[paintView setBackgroundColor:[UIColor redColor]];
		[paintView resetData];
		[paintView erase];

		const float *rgba=CGColorGetComponents([UserInfo me].penColor.CGColor);
		
		[paintView setBrushColorWithRed:(rgba[0]*255) green:(rgba[1]*255) blue:(rgba[2]*255)];
		[paintView setBrushAlpha:1.0f];
		[paintView setBrushScale:5.0f];
		[paintView setUserInteractionEnabled:NO];
		
		[paintView setPresentationDelegate:self];
		
	}
	return self;
}

-(void)dealloc{
	[drawingDataArray release];
	[documentManaber release];
	[pdfViewController release];
	[paintView release];
	[clientObject release];
	[super dealloc];
}



- (NSSet *)documentViewController:(MFDocumentViewController *)dvc overlayViewsForPage:(NSUInteger)page
{
	NSLog(@"finding drawables - %d",page);
	
	NSSet *arr=[NSSet setWithObjects:paintView, nil];
	if(page<[drawingDataArray count]){
		[paintView resetData];
		
		NSLog(@"drawing data array - %@",drawingDataArray);
		[paintView setDrawingData:[drawingDataArray objectAtIndex:page]];
	}
	
	
	return arr;
}
- (CGRect)documentViewController:(MFDocumentViewController *)dvc rectForOverlayView:(UIView *)view
{
	NSLog(@"rect for overlay view %@",view);
	
	CGRect rect;
	rect.origin=CGPointMake(0, 0);
	rect.size=pdfSize;
	NSLog(@"converted rect - %@",NSStringFromCGRect([pdfViewController convertRect:rect fromViewToPage:0]));
	return [pdfViewController convertRect:rect fromViewToPage:0];
	
}
- (void)documentViewController:(MFDocumentViewController *)dvc willAddOverlayView:(UIView *)view
{
	NSLog(@"will add overlay");
}


-(void)setDrawing:(BOOL)flag{
	if(flag){
		[paintView setUserInteractionEnabled:YES];
		[paintView startDrawing];
		
	}else{
		[paintView setUserInteractionEnabled:NO];
		[paintView stopDrawing];
	}
	
	
}

-(void)closeTable{
	if(isMaster)[clientObject sendPresentationOverMessage];
	[waitingViewDelegate endTable:pdfViewController];
}

-(void)drawLock:(BOOL)locked{
	NSLog(@"lock! - %d",locked);
	[pdfViewController setDrawLock:locked];
}

#pragma MFDocumentViewControllerDelegate methods

- (void)documentViewController:(MFDocumentViewController *)dvc didGoToPage:(NSUInteger)page{
	NSLog(@"did go to page %d",page);
	
	if(isMaster)[clientObject sendMessagePageMovedTo:page];
}



-(void)setPage:(NSUInteger)page{
	[pdfViewController setPage:page];
}

-(void)sendServerDrawInfoPen:(NSMutableData *)penInfo start:(CGPoint )start end:(CGPoint)end{

//	CGFloat *infoFloat=(CGFloat *)[penInfo bytes];
//	
//	NSLog(@"rgbas=%f,%f,%f,%f,%f",infoFloat[0],infoFloat[1],infoFloat[2],infoFloat[4],infoFloat[3]);
//	NSLog(@"start %@",NSStringFromCGPoint(start));
//	NSLog(@"end %@",NSStringFromCGPoint(end));


	[clientObject sendDrawingInfoPen:penInfo start:start end:end];

	
}
-(void)sendServerDrawLock:(BOOL)locked{
	[clientObject sendDrawLock:locked];
}

-(void)receivedDrawInfoPen:(NSMutableData *)penInfo start:(CGPoint)start end:(CGPoint)end{
	[paintView drawFromServerStart:start toPoint:end penInfo:penInfo];
}

@end
