//
//  CreateTableViewController.h
//  IdeaTable
//
//  Created by Woo Jeff on 11. 9. 27..
//  Copyright 2011년 O.o.Z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateTableViewController : UITableViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
{
	UISwitch *recordSwitch;
	
	NSString	*title;
	NSUInteger	member;
	NSUInteger	time;
	BOOL		record;
    NSUInteger  memberRow;
    NSUInteger  timeRow;
	
    UITextField *titleTextField;
    NSArray* members;
    NSArray* times;
    UIPickerView *memberSetPicker;
    UIPickerView *timeSetPicker;
}

@end
