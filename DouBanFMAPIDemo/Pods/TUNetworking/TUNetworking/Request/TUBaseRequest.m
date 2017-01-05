//
//  TUBaseRequest.m
//  TUNetworkingDemo
//
//  Created by chengxianghe on 16/4/19.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "TUBaseRequest.h"
#import "TUNetworkHelper.h"

@implementation TUBaseRequest

- (NSString *)appProtocol {
    if ([[self requestConfig] respondsToSelector:@selector(requestProtocol)]) {
        return [[self requestConfig] requestProtocol];
    } else {
        return [[TUNetworkConfig config] requestProtocol];
    }
}

- (NSString *)appHost {
    if ([[self requestConfig] respondsToSelector:@selector(requestHost)]) {
        return [[self requestConfig] requestHost];
    } else {
        return [[TUNetworkConfig config] requestHost];
    }
}

- (NSTimeInterval)requestTimeoutInterval {
    if ([[self requestConfig] respondsToSelector:@selector(requestTimeoutInterval)]) {
        return [[self requestConfig] requestTimeoutInterval];
    } else {
        return [[TUNetworkConfig config] requestTimeoutInterval];
    }
}

- (NSTimeInterval)cacheExpireTimeInterval {
    return -1;
}

- (TURequestMethod)requestMethod {
    if ([[self requestConfig] respondsToSelector:@selector(requestMethod)]) {
        return [[self requestConfig] requestMethod];
    } else {
        return [[TUNetworkConfig config] requestMethod];
    }
}

- (TURequestSerializerType)requestSerializerType {
    if ([[self requestConfig] respondsToSelector:@selector(requestSerializerType)]) {
        return [[self requestConfig] requestSerializerType];
    } else {
        return [[TUNetworkConfig config] requestSerializerType];
    }
}

- (TURequestPublicParametersType)requestPublicParametersType {
    if ([[self requestConfig] respondsToSelector:@selector(requestPublicParametersType)]) {
        return [[self requestConfig] requestPublicParametersType];
    } else {
        return [[TUNetworkConfig config] requestPublicParametersType];
    }
}

- (AFSecurityPolicy *)requestSecurityPolicy {
    if ([[self requestConfig] respondsToSelector:@selector(requestSecurityPolicy)]) {
        return [[self requestConfig] requestSecurityPolicy];
    } else {
        return [[TUNetworkConfig config] requestSecurityPolicy];
    }
}

- (NSDictionary *)requestHeaderFieldValueDictionary {
    return nil;
}

- (NSString *)requestUrl {
    return nil;
}

- (NSDictionary *)requestParameters {
    return nil;
}

- (NSArray *)cacheFileNameIgnoreKeysForParameters {
    return nil;
}

- (NSURLRequest *)buildCustomUrlRequest {
    return nil;
}

- (void)clearCompletionBlock {
    self.successBlock = nil;
    self.failurBlock = nil;
}

- (void)clearCacheCompletionBlock {
    self.cacheCompletionBlcok = nil;
}

- (void)requestHandleResult {
    
}

- (void)requestHandleResultFromCache:(id)cacheResult {
    
}

#pragma mark - Config

- (id<TUNetworkConfigProtocol>)requestConfig {
    return [TUNetworkConfig config];
}

- (BOOL)requestVerifyResult {
    return [[self requestConfig] requestVerifyResult:self.responseObject];
}

@end
