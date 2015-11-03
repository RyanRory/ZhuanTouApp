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
    
    AliPayViews *alipay = [[AliPayViews alloc] initWithFrame:self.view.bounds];
    if ([self.string isEqualToString:@"验证密码"])
    {
        alipay.gestureModel = ValidatePwdModel;
        [alipay setFrame:CGRectMake(0, 32, self.view.frame.size.width, self.view.frame.size.height)];
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
    alipay.block = ^(NSString *pswString) {
        NSLog(@"设置密码成功-----你的密码为 = 【%@】\n\n", pswString);
        if ([self.string isEqualToString:@"重置密码"])
        {
            if ([self.style isEqualToString:@"REGISTER"])
            {
                RegisterSuccessViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"RegisterSuccessVC"];
                [[self navigationController]pushViewController:vc animated:YES];
            }
            else if ([self.style isEqualToString:@"FORGOTTEN"])
            {
                ZTTabBarViewController *tabvc = [[self storyboard]instantiateViewControllerWithIdentifier:@"ZTTabBarViewController"];
                [self presentViewController:tabvc animated:YES completion:nil];
            }
            else
            {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
        else if ([self.string isEqualToString:@"修改密码"])
        {
            [[self navigationController]popViewControllerAnimated:YES];
        }
        else
        {
            ZTTabBarViewController *tabvc = [[self storyboard]instantiateViewControllerWithIdentifier:@"ZTTabBarViewController"];
            [self presentViewController:tabvc animated:YES completion:nil];
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

- (void)backToParent:(id)sender
{
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
