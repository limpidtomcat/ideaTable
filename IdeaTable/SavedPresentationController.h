//
//  SavedPresentationController.h
//  IdeaTable
//
//  Created by Woo Chang ha on 11. 11. 6..
//  Copyright (c) 2011년 O.o.Z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDFViewController.h"
#import "PaintingView.h"
#import "DrawingData.h"

@interface SavedPresentationController : NSObject
{
	MFDocumentManager *documentManaber;
	PDFViewController *pdfViewController;
	PaintingView *paintView;

	NSMutableArray *drawingDataArray;
	CGSize pdfSize;

	NSArray *mainItems;

}

@property (nonatomic, retain) MFDocumentManager *documentManager;
@property (nonatomic, retain) PDFViewController *pdfViewController;
@property (nonatomic, retain) PaintingView *paintView;
@property (nonatomic, retain) NSMutableArray *drawingDataArray;

-(id)initWithTimestamp:(NSString *)timestamp;
@end
