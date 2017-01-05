//
//  TUDouBanChannelController.m
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/10.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import "TUDouBanChannelController.h"
#import "TUDouBanChannelRequest.h"
#import "TUDouBanChannelModel.h"
#import "TUDouBanMusicModel.h"
#import "TUDefaultCell.h"
#import "TUMusicPlayingController.h"
#import "TUMusicManager.h"
#import <MJRefresh.h>
#import "TUDouBanUserModel.h"
#import "TUUserManager.h"
#import "TUDouBanUserChannelRequest.h"
#import "TUMusicManager.h"
#import "TUDouBanDataHelper.h"
#import <MJExtension.h>
#import "TUDouBanLoginController.h"
#import "TUDouBanRedHeartRequest.h"

@interface TUDouBanChannelController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;     // 模型数据
@property (nonatomic, strong) TUDouBanChannelRequest *channelRequest;
@property (nonatomic, strong) TUDouBanUserChannelRequest *userChannelRequest;

@end

@implementation TUDouBanChannelController

+ (instancetype)channelControllerWithChannel:(TUDouBanChannelModel *)channel {
    TUDouBanChannelController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TUDouBanChannelController"];
    vc.channel = channel;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    if (self.isRedHeart) {
        self.title = @"我的红心";
    } else {
        self.title = self.channel.name;
    }
    
    self.dataSource = [NSMutableArray array];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDouBanLogin) name:kDouBanUserLoginSuccessed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDouBanLogout) name:kDouBanUserLogoutSuccessed object:nil];

    self.tableView.rowHeight = [TUDefaultCell height];
    [self.tableView registerNib:[UINib nibWithNibName:@"TUDefaultCell" bundle:nil] forCellReuseIdentifier:@"TUDefaultCell"];
    
    @weakify(self);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        if (!self) { return; }
        [self requestDataIsHeaderRefresh:YES];
    }];
    self.tableView.mj_header = header;
    header.lastUpdatedTimeLabel.hidden = true;
    
    [header beginRefreshing];
}

- (void)onDouBanLogin {
    [self requestDataIsHeaderRefresh:YES];
}

- (void)onDouBanLogout {
    [self requestDataIsHeaderRefresh:YES];
}

- (void)requestDataIsHeaderRefresh:(BOOL)isHeaderRefresh {
    @weakify(self);
    [self requestMoreData:^(NSMutableArray *array, NSError *error) {
        @strongify(self);
        if (!self) { return; }
        [self.tableView.mj_header endRefreshing];
        [self refreshPageData:array];
    }];
}

- (void)requestMoreData:(void(^)(NSMutableArray *array, NSError *error))completion {
    
    if (self.isRedHeart) {
        if (![TUUserManager isDouBanLogin]) {
            // 去登录
            @weakify(self);
            TUDouBanLoginController *vc = [TUDouBanLoginController loginControllerWithSuccess:^{
                [weak_self getRedHeartData:completion];
            } cancel:^{
                
            }];
            [self presentViewController:vc animated:YES completion:nil];
        } else {
            [self getRedHeartData:completion];
        }
        return;
    }
    
    if ([TUUserManager isDouBanLogin]) {
        [self.userChannelRequest sendRequestWithSuccess:^(__kindof TUBaseRequest * _Nonnull baseRequest, id  _Nullable responseObject) {
            NSMutableArray *array = [TUDouBanMusicModel mj_objectArrayWithKeyValuesArray:responseObject[@"song"]];
            if (completion) {
                completion(array, nil);
            }
        } failur:^(__kindof TUBaseRequest * _Nonnull baseRequest, NSError * _Nonnull error) {
            NSLog(@"%@",error.description);
            if (completion) {
                completion(nil, error);
            }
        }];
    } else {
        [self.channelRequest sendRequestWithSuccess:^(__kindof TUBaseRequest * _Nonnull baseRequest, id  _Nullable responseObject) {
            NSMutableArray *array = [TUDouBanMusicModel mj_objectArrayWithKeyValuesArray:responseObject[@"song"]];
            if (completion) {
                completion(array, nil);
            }
        } failur:^(__kindof TUBaseRequest * _Nonnull baseRequest, NSError * _Nonnull error) {
            NSLog(@"%@",error.description);
            if (completion) {
                completion(nil, error);
            }
        }];
    }
}

- (void)getRedHeartData:(void(^)(NSMutableArray *array, NSError *error))completion {
    //1 先获取所有的sid
    @weakify(self);
    TUDouBanRedHeartSidsRequest *sidRequest = [[TUDouBanRedHeartSidsRequest alloc] init];
    [sidRequest sendRequestWithSuccess:^(__kindof TUBaseRequest * _Nonnull baseRequest, id  _Nullable responseObject) {
        //2组装sid数组
        @strongify(self);
        if (!self) { return; }
        
        NSArray *sidsArray = responseObject[@"songs"];
        if ([sidsArray isKindOfClass:[NSArray class]] && sidsArray.count) {
            NSMutableArray *sids = [NSMutableArray arrayWithCapacity:sidsArray.count];
            for (int i = 0; i < sidsArray.count; i ++) {
                NSDictionary *dict = sidsArray[i];
                NSString *sid = dict[@"sid"];
                if ([sid isKindOfClass:[NSString class]] && sid.length) {
                    [sids addObject:sid];
                }
            }
            
            //3根据sid获取歌曲信息
            TUDouBanRedHeartRequest *songRequest = [[TUDouBanRedHeartRequest alloc] init];
            songRequest.sids = sids;
            [songRequest sendRequestWithSuccess:^(__kindof TUBaseRequest * _Nonnull baseRequest, id  _Nullable responseObject) {
                @strongify(self);
                if (!self) { return; }
                
                NSArray *songsArray = responseObject;
                if ([songsArray isKindOfClass:[NSArray class]] && songsArray.count) {
                    NSMutableArray *array = [NSMutableArray arrayWithCapacity:songsArray.count];
                    for (int i = 0; i < songsArray.count; i ++) {
                        TUDouBanMusicModel *model = [TUDouBanMusicModel mj_objectWithKeyValues:songsArray[i]];
                        model.like = YES;
                        [array addObject:model];
                    }
//                    NSMutableArray *array = [TUDouBanMusicModel mj_objectArrayWithKeyValuesArray:songsArray];
                    if (completion) {
                        completion(array, nil);
                    }
                }
                
            } failur:^(__kindof TUBaseRequest * _Nonnull baseRequest, NSError * _Nonnull error) {
                NSLog(@"获取songs失败:%@", error);
                if (completion) {
                    completion(nil, error);
                }
            }];
        }
        
    } failur:^(__kindof TUBaseRequest * _Nonnull baseRequest, NSError * _Nonnull error) {
        NSLog(@"获取sids失败:%@", error);
        if (completion) {
            completion(nil, error);
        }
    }];
}

- (void)refreshPageData:(NSArray *)array {
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:array];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TUDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TUDefaultCell"];
    TUDouBanMusicModel *model = self.dataSource[indexPath.row];
    [cell setInfo:model];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [[TUDouBanDataHelper sharedInstance] changeMusicList:self.dataSource withChannel:self.channel];

    TUMusicPlayingController *vc = [TUMusicPlayingController musicControllerWithMusicList:self.dataSource currentIndex:indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter
- (TUDouBanChannelRequest *)channelRequest {
    if (!_channelRequest) {
        _channelRequest = [[TUDouBanChannelRequest alloc] init];
        _channelRequest.channel_id = _channel.channel_id;
    }
    return _channelRequest;
}

- (TUDouBanUserChannelRequest *)userChannelRequest {
    if (!_userChannelRequest) {
        _userChannelRequest = [[TUDouBanUserChannelRequest alloc] init];
        _userChannelRequest.channel_id = _channel.channel_id;
    }
    _userChannelRequest.type = TUDouBanRequestTypeNewList;

    if ([[TUMusicManager sharedInstance] isPlaying]) {
        _userChannelRequest.type = TUDouBanRequestTypePlayingList;
        _userChannelRequest.sid = [TUMusicPlayingController playingModel].sid;
    }
    
    return _userChannelRequest;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
