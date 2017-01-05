//
//  TUMusicDataMenuController.m
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/6/3.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import "TUMusicDataMenuController.h"
#import "TUDouBanMusicModel.h"

@interface TUMusicDataMenuController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, copy) TUDidSelectedMusicAtIndexPath selectedBlock;
@property (nonatomic, strong) NSMutableArray *dataSource;     // 模型数据
@property (nonatomic, assign) NSInteger currentIndex;     // 模型数据

@end

@implementation TUMusicDataMenuController

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)setDidSelectedBlockAtIndexPat:(TUDidSelectedMusicAtIndexPath)selectedBlock {
    _selectedBlock = selectedBlock;
}

- (void)setDataSource:(NSMutableArray *)data currentIndex:(NSInteger)currentIndex {
    if (_currentIndex != currentIndex || _dataSource != data) {
        self.currentIndex = currentIndex;
        self.dataSource = data;
        self.label.text = [NSString stringWithFormat:@"共%d首", (int)self.dataSource.count];
        [self.tableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat tableHeight = ceil(CGRectGetHeight(self.view.frame) * 0.65);
    
    CGFloat height = CGRectGetHeight(self.view.frame);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, height - tableHeight - 44, kScreenWidth, 44)];
    label.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.8];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"共%d首", (int)self.dataSource.count];
    [self.view addSubview:label];
    self.label = label;
    
    CGRect frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - tableHeight, kScreenWidth, tableHeight);
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.95];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onViewTap:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)gestureRecognizerShouldBegin:(UITapGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:self.view];
    if (CGRectContainsPoint(self.tableView.frame, point)) {
        return NO;
    }
    return YES;
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
        self.selectedBlock = nil;
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TUMusicDataMenuControllerCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TUMusicDataMenuControllerCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    TUDouBanMusicModel *model = self.dataSource[indexPath.row];
    cell.textLabel.text = model.title;
    
    if (self.currentIndex == indexPath.row) {
        cell.textLabel.textColor = [UIColor redColor];
    } else {
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    @weakify(self);
    [self dismissViewControllerAnimated:YES completion:^{
        @strongify(self);
        if (!self) { return; }
        if (self.selectedBlock) {
            self.selectedBlock(indexPath);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
