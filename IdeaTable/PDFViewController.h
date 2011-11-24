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

@interface PDFViewController : MFDocumentViewController<UIGestureRecognizerDelegate>
{
	BOOL isToolbarHidden;
	
	UIToolbar *toolBar;
	UIScrollView *scrollView;

//    CGPoint longPressXY;
}

@property (nonatomic, readonly) UIToolbar *toolBar;
//@property (nonatomic, assign) CGPoint longPressXY;

-(id)initWithDocumentManager:(MFDocumentManager *)aDocumentManager;
-(void)setScrollLock:(BOOL)isLocked;


//-(void)showToolbar;
//-(void)hideToolbar;

@end
