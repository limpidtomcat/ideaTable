//
//  AudioRecordController.h
//  IdeaTable
//
//  Created by Woo Chang ha on 11. 11. 3..
//  Copyright (c) 2011년 O.o.Z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h> 

@interface AudioRecordController : NSObject
{
	
	NSString *recordFile;
	AVAudioRecorder *recorder;
}


@property (nonatomic, retain) NSString *recordFile;
- (void) startRecording;
- (void) stopRecording;
-(BOOL)saveAudioFile;

@end
