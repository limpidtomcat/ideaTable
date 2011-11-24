//
//  MemoData.h
//  IdeaTable
//
//  Created by DongNyeok Jeong on 11/3/11.
//  Copyright (c) 2011 O.o.Z. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomButton : UIButton {
@private
}
@end

@interface MemoData : NSObject
{
    NSInteger slideNum;		// 슬라이드 번호
    CGPoint xy;				// 좌표
    NSString *contents;		// 내용
	NSString *userName;		// 글쓴이
	
	UIViewController *targetViewController;
}
@property (nonatomic, assign) NSInteger slideNum;
@property (nonatomic, assign) CGPoint xy;
@property (nonatomic, retain) NSString *contents;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) UIViewController *targetViewController;
-(UIButton *)memoButton;
@end
