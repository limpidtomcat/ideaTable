//
//  WaitingRoomViewController.m
//  IdeaTable
//
//  Created by Woo Jeff on 11. 9. 27..
//  Copyright 2011년 O.o.Z. All rights reserved.
//

#import "WaitingRoomViewController.h"

#import "PDFViewController.h"


@implementation WaitingRoomViewController

-(id)initWithClientObject:(ClientObject *)_clientObject port:(NSUInteger)_port isMaster:(BOOL)_master{
	self = [super init];
	if(self){
		isMaster=_master;
		port=_port;
		clientObject=[_clientObject retain];
		[clientObject setWaitingRoomDelegate:self];
		
		//		clientObject=[[ClientObject alloc] initWithAddress:<#(NSString *)#> port:<#(NSUInteger)#>];
        // Custom initialization
		userList=[[NSMutableArray alloc] init];
		
	}
	return self;
}
-(void)back:(id)sender{
	if(isMaster){
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Idea Table" message:@"Table will be distroyed." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
		[alert show];
		[alert release];
	}
	else{
		[self.navigationController popViewControllerAnimated:YES];
	}
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
	if(buttonIndex==alertView.firstOtherButtonIndex){
		[self.navigationController popViewControllerAnimated:YES];
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
	[userTable reloadData];
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
	
	[self setTitle:@"Waiting Room"];

	
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
		UIBarButtonItem *startBtn=[[UIBarButtonItem alloc] initWithTitle:@"Start" style:UIBarButtonItemStyleDone target:self action:@selector(startTable:)];
		[self.navigationItem setRightBarButtonItem:startBtn];
		//	[startBtn setEnabled:NO];
		[startBtn release];
	}
	
//	CGRect frame=self.view.bounds;
//	NSLog(@"%d",self.wantsFullScreenLayout);
//	NSLog(@"%@",NSStringFromCGRect(frame));

//	userTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 460-44) style:UITableViewStyleGrouped];
	userTable=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
	userTable.delegate=self;
	userTable.dataSource=self;
	[self.view addSubview:userTable];
	NSLog(@"ppp - %d",port);
	if(port>0){
		UILabel *labe=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
		[labe setText:[NSString stringWithFormat:@"%d",port]];
		[self.view addSubview:labe];
		[labe release];
	}

	
}

- (void)viewDidUnload
{
    [super viewDidUnload];

	[userTable release];
	userTable=nil;
}

-(void)dealloc{
	[userList release];
	[userTable release];
//	[serverObject release];
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
	}
	
	UserInfo *userInfo=[userList objectAtIndex:[indexPath row]];
	
	cell.textLabel.text=userInfo.name;

	cell.detailTextLabel.text=@"color";
//	cell.detailTextLabel.backgroundColor=[UIColor redColor];
	cell.detailTextLabel.textColor=userInfo.penColor;
	
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
	/** Set document name */
    NSString *documentName = @"Manual";
	
    /** Get temporary directory to save thumbnails */
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    /** Set thumbnails path */
    NSString *thumbnailsPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",documentName]];
    
    /** Get document from the App Bundle */
    NSURL *documentUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:documentName ofType:@"pdf"]];
    
    /** Instancing the documentManager */
	MFDocumentManager *documentManager = [[MFDocumentManager alloc]initWithFileUrl:documentUrl];
	
	/** Instancing the readerViewController */
	PDFViewController *pdfViewController = [[PDFViewController alloc]initWithDocumentManager:documentManager];
    
    /** Set resources folder on the manager */
    documentManager.resourceFolder = thumbnailsPath;
	
    /** Set document id for thumbnail generation */
    pdfViewController.documentId = documentName;
    
	/** Present the pdf on screen in a modal view */
    [self presentModalViewController:pdfViewController animated:YES]; 
    
    /** Release the pdf controller*/
    [pdfViewController release];
	NSLog(@"pdf start");
	[clientObject setPdfViewDelegate:pdfViewController];
	[pdfViewController setClientObject:clientObject];
	if(sender!=clientObject){
		NSLog(@"it's master");
		[pdfViewController setIsMaster:YES];
		[clientObject sendPresentationStartMessage];
		
	}

}
@end
