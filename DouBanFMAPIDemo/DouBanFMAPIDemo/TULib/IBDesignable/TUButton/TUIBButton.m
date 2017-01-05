//
//  TUIBButton.m
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/17.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import "TUIBButton.h"

@implementation TUIBButton

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius != 0;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    self.layer.borderWidth = borderWidth;
    
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setSelectHighlightImage:(UIImage *)selectHighlightImage {
    _selectHighlightImage = selectHighlightImage;
    [self setImage:selectHighlightImage forState:UIControlStateSelected | UIControlStateHighlighted];
}

- (void)setSelectHighlightBackgroundImage:(UIImage *)selectHighlightBackgroundImage {
    _selectHighlightBackgroundImage = selectHighlightBackgroundImage;
    [self setBackgroundImage:selectHighlightBackgroundImage forState:UIControlStateSelected | UIControlStateHighlighted];
}

- (void)setDisabledSelectImage:(UIImage *)disabledSelectImage {
    _disabledSelectImage = disabledSelectImage;
    [self setImage:disabledSelectImage forState:UIControlStateSelected | UIControlStateDisabled];
}

- (void)setDisabledSelectBackgroundImage:(UIImage *)disabledSelectBackgroundImage {
    _disabledSelectBackgroundImage = disabledSelectBackgroundImage;
    [self setBackgroundImage:disabledSelectBackgroundImage forState:UIControlStateSelected | UIControlStateDisabled];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
