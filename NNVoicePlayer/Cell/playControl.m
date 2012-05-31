//
//  playControl.m
//  NNVoicePlayer
//
//  Created by n3tr on 5/30/55 BE.
//  Copyright (c) 2555 Simpletail. All rights reserved.
//

#import "playControl.h"

@implementation playControl
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([delegate respondsToSelector:@selector(playButtonDidClicked:)]) {
        [delegate playButtonDidClicked:self];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
