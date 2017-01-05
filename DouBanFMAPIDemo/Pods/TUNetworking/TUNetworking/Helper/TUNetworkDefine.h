//
//  TUNetworkDefine.h
//  TUNetworkingDemo
//
//  Created by chengxianghe on 16/4/20.
//  Copyright © 2016年 cn. All rights reserved.
//

#ifndef TUNetworkDefine_h
#define TUNetworkDefine_h

// is ios system version >= ?
#ifndef SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#endif

FOUNDATION_EXPORT void TULog(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);
FOUNDATION_EXPORT BOOL TUDebugLogEnable();

typedef NS_ENUM(NSInteger , TURequestMethod) {
    TURequestMethodGet = 0,
    TURequestMethodPost,
    TURequestMethodHead,
    TURequestMethodPut,
    TURequestMethodDelete,
    TURequestMethodPatch,
};

typedef NS_ENUM(NSInteger , TURequestSerializerType) {
    TURequestSerializerTypeHTTP = 0,
    TURequestSerializerTypeJSON,
};

typedef NS_ENUM(NSInteger , TURequestPublicParametersType) {
    /// 公参放在Body (Default)
    TURequestPublicParametersTypeBody = 0,
    /// 公参拼接在Url后面
    TURequestPublicParametersTypeUrl,
    /// 公参放在Header
    TURequestPublicParametersTypeHeader,
    /// 不需要公参
    TURequestPublicParametersTypeNone,
};

typedef NS_ENUM(NSInteger , TURequestPriority) {
    TURequestPriorityDefault = 0,
    TURequestPriorityLow,
    TURequestPriorityHigh,
};

typedef NS_ENUM(NSUInteger, TURequestCacheOption) {
    /// 不缓存
    TURequestCacheOptionNone = 0,
    /// 优先读取网络,成功会缓存,失败才会读取本地缓存,(一次网络成功回调)或者(一次网络失败回调和一次缓存读取回调)
    TURequestCacheOptionRefreshPriority,
    /// 优先读取本地缓存,同时访问网络,访问网络成功会缓存,有两次回调
    TURequestCacheOptionCachePriority,
    /// 优先读取本地缓存,没有本地缓存时才访问网络,访问网络成功会缓存,(一次缓存读取成功回调)或者(一次缓存读取失败回调和一次网络回调)
    TURequestCacheOptionCacheSaveFlow,
    /// 只读取本地,离线模式
    TURequestCacheOptionCacheOnly,
};

#endif /* TUNetworkDefine_h */
