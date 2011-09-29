//
//  IdeaTableAppDelegate.h
//  IdeaTable
//
//  Created by Woo Jeff on 11. 9. 27..
//  Copyright 2011년 O.o.Z. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IdeaTableViewController;

@interface IdeaTableAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet IdeaTableViewController *viewController;

@end
