//
//  ClearTableViewController.m
//  IdeaTable
//
//  Created by Woo Jeff on 11. 10. 9..
//  Copyright (c) 2011년 O.o.Z. All rights reserved.
//

#import "ClearTableViewController.h"


@implementation ClearTableViewController
@synthesize tableInfo;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
		[self.navigationItem setHidesBackButton:YES];
		UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
		[self.navigationItem setRightBarButtonItem:doneBtn];
		[self setTitle:@"테이블 정리"];
		[doneBtn release];
        // Custom initialization
    }
    return self;
}

-(void)done{
	[self.navigationController dismissModalViewControllerAnimated:YES];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	if(indexPath.row==0)cell.textLabel.text=@"PDF 저장";
	else if(indexPath.row==1)cell.textLabel.text=@"메모 저장";
	else if(indexPath.row==2)cell.textLabel.text=@"녹음 내용 저장";
    
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

	if(indexPath.row==0){
		
		NSLog(@"주소 - %@",[tableInfo.pptFile absoluteString]);
		
		NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

		NSString *newFilePath=[docPath stringByAppendingPathComponent:tableInfo.title];
//		[docPath stringByAppendingPathExtension:<#(NSString *)#>
		
		NSLog(@"new file path - %@",newFilePath);
		
		NSFileManager *fm=[NSFileManager defaultManager];
		if([fm fileExistsAtPath:[newFilePath stringByAppendingPathExtension:@"pdf"]]){
			NSUInteger index=1;
			while([fm fileExistsAtPath:[newFilePath stringByAppendingFormat:@"_%d.pdf",index]]){
				index++;
			}
			newFilePath=[newFilePath stringByAppendingFormat:@"_%d",index];
		}
		newFilePath=[newFilePath stringByAppendingPathExtension:@"pdf"];
		NSLog(@"new file path - %@",newFilePath);
		NSError *fileMoveError=nil;
		
		[[NSFileManager defaultManager] moveItemAtURL:tableInfo.pptFile toURL:[NSURL fileURLWithPath:newFilePath] error:&fileMoveError];
//		[[NSFileManager defaultManager] moveItemAtPath:[tableInfo.pptFile absoluteString] toPath:newFilePath error:&fileMoveError];
		if(fileMoveError){
			NSLog(@"%@",fileMoveError);
			UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Idea Table" message:@"파일 복사 실패" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}else{
			UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Idea Table" message:@"파일이 저장되었습니다" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
//		[fileMoveError release];
		
	}
}

@end
