//
//  ClearTableViewController.h
//  IdeaTable
//
//  Created by Woo Jeff on 11. 10. 9..
//  Copyright (c) 2011년 O.o.Z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableInfo.h"
#import "AudioRecordController.h"
@interface ClearTableViewController : UITableViewController
{
	TableInfo *tableInfo;
	AudioRecordController *audioRecordController;
	NSMutableArray *drawingDataArray;

	BOOL tableSave;
	BOOL memoSave;
	BOOL drawSave;
	BOOL recordSave;
}

@property (nonatomic, retain) TableInfo *tableInfo;
@property (nonatomic, retain) AudioRecordController *audioRecordController;
@property (nonatomic, retain) NSMutableArray *drawingDataArray;
@end
