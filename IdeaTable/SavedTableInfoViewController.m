//
//  SavedTableViewController.m
//  IdeaTable
//
//  Created by Woo Chang ha on 11. 11. 5..
//  Copyright (c) 2011년 O.o.Z. All rights reserved.
//

#import "SavedTableInfoViewController.h"

@implementation SavedTableInfoViewController

-(id)initWithStyle:(UITableViewStyle)style key:(NSString *)_key tableData:(NSDictionary *)_data{
    self = [super initWithStyle:style];
    if (self) {
		key=[_key retain];
        tableData = [_data retain];
		audioPlayer=nil;
		[self setTitle:[tableData objectForKey:@"title"]];
    }
    return self;
}

-(void)dealloc{
	[audioPlayer stop];
	[audioPlayer release];
	[key release];
	[tableData release];
	if(presentationController)
		[presentationController.pdfViewController cleanUp];
	[presentationController release];
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

	UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
	
	UIButton *newDeleteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	newDeleteButton.frame = CGRectMake(10, 10, 300, 43);
	UIImage *buttonBackground = [UIImage imageNamed:@"redBtn.png"];
	[newDeleteButton setImage:buttonBackground forState:UIControlStateNormal];
//	[newDeleteButton addTarget:self action:@selector(deleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	UILabel *deleteTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 39)];
	deleteTitle.text = @"테이블 기록 삭제";
	deleteTitle.font = [UIFont boldSystemFontOfSize:20];
	deleteTitle.textColor = [UIColor whiteColor];
	deleteTitle.textAlignment = UITextAlignmentCenter;
	deleteTitle.backgroundColor = [UIColor clearColor];
	
	[footerView addSubview:newDeleteButton];
	[footerView addSubview:deleteTitle];
//	self.tableView.tableFooterView = footerView;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(section==0)return 2;
	if(section==1){
		if([[tableData objectForKey:@"recordSave"] boolValue])return 2;
		return 1;
	}
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SavedTableCell";

	NSInteger section=indexPath.section;
	NSInteger row=indexPath.row;

    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
    }
	
	
	if(section==0){
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
		if(row==0){

			NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
			[formatter setTimeZone:[NSTimeZone localTimeZone]];
			[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

			NSString *start;
			start=[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[key intValue]]];
			
			cell.textLabel.text=@"Start";
			cell.detailTextLabel.text=start;
			[formatter release];
		}
		else if(row==1){
			NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
			[formatter setTimeZone:[NSTimeZone localTimeZone]];
			[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
			NSString *over;
			over=[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[tableData objectForKey:@"overTimestamp"] intValue]]];
			
			cell.textLabel.text=@"Over";
			cell.detailTextLabel.text=over;
			
			[formatter release];
		}
	}
	else if(section==1){
		cell.selectionStyle=UITableViewCellSelectionStyleBlue;
		cell.textLabel.text=@"";
		if(row==0)cell.detailTextLabel.text=@"PDF 보기";
		else {
			NSLog(@"checking con");
			if(audioPlayer && [audioPlayer isPlaying])cell.detailTextLabel.text=@"정지";
			cell.detailTextLabel.text=@"녹음 내용 듣기";
		}
	}
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if(indexPath.section==1){
		if(indexPath.row==0){
			
			if(presentationController==nil){
				presentationController=[[SavedPresentationController alloc] initWithTimestamp:key];
			}
			[self.navigationController presentModalViewController:presentationController.pdfViewController animated:YES];
		}else if(indexPath.row==1){
			NSError *error=nil;
			if(!audioPlayer){
				NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
				NSString *savePath=[docPath stringByAppendingPathComponent:@"SavedTable"];
				
				NSString *audioPath=[savePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.caf",key]];
				NSURL *url=[NSURL fileURLWithPath:audioPath];
				
				audioPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
			}
			if(!error){
				if([audioPlayer isPlaying]){
					
					[audioPlayer stop];

					[audioPlayer setCurrentTime:0];
				}
				
				else [audioPlayer play];
				[audioPlayer setDelegate:self];
//				[tableView reloadData];
//				[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
			}else{
				UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Idea Table" message:@"오디오를 재생할 수 없습니다" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
				[alert show];
				[alert release];
			}
		}
	}
}



@end
