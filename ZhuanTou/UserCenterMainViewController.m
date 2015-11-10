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
@synthesize dingqiNumLabel, dingqiButton, huoqiNumLabel, huoqiButton, autoButton, profitButton, detailButton, bankCardButton, bonusNumLabel, bonusButton, securityLabel, securityButton, gestureButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    chargeButton.layer.cornerRadius = 3;
    drawButton.layer.cornerRadius = 3;
    
    t = 0;

    [dingqiButton addTarget:self action:@selector(toDingqi:) forControlEvents:UIControlEventTouchUpInside];
    [huoqiButton addTarget:self action:@selector(toHuoqi:) forControlEvents:UIControlEventTouchUpInside];
    [autoButton addTarget:self action:@selector(setAuto:) forControlEvents:UIControlEventTouchUpInside];
    [profitButton addTarget:self action:@selector(toProfit:) forControlEvents:UIControlEventTouchUpInside];
    [detailButton addTarget:self action:@selector(toDetail:) forControlEvents:UIControlEventTouchUpInside];
    [bankCardButton addTarget:self action:@selector(toBankCard:) forControlEvents:UIControlEventTouchUpInside];
    [bonusButton addTarget:self action:@selector(toBonus:) forControlEvents:UIControlEventTouchUpInside];
    [securityButton addTarget:self action:@selector(toSecurity:) forControlEvents:UIControlEventTouchUpInside];
    [gestureButton addTarget:self action:@selector(toGesture:) forControlEvents:UIControlEventTouchUpInside];
    [chargeButton addTarget:self action:@selector(toCharge:) forControlEvents:UIControlEventTouchUpInside];
    [drawButton addTarget:self action:@selector(toDraw:) forControlEvents:UIControlEventTouchUpInside];
    
//    chargeButton.hidden = YES;
//    drawButton.hidden = YES;
//    
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
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"登出" style:UIBarButtonItemStylePlain target:self action:@selector(signOut:)];
        self.navigationItem.rightBarButtonItem = item;
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:13], NSFontAttributeName,nil] forState:UIControlStateNormal];
        [self setupData];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
        dingqiNumLabel.text = @"0";
        huoqiNumLabel.text = @"0";
        propertyLabel.text = @"0";
        balanceLabel.text = @"0";
        bonusNumLabel.text = @"0";
        securityLabel.text = @"低";
        UINavigationController *nav = [[self storyboard]instantiateViewControllerWithIdentifier:@"LoginNav"];
        [[self tabBarController] presentViewController:nav animated:YES completion:nil];
    }
}

- (void)setupData
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:@"api/account/getUserInfoInAPP"];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        NSString *str = [responseObject objectForKey:@"isSuccess"];
        int f1 = str.intValue;
        if (f1 == 1)
        {
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
            [formatter setPositiveFormat:@"###,##0.00"];
            dingqiNumLabel.text = [NSString stringWithString:[formatter stringFromNumber:[responseObject objectForKey:@"activeInvestTotalAmount"]]];
            huoqiNumLabel.text = [NSString stringWithString:[formatter stringFromNumber:[responseObject objectForKey:@"ztbBalance"]]];
            propertyLabel.text = [NSString stringWithString:[formatter stringFromNumber:[responseObject objectForKey:@"totalAsset"]]];
            balanceLabel.text = [NSString stringWithString:[formatter stringFromNumber:[responseObject objectForKey:@"fundsAvailable"]]];
            bonusNumLabel.text = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"acitveCouponsAmount"]];
            securityLabel.text = [responseObject objectForKey:@"levelStr"];
        }
        else
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = [responseObject objectForKey:@"errorMessage"];
            [hud hide:YES afterDelay:1.5f];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"当前网络状况不佳，请重试";
        [hud hide:YES afterDelay:1.5f];
    }];
}

- (void)toCharge:(id)sender
{
    ChargeViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"ChargeViewController"];
    [[self navigationController]pushViewController:vc animated:YES];
}

- (void)toDraw:(id)sender
{
    DrawViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"DrawViewController"];
    [[self navigationController]pushViewController:vc animated:YES];
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
    DetailViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"DetailViewController"];
    [[self navigationController]pushViewController:vc animated:YES];
}

- (void)toBankCard:(id)sender
{
    BankCardViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"BankCardViewController"];
    [[self navigationController]pushViewController:vc animated:YES];
}

- (void)toBonus:(id)sender
{
    BonusViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"BonusViewController"];
    [[self navigationController]pushViewController:vc animated:YES];
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
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [self.navigationController.view addSubview:hud];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:@"Account/SignOut"];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        NSString *str = [responseObject objectForKey:@"isAuthenticated"];
        int f1 = str.intValue;
        if (f1 == 0)
        {
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = [responseObject objectForKey:@"errorMessage"];
            [hud hide:YES afterDelay:1.5f];
        }
        else
        {
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"登出成功";
            [hud hide:YES afterDelay:1.0f];
            self.navigationItem.leftBarButtonItem = nil;
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setBool:NO forKey:ISLOGIN];
            [userDefault synchronize];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[self tabBarController]setSelectedIndex:0];
            });
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"登出成功";
        [hud hide:YES afterDelay:1.0f];
        self.navigationItem.leftBarButtonItem = nil;
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setBool:NO forKey:ISLOGIN];
        [userDefault synchronize];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[self tabBarController]setSelectedIndex:0];
        });
    }];
    
}


@end
