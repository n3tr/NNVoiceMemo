//
//  NNMusicPlayer.h
//  NNVoicePlayer
//
//  Created by n3tr on 5/31/55 BE.
//  Copyright (c) 2555 Simpletail. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class NNMusicPlayer;

@protocol NNMusicPlayerDelegate <NSObject>

- (void)MusicPlayerDidPlay:(NNMusicPlayer *)musicPlayer;
- (void)MusicPlayerDidStop:(NNMusicPlayer *)musicPlayer;
- (void)MusicPlayerDidPause:(NNMusicPlayer *)musicPlayer;


@end

@interface NNMusicPlayer : NSObject
<AVAudioPlayerDelegate>


@property (nonatomic, retain) AVAudioPlayer *player;

@property (nonatomic, retain) NSString *filePath;
@property (nonatomic, assign) id<NNMusicPlayerDelegate> delegate;

- (BOOL)playAudioWithPath:(NSString *)path;

@end
