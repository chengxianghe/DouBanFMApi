//
//  TUDouBanLoginControllerViewController.m
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/24.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import "TUDouBanLoginController.h"
#import "TUUserManager.h"
#import "TUDouBanUserModel.h"
#import "TUDBLoginRequest.h"
#import <MJExtension.h>

@interface TUDouBanLoginController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (nonatomic, strong) TUDBLoginRequest *loginRequest;
@property (nonatomic, copy) TUDouBanLoginBlock success;
@property (nonatomic, copy) TUDouBanLoginBlock cancel;

@end

@implementation TUDouBanLoginController

+ (instancetype)loginControllerWithSuccess:(TUDouBanLoginBlock)success cancel:(TUDouBanLoginBlock)cancel {
    TUDouBanLoginController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TUDouBanLoginController"];
    vc.success = success;
    vc.cancel = cancel;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.loginRequest = [[TUDBLoginRequest alloc] init];
}

- (IBAction)onLoginBtnClick:(UIButton *)sender {
    NSString *eamil = self.nameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if (!eamil.length || !password.length) {
        NSLog(@"请输入邮箱和密码");
        return;
    }
    
    self.loginRequest.email = eamil;
    self.loginRequest.password = password;
    
    @weakify(self);
    [self.loginRequest sendRequestWithSuccess:^(__kindof TUBaseRequest * _Nonnull baseRequest, id  _Nullable responseObject) {
        @strongify(self);
        if (!self) {
            return ;
        }
        /**
         {
         "access_token" = 21a0867e86f16fb464e1937b94d44f1c;
         "douban_user_id" = 145626941;
         "douban_user_name" = "\U4e91\U9038";
         "expires_in" = 7775999;
         "refresh_token" = 77bc1538a652d3b867343fa9f2f87b28;
         }
         */
        
        NSLog(@"登录成功！：%@", responseObject);
        TUDouBanUserModel *user = [TUDouBanUserModel mj_objectWithKeyValues:responseObject];
        [TUUserManager updateDouBanUser:user];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kDouBanUserLoginSuccessed object:nil];
        
        NSLog(@"doubanUser:%@", [TUUserManager sharedInstance].doubanUser);
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.success) {
                self.success();
            }
        }];

    } failur:^(__kindof TUBaseRequest * _Nonnull baseRequest, NSError * _Nonnull error) {
        NSLog(@"登录失败：%@ response:%@", error, baseRequest.responseObject);
    }];
}

- (IBAction)onCancelBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.cancel) {
            self.cancel();
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
