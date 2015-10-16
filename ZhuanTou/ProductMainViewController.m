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
@synthesize bigRateLabel, monthNumLabel, moryLabel, percentLabel, rateContentLabel, bgCircleImageView, circleImageView;
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
    
    [productsBeforeButton setTitle:[NSString stringWithFormat:@"查看\n往期产品"] forState:UIControlStateNormal];
    productsBeforeButton.titleLabel.numberOfLines = 0;
    productsBeforeButton.titleLabel.textAlignment = 1;
    [productsBeforeButton addTarget:self action:@selector(goToProductsBefore:) forControlEvents:UIControlEventTouchUpInside];
    
    [featureButton1 setUserInteractionEnabled:NO];
    [featureButton2 setUserInteractionEnabled:NO];
    [featureButton3 setUserInteractionEnabled:NO];
    [detailButton addTarget:self action:@selector(goToDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    [wenjianButton setUserInteractionEnabled:NO];
    wenjianButton.tintColor = ZTLIGHTRED;
    zongheButton.tintColor = ZTLIGHTGRAY;
    huoqiButton.tintColor = ZTLIGHTGRAY;
    [self setupWenjian];
    
    buyButton.layer.cornerRadius = 3;
    [buyButton addTarget:self action:@selector(buyNow:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setupWenjian
{
    [rightView setHidden:YES];
    [moryLabel setHidden:NO];
    [monthNumLabel setHidden:NO];
    [productsBeforeButton setHidden:NO];
    bgView.backgroundColor = ZTLIGHTRED;
    triangleImageView.image = [UIImage imageNamed:@"wenjianTriangle.png"];
    circleImageView.image = [UIImage imageNamed:@"wenjian.png"];
    bigRateLabel.textColor = ZTLIGHTRED;
    percentLabel.textColor = ZTLIGHTRED;
    rateContentLabel.textColor = ZTLIGHTRED;
    rateContentLabel.text = @"固定年化收益率";
    productsBeforeButton.tintColor = ZTLIGHTRED;
    [featureButton1 setImage:[UIImage imageNamed:@"profitIcon.png"] forState:UIControlStateNormal];
    [featureButton1 setTitle:@"较高收益" forState:UIControlStateNormal];
    [buyButton setBackgroundColor:ZTLIGHTRED];
}

- (void)setupZonghe
{
    [rightView setHidden:NO];
    [moryLabel setHidden:NO];
    [monthNumLabel setHidden:NO];
    [productsBeforeButton setHidden:NO];
    bgView.backgroundColor = ZTBLUE;
    triangleImageView.image = [UIImage imageNamed:@"zongheTriangle.png"];
    circleImageView.image = [UIImage imageNamed:@"zonghe.png"];
    bigRateLabel.textColor = ZTBLUE;
    percentLabel.textColor = ZTBLUE;
    rateContentLabel.textColor = ZTBLUE;
    rateContentLabel.text = @"预期年化收益率";
    productsBeforeButton.tintColor = ZTBLUE;
    [featureButton1 setImage:[UIImage imageNamed:@"profitIcon.png"] forState:UIControlStateNormal];
    [featureButton1 setTitle:@"超高收益" forState:UIControlStateNormal];
    [buyButton setBackgroundColor:ZTBLUE];
}

- (void)setupHuoqi
{
    [rightView setHidden:YES];
    [moryLabel setHidden:YES];
    [monthNumLabel setHidden:YES];
    [productsBeforeButton setHidden:YES];
    bgView.backgroundColor = ZTRED;
    triangleImageView.image = [UIImage imageNamed:@"huoqiTriangle.png"];
    circleImageView.image = [UIImage imageNamed:@"huoqi.png"];
    bigRateLabel.textColor = ZTRED;
    percentLabel.textColor = ZTRED;
    rateContentLabel.textColor = ZTRED;
    rateContentLabel.text = @"复合年化收益率";
    productsBeforeButton.tintColor = ZTRED;
    [featureButton1 setImage:[UIImage imageNamed:@"quickIcon.png"] forState:UIControlStateNormal];
    [featureButton1 setTitle:@"随存随取" forState:UIControlStateNormal];
    [buyButton setBackgroundColor:ZTRED];
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

- (void)goToDetail:(id)sender
{
    
}

- (void)goToProductsBefore:(id)sender
{
    
}

- (void)buyNow:(id)sender
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
