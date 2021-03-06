//
//  CreateTableViewController.m
//  IdeaTable
//
//  Created by Woo Jeff on 11. 9. 27..
//  Copyright 2011년 O.o.Z. All rights reserved.
//

#import "CreateTableViewController.h"
#import "WaitingRoomViewController.h"
#import "PptFileSelectController.h"
#import "ServerObject.h"

@implementation CreateTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
		self.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
        tableTitle=[[NSString alloc] initWithString:@"NO TITLE"];
		member=2;
		time=10;

		members = [[NSArray alloc] initWithObjects:@"2명",@"3명",@"4명",@"5명",@"6명",@"7명",@"8명", nil];
		times = [[NSArray alloc] initWithObjects:@"10분",@"15분",@"20분",@"25분",@"30분",@"35분",@"40분",@"45분",@"50분", @"55분", nil];
        timeRow=0;
        memberRow=0;
        titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 11, 210, 22)];
        [titleTextField setDelegate:self];
		[titleTextField setHidden:YES];
        [titleTextField setReturnKeyType:UIReturnKeyDone];
		pptFile=nil;

	}
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View liithfecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

	[self setTitle:@"테이블 생성"];
	
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
	
	recordSwitch=[[UISwitch alloc] init];
	[recordSwitch setOn:YES];
	
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
	[pptFile release];
    [tableTitle release];
	[titleTextField release];
	[members release];
	[times	release];
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
    [memberSetPicker removeFromSuperview];
    [timeSetPicker removeFromSuperview];
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
//	cell.
	if([indexPath row]==0){
        [cell addSubview:titleTextField];
		cell.textLabel.text=@"제목";
        cell.detailTextLabel.text = tableTitle;
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
		cell.textLabel.text=@"Presentation File";
		cell.detailTextLabel.text=pptFile;
		cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
	}
	else if([indexPath row]==4){
		cell.textLabel.text=@"녹음";
		cell.accessoryType=UITableViewCellAccessoryNone;
//		[recordSwitch setCenter:CGPointMake(cell.contentView.frame.size.width-50, cell.contentView.frame.size.height/2)];
//		[cell.contentView addSubview:recordSwitch];
		cell.accessoryView=recordSwitch;
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
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
    if (indexPath.row == 0) {
        [memberSetPicker removeFromSuperview];
        memberSetPicker = nil;
        [timeSetPicker removeFromSuperview];
        timeSetPicker = nil;
        [titleTextField setHidden:NO];
        [titleTextField becomeFirstResponder];
       
    }
    else if (indexPath.row == 1) {
        [titleTextField resignFirstResponder];
        [timeSetPicker removeFromSuperview];
        timeSetPicker = nil;
        
        if (memberSetPicker) {
            return;
        }
        memberSetPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 300, 320, 100)];
        [memberSetPicker setDataSource:self];
        [memberSetPicker setShowsSelectionIndicator:YES];
        [memberSetPicker setDelegate:self];
        [memberSetPicker selectRow:memberRow inComponent:0 animated:YES];
        [self.navigationController.view addSubview:memberSetPicker];
        [memberSetPicker release];

    }
    else if (indexPath.row == 2) {
        [memberSetPicker removeFromSuperview];
        memberSetPicker = nil;
        if (timeSetPicker) {
            return;
        }
        timeSetPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 300, 320, 100)];
        [timeSetPicker setDataSource:self];
        [timeSetPicker setShowsSelectionIndicator:YES];
        [timeSetPicker setDelegate:self];
        [timeSetPicker selectRow:timeRow inComponent:0 animated:YES];
        [self.navigationController.view addSubview:timeSetPicker];
        [timeSetPicker release];
        
    }
    else if (indexPath.row == 3) {
        [memberSetPicker removeFromSuperview];
        memberSetPicker = nil;
        [timeSetPicker removeFromSuperview];
        timeSetPicker = nil;
        [titleTextField resignFirstResponder];
        PptFileSelectController* pptFileSelectList = [[PptFileSelectController alloc]init];
		[pptFileSelectList setDelegate:self];
        [self.navigationController pushViewController:pptFileSelectList animated:YES];
        [pptFileSelectList release];
    }
    else {
        [memberSetPicker removeFromSuperview];
        memberSetPicker = nil;
        [timeSetPicker removeFromSuperview];
        timeSetPicker = nil;
    }
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == memberSetPicker)
        return [members count];
    else if (pickerView == timeSetPicker)
        return [times count];
    else
        return 0;
}

-(NSString *)pickerView: (UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == memberSetPicker)
        return [members objectAtIndex:row];
    else if (pickerView == timeSetPicker)
        return [times objectAtIndex:row];
    else
        return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == memberSetPicker) {
		memberRow=row;
        switch (row) {
            case 0:
                member = 2;
                break;
            case 1:
                member = 3;
                break;
            case 2:
                member = 4;
                break;
            case 3:
                member = 5;
                break;
            case 4:
                member = 6;
                break;
            case 5:
                member = 7;
                break;
            case 6:
                member = 8;
                break;
            default:
                break;
        }
        [self.tableView reloadData];
    
    }
    else if (pickerView == timeSetPicker) {
		timeRow=row;
        switch (row) {
            case 0:
                time = 15;
                break;
            case 1:
                time = 20;
                break;
            case 2:
                time = 25;
                break;
            case 3:
                time = 30;
                break;
            case 4:
                time = 35;
                break;
            case 5:
                time = 40;
                break;
            case 6:
                time = 45;
                break;
            case 7:
                time = 50;
                break;
            case 8:
                time = 55;
                break;
            default:
                break;
        }
        [self.tableView reloadData];
    }
}

-(void)setTableTitle:(NSString *)title{
	[tableTitle release];
	tableTitle=[title copy];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
	[((UITableViewCell *)titleTextField.superview).detailTextLabel setHidden:YES];
	[titleTextField setText:((UITableViewCell *)titleTextField.superview).detailTextLabel.text];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
	[((UITableViewCell *)titleTextField.superview).detailTextLabel setHidden:NO];
	if(![textField.text isEqualToString:@""]){
		[self setTableTitle:textField.text];
		[self.tableView reloadData];
	}
    [titleTextField setHidden:true];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [titleTextField resignFirstResponder];
    return YES;
}
-(void)closeCreateTable{
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

-(void)onDoneBtn{
	if(pptFile==nil){
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Idea Table" message:@"PDF 파일을 고르세요" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
		[alert	 show];
		[alert release];
		return;
	}
	NSLog(@"%@",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES));
	
	NSString *documentPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	
	NSString *file=[documentPath stringByAppendingPathComponent:pptFile];
	NSURL *pptFileURL=[NSURL fileURLWithPath:file];
	NSLog(@"file uyrl  - %@",file);
	NSLog(@"file uyrl  - %@",pptFileURL);

	TableInfo *tableInfo=[[TableInfo alloc] init];
	[tableInfo setTitle:tableTitle];
	[tableInfo setMaxUser:member];
	[tableInfo setQuitTime:time*60];
	[tableInfo setShouldRecord:recordSwitch.isOn];
	
	ServerObject *serverObject=[[ServerObject alloc] initWithTableInfo:tableInfo];
	[serverObject setPptFile:pptFileURL];
	
	ClientObject *clientObject=[[ClientObject alloc] initWithAddress:@"127.0.0.1" port:[serverObject port] tableInfo:tableInfo];
	
	
	WaitingRoomViewController *viewController=[[WaitingRoomViewController alloc] initWithClientObject:clientObject isMaster:YES];
	[viewController setTableInfo:tableInfo];
	[tableInfo release];
	
	[viewController setServerObject:serverObject];
	[serverObject release];

	[clientObject release];
	
	[self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}

-(void)setPptFile:(NSString *)_pptFile{
	[pptFile release];
	pptFile=[_pptFile retain];
	[self.tableView reloadData];
}

@end
