//
//  HuoqiViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/18.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "HuoqiViewController.h"

@interface HuoqiViewController ()

@end

@implementation HuoqiViewController

@synthesize yesterdayProfitLabel, myPortionLabel, totalProfitLabel, buyButton, drawButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    buyButton.layer.cornerRadius = 3;
    drawButton.layer.cornerRadius = 3;
    
    yesterdayProfitLabel.format = @"%.2f";
    myPortionLabel.format = @"%.2f";
    totalProfitLabel.format = @"%.2f";
    
    
    [buyButton addTarget:self action:@selector(toBuyHuoqi:) forControlEvents:UIControlEventTouchUpInside];
    [drawButton addTarget:self action:@selector(toDrawHuoqi:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setupData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backToParent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupData
{
    [yesterdayProfitLabel countFromZeroTo:5.00 withDuration:0.8f];
    [myPortionLabel countFromZeroTo:11000 withDuration:0.8f];
    [totalProfitLabel countFromZeroTo:1000 withDuration:0.8f];
    

}

- (void)toBuyHuoqi:(id)sender
{
    
}

- (void)toDrawHuoqi:(id)sender
{
    
}

@end
