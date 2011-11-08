//
//  WaitingRoomViewController.h
//  IdeaTable
//
//  Created by Woo Jeff on 11. 9. 27..
//  Copyright 2011년 O.o.Z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerObject.h"
#import "ClientObject.h"
#import "UserInfo.h"
#import "TableInfo.h"

@interface WaitingRoomViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
	TableInfo *tableInfo;
	
	BOOL isMaster;
	
	UITableView *userTable;
	
	NSMutableArray *userList;
	ServerObject *serverObject;
	ClientObject *clientObject;
	
	UIBarButtonItem *startBtn;
	
}

@property (nonatomic, retain) TableInfo *tableInfo;
@property (nonatomic, retain) ServerObject *serverObject;


-(id)initWithClientObject:(ClientObject *)_clientObject isMaster:(BOOL)_master;
-(void)newUserCome:(UserInfo *)userInfo;
-(void)startTable:(id)sender;
-(void)reloadTitle;
@end
