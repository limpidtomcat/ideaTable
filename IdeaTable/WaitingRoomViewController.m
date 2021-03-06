//
//  WaitingRoomViewController.m
//  IdeaTable
//
//  Created by Woo Jeff on 11. 9. 27..
//  Copyright 2011년 O.o.Z. All rights reserved.
//

#import "WaitingRoomViewController.h"

#import "PDFViewController.h"

#import "ClearTableViewController.h"
#import "PresentationController.h"

@implementation WaitingRoomViewController
@synthesize  serverObject;

@synthesize  tableInfo;

-(id)initWithClientObject:(ClientObject *)_clientObject isMaster:(BOOL)_master{
	self = [super init];
	if(self){
		isMaster=_master;
		clientObject=[_clientObject retain];
		[clientObject setWaitingRoomDelegate:self];
		
		userList=[[NSMutableArray alloc] init];
		
	}
	return self;
}

-(void)goBack{
	// client release
	[clientObject closeSocket];
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)back:(id)sender{
	if(isMaster){
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Idea Table" message:@"Table will be distroyed." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
		[alert show];
		[alert release];
	}
	else{
		[self goBack];
	}
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
	if(buttonIndex==alertView.firstOtherButtonIndex){
		//서버 종료
		[serverObject closeServer];
		[self goBack];
	}
}

-(UserInfo *)getUserById:(NSUInteger)clientId{
	for (UserInfo *user in userList) {
		if(user.clientId==clientId)return user;
	}
	return nil;
}

-(void)newUserCome:(UserInfo *)userInfo{
	[userList addObject:userInfo];

	[startBtn setEnabled:NO];
	[userTable reloadData];
}

-(void)userPPTDownloadComplete:(NSUInteger)clientID{
	NSLog(@"%d 번 사용자 다운 완료",clientID);
	UserInfo *user=[self getUserById:clientID];
	NSLog(@"검색 %@",user);
	[user setPptFileDownloaded:YES];
	[userTable reloadData];

	if(isMaster){
		BOOL ready=YES;
		for(UserInfo *i in userList){
			if(![i pptFileDownloaded])ready=NO;
		}
		
		if(ready)[startBtn setEnabled:YES];
		else [startBtn setEnabled:NO];
		
	}
}

-(void)serverKilled{
	UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Idea Table" message:@"Server has shut down" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
	[alert show];
	[alert release];
	[self goBack];
	
}

-(void)userOut:(NSUInteger)clientId{
	UserInfo *outUser=[self getUserById:clientId];
	[userList removeObject:outUser];
	[userTable reloadData];
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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	
//	[self setTitle:@"Waiting Room"];

	
//	NSLog(@"뷰 목록 - %@",self.navigationController);
//	NSLog(@"이전 뷰 : %@",[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2]);
	//		[
	UIButton *backBtn=[UIButton buttonWithType:101];
	[backBtn setTitle:[[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2] title] forState:UIControlStateNormal];
	[backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *backBtnItem=[[UIBarButtonItem alloc] initWithCustomView:backBtn];
	[self.navigationItem setLeftBarButtonItem:backBtnItem];
	[backBtnItem release];
	
	//		self.
	
	
	if(isMaster){
		startBtn=[[UIBarButtonItem alloc] initWithTitle:@"Start" style:UIBarButtonItemStyleDone target:self action:@selector(startTable:)];
		[self.navigationItem setRightBarButtonItem:startBtn];
		[startBtn setEnabled:NO];

	}
	
//	CGRect frame=self.view.bounds;
//	NSLog(@"%d",self.wantsFullScreenLayout);
//	NSLog(@"%@",NSStringFromCGRect(frame));

//	userTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 460-44) style:UITableViewStyleGrouped];
	userTable=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
	userTable.delegate=self;
	userTable.dataSource=self;
	[self.view addSubview:userTable];

	
}

- (void)viewDidUnload
{
    [super viewDidUnload];

	[userTable release];
	userTable=nil;
}

-(void)dealloc{
	[startBtn release];
	[userList release];
	[userTable release];
	[serverObject release];
	[clientObject release];
	[super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [userList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WaitingUserTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
		UIActivityIndicatorView *indicator=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	
		[indicator setTag:1];
		[indicator setCenter:CGPointMake(15, 22)];
//		[indicator setBounds:CGRectMake(0, 0, 40, 40)];
		[indicator startAnimating];
		[cell.contentView addSubview:indicator];
		[indicator release];
		
		cell.indentationWidth=20;
		cell.indentationLevel=1;
	}
	
	UserInfo *userInfo=[userList objectAtIndex:[indexPath row]];
	
	cell.textLabel.text=userInfo.name;

	cell.detailTextLabel.text=@"color";
//	cell.detailTextLabel.backgroundColor=[UIColor redColor];
	cell.detailTextLabel.textColor=userInfo.penColor;
	
//	NSLog(@"%@",[cell.contentView viewWithTag:1]);
	NSLog(@"%@ 받음 ? %d",userInfo,userInfo.pptFileDownloaded);
	UIActivityIndicatorView *indicator=(UIActivityIndicatorView *)[cell.contentView viewWithTag:1];
	if(userInfo.pptFileDownloaded){

		[indicator stopAnimating];
		 
		[indicator setHidden:YES];
	}
	else {
		[indicator startAnimating];
		[indicator setHidden:NO];
	}
		
	//	[userList objectAtIndex:[indexPath row]];
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

-(void)startTable:(id)sender{
	PresentationController *presentationController=[[PresentationController alloc] initWithPdfUrl:tableInfo.pptFile isMaster:isMaster tableInfo:tableInfo];
	
	
	
	[presentationController setUserList:userList];
	
	/** Present the pdf on screen in a modal view */
    [self presentModalViewController:presentationController.pdfViewController animated:YES]; 
    

	[clientObject setPresentationDelegate:presentationController];
	[presentationController setClientObject:clientObject];
	[presentationController setWaitingViewDelegate:self];

	if(isMaster)
		[clientObject sendPresentationStartMessage];
	
//	[clientObject setPdfViewDelegate:pdfViewController];
//	[pdfViewController setClientObject:clientObject];
//	if(sender!=clientObject){
//		NSLog(@"it's master");
//		[pdfViewController setIsMaster:YES];
//		[clientObject sendPresentationStartMessage];
//		
//	}

	/** Release the pdf controller*/

	[presentationController release];

}

-(void)endTable:(PDFViewController *)pdfViewController{
//	NSLog(@"closing table");
//	ClearTableViewController *viewController=[[ClearTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
//	[viewController setTableInfo:tableInfo];
//	[self.navigationController pushViewController:viewController animated:NO];
//
//	[viewController release];
//	[];
}

-(void)reloadTitle{
	self.title=tableInfo.title;
}

@end
