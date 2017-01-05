//
//  TUNetworkConfig.h
//  TUNetworkingDemo
//
//  Created by chengxianghe on 16/4/21.
//  Copyright © 2016年 cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TUNetworkDefine.h"

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
@import AFNetworking;
#endif

@protocol TUNetworkConfigProtocol <NSObject>

@required

+ (id<TUNetworkConfigProtocol>)config;

/// 用户的uid
- (NSString *)configUserId;

/// 请求的公共参数
- (NSDictionary *)requestPublicParameters;

/// 校验请求结果
- (BOOL)requestVerifyResult:(id)result;

@optional
/// 请求的protocol
- (NSString *)requestProtocol;

/// 请求的Host
- (NSString *)requestHost;

/// 请求的超时时间
- (NSTimeInterval)requestTimeoutInterval;

/// 请求的安全选项
- (AFSecurityPolicy *)requestSecurityPolicy;

/// Http请求的方法
- (TURequestMethod)requestMethod;

/// 请求的SerializerType
- (TURequestSerializerType)requestSerializerType;

/// 请求公参的位置
- (TURequestPublicParametersType)requestPublicParametersType;

@end

@interface TUNetworkConfig : NSObject <TUNetworkConfigProtocol>

/// 用户的uid
@property (nonatomic, copy) NSString *userId;
/// 请求的公共参数
@property (nonatomic, strong) NSDictionary *publicParameters;

+ (instancetype)config;

- (NSString *)configUserId;

/// 请求的protocol
- (NSString *)requestProtocol;

/// 请求的Host
- (NSString *)requestHost;

/// 请求的超时时间
- (NSTimeInterval)requestTimeoutInterval;

/// 请求的安全选项
- (AFSecurityPolicy *)requestSecurityPolicy;

/// Http请求的方法
- (TURequestMethod)requestMethod;

/// 请求的SerializerType
- (TURequestSerializerType)requestSerializerType;

/// 请求公参
- (NSDictionary *)requestPublicParameters;

/// 请求公参的位置
- (TURequestPublicParametersType)requestPublicParametersType;

/// 校验请求结果
- (BOOL)requestVerifyResult:(id)result;

@end
