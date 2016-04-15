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

@synthesize balanceLabel, bgView, drawNumTextField, confirmButton;
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
    
    [drawNumTextField becomeFirstResponder];
    [drawNumTextField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    
    SCNumberKeyBoard *keyboard = [SCNumberKeyBoard showWithTextField:drawNumTextField enter:nil close:nil];
    [keyboard.enterButton setBackgroundColor:ZTBLUE];
    [keyboard.enterButton setTitle:@"确定" forState:UIControlStateNormal];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    [self buttonEnableListener:nil];
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
    if (drawNumTextField.text.doubleValue > [balanceLabel.text stringByReplacingOccurrencesOfString:@"," withString:@""].doubleValue)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"专投宝余额不足";
        [hud hide:YES afterDelay:1.5];
    }
    else
    {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        if ((int)(drawNumTextField.text.doubleValue*100) <= [userDefault integerForKey:TPTHRESHOLD])
        {
            [self draw:@""];
        }
        else
        {
            if ([userDefault boolForKey:ISTPNUMERIC])
            {
                TradePswdView *view = [[TradePswdView alloc]initWithFrame:self.navigationController.view.frame];
                [self.navigationController.view addSubview:view];
                [view showView];
                view.block = ^(NSString *tradePswd){
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                    NSString *URL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"api/account/transferOutZtb4M?amount=%@&tradePassword=%@",drawNumTextField.text,tradePswd]];
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
                };
            }
            else
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"输入交易密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
                    textField.secureTextEntry = YES;
                    textField.returnKeyType = UIReturnKeyDone;
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
                }];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    UITextField *tradePswdTextField = alertController.textFields.firstObject;
                    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
                    [self draw:tradePswdTextField.text];
                }];
                [alertController addAction:cancelAction];
                [alertController addAction:confirmAction];
                confirmAction.enabled = NO;
                [self presentViewController:alertController animated:YES completion:nil];
                
            }
        }

    }

}

- (void)alertTextFieldDidChange:(NSNotification *)notification{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController) {
        UITextField *tradePswdTextField = alertController.textFields.firstObject;
        UIAlertAction *confirmAction = alertController.actions.lastObject;
        confirmAction.enabled = tradePswdTextField.text.length >= 6;
    }
}

- (void)draw:(NSString*)tradePswd
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL;
    if (tradePswd.length == 0)
    {
        URL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"api/account/transferOutZtb?amount=%@",drawNumTextField.text]];
    }
    else
    {
        URL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"api/account/transferOutZtb4M?amount=%@&tradePassword=%@",drawNumTextField.text,tradePswd]];
    }
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

- (IBAction)textFiledReturnEditing:(id)sender{
    [drawNumTextField resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender{
    [drawNumTextField resignFirstResponder];
}

- (IBAction)buttonEnableListener:(id)sender{
    if (drawNumTextField.text.length > 0)
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
