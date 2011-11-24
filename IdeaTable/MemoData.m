//
//  MemoData.m
//  IdeaTable
//
//  Created by DongNyeok Jeong on 11/3/11.
//  Copyright (c) 2011 O.o.Z. All rights reserved.
//

#import "MemoData.h"
#import "MemoViewController.h"
@implementation MemoData

@synthesize slideNum;
@synthesize xy;
@synthesize contents;
@synthesize userName;
@synthesize  targetViewController;

-(void)dealloc{
	[contents release];
	[userName release];
	[super dealloc];
}

-(UIButton *)memoButton{
	CustomButton *btn=[CustomButton buttonWithType:UIButtonTypeCustom];
//	UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
	[btn setFrame:CGRectMake(xy.x, xy.y, 30, 30)];
//	[btn setBackgroundColor:[UIColor redColor]];
	[btn setImage:[UIImage imageNamed:@"Astral.Memo_icon.png"] forState:UIControlStateNormal];
	//Astral.Memo_icon.png
	[btn addTarget:self action:@selector(btnProcess:) forControlEvents:UIControlEventTouchUpInside];
	
	return btn;
	
}

-(void)btnProcess:(id)sender{

	MemoViewController *memoViewController = [[MemoViewController alloc] initWithMemoData:self];
	[targetViewController presentModalViewController:memoViewController animated:YES];
	[memoViewController release];
}

@end

@implementation CustomButton

//-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//	UIView *view=[super hitTest:point withEvent:event];
////	NSLog(@"button hit test - %@",view);
//	return view;
//}
//
//-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
//	BOOL flag=[super pointInside:point withEvent:event];
////	NSLog(@"button point iside");
//	return flag;
//}
//
//
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//	[super touchesBegan:touches withEvent:event];
//	NSLog(@"custom button touches began");
//}
@end
