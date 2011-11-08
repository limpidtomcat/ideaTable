//
//  DrawingData.h
//  IdeaTable
//
//  Created by Woo Chang ha on 11. 10. 23..
//  Copyright (c) 2011년 O.o.Z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

#define kBrushPixelStep		3

@interface DrawingData : NSObject<NSCoding>
{
	NSMutableArray		*drawData;			// 펜 그리기 전체 정보
	
	NSMutableArray		*countArr;			// 좌표 배열 크기 저장용 배열
	NSMutableArray		*infoArr;			// 펜 속성 정보 배열
	GLfloat				**dataArr;			// 좌표 정보 배열
	
}

@property (nonatomic, retain) NSMutableArray *drawData;
@property (nonatomic, retain) NSMutableArray *infoArr;
@property (nonatomic, retain) NSMutableArray *countArr;
@property (nonatomic, assign) GLfloat **dataArr;

@end
