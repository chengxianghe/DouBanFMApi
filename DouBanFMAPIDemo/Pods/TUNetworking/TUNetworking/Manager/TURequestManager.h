//
//  TURequestManager.h
//  TUNetworkingDemo
//
//  Created by chengxianghe on 16/4/19.
//  Copyright © 2016年 cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TUBaseRequest.h"
#import "TUDownloadRequest.h"
#import "TUUploadRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface TUBaseRequest (TURequestManager)

/**
 *  发送请求
 *
 *  @param success  成功的回调
 *  @param failur   失败的回调
 */
- (void)sendRequestWithSuccess:(TURequestSuccess _Nullable)success
                        failur:(TURequestFailur _Nullable)failur;

/**
 *  发送请求（缓存）
 *
 *  @param cache    缓存读取完的回调
 *  @param success  成功的回调
 *  @param failur   失败的回调
 */
- (void)sendRequestWithCache:(TURequestCacheCompletion _Nullable)cache
                     success:(TURequestSuccess _Nullable)success
                      failur:(TURequestFailur _Nullable)failur;

/**
 *  取消请求
 */
- (void)cancelRequest;


@end

@interface TUDownloadRequest (TURequestManager)

/**
 *  发送请求（缓存）
 *
 *  @param cache    缓存读取完的回调
 *  @param success  成功的回调
 *  @param failur   失败的回调
 */
- (void)downloadWithCache:(TURequestCacheCompletion _Nullable)cache
                 progress:(AFProgressBlock _Nullable)downloadProgressBlock
                  success:(TURequestSuccess _Nullable)success
                   failur:(TURequestFailur _Nullable)failur;

@end

@interface TUUploadRequest (TURequestManager)

/**
 *  上传请求 POST
 *
 *  @param constructingBody 上传的数据
 *  @param uploadProgress   上传进度
 *  @param success          成功的回调
 *  @param failur           失败的回调
 */
- (void)uploadWithConstructingBody:(AFConstructingBlock _Nullable)constructingBody
                          progress:(AFProgressBlock _Nullable)uploadProgress
                           success:(TURequestSuccess _Nullable)success
                            failur:(TURequestFailur _Nullable)failur;
/**
 *  上传请求 POST (自定义request)
 *
 *  @param fileData         上传的数据
 *  @param uploadProgress   上传进度
 *  @param success          成功的回调
 *  @param failur           失败的回调
 */
- (void)uploadCustomRequestWithFileData:(NSData * _Nullable)fileData
                               progress:(AFProgressBlock _Nullable)uploadProgress
                                success:(TURequestSuccess _Nullable)success
                                 failur:(TURequestFailur _Nullable)failur;
/**
 *  上传请求 POST (自定义request)
 *
 *  @param fileURL          上传的文件URL
 *  @param uploadProgress   上传进度
 *  @param success          成功的回调
 *  @param failur           失败的回调
 */
- (void)uploadCustomRequestWithFileURL:(NSURL * _Nullable)fileURL
                              progress:(AFProgressBlock _Nullable)uploadProgress
                               success:(TURequestSuccess _Nullable)success
                                failur:(TURequestFailur _Nullable)failur;

@end

@interface TURequestManager : NSObject

+ (nonnull instancetype)manager;

+ (nullable NSMutableDictionary *)buildRequestHeader:(TUBaseRequest *)request;

+ (nullable NSMutableDictionary *)buildRequestParameters:(TUBaseRequest *)request;

+ (nullable NSString *)buildRequestUrl:(nonnull TUBaseRequest *)request;

- (void)sendRequest:(nonnull TUBaseRequest *)request;

- (void)cancelRequest:(nonnull TUBaseRequest *)request;

- (void)cancelAllRequests;

@end

NS_ASSUME_NONNULL_END
