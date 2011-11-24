//
//  MemoViewController.h
//  IdeaTable
//
//  Created by Woo Chang ha on 11. 11. 8..
//  Copyright (c) 2011년 O.o.Z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemoData.h"
@interface MemoViewController : UIViewController
{
	MemoData *memoData;
	
	IBOutlet UINavigationItem *navigationItem;

}
@property (nonatomic, retain) UINavigationItem *navigationItem;

-(id)initWithMemoData:(MemoData *)_memoData;
-(IBAction)back:(id)sender;
@end
