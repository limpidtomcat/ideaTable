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
#import "TableInfo.h"

@protocol WaitingRoomDelegate;

@protocol PresentationDelegate;

@interface ClientObject : NSObject
{
	TableInfo *tableInfo;
	CFSocketRef serverSocket;
	CFRunLoopSourceRef FrameRunLoopSource;
	id<WaitingRoomDelegate> waitingRoomDelegate;
	id<PresentationDelegate> presentationDelegate;
}

@property (nonatomic, retain) TableInfo *tableInfo;
@property (nonatomic, assign) id<WaitingRoomDelegate> waitingRoomDelegate;
@property (nonatomic, assign) id<PresentationDelegate> presentationDelegate;

- (id)initWithAddress:(NSString *)address port:(NSUInteger)port tableInfo:(TableInfo *)_tableInfo;

-(void)sendPresentationStartMessage;
//-(void)sendPageMoveMessageFrom:(NSUInteger)fromPage to:(NSUInteger)toPage;
-(void)sendMessagePageMovedTo:(NSUInteger)toPage;
-(void)closeSocket;
-(void)sendDrawingInfoPen:(NSMutableData *)penInfo start:(CGPoint)start end:(CGPoint)end;

@end


@protocol WaitingRoomDelegate <NSObject>

@end