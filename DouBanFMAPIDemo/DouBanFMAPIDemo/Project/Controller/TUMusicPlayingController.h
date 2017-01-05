//
//  TUMusicPlayingController.h
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/10.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TUMusicLikeRequestHelper.h"

@class TUDouBanMusicModel;

@interface TUMusicPlayingController : UIViewController

+ (instancetype)sharedInstance;

+ (instancetype)musicControllerWithMusicList:(NSArray<__kindof TUDouBanMusicModel *> *)musicList
                                currentIndex:(NSUInteger)currentIndex;

+ (void)onPlay;
+ (void)onPause;
+ (void)onPrevious;
+ (void)onNext;
+ (void)changeLikeWithCompletion:(TUMusicLikeBlock)completion;
+ (TUDouBanMusicModel *)playingModel;

@end
