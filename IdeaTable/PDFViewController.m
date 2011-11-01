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
	
	if(scrollView){
		[scrollView setScrollEnabled:!isLocked];
	}

}

-(void)dealloc{
	[toolBar release];
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

-(void)viewWillAppear:(BOOL)animated{
	NSLog(@"view will appear");
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
	
	for(UIView *view in self.view.subviews){
		if([view isKindOfClass:[UIScrollView class]])
			scrollView=(UIScrollView *)view;
	}
	
	
	toolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-44, self.view.bounds.size.width, 44)];
	
	UIBarButtonItem *home,*pen,*lock;
	UIBarButtonItem *flexible,*fix;
	flexible=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	fix=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	[fix setWidth:10];
	
	home=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"53-house.png"] style:UIBarButtonItemStylePlain target:presentationDelegate action:@selector(closeTable)];
	pen=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"187-pencil.png"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleDraw)];
	lock=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"54-lock.png"] style:UIBarButtonItemStylePlain target:self action:@selector(clientDrawLock)];
//	[pen set

	NSArray *items=[NSArray arrayWithObjects:home,flexible,lock,fix,pen, nil];
	
	[home release];
	[pen release];
	[lock release];
	[flexible release];
	[fix release];
	[toolBar setItems:items];
	[self.view addSubview:toolBar];
	
	
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
	
	UITapGestureRecognizer *tapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapProcess:)];
	[scrollView addGestureRecognizer:tapGestureRecognizer];
	[tapGestureRecognizer release];
}

-(void)tapProcess:(UIGestureRecognizer *)recognizer{
	for(UIView *temp in self.view.subviews){
		NSLog(@"view - %@",temp);
	}
	
	if(isToolbarHidden)[self showToolbar];
	else [self hideToolbar];
}


-(void)clientDrawLock{
	isClientDrawLocked=!isClientDrawLocked;
	[presentationDelegate sendServerDrawLock:isClientDrawLocked];
}

-(void)showToolbar{
	[toolBar setHidden:NO];
	isToolbarHidden=NO;
}

-(void)hideToolbar{
	[toolBar setHidden:YES];
	isToolbarHidden=YES;
}

-(void)drawOn{
	if(isLocked)return;
	[drawBtn setSelected:YES];
	[self setScrollLock:YES];
	[presentationDelegate setDrawing:YES];
}
-(void)drawOff{
	[drawBtn setSelected:NO];
	[self setScrollLock:NO];
	[presentationDelegate setDrawing:NO];
}

-(void)setDrawLock:(BOOL)locked{
	if(locked)[self drawOff];
	isLocked=locked;
}

-(void)toggleDraw{
	isDrawing=!isDrawing;
	if(isDrawing)[self drawOn];
	else [self drawOff];
	
}


- (void)viewDidUnload
{
	scrollView=nil;
	[toolBar release];
	toolBar=nil;
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	NSLog(@"touches began!!!!");
}

@end
