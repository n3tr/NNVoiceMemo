//
//  AudioPlayerCell.h
//  NNVoicePlayer
//
//  Created by n3tr on 5/30/55 BE.
//  Copyright (c) 2555 Simpletail. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "playControl.h"


@protocol AudioPlayerCellDelegate <NSObject>

- (void)audioCellPlayButtonDidClickedInRowNumber:(NSInteger)rowNum;
- (void)audioCellStopButtonDidClickedInRowNumber:(NSInteger)rowNum;
- (void)audioCellStartScrollInRowNumber:(NSInteger)rowNum;
- (void)audioCellSliderInRowNumber:(NSInteger)rowNum DidMoveTo:(float)value;

@end

@interface AudioPlayerCell : UITableViewCell
<playControlDelegate>

@property (nonatomic, assign) NSInteger rowNumber;
@property (weak, nonatomic) IBOutlet playControl *playControlImageView;
@property (weak, nonatomic) IBOutlet playControl *stopControl;
@property (weak, nonatomic) IBOutlet UISlider *sliderTiming;

@property (nonatomic, assign) id<AudioPlayerCellDelegate> delegate;

@end
