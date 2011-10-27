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

@synthesize  presentationDelegate;
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

-(void)dealloc{
	[closeBtn release];
	[drawBtn release];

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


-(id)initWithDocumentManager:(MFDocumentManager *)aDocumentManager presentationDelegate:(id)_presentationDelegate{
	self=[super	initWithDocumentManager:aDocumentManager];
	if(self){
		presentationDelegate=_presentationDelegate;
	}
	return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	closeBtn=[[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	[closeBtn setTitle:@"Close" forState:UIControlStateNormal];
	[closeBtn setFrame:CGRectMake(0, 0, 50, 50)];
	[closeBtn addTarget:presentationDelegate action:@selector(closeTable) forControlEvents:UIControlEventTouchUpInside];
	NSLog(@"dsjkal %@",presentationDelegate);
	
	drawBtn=[[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	[drawBtn setTitle:@"Draw" forState:UIControlStateNormal];
	[drawBtn setTitle:@"Over" forState:UIControlStateSelected];
	[drawBtn setFrame:CGRectMake(320-50, 0, 50, 50)];
	[drawBtn addTarget:self action:@selector(toggleDraw) forControlEvents:UIControlEventTouchUpInside];


	[self.view addSubview:closeBtn];
	[self.view bringSubviewToFront:closeBtn];
	[self.view addSubview:drawBtn];
	[self.view bringSubviewToFront:drawBtn];
	[self setOverlayEnabled:YES];
	[self addOverlayViewDataSource:presentationDelegate];
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
	

	[presentationDelegate setDrawing:isDrawing];
	
}


- (void)viewDidUnload
{
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


-(void)signalPageMove:(NSUInteger )page{
	if(self.page==page-1)[self moveToNextPage];
	else if(self.page==page-1)[self moveToNextPage];
	else [self setPage:page];
	
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
		[createMemoController setDelegate:self];
		UINavigationController *memoNavigationController=[[UINavigationController alloc] initWithRootViewController:createMemoController];
		//[memoNavigationController.navigationBar setTintColor:[UIColor colorWithRed:20/255.0f green:190/255.0f blue:130/255.0f alpha:1.0f]];
		[createMemoController release];
		
		[self presentModalViewController:memoNavigationController animated:YES];
		[memoNavigationController release];

	}
    
    
}

- (void)closeMemoView:(NSInteger) temp{
	NSLog(@"received - %d",temp);
	NSLog(@"current page = %d",[self page]);
	
}

@end
