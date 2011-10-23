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
	BOOL isDrawing;
	UIButton *closeBtn;
	UIButton *drawBtn;
	

	id presentationDelegate;
}

@property (nonatomic, assign) id presentationDelegate;

-(id)initWithDocumentManager:(MFDocumentManager *)aDocumentManager presentationDelegate:(id)_presentationDelegate;
-(void)setScrollLock:(BOOL)isLocked;

@end
