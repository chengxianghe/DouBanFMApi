//
//  TUMusicLikeRequestHelper.m
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/1.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import "TUMusicLikeRequestHelper.h"

@interface TUDouBanUserChannelRequest ()
@property (nonatomic, copy) TUMusicLikeBlock block;
@end

@interface TUMusicLikeRequestHelper ()

@property (nonatomic, strong) NSMutableArray    *requestArray; // 已经发起的请求
@property (nonatomic, strong) NSMutableArray    *requestReadyArray; // 准备发起的请求
@property (nonatomic, assign) NSInteger         maxNum; // 同时最大并发数 默认 kDefaultUploadMaxNum

@end

@implementation TUMusicLikeRequestHelper

+ (TUMusicLikeRequestHelper *)sharedManager {
    static TUMusicLikeRequestHelper *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.maxNum = 3;
        sharedInstance.requestArray = [NSMutableArray array];
        sharedInstance.requestReadyArray = [NSMutableArray array];
    });
    return sharedInstance;
}

+ (void)likeMusicWithSid:(NSString *)sid
               channelId:(NSString *)channelId
                isToLike:(BOOL)isToLike
              completion:(TUMusicLikeBlock)completion {
    
    TUDouBanUserChannelRequest *douBanlikeRequest = [[TUDouBanUserChannelRequest alloc]init];
    douBanlikeRequest.type = isToLike ? TUDouBanRequestTypeLike : TUDouBanRequestTypeUnLike;
    douBanlikeRequest.sid = sid;
    douBanlikeRequest.channel_id = channelId;
    douBanlikeRequest.block = completion;
    [[self sharedManager] addRequest:douBanlikeRequest];
}

- (void)addRequest:(TUDouBanUserChannelRequest *)request {
    if (request != nil) {
        if (self.requestArray.count < self.maxNum) {
            [self.requestArray addObject:request];
            [self startRequest:request];
        } else {
            [self.requestReadyArray addObject:request];
        }
    }
}

- (void)removeRequest:(TUDouBanUserChannelRequest *)request {
    [self.requestArray removeObject:request];
    [self cancelOneRequest:request];
    
    if (self.requestReadyArray.count > 0 && self.requestArray.count < self.maxNum) {
        TUDouBanUserChannelRequest *req = [self.requestReadyArray firstObject];
        [self.requestArray addObject:req];
        [self startRequest:req];
        [self.requestReadyArray removeObject:req];
    }
    
}

- (void)cancelOneRequest:(TUDouBanUserChannelRequest *)request {
    [request cancelRequest];
    request.block = nil;
    request = nil;
}

- (void)startRequest:(TUDouBanUserChannelRequest *)request {
    if (request != nil) {
        __weak typeof(self) weakSelf = self;
        [request sendRequestWithSuccess:^(__kindof TUDouBanUserChannelRequest * _Nonnull baseRequest, id  _Nullable responseObject) {
            NSLog(@"红心操作--成功了");
            [weakSelf endRequest:request isSuccess: true];
        } failur:^(__kindof TUDouBanUserChannelRequest * _Nonnull baseRequest, NSError * _Nonnull error) {
            NSLog(@"红心操作--失败了");
            [weakSelf endRequest:request isSuccess: false];
        }];
    }
}

- (void)endRequest:(TUDouBanUserChannelRequest *)request isSuccess:(BOOL)isSuccess {
    if (request.block) {
        request.block(request, isSuccess);
        request.block = nil;
    }
    [self removeRequest:request];
}

@end
