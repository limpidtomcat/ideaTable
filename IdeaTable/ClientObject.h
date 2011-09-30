//
//  ClientObject.h
//  IdeaTable
//
//  Created by Woo Jeff on 11. 9. 29..
//  Copyright 2011년 O.o.Z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/types.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <netdb.h>

@interface ClientObject : NSObject

- (id)initWithAddress:(NSString *)address port:(NSUInteger)port;
@end
