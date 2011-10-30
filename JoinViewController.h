//
//  JoinViewController.h
//  IdeaTable
//
//  Created by Woo Jeff on 11. 9. 30..
//  Copyright 2011년 O.o.Z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JoinViewController : UIViewController<NSNetServiceBrowserDelegate, NSNetServiceDelegate>
{
	IBOutlet UITextField *ipField;
	IBOutlet UITextField *portField;
	
	NSMutableArray *waitingRooms;
	
	IBOutlet UITableView *waitingRoomTable;
	
	NSNetServiceBrowser *browser;
}

@property (nonatomic ,retain) UITextField *ipField;
@property (nonatomic ,retain) UITextField *portField;
@property (nonatomic ,retain) UITableView *waitingRoomTable;

@end
