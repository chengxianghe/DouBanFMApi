//
//  TUNetworkConfig.m
//  TUNetworkingDemo
//
//  Created by chengxianghe on 16/4/21.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "TUNetworkConfig.h"

@implementation TUNetworkConfig

+ (TUNetworkConfig *)config {
    static TUNetworkConfig *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[self alloc] init];
    });
    return config;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self reset];
    }
    return self;
}

- (void)reset {
    _publicParameters = @{};
    _userId = @"0";
}

- (NSString *)configUserId {
    return self.userId;
}

/// 请求的protocol
- (NSString *)requestProtocol {
    return @"http://";
}

/// 请求的Host
- (NSString *)requestHost {
    return @"";
}

/// 请求的超时时间
- (NSTimeInterval)requestTimeoutInterval {
    return 60;
}

/// 请求的安全选项
- (AFSecurityPolicy *)requestSecurityPolicy {
    return [AFSecurityPolicy defaultPolicy];
}

/// Http请求的方法
- (TURequestMethod)requestMethod {
    return TURequestMethodGet;
}

/// 请求的SerializerType
- (TURequestSerializerType)requestSerializerType {
    return TURequestSerializerTypeHTTP;
}

- (NSDictionary *)requestPublicParameters {
    return self.publicParameters;
}

/// 请求公参的位置
- (TURequestPublicParametersType)requestPublicParametersType {
    return TURequestPublicParametersTypeBody;
}

/// 请求校验
- (BOOL)requestVerifyResult:(id)result {
    if (result) {
        return YES;
    }
    return NO;
}

@end
