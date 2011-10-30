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
@synthesize waitingRoomTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		waitingRooms=[[NSMutableArray alloc] init];
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
	[waitingRooms release];
	[waitingRoomTable release];
	[ipField release];
	[portField release];
	[super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setTitle:@"테이블 참여"];
	
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

-(void)viewDidAppear:(BOOL)animated{
	browser=[[NSNetServiceBrowser alloc] init];
	[browser setDelegate:self];
	[browser searchForServicesOfType:@"_idea._tcp." inDomain:@"local."];
	[waitingRooms removeAllObjects];
	[waitingRoomTable reloadData];

}

-(void)viewDidDisappear:(BOOL)animated{
	[browser stop];
	[browser release];
	
}


- (void)viewDidUnload
{
    [super viewDidUnload];
	
	self.ipField=nil;
	self.portField=nil;
	self.waitingRoomTable=nil;
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

#pragma mark - NSNetServiceBrowserDelegate methods

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
	[netService setDelegate:self];
	[netService resolveWithTimeout:5];
	
	[waitingRooms addObject:netService];
	
	if(!moreServicesComing)	[waitingRoomTable reloadData];
	
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didRemoveService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing{
	[waitingRooms removeObject:netService];
	if(!moreServicesComing)	[waitingRoomTable reloadData];
	
}


- (void)netServiceDidResolveAddress:(NSNetService *)sender
{
	NSLog(@"didresolve %@",sender.hostName);
	NSNetService *netService=sender;
	
	[netService stop];
	
	[waitingRoomTable reloadData];
}
- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict{
	NSLog(@"resolve fail %@",errorDict);
}

- (void)netServiceWillResolve:(NSNetService *)sender{
	NSLog(@"will resolve");
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [waitingRooms count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WaitingRoomTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
	NSNetService *netService=[waitingRooms objectAtIndex:indexPath.row];
	if([[netService addresses] count]==0)[cell.textLabel setTextColor:[UIColor grayColor]];
	else [cell.textLabel setTextColor:[UIColor blackColor]];
	cell.textLabel.text=netService.name;
	
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	NSNetService *netService=[waitingRooms objectAtIndex:indexPath.row];

	NSString *ip;
	NSLog(@"%d",[netService.addresses count]);

	for (NSData *data in netService.addresses) {
		
		struct sockaddr_in *address=(struct sockaddr_in *)[data bytes];
		if(address->sin_family != AF_INET)continue;	//skip ipv6

		ip=[NSString stringWithCString:inet_ntoa(address->sin_addr) encoding:NSUTF8StringEncoding];
		break;
		NSLog(@"%@",ip);
	}
//	return;

	NSLog(@"join");
	TableInfo *tableInfo=[[TableInfo alloc] init];
	
	ClientObject *clientObject=[[ClientObject alloc] initWithAddress:ip port:netService.port tableInfo:tableInfo];
	WaitingRoomViewController *viewController=[[WaitingRoomViewController alloc] initWithClientObject:clientObject port:0 isMaster:NO];
	[viewController setTableInfo:tableInfo];
	[self.navigationController pushViewController:viewController animated:YES];
	[tableInfo release];
	[viewController release];
	[clientObject release];

}


@end
