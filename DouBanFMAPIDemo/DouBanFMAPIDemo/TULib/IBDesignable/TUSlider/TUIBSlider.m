//
//  TUIBSlider.m
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/17.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import "TUIBSlider.h"

@implementation TUIBSlider

- (void)setIB_ThumbImage:(UIImage *)IB_ThumbImage {
    _IB_ThumbImage = IB_ThumbImage;
    [self setThumbImage:IB_ThumbImage forState:UIControlStateNormal];
}

- (void)setIB_MaximumTrackImage:(UIImage *)IB_MaximumTrackImage {
    _IB_MaximumTrackImage = IB_MaximumTrackImage;
    [self setMaximumTrackImage:IB_MaximumTrackImage forState:UIControlStateNormal];
}

- (void)setIB_MinimumValueImage:(UIImage *)IB_MinimumValueImage {
    _IB_MinimumTrackImage = IB_MinimumValueImage;
    [self setMinimumTrackImage:IB_MinimumValueImage forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
