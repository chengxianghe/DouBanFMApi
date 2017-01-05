//
//  TUBaseRequest.h
//  TUNetworkingDemo
//
//  Created by chengxianghe on 16/4/19.
//  Copyright © 2016年 cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TUNetworkDefine.h"
#import "TUNetworkConfig.h"

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
@import AFNetworking;
#endif

NS_ASSUME_NONNULL_BEGIN

@class TUBaseRequest;

typedef NSURL * _Nullable (^AFDownloadDestinationBlock)(NSURL *targetPath, NSURLResponse *response);
typedef void (^AFConstructingBlock)(__kindof id<AFMultipartFormData> formData);
typedef void (^AFProgressBlock)(__kindof NSProgress *progress);
typedef void (^TURequestSuccess)(__kindof TUBaseRequest *baseRequest, id _Nullable responseObject);
typedef void (^TURequestFailur)(__kindof TUBaseRequest *baseRequest, NSError *error);
typedef void (^TURequestCacheCompletion)(__kindof TUBaseRequest *baseRequest, __kindof id _Nullable cacheResult, NSError *error);

/**
 *  基本请求
 */
@interface TUBaseRequest : NSObject

@property (nonatomic,   copy) _Nullable TURequestSuccess successBlock;
@property (nonatomic,   copy) _Nullable TURequestFailur failurBlock;
@property (nonatomic,   copy) _Nullable TURequestCacheCompletion cacheCompletionBlcok;
@property (nonatomic, strong) _Nullable id responseObject;
/// 请求的Task
@property (nonatomic, strong) NSURLSessionTask *requestTask;
/// 请求优先级
@property (nonatomic, assign) TURequestPriority requestPriority;
/// 请求的缓存选项
@property (nonatomic, assign) TURequestCacheOption cacheOption;

/**
 *  清理网络回调block
 */
- (void)clearCompletionBlock;

/**
 *  请求的protocol
 *
 *  @return NSString
 */
- (NSString * _Nullable)appProtocol;

/**
 *  请求的Host
 *
 *  @return NSString
 */
- (NSString * _Nullable)appHost;

/**
 *  请求的URL
 *
 *  @return NSString
 */
- (NSString * _Nullable)requestUrl;

/**
 *  请求的连接超时时间，默认为60秒
 *
 *  @return NSTimeInterval
 */
- (NSTimeInterval)requestTimeoutInterval;

/**
 *  请求的参数列表
 *  POST时放在body中
 *
 *  @return NSDictionary
 */
- (NSDictionary<NSString *, id> * _Nullable)requestParameters;

/**
 *  请求的方法(GET,POST...)
 *
 *  @return TURequestMethod
 */
- (TURequestMethod)requestMethod;

/**
 *  请求的SerializerType
 *
 *  @return TURequestSerializerType
 */
- (TURequestSerializerType)requestSerializerType;

/**
 *  请求公参的位置
 *
 *  @return TURequestPublicParametersType
 */
- (TURequestPublicParametersType)requestPublicParametersType;

/**
 *  证书配置
 *
 *  @return AFSecurityPolicy
 */
- (AFSecurityPolicy * _Nullable)requestSecurityPolicy;

/**
 *  在HTTP报头添加的自定义参数
 *
 *  @return NSDictionary
 */
- (NSDictionary<NSString *, NSString *> * _Nullable)requestHeaderFieldValueDictionary;

/**
 *  请求的回调
 */
- (void)requestHandleResult;

/**
 *  请求缓存的回调
 *
 *  @param cacheResult 缓存的数据
 */
- (void)requestHandleResultFromCache:(id _Nullable)cacheResult;

/**
 *  自定义UrlRequest
 *
 *  @return NSURLRequest
 */
- (NSURLRequest * _Nonnull)buildCustomUrlRequest;

#pragma mark - Cache

/**
 *  缓存过期时间（默认-1 永远不过期）
 *
 *  @return NSTimeInterval
 */
- (NSTimeInterval)cacheExpireTimeInterval;

/**
 *  清理缓存回调block
 */
- (void)clearCacheCompletionBlock;

/**
 *  缓存需要忽略的参数
 *
 *  @return NSArray
 */
- (NSArray<__kindof NSString *> * _Nullable)cacheFileNameIgnoreKeysForParameters;

#pragma mark - config

/**
 *  网络配置
 *
 *  @return TUNetworkConfig
 */
- (id<TUNetworkConfigProtocol> _Nonnull)requestConfig;

/**
 *  请求结果校验
 *
 *  @return BOOL
 */
- (BOOL)requestVerifyResult;

@end

NS_ASSUME_NONNULL_END
