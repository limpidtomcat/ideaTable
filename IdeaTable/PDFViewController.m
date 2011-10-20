//
//  PDFViewController.m
//  IdeaTable
//
//  Created by Woo Jeff on 11. 9. 30..
//  Copyright 2011년 O.o.Z. All rights reserved.
//

#import "PDFViewController.h"

@implementation PDFViewController
@synthesize isMaster;
@synthesize  clientObject;
@synthesize waitingViewDelegate;

-(id)initWithClientObject:(ClientObject *)_clientObject{
	self=[super init];
	if(self	){
		clientObject=[_clientObject retain];
		self.documentDelegate=self;
		
	}
	return self;
}
-(void)dealloc{
	[closeBtn release];
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
	[self.view addSubview:closeBtn];
	[self.view bringSubviewToFront:closeBtn];
	
}

-(void)closeTable{
	[waitingViewDelegate endTable:self];
}

- (void)viewDidUnload
{
	[closeBtn release];
	closeBtn=nil;
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

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//	[super scrollViewDidScroll:scrollView];
//	
//	NSLog(@"scrollview dudscroll %@",NSStringFromCGPoint(scrollView.contentOffset));1
////	if(isMaster)[clientObject sendMessagePageScrollWidth:(CGFloat)scrollView.contentOffset.x];
//}
//
@end
