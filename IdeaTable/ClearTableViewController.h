//
//  ClearTableViewController.h
//  IdeaTable
//
//  Created by Woo Jeff on 11. 10. 9..
//  Copyright (c) 2011년 O.o.Z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableInfo.h"

@interface ClearTableViewController : UITableViewController
{
	TableInfo *tableInfo;
}

@property (nonatomic, retain) TableInfo *tableInfo;
@end
