//
//  MemoOverlayView.m
//  IdeaTable
//
//  Created by Woo Chang ha on 11. 11. 10..
//  Copyright (c) 2011년 O.o.Z. All rights reserved.
//

#import "MemoOverlayView.h"

@implementation MemoOverlayView
//
//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}
//
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
	UIView *view=[super hitTest:point withEvent:event];
	NSLog(@"hit testing - %@ %@",view,event);
	NSLog(@"%@",NSStringFromCGRect(view.frame));
	return view;
}

@end
