//
//  AppDelegate+TUMusicRemoteControl.h
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/27.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import "AppDelegate.h"

@class TUDouBanMusicModel, MPRemoteCommand, MPFeedbackCommandEvent;

@interface AppDelegate (TUMusicRemoteControl)

// 初始化
+ (void)configRemoteControl;

+ (void)refreshPlayMusicRemoteControlEventsWithModel:(TUDouBanMusicModel *)model isPlay:(BOOL)isPlay;

- (void)playEvent:(MPRemoteCommand *)command;
- (void)pauseEvent:(MPRemoteCommand *)command;
- (void)nextCommandEvent:(MPRemoteCommand *)command;
- (void)previousCommandEvent:(MPRemoteCommand *)command;
- (void)likeEvent:(MPFeedbackCommandEvent *)feedbackEvent;
- (void)bookmarkEvent:(MPFeedbackCommandEvent *)feedbackEvent;

@end
