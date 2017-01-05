//
//  TUMusicDataMenuController.h
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/6/3.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TUDidSelectedMusicAtIndexPath)(NSIndexPath *indexPath);

@interface TUMusicDataMenuController : UIViewController

@property (nonatomic, strong) UITableView *tableView;

- (void)setDidSelectedBlockAtIndexPat:(TUDidSelectedMusicAtIndexPath)selectedBlock;
- (void)setDataSource:(NSMutableArray *)data currentIndex:(NSInteger)currentIndex;

@end
