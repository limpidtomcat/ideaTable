//
//  UserInfo.m
//  IdeaTable
//
//  Created by Woo Jeff on 11. 9. 27..
//  Copyright 2011년 O.o.Z. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
@synthesize name;
@synthesize penColor;

- (id)init
{
    self = [super init];
    if (self) {
		name=[[NSString alloc] initWithFormat:@"User Test"];
		penColor=[[UIColor alloc] initWithRed:1 green:0 blue:0 alpha:1];
    }
    
    return self;
}

-(void)dealloc{
	[penColor release];
	[name release];
	[super dealloc];
}

@end
