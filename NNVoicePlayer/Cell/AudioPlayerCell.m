//
//  AudioPlayerCell.m
//  NNVoicePlayer
//
//  Created by n3tr on 5/30/55 BE.
//  Copyright (c) 2555 Simpletail. All rights reserved.
//

#import "AudioPlayerCell.h"
#import "playControl.h"

@interface AudioPlayerCell()

- (void)sliderTouchDown:(id)sender;
- (void)sliderTouchUpInside:(id)sender;



@end

@implementation AudioPlayerCell
@synthesize playControlImageView;
@synthesize stopControl;
@synthesize sliderTiming;
@synthesize rowNumber;
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    sliderTiming.value = 0;
    playControlImageView.image = [UIImage imageNamed:@"play_icon.png"];
    playControlImageView.delegate = self;
    playControlImageView.userInteractionEnabled = YES;
    
    stopControl.image = [UIImage imageNamed:@"stop_icon.png"];
    stopControl.delegate = self;
    stopControl.userInteractionEnabled = YES;
    
    
    [sliderTiming addTarget:self action:@selector(sliderTouchDown:) forControlEvents:UIControlEventTouchDown];
    
    [sliderTiming addTarget:self action:@selector(sliderTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];

    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)sliderTouchDown:(id)sender
{
    if ([delegate respondsToSelector:@selector(audioCellStartScrollInRowNumber:)]) {
        [delegate audioCellStartScrollInRowNumber:rowNumber];
    }
}

- (void)sliderTouchUpInside:(id)sender
{
    if ([delegate respondsToSelector:@selector(audioCellSliderInRowNumber:DidMoveTo:)]) {
        [delegate audioCellSliderInRowNumber:rowNumber DidMoveTo:sliderTiming.value];
    }
}


#pragma mark - Delegate

- (void)playButtonDidClicked:(playControl*)playControl
{
    if ([delegate respondsToSelector:@selector(audioCellPlayButtonDidClickedInRowNumber:)]) {
        if (playControl == playControlImageView) {
            [delegate audioCellPlayButtonDidClickedInRowNumber:rowNumber];
        }else{
            [delegate audioCellStopButtonDidClickedInRowNumber:rowNumber];
        }
    }
}

@end
