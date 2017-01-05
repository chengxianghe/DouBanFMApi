//
//  TUNetworkHelper.h
//  TUNetworkingDemo
//
//  Created by chengxianghe on 16/4/19.
//  Copyright © 2016年 cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TUNetworkHelper : NSObject

+ (NSString *)urlStringWithOriginUrlString:(NSString *)originUrlString
                          appendParameters:(NSDictionary *)parameters;

+ (void)setiTunesForbidBackupAttribute:(NSString *)path;

+ (NSString *)md5StringFromString:(NSString *)string;

+ (NSString*)urlEncode:(NSString*)str;

+ (NSString*)urlDecoded:(NSString *)str;

+ (NSString *)mimeTypeForFileAtPath:(NSString *)path;

+ (NSString *)appVersionString;

+ (NSData *)GB2312ToUTF8WithData:(NSData *)gb2312Data;

/**
 *  是否开启 Debug Log 默认开启 YES
 */
+ (void)setDebugLog:(BOOL)debugLog;

@end
