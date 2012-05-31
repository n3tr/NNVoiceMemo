//
//  VoiceRecorderViewController.m
//  NNVoicePlayer
//
//  Created by n3tr on 5/31/55 BE.
//  Copyright (c) 2555 Simpletail. All rights reserved.
//

#import "VoiceRecorderViewController.h"

#import <AVFoundation/AVFoundation.h>
#import "NNItem.h"

#import "AppDelegate.h"
@interface VoiceRecorderViewController ()
{
    AVAudioRecorder *audioRecorder;
    NSString *filePath;
    NSTimer *loopTimer;
}
-(void)dismissRecorder:(id)sender;
- (void)updateDuration;

- (void)startRecording;
- (void)stopRecording;

@end

@implementation VoiceRecorderViewController
@synthesize recordBtn = _recordBtn;
@synthesize durationLabel = _durationLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    AppDelegate *appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    
    NSURL *docURL = appDel.applicationDocumentsDirectory;
   
    
    NSURL *voiceDir = [docURL URLByAppendingPathComponent:@"userVoice" isDirectory:YES];
    
    
    NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"%f",timestamp];
    
    NSURL *path = [voiceDir URLByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
    NSLog(@"%@",path);
 
    
    NSError *error = nil;
    
    audioRecorder = [[AVAudioRecorder alloc] initWithURL:path settings:nil error:&error];
    
    if (error) {
        NSLog(@"%@",[error localizedDescription]);
    }
    audioRecorder.delegate = self;
    filePath = [path absoluteString];
     NSLog(@"%@",filePath);
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissRecorder:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    _durationLabel.text = @"0:00";

}

- (void)viewDidUnload
{
    [self setRecordBtn:nil];
    [self setDurationLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)recordBtnClicked:(id)sender {
    if (!audioRecorder.recording) {
        [_recordBtn setTitle:@"Stop" forState:UIControlStateNormal];
        
        loopTimer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:0.5 target:self selector:@selector(updateDuration) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:loopTimer forMode:NSDefaultRunLoopMode];
        
        [self startRecording];

    }else {
        [self stopRecording];
    }
}

- (void)dismissRecorder:(id)sender
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)updateDuration
{
    
    float current = audioRecorder.currentTime;
    
    int remainMin = (int)current / 60;
    int remainSec = (int)current % 60;
    
    
    NSString *formatString;
    if (remainSec < 10) {
        formatString = @"%d:0%d";
    }else {
        formatString = @"%d:%d";
    }
    
    NSLog(formatString,remainMin,remainSec);
    
    _durationLabel.text = [NSString stringWithFormat:formatString,remainMin,remainSec];
}






#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]


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
    
    
    
    // Create a new dated file
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/userVoice/",DOCUMENTS_FOLDER] isDirectory:nil]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"%@/userVoice/",DOCUMENTS_FOLDER] withIntermediateDirectories:YES attributes:nil error:nil];
    }
   
    filePath = [NSString stringWithFormat:@"%@/userVoice/%f.caf", DOCUMENTS_FOLDER, now] ;
    
    
    
    NSURL *url = [NSURL fileURLWithPath:filePath];
    err = nil;
    audioRecorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&err];
    if(!audioRecorder){
        NSLog(@"recorder: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
                                   message: [err localizedDescription]
                                  delegate: nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //prepare to record
    [audioRecorder setDelegate:self];
    [audioRecorder prepareToRecord];
    audioRecorder.meteringEnabled = YES;
    
    BOOL audioHWAvailable = audioSession.inputIsAvailable;
    if (! audioHWAvailable) {
        UIAlertView *cantRecordAlert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
                                   message: @"Audio input hardware not available"
                                  delegate: nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        [cantRecordAlert show];
    
        return;
    }
    
    // start recording
    [audioRecorder recordForDuration:(NSTimeInterval) 10];
    
}

- (void) stopRecording{
    
    [audioRecorder stop];
    
    NSURL *url = [NSURL fileURLWithPath: filePath];
    NSError *err = nil;
    NSData *audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:&err];
    if(!audioData)
        NSLog(@"audio data: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
//    [editedObject setValue:[NSData dataWithContentsOfURL:url] forKey:editedFieldKey];   
    
    //[recorder deleteRecording];
    
    
//    NSFileManager *fm = [NSFileManager defaultManager];
    
//    err = nil;
//    [fm removeItemAtPath:[url path] error:&err];
//    if(err)
//        NSLog(@"File Manager: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
    
    
    
    
    
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *) aRecorder successfully:(BOOL)flag
{
    
    NSLog (@"audioRecorderDidFinishRecording:successfully:");
    // your actions here
    [self stopRecording];
    [loopTimer invalidate];
    AppDelegate *appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    NNItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"NNItem" inManagedObjectContext:appDel.managedObjectContext];
    item.type = @"voice";
    item.created_date = [NSDate date];
    item.title = @"audio";
    item.filePath = [audioRecorder.url path];
    [appDel saveContext];
    [self.navigationController dismissModalViewControllerAnimated:YES];
    
}



@end
