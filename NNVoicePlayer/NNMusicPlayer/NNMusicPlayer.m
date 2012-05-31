//
//  NNMusicPlayer.m
//  NNVoicePlayer
//
//  Created by n3tr on 5/31/55 BE.
//  Copyright (c) 2555 Simpletail. All rights reserved.
//

#import "NNMusicPlayer.h"

#import <AVFoundation/AVFoundation.h>

@implementation NNMusicPlayer

@synthesize filePath = _filePath;
@synthesize player = _player;
@synthesize delegate = _delegate;




- (BOOL)playAudioWithPath:(NSString *)path
{
    if (_player) {
        [_player stop];
        _player = nil;
    }
    
    NSURL *pathURL = [NSURL fileURLWithPath:path];
    
    NSError *error = nil;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:pathURL error:&error];
    
    return error ? NO : YES;
}

- (float)currentTime
{
    return _player ? _player.currentTime : 0;
}




@end
