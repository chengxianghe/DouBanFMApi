//
//  TUMusicSettingViewController.m
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/31.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import "TUMusicSettingMoreController.h"

@interface TUMusicSettingMoreController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataSource;     // 模型数据
@property (nonatomic, strong) UILabel *label;

@end

@implementation TUMusicSettingMoreController

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat tableHeight = ceil(CGRectGetHeight(self.view.frame) * 0.5);
    
    CGFloat height = CGRectGetHeight(self.view.frame);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, height - tableHeight - 44, kScreenWidth, 44)];
    label.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.8];
    label.textColor = [UIColor whiteColor];
    label.text = @"    歌曲:xxx";
    [self.view addSubview:label];
    self.label = label;
    
    CGRect frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - tableHeight, kScreenWidth, tableHeight);
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    

    
    self.dataSource = @[@"收藏到歌单",
                        @"相似歌手",
                        @"歌手:xxx",
                        @"专辑:xxx",
                        @"音质:自动选择",
                        @"定时关闭",
                        @"均衡器",
                        @"打开驾驶模式",
                        @"收藏到歌单",
                        @"相似歌手",
                        @"歌手:xxx",
                        @"专辑:xxx",
                        @"音质:自动选择",
                        @"定时关闭",
                        @"均衡器",
                        @"打开驾驶模式"
                        ];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.95];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onViewTap:)];
    [self.view addGestureRecognizer:tap];
}

- (void)onViewTap:(UITapGestureRecognizer *)tap {
    CGRect tableFrame = self.tableView.frame;
    tableFrame.origin.y = CGRectGetHeight(self.view.frame);
    
    CGRect lableFrame = self.label.frame;
    lableFrame.origin.y = CGRectGetHeight(self.view.frame);
    
    [UIView animateWithDuration:0.2 animations:^{
        self.tableView.frame = tableFrame;
        self.label.frame = lableFrame;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    scrollView.bounces = ((scrollView.contentOffset.y > 10) || scrollView.isDecelerating);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate) {
        scrollView.bounces = YES;
    }
}

#pragma mark - UITableViewDataSorce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TUMusicSettingMoreControllerCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TUMusicSettingMoreControllerCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
