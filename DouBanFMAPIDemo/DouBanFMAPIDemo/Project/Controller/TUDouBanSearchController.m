//
//  TUDouBanSearchController.m
//  DouBanFMAPIDemo
//
//  Created by chengxianghe on 2017/2/14.
//  Copyright © 2017年 cn. All rights reserved.
//

#import "TUDouBanSearchController.h"
#import "TUDouBanSearchRequest.h"
#import "TUMusicManager.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "TUMusicPlayingController.h"
#import "TUDouBanMusicModel.h"
#import "TUDefaultCell.h"

@interface TUDouBanSearchController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<__kindof TUDouBanMusicModel *> *dataSource;
@property (nonatomic, strong) TUDouBanSearchRequest *searchRequest;
@property (assign, nonatomic) NSInteger currentPage;
@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation TUDouBanSearchController

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.searchBar resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.placeholder = @"搜索歌曲";
    searchBar.showsCancelButton = YES;
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar = searchBar;
    self.searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
    
    self.dataSource = [NSMutableArray array];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = [TUDefaultCell height];
    [self.tableView registerNib:[UINib nibWithNibName:@"TUDefaultCell" bundle:nil] forCellReuseIdentifier:@"TUDefaultCell"];
    [self.view addSubview:self.tableView];

    self.searchRequest = [[TUDouBanSearchRequest alloc] init];
    
    @weakify(self);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        if (!self) { return; }
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
            return;
        }
        [self requestDataIsHeaderRefresh:YES];
    }];
    self.tableView.mj_header = header;
    
    header.lastUpdatedTimeLabel.hidden = true;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        if (!self) { return; }
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
            return;
        }
        [self requestDataIsHeaderRefresh:NO];
    }];
    self.tableView.mj_footer = footer;

}

- (void)requestDataIsHeaderRefresh:(BOOL)isHeaderRefresh {
    @weakify(self);
    self.searchRequest.searchText = self.searchBar.text;
    
    self.searchRequest.page = isHeaderRefresh ? 0 : (self.currentPage + 1);
    [self.searchRequest sendRequestWithSuccess:^(__kindof TUBaseRequest * _Nonnull baseRequest, id  _Nullable responseObject) {
        @strongify(self);
        if (!self) { return; }
        [self.tableView.mj_header endRefreshing];
        
        NSArray *array = [TUDouBanMusicModel mj_objectArrayWithKeyValuesArray:responseObject[@"items"]];
        [self refreshPageData:array isHeaderRefresh:isHeaderRefresh];
        
        if (array.count < 20) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        
    } failur:^(__kindof TUBaseRequest * _Nonnull baseRequest, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSLog(@"%@",error.description);
    }];
}

- (void)refreshPageData:(NSArray *)array isHeaderRefresh:(BOOL)isHeaderRefresh {
    if (isHeaderRefresh) {
        self.currentPage = 0;
        [self.dataSource removeAllObjects];
    } else {
        self.currentPage += 1;
    }
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
    [self.searchBar resignFirstResponder];

    TUDouBanMusicModel *current = self.dataSource[indexPath.row];
    
    if (!current.playable) {
        kTipAlert(@"歌曲已下架，不能播放！");
        return;
    }
    
    NSMutableArray *filterArray = [NSMutableArray arrayWithCapacity:self.dataSource.count];

    for (TUDouBanMusicModel *music in self.dataSource) {
        if (music.playable) {
            [filterArray addObject:music];
        }
    }
    
    TUMusicPlayingController *vc = [TUMusicPlayingController musicControllerWithMusicList:filterArray currentIndex:[filterArray indexOfObject:current]];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    [self requestDataIsHeaderRefresh:YES];
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
