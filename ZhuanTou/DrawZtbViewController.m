//
//  DrawZtbViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/11/9.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "DrawZtbViewController.h"

@interface DrawZtbViewController ()

@end

@implementation DrawZtbViewController

@synthesize balanceLabel, bgView, drawNumTextField, tradePswdTextField, confirmButton;
@synthesize balance;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
    backItem.tintColor = ZTBLUE;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
    
    bgView.layer.cornerRadius = 3;
    bgView.clipsToBounds = YES;
    balanceLabel.text = [NSString stringWithFormat:@"%@元",balance];
    
    confirmButton.layer.cornerRadius = 3;
    [confirmButton addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton setUserInteractionEnabled:NO];
    [confirmButton setAlpha:0.6f];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backToParent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)confirm:(id)sender
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    if (drawNumTextField.text.doubleValue > [balanceLabel.text stringByReplacingOccurrencesOfString:@"," withString:@""].doubleValue)
    {
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"专投宝余额不足";
        [hud hide:YES afterDelay:1.5];
    }
    else
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *URL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"api/account/transferOutZtb4M?amount=%@&tradePassword=%@",drawNumTextField.text,tradePswdTextField.text]];
        [manager POST:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
            NSLog(@"%@",responseObject);
            NSString *str = [responseObject objectForKey:@"isSuccess"];
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
                hud.labelText = @"转出成功";
                [hud hide:YES afterDelay:1.5f];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[self navigationController]popViewControllerAnimated:YES];
                });
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"当前网络状况不佳，请重试";
            [hud hide:YES afterDelay:1.5f];
        }];
    }

}

- (IBAction)textFiledReturnEditing:(id)sender{
    if (sender == drawNumTextField)
    {
        [drawNumTextField resignFirstResponder];
        [tradePswdTextField becomeFirstResponder];
    }
    else
    {
        [tradePswdTextField resignFirstResponder];
    }
}

- (IBAction)backgroundTap:(id)sender{
    [drawNumTextField resignFirstResponder];
    [tradePswdTextField resignFirstResponder];
}

- (IBAction)buttonEnableListener:(id)sender{
    if ((drawNumTextField.text.length > 0) && (tradePswdTextField.text.length > 0))
    {
        [confirmButton setUserInteractionEnabled:YES];
        [confirmButton setAlpha:1.0f];
    }
    else
    {
        [confirmButton setUserInteractionEnabled:NO];
        [confirmButton setAlpha:0.6f];
    }
}


@end
