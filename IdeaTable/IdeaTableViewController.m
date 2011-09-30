//
//  IdeaTableViewController.m
//  IdeaTable
//
//  Created by Woo Jeff on 11. 9. 27..
//  Copyright 2011년 O.o.Z. All rights reserved.
//

#import "IdeaTableViewController.h"

#import "CreateTableViewController.h"
#import "JoinViewController.h"

@implementation IdeaTableViewController

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

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

-(IBAction)createTable:(id)sender{
	CreateTableViewController *viewController=[[CreateTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	UINavigationController *navigationController=[[UINavigationController alloc] initWithRootViewController:viewController];
	[viewController release];
	
	[self presentModalViewController:navigationController animated:YES];
	[navigationController release];
}

-(IBAction)joinTable:(id)sender{
	JoinViewController *viewController=[[JoinViewController alloc] initWithNibName:@"JoinViewController" bundle:nil];
	UINavigationController *navigationController=[[UINavigationController alloc] initWithRootViewController:viewController];
	[viewController release];
	
	[self presentModalViewController:navigationController animated:YES];
	[navigationController release];
}

@end
