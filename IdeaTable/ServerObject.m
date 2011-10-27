//
//  ServerObject.m
//  IdeaTable
//
//  Created by Woo Jeff on 11. 9. 27..
//  Copyright 2011년 O.o.Z. All rights reserved.
//

#import "ServerObject.h"
#define SendBufferSize 100

@implementation ServerObject
@synthesize port;

@synthesize connectedClients;
@synthesize pptFile;


-(NSUInteger)maxUserCount{
	return tableInfo.maxUser;
}
- (id)initWithTableInfo:(TableInfo *)_tableInfo{
	self =[super init];
	if(self){
		tableInfo=[_tableInfo retain];
		maxUserId=0;
		port=[self initServerSocket];

		connectedClients=[[NSMutableArray alloc] init];
		availableColors=[[NSMutableSet alloc] initWithObjects:
						 [UIColor blackColor],
						 [UIColor redColor],
						 [UIColor blueColor],
						 [UIColor purpleColor],
						 [UIColor brownColor],
						 [UIColor cyanColor],
						 [UIColor greenColor],
						 [UIColor magentaColor],
						 [UIColor orangeColor],
						 nil];
	}
	return self;
}


-(void)dealloc{
	[availableColors release];
	[connectedClients release];
	[super dealloc];
}

-(void)closeServer{
	
	// clients disconnect
	NSArray *clients=[NSArray arrayWithArray:connectedClients];
	for(NSValue *value in clients){
		ConnectedClient *client=[value pointerValue];
		[self disconnectSocket:client->socketRef];
	}
	
	// CLOSE LISTENING SOCKET
	
	[netService release];
	CFSocketInvalidate(listeningSocket);
	CFRelease(listeningSocket);
	CFRunLoopRemoveSource(CFRunLoopGetCurrent(), listeningRunLoopSourceRef, kCFRunLoopCommonModes);
	CFRelease(listeningRunLoopSourceRef);
	
}

-(void)acceptedNewClient:(CFSocketRef)s
{

	CFRunLoopSourceRef FrameRunLoopSource = CFSocketCreateRunLoopSource(NULL, s , 0);
	CFRunLoopAddSource(CFRunLoopGetCurrent(), FrameRunLoopSource, kCFRunLoopCommonModes); 

	ConnectedClient *k=malloc(sizeof(ConnectedClient));
	k->socketRef=s;
	k->runLoopSourceRef=FrameRunLoopSource; 
	k->clientId=maxUserId++;
	
	UIColor *userCol=[availableColors anyObject];
	// Available Color 중 하나를 선택. 없으면 랜덤한 컬러 생성
	if (userCol) {
		[availableColors removeObject:userCol];
		
		const float *rgba=CGColorGetComponents(userCol.CGColor);
		k->r=(Byte)(rgba[0]*255);
		k->g=(Byte)(rgba[1]*255);
		k->b=(Byte)(rgba[2]*255);
	}else{
		k->r=rand()%256;
		k->g=rand()%256;
		k->b=rand()%256;
	}
	
	
	NSValue *clientValue=[NSValue valueWithPointer:k];
	[connectedClients addObject:clientValue];
	
	NSLog(@"%@",connectedClients);
}

-(ConnectedClient *)getClientBySocketRef:(CFSocketRef)s{
	ConnectedClient *client;
	for(NSValue *v in connectedClients){
		ConnectedClient *k=[v pointerValue];
		if(k->socketRef==s){
			client=k;
		}
	}
	return client;
}




-(void)sendData:(char *)buf toClient:(CFSocketRef)socket{
	NSLog(@"sending from server - %s",buf);
	CFDataRef dt = CFDataCreate(NULL, (const UInt8*)buf, SendBufferSize);
	CFSocketSendData(socket, NULL, dt, 0);
	
}
-(void)sendData:(char *)buf exceptClient:(CFSocketRef)socket{
	for(NSValue *val in connectedClients){
		ConnectedClient *p=[val pointerValue];
		
		CFSocketRef s=p->socketRef;
		if(s==socket)continue;
		[self sendData:buf toClient:s];
	}
}

-(void)disconnectSocket:(CFSocketRef)s{
	
	ConnectedClient *client=[self getClientBySocketRef:s];
	
	char buf[SendBufferSize]={0};
	buf[0]=5;
	buf[1]=client->clientId;
	[self sendData:buf exceptClient:s];
	
	NSValue *clientValue=[NSValue valueWithPointer:client];
	
	CFSocketInvalidate(client->socketRef);
	CFRelease(client->socketRef);
	CFRunLoopRemoveSource(CFRunLoopGetCurrent(), client->runLoopSourceRef, kCFRunLoopCommonModes);
	CFRelease(client->runLoopSourceRef);
	[connectedClients removeObject:clientValue];
	free(client);
	
}

-(void)recvData:(char *)buf fromClient:(CFSocketRef)s{
	Byte firstByte=buf[0];
	NSLog(@"Server Get Message Code - %d",firstByte);
	if(firstByte==1){	// 클라이언트 접속, 이름을 보내왔다

		ConnectedClient *client=[self getClientBySocketRef:s];
		
		BOOL isMaster=buf[1];

		int len=strlen(buf+2);
		strncpy(client->name, buf+2, len);
		client->name[len]='\0';

		char sendBuf[SendBufferSize]={0};
		NSUInteger index=0;
		
		sendBuf[index++]=4;
		sendBuf[index++]=client->clientId;
		sendBuf[index++]=len;
		memcpy(sendBuf+index, client->name, len);
		
		index+=len;
		sendBuf[index++]=client->r;
		sendBuf[index++]=client->g;
		sendBuf[index++]=client->b;
		[self sendData:sendBuf exceptClient:s];
		

		
		NSLog(@"%@",pptFile);
		NSData *pptData=[NSData dataWithContentsOfURL:pptFile];


		index=0;
		// first Byte
		sendBuf[index++]=1;

		// file Size
		NSUInteger dataLength=pptData.length;
		if(isMaster)dataLength=0;
		memcpy(sendBuf+index, &(dataLength), sizeof(NSUInteger));
		index+=sizeof(NSUInteger);
		NSLog(@"보내는 사이즈 %d",dataLength);

		// title length
		Byte titleLength=tableInfo.title.length;
		sendBuf[index++]=titleLength;
		NSLog(@"보내는 길이 %d",titleLength);
		
		// title string
		const char *title=[tableInfo.title cStringUsingEncoding:NSUTF8StringEncoding];
		NSLog(@"sending title  %s",title);
		memcpy(sendBuf+index, title, strlen(title));
		index+=strlen(title);
		
		// ID
		sendBuf[index++]=client->clientId;
		
		//rgb
		sendBuf[index++]=client->r;
		sendBuf[index++]=client->g;
		sendBuf[index++]=client->b;
		
		// user count
		Byte userCount=[connectedClients count];
		sendBuf[index++]= userCount-1;

		// user info
		for(NSUInteger i=0;i<userCount;i++){
			ConnectedClient *user=[[connectedClients objectAtIndex:i] pointerValue];
			if(client==user)continue;
			sendBuf[index++]=user->clientId;
			sendBuf[index++]=strlen(user->name);
			strncpy(sendBuf+index, user->name, strlen(user->name));
			index+=strlen(user->name);
			sendBuf[index++]=user->r;
			sendBuf[index++]=user->g;
			sendBuf[index++]=user->b;
		}
		[self sendData:sendBuf toClient:s];

		NSArray *tempArr=[NSArray arrayWithObjects:[NSValue valueWithPointer:s],pptData, nil];

		[self performSelectorInBackground:@selector(sendPptFile:) withObject:tempArr];

		
	}
	else if(firstByte==2){	// Presentation Started
		if(tableInfo.quitTime>0){
			NSLog(@"timer set - %d",tableInfo.quitTime);
			quitTimer=[[NSTimer scheduledTimerWithTimeInterval:tableInfo.quitTime target:self selector:@selector(tableTimeOut:) userInfo:nil repeats:NO] retain];
		}
		[self sendData:buf exceptClient:s];
	}
	else if(firstByte==3){	// Page Moved
		[self sendData:buf exceptClient:s];
	}
	else if(firstByte==7){	// Drawing
		[self sendData:buf exceptClient:s];
	}
	else{
		NSLog(@"str - %s",buf);
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"received" message:[NSString stringWithCString:buf encoding:NSUTF8StringEncoding] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
		[alert	 show];
		[alert release];
	}
}

-(void)sendPptFile:(NSArray *)tData{
	NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];

	NSData *pptData=[tData objectAtIndex:1];
	CFSocketRef s=[[tData objectAtIndex:0] pointerValue];

	CFDataRef pptCFData = CFDataCreate(NULL, (const UInt8*)pptData.bytes, pptData.length);
	NSLog(@"sending ppd data");
	

	CFSocketSendData(s, NULL, pptCFData, 0);
	NSLog(@"sended ppd data");

	CFRelease(pptCFData);
	
	pptCFData=NULL;
	
	[pool release];
}


void CFServerSocketCallBack (
							  CFSocketRef s,
							  CFSocketCallBackType callbackType,
							  CFDataRef address,
							  const void *data,
							  void *info
							  ){
	NSLog(@"callback is main thread - %d",[NSThread isMainThread]);
    if(callbackType == kCFSocketReadCallBack) {
        // 소켓에서 읽을 수 있습니다.
        char buf[SendBufferSize] = {0};
        int sock = CFSocketGetNative(s);

		int cnt=recv(sock, &buf, SendBufferSize, 0);
		NSLog(@"readed %d",cnt);
		if(cnt==0){
			NSLog(@"접속 종료됨 %@",[NSValue valueWithPointer:s]);
			[(ServerObject *)info disconnectSocket:s];
			
			
		}
		else if(cnt>0){
			NSLog(@"to read : %d",cnt);
			[(ServerObject *)info recvData:buf fromClient:s];
		}
		
    }
    if(callbackType == kCFSocketWriteCallBack) {
        NSLog(@"to write");
//		NSLog(@"%@",self);
//		[(ServerObject *)info sendData:s];
        // 데이터 송신이 가능해졌습니다.
    }
    if(callbackType == kCFSocketConnectCallBack) {
        NSLog(@"connected");
        // 연결이 이루어졌습니다.
    }
}


static void CFListeningSockCallBack (
                     CFSocketRef s,
                     CFSocketCallBackType callbackType,
                     CFDataRef address,
                     const void *data,
                     void *info
					 )
{
	
	ServerObject *serverObject=(ServerObject*)info;
	
	if(callbackType == kCFSocketAcceptCallBack ){
        NSLog(@"accepted");

		if([[serverObject connectedClients] count]>=serverObject.maxUserCount){//접속 거부
			CFSocketNativeHandle fd = *(CFSocketNativeHandle*)data;
			CFSocketRef serverSocket=CFSocketCreateWithNative(kCFAllocatorDefault, fd, kCFSocketNoCallBack, (CFSocketCallBack)&CFServerSocketCallBack, NULL);
			char buf[100];
			buf[0]=6;
			[serverObject sendData:buf toClient:serverSocket];
			CFSocketInvalidate(serverSocket);
			CFRelease(serverSocket);
			
			
		}else{
			CFSocketContext socketCtxt = {0, info, NULL, NULL, NULL};	
			
			CFSocketNativeHandle fd = *(CFSocketNativeHandle*)data;
			CFSocketRef serverSocket=CFSocketCreateWithNative(kCFAllocatorDefault, fd, kCFSocketReadCallBack|kCFSocketWriteCallBack|kCFSocketConnectCallBack, (CFSocketCallBack)&CFServerSocketCallBack, &socketCtxt);
			
			
			[serverObject acceptedNewClient:serverSocket];
			
		}
		
	}

}

-(NSUInteger)initServerSocket
{

	CFSocketContext socketCtxt = {0, self, NULL, NULL, NULL};	
	
	int m_nSocket = socket(AF_INET, SOCK_STREAM, 0);
	
	
	struct sockaddr_in serverAddress;		
	memset(&serverAddress, 0, sizeof(serverAddress));
	
	serverAddress.sin_family = AF_INET;
	serverAddress.sin_port = htons(0);
	serverAddress.sin_addr.s_addr = INADDR_ANY;//inet_addr([m_strInetAddress UTF8String]);
	memset(serverAddress.sin_zero, '\0', sizeof serverAddress.sin_zero);	
	
	
	if( bind(m_nSocket, (struct sockaddr *)&serverAddress, sizeof(serverAddress) ) < 0)
	{
		@throw [NSException exceptionWithName: @"Server" reason: @"Can't bind to socket" userInfo: nil];
	}		
	
	if(listen(m_nSocket, 256) != 0)
		@throw [NSException exceptionWithName: @"Server" reason: @"Can't listen socket" userInfo: nil];		
	
	listeningSocket = CFSocketCreateWithNative(kCFAllocatorDefault, m_nSocket, kCFSocketAcceptCallBack, (CFSocketCallBack)&CFListeningSockCallBack, &socketCtxt);
//	CFSocketRef m_listeningSocket = CFSocketCreateWithNative(kCFAllocatorDefault, m_nSocket, kCFSocketAcceptCallBack, (CFSocketCallBack)&CFListeningSockCallBack, &socketCtxt);
	
	if(listeningSocket < 0)
		@throw [NSException exceptionWithName: @"Server" reason: @"Can't create CFScoket" userInfo: nil];
	
	// set up the run loop sources for the sockets
	CFRunLoopRef cfRunLoopRef = CFRunLoopGetCurrent();
	listeningRunLoopSourceRef = CFSocketCreateRunLoopSource(kCFAllocatorDefault, listeningSocket, 0);
//	CFRunLoopSourceRef cfRunLoopSourceRef = CFSocketCreateRunLoopSource(kCFAllocatorDefault, listeningSocket, 0);
	NSAssert(listeningRunLoopSourceRef, @"Can't create RunLoopSource");
	
	
	CFRunLoopAddSource(cfRunLoopRef, listeningRunLoopSourceRef, kCFRunLoopCommonModes);		
//	CFRelease(cfRunLoopSourceRef);		
	
	
	// 콜백함수로 들어오도록 runloop에 등록
//	CFRunLoopSourceRef FrameRunLoopSource = CFSocketCreateRunLoopSource(NULL, listeningSocket , 0);
//	CFRunLoopAddSource(CFRunLoopGetCurrent(), FrameRunLoopSource, kCFRunLoopCommonModes); 
	

	
	CFDataRef	 dataRef = CFSocketCopyAddress(listeningSocket);
	struct sockaddr_in *sockaddr = (struct sockaddr_in*)CFDataGetBytePtr(dataRef);

	
	char	space[255];
	inet_ntop(AF_INET, &sockaddr->sin_addr, space, sizeof(space) );
	int p=ntohs(sockaddr->sin_port);
	

	NSLog(@"%s %d",space,p);
	
	

	CFRelease(dataRef);
	
	
	netService=[[NSNetService alloc] initWithDomain:@"local." type:@"_idea._tcp." name:tableInfo.title port:p];
	[netService publish];
//	[netService release];
	
	//	NSLog(@"%@",[NSString stringwithcf])
	return (NSUInteger)p;

}



#if ! defined(IFT_ETHER)
#define IFT_ETHER 0x6/* Ethernet CSMACD */
#endif

+ (NSString *)localIPAddress
{
	BOOL			success;
	struct ifaddrs * addrs	= NULL;
	const struct	ifaddrs * cursor;
	NSString		*address	= @"";
	
	success = (getifaddrs(&addrs) == 0);
	if (success) 
	{
		cursor = addrs;
		while (cursor != NULL) {
			if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0) // this second test keeps from picking up the loopback address
			{
				NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
				if ([name isEqualToString:@"en0"]) 
				{ // found the WiFi adapter					
					address	= [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
					break;
				}
			}
			
			cursor = cursor->ifa_next;
		}
		freeifaddrs(addrs);
	}
	return address;	
	
}

-(void)tableTimeOut:(NSTimer *)timer{
	NSLog(@"table time out");
}

@end
