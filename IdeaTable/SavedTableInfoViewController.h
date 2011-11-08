//
//  SavedTableViewController.h
//  IdeaTable
//
//  Created by Woo Chang ha on 11. 11. 5..
//  Copyright (c) 2011년 O.o.Z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SavedPresentationController.h"
#import <AVFoundation/AVAudioPlayer.h>
@interface SavedTableInfoViewController : UITableViewController
{
	NSString *key;
	NSDictionary *tableData;
	SavedPresentationController *presentationController;
	AVAudioPlayer *audioPlayer;
}

-(id)initWithStyle:(UITableViewStyle)style key:(NSString *)_key tableData:(NSDictionary *)_data;
@end
