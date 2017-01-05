//
//  TUUploadRequest.h
//  MissLi
//
//  Created by chengxianghe on 16/7/25.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "TUBaseRequest.h"

/**
 *  上传请求 默认无缓存 默认请求方式POST
 */
@interface TUUploadRequest : TUBaseRequest

/**
 *  POST传送文件文件
 */
@property (nonatomic, readonly) AFConstructingBlock _Nullable constructingBodyBlock;

/**
 *  POST传送文件Data(自定义Request)
 */
@property (nonatomic, readonly) NSData * _Nullable fileData;

/**
 *  POST传送文件URL(自定义Request)
 */
@property (nonatomic, readonly) NSURL * _Nullable fileURL;

/**
 *  当需要上传时，获得上传进度的回调
 */
@property (nonatomic, readonly) AFProgressBlock _Nullable uploadProgressBlock;

- (void)sendRequestWithSuccess:(TURequestSuccess _Nullable)success
                        failur:(TURequestFailur _Nullable)failur __attribute__((unavailable("use [-uploadWithConstructingBody:progress:success:failur:]")));

- (void)sendRequestWithCache:(TURequestCacheCompletion _Nullable)cache
                     success:(TURequestSuccess _Nullable)success
                      failur:(TURequestFailur _Nullable)failur __attribute__((unavailable("use [-uploadWithConstructingBody:progress:success:failur:]")));



@end
