//
//  TUIBSlider.h
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/17.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE//声明类是可设计的
@interface TUIBSlider : UISlider

@property(nonatomic)IBInspectable UIImage *IB_ThumbImage;
@property(nonatomic)IBInspectable UIImage *IB_MinimumTrackImage;
@property(nonatomic)IBInspectable UIImage *IB_MaximumTrackImage;

@end