//
//  TUUserManager.h
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/24.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TUDouBanUserModel.h"

@interface TUUserManager : NSObject

@property (nonatomic, strong, readonly) TUDouBanUserModel *doubanUser;

+ (instancetype)sharedInstance;

+ (void)updateDouBanUser:(TUDouBanUserModel *)user;
+ (BOOL)isDouBanLogin;
+ (void)verifyDouBanLoginToken;

@end
