//
//  TUMusicManager.h
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/11.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol TUMusicManagerDelegate <NSObject>

- (void)playMusicDidStartWithTotalTime:(NSTimeInterval)time;

- (void)playingMusicWithCurrentTime:(NSTimeInterval)currentTime progress:(CGFloat)progress;

- (void)playMusicDidLoadCacheBufferTime:(NSTimeInterval)time;

- (void)playMusicDidEnd:(NSString *)url;

- (void)playMusicWhenInterruptionBegin:(NSDictionary *)userInfo;

- (void)playMusicWhenInterruptionEnd:(NSDictionary *)userInfo;

/** 耳机拔掉了 Headphone/Line was pulled */
- (void)playMusicWhenHeadphonePulled:(NSDictionary *)userInfo;
/** 耳机插入了 Headphone/Line plugged in */
- (void)playMusicWhenHeadphonePlugged:(NSDictionary *)userInfo;

@optional
- (void)playMusicWhenRouteChanged:(NSDictionary *)userInfo;

/**
 *  人为的终止播放
 */
- (void)playMusicDidStop:(NSString *)url;

@end

@interface TUMusicManager : NSObject

@property (nonatomic, weak) id<TUMusicManagerDelegate> delegate;

+ (instancetype)sharedInstance;

+ (void)playMusicWithUrl:(NSString *)url;

- (void)play;

- (void)pause;

- (void)stop;

- (BOOL)isPlaying;

- (NSString *)playingUrl;

- (NSTimeInterval)currentTime;

- (NSTimeInterval)totalTime;

/// 跳转到指定位置
- (void)seekToTime:(NSTimeInterval)time completionHandler:(void(^)(BOOL finished))completion;

@end
