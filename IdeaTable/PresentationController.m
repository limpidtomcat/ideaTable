//
//  PresentationController.m
//  IdeaTable
//
//  Created by Woo Chang ha on 11. 10. 23..
//  Copyright (c) 2011년 O.o.Z. All rights reserved.
//

#import "PresentationController.h"

@implementation PresentationController
@synthesize drawingDataArray;
@synthesize paintView;
@synthesize pdfViewController;
@synthesize documentManager;
@synthesize isMaster;
@synthesize clientObject;
@synthesize waitingViewDelegate;



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

		
	
		drawingDataArray= [[NSMutableArray alloc] init];
		
		for(NSUInteger i=0;i<[documentManager numberOfPages];i++){
			DrawingData *data=[[DrawingData alloc] init];
			[drawingDataArray addObject:data];
			[data release];
		}
		NSLog(@"array - %@",drawingDataArray);

//		CGSize bookSize=documentManager.
		
		paintView=[[PaintingView alloc] initWithFrame:CGRectMake(0, 0, 320, 460) photoSize:CGSizeMake(576, 822) delegate:self drawQueue:nil];
		//	[paintView setBackgroundColor:[UIColor redColor]];
		[paintView resetData];
		[paintView erase];
		[paintView setBrushColorWithRed:0 green:0 blue:0];
		[paintView setBrushAlpha:1.0f];
		[paintView setBrushScale:5.0f];
		[paintView setUserInteractionEnabled:NO];
		
		
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
	NSLog(@"converted rect - %@",NSStringFromCGRect([pdfViewController convertRect:CGRectMake(0, 0, 596, 842) fromViewToPage:0]));
	
	return [pdfViewController convertRect:CGRectMake(0, 0, 586, 842) fromViewToPage:0];
	
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
	[waitingViewDelegate endTable:pdfViewController];
}


#pragma MFDocumentViewControllerDelegate methods

- (void)documentViewController:(MFDocumentViewController *)dvc didGoToPage:(NSUInteger)page{
	NSLog(@"did go to page %d",page);
	
	if(isMaster)[clientObject sendMessagePageMovedTo:page];
}



-(void)setPage:(NSUInteger)page{
	[pdfViewController setPage:page];
}

@end
