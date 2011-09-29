//
//  UserInfo.h
//  IdeaTable
//
//  Created by Woo Jeff on 11. 9. 27..
//  Copyright 2011년 O.o.Z. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
{
	NSString *name;
	UIColor *penColor;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) UIColor *penColor;
@end
