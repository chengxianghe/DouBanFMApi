//
//  TUUserManager.m
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/24.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import "TUUserManager.h"
#import "KeychainTool.h"
#import "TUDouBanUserChannelRequest.h"

@interface TUUserManager ()

@end

@implementation TUUserManager

+ (instancetype)sharedInstance {
    static TUUserManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self getDouBanUserFromLocal];
    }
    return self;
}

#pragma mark - DouBan

- (void)getDouBanUserFromLocal {
    _doubanUser = [KeychainTool load:@"com.itwu.douban.user"];
    if (_doubanUser == nil) {
        _doubanUser = [[TUDouBanUserModel alloc] init];
    }
}

+ (void)updateDouBanUser:(TUDouBanUserModel *)user {
    TUDouBanUserModel *douBanUser = [TUUserManager sharedInstance].doubanUser;
    douBanUser.user_id = user.user_id;
    douBanUser.user_name = user.user_name;
    douBanUser.expire = user.expire;
    douBanUser.token = user.token;
    douBanUser.refresh_token = user.refresh_token;
    
    [KeychainTool save:@"com.itwu.douban.user" data:user];
    if (user == nil) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDouBanUserLogoutSuccessed object:nil];
    }
}

+ (BOOL)isDouBanLogin {
    TUDouBanUserModel *douBanUser = [TUUserManager sharedInstance].doubanUser;

    if (douBanUser.token.length) {
        // 1479631554
        NSTimeInterval expire = [TUUserManager sharedInstance].doubanUser.expire.longLongValue;
        NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
        // 有效期90天
        if (expire - now > 0) {
            return YES;
        }
    }
    
    return NO;
}

+ (void)verifyDouBanLoginToken {
    if ([self isDouBanLogin]) {
        TUDouBanUserChannelRequest *userChannelRequest = [[TUDouBanUserChannelRequest alloc] init];
        userChannelRequest.cacheOption = TURequestCacheOptionNone;
        userChannelRequest.channel_id = @(-3).stringValue;
        [userChannelRequest sendRequestWithSuccess:^(__kindof TUBaseRequest * _Nonnull baseRequest, id  _Nullable responseObject) {
            NSLog(@"token verify success");
        } failur:^(__kindof TUBaseRequest * _Nonnull baseRequest, NSError * _Nonnull error) {
            NSLog(@"token verify failed: %@",error);
            [self updateDouBanUser:nil];
        }];
    }
}


@end
