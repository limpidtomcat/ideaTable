//
//  PDFViewController.m
//  IdeaTable
//
//  Created by Woo Jeff on 11. 9. 30..
//  Copyright 2011년 O.o.Z. All rights reserved.
//

#import "PDFViewController.h"
#import "FastPdfKit/MFDocumentViewController.h"
#import "CreateMemoController.h"

@implementation PDFViewController
@synthesize isMaster;
@synthesize  clientObject;
@synthesize waitingViewDelegate;

-(void)setScrollLock:(BOOL)isLocked{
	UIScrollView *pageView=nil;
	
	for(UIView *view in self.view.subviews){
		if([view isKindOfClass:[UIScrollView class]])
			pageView=(UIScrollView *)view;
	}

	if(pageView){
		[pageView setScrollEnabled:!isLocked];
	}

}

- (NSSet *)documentViewController:(MFDocumentViewController *)dvc overlayViewsForPage:(NSUInteger)page
{
	NSLog(@"finding drawables - %d",page);

	NSSet *arr=[NSSet setWithObjects:paintView, nil];
	[paintView resetData];
	
	NSLog(@"drawing data array - %@",drawingDataArray);
	[paintView setDrawingData:[drawingDataArray objectAtIndex:page]];

	
	return arr;
}
- (CGRect)documentViewController:(MFDocumentViewController *)dvc rectForOverlayView:(UIView *)view
{
	NSLog(@"rect for overlay view %@",view);
	NSLog(@"converted rect - %@",NSStringFromCGRect([self convertRect:CGRectMake(0, 0, 586, 842) fromViewToPage:0]));
	
	return [self convertRect:CGRectMake(0, 0, 586, 842) fromViewToPage:0];

}
- (void)documentViewController:(MFDocumentViewController *)dvc willAddOverlayView:(UIView *)view
{
	NSLog(@"will add overlay");
}

//- (NSArray *)documentViewController:(MFDocumentViewController *)dvc drawablesForPage:(NSUInteger)page
//{
//}


-(id)initWithDocumentManager:(MFDocumentManager *)aDocumentManager{
	self=[super initWithDocumentManager:aDocumentManager];
	if(self){
		drawingDataArray= [[NSMutableArray alloc] init];
		for(NSUInteger i=0;i<6;i++){
			DrawingData *data=[[DrawingData alloc] init];
			[drawingDataArray addObject:data];
			[data release];
		}
		NSLog(@"array - %@",drawingDataArray);
		
	}
	return self;
}

-(id)initWithClientObject:(ClientObject *)_clientObject{
	self=[super init];
	if(self	){
//		self.
		clientObject=[_clientObject retain];
		self.documentDelegate=self;
//		NSLog(@"overlay view datasource - %@",self.)
//		[self addOverlayDataSource:self];
		

	}
	return self;
}
-(void)dealloc{
	[closeBtn release];
	[drawBtn release];
	[paintView release];
	[clientObject release];
	[super dealloc];
}
			   

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


- (void)viewDidLoad
{
    [super viewDidLoad];
	closeBtn=[[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	[closeBtn setTitle:@"Close" forState:UIControlStateNormal];
	[closeBtn setFrame:CGRectMake(0, 0, 50, 50)];
	[closeBtn addTarget:self action:@selector(closeTable) forControlEvents:UIControlEventTouchUpInside];
	
	drawBtn=[[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	[drawBtn setTitle:@"Draw" forState:UIControlStateNormal];
	[drawBtn setTitle:@"Over" forState:UIControlStateSelected];
	[drawBtn setFrame:CGRectMake(320-50, 0, 50, 50)];
	[drawBtn addTarget:self action:@selector(toggleDraw) forControlEvents:UIControlEventTouchUpInside];

	paintView=[[PaintingView alloc] initWithFrame:CGRectMake(0, 0, 320, 460) photoSize:CGSizeMake(576, 822) delegate:self drawQueue:nil];
//	[paintView setBackgroundColor:[UIColor redColor]];
	[paintView resetData];
	[paintView erase];
	[paintView setBrushColorWithRed:0 green:0 blue:0];
	[paintView setBrushAlpha:1.0f];
	[paintView setBrushScale:5.0f];
	[paintView setUserInteractionEnabled:NO];

//	[self.view addSubview:paintView];
//	[self.view bringSubviewToFront:paintView];

	[self.view addSubview:closeBtn];
	[self.view bringSubviewToFront:closeBtn];
	[self.view addSubview:drawBtn];
	[self.view bringSubviewToFront:drawBtn];
	[self setOverlayEnabled:YES];
	[self addOverlayViewDataSource:self];
	[self setUseTiledOverlayView:YES];
	[self reloadOverlay];
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showMemoView:)];
    [self.view addGestureRecognizer:longPressGesture];
    [longPressGesture release];
	
}

-(void)toggleDraw{
	isDrawing=!isDrawing;
	[drawBtn setSelected:isDrawing];

	
//	NSStringFromCGRect(<#CGRect rect#>)
//	NSLog(@"페이지 크기 - %@",nsstring)
	
	[self setScrollLock:isDrawing];
	
	if(isDrawing){
		[paintView setUserInteractionEnabled:YES];
		[paintView startDrawing];
		
	}else{
		[paintView setUserInteractionEnabled:NO];
		[paintView stopDrawing];
	}

}

-(void)closeTable{
	[waitingViewDelegate endTable:self];
}

- (void)viewDidUnload
{
	[paintView release];
	paintView=nil;
	[closeBtn release];
	closeBtn=nil;
	[drawBtn release];
	drawBtn=nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)documentViewController:(MFDocumentViewController *)dvc didGoToPage:(NSUInteger)page{
	NSLog(@"did go to page %d",page);

	if(isMaster)[clientObject sendMessagePageMovedTo:page];
}


-(void)signalPageMove:(NSUInteger )page{
	if(self.page==page-1)[self moveToNextPage];
	else if(self.page==page-1)[self moveToNextPage];
	else [self setPage:page];
	
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
	
	NSLog(@"scrollviewdidzoom");
	[super scrollViewDidZoom:scrollView];
	[paintView setFrame:[self viewForZoomingInScrollView:scrollView].frame];

	
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	[super scrollViewDidScroll:scrollView];
	
	NSLog(@"scrollview dudscroll %@",NSStringFromCGPoint(scrollView.contentOffset));
//	if(isMaster)[clientObject sendMessagePageScrollWidth:(CGFloat)scrollView.contentOffset.x];
}


- (void)showMemoView:(UILongPressGestureRecognizer *)gestureRecognizer
{

	if(gestureRecognizer.state==UIGestureRecognizerStateBegan){
		NSLog(@"memo success! - %@",gestureRecognizer.view);
		CGPoint pl = [gestureRecognizer locationInView:self.view];
		NSLog(NSStringFromCGPoint(pl));
		
		CreateMemoController *createMemoController=[[CreateMemoController alloc] initWithNibName:@"CreateMemoController" bundle:nil];
		UINavigationController *memoNavigationController=[[UINavigationController alloc] initWithRootViewController:createMemoController];
		//[memoNavigationController.navigationBar setTintColor:[UIColor colorWithRed:20/255.0f green:190/255.0f blue:130/255.0f alpha:1.0f]];
		[createMemoController release];
		
		[self presentModalViewController:memoNavigationController animated:YES];
		[memoNavigationController release];

	}
    
    
}
@end
