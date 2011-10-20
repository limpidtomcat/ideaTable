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
@protocol PDFViewDelegate;

@interface ClientObject : NSObject
{
	TableInfo *tableInfo;
	CFSocketRef serverSocket;
	CFRunLoopSourceRef FrameRunLoopSource;
	id<WaitingRoomDelegate> waitingRoomDelegate;
	id<PDFViewDelegate> pdfViewDelegate;
}

@property (nonatomic, retain) TableInfo *tableInfo;
@property (nonatomic, assign) id<WaitingRoomDelegate> waitingRoomDelegate;
@property (nonatomic, assign) id<PDFViewDelegate> pdfViewDelegate;
- (id)initWithAddress:(NSString *)address port:(NSUInteger)port tableInfo:(TableInfo *)_tableInfo;

-(void)sendPresentationStartMessage;
//-(void)sendPageMoveMessageFrom:(NSUInteger)fromPage to:(NSUInteger)toPage;
-(void)sendMessagePageMovedTo:(NSUInteger)toPage;
-(void)closeSocket;

@end


@protocol WaitingRoomDelegate <NSObject>

@end