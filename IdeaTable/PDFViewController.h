//
//  PDFViewController.h
//  IdeaTable
//
//  Created by Woo Jeff on 11. 9. 30..
//  Copyright 2011년 O.o.Z. All rights reserved.
//



#import	"FastPdfKit/FastPdfKit.h"
#import "ClientObject.h"
#import "PaintingView.h"

@interface PDFViewController : MFDocumentViewController<MFDocumentOverlayDataSource, MFDocumentViewControllerDelegate, FPKOverlayViewDataSource>
{
	BOOL isMaster;
	BOOL isDrawing;
	ClientObject *clientObject;
	UIButton *closeBtn;
	UIButton *drawBtn;
	PaintingView *paintView;
	NSMutableArray *drawingDataArray;
	
	id waitingViewDelegate;
}
@property (nonatomic, assign) BOOL isMaster;
@property (nonatomic, retain) ClientObject *clientObject;
@property (nonatomic ,assign) id waitingViewDelegate;
@end
