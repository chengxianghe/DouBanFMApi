//
//  TUNavigationController.m
//  RedLine
//
//  Created by chengxianghe on 16/3/25.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "TUNavigationController.h"

@interface TUNavigationController ()

@end

@implementation TUNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Status Bar

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

@end
