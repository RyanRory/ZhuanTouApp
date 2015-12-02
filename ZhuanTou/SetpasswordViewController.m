//
//  SetpasswordViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/14.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "SetpasswordViewController.h"

@import LocalAuthentication;

@interface SetpasswordViewController ()

@end

@implementation SetpasswordViewController

@synthesize forgottenButton, touchIdButton, forgottenButtonWithTouchId;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    if ([self.string isEqualToString:@"验证密码"])
    {
        self.navigationItem.hidesBackButton = YES;
    }
    else
    {
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
        backItem.tintColor = ZTBLUE;
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
    }
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    
    [forgottenButton addTarget:self action:@selector(toLogin:) forControlEvents:UIControlEventTouchUpInside];
    [forgottenButtonWithTouchId addTarget:self action:@selector(toLogin:) forControlEvents:UIControlEventTouchUpInside];
    [touchIdButton addTarget:self action:@selector(setTouchID:) forControlEvents:UIControlEventTouchUpInside];
    
    __weak NSString *weakStyle = self.style;
    __weak NSString *weakString = self.string;
    __weak UINavigationController *weakSelf = self.navigationController;
    
    alipay = [[AliPayViews alloc] initWithFrame:self.view.bounds];
    oldPSW = [KeychainData objectForKey:KEYCHAIN_KEY];
    if ([self.string isEqualToString:@"验证密码"])
    {
        alipay.gestureModel = ValidatePwdModel;
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        LAContext *context = [[LAContext alloc] init];
        context.localizedFallbackTitle=@"";
        NSError *error;
        BOOL success;
        
        success = [context canEvaluatePolicy: LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
        if (success)
        {
            [self.view bringSubviewToFront:forgottenButtonWithTouchId];
            [self.view bringSubviewToFront:touchIdButton];
            [forgottenButton setHidden:YES];
            if ([userDefault boolForKey:TOUCHID])
            {
                [touchIdButton setTitle:@"关闭指纹验证" forState:UIControlStateNormal];
                [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:NSLocalizedString(@"通过Home键验证已有指纹", nil) reply:
                 ^(BOOL success, NSError *authenticationError) {
                     if (success)
                     {
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                             ZTTabBarViewController *tabvc = [[weakSelf storyboard]instantiateViewControllerWithIdentifier:@"ZTTabBarViewController"];
                             [weakSelf presentViewController:tabvc animated:YES completion:nil];
                         });
                     }
                 }];
            }
            else
            {
                [touchIdButton setTitle:@"开启指纹验证" forState:UIControlStateNormal];
            }
        }
        else
        {
            [self.view bringSubviewToFront:forgottenButton];
            [forgottenButtonWithTouchId setHidden:YES];
            [touchIdButton setHidden:YES];
        }

    }
    else if ([self.string isEqualToString:@"修改密码"])
    {
        alipay.gestureModel = AlertPwdModel;
        [forgottenButton setHidden:YES];
        [forgottenButtonWithTouchId setHidden:YES];
        [touchIdButton setHidden:YES];
    }
    else if ([self.string isEqualToString:@"重置密码"])
    {
        alipay.gestureModel = SetPwdModel;
        [forgottenButton setHidden:YES];
        [forgottenButtonWithTouchId setHidden:YES];
        [touchIdButton setHidden:YES];
    }
    else
    {
        alipay.gestureModel = NoneModel;
        [forgottenButton setHidden:YES];
        [forgottenButtonWithTouchId setHidden:YES];
        [touchIdButton setHidden:YES];
    }
    
    alipay.block = ^(NSString *pswString) {
        if ([weakString isEqualToString:@"重置密码"])
        {
            if ([weakStyle isEqualToString:@"REGISTER"])
            {
                RegisterSuccessViewController *vc = [[weakSelf storyboard]instantiateViewControllerWithIdentifier:@"RegisterSuccessVC"];
                [[weakSelf navigationController]pushViewController:vc animated:YES];
            }
            else if ([weakStyle isEqualToString:@"FORGOTTEN"])
            {
                ZTTabBarViewController *tabvc = [[weakSelf storyboard]instantiateViewControllerWithIdentifier:@"ZTTabBarViewController"];
                [weakSelf presentViewController:tabvc animated:YES completion:nil];
            }
            else
            {
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }
        }
        else if ([weakString isEqualToString:@"修改密码"])
        {
            [[self navigationController]popViewControllerAnimated:YES];
        }
        else
        {
//            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//            NSString *password = [userDefault objectForKey:PASSWORD];
//            if ((password.length > 0) && (![userDefault boolForKey:ISLOGIN]))
//            {
//                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//                NSDictionary *parameters = @{@"login":[userDefault objectForKey:USERNAME],
//                                             @"password":[userDefault objectForKey:PASSWORD]};
//                NSString *URL = [BASEURL stringByAppendingString:@"api/auth/signIn"];
//                [manager POST:URL parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
//                    NSLog(@"%@", responseObject);
//                    NSString *str = [responseObject objectForKey:@"isAuthenticated"];
//                    int f1 = str.intValue;
//                    if (f1 == 0)
//                    {
//                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                        hud.mode = MBProgressHUDModeCustomView;
//                        hud.labelText = [responseObject objectForKey:@"errorMessage"];
//                        [hud hide:YES afterDelay:1.5f];
//                    }
//                    else
//                    {
//                        [userDefault setBool:YES forKey:ISLOGIN];
//                        [userDefault setBool:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"isTradePwSetted"]].boolValue forKey:ISTRADEPSWDSET];
//                        [userDefault synchronize];
//                    }
//                    
//                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                    NSLog(@"Error: %@", error);
//                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                    hud.mode = MBProgressHUDModeText;
//                    hud.labelText = @"登录失败";
//                    [hud hide:YES afterDelay:1.5f];
//                    
//                }];
//            }
//            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                ZTTabBarViewController *tabvc = [[weakSelf storyboard]instantiateViewControllerWithIdentifier:@"ZTTabBarViewController"];
//                [weakSelf presentViewController:tabvc animated:YES completion:nil];
//            });
            
            ZTTabBarViewController *tabvc = [[weakSelf storyboard]instantiateViewControllerWithIdentifier:@"ZTTabBarViewController"];
            [weakSelf presentViewController:tabvc animated:YES completion:nil];
        }
    };
    
    alipay.failBlock = ^(NSString *str){
        if ([str isEqualToString:@"LOGIN"])
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您已连续5次输错手势，请重新登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction* call){
                [weakSelf performSelector:@selector(toLogin:) withObject:nil afterDelay:0];
            }];
            [alertController addAction:confirmAction];
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }
        else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"手势密码已失效，请重新登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction* call){
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                NSString *URL = [BASEURL stringByAppendingString:@"Account/SignOut"];
                [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                    NSLog(@"%@", responseObject);
                    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                    [userDefault setBool:NO forKey:ISLOGIN];
                    [userDefault removeObjectForKey:PASSWORD];
                    [userDefault synchronize];
                    [[weakSelf navigationController]popViewControllerAnimated:NO];
    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                    [userDefault setBool:NO forKey:ISLOGIN];
                    [userDefault removeObjectForKey:PASSWORD];
                    [userDefault synchronize];
                    [[weakSelf navigationController]popViewControllerAnimated:NO];
                }];

            }];
            [alertController addAction:confirmAction];
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }
    };
    
    [self.view addSubview:alipay];

}

- (void)viewDidLayoutSubviews
{
    [alipay setFrame:CGRectMake(0, (self.view.frame.size.height-480)/2-10, self.view.frame.size.width, 480)];
}

- (void)backToParent:(id)sender
{
    if ((![KeychainData isSave]) && (oldPSW.length > 0))
    {
        [KeychainData setPSW:oldPSW];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)toLogin:(id)sender
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:PASSWORD];
    [userDefault synchronize];
    [KeychainData forgotPsw];
    LoginViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"LoginViewController"];
    vc.style = @"FORGOTTEN";
    [[self navigationController]pushViewController:vc animated:YES];
}

- (void)setTouchID:(id)sender
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:![userDefault boolForKey:TOUCHID] forKey:TOUCHID];
    [userDefault synchronize];
    if ([userDefault boolForKey:TOUCHID])
    {
        [touchIdButton setTitle:@"关闭指纹验证" forState:UIControlStateNormal];
        __weak SetpasswordViewController *weakSelf = self;
        LAContext *context = [[LAContext alloc] init];
        context.localizedFallbackTitle=@"";
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:NSLocalizedString(@"通过Home键验证已有指纹", nil) reply:
         ^(BOOL success, NSError *authenticationError) {
             if (success)
             {
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     ZTTabBarViewController *tabvc = [[weakSelf storyboard]instantiateViewControllerWithIdentifier:@"ZTTabBarViewController"];
                     [weakSelf presentViewController:tabvc animated:YES completion:nil];
                 });
             }
         }];
    }
    else
    {
        [touchIdButton setTitle:@"开启指纹验证" forState:UIControlStateNormal];
    }
}


@end
