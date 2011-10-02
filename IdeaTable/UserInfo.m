//
//  UserInfo.m
//  IdeaTable
//
//  Created by Woo Jeff on 11. 9. 27..
//  Copyright 2011년 O.o.Z. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
@synthesize clientId;
@synthesize name;
@synthesize penColor;

-(id) initWithName:(NSString *)_name color:(UIColor *)_col clientId:(NSUInteger)_id
{
	self = [super init];
	if(self){
		clientId=_id;
		NSLog(@"userinfo creating name - %@",_name);
		name=[_name retain];
		penColor=[_col retain];
	}
	return self;
}

-(void)dealloc{
	[penColor release];
	[name release];
	[super dealloc];
}

@end
