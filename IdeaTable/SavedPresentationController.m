//
//  SavedPresentationController.m
//  IdeaTable
//
//  Created by Woo Chang ha on 11. 11. 6..
//  Copyright (c) 2011년 O.o.Z. All rights reserved.
//

#import "SavedPresentationController.h"

@implementation SavedPresentationController
@synthesize drawingDataArray;
@synthesize paintView;
@synthesize pdfViewController;
@synthesize documentManager;


-(id)initWithTimestamp:(NSString *)timestamp{
//-(id)initWithPdfUrl:(NSURL *)url{
	self=[super init];
	if(self){
		NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSString *savePath=[docPath stringByAppendingPathComponent:@"SavedTable"];
		
		NSString *pdfPath=[savePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf",timestamp]];
		NSURL *url=[NSURL fileURLWithPath:pdfPath];
		
		/** Instancing the documentManager */
		documentManager = [[MFDocumentManager alloc]initWithFileUrl:url];
		
		/** Instancing the readerViewController */
		pdfViewController = [[PDFViewController alloc]initWithDocumentManager:documentManager];
		
		[pdfViewController setDocumentDelegate:self];
		
		CGPDFDocumentRef pdf=CGPDFDocumentCreateWithURL((CFURLRef)url);
		
		CGPDFPageRef pdfPage=CGPDFDocumentGetPage(pdf, 1);
		CGRect pdfRect= CGPDFPageGetBoxRect(pdfPage, kCGPDFBleedBox);
		
		pdfSize=pdfRect.size;
		
		
		NSString *drawPath=[savePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pen",timestamp]];
		NSArray *data=[NSKeyedUnarchiver unarchiveObjectWithFile:drawPath];
		drawingDataArray=[[NSMutableArray alloc] initWithArray:data];
		
		// Painting View Initialize.
		paintView=[[PaintingView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024) photoSize:pdfSize delegate:self drawQueue:nil];
		[paintView resetData];
		[paintView erase];
		
		[paintView setUserInteractionEnabled:NO];
		
		[paintView setPresentationDelegate:self];
		
		[pdfViewController addOverlayViewDataSource:self];
		UIBarButtonItem *home;
		UIBarButtonItem *flexible,*fix;
		flexible=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		fix=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
		[fix setWidth:10];
		
		home=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"53-house.png"] style:UIBarButtonItemStylePlain target:self action:@selector(closeTable)];
		
		mainItems=[[NSArray alloc] initWithObjects:home, nil];
		
		[home	release];
		
		[flexible release];
		[fix release];
		
		// Force PDFViewController to load view
		[pdfViewController view];
		[pdfViewController.toolBar setItems:mainItems];
	}
	return self;
}

-(void)dealloc{
	[drawingDataArray release];
	[documentManaber release];
	[pdfViewController release];
	[paintView release];
	[mainItems release];
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


-(void)closeTable{
	
	[pdfViewController dismissModalViewControllerAnimated:YES];
}

@end
