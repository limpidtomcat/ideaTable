//
//  PptFileSelectController.h
//  IdeaTable
//
//  Created by DongNyeok Jeong on 9/30/11.
//  Copyright 2011 O.o.Z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PptFileSelectController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *pptFileTable;
    NSMutableArray *pptFileList;
}

@end
