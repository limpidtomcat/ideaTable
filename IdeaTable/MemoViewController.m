//
//  MemoViewController.m
//  IdeaTable
//
//  Created by Woo Chang ha on 11. 11. 8..
//  Copyright (c) 2011년 O.o.Z. All rights reserved.
//

#import "MemoViewController.h"

@implementation MemoViewController
@synthesize  navigationItem;

-(id)initWithMemoData:(MemoData *)_memoData{
	self=[super	init];
	if(self){
		memoData=[_memoData retain];
	}
	return self;
}

-(void)dealloc{
	[memoData release];
	[super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
	NSLog(@"name - %@",[memoData userName]);
	[navigationItem setTitle:[memoData userName]];

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
-(IBAction)back:(id)sender{
	[self dismissModalViewControllerAnimated:YES];
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 400;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MemoContentCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }

//	memoData.contents
	NSLog(@"memo contetn - %@",memoData.contents);
//    cell
	;
	[cell.textLabel setNumberOfLines:[[memoData.contents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] count]];
	cell.selectionStyle=UITableViewCellEditingStyleNone;
	cell.textLabel.text=memoData.contents;

    return cell;
}
@end
