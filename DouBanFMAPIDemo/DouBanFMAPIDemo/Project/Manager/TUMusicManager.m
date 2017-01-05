//
//  TUMusicManager.m
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/11.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import "TUMusicManager.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate+TUMusicRemoteControl.h"
#import "MusicIndicator.h"

@interface TUMusicManager ()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *currentItem;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CMTimeScale timescale; // timescale
@property (nonatomic, assign) CGFloat cacheBuffer;

@end

@implementation TUMusicManager

+ (instancetype)sharedInstance {
    static TUMusicManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        // 音频会话
        AVAudioSession *session = [AVAudioSession sharedInstance];
        // 设置会话类型（播放类型、播放模式,会自动停止其他音乐的播放）
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        // 激活会话
        [session setActive:YES error:nil];
        
        // 初始化 媒体远程控制中心
        [AppDelegate configRemoteControl];
        
        // 监听中断事件（电话...或者用了别的播放器...）
        [[NSNotificationCenter defaultCenter] addObserver:sharedInstance selector:@selector(onInterruption:) name:AVAudioSessionInterruptionNotification object:nil];
        
        // 监听耳机事件（播放设备切换）
        [[NSNotificationCenter defaultCenter] addObserver:sharedInstance selector:@selector(audioRouteChangeListenerCallback:) name:AVAudioSessionRouteChangeNotification object:nil];        
    });
    return sharedInstance;
}

// 检查当前有没有耳机插入
- (BOOL)isHeadsetPluggedIn {
    AVAudioSessionRouteDescription* route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription* desc in [route outputs]) {
        if ([[desc portType] isEqualToString:AVAudioSessionPortHeadphones])
            return YES;
    }
    return NO;
}

- (void)onInterruption:(NSNotification *)notification {
    NSLog(@"onInterruption %@", notification);
    NSNumber *num = notification.userInfo[AVAudioSessionInterruptionTypeKey];
    NSNumber *optionNum = notification.userInfo[AVAudioSessionInterruptionOptionKey];
    
    if (num.unsignedIntegerValue == AVAudioSessionInterruptionTypeBegan) {
        NSLog(@"被打断了播放");
        if ([self.delegate respondsToSelector:@selector(playMusicWhenInterruptionBegin:)]) {
            [self.delegate playMusicWhenInterruptionBegin:notification.userInfo];
        }
    } else if (num.unsignedIntegerValue == AVAudioSessionInterruptionTypeEnded
               && optionNum.unsignedIntegerValue == AVAudioSessionInterruptionOptionShouldResume) {
        /**
         userInfo = {
         AVAudioSessionInterruptionOptionKey = 1;
         AVAudioSessionInterruptionTypeKey = 0;
         }
         */
        //AVAudioSessionInterruptionOptionKey
        //	AVAudioSessionInterruptionOptionShouldResume = 1
        NSLog(@"可以继续播放了");
        if ([self.delegate respondsToSelector:@selector(playMusicWhenInterruptionEnd:)]) {
            [self.delegate playMusicWhenInterruptionEnd:notification.userInfo];
        }
    }
}

// If the user pulls out he headphone jack, stop playing.
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification {
    NSDictionary *interuptionDict = notification.userInfo;
    
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    
    if ([self.delegate respondsToSelector:@selector(playMusicWhenRouteChanged:)]) {
        [self.delegate playMusicWhenRouteChanged:notification.userInfo];
    }
    
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            NSLog(@"AVAudioSessionRouteChangeReasonNewDeviceAvailable");
            NSLog(@"Headphone/Line plugged in");
            if ([self.delegate respondsToSelector:@selector(playMusicWhenHeadphonePlugged:)]) {
                [self.delegate playMusicWhenHeadphonePlugged:notification.userInfo];
            }
            break;
            
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
            NSLog(@"AVAudioSessionRouteChangeReasonOldDeviceUnavailable");
            NSLog(@"Headphone/Line was pulled. Stopping player....");
            if ([self.delegate respondsToSelector:@selector(playMusicWhenHeadphonePulled:)]) {
                [self.delegate playMusicWhenHeadphonePulled:notification.userInfo];
            }
            break;
            
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
}

+ (void)playMusicWithUrl:(NSString *)url {
    [[self sharedInstance] playMusicWithUrl:url];
}

- (BOOL)isPlaying {
    return [self.player rate] > 0;
}

- (NSString *)playingUrl {
    // get current asset
    AVAsset *currentPlayerAsset = self.player.currentItem.asset;
    // make sure the current asset is an AVURLAsset
    if (![currentPlayerAsset isKindOfClass:AVURLAsset.class]) {
        return nil;
    }
    // return the NSURL
    return [[(AVURLAsset *)currentPlayerAsset URL] absoluteString];
}

- (NSTimeInterval)currentTime {
    return CMTimeGetSeconds(self.player.currentTime);
}

- (NSTimeInterval)totalTime {
    return CMTimeGetSeconds(self.player.currentItem.duration);
}

- (void)playMusicWithUrl:(NSString *)url {
    [self stop];
    NSLog(@"playMusicWithUrl: %@", url);

    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:url] options:nil];
    self.currentItem = [AVPlayerItem playerItemWithAsset:movieAsset];

    // 每次都重新创建Player，替换replaceCurrentItemWithPlayerItem:，该方法阻塞线程
    self.player = nil;
    self.player = [AVPlayer playerWithPlayerItem:self.currentItem];
    
    [self play];
}

#pragma mark - Play Control

- (void)play {
    if ([self isPlaying]) {
        return;
    }

    [self addTimer];
    [self.player play];
    [[MusicIndicator sharedInstance] setState:NAKPlaybackIndicatorViewStatePlaying];
}

- (void)pause {
    [self removeTimer];
    [self.player pause];
    [[MusicIndicator sharedInstance] setState:NAKPlaybackIndicatorViewStatePaused];

}

- (void)stop {
    if (!self.player) {
        return;
    }
    
    // 被手动切换了
    if ([self isPlaying] && [self.delegate respondsToSelector:@selector(playMusicDidStop:)]) {
        [self.delegate playMusicDidStop:[self playingUrl]];
    }
    
//    [self pause];

    self.currentItem = nil;
    
    if (self.player.currentItem) {
        [self.player replaceCurrentItemWithPlayerItem:nil];
    }
    self.player = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[MusicIndicator sharedInstance] setState:NAKPlaybackIndicatorViewStateStopped];
}

- (void)seekToTime:(NSTimeInterval)time completionHandler:(void (^)(BOOL))completion{
    if (time < 0
        || self.player.currentItem == nil
        || self.player.status != AVPlayerItemStatusReadyToPlay) {
        if (completion) {
            completion(NO);
        }
        return;
    }
    
    [self.player.currentItem cancelPendingSeeks];
    
    if (floor(time) >= floor([self totalTime])) {
        // 用户拖到最后了
        [self stop];
    } else {
        [self.player seekToTime:CMTimeMakeWithSeconds(time, MAX(1, self.timescale)) completionHandler:^(BOOL finished) {
            if (completion) {
                completion(finished);
            }
            [self updateCurrentTimer];
        }];
    }
}

#pragma mark - Notification
- (void)prepareToPlay {
    NSLog(@"prepareToPlay");
    
    self.timescale = self.player.currentItem.duration.timescale;
    NSLog(@"timescale--%d", self.timescale);
    
    if ([self.delegate respondsToSelector:@selector(playMusicDidStartWithTotalTime:)]) {
        [self.delegate playMusicDidStartWithTotalTime:[self totalTime]];
    }
    
    [[MusicIndicator sharedInstance] setState:NAKPlaybackIndicatorViewStatePlaying];
}

- (void)playFinish {
    NSLog(@"playFinish");
    if ([self.delegate respondsToSelector:@selector(playMusicDidEnd:)]) {
        [self.delegate playMusicDidEnd:[self playingUrl]];
    }
    [[MusicIndicator sharedInstance] setState:NAKPlaybackIndicatorViewStateStopped];
}

#pragma mark - Private
/**
 *  添加定时器
 */
- (void)addTimer {
    //在新增定时器之前，先移除之前的定时器
    [self removeTimer];
    
    [self updateCurrentTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateCurrentTimer) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/**
 *  移除定时器
 */
- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}

/**
 *  触发定时器
 */
- (void)updateCurrentTimer {
    if (![self isPlaying]) return;

    if ([self.delegate respondsToSelector:@selector(playingMusicWithCurrentTime:progress:)]) {
        
        CGFloat current = [self currentTime];
        [self.delegate playingMusicWithCurrentTime:current progress:current / [self totalTime]];
    }
}

/**
 *  给AVPlayerItem添加监控
 *
 *  @param playerItem AVPlayerItem对象
 */
-(void)addObserverToPlayerItem:(AVPlayerItem *)playerItem{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinish) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    // 缓冲区空了，需要等待数据
    [playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    // 缓冲区有足够数据可以播放了
    [playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
}
-(void)removeObserverFromPlayerItem:(AVPlayerItem *)playerItem{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    [playerItem removeObserver:self forKeyPath:@"status"];
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
}
/**
 *  通过KVO监控播放器状态
 *
 *  @param keyPath 监控属性
 *  @param object  监视器
 *  @param change  状态改变
 *  @param context 上下文
 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    AVPlayerItem *playerItem = object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        if(status == AVPlayerStatusReadyToPlay){
            NSLog(@"正在播放...，Media总长度:%.2f, timescale:%d",CMTimeGetSeconds(playerItem.duration), playerItem.duration.timescale);
            [self prepareToPlay];
        }
    } else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        
        NSArray *array = playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
//        NSLog(@"共缓冲：%.2f",totalBuffer);
        // 计算视频缓冲长度
        self.cacheBuffer = totalBuffer;
    }
}

- (void)setCacheBuffer:(CGFloat)cacheBuffer{
    _cacheBuffer = cacheBuffer;
    if ([self.delegate respondsToSelector:@selector(playMusicDidLoadCacheBufferTime:)]) {
        [self.delegate playMusicDidLoadCacheBufferTime:cacheBuffer];
    }
}

- (void)setCurrentItem:(AVPlayerItem *)currentItem {
    if (_currentItem) {
        [self removeObserverFromPlayerItem:_currentItem];
    };
    _currentItem = currentItem;
    
    if (currentItem) {
        [self addObserverToPlayerItem:currentItem];
    }
}

@end
