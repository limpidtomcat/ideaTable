//
//  CreateTableViewController.m
//  IdeaTable
//
//  Created by Woo Jeff on 11. 9. 27..
//  Copyright 2011년 O.o.Z. All rights reserved.
//

#import "CreateTableViewController.h"
#import "WaitingRoomViewController.h"
#import "ServerObject.h"

@implementation CreateTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
		self.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
		title=@"NO TITLE";
		member=3;
		time=10;
		record=YES;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

	[self setTitle:@"생성"];
	
	UIButton *customBtn=[UIButton buttonWithType:101];
	[customBtn setTitle:@"Home" forState:UIControlStateNormal];
	[customBtn addTarget:self action:@selector(closeCreateTable) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *backBtn=[[UIBarButtonItem alloc] initWithCustomView:customBtn];
	[self.navigationItem setLeftBarButtonItem:backBtn];
//	[self.navigationItem setHidesBackButton:NO];
//	self.navigationController.navigationBar.backItem.title=@"Home";
	[backBtn release];

	UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(onDoneBtn)];
	[self.navigationItem setRightBarButtonItem:doneBtn];
	[doneBtn release];
	
	recordSwitch=[[UISwitch alloc] initWithFrame:CGRectMake(202,8, 0, 0)];
	[recordSwitch setOn:record];
	
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	[recordSwitch release];
	recordSwitch=nil;
}
-(void)dealloc{
	[recordSwitch release];
	[super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
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
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CreateTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
	if([indexPath row]==0){
		cell.textLabel.text=@"제목";
		cell.accessoryType=UITableViewCellAccessoryNone;
	}
	else if([indexPath row]==1){
		cell.textLabel.text=@"인원";
		cell.detailTextLabel.text=[NSString stringWithFormat:@"%d",member];
		cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
	}
	else if([indexPath row]==2){
		cell.textLabel.text=@"시간";
		cell.detailTextLabel.text=[NSString stringWithFormat:@"%d min",time];
		cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
	}
	else if([indexPath row]==3){
		cell.textLabel.text=@"PPT File";
		cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
	}
	else if([indexPath row]==4){
		cell.textLabel.text=@"녹음";
		cell.accessoryType=UITableViewCellAccessoryNone;
//		cell.detailTextLabel
		
		[cell addSubview:recordSwitch];
	}
    
    // Configure the cell...
    
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

-(void)closeCreateTable{
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

-(void)onDoneBtn{
	ServerObject *serverObject=[[ServerObject alloc] init];
	NSLog(@"주소 : %@",[ServerObject localIPAddress]);
	NSLog(@"포트 : %d",[serverObject port]);
	
	ClientObject *clientObject=[[ClientObject alloc] initWithAddress:@"127.0.0.1" port:[serverObject port]];
	
	
	WaitingRoomViewController *viewController=[[WaitingRoomViewController alloc] initWithClientObject:clientObject port:[serverObject port] isMaster:YES];

	[clientObject release];
	
	[self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}

@end
