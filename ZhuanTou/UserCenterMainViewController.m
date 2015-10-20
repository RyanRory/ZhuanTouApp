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

- (void)setupData
{
    propertyLabel.text = @"￥100,600,4";
    balanceLabel.text = @"￥100,600,4";
    dingqiNumLabel.text = @"￥100,600,4";
    huoqiNumLabel.text = @"￥100,600,4";
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
    
}

- (void)toGesture:(id)sender
{
    
}


@end
