//
//  playControl.h
//  NNVoicePlayer
//
//  Created by n3tr on 5/30/55 BE.
//  Copyright (c) 2555 Simpletail. All rights reserved.
//

#import <UIKit/UIKit.h>

@class playControl;

@protocol playControlDelegate <NSObject>

- (void)playButtonDidClicked:(playControl *)playControl;

@end


@interface playControl : UIImageView


@property (nonatomic, assign) id<playControlDelegate> delegate;

@end
