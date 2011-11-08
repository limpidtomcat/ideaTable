//
//  SavedTableViewController.m
//  IdeaTable
//
//  Created by Woo Chang ha on 11. 11. 4..
//  Copyright (c) 2011년 O.o.Z. All rights reserved.
//

#import "SavedTableListViewController.h"
#import "SavedTableInfoViewController.h"

@implementation SavedTableListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
		NSString *documentPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSString *savePath=[documentPath stringByAppendingPathComponent:@"SavedTable"];
		NSString *dataFile=[savePath stringByAppendingPathComponent:@"data.dat"];
		NSLog(@"file ok ? %d",	[[NSFileManager defaultManager] fileExistsAtPath:dataFile]);
		savedTableDictionary=[[NSDictionary alloc] initWithContentsOfFile:dataFile];
		NSLog(@"saved file - %@",savedTableDictionary);
		
		savedTableKeys=[[savedTableDictionary allKeys] sortedArrayUsingComparator:^(id s1, id s2){
			if ([s1 intValue] > [s2 intValue]) {
				return (NSComparisonResult)NSOrderedDescending;
			}
			
			if ([s1 intValue] < [s2 intValue]) {
				return (NSComparisonResult)NSOrderedAscending;
			}
			return (NSComparisonResult)NSOrderedSame;					
		}];
		[savedTableKeys retain];
		
    }
    return self;
}

-(void)dealloc{
	[savedTableKeys release];
	[savedTableDictionary release];
	[super dealloc];
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
	
	[self setTitle:@"저장된 테이블"];

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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [savedTableKeys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
	
	id cellKey=[savedTableKeys objectAtIndex:indexPath.row];
	NSDictionary *data=[savedTableDictionary objectForKey:cellKey];
	[cell.textLabel setText:[data objectForKey:@"title"]];
	
	NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	[formatter setTimeZone:[NSTimeZone localTimeZone]];
	NSDate *startDate=[NSDate dateWithTimeIntervalSince1970:[cellKey intValue]];
    [cell.detailTextLabel setText:[formatter stringFromDate:startDate]];
	[formatter release];
    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

	NSString *key=[savedTableKeys objectAtIndex:indexPath.row];
	NSDictionary *data=[savedTableDictionary objectForKey:key];
	
	SavedTableInfoViewController *viewController=[[SavedTableInfoViewController alloc] initWithStyle:UITableViewStyleGrouped key:key tableData:data];

	
	[self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}

@end
