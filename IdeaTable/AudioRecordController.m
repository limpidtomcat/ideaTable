//
//  AudioRecordController.m
//  IdeaTable
//
//  Created by Woo Chang ha on 11. 11. 3..
//  Copyright (c) 2011년 O.o.Z. All rights reserved.
//

#import "AudioRecordController.h"

@implementation AudioRecordController
@synthesize  recordFile;

- (void) startRecording{
    
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
    if(err){
        NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        return;
    }
    [audioSession setActive:YES error:&err];
    err = nil;
    if(err){
        NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        return;
    }
    
	
	
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey]; 
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    [recordSetting setValue :[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    
    
	NSString *tempPath=NSTemporaryDirectory();
	
    // Create a new dated file
//    NSDate *now = [NSDate dateWithTimeIntervalSinceNow:0];
//	NSString *caldate = [now description];
	NSString *file=[tempPath stringByAppendingPathComponent:recordFile];
    
    NSURL *url = [NSURL fileURLWithPath:file];
    err = nil;
    recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&err];
    if(!recorder){
        NSLog(@"recorder: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Warning" message: [err localizedDescription]delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];[alert show];
        [alert release];
        return;
    }
    
    //prepare to record
//    [recorder setDelegate:self];
    [recorder prepareToRecord];
    recorder.meteringEnabled = YES;
    
    BOOL audioHWAvailable = audioSession.inputIsAvailable;
    if (! audioHWAvailable) {
        UIAlertView *cantRecordAlert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
								   message: @"Audio input hardware not available"
								  delegate: nil
						 cancelButtonTitle:@"OK"
						 otherButtonTitles:nil];
        [cantRecordAlert show];
        [cantRecordAlert release]; 
        return;
    }
    
//    [recorder recordForDuration:(NSTimeInterval) 10];
	[recorder record];
    
}

- (void) stopRecording{
    
    [recorder stop];
    
}

-(BOOL)saveAudioFile{
	NSString *tempPath=NSTemporaryDirectory();
	NSString *tempFile=[tempPath stringByAppendingPathComponent:recordFile];
	
	NSString *documentPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *savePath=[documentPath stringByAppendingPathComponent:@"SavedTable"];
	NSString *documentFile=[savePath stringByAppendingPathComponent:recordFile];

	NSError *error=nil;

	[[NSFileManager defaultManager] moveItemAtPath:tempFile toPath:documentFile error:&error];
	if(error){
		return NO;
	}
	return YES;
}

-(void)dealloc{
	[recordFile release];
	[super dealloc];
}

@end
