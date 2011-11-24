//
//  CreateMemoController.m
//  IdeaTable
//
//  Created by DongNyeok Jeong on 10/21/11.
//  Copyright 2011 O.o.Z. All rights reserved.
//

#import "CreateMemoController.h"
#import "PDFViewController.h"
#import "MemoData.h"
#import "PresentationController.h"

@implementation CreateMemoController
@synthesize memoField;
@synthesize totalMemoData;
@synthesize delegate;
@synthesize xy;

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
    [memoField becomeFirstResponder];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"Memo"];
	
	UIButton *customBtn=[UIButton buttonWithType:101];
	[customBtn setTitle:@"PPT" forState:UIControlStateNormal];
	[customBtn addTarget:self action:@selector(closeMemoView) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *backBtn=[[UIBarButtonItem alloc] initWithCustomView:customBtn];
	[self.navigationItem setLeftBarButtonItem:backBtn];
	[backBtn release];
	
	UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneBtn)];
	[self.navigationItem setRightBarButtonItem:doneBtn];
	[doneBtn release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.memoField = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    [memoField release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)closeMemoView
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)doneBtn
{

	[delegate addMemoData:self.memoField.text point:xy];

    [self.navigationController dismissModalViewControllerAnimated:YES];
    
}

@end
