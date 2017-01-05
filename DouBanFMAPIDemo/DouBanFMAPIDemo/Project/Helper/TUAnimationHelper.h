//
//  TUAnimationHelper.h
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/12.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TUAnimationHelper : NSObject

+ (void)animationFade:(UIView *)view duration:(CFTimeInterval)duration;

@end


@interface CALayer (TUHelper)

- (void)tu_stopAnimation;

- (void)tu_startAnimation;

@end