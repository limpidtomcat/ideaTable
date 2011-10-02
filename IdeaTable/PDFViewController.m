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
-(id)initWithClientObject:(ClientObject *)_clientObject{
	self=[super init];
	if(self	){
		clientObject=[_clientObject retain];
	}
	return self;
}
-(void)dealloc{
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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
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

@end
