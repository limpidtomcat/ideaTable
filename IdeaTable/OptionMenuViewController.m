//
//  OptionMenuViewController.m
//  IdeaTable
//
//  Created by DongNyeok Jeong on 9/30/11.
//  Copyright 2011 O.o.Z. All rights reserved.
//

#import "OptionMenuViewController.h"
#import "SavedTableListViewController.h"


@implementation OptionMenuViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
		nameTextField=[[UITextField alloc] initWithFrame:CGRectMake(100, 11, 210, 22)];
		[nameTextField setHidden:YES];
		[nameTextField setReturnKeyType:UIReturnKeyDone];
//		[nameTextField setUserInteractionEnabled:NO];
//		[nameTextField setBackgroundColor:[UIColor redColor]];
		[nameTextField setDelegate:self];
        
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
    
    [self setTitle:@"옵션"];
    
    UIButton *customBtn=[UIButton buttonWithType:101];
	[customBtn setTitle:@"Home" forState:UIControlStateNormal];
	[customBtn addTarget:self action:@selector(closeOptMenu) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBtn=[[UIBarButtonItem alloc] initWithCustomView:customBtn];
	[self.navigationItem setLeftBarButtonItem:backBtn];
	[backBtn release];

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

-(void)dealloc
{
	[nameTextField release];
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
//        case 2:
//            return 2;
//            break;
        case 2:
            return 1;
            break;
        case 3:
            return 1;
        default:
            break;
    }
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"OptionMenuCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
	
	NSInteger section=indexPath.section;
	NSInteger row=indexPath.row;
	if(section==0){
        [cell addSubview:nameTextField];
		cell.textLabel.text=@"내 이름";

		NSString *myName=[[NSUserDefaults standardUserDefaults] objectForKey:@"myName"];
		if(myName==nil)myName=[[UIDevice currentDevice] name];
		
        cell.detailTextLabel.text = myName;
		cell.accessoryType=UITableViewCellAccessoryNone;
	}
	else if (section==1){
		if(row==0){
			
			cell.textLabel.text=@"저장된 회의";
			
			cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
		}
		else if(row==1){
			cell.textLabel.text=@"데이터 초기화";
		}
	}
//	else if(section==2){
//		if(row==0){
//			cell.textLabel.text=@"메모 초기화";
//			//확인 팝업 구현
//			cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//		}
//		else if(row==1){
//			cell.textLabel.text=@"슬라이드파일 초기화";
//			//확인 팝업 구현
//			cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//		}			
//	}
	else if(section==2){
		cell.textLabel.text=@"버전정보";
        cell.detailTextLabel.text = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
//		cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
	}
	else if(section	==3){
		cell.textLabel.text=@"dropbox 연결";
		cell.accessoryType=UITableViewCellAccessoryNone;
    }
    
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
	if(indexPath.section==0&&indexPath.row==0){
		[[tableView cellForRowAtIndexPath:indexPath].detailTextLabel setHidden:YES];
		[nameTextField setText:[[tableView cellForRowAtIndexPath:indexPath].detailTextLabel text]];
		[nameTextField setHidden:NO];
		[nameTextField becomeFirstResponder];
		
	}
	else if([nameTextField isFirstResponder]){
		[self saveMyName:nameTextField.text];
		[nameTextField resignFirstResponder];
		[nameTextField setHidden:YES];
		[[((UITableViewCell *)[nameTextField superview]) detailTextLabel] setHidden:NO];
	}
	
	// 저장된 테이블 보기
	if(indexPath.section==1){
		if(indexPath.row==0){
			//		SavedTableListTableView 
			SavedTableListViewController *savedTableViewController=[[SavedTableListViewController alloc] initWithStyle:UITableViewStylePlain];
			[self.navigationController pushViewController:savedTableViewController animated:YES];
			[savedTableViewController release];
			
		}
		else if(indexPath.row==1){
			UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Idea Table" message:@"저장된 모든 데이터를 초기화하겠습니까?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
			[alert show];
			[alert release];
		}
	}
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
	if(buttonIndex==alertView.firstOtherButtonIndex){
		NSString *documentPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSString *savePath=[documentPath stringByAppendingPathComponent:@"SavedTable"];
		
		NSFileManager* fm = [[[NSFileManager alloc] init] autorelease];
		NSDirectoryEnumerator* en;

		NSError* err = nil;
		BOOL res;

		en = [fm enumeratorAtPath:savePath];
		
		NSString* file;
		while (file = [en nextObject]) {
			res = [fm removeItemAtPath:[savePath stringByAppendingPathComponent:file] error:&err];
			if (!res && err) {
				NSLog(@"oops: %@", err);
			}
		}	
		
		en = [fm enumeratorAtPath:documentPath];
		
		while (file = [en nextObject]) {
			res = [fm removeItemAtPath:[documentPath stringByAppendingPathComponent:file] error:&err];
			if (!res && err) {
				NSLog(@"oops: %@", err);
			}
		}
		
		[[NSFileManager defaultManager] createDirectoryAtPath:savePath withIntermediateDirectories:NO attributes:nil error:nil];


	}
}

-(void)closeOptMenu{
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

-(void)saveMyName:(NSString *)name{
	if([name isEqualToString:@""])return;
	[[NSUserDefaults standardUserDefaults] setObject:name forKey:@"myName"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[self.tableView reloadData];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
	[[((UITableViewCell *)[textField superview]) detailTextLabel] setHidden:YES];
	
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
	[self saveMyName:textField.text];
	[textField setHidden:YES];
	[[((UITableViewCell *)[textField superview]) detailTextLabel] setHidden:NO];
	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	
	
	
	[textField resignFirstResponder];
	return YES;
	
}


@end
