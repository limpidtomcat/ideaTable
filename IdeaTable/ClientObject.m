//
//  ClientObject.m
//  IdeaTable
//
//  Created by Woo Jeff on 11. 9. 29..
//  Copyright 2011년 O.o.Z. All rights reserved.
//

#import "ClientObject.h"
#import "UserInfo.h"
#define SendBufferSize 100

@implementation ClientObject
@synthesize waitingRoomDelegate;
@synthesize presentationDelegate;
@synthesize tableInfo;

static void CFSockCallBack(
					CFSocketRef s,
					CFSocketCallBackType callbackType,
					CFDataRef address,
					const void *data,
					void *info
					);

- (id)initWithAddress:(NSString *)address port:(NSUInteger)port tableInfo:(TableInfo *)_tableInfo
{
    self = [super init];
    if (self) {
		
		tableInfo=[_tableInfo retain];

		// 소켓 생성
		
		CFSocketContext socketCtxt = {0, self, NULL, NULL, NULL};	
		serverSocket = CFSocketCreate(kCFAllocatorDefault,
									  PF_INET,
									  SOCK_STREAM,
									  0,	
									  kCFSocketReadCallBack|kCFSocketConnectCallBack|kCFSocketWriteCallBack,
									  (CFSocketCallBack)&CFSockCallBack,
									  &socketCtxt);
		
		
		// 연결 정보 설정
		struct sockaddr_in theName;
		
		theName.sin_addr.s_addr=inet_addr([address cStringUsingEncoding:NSUTF8StringEncoding]);
		theName.sin_len=sizeof(theName);
		theName.sin_port = htons(port);
		theName.sin_family = AF_INET;
		
		CFDataRef addressData = CFDataCreate( NULL, (const UInt8 *)&theName, sizeof( struct sockaddr_in ) );
		
		// 연결 시도 (timeout에 -값을 주면 백그라운드 시도)
		CFSocketConnectToAddress(serverSocket, addressData, -1);
		
		// 콜백함수로 들어오도록 runloop에 등록
		FrameRunLoopSource = CFSocketCreateRunLoopSource(NULL, serverSocket, 0);
		CFRunLoopAddSource(CFRunLoopGetCurrent(), FrameRunLoopSource, kCFRunLoopCommonModes); 

	}
    
    return self;
}

-(void)dealloc{
	[tableInfo release];
	[super dealloc];
}


-(void)closeSocket{
	CFSocketInvalidate(serverSocket);
	CFRelease(serverSocket);
	CFRunLoopRemoveSource(CFRunLoopGetCurrent(), FrameRunLoopSource, kCFRunLoopCommonModes);
	CFRelease(FrameRunLoopSource);


}

// 저장된 이름을 불러오고 저장되어있지 않을 경우 디바이스 이름을 리턴
-(NSString *)myName{
	NSString *myName=[[NSUserDefaults standardUserDefaults] objectForKey:@"myName"];
	if(myName==nil)myName=[[UIDevice currentDevice] name];
	
	return myName;
}



-(void)sendData:(char *)buf{

	CFDataRef dt = CFDataCreate(NULL, (const UInt8*)buf, SendBufferSize);

	CFSocketSendData(serverSocket, NULL, dt, 0);
	
}


-(void)sendPresentationStartMessage{
	char buf[SendBufferSize];
	buf[0]=2;
	[self sendData:buf];
}

-(void)sendMessagePageMovedTo:(NSUInteger)toPage{

	char buf[SendBufferSize];
	buf[0]=3;
	memcpy(buf+1, &toPage, sizeof(toPage));
	[self sendData:buf];
}


-(void)recvData:(char *)buf{

	Byte firstByte=buf[0];
	NSLog(@"Client Get Message Code - %d",firstByte);

	// 1. Welcome
	// 서버가 이름을 받은 뒤 바로
	// 클라이언트의 id, rgb, 기존 접속자리스트를 보내온다
	if(firstByte==1){
		NSLog(@"welcome");
		NSUInteger index=1;
		NSUInteger dataLength;
		memcpy(&dataLength, buf+1, sizeof(NSUInteger));
		index+=sizeof(NSUInteger);
		NSLog(@"받은 사이즈 %d",dataLength);
		
		Byte titleLength=buf[index++];
		NSLog(@"받은 길이 %d",titleLength);
		
		char *titleBuffer=malloc(titleLength+1);
		memcpy(titleBuffer, buf+index, titleLength);
		titleBuffer[titleLength]='\0';
		NSLog(@"%s",titleBuffer);
		tableInfo.title=[NSString stringWithCString:titleBuffer encoding:NSUTF8StringEncoding];
		[waitingRoomDelegate reloadTitle];
//		[waitingRoomDelegate setTableTitle:[NSString stringWithCString:titleBuffer encoding:NSUTF8StringEncoding]];
		free(titleBuffer);
		index+=titleLength;
		
		Byte clientId=buf[index++];
		Byte r,g,b;
		r=buf[index++];
		g=buf[index++];
		b=buf[index++];
		//나부터 생성
		UserInfo *userInfo=[[UserInfo alloc] initWithName:[self myName] color:[UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f] clientId:clientId];
		[waitingRoomDelegate newUserCome:userInfo];
		[UserInfo release];
		
		
		Byte userCount=buf[index++];
		NSLog(@"connected user count - %d",userCount);
		for(Byte i=0;i<userCount;i++){
			Byte userId=buf[index++];
			Byte len=buf[index++];
			char name[100];
			strncpy(name,buf+index,len);
			name[len]='\0';
			index+=len;
			Byte r,g,b;
			r=buf[index++];
			g=buf[index++];
			b=buf[index++];
			NSLog(@"접속한 사용자 - %d, %s, %d %d %d",userId,name,r,g,b);
			
			UserInfo *userInfo=[[UserInfo alloc] initWithName:[NSString stringWithCString:name encoding:NSUTF8StringEncoding] color:[UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f] clientId:userId];
			[waitingRoomDelegate newUserCome:userInfo];
			[UserInfo release];
		}
		
		if(dataLength>0){
			NSLog(@"받을 파일 크기 - %d",dataLength);
			int receivedByte=0;
			int requestByte;
			char *fileBuf[100];
			NSMutableData *fileData=[[NSMutableData alloc] init];
			int fd=CFSocketGetNative(serverSocket);
			while(receivedByte<dataLength){
				requestByte=dataLength-receivedByte;
				if(requestByte>100)requestByte=100;
				int cnt=recv(fd, &fileBuf, requestByte, 0);
				
				receivedByte+=cnt;
				
				[fileData appendBytes:&fileBuf length:cnt];
			}
			
			NSString *tmpPath=NSTemporaryDirectory();
//			NSString *documentPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
			
			NSLog(@"DOWNLOAD COMPLETE - %d bytes",fileData.length);

			NSUInteger timeInterval=[[NSDate date] timeIntervalSince1970];
			NSString *timeString=[NSString stringWithFormat:@"%d.pdf",timeInterval];

			
			NSString *file=[tmpPath stringByAppendingPathComponent:timeString];
			NSLog(@"file path - %@",file);
			[fileData writeToFile:file atomically:YES];
			NSURL *url=[NSURL fileURLWithPath:file];

//			[waitingRoomDelegate setPptFileURL:url];
			[tableInfo setPptFile:url];
			
			[fileData release];
		}


	}
	// 2. Start
	// 3. Pagemove
	else if(firstByte==2){
		[waitingRoomDelegate startTable:self];
	}
	else if (firstByte==3){
		NSUInteger toPage;
		memcpy(&toPage, buf+1, sizeof(NSUInteger));
		NSLog(@"received page movement signal - %d",toPage);
		[presentationDelegate setPage:toPage];
	}
	
	// 4. UserCome
	// 새 사용자가 접속하여 서버가 그 사용자에 대한 정보를 보냈다
	// id, 이름, rgb
	else if(firstByte==4){	// 새 사용자가 방에 들어옴
		Byte userId=buf[1];
		Byte len=buf[2];
		char name[100];
		strncpy(name, buf+3, len);
		name[len]='\0';
		Byte r,g,b;
		r=buf[len+3];
		g=buf[len+4];
		b=buf[len+5];

		NSString *info=[NSString stringWithFormat:@"new user name%d - %s, color %d,%d,%d",len,name,r,g,b];
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"new user" message:info delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
		[alert	 show];
		[alert release];
		UserInfo *userInfo=[[UserInfo alloc] initWithName:[NSString stringWithCString:name encoding:NSUTF8StringEncoding] color:[UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1] clientId:userId];
		[waitingRoomDelegate newUserCome:userInfo];
		[userInfo release];
		
	}
	// 5. User Out
	// 다른 사용자중의 한명이 나갔다
	else if(firstByte==5){		//사용자가 나감
		Byte userId=buf[1];
		[waitingRoomDelegate userOut:userId];
	}
	else if(firstByte==6){		// 접속 거부 - 풀방
		NSLog(@"full room");
		[waitingRoomDelegate goBack];
	}
	else{
		NSLog(@"str - %s",buf);
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"received" message:[NSString stringWithCString:buf encoding:NSUTF8StringEncoding] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
		[alert	 show];
		[alert release];
	}
	
	
}


static void CFSockCallBack(
                     CFSocketRef s,
                     CFSocketCallBackType callbackType,
                     CFDataRef address,
                     const void *data,
                     void *info
					 )
{
	
    if(callbackType == kCFSocketReadCallBack) {

        // 소켓에서 읽을 수 있습니다.
        char buf[SendBufferSize] = {0};
        int sock = CFSocketGetNative(s);
		int cnt=recv(sock, &buf, SendBufferSize, 0);
		if(cnt==0){	// Server killed
			NSLog(@"connection lost");
			[(ClientObject *)info closeSocket];
		}
		else if(cnt>0){
			NSLog(@"to read : %d",cnt);
			[(ClientObject *)info recvData:buf];
		}
		
		
    }
    if(callbackType == kCFSocketWriteCallBack) {
		char buf[SendBufferSize]={0};
		buf[0]=1;

		Byte isMaster=NO;
		buf[1]=isMaster;

		// 전송을 위해 C String으로 변경
		const char *myNameCString=[[(ClientObject *)info myName] cStringUsingEncoding:NSUTF8StringEncoding];
		
		strncpy(buf+2, myNameCString,strlen(myNameCString));
		buf[strlen(myNameCString)+2]='\0';
		NSLog(@"보내는 이름  %s",buf+2);

		[(ClientObject *)info sendData:buf];

    }
    if(callbackType == kCFSocketConnectCallBack) {
        NSLog(@"client connected");
        // 연결이 이루어졌습니다.
		// 이름 보내자
	}
}



@end
