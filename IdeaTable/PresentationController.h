//
//  PresentationController.h
//  IdeaTable
//
//  Created by Woo Chang ha on 11. 10. 23..
//  Copyright (c) 2011년 O.o.Z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDFViewController.h"
#import "PaintingView.h"
#import "DrawingData.h"
#import "AudioRecordController.h"
#import "TableInfo.h"

@interface PresentationController : NSObject<FPKOverlayViewDataSource, MFDocumentViewControllerDelegate>
{
	BOOL isMaster;
	BOOL drawLock;

	TableInfo *tableInfo;

	ClientObject *clientObject;
	MFDocumentManager *documentManaber;
	PDFViewController *pdfViewController;
	PaintingView *paintView;

	AudioRecordController *audioRecordController;

	NSMutableArray *drawingDataArray;
	CGSize pdfSize;

//	NSString *dataFileName;

	NSArray *userList;

	id waitingViewDelegate;

	NSArray *mainItems;
	NSArray *drawingItems;

}

@property (nonatomic, retain) TableInfo *tableInfo;
@property (nonatomic, retain) ClientObject *clientObject;
@property (nonatomic, retain) MFDocumentManager *documentManager;
@property (nonatomic, retain) PDFViewController *pdfViewController;
@property (nonatomic, retain) PaintingView *paintView;
@property (nonatomic, retain) NSMutableArray *drawingDataArray;
@property (nonatomic, retain) NSArray *userList;
@property (nonatomic, assign) id waitingViewDelegate;

-(id)initWithPdfUrl:(NSURL *)url isMaster:(BOOL)_isMaster tableInfo:(TableInfo *)_tableInfo;
-(void)setPage:(NSUInteger)page;
@end
