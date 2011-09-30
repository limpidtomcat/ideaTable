//
//  ClientObject.m
//  IdeaTable
//
//  Created by Woo Jeff on 11. 9. 29..
//  Copyright 2011년 O.o.Z. All rights reserved.
//

#import "ClientObject.h"

@implementation ClientObject

- (id)initWithAddress:(NSString *)address port:(NSUInteger)port
{
    self = [super init];
    if (self) {
		[self initClientSocketWithAddress:address port:port];
    }
    
    return self;
}

void CFSockCallBack (
                     CFSocketRef s,
                     CFSocketCallBackType callbackType,
                     CFDataRef address,
                     const void *data,
                     void *info
					 )
{
	
//    NSLog(@"callback!");
	if(callbackType == kCFSocketDataCallBack) {
		NSLog(@"has data");
        // 데이터 수신시 여기에 프로그래밍하세요
        UInt8 * d = CFDataGetBytePtr((CFDataRef)data);
		
		NSString *str=[[NSString alloc] initWithCString:(const char*)d encoding:NSUTF8StringEncoding];
		NSLog(@"%@",str);
		[str release];
    }
    if(callbackType == kCFSocketReadCallBack) {
        // 소켓에서 읽을 수 있습니다.
        char buf[100] = {0};
        int sock = CFSocketGetNative(s);
		int cnt=recv(sock, &buf, 100, 0);
		if(cnt>0){
			NSLog(@"to read : %d",cnt);
			NSLog(@"%s",buf);
		}
		
    }
    if(callbackType == kCFSocketWriteCallBack) {
        NSLog(@"to write");
        // 데이터 송신이 가능해졌습니다.
        char sendbuf[100]={0};
        strcpy(sendbuf,"GET / HTTP/1.0\r\n\r\n");
        CFDataRef dt = CFDataCreate(NULL, (const UInt8*)sendbuf, sizeof(sendbuf));
        CFSocketSendData(s, NULL, dt, 0);
    }
    if(callbackType == kCFSocketConnectCallBack) {
        NSLog(@"connected");
        // 연결이 이루어졌습니다.
    }
}

-(void)initClientSocketWithAddress:(NSString *)address port:(NSUInteger)port
{
	// Network connection
	
	// 소켓 생성
	CFSocketRef clientSocketRef;
	clientSocketRef = CFSocketCreate(kCFAllocatorDefault,
									 PF_INET,
									 SOCK_STREAM,
									 0,	
									 kCFSocketReadCallBack|kCFSocketConnectCallBack|kCFSocketWriteCallBack,
									 CFSockCallBack,
									 NULL);
	
	
	// 연결 정보 설정
	struct sockaddr_in theName;
//	struct hostent *hp;
	
	NSLog(@"%@",address);
	theName.sin_addr.s_addr=inet_addr([address cStringUsingEncoding:NSUTF8StringEncoding]);
	theName.sin_len=sizeof(theName);
	theName.sin_port = htons(port);
	theName.sin_family = AF_INET;
	
	//호스트 정보를 알아온다
//	hp = gethostbyname("naver.com");
//	if( hp == NULL ) {
//		return;
//	}
	//	theName.
//	memcpy( &theName.sin_addr.s_addr, hp->h_addr_list[0], hp->h_length );
	
	CFDataRef addressData = CFDataCreate( NULL, &theName, sizeof( struct sockaddr_in ) );
	
	// 연결 시도 (timeout에 -값을 주면 백그라운드 시도)
	CFSocketConnectToAddress(clientSocketRef, addressData, 30);
	
	// 콜백함수로 들어오도록 runloop에 등록
	CFRunLoopSourceRef FrameRunLoopSource = CFSocketCreateRunLoopSource(NULL, clientSocketRef , 0);
	CFRunLoopAddSource(CFRunLoopGetCurrent(), FrameRunLoopSource, kCFRunLoopCommonModes); 
	
}

@end
