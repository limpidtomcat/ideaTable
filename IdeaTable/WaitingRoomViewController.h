//
//  WaitingRoomViewController.h
//  IdeaTable
//
//  Created by Woo Jeff on 11. 9. 27..
//  Copyright 2011년 O.o.Z. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ClientObject.h"
#import "UserInfo.h"
@interface WaitingRoomViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
	BOOL isMaster;
	
	UITableView *userTable;
	
	NSMutableArray *userList;
//	ServerObject *serverObject;
	ClientObject *clientObject;
	
	NSUInteger port;
}

-(id)initWithClientObject:(ClientObject *)_clientObject port:(NSUInteger)_port isMaster:(BOOL)_master;
-(void)newUserCome:(UserInfo *)userInfo;
-(void)startTable:(id)sender;
@end
