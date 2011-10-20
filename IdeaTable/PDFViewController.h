//
//  PDFViewController.h
//  IdeaTable
//
//  Created by Woo Jeff on 11. 9. 30..
//  Copyright 2011년 O.o.Z. All rights reserved.
//



#import	"FastPdfKit/FastPdfKit.h"
#import "ClientObject.h"
@interface PDFViewController : MFDocumentViewController<MFDocumentOverlayDataSource, MFDocumentViewControllerDelegate>
{
	BOOL isMaster;
	ClientObject *clientObject;
	UIButton *closeBtn;
	
	id waitingViewDelegate;
}
@property (nonatomic, assign) BOOL isMaster;
@property (nonatomic, retain) ClientObject *clientObject;
@property (nonatomic ,assign) id waitingViewDelegate;
@end
