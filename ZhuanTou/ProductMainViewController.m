//
//  ProductMainViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/15.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "ProductMainViewController.h"

@interface ProductMainViewController ()

@end

@implementation ProductMainViewController

@synthesize wenjianButton, zongheButton, huoqiButton;
@synthesize featureButton1, featureButton2, featureButton3, detailButton;
@synthesize bigRateLabel, monthNumLabel, percentLabel, rateContentLabel, bgCircleImageView, circleImageView;
@synthesize productsBeforeButton;
@synthesize smallRateLabel, rightView;
@synthesize amountLabel, timeLabel, buyButton;
@synthesize bgView, triangleImageView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    
    [wenjianButton addTarget:self action:@selector(clickWenjianButton:) forControlEvents:UIControlEventTouchUpInside];
    [zongheButton addTarget:self action:@selector(clickZongheButton:) forControlEvents:UIControlEventTouchUpInside];
    [huoqiButton addTarget:self action:@selector(clickHuoqi:) forControlEvents:UIControlEventTouchUpInside];
    
    [wenjianButton setUserInteractionEnabled:NO];
    wenjianButton.tintColor = ZTLIGHTRED;
    [self setupWenjian];
    
}

- (void)setupWenjian
{
    [rightView setHidden:YES];
    bgView.backgroundColor = ZTLIGHTRED;
    triangleImageView.image = [UIImage imageNamed:@"wenjianTriangle.png"];
    circleImageView.image = [UIImage imageNamed:@"wenjian.png"];
    bigRateLabel.tintColor = ZTLIGHTRED;
    percentLabel.tintColor = ZTLIGHTRED;
    rateContentLabel.tintColor = ZTLIGHTRED;
    rateContentLabel.text = @"固定年化收益率";
    productsBeforeButton.tintColor = ZTLIGHTRED;
    
}

- (void)setupZonghe
{
    
}

- (void)setupHuoqi
{
    
}

- (void)clickWenjianButton:(id)sender
{
    [self setupWenjian];
    wenjianButton.tintColor = ZTLIGHTRED;
    [wenjianButton setUserInteractionEnabled:NO];
    [zongheButton setUserInteractionEnabled:YES];
    [huoqiButton setUserInteractionEnabled:YES];
    zongheButton.tintColor = ZTLIGHTGRAY;
    huoqiButton.tintColor = ZTLIGHTGRAY;
}

- (void)clickZongheButton:(id)sender
{
    [self setupZonghe];
    zongheButton.tintColor = ZTBLUE;
    [zongheButton setUserInteractionEnabled:NO];
    [wenjianButton setUserInteractionEnabled:YES];
    [huoqiButton setUserInteractionEnabled:YES];
    wenjianButton.tintColor = ZTLIGHTGRAY;
    huoqiButton.tintColor = ZTLIGHTGRAY;
}

- (void)clickHuoqi:(id)sender
{
    [self setupHuoqi];
    huoqiButton.tintColor = ZTRED;
    [huoqiButton setUserInteractionEnabled:NO];
    [wenjianButton setUserInteractionEnabled:YES];
    [zongheButton setUserInteractionEnabled:YES];
    wenjianButton.tintColor = ZTLIGHTGRAY;
    zongheButton.tintColor = ZTLIGHTGRAY;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
