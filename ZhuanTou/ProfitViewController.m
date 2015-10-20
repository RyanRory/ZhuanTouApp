//
//  ProfitViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/20.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "ProfitViewController.h"

@interface ProfitViewController ()

@end

@implementation ProfitViewController

@synthesize dingqiPercentLabel, huoqiPercentLabel, balancePercentLabel, frozenPercentLabel;
@synthesize dingqiNumLabel, huoqiNumLabel, balanceNumLabel, frozenNumLabel;
@synthesize contentView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    contentView.layer.cornerRadius = 3;
    
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
    dingqiPercentLabel.text = [NSString stringWithFormat:@"%0.2f%%",25.00];
    huoqiPercentLabel.text = [NSString stringWithFormat:@"%0.2f%%",25.00];
    balancePercentLabel.text = [NSString stringWithFormat:@"%0.2f%%",25.00];
    frozenPercentLabel.text = [NSString stringWithFormat:@"%0.2f%%",25.00];
    
    
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    [formatter setPositiveFormat:@"###,##0.00元"];
    dingqiNumLabel.text = [NSString stringWithString:[formatter stringFromNumber:[NSNumber numberWithDouble:10000.00]]];
    huoqiNumLabel.text = [NSString stringWithString:[formatter stringFromNumber:[NSNumber numberWithDouble:10000.00]]];
    balanceNumLabel.text = [NSString stringWithString:[formatter stringFromNumber:[NSNumber numberWithDouble:10000.00]]];
    frozenNumLabel.text = [NSString stringWithString:[formatter stringFromNumber:[NSNumber numberWithDouble:10000.00]]];;

}


@end
