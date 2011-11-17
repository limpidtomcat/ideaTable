//
//  MemoData.m
//  IdeaTable
//
//  Created by DongNyeok Jeong on 11/3/11.
//  Copyright (c) 2011 O.o.Z. All rights reserved.
//

#import "MemoData.h"

@implementation MemoData

@synthesize slideNum;
@synthesize xy;
@synthesize contents;
@synthesize userName;

-(void)dealloc{
	[contents release];
	[userName release];
	[super dealloc];
}

-(UIButton *)memoButton{
	UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
	[btn setFrame:CGRectMake(xy.x, xy.y, 30, 30)];
	[btn setBackgroundColor:[UIColor redColor]];
	[btn addTarget:self  action:@selector(btnProcess:) forControlEvents:UIControlEventTouchUpInside];
	
	return btn;
	
}

-(void)btnProcess:(id)sender{
	NSLog(@"memo button pushed");
}

@end
