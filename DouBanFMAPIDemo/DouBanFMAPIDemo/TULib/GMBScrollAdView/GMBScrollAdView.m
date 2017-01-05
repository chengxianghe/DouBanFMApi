//
//  GMBScrollAdView.m
//  GMBScrollAdView
//
//  Created by chengxianghe on 15/4/15.
//  Copyright (c) 2015年 cn. All rights reserved.
//

#import "GMBScrollAdView.h"
#import <UIImageView+AFNetworking.h>


@implementation UIScrollView (UITouch)

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [[self nextResponder] touchesBegan:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    [[self nextResponder] touchesMoved:touches withEvent:event];
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    [[self nextResponder] touchesEnded:touches withEvent:event];
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //    [[self nextResponder] touchesCancelled:touches withEvent:event];
    [super touchesCancelled:touches withEvent:event];
}

@end


@interface GMBScrollAdView() <UIScrollViewDelegate>

@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) NSArray       *imageArray;        // 自己的图片数组
@property (nonatomic, strong) NSArray       *titles;            // 标题数组
@property (nonatomic, assign) int           loopCount;          // 计数器
@property (nonatomic,   copy) GMBScrollAdViewDidSelect didSelect;
@property (nonatomic,   copy) GMBScrollAdViewTitleConfig titleConfig;   //label配置
@property (nonatomic,   weak) id<GMBScrollAdViewDelegate> delegate;

@end

@implementation GMBScrollAdView

#pragma mark - Public Methods

- (instancetype)initWithDelegate:(id<GMBScrollAdViewDelegate>)delegate
                           frame:(CGRect)frame
                          images:(NSArray *)images
                          titles:(NSArray *)titles
                        autoPlay:(BOOL)autoPlay
                           delay:(NSTimeInterval)delay
                     titleConfig:(GMBScrollAdViewTitleConfig)titleConfig {
    if (self = [super initWithFrame:frame]) {
        self.timeInterval = delay;
        self.delegate = delegate;
        self.titles = [NSArray arrayWithArray:titles];
        self.loopCount = 0;
        self.titleConfig = titleConfig;
        [self addScrollView];
        [self addPageControl];
        [self addImageViewToScrollView];

        if (images.count) {
            [self reloadScrollAdData:images];
            if (autoPlay == YES) {
                [self toPlay];
            }

        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                       images:(NSArray *)images
                       titles:(NSArray *)titles
                     autoPlay:(BOOL)autoPlay
                        delay:(NSTimeInterval)delay
                    didSelect:(GMBScrollAdViewDidSelect)didSelect
                  titleConfig:(GMBScrollAdViewTitleConfig)titleConfig {
    GMBScrollAdView *adView = [self initWithDelegate:nil
                                               frame:frame
                                              images:images
                                              titles:titles
                                            autoPlay:autoPlay
                                               delay:delay
                                         titleConfig:titleConfig];
    adView.didSelect = didSelect;
    return adView;
}

- (instancetype)initWithFrame:(CGRect)frame
                       images:(NSArray *)images
                     autoPlay:(BOOL)autoPlay
                        delay:(NSTimeInterval)delay
                    didSelect:(GMBScrollAdViewDidSelect)didSelect {
    GMBScrollAdView *adView = [self initWithFrame:frame
                                           images:images
                                           titles:nil
                                         autoPlay:autoPlay
                                            delay:delay
                                        didSelect:didSelect
                                      titleConfig:nil];
    return adView;
}

- (void)updateImages:(NSArray *)images
              titles:(NSArray *)titles {
    [self cancelPlay];
    self.titles = [NSArray arrayWithArray:titles];
    [self reloadScrollAdData:images];
    if (images.count) {
        [self toPlay];
    }
}

- (void)setHidePageControl:(BOOL)hidePageControl {
    _hidePageControl = hidePageControl;
    _pageControl.hidden = hidePageControl;
}

#pragma mark - Private Methods
- (void)reloadScrollAdData:(NSArray *)images {
    [self checkImages:images];
    _pageControl.numberOfPages = images.count;
    _pageControl.currentPage = 0;
    [self refreshImages];
}

- (void)toPlay{
//    [self performSelector:@selector(autoPlayToNextPage) withObject:nil afterDelay:_timeInterval];
    [self performSelector:@selector(autoPlayToNextPage) withObject:nil afterDelay:_timeInterval inModes:@[NSRunLoopCommonModes]];
}

- (void)autoPlayToNextPage{
    [self cancelPlay];
    
//    UIView *view = self.scrollView.subviews[1];
//    UIViewAnimationOptions option = UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionTransitionCurlUp | UIViewAnimationOptionCurveEaseOut;
//    [UIView transitionWithView:view duration:1 options:option animations:^{
//        [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds) * 2.0, 0)];
//    } completion:^(BOOL finished) {
//        [self toPlay];
//    }];

    [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds) * 2.0, 0) animated:YES];
    [self toPlay];
}

- (void)cancelPlay {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoPlayToNextPage) object:nil];
}

- (void)checkImages:(NSArray *)images {
    switch (images.count) {
            // 这里 防止少于3张图的时候异常
        case 1:
            self.imageArray = @[images[0],images[0],images[0]];
            break;
        case 2:
            self.imageArray = @[images[0],images[1],images[0],images[1]];
            break;
        default:
            self.imageArray = [NSArray arrayWithArray:images];
            break;
    }
}

- (void)addImageViewToScrollView {
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * width, 0, width, height)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [_scrollView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 30)];
        [imageView addSubview:label];
        
        if (_titleConfig) {
            _titleConfig(label);
        }
    }
}

- (void)addScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    scrollView.scrollsToTop = NO;//解决多个scrollview不能点击状态栏返回顶部
    scrollView.contentSize = CGSizeMake(3.0 * width, height);
    scrollView.contentOffset = CGPointMake(width, height);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapped:)];
    [scrollView addGestureRecognizer:tap];
    
    [self addSubview:scrollView];
    
    _scrollView = scrollView;
}

- (void)addPageControl{
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, height-20, width, 20)];
    //    bgView.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.2];
    bgView.backgroundColor = [UIColor clearColor];
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, width, 20)];
    pageControl.userInteractionEnabled = NO;
    _pageControl = pageControl;
    [bgView addSubview:self.pageControl];
    [self addSubview:bgView];
}

- (void)setImageView:(UIImageView *)imageView withIndex:(NSInteger)i {
    // 没有设置默认图 用自带的设置
    if (!self.placeholderImage) {
        self.placeholderImage = [UIImage imageNamed:@"product_default"];
    }
    
    if ([self.imageArray[i] isKindOfClass:[NSString class]]) {
        if ([self.imageArray[i] hasPrefix:@"http"]) {
            [imageView setImageWithURL:[NSURL URLWithString:self.imageArray[i]] placeholderImage:self.placeholderImage];
        } else {
            [imageView setImage:[UIImage imageNamed:self.imageArray[i]]];
        }
    } else if ([self.imageArray[i] isKindOfClass:[NSURL class]]) {
        [imageView setImageWithURL:self.imageArray[i] placeholderImage:self.placeholderImage];
    } else if ([self.imageArray[i] isKindOfClass:[UIImage class]]){
        [imageView setImage:self.imageArray[i]];
    } else {
        [imageView setImage:nil];
    }
    
}

- (void)refreshImages{
    NSInteger count = self.imageArray.count;
    NSInteger imageCount = self.pageControl.numberOfPages;

    NSInteger firstImage  = (self.loopCount + count - 1) % count;
    NSInteger secondImage =  self.loopCount              % count;
    NSInteger thirdImage  = (self.loopCount + count + 1) % count;
    
    switch (imageCount) {
        case 1:
            self.pageControl.currentPage = 1;
            break;
        case 2:
            self.pageControl.currentPage = secondImage % 2;
            break;
            
        default:
            self.pageControl.currentPage = secondImage;
            break;
    }
    
    [self configAdView:(UIImageView *)self.scrollView.subviews[0] With:firstImage];
    [self configAdView:(UIImageView *)self.scrollView.subviews[1] With:secondImage];
    [self configAdView:(UIImageView *)self.scrollView.subviews[2] With:thirdImage];

    [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds), 0)];
    
    if ([self.delegate respondsToSelector:@selector(scrollAdView:didScrollToIndex:)]) {
        [self.delegate scrollAdView:self didScrollToIndex:self.pageControl.currentPage];
    }
}


- (void)configAdView:(UIImageView *)imageView With:(NSInteger)index {
    [self setImageView:imageView withIndex:index];
    
    UILabel *lable = (UILabel *)imageView.subviews[0];
 
    NSInteger imageCount = self.pageControl.numberOfPages;
    if (imageCount == 1) {
        index = 0;
    } else if (imageCount == 2) {
        index = index%2;
    }
    
    if (index < self.titles.count) {
        lable.hidden = NO;
        [lable setText:self.titles[index]];
    } else {
        lable.hidden = YES;
    }
}

#pragma mark - UITapGestureRecognizer

- (void)singleTapped:(UITapGestureRecognizer *)recognizer{
    NSLog(@"singleTapped");
    
    if (self.didSelect) {
        self.didSelect(self.pageControl.currentPage);
    }
    
    if ([self.delegate respondsToSelector:@selector(scrollAdView:didSelectIndex:)]) {
        [self.delegate scrollAdView:self didSelectIndex:self.pageControl.currentPage];
    }
}

#pragma mark - UIScrollViewDelegate

// 经常调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat x = scrollView.contentOffset.x;
    CGFloat width = CGRectGetWidth(self.frame);
    NSInteger imageCount = self.pageControl.numberOfPages;

    if (x >= 2 * width) {
        self.loopCount ++;
        if (self.loopCount > imageCount) {
            self.loopCount -= (int)imageCount;
        }
        
        [self refreshImages];
    }
    if (x <= 0) {
        self.loopCount --;
        if (self.loopCount < 0) {
            self.loopCount += (int)imageCount;
        }
        [self refreshImages];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self cancelPlay];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    [self toPlay];
}

#pragma mark - Touch Event

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesBegan");
    [self cancelPlay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesEnded");
    [self toPlay];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesCancelled");
    [self toPlay];
}

@end

@interface GMBScrollAdViewCell ()


@end

@implementation GMBScrollAdViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                     delegate:(id<GMBScrollAdViewDelegate>)delegate
                       height:(CGFloat)height
                       images:(NSArray *)images
                       titles:(NSArray *)titles
                     autoPlay:(BOOL)autoPlay
                        delay:(NSTimeInterval)delay
                  titleConfig:(GMBScrollAdViewTitleConfig)titleConfig {
 
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.scrollAdView = [[GMBScrollAdView alloc] initWithDelegate:delegate
                                                                frame:CGRectMake(0, 0, kScreenWidth, height)
                                                               images:images
                                                               titles:titles
                                                             autoPlay:autoPlay
                                                                delay:delay
                                                          titleConfig:titleConfig];
        [self.contentView addSubview:self.scrollAdView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
    
}

@end
