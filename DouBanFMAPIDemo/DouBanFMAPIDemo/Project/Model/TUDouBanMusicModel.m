//
//  TUDouBanMusicModel.m
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/10.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import "TUDouBanMusicModel.h"
#import <MJExtension/MJExtension.h>

@implementation TUDouBanMusicModel

// 支持归档
MJCodingImplementation

/**
 *  这个数组中的属性名将会被忽略：不进行归档
 */
+ (NSArray *)mj_ignoredCodingPropertyNames {
    return @[@"image"];
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"singers" : [TUDouBanSingerModel class]};
}

@end

@implementation TUDouBanSingerModel
MJCodingImplementation
@end
