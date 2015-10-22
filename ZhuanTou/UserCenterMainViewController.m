//
//  UserCenterMainViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/18.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "UserCenterMainViewController.h"

@interface UserCenterMainViewController ()

@end

@implementation UserCenterMainViewController

@synthesize propertyLabel, balanceLabel, chargeButton, drawButton;
@synthesize dingqiNumLabel, dingqiButton, huoqiNumLabel, huoqiButton, autoSwitch, autoButton, profitButton, detailButton, bankCardNumLabel, bankCardButton, bonusNumLabel, bonusButton, securityLabel, securityButton, gestureButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    
    chargeButton.layer.cornerRadius = 3;
    drawButton.layer.cornerRadius = 3;

    [dingqiButton addTarget:self action:@selector(toDingqi:) forControlEvents:UIControlEventTouchUpInside];
    [huoqiButton addTarget:self action:@selector(toHuoqi:) forControlEvents:UIControlEventTouchUpInside];
    [autoButton addTarget:self action:@selector(setAuto:) forControlEvents:UIControlEventTouchUpInside];
    [profitButton addTarget:self action:@selector(toProfit:) forControlEvents:UIControlEventTouchUpInside];
    [detailButton addTarget:self action:@selector(toDetail:) forControlEvents:UIControlEventTouchUpInside];
    [bankCardButton addTarget:self action:@selector(toBankCard:) forControlEvents:UIControlEventTouchUpInside];
    [bonusButton addTarget:self action:@selector(toBonus:) forControlEvents:UIControlEventTouchUpInside];
    [securityButton addTarget:self action:@selector(toSecurity:) forControlEvents:UIControlEventTouchUpInside];
    [gestureButton addTarget:self action:@selector(toGesture:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setupData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    BOOL flag = [userDefault boolForKey:ISLOGIN];
    if (flag)
    {
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"退出登录" style:UIBarButtonItemStylePlain target:self action:@selector(signOut:)];
        self.navigationItem.leftBarButtonItem = item;
        [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:13], NSFontAttributeName,nil] forState:UIControlStateNormal];
    }
}

- (void)setupData
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    [formatter setPositiveFormat:@"###,##0.00"];
    propertyLabel.text = [NSString stringWithString:[formatter stringFromNumber:[NSNumber numberWithDouble:1111001.11]]];
    balanceLabel.text = [NSString stringWithString:[formatter stringFromNumber:[NSNumber numberWithDouble:1111001.11]]];
    dingqiNumLabel.text = [NSString stringWithString:[formatter stringFromNumber:[NSNumber numberWithDouble:1111001.11]]];
    huoqiNumLabel.text = [NSString stringWithString:[formatter stringFromNumber:[NSNumber numberWithDouble:1111001.11]]];
    bankCardNumLabel.text = @"3张";
    bonusNumLabel.text = @"3张";
    securityLabel.text = @"高";
    autoSwitch.on = YES;
}

- (void)toDingqi:(id)sender
{
    DingqiViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"DingqiViewController"];
    [[self navigationController]pushViewController:vc animated:YES];
}

- (void)toHuoqi:(id)sender
{
    HuoqiViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"HuoqiViewController"];
    [[self navigationController]pushViewController:vc animated:YES];
}

- (void)setAuto:(id)sender
{
    AutoViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"AutoViewController"];
    [[self navigationController]pushViewController:vc animated:YES];
}

- (void)toProfit:(id)sender
{
    ProfitViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"ProfitViewController"];
    [[self navigationController]pushViewController:vc animated:YES];
}

- (void)toDetail:(id)sender
{
    
}

- (void)toBankCard:(id)sender
{
    
}

- (void)toBonus:(id)sender
{
    
}

- (void)toSecurity:(id)sender
{
    SecurityViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"SecurityViewController"];
    [[self navigationController]pushViewController:vc animated:YES];
}

- (void)toGesture:(id)sender
{
    BOOL isSave = [KeychainData isSave]; //是否有保存
    if (isSave) {
        SetpasswordViewController *setpass = [[self storyboard]instantiateViewControllerWithIdentifier:@"SetpasswordViewController"];
        setpass.string = @"修改密码";
        setpass.hidesBottomBarWhenPushed = YES;
        [[self navigationController]pushViewController:setpass animated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"您还没有设置手势密码" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)signOut:(id)sender
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:@"Account/SignOut"];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        NSString *str = [responseObject objectForKey:@"isAuthenticated"];
        int f1 = str.intValue;
        if (f1 == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[responseObject objectForKey:@"errorMessage"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登出成功！" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            self.navigationItem.leftBarButtonItem = nil;
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setBool:NO forKey:ISLOGIN];
            [userDefault synchronize];
            [[self tabBarController]setSelectedIndex:0];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登出成功!" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        self.navigationItem.leftBarButtonItem = nil;
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setBool:NO forKey:ISLOGIN];
        [userDefault synchronize];
        [[self tabBarController]setSelectedIndex:0];
    }];
    
}


@end
