//
//  TUCacheManager.m
//  TUNetworkingDemo
//
//  Created by chengxianghe on 16/4/19.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "TUCacheManager.h"
#import "TUBaseRequest.h"
#import "TUNetworkHelper.h"
#import "TUDownloadRequest.h"
#import "TURequestManager.h"

@implementation TUBaseRequest (TUCacheManager)

- (NSString *)cachePath {
    NSString *basePath = [TUCacheManager cacheBaseDirPath];
    
    NSString *dirPath = [NSString stringWithFormat:@"%@/%@/%@", basePath, [[self requestConfig] configUserId], [self class]];
    
    NSMutableDictionary *mudict = [NSMutableDictionary dictionaryWithDictionary:[TURequestManager buildRequestParameters:self]];
    NSArray *ignoreKeys = [self cacheFileNameIgnoreKeysForParameters];
    if (ignoreKeys.count) {
        [mudict removeObjectsForKeys:ignoreKeys];
    }
    
    NSString *requestInfo = [NSString stringWithFormat:@"Class:%@ Argument:%@ Url:%@", [self class], mudict,[TURequestManager buildRequestUrl:self]];
    
    NSString *cacheFileName = [TUNetworkHelper md5StringFromString:requestInfo];
    
    NSString *cachePath = [NSString stringWithFormat:@"%@/%@.json", dirPath, cacheFileName];
    
    return cachePath;
}

@end

@implementation TUDownloadRequest (TUCacheManager)

- (NSString *)cachePath {
    NSString *basePath = [TUCacheManager cacheBaseDownloadDirPath];
    NSString *dirPath = [NSString stringWithFormat:@"%@/%@", basePath, [self class]];
    
    [TUCacheManager checkDirPath:dirPath autoCreate:YES];
    
    NSString *cacheFileName = [[self requestUrl] lastPathComponent];
    NSString *cachePath = [NSString stringWithFormat:@"%@/%@", dirPath, cacheFileName];
    return cachePath;
}

@end

static NSString *cacheBasePath = nil;
static NSString *cacheBaseDownloadPath = nil;

@implementation TUCacheManager

+ (void)saveCacheObject:(id)object withCachePath:(NSString *)path completion:(TUCacheWriteCompletion)completion {
    __block NSError *error = nil;
    NSString *cacheDir = [path stringByDeletingLastPathComponent];

    if (object != nil) {
        if (![object conformsToProtocol:@protocol(NSCoding)]) {
            if (completion) {
                error = [NSError errorWithDomain:@"Error cache object not conforms NSCoding!" code:-1 userInfo:nil];
                completion(error, nil);
                return;
            }
        }
        
        if (![self checkDirPath:cacheDir autoCreate:YES]) {
            if (completion) {
                error = [NSError errorWithDomain:@"Error cache dirPath can't create!" code:-1 userInfo:nil];
                completion(error, path);
            }
            return;
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            BOOL result = [NSKeyedArchiver archiveRootObject:object toFile:path];
            if (!result) {
                error = [NSError errorWithDomain:@"Error archiveRootObject can't complete!" code:-1 userInfo:nil];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(error, path);
                }
            });
        });
    } else {
        error = [NSError errorWithDomain:@"Error cache object can't be nil!" code:-1 userInfo:nil];
        if (completion) {
            completion(error, nil);
        }
    }
}

+ (void)getCacheObjectWithCachePath:(NSString *)path completion:(TUCacheReadCompletion)completion {
    NSError *error = nil;
    id cacheResult = nil;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:nil]) {
        // 防止异常
        @try {
            cacheResult = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        }
        @catch (NSException *exception) {
            TULog(@"Error data may be damaged! %@", exception);
            error = [NSError errorWithDomain:@"Error data may be damaged!" code:-1 userInfo:nil];
            if (completion) {
                completion(error, nil);
            }
            return;
        }
        @finally {
        }
    } else {
        error = [NSError errorWithDomain:@"Error cachePath not exist!" code:-1 userInfo:nil];
    }
    
    if (completion) {
        completion(error, cacheResult);
    }
}

+ (void)saveCacheForRequest:(TUBaseRequest *)request completion:(TUCacheWriteCompletion)completion {
    __block NSError *error = nil;
    NSString *path = [self getCachePathForRequest:request];
    
    if ([request isKindOfClass:[TUDownloadRequest class]]) {
        BOOL isDir = NO;
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
        if (isDir || !isExist) {
            error = [NSError errorWithDomain:@"Error dowload request can't cache!" code:-1 userInfo:nil];
        }
        if (completion) {
            completion(error, path);
        }
        return;
    }

    [self saveCacheObject:request.responseObject withCachePath:path completion:completion];
}

+ (void)getCacheForRequest:(TUBaseRequest *)request completion:(TUCacheReadCompletion)completion {
    NSString *cachePath = [self getCachePathForRequest:request];
    NSError *error = nil;
    
    if ([request isKindOfClass:[TUDownloadRequest class]]) {
        BOOL isDir = NO;
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:cachePath isDirectory:&isDir];
        if (isDir || !isExist) {
            error = [NSError errorWithDomain:@"Error dowload request can't get cache!" code:-1 userInfo:nil];
        }
        if (completion) {
            completion(error, cachePath);
        }
        return;
    }
    
    if ([self isCacheExpireForRequest:request path:cachePath]) {
        error = [NSError errorWithDomain:@"Error cache was expired!" code:-1 userInfo:nil];
        if (completion) {
            completion(error, nil);
        }
        return;
    }
    
    [self getCacheObjectWithCachePath:cachePath completion:completion];
}

// 缓存是否过期
+ (BOOL)isCacheExpireForRequest:(TUBaseRequest *)request path:(NSString *)path {
    CGFloat seconds = [self cacheFileDuration:path];
    NSTimeInterval expireTime = [request cacheExpireTimeInterval];
    
    if (expireTime <= 0 || (seconds > 0 && seconds < expireTime)) {
        return NO;
    }
    return YES;
}

+ (CGFloat)cacheFileDuration:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // get file attribute
    NSError *attributesRetrievalError = nil;
    NSDictionary *attributes = [fileManager attributesOfItemAtPath:path
                                                             error:&attributesRetrievalError];
    if (!attributes) {
        TULog(@"Error get attributes for file at %@: %@", path, attributesRetrievalError);
        return -1;
    }
    int seconds = -[[attributes fileModificationDate] timeIntervalSinceNow];
    return seconds;
}

+ (void)clearCacheForRequest:(TUBaseRequest *)request {
    [self removeFilePath:[self getCachePathForRequest:request]];
}

+ (void)clearAllCacheWithCompletion:(void (^)())completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self removeFilePath:[self cacheBaseDirPath]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    });
}

+ (void)removeFilePath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path isDirectory:nil]) {
        NSError *error = nil;
        [fileManager removeItemAtPath:path error:&error];
        if (error) {
            TULog(@"Error delete file failed! %@", error);
        }
    }
}

+ (NSString *)getCachePathForRequest:(TUBaseRequest *)request {
    return [request cachePath];
}

+ (NSString *)cacheBaseDirPath {
    if (!cacheBasePath) {
        NSString *pathOfLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        cacheBasePath = [NSString stringWithFormat:@"%@/TURequestCache", pathOfLibrary];
        [self checkDirPath:cacheBasePath autoCreate:YES];
    }
    return cacheBasePath;
}

+ (NSString *)cacheBaseDownloadDirPath {
    if (!cacheBaseDownloadPath) {
        cacheBaseDownloadPath = [[self cacheBaseDirPath] stringByAppendingPathComponent:@"Download"];
        [self checkDirPath:cacheBaseDownloadPath autoCreate:YES];
    }
    return cacheBaseDownloadPath;
}

+ (BOOL)checkDirPath:(NSString *)dirPath autoCreate:(BOOL)autoCreate {
    NSError *error = nil;
    NSFileManager *manager = [NSFileManager defaultManager];
    
    BOOL isDir = NO;
    BOOL isExist = [manager fileExistsAtPath:dirPath isDirectory:&isDir];
    
    if (!autoCreate) {
        if (isDir && isExist) {
            return YES;
        }
        return NO;
    } else {
        if (isExist) {
            if (!isDir) {
                [manager removeItemAtPath:dirPath error:&error];
                [manager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error];
                [TUNetworkHelper setiTunesForbidBackupAttribute:dirPath];
            }
        } else {
            [manager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error];
            [TUNetworkHelper setiTunesForbidBackupAttribute:dirPath];
        }
        if (error) {
            TULog(@"Error create dirPath failed! %@", error);
            return NO;
        }        
        return YES;
    }
}


+ (void)getCacheSizeOfAllWithCompletion:(void (^)(CGFloat))completion {
    __block CGFloat totalSize = 0;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        totalSize = [self folderSizeAtPath:[self cacheBaseDirPath]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(totalSize);
            }
        });
    });
}

+ (CGFloat)getCacheSizeWithRequest:(TUBaseRequest *)request {
    return [self fileSizeAtPath:[self getCachePathForRequest:request]];
}

//遍历文件夹获得文件夹大小，返回多少B
+ (CGFloat)folderSizeAtPath:(NSString*)folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) {
        return 0;
    }
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize;
}

//单个文件的大小 返回多少B
+ (long long)fileSizeAtPath:(NSString*)filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

@end
