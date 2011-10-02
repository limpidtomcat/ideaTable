//
//  JoinViewController.m
//  IdeaTable
//
//  Created by Woo Jeff on 11. 9. 30..
//  Copyright 2011년 O.o.Z. All rights reserved.
//

#import "JoinViewController.h"
#import "ClientObject.h"
#import "WaitingRoomViewController.h"

@implementation JoinViewController
@synthesize ipField;
@synthesize  portField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)dealloc{
	[ipField release];
	[portField release];
	[super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setTitle:@"Join"];
	
	UIButton *customBtn=[UIButton buttonWithType:101];
	[customBtn setTitle:@"Home" forState:UIControlStateNormal];
	[customBtn addTarget:self action:@selector(closeJoinView) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *backBtn=[[UIBarButtonItem alloc] initWithCustomView:customBtn];
	[self.navigationItem setLeftBarButtonItem:backBtn];
	[backBtn release];
	
	UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc] initWithTitle:@"Join" style:UIBarButtonItemStyleDone target:self action:@selector(onJoinBtn)];
	[self.navigationItem setRightBarButtonItem:doneBtn];
	[doneBtn release];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
	
	self.ipField=nil;
	self.portField=nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)closeJoinView{
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

-(void)onJoinBtn{
	NSLog(@"join");
	ClientObject *clientObject=[[ClientObject alloc] initWithAddress:[ipField text] port:[[portField text] intValue]];
	WaitingRoomViewController *viewController=[[WaitingRoomViewController alloc] initWithClientObject:clientObject port:0 isMaster:NO];
	[self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
	[clientObject release];

}

@end
