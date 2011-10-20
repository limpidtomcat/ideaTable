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
	
//	NSNetServiceBrowser *browser=[[NSNetServiceBrowser alloc] init];
//	[browser setDelegate:self];
//	[browser searchForServicesOfType:@"_idea._tcp." inDomain:@"local."];
////	[browser searchForServicesOfType:<#(NSString *)#> inDomain:<#(NSString *)#>
//
//	NSLog(@"let's search");
////	[browser	 release];

}

- (void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)netServiceBrowser
{
	NSLog(@"start search");
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didNotSearch:(NSDictionary *)errorInfo
{

	NSLog(@"error search %@",errorInfo);
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didFindService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing
{
	NSLog(@"found %@",netService);
	NSLog(@"more ? %d",moreServicesComing);
	[netService retain];
	[netService setDelegate:self];
	[netService resolveWithTimeout:1];

}

- (void)netServiceDidResolveAddress:(NSNetService *)sender
{
	NSLog(@"didresolve %@",sender.hostName);
	NSNetService *netService=sender;
	NSLog(@"%@",netService.addresses);
	for (NSData *data in netService.addresses) {
		
		
//		if (socketAddress && socketAddress->sa_family == AF_INET) {
		struct sockaddr_in *address=(struct sockaddr_in *)[data bytes];
		if(address->sin_family != AF_INET)continue;
		NSLog(@"data/");
		NSString *ip=[NSString stringWithCString:inet_ntoa(address->sin_addr) encoding:NSUTF8StringEncoding];
		NSLog(@"%@",ip);
	}
	//	netService.addresses 
	//	netService.addresses
	//	netService.port
	[netService stop];
	NSString *addr;
//	[self autoJoinToAddr:addr port:netService.port];
}
- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict{
	NSLog(@"resolve fail %@",errorDict);
}

- (void)netServiceWillResolve:(NSNetService *)sender{
	NSLog(@"will resolve");
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
	TableInfo *tableInfo=[[TableInfo alloc] init];
	
	ClientObject *clientObject=[[ClientObject alloc] initWithAddress:[ipField text] port:[[portField text] intValue] tableInfo:tableInfo];
	WaitingRoomViewController *viewController=[[WaitingRoomViewController alloc] initWithClientObject:clientObject port:0 isMaster:NO];
	[viewController setTableInfo:tableInfo];
	[self.navigationController pushViewController:viewController animated:YES];
	[tableInfo release];
	[viewController release];
	[clientObject release];

}

-(void)autoJoinToAddr:(NSString *)addr port:(NSUInteger)port{
	ClientObject *clientObject=[[ClientObject alloc] initWithAddress:addr port:port];
	WaitingRoomViewController *viewController=[[WaitingRoomViewController alloc] initWithClientObject:clientObject port:0 isMaster:NO];
	[self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
	[clientObject release];
	
}

-(void)joinComplete:(ClientObject *)clientObject{
	WaitingRoomViewController *viewController=[[WaitingRoomViewController alloc] initWithClientObject:clientObject port:0 isMaster:NO];
	
}

@end
