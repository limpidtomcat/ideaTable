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
	BOOL pptFileDownloaded;
	Byte clientId;
	NSString *name;
	UIColor *penColor;
}

@property (nonatomic, assign) BOOL pptFileDownloaded;
@property (nonatomic, readonly) Byte clientId;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) UIColor *penColor;

-(id) initWithName:(NSString *)_name color:(UIColor *)_col clientId:(NSUInteger)_id;
+(void)setMe:(UserInfo *)userInfo;
+(UserInfo *)me;
@end
