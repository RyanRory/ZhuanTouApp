//
//  ProductBuyConfirmViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/16.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "ProductBuyConfirmViewController.h"

@interface ProductBuyConfirmViewController ()

@end

@implementation ProductBuyConfirmViewController

@synthesize confirmButton, contentView, wenjianView;
@synthesize bgView;
@synthesize preIncomeLabel, preIncomeNumLabel, productTimeLabel, productTimeNumLabel, lowestIncomeLabel, lowestIncomeNumLabel, amountNumLabel, amoutLabel;

@synthesize wenjianBgView, wenjianAmountLabel, wenjianAmountNumLabel, wenjianPILabel, wenjianPINumLabel, wenjianPTLabel, wenjianPTNumLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
    
    contentView.layer.cornerRadius = 3;
    confirmButton.layer.cornerRadius = 3;
    wenjianView.layer.cornerRadius = 3;
    
    [confirmButton addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([style isEqualToString:WENJIAN])
    {
        [self setupWenjian];
    }
    else if ([style isEqualToString:ZONGHE])
    {
        [self setupZonghe];
    }
    else
    {
        [self setupHuoqi];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)backToParent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setStyle:(NSString*)str
{
    style = str;
}

-(void)setupWenjian
{
    [contentView setHidden:YES];
    wenjianBgView.backgroundColor = ZTLIGHTRED;
    confirmButton.backgroundColor = ZTLIGHTRED;
    wenjianPILabel.textColor = ZTLIGHTRED;
    wenjianPINumLabel.textColor = ZTLIGHTRED;
    wenjianPTLabel.textColor = ZTLIGHTRED;
    wenjianPTNumLabel.textColor = ZTLIGHTRED;
    wenjianAmountLabel.textColor = ZTLIGHTRED;
    wenjianAmountNumLabel.textColor = ZTLIGHTRED;
    
}

- (void)setupZonghe
{
    [wenjianView setHidden:YES];
    bgView.backgroundColor = ZTBLUE;
    confirmButton.backgroundColor = ZTBLUE;
    preIncomeLabel.textColor = ZTBLUE;
    preIncomeNumLabel.textColor = ZTBLUE;
    productTimeLabel.textColor = ZTBLUE;
    productTimeNumLabel.textColor = ZTBLUE;
    lowestIncomeLabel.textColor = ZTBLUE;
    lowestIncomeNumLabel.textColor = ZTBLUE;
    amoutLabel.textColor = ZTBLUE;
    amountNumLabel.textColor = ZTBLUE;
}

- (void)setupHuoqi
{
    [wenjianView setHidden:YES];
    bgView.backgroundColor = ZTRED;
    confirmButton.backgroundColor = ZTRED;
    preIncomeLabel.textColor = ZTRED;
    preIncomeNumLabel.textColor = ZTRED;
    productTimeLabel.textColor = ZTRED;
    productTimeNumLabel.textColor = ZTRED;
    lowestIncomeLabel.textColor = ZTRED;
    lowestIncomeNumLabel.textColor = ZTRED;
    amoutLabel.textColor = ZTRED;
    amountNumLabel.textColor = ZTRED;
}

- (void)confirm:(id)sender
{
    
}


@end
