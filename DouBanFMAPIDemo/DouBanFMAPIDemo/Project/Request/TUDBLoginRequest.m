//
//  TUDBLoginRequest.m
//  TUSmartSpeaker
//
//  Created by chengxianghe on 2017/1/4.
//  Copyright © 2017年 ITwU. All rights reserved.
//

#import "TUDBLoginRequest.h"

@implementation TUDBLoginRequest

- (TURequestMethod)requestMethod {
    return TURequestMethodPost;
}

- (NSString *)requestUrl {
    return @"https://www.douban.com/service/auth2/token";
}

- (NSDictionary<NSString *,id> *)requestParameters {
    /*
     ?_v=58705
     &alt=json
     &apikey=02646d3fb69a52ff072d47bf23cef8fd
     &client_id=02646d3fb69a52ff072d47bf23cef8fd
     &client_secret=cde5d61429abcd7c
     &device_id=b88146214e19b8a8244c9bc0e2789da68955234d
     &douban_udid=b635779c65b816b13b330b68921c0f8edc049590
     &grant_type=password
     &redirect_uri=http%3A//www.douban.com/mobile/fm
     &udid=b88146214e19b8a8244c9bc0e2789da68955234d
     
     &username=
     &password=
     
     */
    return @{
             @"username" : _email,
             @"password" : _password,
             @"alt":@"json",
             @"apikey":@"02646d3fb69a52ff072d47bf23cef8fd",
             @"client_id":@"02646d3fb69a52ff072d47bf23cef8fd",
             @"client_secret":@"cde5d61429abcd7c",
             @"device_id":@"b88146214e19b8a8244c9bc0e2789da68955234d",
             @"douban_udid":@"b635779c65b816b13b330b68921c0f8edc049590",
             @"grant_type":@"password",
             @"udid":@"b88146214e19b8a8244c9bc0e2789da68955234d",
             @"redirect_uri":@"http://www.douban.com/mobile/fm",
             
             };
}

- (void)requestHandleResult {
    NSLog(@"%s", __func__);
}

@end
