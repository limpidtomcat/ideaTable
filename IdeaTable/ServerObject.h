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

#import "TableInfo.h"

typedef struct {
	CFSocketRef socketRef;
	CFRunLoopSourceRef runLoopSourceRef;
	Byte clientId;
	char name[100];
	Byte r,g,b;
} ConnectedClient;

@interface ServerObject : NSObject
{
	TableInfo *tableInfo;
	
//	NSString *tableTitle;
//	NSURL *pptFile;
	NSNetService *netService;
	
	NSUInteger port;
//	NSUInteger maxUserCount;
	CFSocketRef listeningSocket;
	CFRunLoopSourceRef listeningRunLoopSourceRef;
	
	NSMutableArray *connectedClients;
	NSMutableSet *availableColors;
	Byte maxUserId;
	
	NSTimer	 *quitTimer;
	
}

@property (nonatomic, readonly) NSMutableArray *connectedClients;
@property (nonatomic, readonly) NSUInteger maxUserCount;
@property (nonatomic, assign) NSUInteger port;
@property (nonatomic ,retain) NSURL *pptFile;

+ (NSString *)localIPAddress;
-(NSUInteger)initServerSocket;
-(void)closeServer;
//- (id)initWithTableTitle:(NSString *)title maxUserCount:(NSUInteger)count;
- (id)initWithTableInfo:(TableInfo *)tableInfo;


@end
