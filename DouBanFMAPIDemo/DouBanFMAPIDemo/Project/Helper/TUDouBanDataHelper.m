//
//  TUDouBanHelper.m
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/10.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import "TUDouBanDataHelper.h"
#import "TUDouBanChannelRequest.h"
#import "TUDouBanMusicModel.h"
#import "TUUserManager.h"
#import "TUDouBanUserChannelRequest.h"
#import "TUMusicManager.h"
#import "TUMusicPlayingController.h"
#import "TUDouBanChannelModel.h"
#import <MJExtension.h>

@interface TUDouBanDataHelper ()

@property (nonatomic, strong) TUDouBanChannelRequest *channelRequest;
@property (nonatomic, strong) TUDouBanUserChannelRequest *userChannelRequest;
@property (nonatomic, strong) NSMutableArray *dataSource;     // 模型数据
@property (nonatomic, strong) TUDouBanChannelModel *channel;

@end

@implementation TUDouBanDataHelper

+ (instancetype)sharedInstance {
    static TUDouBanDataHelper *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.dataSource = [NSMutableArray array];
    });
    return sharedInstance;
}

- (void)changeMusicList:(NSArray<__kindof TUDouBanMusicModel *> *)musicList withChannel:(TUDouBanChannelModel *)channel {
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:musicList];
    self.channel = channel;
}

- (void)musicPlayerGetNextSongsWithCurrentMusic:(TUDouBanMusicModel *)currentMusic
                                         isSkip:(BOOL)isSkip
                                      competion:(void (^)(NSMutableArray<__kindof TUDouBanMusicModel *> *musicList, NSUInteger currentIndex))completion {
    if ([TUUserManager isDouBanLogin]) {
        
        [self.userChannelRequest cancelRequest];
        
        if (self.dataSource.count) {
            self.userChannelRequest.sid = [self.dataSource[self.dataSource.count - 1] sid];
        } else {
            self.userChannelRequest.sid = currentMusic.sid;
        }
        
        self.userChannelRequest.channel_id = self.channel.channel_id;
        self.userChannelRequest.type = isSkip ? TUDouBanRequestTypeSkip : TUDouBanRequestTypePlayingList;
        
        [self.userChannelRequest sendRequestWithSuccess:^(__kindof TUBaseRequest * _Nonnull baseRequest, id  _Nullable responseObject) {
            NSMutableArray *array = [TUDouBanMusicModel mj_objectArrayWithKeyValuesArray:responseObject[@"song"]];
            if (!array.count) {
                if (completion) {
                    completion(nil, 0);
                }
                return ;
            }
            
            [self refreshPageData:array];
            if (completion) {
                completion(self.dataSource, self.dataSource.count - 1);
            }
            
        } failur:^(__kindof TUBaseRequest * _Nonnull baseRequest, NSError * _Nonnull error) {
            NSLog(@"%@",error.description);
            if (completion) {
                completion(nil, 0);
            }
        }];
    } else {
        [self.channelRequest cancelRequest];

        [self.channelRequest sendRequestWithSuccess:^(__kindof TUBaseRequest * _Nonnull baseRequest, id  _Nullable responseObject) {
            NSMutableArray *array = [TUDouBanMusicModel mj_objectArrayWithKeyValuesArray:responseObject[@"song"]];

            if (!array.count) {
                if (completion) {
                    completion(nil, 0);
                }
            }

            [self refreshPageData:array];
            if (completion) {
                completion(self.dataSource, self.dataSource.count - 1);
            }
            [self refreshPageData:array];
        } failur:^(__kindof TUBaseRequest * _Nonnull baseRequest, NSError * _Nonnull error) {
            NSLog(@"%@",error.description);
            if (completion) {
                completion(nil, 0);
            }
        }];
    }
}

- (void)refreshPageData:(NSArray *)array {
    [self.dataSource addObjectsFromArray:array];
}

- (TUDouBanChannelRequest *)channelRequest {
    if (!_channelRequest) {
        _channelRequest = [[TUDouBanChannelRequest alloc] init];
        _channelRequest.channel_id = _channel.channel_id;
    }
    return _channelRequest;
}

- (TUDouBanUserChannelRequest *)userChannelRequest {
    if (!_userChannelRequest) {
        _userChannelRequest = [[TUDouBanUserChannelRequest alloc] init];
    }
    return _userChannelRequest;
}

@end
