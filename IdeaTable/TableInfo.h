//
//  TableInfo.h
//  IdeaTable
//
//  Created by Woo Jeff on 11. 10. 10..
//  Copyright (c) 2011년 O.o.Z. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableInfo : NSObject
{
	NSString *title;
	NSUInteger maxUser;
	NSURL *pptFile;
	BOOL shouldRecord;

	
	NSUInteger quitTime;
	
	NSString *startTimestamp;
	NSString *overTimestamp;
	

}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, assign) NSUInteger maxUser;
@property (nonatomic, retain) NSURL *pptFile;
@property (nonatomic, assign) NSUInteger quitTime;
@property (nonatomic, assign) BOOL shouldRecord;
@property (nonatomic, retain) NSString *startTimestamp;
@property (nonatomic, retain) NSString *overTimestamp;

@end
