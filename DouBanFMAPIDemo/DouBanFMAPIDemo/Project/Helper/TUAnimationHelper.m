//
//  TUAnimationHelper.m
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/12.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import "TUAnimationHelper.h"

@implementation TUAnimationHelper

+ (void)animationFade:(UIView *)view duration:(CFTimeInterval)duration {
    CATransition *animation = [CATransition animation];
    [animation setDuration:duration];
    [animation setType:kCATransitionFade];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [animation setRemovedOnCompletion:YES];
    
    [view.layer addAnimation:animation forKey:nil];
}


@end

@implementation CALayer (TUHelper)

- (void)tu_stopAnimation {
    if (self.speed == 0.0) { return; }
    CFTimeInterval pausedTime = [self convertTime:CACurrentMediaTime() fromLayer:nil];
    self.speed = 0.0;
    self.timeOffset = pausedTime;
}

- (void)tu_startAnimation {
    if (self.speed != 1.0) { return; }
    self.speed = 1.0;
    self.beginTime = 0.0;
    CFTimeInterval pausedTime = [self timeOffset];
    CFTimeInterval timeSincePause = [self convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.beginTime = timeSincePause;
}

@end