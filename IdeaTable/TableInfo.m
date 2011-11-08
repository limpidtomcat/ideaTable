//
//  TableInfo.m
//  IdeaTable
//
//  Created by Woo Jeff on 11. 10. 10..
//  Copyright (c) 2011년 O.o.Z. All rights reserved.
//

#import "TableInfo.h"

@implementation TableInfo
@synthesize maxUser;
@synthesize title;
@synthesize pptFile;
@synthesize quitTime;
@synthesize shouldRecord;
@synthesize startTimestamp;
@synthesize overTimestamp;

-(void)dealloc{
	[title release];
	[pptFile release];
	[startTimestamp release];
	[overTimestamp release];
	[super dealloc];
}
@end
