//
//  DrawingData.m
//  IdeaTable
//
//  Created by Woo Chang ha on 11. 10. 23..
//  Copyright (c) 2011년 O.o.Z. All rights reserved.
//

#import "DrawingData.h"

@implementation DrawingData
@synthesize drawData;
@synthesize infoArr;
@synthesize dataArr;
@synthesize countArr;

-(id)init{
	self=[super	init];
	if(self){

	/*	
		// 펜 그리기 기록을 파일로부터 불러온다

		NSString *_fileName = [pathStr stringByAppendingPathComponent:[NSString stringWithFormat:DRAW_DATA_PATH,page]];
		if([[NSFileManager defaultManager] fileExistsAtPath:_fileName]){
			drawData=[[NSMutableArray alloc] initWithContentsOfFile:_fileName];
		}else{
			drawData=[[NSMutableArray alloc] init];
		}
		
	 */
		// 펜 그리기 정보 배열을 생성한다
		[self parseFromDrawData];
	
	}
	return self;
}

-(void)dealloc
{

	
	// 펜 정보 메모리 해제
	for(NSUInteger i=0;i<[infoArr count];i++){
		free(dataArr[i]);
	}
	free(dataArr);
	[infoArr release];
	[countArr release];
	[drawData release];
	

	[super dealloc];
}

// 그리기 기록 배열로부터 펜 속성 기록과 좌표 기록을 분리해내고
// 좌표 기록을 세분화하여 VertexArray를 만든다
-(void)parseFromDrawData{
	// 기존에 배열이 생성 되어있으면 해제
	if(dataArr){
		for(NSUInteger i=0;i<[infoArr count];i++){
			free(dataArr[i]);
		}
		[infoArr release];
		[countArr release];
		
		free(dataArr);
	}
	
	infoArr=[[NSMutableArray alloc] init];
	countArr=[[NSMutableArray alloc] init];
	dataArr=malloc( ([drawData count] / 2) * sizeof(GLfloat*));
	
	// 선분 개수만큼 반복
	for(NSUInteger i=0;i<[drawData count];i+=2){
		// 펜 속성 정보 분리
		[infoArr addObject:[drawData objectAtIndex:i]];
		
		// 펜 좌표 데이터
		NSData *data=[drawData objectAtIndex:i+1];
		// CGPoint의 배열로 받아온다.
		CGPoint *point = (CGPoint *)[data bytes];
		
		GLfloat*		vertexBuffer = NULL;
		NSUInteger		vertexMax = 64;
		NSUInteger		vertexCount = 0, j;
		
		for(j = 0; j < [data length] / sizeof(CGPoint)-1; ++j, ++point){
			
			CGPoint start=*point;
			CGPoint end=*(point+1);
			
			NSUInteger			count, i;
			
			// Allocate vertex array buffer
			if(vertexBuffer == NULL)
				vertexBuffer = malloc(vertexMax * 2 * sizeof(GLfloat));
			
			
			// Add points to the buffer so there are drawing points every X pixels
			count = MAX(ceilf(sqrtf((end.x - start.x) * (end.x - start.x) + (end.y - start.y) * (end.y - start.y)) / kBrushPixelStep), 1);
			
			for(i = 0; i < count; ++i) {
				if(vertexCount == vertexMax) {
					vertexMax = 2 * vertexMax;
					vertexBuffer = realloc(vertexBuffer, vertexMax * 2 * sizeof(GLfloat));
				}
				
				vertexBuffer[2 * vertexCount + 0] = start.x + (end.x - start.x) * ((GLfloat)i / (GLfloat)count);
				vertexBuffer[2 * vertexCount + 1] = start.y + (end.y - start.y) * ((GLfloat)i / (GLfloat)count);
				
				vertexCount += 1;
			}
		}
		
		
		dataArr[i/2]=vertexBuffer;
		[countArr addObject:[NSNumber numberWithInt:vertexCount]];
		
		
	}
}

//-(void)saveDrawing{
//	NSString *_fileName = [pathStr stringByAppendingPathComponent:[NSString stringWithFormat:DRAW_DATA_PATH,page]];
//	
//	[drawData writeToFile:_fileName atomically:YES];
//	
//}

@end
