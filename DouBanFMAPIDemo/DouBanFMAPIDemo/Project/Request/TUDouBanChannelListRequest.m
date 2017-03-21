//
//  TUDouBanChannelListRequest.m
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/10.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import "TUDouBanChannelListRequest.h"

//频道列表数据网址：
//http://www.douban.com/j/app/radio/channels
// 新的
//https://api.douban.com/v2/fm/app_channels?alt=json&apikey=02646d3fb69a52ff072d47bf23cef8fd&app_name=radio_iphone&client=s%3Amobile|y%3AiOS%2010.2|f%3A115|d%3Ab88146214e19b8a8244c9bc0e2789da68955234d|e%3AiPhone7%2C1|m%3Aappstore&douban_udid=b635779c65b816b13b330b68921c0f8edc049590&icon_cate=xlarge&udid=b88146214e19b8a8244c9bc0e2789da68955234d&version=115
@implementation TUDouBanChannelListRequest

- (TURequestCacheOption)cacheOption {
    return TURequestCacheOptionRefreshPriority;
}

- (TURequestMethod)requestMethod {
    return TURequestMethodGet;
}

- (AFSecurityPolicy *)requestSecurityPolicy {
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    
    [securityPolicy setValidatesDomainName:NO];
    
    return securityPolicy;
}

- (NSString *)requestUrl {
    return @"https://api.douban.com/v2/fm/app_channels";
}

- (NSDictionary *)requestParameters {
    return @{@"alt":@"json",
             @"apikey":@"02646d3fb69a52ff072d47bf23cef8fd",
             @"app_name":@"radio_iphone",
             @"client":@"s:mobile|y:iOS 10.2|f:115|d:b88146214e19b8a8244c9bc0e2789da68955234d|e:iPhone7,1|m:appstore",
             @"douban_udid":@"b635779c65b816b13b330b68921c0f8edc049590",
             @"icon_cate":@"xlarge",
             @"udid":@"b88146214e19b8a8244c9bc0e2789da68955234d",
             @"version":@"115",
             };
}

- (void)requestHandleResult {
    NSLog(@"%s", __func__);
}

@end
