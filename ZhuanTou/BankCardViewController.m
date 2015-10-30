//
//  BankCardViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/30.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "BankCardViewController.h"

@interface BankCardViewController ()

@end

@implementation BankCardViewController

@synthesize noBankCardView, addBankCardButton;
@synthesize bankCardView, bankImage, bankNameLabel, cardNumLabel, branchLabel, descriptionLabel, oneLimitLabel, dayLimitLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
    backItem.tintColor = ZTBLUE;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
    
    [bankCardView.layer setBorderWidth:1.0f];
    [bankCardView.layer setBorderColor:[UIColor colorWithRed:56.0/255.0 green:148.0/255.0 blue:238.0/255.0 alpha:100].CGColor];
    bankCardView.layer.cornerRadius = 3;
    
    bankCardView.hidden = YES;
    descriptionLabel.hidden = YES;
    addBankCardButton.layer.cornerRadius = 3;
    [addBankCardButton addTarget:self action:@selector(toAddBankCard:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)viewDidAppear:(BOOL)animated
{
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
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:@"api/withdraw/accountBankCards"];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        NSString *str = [responseObject objectForKey:@"isSuccess"];
        int f1 = str.intValue;
        if (f1 == 1)
        {
            [hud hide:YES];
            addBankCardButton.hidden = YES;
            noBankCardView.hidden = YES;
            descriptionLabel.hidden = NO;
            bankNameLabel.text = [responseObject objectForKey:@"bankName"];
            branchLabel.text = [responseObject objectForKey:@"subbranchBankName"];
            cardNumLabel.text = [responseObject objectForKey:@"cardCode"];
            oneLimitLabel.text = [responseObject objectForKey:@"limitAmount"];
            dayLimitLabel.text = [responseObject objectForKey:@"dailyLimit"];
        }
        else
        {
            [hud hide:YES];
            bankCardView.hidden = YES;
            noBankCardView.hidden = NO;
            addBankCardButton.hidden = NO;
            descriptionLabel.hidden = YES;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"当前网络状况不佳，请重试";
        [hud hide:YES afterDelay:1.5f];
    }];

}

- (void)toAddBankCard:(id)sender
{
    AddBankCardViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"AddBankCardViewController"];
    [[self navigationController]pushViewController:vc animated:YES];
}

@end