//
//  TUDouBanHelper.h
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/10.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TUDouBanChannelModel, TUDouBanMusicModel;

@interface TUDouBanDataHelper : NSObject

@property (nonatomic, strong, readonly) TUDouBanChannelModel *channel;
@property (nonatomic, strong, readonly) NSMutableArray *dataSource;     // 模型数据

+ (instancetype)sharedInstance;

- (void)changeMusicList:(NSArray<__kindof TUDouBanMusicModel *> *)musicList withChannel:(TUDouBanChannelModel *)channel;

- (void)musicPlayerGetNextSongsWithCurrentMusic:(TUDouBanMusicModel *)currentMusic
                                         isSkip:(BOOL)isSkip
                                      competion:(void (^)(NSMutableArray<__kindof TUDouBanMusicModel *> *musicList, NSUInteger currentIndex))completion;

@end
