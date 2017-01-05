//
//  TUIBButton.h
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/17.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE//声明类是可设计的
@interface TUIBButton : UIButton

@property(nonatomic)IBInspectable CGFloat cornerRadius;
@property(nonatomic)IBInspectable UIColor *borderColor;
@property(nonatomic)IBInspectable CGFloat borderWidth;
//@property(nonatomic)IBInspectable UIColor *highlightBackgroundColor;
@property(nonatomic)IBInspectable UIImage *selectHighlightImage;
@property(nonatomic)IBInspectable UIImage *selectHighlightBackgroundImage;

@property(nonatomic)IBInspectable UIImage *disabledSelectImage;
@property(nonatomic)IBInspectable UIImage *disabledSelectBackgroundImage;

@end
