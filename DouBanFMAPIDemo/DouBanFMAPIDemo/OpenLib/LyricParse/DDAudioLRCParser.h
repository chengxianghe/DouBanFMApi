//
//  DDAudioLRCParser.h
//  JuYouQu
//
//  Created by Normal on 16/2/19.
//  Copyright © 2016年 Bo Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DDAudioLRC;
@class DDAudioLRCUnit;

@interface DDAudioLRCParser : NSObject
+ (nullable DDAudioLRC *)parserLRCText:(NSString *)lrc;
@end


@interface DDAudioLRC : NSObject
@property (nullable, strong, nonatomic) NSString *originLRCText;
@property (nullable, strong, nonatomic) NSArray<DDAudioLRCUnit *> *units;
@property (nonatomic, copy) NSString *lrc_title;  // 歌曲名称
@property (nonatomic, copy) NSString *lrc_autor;  // 演唱者
@property (nonatomic, copy) NSString *lrc_create; // 歌词制作
@property (nonatomic, copy) NSString *lrc_album;  // 专辑
@property (nonatomic, copy) NSString *lrc_offset;  // 补偿
@property (nonatomic, copy) NSString *lrc_time;  // 时长

// 歌词上附带的一些歌曲数据。根据 keys 取数据，数据是否存在由歌词决定。
- (void)setMetadata:(nullable id)value forKey:(NSString *)key;
- (nullable id)metadataForKey:(NSString *)key;

// 根据时间返回相应歌词所在行数
- (NSRange)linesAtTimeSecondFrom:(NSTimeInterval)from to:(NSTimeInterval)end;
- (NSUInteger)lineAtTimeSecond:(NSTimeInterval)sec;

// 根据时间返回相应的歌词
- (nullable NSArray<DDAudioLRCUnit *> *)LRCUnitsAtTimeSecondFrom:(NSTimeInterval)from to:(NSTimeInterval)end;
- (nullable DDAudioLRCUnit *)LRCUnitAtTimeSecond:(NSTimeInterval)sec;

// 返回歌词行数对应的歌词内容
- (nullable NSArray<DDAudioLRCUnit *> *)LRCUnitsAtLines:(NSRange)range;
- (nullable DDAudioLRCUnit *)LRCUnitAtLine:(NSUInteger)line;
@end

@interface DDAudioLRCUnit : NSObject
@property (nullable, strong, nonatomic) NSString *secString;
@property (assign, readonly, nonatomic) NSTimeInterval sec;
@property (nullable, strong, nonatomic) NSString *lrc;
@end

NS_ASSUME_NONNULL_END