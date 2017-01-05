//
//  GMBScrollAdView.h
//  GMBScrollAdView
//
//  Created by chengxianghe on 15/4/15.
//  Copyright (c) 2015年 cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GMBScrollAdView;

/** 配置Label */
typedef void (^GMBScrollAdViewTitleConfig)(UILabel *label);

typedef void (^GMBScrollAdViewDidSelect)(NSInteger index);

@protocol GMBScrollAdViewDelegate <NSObject>
@optional

- (void)scrollAdView:(GMBScrollAdView *)scrollAdView didSelectIndex:(NSInteger)index;
- (void)scrollAdView:(GMBScrollAdView *)scrollAdView didScrollToIndex:(NSInteger)index;

@end

/**
 *  images可传url string image
 */
@interface GMBScrollAdView : UIView

/** 加载网络图片时的默认图片 */
@property (nonatomic, strong) UIImage *placeholderImage;
/** 是否隐藏pagecontrol，默认为NO */
@property (nonatomic, assign) BOOL hidePageControl;

- (instancetype)initWithDelegate:(id<GMBScrollAdViewDelegate>)delegate
                           frame:(CGRect)frame
                          images:(NSArray *)images
                          titles:(NSArray *)titles
                        autoPlay:(BOOL)autoPlay
                           delay:(NSTimeInterval)delay
                     titleConfig:(GMBScrollAdViewTitleConfig)titleConfig;

- (instancetype)initWithFrame:(CGRect)frame
                       images:(NSArray *)images
                       titles:(NSArray *)titles
                     autoPlay:(BOOL)autoPlay
                        delay:(NSTimeInterval)delay
                    didSelect:(GMBScrollAdViewDidSelect)didSelect
                  titleConfig:(GMBScrollAdViewTitleConfig)titleConfig;

- (instancetype)initWithFrame:(CGRect)frame
                       images:(NSArray *)images
                     autoPlay:(BOOL)autoPlay
                        delay:(NSTimeInterval)delay
                    didSelect:(GMBScrollAdViewDidSelect)didSelect;

- (void)updateImages:(NSArray *)images
              titles:(NSArray *)titles;

@end

@interface GMBScrollAdViewCell : UITableViewCell
@property (nonatomic, strong) GMBScrollAdView *scrollAdView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                     delegate:(id<GMBScrollAdViewDelegate>)delegate
                       height:(CGFloat)height
                       images:(NSArray *)images
                       titles:(NSArray *)titles
                     autoPlay:(BOOL)autoPlay
                        delay:(NSTimeInterval)delay
                  titleConfig:(GMBScrollAdViewTitleConfig)titleConfig;

@end
