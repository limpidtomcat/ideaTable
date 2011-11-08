//
//  PresentationController.m
//  IdeaTable
//
//  Created by Woo Chang ha on 11. 10. 23..
//  Copyright (c) 2011년 O.o.Z. All rights reserved.
//

#import "PresentationController.h"
#import "UserInfo.h"
#import "ClearTableViewController.h"
@implementation PresentationController
@synthesize drawingDataArray;
@synthesize paintView;
@synthesize pdfViewController;
@synthesize documentManager;
@synthesize clientObject;
@synthesize waitingViewDelegate;
@synthesize userList;
@synthesize tableInfo;


-(id)initWithPdfUrl:(NSURL *)url isMaster:(BOOL)_isMaster tableInfo:(TableInfo *)_tableInfo{
	self=[super init];
	if(self){
		tableInfo=[_tableInfo retain];
		isMaster=_isMaster;
		/** Instancing the documentManager */
		documentManager = [[MFDocumentManager alloc]initWithFileUrl:url];
		
		/** Instancing the readerViewController */
		pdfViewController = [[PDFViewController alloc]initWithDocumentManager:documentManager];
		[pdfViewController addOverlayViewDataSource:self];

		[pdfViewController setDocumentDelegate:self];
		if(!isMaster)[pdfViewController setScrollLock:YES];
		

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
		
//		NSArray *data=[NSKeyedUnarchiver unarchiveObjectWithFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"data.pen"]];
//		drawingDataArray=[[NSMutableArray alloc] initWithArray:data];

		// Painting View Initialize.
		paintView=[[PaintingView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024) photoSize:pdfSize delegate:self drawQueue:nil];
		[paintView resetData];
		[paintView erase];

		const float *rgba=CGColorGetComponents([UserInfo me].penColor.CGColor);
		
		[paintView setBrushColorWithRed:(rgba[0]*255) green:(rgba[1]*255) blue:(rgba[2]*255)];
		[paintView setBrushAlpha:1.0f];
		[paintView setBrushScale:5.0f];
		[paintView setUserInteractionEnabled:NO];
		
		[paintView setPresentationDelegate:self];

		
		[tableInfo setStartTimestamp:[NSString stringWithFormat:@"%d",(int)[[NSDate date] timeIntervalSince1970]]];

		
		if(tableInfo.shouldRecord){
			audioRecordController=[[AudioRecordController alloc] init];
			[audioRecordController setRecordFile:[tableInfo.startTimestamp stringByAppendingPathExtension:@"caf"]];
			[audioRecordController startRecording];
			
		}

	
		UIBarButtonItem *home,*lock,*draw;
		UIBarButtonItem *back,*pen, *eraser;
		UIBarButtonItem *flexible,*fix;
		flexible=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		fix=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
		[fix setWidth:10];
		
		home=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"53-house.png"] style:UIBarButtonItemStylePlain target:self action:@selector(closeTable)];
		draw=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"98-palette.png"] style:UIBarButtonItemStylePlain target:self action:@selector(drawOn)];
		lock=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"54-lock.png"] style:UIBarButtonItemStylePlain target:self action:@selector(clientDrawLock:)];
		
		back =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"01-refresh.png"] style:UIBarButtonItemStylePlain target:self action:@selector(drawOff)];
		pen=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"187-pencil.png"] style:UIBarButtonItemStylePlain target:self action:@selector(setPen)];
		eraser=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"eraser_alpha.png"] style:UIBarButtonItemStylePlain target:self action:@selector(setEraser)];
		
		
		if(isMaster)
			mainItems=[[NSArray alloc] initWithObjects:home,flexible,lock,fix,draw, nil];
		else
			mainItems=[[NSArray alloc] initWithObjects:home,flexible,draw, nil];
		drawingItems=[[NSArray alloc] initWithObjects:back,flexible,pen,fix,eraser, nil];
		
		[home	release];
		[lock	release];
		[draw	release];
		
		[back	release];
		[pen	release];
		[eraser	release];
		
		[flexible release];
		[fix release];

		// Force PDFViewController to load view
		[pdfViewController view];
		[pdfViewController.toolBar setItems:mainItems];
	}
	return self;
}

-(void)dealloc{
	[tableInfo release];
	[audioRecordController release];
	[drawingDataArray release];
	[documentManaber release];
	[pdfViewController release];
	[paintView release];
	[clientObject release];
	[mainItems release];
	[drawingItems release];
	[super dealloc];
}



- (NSSet *)documentViewController:(MFDocumentViewController *)dvc overlayViewsForPage:(NSUInteger)page
{
	NSLog(@"finding drawables - %d",page);
	
	NSSet *arr=[NSSet setWithObjects:paintView, nil];
	if(page<[drawingDataArray count]){
		[paintView resetData];
		
		NSLog(@"drawing data array - %@",drawingDataArray);
		NSLog(@"selected - %@",[drawingDataArray objectAtIndex:page]);
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
	[paintView setUserInteractionEnabled:flag];
	if(flag){
		[pdfViewController setScrollLock:YES];
		[paintView startDrawing];
		
	}else{
		if(isMaster)[pdfViewController setScrollLock:NO];
		[paintView stopDrawing];
	}
	
	
}

-(void)drawOn{
	if(drawLock && !isMaster)return;
	
	[self setDrawing:YES];
	[pdfViewController.toolBar setItems:drawingItems];
}
-(void)drawOff{
	[self setDrawing:NO];
	[pdfViewController.toolBar setItems:mainItems];
}



-(void)closeTable{
	
	[tableInfo setOverTimestamp:[NSString stringWithFormat:@"%d",(int)[[NSDate date] timeIntervalSince1970]]];

	if(tableInfo.shouldRecord)
		[audioRecordController stopRecording];
	if(isMaster)[clientObject sendPresentationOverMessage];
	
	ClearTableViewController *viewController=[[ClearTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	[viewController setTableInfo:tableInfo];
	[viewController setAudioRecordController:audioRecordController];
	[viewController setDrawingDataArray:drawingDataArray];
	[pdfViewController.parentViewController pushViewController:viewController animated:NO];
	
	[viewController release];

	[pdfViewController dismissModalViewControllerAnimated:YES];
	[pdfViewController cleanUp];
}

-(void)clientDrawLock:(id)sender{
	UIBarButtonItem *sendBtn=(UIBarButtonItem *)sender;
	
	drawLock=!drawLock;

	if(drawLock)
		[sendBtn setImage:[UIImage imageNamed:@"unlock.png"]];
	else 
		[sendBtn setImage:[UIImage imageNamed:@"54-lock.png"]];
	
	[self sendServerDrawLock:drawLock];
}


-(void)setDrawLock:(BOOL)locked{
	NSLog(@"lock! - %d",locked);
	drawLock=locked;
	if(drawLock&&!isMaster){
		[self setDrawing:NO];
	}
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


-(void)setPen{
	NSLog(@"pen set");
	[paintView setBrushAlpha:1];
}
-(void)setEraser{
	NSLog(@"eraser set");
	[paintView setBrushAlpha:0];
}

@end
