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

@interface PresentationController : NSObject<FPKOverlayViewDataSource, MFDocumentViewControllerDelegate>
{
	BOOL isMaster;
	ClientObject *clientObject;
	MFDocumentManager *documentManaber;
	PDFViewController *pdfViewController;
	PaintingView *paintView;
	NSMutableArray *drawingDataArray;
	CGSize pdfSize;
	
	id waitingViewDelegate;
}

@property (nonatomic, assign) BOOL isMaster;
@property (nonatomic, retain) ClientObject *clientObject;
@property (nonatomic, retain) MFDocumentManager *documentManager;
@property (nonatomic, retain) PDFViewController *pdfViewController;
@property (nonatomic, retain) PaintingView *paintView;
@property (nonatomic, retain) NSMutableArray *drawingDataArray;
@property (nonatomic, assign) id waitingViewDelegate;

-(id)initWithPdfUrl:(NSURL *)url;
-(void)setPage:(NSUInteger)page;
@end
