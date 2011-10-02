//
//  PDFViewController.h
//  IdeaTable
//
//  Created by Woo Jeff on 11. 9. 30..
//  Copyright 2011년 O.o.Z. All rights reserved.
//



#import	"FastPdfKit/FastPdfKit.h"
#import "ClientObject.h"
@interface PDFViewController : ReaderViewController
{
	BOOL isMaster;
	ClientObject *clientObject;
}
@property (nonatomic, assign) BOOL isMaster;
@property (nonatomic, retain) ClientObject *clientObject;
@end
