//
//  TUMusicPlayingController.m
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/10.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import "TUMusicPlayingController.h"
#import <UIImageView+WebCache.h>
#import "TUMusicManager.h"
#import "TUMusicHelper.h"
#import "TUDouBanMusicModel.h"
#import "TUAnimationHelper.h"
#import "FXBlurView.h"
#import "TUIBButton.h"
#import "TUIBLoopButton.h"
#import "TUIBSlider.h"
#import "AppDelegate+TUMusicRemoteControl.h"
#import "TUUserManager.h"
#import "TUDouBanUserChannelRequest.h"
#import "TUDouBanLoginController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "TUDouBanLyricRequest.h"
#import "DDAudioLRCParser.h"
#import "TUDouBanLyricModel.h"
#import "TUDouBanDataHelper.h"
#import "TUDouBanChannelModel.h"
#import "TUDragModalTransition.h"
#import "TUMusicSettingMoreController.h"
#import "TUMusicDataMenuController.h"

static CGFloat kDefaultAngle = (M_PI / 360.0f);

@interface TUMusicLyricCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lrcLabel;
- (void)setLrcModel:(DDAudioLRCUnit *)model;
@end

@implementation TUMusicLyricCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self resetUI];
}

- (void)resetUI {
    self.lrcLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    self.lrcLabel.font = [UIFont systemFontOfSize:15.0];
}

- (void)setLrcModel:(DDAudioLRCUnit *)model {
    if (model) {
        self.lrcLabel.text = model.lrc;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // 处理选中后的效果
    if (selected) {
        self.lrcLabel.textColor = [UIColor whiteColor];
        self.lrcLabel.font = [UIFont systemFontOfSize:17.0];
    }else {
        [self resetUI];
    }
}


@end

@interface TUMusicVCCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerImageTopConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *backCDImageView;
@property (weak, nonatomic) IBOutlet UIImageView *maskCDImageView;
@property (strong, nonatomic) TUDouBanMusicModel *music;

- (void)setMusic:(TUDouBanMusicModel *)music;

+ (CGFloat)getCenterImageTop;
+ (CGFloat)getImageLeading;

@end

@implementation TUMusicVCCollectionCell

+ (CGFloat)getCenterImageTop {
    CGFloat centerImageTop = 0;
    
    if (kIs_Inch3_5) {
        centerImageTop = 43;
    } else if (kIs_Inch4_0) {
        centerImageTop = 43;
    } else if (kIs_Inch4_7) {
        centerImageTop = 55;
    } else if (kIs_Inch5_5) {
        centerImageTop = 57;
    }
    return centerImageTop;
}

+ (CGFloat)getImageLeading {
    CGFloat imageLeading = 0;
    
    if (kIs_Inch3_5) {
        imageLeading = 42;
    } else if (kIs_Inch4_0) {
        imageLeading = 42;
    } else if (kIs_Inch4_7) {
        imageLeading = 38;
    } else if (kIs_Inch5_5) {
        imageLeading = 43;
    }
    return imageLeading;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _centerImageTopConstraint.constant = [self.class getCenterImageTop];
    self.imageView.layer.cornerRadius = ceil((kScreenWidth - ([self.class getCenterImageTop] + [self.class getImageLeading]) * 2) * 0.5);
    
}

- (void)setMusic:(TUDouBanMusicModel *)music {
    _music = music;
    
    @weakify(self);
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.music.picture] placeholderImage:[UIImage imageNamed:@"cm2_default_cover_play"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        @strongify(self);
        if (!self) { return; }
        
        self.music.image = image;
    }];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.transform = CGAffineTransformIdentity;
    self.maskCDImageView.transform = CGAffineTransformIdentity;
}

@end


@interface TUMusicPlayingController () <TUMusicManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *needleHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *needleTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *needleLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *needleTopHeightMConstraint;

@property (weak, nonatomic) IBOutlet UIView *navBottomLineView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *needleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *needleTopImageView;
@property (weak, nonatomic) IBOutlet UIView *likeView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

// bootom ui
@property (weak, nonatomic) IBOutlet UIProgressView *cacheProgressView;
@property (weak, nonatomic) IBOutlet TUIBSlider *progressView;
@property (weak, nonatomic) IBOutlet TUIBButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *preButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet TUIBLoopButton *loopButton;

// setting ui
@property (weak, nonatomic) IBOutlet TUIBButton *likeButton;
@property (weak, nonatomic) IBOutlet TUIBButton *downloadButton;
@property (weak, nonatomic) IBOutlet TUIBButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *menuMoreButton;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel; //comment count label

// volume
@property (weak, nonatomic) IBOutlet UIView *volumeBackView;
@property (weak, nonatomic) IBOutlet TUIBSlider *volumeSlider;
@property (strong, nonatomic) MPVolumeView *volumSystemView; // 控制系统的音量HUD
@property (strong, nonatomic) UISlider  *volumeSystemSlider; // 系统声音进度条

@property (strong, nonatomic) TUDouBanMusicModel *currentMusic;
@property (assign, nonatomic) NSUInteger currentIndex;
@property (strong, nonatomic) NSMutableArray<__kindof TUDouBanMusicModel *> *musicList;
@property (strong, nonatomic) TUDouBanUserChannelRequest *douBanRequest;
@property (strong, nonatomic) TUDouBanLyricRequest *lyricRequest;
@property (strong, nonatomic) DDAudioLRC *lyric;
@property (assign, nonatomic) NSUInteger lyricSelectedLine;

// status
@property (assign, nonatomic) BOOL isShowingLyric;
@property (assign, nonatomic) BOOL isDraggingProgress;
@property (assign, nonatomic) BOOL isDraggingVolumeSlider;
@property (assign, nonatomic) BOOL isAnimating;
@property (assign, nonatomic) BOOL isViewShowing;

// rotation
@property (strong, nonatomic) CADisplayLink *rotationDisplaylink;
@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) UIImageView *maskCDImageView;

@property (weak, nonatomic) TUMusicDataMenuController *dataMenuController;
@property (strong, nonatomic) TUDragModalTransition *transitionManager;

- (void)setMusicList:(NSMutableArray<__kindof TUDouBanMusicModel *> *)musicList currentIndex:(NSUInteger)currentIndex;

@end

@implementation TUMusicPlayingController

#pragma mark - Public

+ (TUDouBanMusicModel *)playingModel {
    return [[self sharedInstance] currentMusic];
}

+ (void)onNext {
    [[self sharedInstance] onNextButtonClick];
}

+ (void)onPrevious {
    [[self sharedInstance] onPreButtonClick];
}

+ (void)onPlay {
    [[self sharedInstance] continuePlay];
}

+ (void)onPause {
    [[self sharedInstance] pausePlay];
}

+ (void)changeLikeWithCompletion:(TUMusicLikeBlock)completion {
    [[self sharedInstance] changeLikeWithCompletion:completion];
}

+ (instancetype)sharedInstance {
    static TUMusicPlayingController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TUMusicPlayingController"];
        [TUMusicManager sharedInstance].delegate = sharedInstance;
    });
    return sharedInstance;
}

+ (instancetype)musicControllerWithMusicList:(NSArray<__kindof TUDouBanMusicModel *> *)musicList
                                currentIndex:(NSUInteger)currentIndex {
    TUMusicPlayingController *vc = [TUMusicPlayingController sharedInstance];
    NSMutableArray *array = [NSMutableArray arrayWithArray:musicList];
    [vc setMusicList:array currentIndex:currentIndex];
    return vc;
}

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.transitionManager.isInteractive) {
        return;
    }
    NSLog(@"viewWillAppear");
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
//    [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
    self.isViewShowing = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.transitionManager.isInteractive || self.transitionManager.scrollView) {
        return;
    }
    if ([[TUMusicManager sharedInstance] isPlaying]) {
        [self rotationImage];
        NSLog(@"viewDidAppear startRotationDisplaylink");
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.transitionManager.isInteractive) {
        return;
    }
    NSLog(@"viewWillDisappear");

    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    [self.navigationController.view bringSubviewToFront:self.navigationController.navigationBar];
    self.isViewShowing = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.transitionManager.isInteractive || self.transitionManager.scrollView) {
        return;
    }
    
    NSLog(@"viewDidDisappear pauseRorationDisplayLink %@", self.transitionManager.scrollView);
    
    [self stopRotationImage];
    [self removeRotationDisplayLink];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //开启交互手势,我一般是在自定义的导航栏里面设置的,UIGestureRecognizerDelegate
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
    // Do any additional setup after loading the view.

    [self configUI];
    [self configVolumeUI];
    [self configCollectionView];
    [self configTableView];
    [self configEvents];
    [self configNotification];

    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        self.currentMusic = self.musicList[self.currentIndex];
    });

    self.lyricSelectedLine = NSNotFound;
    self.lyricRequest = [[TUDouBanLyricRequest alloc] init];
    self.douBanRequest = [[TUDouBanUserChannelRequest alloc] init];
    self.douBanRequest.type = TUDouBanRequestTypeEnd;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
    [self removeRotationDisplayLink];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private
- (void)addLikeMusicWithModel:(TUDouBanMusicModel *)model completion:(TUMusicLikeBlock)completion {
    [TUMusicLikeRequestHelper likeMusicWithSid:model.sid channelId:[TUDouBanDataHelper sharedInstance].channel.channel_id isToLike:YES completion:^(TUDouBanUserChannelRequest *request, BOOL isSuccess) {
        if (completion) {
            completion(request, isSuccess);
        }
    }];
}

- (void)removeLikeMusicModel:(TUDouBanMusicModel *)model completion:(TUMusicLikeBlock)completion {
    [TUMusicLikeRequestHelper likeMusicWithSid:model.sid channelId:[TUDouBanDataHelper sharedInstance].channel.channel_id isToLike:NO completion:^(TUDouBanUserChannelRequest *request, BOOL isSuccess) {
        if (completion) {
            completion(request, isSuccess);
        }
    }];
}

- (void)playWithMusic:(TUDouBanMusicModel *)music {
    [TUMusicManager playMusicWithUrl:music.url];
}

- (void)setMusicList:(NSMutableArray<__kindof TUDouBanMusicModel *> *)musicList currentIndex:(NSUInteger)currentIndex {
    
    if (self.musicList != nil) {
        self.musicList = musicList;

        self.currentIndex = MIN(currentIndex, musicList.count);
        self.currentMusic = musicList[self.currentIndex];
        
        [self.collectionView reloadData];

        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
            TUMusicVCCollectionCell *cell = (TUMusicVCCollectionCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
            if (self.imageView != cell.imageView) {
                self.imageView = cell.imageView;
                self.maskCDImageView = cell.maskCDImageView;
            }
        });
        
    } else {
        self.musicList = musicList;
        self.currentIndex = MIN(currentIndex, musicList.count);
        //初次进来 控件（UICollectionView）还未创建
    }
}

- (void)setCurrentMusic:(TUDouBanMusicModel *)currentMusic {
    
    if (_currentMusic == currentMusic) {
        return;
    }
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateBackImage) object:nil];
//    [self performSelector:@selector(updateBackImage) withObject:nil afterDelay:0.2];
    @weakify(self);
    [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:currentMusic.picture] placeholderImage:nil options:SDWebImageAvoidAutoSetImage|SDWebImageDelayPlaceholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        @strongify(self);
        if (!self) { return; }
        self.backgroundImageView.image = [image blurredImageWithRadius:10 iterations:2 tintColor:[UIColor blackColor]];
        [TUAnimationHelper animationFade:self.backgroundImageView duration:0.5];
        
        currentMusic.image = image;
        [AppDelegate refreshPlayMusicRemoteControlEventsWithModel:currentMusic isPlay:YES];
    }];
    
    self.preButton.enabled = [self canPlayPrevious];
    self.nextButton.enabled = [self canPlayNext];
    self.likeButton.selected = currentMusic.like;
    self.titleLabel.text = currentMusic.title;
    self.subTitleLabel.text = currentMusic.artist;
    self.progressView.value = 0;
    self.cacheProgressView.progress = 0;
    
    if (currentMusic) {
        [self stopRotationImage];
        [self playWithMusic:currentMusic];
    } else {
        [self stopRotationImage];
        [self removeRotationDisplayLink];
    }
    self.lyricSelectedLine = NSNotFound;
    self.lyric = nil;
    [self.tableView reloadData];
    _currentMusic = currentMusic;
}

- (BOOL)canPlayPrevious {
    return (self.musicList.count && _currentIndex > 0);
}

- (BOOL)canPlayNext {
    return (self.musicList.count && (_currentIndex + 1) < self.musicList.count);
}

- (void)configUI {
    [self.view sendSubviewToBack:self.backgroundImageView];
    
    if (kIs_Inch3_5) {
        self.backgroundView.image = [UIImage imageNamed:@"cm2_play_disc_mask"];
        self.imageTopConstraint.constant = 36;
        
        //0.278, 0.175
        //        self.needleImageView.layer.anchorPoint = CGPointMake(0.278, 0.175);
        self.needleImageView.image = [UIImage imageNamed:@"needle-bottombar-4"];
        self.needleHeightConstraint.constant = 80;
        self.needleTopConstraint.constant = -40 + 3;
        self.needleLeadingConstraint.constant = -28;
        self.needleTopHeightMConstraint.constant = 4;
    } else if (kIs_Inch4_0) {
        self.backgroundView.image = [UIImage imageNamed:@"cm2_play_disc_mask-ip5"];
        self.imageTopConstraint.constant = 66;
        
        //0.278, 0.175
        //        self.needleImageView.layer.anchorPoint = CGPointMake(0.278, 0.175);
        self.needleImageView.image = [UIImage imageNamed:@"needle-bottombar"];
        self.needleHeightConstraint.constant = 120;
        self.needleTopConstraint.constant = -60 + 4;
        self.needleLeadingConstraint.constant = -40;
        self.needleTopHeightMConstraint.constant = 0;
    } else if (kIs_Inch4_7) {
        self.backgroundView.image = [UIImage imageNamed:@"cm2_play_disc_mask-ip6"];
        self.imageTopConstraint.constant = 83;
        
        //0.270, 0.164
        //        self.needleImageView.layer.anchorPoint = CGPointMake(0.270, 0.164);
        self.needleImageView.image = [UIImage imageNamed:@"needle-bottombar"];
        self.needleHeightConstraint.constant = 146;
        self.needleTopConstraint.constant = -70 + 5;
        self.needleLeadingConstraint.constant = -48;
        self.needleTopHeightMConstraint.constant = 0;
        
    } else if (kIs_Inch5_5) {
        self.backgroundView.image = [UIImage imageNamed:@"cm2_play_disc_mask-ip6p"];
        self.imageTopConstraint.constant = 86;
        
        //0.253, 0.164
        //        self.needleImageView.layer.anchorPoint = CGPointMake(0.253, 0.164);
        self.needleImageView.image = [UIImage imageNamed:@"needle-bottombar"];
        self.needleHeightConstraint.constant = 160;
        self.needleTopConstraint.constant = -80 + 6;
        self.needleLeadingConstraint.constant = -55;
        self.needleTopHeightMConstraint.constant = -2;
    }
    
    self.needleImageView.layer.anchorPoint = CGPointMake(0, 0);
    
    [self.view setNeedsDisplay];
}

- (void)configCollectionView {
    CGFloat imageLeading = [TUMusicVCCollectionCell getImageLeading];
    self.imageHeightConstraint.constant = ceil(kScreenWidth - imageLeading * 2);
//    [self.collectionView layoutIfNeeded];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.itemSize = CGSizeMake(kScreenWidth, ceilf(self.imageHeightConstraint.constant));

    // 同时只允许一个手指操作
    self.collectionView.panGestureRecognizer.maximumNumberOfTouches = 1;
}

- (void)configTableView {
    CGFloat headerHeight = ceil(self.tableView.bounds.size.height / 3);
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, headerHeight)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, headerHeight)];
    self.tableView.rowHeight = 30;
}


- (void)configVolumeUI {
    // 添加并接收系统的音量条
    // 把系统音量条放在可视范围外，用我们自己的音量条来控制
    MPVolumeView *volumView = [[MPVolumeView alloc]initWithFrame:CGRectMake(-1000, -1000, 30, 30)];
    volumView.hidden = YES;
    self.volumSystemView = volumView;
    // 遍历volumView上控件，取出音量slider
    for (UIView *view in volumView.subviews) {
        if ([view isKindOfClass:[UISlider class]]) {
            // 接收系统音量条
            self.volumeSystemSlider = (UISlider *)view;
            // 把系统音量的值赋给自定义音量条
            self.volumeSlider.maximumValue = self.volumeSystemSlider.maximumValue;
            self.volumeSlider.minimumValue = self.volumeSystemSlider.minimumValue;
            self.volumeSlider.value = self.volumeSystemSlider.value;
            
            break;
        }
    }
    // 添加系统音量控件
    [self.view addSubview:volumView];
}

- (void)configEvents {
    // slider开始滑动事件
    [self.progressView addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
    // slider滑动中事件
    [self.progressView addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    // slider结束滑动事件
    [self.progressView addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
    
    // slider开始滑动事件
    [self.volumeSlider addTarget:self action:@selector(volumeSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
    // slider滑动中事件
    [self.volumeSlider addTarget:self action:@selector(volumeSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    // slider结束滑动事件
    [self.volumeSlider addTarget:self action:@selector(volumeSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
}

- (void)configNotification {
    //notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeDidChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    //监听是否触发home键挂起程序.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    //监听是否重新进入程序程序.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)configLyric:(DDAudioLRC *)lrc {
    self.lyric = lrc;
    [self.tableView reloadData];
    if (self.lyric.units.count == 0) {
        self.lyricSelectedLine = 0;
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
}

- (void)updateLyricView:(NSNumber *)currentTime {
    NSRange range = [self.lyric linesAtTimeSecondFrom:0 to:[currentTime floatValue]];
        NSUInteger index = range.length - 1;
    if (range.location == 0 && index < self.lyric.units.count) {
        if (index != self.lyricSelectedLine) {
            _lyricSelectedLine = index;
            if (!self.isAnimating) {
                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            }
        }
    }
}

#pragma mark - Animation
- (void)startAnimating {
    self.isAnimating = YES;
    self.collectionView.userInteractionEnabled = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(endAnimating) object:nil];
    [self performSelector:@selector(endAnimating) withObject:nil afterDelay:1.0 inModes:@[NSRunLoopCommonModes]];
}

- (void)endAnimating {
    self.isAnimating = NO;
    self.collectionView.userInteractionEnabled = YES;
    if (self.isShowingLyric) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.lyricSelectedLine == NSNotFound ? 0 : self.lyricSelectedLine inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
}

- (void)rotationImage {
    dispatch_async(dispatch_get_main_queue(), ^{
        //start Animation
        [self startRorationNeedleImage:^(BOOL finished) {
            if (self.isViewShowing && !self.isShowingLyric) {
                [self startRotationDisplaylink];
            }
        }];
    });
}

- (void)stopRotationImage {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self pauseRorationDisplayLink];
        [self resetNeedleImage];
    });
}

- (void)startRorationNeedleImage:(void(^)(BOOL finished))completion {
    if (CGAffineTransformEqualToTransform(self.needleImageView.transform, CGAffineTransformIdentity)) {
        if (completion) {
            completion(YES);
        }
        return;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.needleImageView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if (completion) {
            completion(finished);
        }
    }];
}

- (void)resetNeedleImage {
    if (!CGAffineTransformEqualToTransform(self.needleImageView.transform, CGAffineTransformIdentity)) {
        return;
    }
    
    CGFloat angle = -M_PI * 0.18;
    [UIView animateWithDuration:0.3 animations:^{
        self.needleImageView.transform = CGAffineTransformMakeRotation(angle);
    } completion:^(BOOL finished) {
    }];
}

- (void)startRotationDisplaylink {
    if (self.rotationDisplaylink == nil) {
        self.rotationDisplaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateImageDisplay)];
        [self.rotationDisplaylink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        NSLog(@"*****startRotationDisplaylink");
    } else if ([self.rotationDisplaylink isPaused]) {
        [self.rotationDisplaylink setPaused:NO];
    }
}

-(void)removeRotationDisplayLink {
    if (self.rotationDisplaylink) {
        [self.rotationDisplaylink invalidate];
        self.rotationDisplaylink = nil;
        NSLog(@"*****removeRotationDisplayLink");
    }
}

- (void)pauseRorationDisplayLink {
    if (_rotationDisplaylink && ![_rotationDisplaylink isPaused]) {
        [_rotationDisplaylink setPaused:YES];
        NSLog(@"*****pauseRorationDisplayLink");
    }
}

- (void)updateImageDisplay {
    if (!self.imageView) {
        return;
    }
    CGAffineTransform t = CGAffineTransformRotate(self.imageView.transform, kDefaultAngle);
    self.imageView.transform = t;
    self.maskCDImageView.transform = t;
}

//- (void)addCDMask {
//    CAGradientLayer *layer = [CAGradientLayer layer];
//    CGFloat width = ceil(kScreenWidth - self.imageLeadingContraint.constant * 2);
//    layer.frame = CGRectMake(0, 0, width, width);
//    layer.colors = @[(id)[UIColor whiteColor].CGColor,(id)[UIColor  clearColor].CGColor,(id)[UIColor whiteColor].CGColor];
//    layer.locations = @[@(0.2),@(0.5),@(0.8)];
//    layer.startPoint = CGPointMake(0, 0);
//    layer.endPoint = CGPointMake(1, 0);
//    self.backCDImageView.layer.mask = layer;
//}

#pragma mark - Notification
- (void)volumeDidChanged:(NSNotification *)notification {
    //    self.volume.hidden = NO;
    if (!self.isDraggingVolumeSlider) {
        NSString *volumeS = notification.userInfo[@"AVSystemController_AudioVolumeNotificationParameter"];
        self.volumeSlider.value = volumeS.floatValue;
    }
}

// 进入前台
- (void)applicationDidBecomeActive {
    self.isViewShowing = YES;
    if ([[TUMusicManager sharedInstance] isPlaying]) {
        TUMusicVCCollectionCell *cell = (TUMusicVCCollectionCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
        self.imageView = cell.imageView;
        self.maskCDImageView = cell.maskCDImageView;
        [self rotationImage];
    }
}

// 进入后台 即将挂起
- (void)applicationWillResignActive {
//    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    self.isViewShowing = NO;
    if ([[TUMusicManager sharedInstance] isPlaying]) {
        [self pauseRorationDisplayLink];
    }
}

#pragma mark - Action
#pragma mark - Action Nav
- (IBAction)onBackButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onShareButtonClick:(UIButton *)sender {
    
}

#pragma mark - Action Bottom
- (IBAction)onPlayButtonClick {
    if (self.playButton.selected) {
        [self pausePlay];
    } else {
        if ([[TUMusicManager sharedInstance] currentTime] == [[TUMusicManager sharedInstance] totalTime]) {
            [[TUMusicManager sharedInstance] seekToTime:0 completionHandler:^(BOOL finished) {
                [self continuePlay];
            }];
        } else {
            [self continuePlay];
        }
    }
}

- (void)continuePlay {
    [[TUMusicManager sharedInstance] play];
    self.playButton.selected = YES;
    [self rotationImage];
    [AppDelegate refreshPlayMusicRemoteControlEventsWithModel:[self.class playingModel] isPlay:YES];
}

- (void)pausePlay {
    [[TUMusicManager sharedInstance] pause];
    self.playButton.selected = NO;
    [self stopRotationImage];
    [AppDelegate refreshPlayMusicRemoteControlEventsWithModel:[self.class playingModel] isPlay:NO];
}

- (IBAction)onLoopButtonClick {
    if (self.loopButton.loopState < TULoopButtonStateMax) {
        self.loopButton.loopState ++;
    } else {
        self.loopButton.loopState = TULoopButtonStateOne;
    }
}

- (IBAction)onPreButtonClick {
    if (self.isAnimating) {
        return;
    }
    
    [self startAnimating];
    
    if ([self canPlayPrevious]) {
//        _currentIndex--;
//        self.currentMusic = self.musicList[_currentIndex];
        [self stopRotationImage];
        self.imageView = nil;
        self.maskCDImageView = nil;
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

- (IBAction)onNextButtonClick {
    if (self.isAnimating) {
        return;
    }
    
    [self startAnimating];
    
    if ([self canPlayNext]) {
//        _currentIndex++;
//        self.currentMusic = self.musicList[_currentIndex];
        
        [self stopRotationImage];
        self.imageView = nil;
        self.maskCDImageView = nil;
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

- (IBAction)onMenuButtonClick {
    TUMusicDataMenuController *vc = [[TUMusicDataMenuController alloc] init];
    [vc setDataSource:self.musicList currentIndex:self.currentIndex];
    vc.view.backgroundColor = [UIColor clearColor];
    @weakify(self);
    [vc setDidSelectedBlockAtIndexPat:^(NSIndexPath *indexPath) {
        @strongify(self);
        if (!self) { return; }
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        self.currentIndex = indexPath.row;
        self.currentMusic = self.musicList[self.currentIndex];
    }];
    self.transitionManager = [[TUDragModalTransition alloc] initWithViewController:vc scrollView:vc.tableView];
    self.transitionManager.behindViewAlpha = 1;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:vc animated:true completion: nil];
    vc.transitioningDelegate = self.transitionManager;
    self.dataMenuController = vc;
}

#pragma mark - Action Setting
- (IBAction)onSettingLikeButtonClick:(TUIBButton *)sender {
    if (![TUUserManager isDouBanLogin]) {
        [self presentViewController:[TUDouBanLoginController loginControllerWithSuccess:^{
            [self changeLikeWithCompletion:nil];
        } cancel:nil] animated:YES completion:nil];
    } else {
        [self changeLikeWithCompletion:nil];
    }
}

- (void)changeLikeWithCompletion:(TUMusicLikeBlock)completion {
    if (![TUUserManager isDouBanLogin]) {
        if (completion) {
            completion(nil, NO);
        }
        return;
    }
    
    UIButton *sender = self.likeButton;
    
    @weakify(self);
    if (!sender.selected) {
        [self addLikeMusicWithModel:self.currentMusic completion:^(TUDouBanUserChannelRequest *request, BOOL isSuccess) {
            @strongify(self);
            if (!self) { return; }
            
            if (isSuccess && [request.sid isEqualToString:self.currentMusic.sid]) {
                self.currentMusic.like = YES;
                [[TUDouBanDataHelper sharedInstance] updateMusicItem:self.currentMusic];

                [AppDelegate refreshPlayMusicRemoteControlEventsWithModel:self.currentMusic isPlay:YES];
                
                sender.selected = YES;
                sender.transform = CGAffineTransformMakeScale(0, 0);
                [UIView animateWithDuration:0.2 animations:^{
                    sender.transform = CGAffineTransformMakeScale(1.3, 1.3);
                } completion:^(BOOL finished){
                    [UIView animateWithDuration:0.1 animations:^{
                        sender.transform = CGAffineTransformIdentity;
                    }];
                }];
            }
            
            if (completion) {
                completion(request, isSuccess);
            }
        }];
        
    } else {
        [self removeLikeMusicModel:self.currentMusic completion:^(TUDouBanUserChannelRequest *request, BOOL isSuccess) {
            @strongify(self);
            if (!self) { return; }
            
            if (isSuccess && [request.sid isEqualToString:self.currentMusic.sid]) {
                self.currentMusic.like = NO;
                [[TUDouBanDataHelper sharedInstance] updateMusicItem:self.currentMusic];
                
                [AppDelegate refreshPlayMusicRemoteControlEventsWithModel:self.currentMusic isPlay:YES];
                sender.selected = NO;
            }
            
            if (completion) {
                completion(request, isSuccess);
            }
        }];
    }
}

- (IBAction)onSettingDownloadButtonClick:(TUIBButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)onSettingCommentButtonClick:(TUIBButton *)sender {
    sender.selected = !sender.selected;
    self.commentCountLabel.hidden = !sender.selected;
    UIViewController *tempVc = [[UIViewController alloc] init];
    tempVc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:tempVc animated:YES];
}

- (IBAction)onSettingMoreButtonClick:(UIButton *)sender {
    TUMusicSettingMoreController *vc = [[TUMusicSettingMoreController alloc] init];
    vc.view.backgroundColor = [UIColor clearColor];
    self.transitionManager = [[TUDragModalTransition alloc] initWithViewController:vc scrollView:vc.tableView];
    self.transitionManager.behindViewAlpha = 1;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:vc animated:true completion: nil];
    vc.transitioningDelegate = self.transitionManager;
}

#pragma mark - Action Slider

// slider开始滑动事件
- (void)progressSliderTouchBegan:(UISlider *)slider {
    _isDraggingProgress = YES;
}

// slider滑动中事件
- (void)progressSliderValueChanged:(UISlider *)slider {
    self.startTimeLabel.text = [TUMusicHelper stringWithDuration:slider.value];
}

// slider结束滑动事件
- (void)progressSliderTouchEnded:(UISlider *)slider {
    [[TUMusicManager sharedInstance] seekToTime:slider.value completionHandler:^(BOOL finished) {
        NSLog(@"seek next currentTime:%f", [[TUMusicManager sharedInstance] currentTime]);
        _isDraggingProgress = NO;
        if (finished) {
            [AppDelegate refreshPlayMusicRemoteControlEventsWithModel:[self.class playingModel] isPlay:YES];
        }
    }];
}

// volume slider开始滑动事件
- (void)volumeSliderTouchBegan:(UISlider *)slider {
    self.isDraggingVolumeSlider = YES;
}

- (void)volumeSliderValueChanged:(TUIBSlider *)volumeSlider {
    self.volumeSystemSlider.value = volumeSlider.value;
}

- (void)volumeSliderTouchEnded:(TUIBSlider *)sender {
    self.isDraggingVolumeSlider = NO;
}


#pragma mark - Action View
- (IBAction)onBackViewTap {
    if (self.isAnimating) {
        return;
    }
    [self showLyricView:!self.isShowingLyric];
}

- (void)showLyricView:(BOOL)show {
    self.isShowingLyric = show;

    if (show) {
        [self pauseRorationDisplayLink];
    }
    
    if (show && self.tableView.maskView == nil) {
        UIImageView *mask = [[UIImageView alloc] init];
        mask.image = [UIImage imageNamed:@"cm2_table_mask"];
        self.tableView.maskView = mask;
        mask.frame = self.tableView.bounds;
    }
    
    self.isAnimating = YES;
    
    self.collectionView.hidden = NO;
    self.needleImageView.hidden = NO;
    self.needleTopImageView.hidden = NO;
    self.likeView.hidden = NO;
    self.backgroundView.hidden = NO;
    self.volumeBackView.hidden = NO;
    self.tableView.hidden = NO;
    self.navBottomLineView.hidden = NO;
    self.volumSystemView.hidden = !show;
    
    if (show) {
        self.volumeSlider.value = self.volumeSystemSlider.value;
        
        self.collectionView.alpha = 1;
        self.needleImageView.alpha = 1;
        self.needleTopImageView.alpha = 1;
        self.likeView.alpha = 1;
        self.backgroundView.alpha = 1;
        
        self.tableView.alpha = 0;
        self.volumeBackView.alpha = 0;
        self.navBottomLineView.alpha = 1;
        
//        [self.tableView reloadData];
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.lyricSelectedLine == NSNotFound ? 0 : self.lyricSelectedLine inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
        [self scrollViewDidScroll:self.tableView];
        
        CGFloat tableHeight = self.tableView.bounds.size.height;
        NSArray *cells = [self.tableView visibleCells];
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(endAnimating) object:nil];
        [self performSelector:@selector(endAnimating) withObject:nil afterDelay:cells.count * 0.05 + 1.5 inModes:@[NSRunLoopCommonModes]];
        
        [UIView animateWithDuration:0.5 animations:^{
            self.needleImageView.alpha = 0;
        } completion:^(BOOL finished) {
            self.needleImageView.hidden = YES;
            self.needleImageView.alpha = 1;
            [UIView animateWithDuration:0.5 animations:^{
                self.volumeBackView.alpha = 1;
                self.navBottomLineView.alpha = 0;
            } completion:^(BOOL finished) {
                self.navBottomLineView.hidden = YES;
                self.navBottomLineView.alpha = 1;
            }];
        }];
        
        [UIView animateWithDuration:1 animations:^{
            self.collectionView.alpha = 0;
            self.needleTopImageView.alpha = 0;
            self.likeView.alpha = 0;
            self.backgroundView.alpha = 0;
            self.tableView.alpha = 1;
        } completion:^(BOOL finished) {
            self.collectionView.hidden = YES;
            self.likeView.hidden = YES;
            self.backgroundView.hidden = YES;
            self.needleTopImageView.hidden = YES;
            self.needleTopImageView.alpha = 1;
            self.collectionView.alpha = 1;
            
            self.likeView.alpha = 1;
            self.backgroundView.alpha = 1;
        }];
        
        NSInteger index = 0;
        for (UITableViewCell *cell in cells) {
            cell.alpha = 1;
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight);
            [UIView animateWithDuration:1.5 delay:0.05 * index usingSpringWithDamping:0.8 initialSpringVelocity:0 options:0 animations:^{
                cell.transform = CGAffineTransformIdentity;
            } completion:nil];
            index += 1;
        }
    } else {
        self.collectionView.alpha = 0;
        self.needleImageView.alpha = 0;
        self.needleTopImageView.alpha = 0;
        self.likeView.alpha = 0;
        self.backgroundView.alpha = 0;
        self.tableView.alpha = 1;
        self.volumeBackView.alpha = 1;
        self.navBottomLineView.alpha = 0;

//        [self.tableView reloadData];
        
        CGFloat tableHeight = self.tableView.bounds.size.height;
        NSArray *cells = [self.tableView visibleCells];
        
        NSInteger index = cells.count - 1;
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(endAnimating) object:nil];
        [self performSelector:@selector(endAnimating) withObject:nil afterDelay:index * 0.05 + 1.5 inModes:@[NSRunLoopCommonModes]];
        
        [UIView animateWithDuration:1.0 animations:^{
            self.volumeBackView.alpha = 0;
            self.navBottomLineView.alpha = 1;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.needleTopImageView.alpha = 0.8;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.3 animations:^{
                    self.needleImageView.alpha = 1;
                    self.needleTopImageView.alpha = 1;
                } completion:^(BOOL finished) {
                    self.volumeBackView.hidden = YES;
                    self.volumeBackView.alpha = 1;
                    if ([[TUMusicManager sharedInstance] isPlaying]) {
                        [self rotationImage];
                    }
                }];
            }];
        }];
        
        [UIView animateWithDuration:1.5 + index * 0.05 animations:^{
            self.collectionView.alpha = 1;
            //            self.needleImageView.alpha = 1;
//                        self.needleTopImageView.alpha = 1;
            self.likeView.alpha = 1;
            self.backgroundView.alpha = 1;
            self.tableView.alpha = 0;
            //            self.volumeBackView.alpha = 0;
        } completion:^(BOOL finished) {
            self.tableView.hidden = YES;
            //            self.volumeBackView.hidden = YES;
            //            self.volumeBackView.alpha = 1;
            self.tableView.alpha = 1;
        }];
        
        for (UITableViewCell *cell in cells) {
            cell.alpha = 1;
            cell.transform = CGAffineTransformIdentity;
            [UIView animateWithDuration:1.5 delay:0.05 * index usingSpringWithDamping:0.8 initialSpringVelocity:0 options:0 animations:^{
                cell.transform = CGAffineTransformMakeTranslation(0, tableHeight);
            } completion:^(BOOL finished) {
                cell.alpha = 0;
                cell.transform = CGAffineTransformIdentity;
            }];
            index -= 1;
        }
    }
}

#pragma mark - Delegate

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lyric.units.count == 0 ? 1 : self.lyric.units.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TUMusicLyricCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TUMusicLyricCell"];
    if (self.lyric.units.count) {
        DDAudioLRCUnit *model = self.lyric.units[indexPath.row];
        [cell setLrcModel:model];
    } else {
        if (self.lyric.originLRCText.length > 20
            || self.lyric.originLRCText.length == 0
            || [self.lyric.originLRCText isEqualToString:@" "]) {
            cell.lrcLabel.text = @"没有歌词";
        } else {
            cell.lrcLabel.text = self.lyric.originLRCText;
        }
    }
    
    return cell;
}


#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.musicList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGAffineTransform imageTransform = CGAffineTransformIdentity;
    CGAffineTransform maskCDImageTransform = CGAffineTransformIdentity;

    if (_currentIndex == indexPath.item && self.imageView != nil) {
        imageTransform = self.imageView.transform;
        maskCDImageTransform = self.maskCDImageView.transform;
    }
    TUMusicVCCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TUMusicVCCollectionCell" forIndexPath:indexPath];
    [cell setMusic:self.musicList[indexPath.row]];
    if (_currentIndex == indexPath.item) {
        cell.imageView.transform = imageTransform;
        cell.maskCDImageView.transform = maskCDImageTransform;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self onBackViewTap];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _tableView && self.isShowingLyric) {
        self.tableView.maskView.frame = self.tableView.bounds;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == _collectionView) {
        NSLog(@"%s", __func__);
        [self stopRotationImage];
        self.imageView = nil;
        self.maskCDImageView = nil;
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (scrollView == _collectionView) {
        
        NSLog(@"%s", __func__);
        
        [self startAnimating];
    }
}

//// 代码触发的滑动
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView == _collectionView) {
        
        NSLog(@"%s", __func__);
        [self scrollViewDidEndDecelerating:self.collectionView];
    }
}

// 拖拽触发的滑动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _collectionView) {
        NSLog(@"%s", __func__);
        
        NSUInteger index = MIN(self.musicList.count, (self.collectionView.contentOffset.x + kScreenWidth * 0.5) / kScreenWidth);
        
        if (_currentIndex != index) {
            _currentIndex = index;
            self.currentMusic = self.musicList[index];
        } else if (self.isViewShowing) {
            TUMusicVCCollectionCell *cell = (TUMusicVCCollectionCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
            self.imageView = cell.imageView;
            self.maskCDImageView = cell.maskCDImageView;
            if ([[TUMusicManager sharedInstance] isPlaying]) {
                [self rotationImage];
            }
        }
    }
}

#pragma mark - TUMusicManagerDelegate
- (void)playMusicDidStartWithTotalTime:(NSTimeInterval)time {
    //    NSLog(@"%s total:%f", __func__, time);
    
    TUMusicVCCollectionCell *cell = (TUMusicVCCollectionCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
    self.imageView = cell.imageView;
    self.maskCDImageView = cell.maskCDImageView;
    
    [self rotationImage];
    
    self.playButton.selected = YES;
    self.progressView.minimumValue = 0;
    self.progressView.maximumValue = time;
    self.progressView.value = 0;
    self.endTimeLabel.text = [TUMusicHelper stringWithDuration:time];
    self.startTimeLabel.text = @"00:00";
    [AppDelegate refreshPlayMusicRemoteControlEventsWithModel:self.currentMusic isPlay:YES];
    
    // 更新菜单
    [self.dataMenuController setDataSource:self.musicList currentIndex:self.currentIndex];
    
    @weakify(self);
    // 歌词
    self.lyricRequest.sid = self.currentMusic.sid;
    self.lyricRequest.ssid = self.currentMusic.ssid;
    
    [self.lyricRequest sendRequestWithCache:^(__kindof TUBaseRequest * _Nonnull baseRequest, id  _Nullable cacheResult, NSError * _Nonnull error) {
        @strongify(self);
        if (!self) { return; }
        if (error == nil) {
//            NSLog(@"cacheResult:%@", cacheResult);
            DDAudioLRC *lrc = [DDAudioLRCParser parserLRCText:cacheResult[@"lyric"]];
            [self configLyric:lrc];
        }
    } success:^(__kindof TUBaseRequest * _Nonnull baseRequest, id  _Nullable responseObject) {
        @strongify(self);
        if (!self) { return; }
//        NSLog(@"responseObject:%@", responseObject);
        DDAudioLRC *lrc = [DDAudioLRCParser parserLRCText:responseObject[@"lyric"]];
        [self configLyric:lrc];
    } failur:^(__kindof TUBaseRequest * _Nonnull baseRequest, NSError * _Nonnull error) {
        NSLog(@"error:%@", error);
    }];
    
    // 第一次进入的时候为保证下一首的按钮可以点击 预先请求一次
    if (![self canPlayNext] && self.musicList.count == 1) {
        [[TUDouBanDataHelper sharedInstance] musicPlayerGetNextSongsWithCurrentMusic:_currentMusic isSkip:YES competion:^(NSMutableArray<__kindof TUDouBanMusicModel *> *musicList, NSUInteger currentIndex) {
            @strongify(self);
            if (!self) { return; }
            if (musicList.count && currentIndex < musicList.count) {
                
                NSMutableArray *indexs = [NSMutableArray array];
                for (NSInteger i = self.musicList.count; i < musicList.count; i ++) {
                    [indexs addObject:[NSIndexPath indexPathForItem:i inSection:0]];
                }
                self.musicList = [NSMutableArray arrayWithArray:musicList];
                [self.collectionView insertItemsAtIndexPaths:indexs];
                
//                [self.collectionView reloadData];
//                TUMusicVCCollectionCell *cell = (TUMusicVCCollectionCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
//                if (self.imageView != cell.imageView) {
//                    self.imageView = cell.imageView;
//                    self.maskCDImageView = cell.maskCDImageView;
//                }
                
                self.preButton.enabled = [self canPlayPrevious];
                self.nextButton.enabled = [self canPlayNext];
            }
        }];
    }
}

- (void)playingMusicWithCurrentTime:(NSTimeInterval)currentTime progress:(CGFloat)progress {
    if (self.lyric.units.count) {
        //        [self performSelector:@selector(updateLyricView:) withObject:@(currentTime) afterDelay:0 inModes:@[NSDefaultRunLoopMode]];
        [self updateLyricView:@(currentTime)];
    }
    
    if (_isDraggingProgress) {
        return;
    }
    
    self.progressView.value = currentTime;
    self.startTimeLabel.text = [TUMusicHelper stringWithDuration:currentTime];
}

- (void)playMusicDidLoadCacheBufferTime:(NSTimeInterval)time {
    [self.cacheProgressView setProgress:time / [[TUMusicManager sharedInstance] totalTime] animated:YES];
}

- (void)playMusicDidEnd:(NSString *)url {
    NSLog(@"播放结束了");
    if ([url isEqualToString:self.currentMusic.url]) {
        // 报告豆瓣播放结束
        self.douBanRequest.sid = self.currentMusic.sid;
        self.douBanRequest.channel_id = [TUDouBanDataHelper sharedInstance].channel.channel_id;
        [self.douBanRequest sendRequestWithSuccess:^(__kindof TUBaseRequest * _Nonnull baseRequest, id  _Nullable responseObject) {
            NSLog(@"报告豆瓣播放结束%@", responseObject);
        } failur:^(__kindof TUBaseRequest * _Nonnull baseRequest, NSError * _Nonnull error) {
            
        }];
    }
    
    [self stopRotationImage];
    self.imageView.transform = CGAffineTransformIdentity;
    self.maskCDImageView.transform = CGAffineTransformIdentity;
    [self.collectionView reloadData];
    
    self.playButton.selected = NO;
    
    if (self.loopButton.loopState == TULoopButtonStateOne) {
        // 单曲循环
        [self onPlayButtonClick];
    } else if (self.loopButton.loopState == TULoopButtonStateShuffle) {
        // 随机循环
        if ([self canPlayNext]) {
            [self onNextButtonClick];

            // 获取下一个列表
            @weakify(self);
            [[TUDouBanDataHelper sharedInstance] musicPlayerGetNextSongsWithCurrentMusic:_currentMusic isSkip:NO competion:^(NSMutableArray<__kindof TUDouBanMusicModel *> *musicList, NSUInteger currentIndex) {
                @strongify(self);
                if (!self) { return; }
                NSMutableArray *indexs = [NSMutableArray array];
                for (NSInteger i = self.musicList.count; i < musicList.count; i ++) {
                    [indexs addObject:[NSIndexPath indexPathForItem:i inSection:0]];
                }
                self.musicList = [NSMutableArray arrayWithArray:musicList];
                [self.collectionView insertItemsAtIndexPaths:indexs];
                
                self.preButton.enabled = [self canPlayPrevious];
                self.nextButton.enabled = [self canPlayNext];
            }];
            
            self.preButton.enabled = [self canPlayPrevious];
            self.nextButton.enabled = [self canPlayNext];
        }
    } else {
        // 列表循环
        [self onNextButtonClick];
    }
}

- (void)playMusicDidStop:(NSString *)url {
    NSLog(@"被手动切换了 %s", __func__);
    if ([self canPlayNext]) {
        return;
    }
    NSLog(@"手动切换获取下一曲");
    @weakify(self);
    [[TUDouBanDataHelper sharedInstance] musicPlayerGetNextSongsWithCurrentMusic:_currentMusic isSkip:YES competion:^(NSMutableArray<__kindof TUDouBanMusicModel *> *musicList, NSUInteger currentIndex) {
        @strongify(self);
        if (!self) { return; }
        
        if (musicList.count && currentIndex < musicList.count && ![[TUMusicManager sharedInstance] isPlaying]) {
            [self setMusicList:musicList currentIndex:currentIndex];
        } else if (musicList.count && currentIndex < musicList.count) {
            NSMutableArray *indexs = [NSMutableArray array];
            for (NSInteger i = self.musicList.count; i < musicList.count; i ++) {
                [indexs addObject:[NSIndexPath indexPathForItem:i inSection:0]];
            }
            self.musicList = [NSMutableArray arrayWithArray:musicList];
            [self.collectionView insertItemsAtIndexPaths:indexs];

            self.preButton.enabled = [self canPlayPrevious];
            self.nextButton.enabled = [self canPlayNext];
        }
    }];
}

- (void)playMusicWhenInterruptionBegin:(NSDictionary *)userInfo {
    [self.class onPause];
}

- (void)playMusicWhenInterruptionEnd:(NSDictionary *)userInfo {
    [self.class onPlay];
}

- (void)playMusicWhenHeadphonePlugged:(NSDictionary *)userInfo {
    // 耳机插入了 直接播放音乐
//    if (self.currentMusic) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.class onPlay];
//        });
//    }
}

- (void)playMusicWhenHeadphonePulled:(NSDictionary *)userInfo {
    // 耳机拔掉了 系统会自动暂停播放 更新UI
    if (self.currentMusic) {
        // 必须主线程 修改 UI (ios9 会报错)
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.class onPause];
        });
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end


