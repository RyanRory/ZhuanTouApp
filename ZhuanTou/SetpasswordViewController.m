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
@synthesize isFromNewer;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    if ([self.string isEqualToString:@"验证密码"] || [self.string isEqualToString:@"重置密码"])
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
                         NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                         NSString *password = [userDefault objectForKey:PASSWORD];
                         if ((password.length > 0) && (![userDefault boolForKey:ISLOGIN]))
                         {
                             AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                             NSDictionary *parameters = @{@"login":[userDefault objectForKey:USERNAME],
                                                          @"password":[userDefault objectForKey:PASSWORD]};
                             NSString *URL = [BASEURL stringByAppendingString:@"api/auth/signIn"];
                             [manager POST:URL parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                                 NSLog(@"%@", responseObject);
                                 NSString *str = [responseObject objectForKey:@"isAuthenticated"];
                                 int f1 = str.intValue;
                                 if (f1 == 0)
                                 {
                                     MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakSelf.presentedViewController.view animated:YES];
                                     hud.mode = MBProgressHUDModeCustomView;
                                     NSRange range = [[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"errorMessage"]] rangeOfString:@"密码错误"];
                                     if (range.length > 0)
                                     {
                                         hud.labelText = @"您的登录密码已修改，请重新登录";
                                         [userDefault removeObjectForKey:PASSWORD];
                                         [userDefault synchronize];
                                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                             UINavigationController *nav = [[weakSelf storyboard]instantiateViewControllerWithIdentifier:@"LoginNav"];
                                             [weakSelf.presentedViewController presentViewController:nav animated:YES completion:nil];
                                         });
                                     }
                                     else
                                     {
                                         hud.labelText = [responseObject objectForKey:@"errorMessage"];
                                     }
                                     [hud hide:YES afterDelay:1.5f];
                                 }
                                 else
                                 {
                                     [userDefault setBool:YES forKey:ISLOGIN];
                                     [userDefault setObject:[responseObject objectForKey:@"nickname"] forKey:NICKNAME];
                                     [userDefault setBool:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"isTradepasswordset"]].boolValue forKey:ISTRADEPSWDSET];
                                     [userDefault synchronize];
                                 }
                                 
                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 NSLog(@"Error: %@", error);
                                 MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
                                 hud.mode = MBProgressHUDModeText;
                                 hud.labelText = @"登录失败";
                                 [hud hide:YES afterDelay:1.5f];
                                 
                             }];
                         }

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
    
    BOOL weakIsFromNewer = isFromNewer;
    
    alipay.block = ^(NSString *pswString) {
        if ([weakString isEqualToString:@"重置密码"])
        {
            if ([weakStyle isEqualToString:@"REGISTER"])
            {
                if (weakIsFromNewer)
                {
                    [weakSelf popToViewController:weakSelf.viewControllers[1] animated:YES];
                }
                else
                {
                    RegisterSuccessViewController *vc = [[weakSelf storyboard]instantiateViewControllerWithIdentifier:@"RegisterSuccessVC"];
                    [weakSelf pushViewController:vc animated:YES];
                }
            }
            else if ([weakStyle isEqualToString:@"FORGOTTEN"])
            {
                ZTTabBarViewController *tabvc = [[weakSelf storyboard]instantiateViewControllerWithIdentifier:@"ZTTabBarViewController"];
                PPRevealSideViewController *revealSideViewController = [[PPRevealSideViewController alloc]initWithRootViewController:tabvc];
                [revealSideViewController setDirectionsToShowBounce:PPRevealSideDirectionNone];
                revealSideViewController.fakeiOS7StatusBarColor = [UIColor clearColor];
                [revealSideViewController setOption:PPRevealSideOptionsiOS7StatusBarMoving];
                LeftViewController *leftVC = [[weakSelf storyboard]instantiateViewControllerWithIdentifier:@"LeftViewController"];
                [revealSideViewController preloadViewController:leftVC forSide:PPRevealSideDirectionLeft];
                [weakSelf presentViewController:revealSideViewController animated:NO completion:nil];
            }
            else
            {
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }
        }
        else if ([weakString isEqualToString:@"修改密码"])
        {
            [weakSelf popViewControllerAnimated:YES];
        }
        else
        {
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            NSString *password = [userDefault objectForKey:PASSWORD];
            if ((password.length > 0) && (![userDefault boolForKey:ISLOGIN]))
            {
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                NSDictionary *parameters = @{@"login":[userDefault objectForKey:USERNAME],
                                             @"password":[userDefault objectForKey:PASSWORD]};
                NSString *URL = [BASEURL stringByAppendingString:@"api/auth/signIn"];
                [manager POST:URL parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                    NSLog(@"%@", responseObject);
                    NSString *str = [responseObject objectForKey:@"isAuthenticated"];
                    int f1 = str.intValue;
                    if (f1 == 0)
                    {
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakSelf.presentedViewController.view animated:YES];
                        hud.mode = MBProgressHUDModeCustomView;
                        NSRange range = [[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"errorMessage"]] rangeOfString:@"密码错误"];
                        if (range.length > 0)
                        {
                            hud.labelText = @"您的登录密码已修改，请重新登录";
                            [userDefault removeObjectForKey:PASSWORD];
                            [userDefault synchronize];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                UINavigationController *nav = [[weakSelf storyboard]instantiateViewControllerWithIdentifier:@"LoginNav"];
                                [weakSelf.presentedViewController presentViewController:nav animated:YES completion:nil];
                            });
                        }
                        else
                        {
                            hud.labelText = [responseObject objectForKey:@"errorMessage"];
                        }
                        [hud hide:YES afterDelay:1.5f];
                    }
                    else
                    {
                        [userDefault setBool:YES forKey:ISLOGIN];
                        [userDefault setObject:[responseObject objectForKey:@"nickname"] forKey:NICKNAME];
                        [userDefault setBool:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"isTradepasswordset"]].boolValue forKey:ISTRADEPSWDSET];
                        [userDefault synchronize];
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"登录失败";
                    [hud hide:YES afterDelay:1.5f];
                    
                }];
            }
            ZTTabBarViewController *tabvc = [[weakSelf storyboard]instantiateViewControllerWithIdentifier:@"ZTTabBarViewController"];
            PPRevealSideViewController *revealSideViewController = [[PPRevealSideViewController alloc]initWithRootViewController:tabvc];
            [revealSideViewController setDirectionsToShowBounce:PPRevealSideDirectionNone];
            revealSideViewController.fakeiOS7StatusBarColor = [UIColor clearColor];
            [revealSideViewController setOption:PPRevealSideOptionsiOS7StatusBarMoving];
            LeftViewController *leftVC = [[weakSelf storyboard]instantiateViewControllerWithIdentifier:@"LeftViewController"];
            [revealSideViewController preloadViewController:leftVC forSide:PPRevealSideDirectionLeft];
            [weakSelf presentViewController:revealSideViewController animated:NO completion:nil];
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
    if (SCREEN_WIDTH > 350)
    {
        [alipay setFrame:CGRectMake(0, (self.view.frame.size.height-480)/2-30, self.view.frame.size.width, 460)];
    }
    else
    {
        [alipay setFrame:CGRectMake(0, (self.view.frame.size.height-480)/2-10, self.view.frame.size.width, 460)];
    }
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
                 NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                 NSString *password = [userDefault objectForKey:PASSWORD];
                 if ((password.length > 0) && (![userDefault boolForKey:ISLOGIN]))
                 {
                     AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                     NSDictionary *parameters = @{@"login":[userDefault objectForKey:USERNAME],
                                                  @"password":[userDefault objectForKey:PASSWORD]};
                     NSString *URL = [BASEURL stringByAppendingString:@"api/auth/signIn"];
                     [manager POST:URL parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                         NSLog(@"%@", responseObject);
                         NSString *str = [responseObject objectForKey:@"isAuthenticated"];
                         int f1 = str.intValue;
                         if (f1 == 0)
                         {
                             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakSelf.presentedViewController.view animated:YES];
                             hud.mode = MBProgressHUDModeCustomView;
                             NSRange range = [[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"errorMessage"]] rangeOfString:@"密码错误"];
                             if (range.length > 0)
                             {
                                 hud.labelText = @"您的登录密码已修改，请重新登录";
                                 [userDefault removeObjectForKey:PASSWORD];
                                 [userDefault synchronize];
                                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                     UINavigationController *nav = [[weakSelf storyboard]instantiateViewControllerWithIdentifier:@"LoginNav"];
                                     [weakSelf.presentedViewController presentViewController:nav animated:YES completion:nil];
                                 });
                             }
                             else
                             {
                                 hud.labelText = [responseObject objectForKey:@"errorMessage"];
                             }
                             [hud hide:YES afterDelay:1.5f];
                         }
                         else
                         {
                             [userDefault setBool:YES forKey:ISLOGIN];
                             [userDefault setObject:[responseObject objectForKey:@"nickname"] forKey:NICKNAME];
                             [userDefault setBool:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"isTradepasswordset"]].boolValue forKey:ISTRADEPSWDSET];
                             [userDefault synchronize];
                         }
                         
                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         NSLog(@"Error: %@", error);
                         MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
                         hud.mode = MBProgressHUDModeText;
                         hud.labelText = @"登录失败";
                         [hud hide:YES afterDelay:1.5f];
                         
                     }];
                 }
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
