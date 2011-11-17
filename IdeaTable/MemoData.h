//
//  MemoData.h
//  IdeaTable
//
//  Created by DongNyeok Jeong on 11/3/11.
//  Copyright (c) 2011 O.o.Z. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemoData : NSObject
{
    NSInteger slideNum;
    CGPoint xy;
    NSString *contents;
	NSString *userName;
}
@property (nonatomic, assign) NSInteger slideNum;
@property (nonatomic, assign) CGPoint xy;
@property (nonatomic, retain) NSString *contents;
@property (nonatomic, retain) NSString *userName;

-(UIButton *)memoButton;
@end
