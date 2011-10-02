//
//  ServerObject.h
//  IdeaTable
//
//  Created by Woo Jeff on 11. 9. 27..
//  Copyright 2011년 O.o.Z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/types.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <netdb.h>



#include <ifaddrs.h>
#include <arpa/inet.h>

#include <net/if.h>
#include <net/if_dl.h>

typedef struct {
	CFSocketRef socketRef;
	CFRunLoopSourceRef runLoopSourceRef;
	Byte clientId;
	char name[100];
	Byte r,g,b;
} ConnectedClient;

@interface ServerObject : NSObject
{
	NSUInteger port;
//	CFSocketRef 
	NSMutableArray *connectedClients;
	NSMutableSet *availableColors;
	Byte maxUserId;
	
}

@property (nonatomic, assign) NSUInteger port;

+ (NSString *)localIPAddress;
-(NSUInteger)initServerSocket;


@end
