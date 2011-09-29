//
//  CreateTableViewController.h
//  IdeaTable
//
//  Created by Woo Jeff on 11. 9. 27..
//  Copyright 2011년 O.o.Z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateTableViewController : UITableViewController
{
	UISwitch *recordSwitch;
	
	NSString	*title;
	NSUInteger	member;
	NSUInteger	time;
	BOOL		record;
	
}
@end
