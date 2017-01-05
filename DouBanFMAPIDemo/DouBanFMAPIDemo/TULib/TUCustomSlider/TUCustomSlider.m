//
//  TUCustomSlider.m
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/17.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import "TUCustomSlider.h"


#define kCacheViewHeight 10

@interface TUCustomSlider ()

@property (nonatomic, strong) UIImageView   *cacheSliderView;
@property (nonatomic, strong) UIView        *backSliderView;
@property (nonatomic, strong) UIImageView   *recoderSliderView;
@property (nonatomic, strong) UIView        *touchView;

@end


@implementation TUCustomSlider {
    BOOL _isOut;
}

- (void)dealloc {
    _delegate = nil;
    NSLog(@"%s", __func__);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    // 背景条
    self.backSliderView = [[UIView alloc]init];
    self.backSliderView.backgroundColor = [UIColor clearColor];
    self.backSliderView.userInteractionEnabled = NO;
    [self addSubview:self.backSliderView];
    
    // 缓冲条
    self.cacheSliderView = [[UIImageView alloc]init];
    //        self.cacheSliderView.backgroundColor = [UIColor blueColor];
    //        self.cacheSliderView.alpha = 0.1;
    self.cacheSliderView.image = [UIImage imageNamed:@"poster_shadow"];
    self.cacheSliderView.userInteractionEnabled = NO;
    [self addSubview:self.cacheSliderView];
    
    // 播放条
    self.recoderSliderView = [[UIImageView alloc]init];
    //        self.recoderSliderView.backgroundColor = [UIColor blueColor];
    //leso_poster_mask   poster_shadow
    self.recoderSliderView.image = [UIImage imageNamed:@"leso_poster_mask"];
    self.recoderSliderView.userInteractionEnabled = NO;
    [self addSubview:self.recoderSliderView];
    
    
    // 创建滑块视图
    self.thumbView = [[UIImageView alloc]init];
    self.thumbView.image = [UIImage imageNamed:@"btn_progressBar_slidingBlock"];
    self.thumbView.userInteractionEnabled = NO;
    [self addSubview:_thumbView];
    
    self.touchView = [[UIView alloc] initWithFrame:self.bounds];
    self.touchView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.touchView];
    
    // 添加点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.touchView addGestureRecognizer:tap];
    
    // 添加平移手势，用来控制音量和快进快退
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panDirection:)];
    [self.touchView addGestureRecognizer:pan];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!CGRectEqualToRect(self.touchView.frame, self.bounds)) {
        self.touchView.frame = self.bounds;
        self.thumbView.frame = CGRectMake(0, 0, 4, kCacheViewHeight);
        self.thumbView.center = CGPointMake(self.thumbView.center.x, self.frame.size.height / 2);
        
        self.backSliderView.frame = CGRectMake(0, (self.frame.size.height - kCacheViewHeight) / 2, self.frame.size.width, kCacheViewHeight);
        
        self.recoderSliderView.frame = CGRectMake(0, (self.frame.size.height - kCacheViewHeight) / 2, self.thumbView.center.x, kCacheViewHeight);
        
        if ((_maximumValue - _minimumValue) > 0) {
            self.cacheSliderView.frame = CGRectMake(0, (self.frame.size.height - kCacheViewHeight) / 2, _cacheProgress / (_maximumValue - _minimumValue) * self.frame.size.width, kCacheViewHeight);
        }
    }
}

- (void)setValue:(CGFloat)value {
    
    if (value < self.minimumValue) {
        value = self.minimumValue;
    } else if (value > self.maximumValue){
        value = self.maximumValue;
    }
    
    _value = value;
    
    CGFloat progress = value/(_maximumValue - _minimumValue) * self.frame.size.width;
    self.thumbView.center = CGPointMake(progress, self.frame.size.height / 2);
    
    self.recoderSliderView.frame = CGRectMake(0, (self.frame.size.height - kCacheViewHeight) / 2, progress, kCacheViewHeight);
}

- (void)setCacheProgress:(CGFloat)cacheProgress {
    //    NSLog(@"setCache");
    
    if (cacheProgress < self.minimumValue) {
        cacheProgress = self.minimumValue;
    } else if (cacheProgress > self.maximumValue){
        cacheProgress = self.maximumValue;
    }
    
    if (_cacheProgress == cacheProgress) {
        return;
    }
    
    _cacheProgress = cacheProgress;
    
    CGFloat progress = cacheProgress / (_maximumValue - _minimumValue) * self.frame.size.width;
    
    self.cacheSliderView.frame = CGRectMake(0, (self.frame.size.height - kCacheViewHeight) / 2, progress, kCacheViewHeight);
    
}

- (void)setMaximumValue:(CGFloat)maximumValue {
    _maximumValue = maximumValue;
    
}

- (void)setMinimumValue:(CGFloat)minimumValue {
    _minimumValue = minimumValue;
}

- (BOOL)highlighted {
    return _highlighted;
}


#pragma mark - 点击手势方法
- (void)tapAction:(UITapGestureRecognizer *)tap {
    // 获取tap手势的位置
    CGPoint touchPoint = [tap locationInView:self];
    if (!CGRectContainsPoint(self.bounds, touchPoint)) {
        return;
    }
    [self delegateTouch:touchPoint.x];
}

- (void)panDirection:(UIPanGestureRecognizer *)pan {
    
    CGPoint touchPoint = [pan locationInView:self.touchView];
    
    if (!CGRectContainsPoint(self.bounds, touchPoint)) {
        
        if (_isOut) {
            return;
        }
        
        if (self.thumbView.center.x != 0) {
            [self delegateTouch:touchPoint.x];
        }
        
        _isOut = YES;
        return;
    }
    
    _isOut = NO;
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{ // 开始移动
            //            NSLog(@"开始移动");
            [self delegateTouch:touchPoint.x];
            break;
        }
        case UIGestureRecognizerStateChanged:{ // 正在移动
            CGFloat progress = touchPoint.x/self.frame.size.width * (_maximumValue - _minimumValue);
            //            NSLog(@"正在移动");
            
            _highlighted = YES;
            
            // 此时只需改变UI
            [self changeThumbViewCenter:touchPoint.x];
            
            if ([self.delegate respondsToSelector:@selector(progressAction:)]) {
                [self.delegate progressAction:progress];
            }
            
            break;
        }
        case UIGestureRecognizerStateEnded:{ // 移动停止
            //            NSLog(@"停止移动");
            [self delegateTouch:touchPoint.x];
            
        }
        default:
            break;
    }
}

- (void)delegateTouch:(CGFloat)touchPointX {
    
    if (touchPointX < 0) {
        touchPointX = 0;
    } else if (touchPointX > self.frame.size.width){
        touchPointX = self.frame.size.width;
    }
    _highlighted = NO;
    
    // 此时只需改变UI
    [self changeThumbViewCenter:touchPointX];
    
    // 根据百分比计算出value的值
    CGFloat value = ceilf((_maximumValue - _minimumValue) * touchPointX/self.frame.size.width);
    
    // 传递参数
    if ([_delegate respondsToSelector:@selector(touchView:)]) {
        [_delegate touchView:value];
    }
}

- (void)changeThumbViewCenter:(CGFloat)centerX {
    self.thumbView.center = CGPointMake(centerX, self.frame.size.height / 2);
    self.recoderSliderView.frame = CGRectMake(0, (self.frame.size.height - kCacheViewHeight) / 2, centerX, kCacheViewHeight);
}

@end