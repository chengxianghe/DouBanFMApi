//
//  TUMusicCategory.h
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/1.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TUMusicCategory : NSObject

@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, strong) NSNumber *categoryId;
@property (nonatomic, copy) NSString *tag;

@end
