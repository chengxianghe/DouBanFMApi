//
//  TUIBLoopButton.m
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/17.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import "TUIBLoopButton.h"

@implementation TUIBLoopButton

- (void)setIsBackground:(BOOL)isBackground {
    _isBackground = isBackground;
}

- (void)setLoopState:(NSUInteger)loopState {
    _loopState = loopState;
    switch (loopState) {
        case TULoopButtonStateOne:
            if (_isBackground) {
                [self setBackgroundImage:_loopOneImage forState:UIControlStateNormal];
                [self setBackgroundImage:_loopOneHighlightImage forState:UIControlStateHighlighted];

            } else {
                [self setImage:_loopOneImage forState:UIControlStateNormal];
                [self setImage:_loopOneHighlightImage forState:UIControlStateHighlighted];
            }
            break;
        case TULoopButtonStateAll:
            if (_isBackground) {
                [self setBackgroundImage:_loopAllImage forState:UIControlStateNormal];
                [self setBackgroundImage:_loopAllHighlightImage forState:UIControlStateHighlighted];
                
            } else {
                [self setImage:_loopAllImage forState:UIControlStateNormal];
                [self setImage:_loopAllHighlightImage forState:UIControlStateHighlighted];
            }
            break;
        case TULoopButtonStateShuffle:
            if (_isBackground) {
                [self setBackgroundImage:_loopShuffleImage forState:UIControlStateNormal];
                [self setBackgroundImage:_loopShuffleHighlightImage forState:UIControlStateHighlighted];
                
            } else {
                [self setImage:_loopShuffleImage forState:UIControlStateNormal];
                [self setImage:_loopShuffleHighlightImage forState:UIControlStateHighlighted];
            }
            break;
        default:
            break;
    }
}

- (void)setLoopOneImage:(UIImage *)loopOneImage {
    _loopOneImage = loopOneImage;
}

- (void)setLoopOneHighlightImage:(UIImage *)loopOneHighlightImage {
    _loopOneHighlightImage = loopOneHighlightImage;
}

- (void)setLoopAllImage:(UIImage *)loopAllImage {
    _loopAllImage = loopAllImage;
}

- (void)setLoopAllHighlightImage:(UIImage *)loopAllHighlightImage {
    _loopAllHighlightImage = loopAllHighlightImage;
}

- (void)setLoopShuffleImage:(UIImage *)loopShuffleImage {
    _loopShuffleImage = loopShuffleImage;
}

- (void)setLoopShuffleHighlightImage:(UIImage *)loopShuffleHighlightImage {
    _loopShuffleHighlightImage = loopShuffleHighlightImage;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
