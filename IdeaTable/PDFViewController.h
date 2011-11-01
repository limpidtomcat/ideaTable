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
	BOOL isToolbarHidden;
	BOOL isClientDrawLocked;
	BOOL isLocked;
	UIButton *closeBtn;
	UIButton *drawBtn;
	
	UIToolbar *toolBar;
	UIScrollView *scrollView;
	id presentationDelegate;
}

@property (nonatomic, assign) id presentationDelegate;

-(id)initWithDocumentManager:(MFDocumentManager *)aDocumentManager presentationDelegate:(id)_presentationDelegate;
-(void)setScrollLock:(BOOL)isLocked;


-(void)showToolbar;
-(void)hideToolbar;
-(void)drawOff;

@end
