//
//  AppDelegate+TUMusicRemoteControl.m
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/27.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import "AppDelegate+TUMusicRemoteControl.h"
#import "TUMusicPlayingController.h"
#import "TUDouBanMusicModel.h"
#import "TUMusicManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AudioToolbox/AudioToolbox.h>

@implementation AppDelegate (TUMusicRemoteControl)

// 初始化
+ (void)configRemoteControl {
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.1")) {
        /**
         MPRemoteCommandCenter is what you need. You can set the dislikeCommand, likeCommand and bookmarkCommand properties to perform the actions you need, and override the localizedTitle properties of those commands to change the text. Unfortunately, as can be seen in the screenshot, you can't customise the icons of the commands.
         */
        MPRemoteCommandCenter *rcc = [MPRemoteCommandCenter sharedCommandCenter];
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        // 播放、暂停、下一曲、上一曲（用dislikeCommand代替展示）
        MPRemoteCommand *playCommand = [rcc playCommand];
        [playCommand setEnabled:YES];
        [playCommand addTarget:appDelegate action:@selector(playEvent:)];
        
        MPRemoteCommand *pauseCommand = [rcc pauseCommand];
        [pauseCommand setEnabled:YES];
        [pauseCommand addTarget:appDelegate action:@selector(pauseEvent:)];
        
        MPRemoteCommand *nextCommand = [rcc nextTrackCommand];
        [nextCommand setEnabled:YES];
        [nextCommand addTarget:appDelegate action:@selector(nextCommandEvent:)];
        
        MPFeedbackCommand *likeCommand = [MPRemoteCommandCenter sharedCommandCenter].likeCommand;
        [likeCommand setEnabled:YES];
        [likeCommand addTarget:appDelegate action:@selector(likeEvent:)];
        [likeCommand setLocalizedTitle:@"红心"];
        [likeCommand setLocalizedShortTitle:@"红心"];
        
        MPFeedbackCommand *dislikeCommand = [MPRemoteCommandCenter sharedCommandCenter].dislikeCommand;
        [dislikeCommand addTarget:appDelegate action:@selector(previousCommandEvent:)];
        [dislikeCommand setEnabled:YES];
        [dislikeCommand setLocalizedTitle:@"上一曲"];
        [dislikeCommand setLocalizedShortTitle:@"上一曲"];
        
        MPFeedbackCommand *bookmarkCommand = [MPRemoteCommandCenter sharedCommandCenter].bookmarkCommand;
        [bookmarkCommand setEnabled:YES];
        [bookmarkCommand addTarget:appDelegate action:@selector(bookmarkEvent:)];
        [bookmarkCommand setLocalizedTitle:@"离线单曲"];
        [bookmarkCommand setLocalizedShortTitle:@"离线单曲"];
        
        // 设置前进和倒退 和下一曲冲突
        //        MPSkipIntervalCommand *skipBackwardIntervalCommand = [rcc skipBackwardCommand];
        //        [skipBackwardIntervalCommand setEnabled:YES];
        //        [skipBackwardIntervalCommand addTarget:self action:@selector(skipBackwardEvent:)];
        //        skipBackwardIntervalCommand.preferredIntervals = @[@(42)];  // 设置快进时间
        //
        //        MPSkipIntervalCommand *skipForwardIntervalCommand = [rcc skipForwardCommand];
        //        skipForwardIntervalCommand.preferredIntervals = @[@(42)];  // 倒退时间 最大 99
        //        [skipForwardIntervalCommand setEnabled:YES];
        //        [skipForwardIntervalCommand addTarget:self action:@selector(skipForwardEvent:)];
        
        
    }
}

#pragma mark - RemoteControl
#pragma mark -
+ (void)refreshPlayMusicRemoteControlEventsWithModel:(TUDouBanMusicModel *)model isPlay:(BOOL)isPlay {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate playMusicRemoteControlEventsWithModel:model isPlay:isPlay];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)playMusicRemoteControlEventsWithModel:(TUDouBanMusicModel *)model isPlay:(BOOL)isPlay {
    // 开始监听远程控制事件
    // 成为第一响应者（必备条件）
    if (![self isFirstResponder]) {
        [self becomeFirstResponder];
        // 开始监控
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    }
    
    // 初始化播放信息
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    // 专辑名称
    info[MPMediaItemPropertyAlbumTitle] = model.albumtitle;
    // 歌手
    info[MPMediaItemPropertyArtist] = model.artist;
    // 歌曲名称
    info[MPMediaItemPropertyTitle] = model.title;
    // 设置图片
    if (model.image) {
        info[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithImage:model.image];
    }
    // 设置持续时间（歌曲的总时间）
    info[MPMediaItemPropertyPlaybackDuration] = @([[TUMusicManager sharedInstance] totalTime]);
    // 设置当前播放进度
    info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = @([[TUMusicManager sharedInstance] currentTime]);
    
    // 播放速度
    info[MPNowPlayingInfoPropertyPlaybackRate] = isPlay ? @1.0 : @0.0;
    
    // 播放信息中心
    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
    
    // 切换播放信息
    center.nowPlayingInfo = info;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.1")) {
        MPFeedbackCommand *likeCommand = [MPRemoteCommandCenter sharedCommandCenter].likeCommand;
        
        likeCommand.active = model.like;
        likeCommand.localizedTitle = model.like ? @"取消红心" : @"红心";
        likeCommand.localizedShortTitle = model.like ? @"取消红心" : @"红心";
    }
    
}


- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    //    event.type; // 事件类型
    //    event.subtype; // 事件的子类型
    //    UIEventSubtypeRemoteControlPlay                 = 100,
    //    UIEventSubtypeRemoteControlPause                = 101,
    //    UIEventSubtypeRemoteControlStop                 = 102,
    //    UIEventSubtypeRemoteControlTogglePlayPause      = 103,
    //    UIEventSubtypeRemoteControlNextTrack            = 104,
    //    UIEventSubtypeRemoteControlPreviousTrack        = 105,
    //    UIEventSubtypeRemoteControlBeginSeekingBackward = 106,
    //    UIEventSubtypeRemoteControlEndSeekingBackward   = 107,
    //    UIEventSubtypeRemoteControlBeginSeekingForward  = 108,
    //    UIEventSubtypeRemoteControlEndSeekingForward    = 109,
    
    // >= 7.1 会采用MPRemoteCommandCenter 这里就不用处理了
    if (SYSTEM_VERSION_LESS_THAN(@"7.1")) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:
                [TUMusicPlayingController onPlay];
                break;
            case UIEventSubtypeRemoteControlPause:
                [TUMusicPlayingController onPause];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                [TUMusicPlayingController onNext];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                [TUMusicPlayingController onPrevious];
                
            default:
                break;
        }
    }
}

- (void)playEvent:(MPRemoteCommand *)command {
    [TUMusicPlayingController onPlay];
}

- (void)pauseEvent:(MPRemoteCommand *)command {
    [TUMusicPlayingController onPause];
}

- (void)nextCommandEvent:(MPRemoteCommand *)command {
    [TUMusicPlayingController onNext];
    NSLog(@"下一曲");
}

- (void)previousCommandEvent:(MPRemoteCommand *)command {
    [TUMusicPlayingController onPrevious];
    NSLog(@"上一曲");
}

- (void)likeEvent:(MPFeedbackCommandEvent *)feedbackEvent {
    MPFeedbackCommand *likeCommand = [MPRemoteCommandCenter sharedCommandCenter].likeCommand;
    [TUMusicPlayingController changeLikeWithCompletion:^(TUDouBanUserChannelRequest *request, BOOL isSuccess) {
        if (isSuccess && [request.sid isEqualToString:[TUMusicPlayingController playingModel].sid]) {
            likeCommand.active = !likeCommand.active;
            likeCommand.localizedTitle = likeCommand.active ? @"取消红心" : @"红心";
            likeCommand.localizedShortTitle = likeCommand.active ? @"取消红心" : @"红心";
        }
    }];
    
    NSLog(@"Like");
}

- (void)bookmarkEvent:(MPFeedbackCommandEvent *)feedbackEvent {
    MPFeedbackCommand *bookmarkCommand = [MPRemoteCommandCenter sharedCommandCenter].bookmarkCommand;
    bookmarkCommand.active = !bookmarkCommand.active;
    NSLog(@"Bookmark");
}

//- (void)skipBackwardEvent: (MPSkipIntervalCommandEvent *)skipEvent {
//    NSLog(@"Skip backward by %f", skipEvent.interval);
//}
//- (void)skipForwardEvent: (MPSkipIntervalCommandEvent *)skipEvent{
//    NSLog(@"Skip forward by %f", skipEvent.interval);
//}

@end
