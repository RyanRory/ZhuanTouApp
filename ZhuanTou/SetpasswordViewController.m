//
//  SetpasswordViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/14.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "SetpasswordViewController.h"

@interface SetpasswordViewController ()

@end

@implementation SetpasswordViewController

@synthesize forgottenButton;

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
    
    alipay = [[AliPayViews alloc] initWithFrame:self.view.bounds];
    oldPSW = [KeychainData objectForKey:KEYCHAIN_KEY];
    if ([self.string isEqualToString:@"验证密码"])
    {
        alipay.gestureModel = ValidatePwdModel;
    }
    else if ([self.string isEqualToString:@"修改密码"])
    {
        alipay.gestureModel = AlertPwdModel;
    }
    else if ([self.string isEqualToString:@"重置密码"])
    {
        alipay.gestureModel = SetPwdModel;
    }
    else
    {
        alipay.gestureModel = NoneModel;
    }
    
    __weak NSString *weakStyle = self.style;
    __weak NSString *weakString = self.string;
    __weak SetpasswordViewController *weakSelf = self;
    
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
            [[weakSelf navigationController]popViewControllerAnimated:YES];
        }
        else
        {
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
    
    if ([self.string isEqualToString:@"验证密码"])
    {
        [self.view bringSubviewToFront:forgottenButton];
    }
    else
    {
        [forgottenButton setHidden:YES];
    }

}

- (void)viewDidLayoutSubviews
{
    [alipay setFrame:CGRectMake(0, (self.view.frame.size.height-480)/2, self.view.frame.size.width, 480)];
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


@end
