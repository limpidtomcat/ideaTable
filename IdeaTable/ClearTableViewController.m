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
@synthesize audioRecordController;
@synthesize drawingDataArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
		[self.navigationItem setHidesBackButton:YES];
		UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
		[self.navigationItem setRightBarButtonItem:doneBtn];
		[self setTitle:@"테이블 정리"];
		[doneBtn release];
		
		tableSave=NO;
		drawSave=NO;
		memoSave=NO;
		recordSave=NO;

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(tableSave==NO)return 1;
	else 
		return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	NSInteger row=indexPath.row;
	if(row==0){
		cell.textLabel.text=@"테이블 저장";
		if(tableSave)cell.accessoryType=UITableViewCellAccessoryCheckmark;
		else cell.accessoryType=UITableViewCellAccessoryNone;
	}
	else if(row==1){
		cell.textLabel.text=@"메모 저장";
		if(memoSave)cell.accessoryType=UITableViewCellAccessoryCheckmark;
		else cell.accessoryType=UITableViewCellAccessoryNone;
	}
	else if(row==2){
		cell.textLabel.text=@"그리기 저장";
		if(drawSave)cell.accessoryType=UITableViewCellAccessoryCheckmark;
		else cell.accessoryType=UITableViewCellAccessoryNone;
	}
	else if(row==3){
		cell.textLabel.text=@"녹음 내용 저장";
		if(recordSave)cell.accessoryType=UITableViewCellAccessoryCheckmark;
		else cell.accessoryType=UITableViewCellAccessoryNone;
	}

	
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	if(indexPath.row==0){
		tableSave=!tableSave;

		[tableView beginUpdates];
		if(tableSave){
			[[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
			NSArray *arr=[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:0],[NSIndexPath indexPathForRow:2 inSection:0],[NSIndexPath indexPathForRow:3 inSection:0], nil];
			
			[tableView insertRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationTop];
		}else{
			[[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
			NSArray *arr=[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:0],[NSIndexPath indexPathForRow:2 inSection:0],[NSIndexPath indexPathForRow:3 inSection:0], nil];
			[tableView deleteRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationTop];
			
		}
		[tableView endUpdates];

	}
	else if(indexPath.row==1){
		memoSave=!memoSave;
		if(memoSave)[[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
		else [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
	}
	else if(indexPath.row==2){
		drawSave=!drawSave;
		if(drawSave)[[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
		else [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
	}
	else if(indexPath.row==3){
		recordSave=!recordSave;
		if(recordSave)[[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
		else [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
	}
}

-(void)saveDrawFile{
	NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *savePath=[docPath stringByAppendingPathComponent:@"SavedTable"];
	NSString *newFilePath=[savePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pen",tableInfo.startTimestamp]];
	
	[NSKeyedArchiver archiveRootObject:drawingDataArray toFile:newFilePath];
}

-(void)saveRecordFile{
	BOOL saveComplete=[audioRecordController saveAudioFile];
//	UIAlertView *alert=nil;
//	if(saveComplete)
//		alert=[[UIAlertView alloc] initWithTitle:@"Idea Table" message:@"파일이 저장되었습니다" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
//	else
//		alert=[[UIAlertView alloc] initWithTitle:@"Idea Table" message:@"파일 저장 실패" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
//	[alert show];
//	[alert release];
	return saveComplete;
}

-(BOOL)savePDFFile{
	
	NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//	NSString *newFilePath=[docPath stringByAppendingPathComponent:tableInfo.title];
	
//	NSFileManager *fm=[NSFileManager defaultManager];
//	if([fm fileExistsAtPath:[newFilePath stringByAppendingPathExtension:@"pdf"]]){
//		NSUInteger index=1;
//		while([fm fileExistsAtPath:[newFilePath stringByAppendingFormat:@"_%d.pdf",index]]){
//			index++;
//		}
//		newFilePath=[newFilePath stringByAppendingFormat:@"_%d",index];
//	}
//	newFilePath=[newFilePath stringByAppendingPathExtension:@"pdf"];
	NSString *savePath=[docPath stringByAppendingPathComponent:@"SavedTable"];
	NSString *newFilePath=[savePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf",tableInfo.startTimestamp]];
	
	NSLog(@"new file path - %@",newFilePath);
	NSError *fileMoveError=nil;
	
	[[NSFileManager defaultManager] moveItemAtURL:tableInfo.pptFile toURL:[NSURL fileURLWithPath:newFilePath] error:&fileMoveError];
	
	return fileMoveError==nil;

//	UIAlertView *alert=nil;
//	if(fileMoveError)
//		alert=[[UIAlertView alloc] initWithTitle:@"Idea Table" message:@"PDF 파일 저장 실패" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
//	else
//		alert=[[UIAlertView alloc] initWithTitle:@"Idea Table" message:@"파일이 저장되었습니다" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
//
//	[alert show];
//	[alert release];

}

-(void)done{
	if(tableSave){
		NSString *savePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"SavedTable"];
		NSString *dataFile=[savePath stringByAppendingPathComponent:@"data.dat"];
		NSMutableDictionary *fileData=[
									   NSMutableDictionary dictionaryWithContentsOfFile:dataFile];
		if (fileData==nil)fileData=[NSMutableDictionary dictionary];
		
		NSDictionary *tableData=[NSDictionary dictionaryWithObjectsAndKeys:
								 tableInfo.title,@"title",
								 tableInfo.overTimestamp,@"overTimestamp",
								 [NSNumber numberWithBool:memoSave],@"memoSave",
								 [NSNumber numberWithBool:drawSave],@"drawSave",
								 [NSNumber numberWithBool:recordSave],@"recordSave",
								 nil];
		
		[fileData setObject:tableData forKey:tableInfo.startTimestamp];
		[fileData writeToFile:dataFile atomically:YES];

		[self savePDFFile];
		if(memoSave){
//			[self saveMemoFile];
		}
		if(drawSave){
			[self saveDrawFile];
		}
		if(recordSave){
			[self saveRecordFile];
		}
		UIAlertView *alert=[[UIAlertView alloc ] initWithTitle:@"Idea Table" message:@"테이블이 저장되었습니다" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
		[alert show];
		[alert release];

	}else{
		[self.navigationController dismissModalViewControllerAnimated:YES];
	}
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
	[self.navigationController dismissModalViewControllerAnimated:YES];
}



-(void)dealloc{
	[audioRecordController release];
	[tableInfo release];
	[drawingDataArray release];
	[super dealloc];
}
@end
