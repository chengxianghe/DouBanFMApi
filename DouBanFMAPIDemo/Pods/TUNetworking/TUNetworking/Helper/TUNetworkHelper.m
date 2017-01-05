//
//  TUNetworkHelper.m
//  TUNetworkingDemo
//
//  Created by chengxianghe on 16/4/19.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "TUNetworkHelper.h"
#import <CommonCrypto/CommonDigest.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "TUNetworkDefine.h"

static BOOL TUDebugLog = YES;

BOOL TUDebugLogEnable() {
    return TUDebugLog;
}

void TULog(NSString *format, ...) {
#ifdef DEBUG
    if (TUDebugLogEnable()) {
        va_list argptr;
        va_start(argptr, format);
        NSLogv([NSString stringWithFormat:@"🐥%@", format], argptr);
        va_end(argptr);
    }
#endif
}

@implementation TUNetworkHelper

+ (void)setDebugLog:(BOOL)debugLog {
    TUDebugLog = debugLog;
}

+ (NSString *)urlParametersStringFromParameters:(NSDictionary *)parameters {
    NSMutableString *urlParametersString = [[NSMutableString alloc] initWithString:@""];
    if (parameters && parameters.count > 0) {
        for (NSString *key in parameters) {
            NSString *value = parameters[key];
            value = [NSString stringWithFormat:@"%@",value];
            value = [self urlEncode:value];
            [urlParametersString appendFormat:@"&%@=%@", key, value];
        }
    }
    return urlParametersString;
}

+ (NSString *)urlStringWithOriginUrlString:(NSString *)originUrlString appendParameters:(NSDictionary *)parameters {
    NSString *filteredUrl = originUrlString;
    NSString *paraUrlString = [self urlParametersStringFromParameters:parameters];
    if (paraUrlString && paraUrlString.length > 0) {
        if ([originUrlString rangeOfString:@"?"].location != NSNotFound) {
            filteredUrl = [filteredUrl stringByAppendingString:paraUrlString];
        } else {
            filteredUrl = [filteredUrl stringByAppendingFormat:@"?%@", [paraUrlString substringFromIndex:1]];
        }
        return filteredUrl;
    } else {
        return originUrlString;
    }
}


+ (NSString*)urlEncode:(NSString*)str {
    //different library use slightly different escaped and unescaped set.
    //below is copied from AFNetworking but still escaped [] as AF leave them for Rails array parameter which we don't use.
    //https://github.com/AFNetworking/AFNetworking/pull/555
    NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)str, CFSTR("."), CFSTR(":/?#[]@!$&'()*+,;="), kCFStringEncodingUTF8);
    return result;
}

+ (NSString*)urlDecoded:(NSString *)str {
    NSString *result = CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,(__bridge CFStringRef)str, CFSTR(""),kCFStringEncodingUTF8));
    
    return result;
}

+ (NSString *)mimeTypeForFileAtPath:(NSString *)path {
    if (![[[NSFileManager alloc] init] fileExistsAtPath:path]) {
        return nil;
    }
    // Borrowed from http://stackoverflow.com/questions/2439020/wheres-the-iphone-mime-type-database
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[path pathExtension], NULL);
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    if (!MIMEType) {
        return @"application/octet-stream";
    }
    return CFBridgingRelease(MIMEType);
}

+ (void)setiTunesForbidBackupAttribute:(NSString *)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    [url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    if (error) {
        TULog(@"error to set do not backup attribute, error = %@", error);
    }
}

+ (NSString *)md5StringFromString:(NSString *)string {
    if(string == nil || [string length] == 0)
        return nil;
    
    const char *value = [string UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

+ (NSString *)appVersionString {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSData *)GB2312ToUTF8WithData:(NSData *)gb2312Data {
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *str = [[NSString alloc] initWithData:gb2312Data encoding:enc];
    NSData *utf8Data = [str dataUsingEncoding:NSUTF8StringEncoding];
    return utf8Data;
}

@end
