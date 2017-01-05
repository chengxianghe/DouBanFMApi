//
//  TUDouBanChannelListController.m
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/10.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import "TUDouBanChannelListController.h"
#import "TUDouBanChannelListRequest.h"
#import "TUDouBanChannelModel.h"
#import "TUDouBanChannelController.h"
#import "TUMusicManager.h"
#import <MJRefresh.h>
#import "TUDouBanLoginController.h"
#import "TUUserManager.h"
#import <MJExtension.h>
#import "TUDouBanChannelGroup.h"
#import "MusicIndicator.h"
#import "TUDouBanDataHelper.h"
#import "TUMusicPlayingController.h"

@interface TUDouBanChannelListController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<__kindof TUDouBanChannelGroup *> *dataSource;     // 模型数据
@property (nonatomic, strong) TUDouBanChannelListRequest *channelListRequest;

@end

@implementation TUDouBanChannelListController

- (instancetype)init {
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TUDouBanChannelListController"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateIndicatorState];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"豆瓣FM";
    
    self.dataSource = [NSMutableArray array];
    
    self.tableView.rowHeight = 44;
    self.channelListRequest = [[TUDouBanChannelListRequest alloc] init];
    
    @weakify(self);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        if (!self) { return; }
        [self requestDataIsHeaderRefresh:YES];
    }];
    self.tableView.mj_header = header;
    header.lastUpdatedTimeLabel.hidden = true;
    [header beginRefreshing];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(douBanLoginNotification) name:kDouBanUserLoginSuccessed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(douBanLogoutNotification) name:kDouBanUserLogoutSuccessed object:nil];
    
    UIBarButtonItem *redHeartItem = [[UIBarButtonItem alloc] initWithTitle:@"我的红心" style:UIBarButtonItemStylePlain target:self action:@selector(onMyRedHeart)];

    UIBarButtonItem *loginItem = [[UIBarButtonItem alloc] initWithTitle:[TUUserManager isDouBanLogin] ? @"已登录" : @"登录" style:UIBarButtonItemStylePlain target:self action:@selector(onDouBanLogin:)];

    self.navigationItem.leftBarButtonItems = @[loginItem, redHeartItem];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:[MusicIndicator sharedInstance]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCurrentPlaying:)];
    [item.customView addGestureRecognizer:tap];
    
    self.navigationItem.rightBarButtonItem = item;
}

- (void)onCurrentPlaying:(UITapGestureRecognizer *)sender {
    NSLog(@"当前播放");
    if ([TUDouBanDataHelper sharedInstance].dataSource.count) {
        [self.navigationController pushViewController:[TUMusicPlayingController sharedInstance] animated:YES];
    };
}

- (void)updateIndicatorState {
    [MusicIndicator sharedInstance].state = [MusicIndicator sharedInstance].state;
}


- (void)douBanLoginNotification {
    self.navigationItem.leftBarButtonItems.firstObject.title = @"已登录";
}

- (void)douBanLogoutNotification {
    self.navigationItem.leftBarButtonItems.firstObject.title = @"登录";
}

- (void)onMyRedHeart {
    if (![TUUserManager isDouBanLogin]) {
        // 去登录
        @weakify(self);
        TUDouBanLoginController *vc = [TUDouBanLoginController loginControllerWithSuccess:^{
            TUDouBanChannelController *vc = [TUDouBanChannelController channelControllerWithChannel:nil];
            vc.isRedHeart = YES;
            [weak_self.navigationController pushViewController:vc animated:YES];
        } cancel:^{
            
        }];
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        TUDouBanChannelController *vc = [TUDouBanChannelController channelControllerWithChannel:nil];
        vc.isRedHeart = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)onDouBanLogin:(UIBarButtonItem *)sender {
    if ([sender.title isEqualToString:@"已登录"]) {
        NSLog(@"豆瓣登出");
        [self alertWithTitle:@"豆瓣" message:@"你确定要退出登录" doneTitle:@"确定" done:^{
            // 确定退出豆瓣登录
            [TUUserManager updateDouBanUser:nil];
        } cancelTitle:@"取消" cancel:nil];
    } else {
        NSLog(@"豆瓣登录");
        [self presentViewController:[TUDouBanLoginController loginControllerWithSuccess:nil cancel:nil] animated:YES completion:nil];
    }
}

- (UIAlertController *)alertWithTitle:(NSString *)title message:(NSString *)message doneTitle:(NSString *)doneTitle done:(void(^)())doneBlock cancelTitle:(NSString *)cancelTitle cancel:(void(^)())cancelBlock {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (cancelBlock != nil) {
            cancelBlock();
        }
    }];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:doneTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (doneBlock != nil) {
            doneBlock();
        }
    }];
    [alert addAction:cancel];
    [alert addAction:sure];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    return alert;
}

- (void)requestDataIsHeaderRefresh:(BOOL)isHeaderRefresh {
    @weakify(self);
    
    [self.channelListRequest sendRequestWithSuccess:^(__kindof TUBaseRequest * _Nonnull baseRequest, id  _Nullable responseObject) {
        @strongify(self);
        if (!self) { return; }
        [self.tableView.mj_header endRefreshing];

        NSArray *array = [TUDouBanChannelGroup mj_objectArrayWithKeyValuesArray:responseObject[@"groups"]];

        [self refreshPageData:array];
    } failur:^(__kindof TUBaseRequest * _Nonnull baseRequest, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        NSLog(@"%@",error.description);
    }];
}

- (void)refreshPageData:(NSArray *)array {
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:array];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource[section] chls].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"TUDouBanChannelListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    TUDouBanChannelModel *model = [self.dataSource[indexPath.section] chls][indexPath.row];
    
    cell.textLabel.text = model.name;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.dataSource[section] group_name];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    TUDouBanChannelModel *model = [self.dataSource[indexPath.section] chls][indexPath.row];
    
    if (indexPath.section == 0 && indexPath.row == 0) {

        if ([TUUserManager isDouBanLogin]) {
            [self performSegueWithIdentifier:@"ChannelListToDetail" sender:model];
//            [self.navigationController pushViewController:[TUDouBanChannelController channelControllerWithChannel:model] animated:YES];
        } else {
            // 去登录
            @weakify(self);
            TUDouBanLoginController *vc = [TUDouBanLoginController loginControllerWithSuccess:^{
                [weak_self performSegueWithIdentifier:@"ChannelListToDetail" sender:model];
//                [self.navigationController pushViewController:[TUDouBanChannelController channelControllerWithChannel:model] animated:YES];
            } cancel:^{
                
            }];
            [self presentViewController:vc animated:YES completion:nil];
        }
    } else {
        [self performSegueWithIdentifier:@"ChannelListToDetail" sender:model];
//        [self.navigationController pushViewController:[TUDouBanChannelController channelControllerWithChannel:model] animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ChannelListToDetail"]) {
        TUDouBanChannelModel *model = sender;
        TUDouBanChannelController *vc = segue.destinationViewController;
        vc.channel = model;
    }
}

@end
