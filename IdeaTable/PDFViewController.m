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
@synthesize  toolBar;

-(void)setScrollLock:(BOOL)flag{
	
	if(scrollView){
		[scrollView setScrollEnabled:!flag];
	}

}

-(void)dealloc{
	[toolBar release];

	[super dealloc];
}
			   

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	for(UIView *view in self.view.subviews){
		NSLog(@"%@",view);
		if([view isKindOfClass:[UIImageView class]])[view removeFromSuperview];
	}
}

-(void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}
-(void)viewDidDisappear:(BOOL)animated{
	[super viewDidDisappear:animated];
	[[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

-(id)initWithDocumentManager:(MFDocumentManager *)aDocumentManager{

	self=[super	initWithDocumentManager:aDocumentManager];
	if(self){

		[self setOverlayEnabled:YES];
		[self setUseTiledOverlayView:YES];
	}
	return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	
	
	// 스크롤 뷰를 찾아낸다
	for(UIView *view in self.view.subviews){
		if([view isKindOfClass:[UIScrollView class]])
			scrollView=(UIScrollView *)view;
	}
	
	toolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-44, self.view.bounds.size.width, 44)];
	[self.view addSubview:toolBar];
	
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showMemoView:)];
    [self.view addGestureRecognizer:longPressGesture];
    [longPressGesture release];
	
	UITapGestureRecognizer *tapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapProcess:)];
	[scrollView addGestureRecognizer:tapGestureRecognizer];
	[tapGestureRecognizer release];
	
	[self reloadOverlay];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
	
	scrollView=nil;
	[toolBar release];
	toolBar=nil;
}


-(void)tapProcess:(UIGestureRecognizer *)recognizer{
	if(isToolbarHidden)[self showToolbar];
	else [self hideToolbar];
}

-(void)showToolbar{
	[toolBar setHidden:NO];
	isToolbarHidden=NO;
}

-(void)hideToolbar{
	[toolBar setHidden:YES];
	isToolbarHidden=YES;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// 방장이 페이지를 넘겼을 때
-(void)signalPageMove:(NSUInteger)page{
	if(self.page==page-1)[self moveToNextPage];
	else if(self.page==page-1)[self moveToNextPage];
	else [self setPage:page];
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
