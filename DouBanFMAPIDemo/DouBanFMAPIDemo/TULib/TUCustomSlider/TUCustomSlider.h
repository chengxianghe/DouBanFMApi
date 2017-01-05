//
//  TUCustomSlider.h
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/17.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TUCustomSliderDelegate <NSObject>

// 点击view后返回的value
- (void)touchView:(float)value;
- (void)progressAction:(CGFloat)progress;

@end

@interface TUCustomSlider : UIView

@property (nonatomic, strong) UIImageView *thumbView; // 滑块
@property (nonatomic, weak) id<TUCustomSliderDelegate> delegate;

/**
 *  缓冲的进度
 */
@property (nonatomic, assign) CGFloat cacheProgress; //
@property (nonatomic, assign) CGFloat value;     //
@property (nonatomic, assign) CGFloat maximumValue;     //
@property (nonatomic, assign) CGFloat minimumValue;     //
@property (nonatomic, assign) BOOL highlighted;     //
@property (nonatomic, assign) BOOL canTap;     //


@end
