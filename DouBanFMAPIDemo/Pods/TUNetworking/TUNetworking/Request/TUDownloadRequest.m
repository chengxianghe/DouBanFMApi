//
//  TUDownloadRequest.m
//  TUNetworkingDemo
//
//  Created by chengxianghe on 16/4/22.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "TUDownloadRequest.h"

@interface TUDownloadRequest ()

@property (nonatomic, copy) _Nullable AFProgressBlock downloadProgressBlock;

@end

@implementation TUDownloadRequest

- (void)resume {
    if (self.requestTask.state != NSURLSessionTaskStateRunning) {
        [self.requestTask resume];
    }
}

- (void)suspend {
    if (self.requestTask.state == NSURLSessionTaskStateRunning) {
        [self.requestTask suspend];
    }
}

@end
