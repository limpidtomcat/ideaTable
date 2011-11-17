//
//  CreateMemoController.h
//  IdeaTable
//
//  Created by DongNyeok Jeong on 10/21/11.
//  Copyright 2011 O.o.Z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateMemoController : UIViewController
{
    IBOutlet UITextView *memoField;
    NSMutableArray *totalMemoData;
	CGPoint xy;
	id delegate;
}
@property (nonatomic, retain) UITextView *memoField;
@property (nonatomic, retain) NSMutableArray *totalMemoData;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) CGPoint xy;
@end
