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
    self.view.clipsToBounds = YES;
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
    noBankCardView.hidden = YES;
    addBankCardButton.layer.cornerRadius = 3;
    [addBankCardButton addTarget:self action:@selector(toAddBankCard:) forControlEvents:UIControlEventTouchUpInside];
    addBankCardButton.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
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
    NSString *URL = [BASEURL stringByAppendingString:@"api/account/getAppBankCards"];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
        NSLog(@"%@", responseObject);
//        NSString *str = [responseObject objectForKey:@"isSuccess"];
//        int f1 = str.intValue;
        if (responseObject.count > 0)
        {
            [hud hide:YES];
            bankCardView.hidden = NO;
            addBankCardButton.hidden = YES;
            noBankCardView.hidden = YES;
            descriptionLabel.hidden = NO;
            bankNameLabel.text = [responseObject[0] objectForKey:@"bankName"];
           // branchLabel.text = [[responseObject[0] objectForKey:@"subBankName"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            branchLabel.text = [responseObject[0] objectForKey:@"subBankName"];
            cardNumLabel.text = [responseObject[0] objectForKey:@"cardCode"];
            oneLimitLabel.text = [responseObject[0] objectForKey:@"limitAmount"];
            dayLimitLabel.text = [responseObject[0] objectForKey:@"dailyLimit"];
            bankImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[responseObject[0] objectForKey:@"imgUrl"]]]];
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
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:@"api/account/IsIdentified"];
    [manager POST:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"%@",responseObject);
        NSString *str = [responseObject objectForKey:@"isSuccess"];
        int f1 = str.intValue;
        if (f1 == 1)
        {
            [hud hide:YES];
            AddBankCardViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"AddBankCardViewController"];
            [vc setFullName:[responseObject objectForKey:@"fullName"]];
            [[self navigationController]pushViewController:vc animated:YES];
        }
        else
        {
            [hud hide:YES];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您还未进行实名验证，请先进行实名验证" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                RealNameViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"RealNameViewController"];
                [[self navigationController]pushViewController:vc animated:YES];
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:confirmAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"当前网络状况不佳，请重试";
        [hud hide:YES afterDelay:1.5f];
    }];

    
}

@end
