//
//  VoiceRecorderViewController.h
//  NNVoicePlayer
//
//  Created by n3tr on 5/31/55 BE.
//  Copyright (c) 2555 Simpletail. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>

@interface VoiceRecorderViewController : UIViewController
<AVAudioRecorderDelegate>
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
- (IBAction)recordBtnClicked:(id)sender;

@end
