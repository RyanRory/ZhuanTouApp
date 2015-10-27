//
//  SetTradePswdViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/22.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "SetTradePswdViewController.h"

@interface SetTradePswdViewController ()

@end

@implementation SetTradePswdViewController

@synthesize tradePswdTextField, tradePswdAgainTextField, confirmButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
    backItem.tintColor = ZTBLUE;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
    
    [confirmButton setUserInteractionEnabled:NO];
    [confirmButton setAlpha:0.6f];
    confirmButton.layer.cornerRadius = 3;
    [confirmButton addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
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
    [tradePswdTextField resignFirstResponder];
    [tradePswdAgainTextField resignFirstResponder];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [self.navigationController.view addSubview:hud];
    NSString *PasswordReg = @"^[a-zA-Z0-9!@#$%^&*()_+|]{8,30}$";
    NSPredicate *regextestpassword = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PasswordReg];
    if(![tradePswdTextField.text isEqualToString: tradePswdAgainTextField.text])
    {
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"两次输入的密码不一致";
        [hud hide:YES afterDelay:1.5f];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [tradePswdAgainTextField becomeFirstResponder];
        });
    }
    else if(![regextestpassword evaluateWithObject: tradePswdTextField.text])
    {
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"密码至少8位，包括数字和字母";
        [hud hide:YES afterDelay:1.5f];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [tradePswdTextField becomeFirstResponder];
        });
    }
    else
    {
        [confirmButton setUserInteractionEnabled:NO];
        [confirmButton setAlpha:0.6f];
        hud.mode = MBProgressHUDModeIndeterminate;
        [hud show:YES];
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = @{@"tradePassword":tradePswdTextField.text,
                                     @"loginPassword":[userDefault objectForKey:PASSWORD]};
        NSString *URL = [BASEURL stringByAppendingString:@"api/account/setTradePassword"];
        [manager POST:URL parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
            NSLog(@"%@", responseObject);
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
                [hud hide:YES];
                hud.mode = MBProgressHUDModeCustomView;
                hud.labelText = @"设置成功";
                [hud hide:YES afterDelay:1.5f];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
                
            }
            [confirmButton setUserInteractionEnabled:YES];
            [confirmButton setAlpha:1.0f];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"当前网络状况不佳，请重试";
            [hud hide:YES afterDelay:1.5f];
            [confirmButton setUserInteractionEnabled:YES];
            [confirmButton setAlpha:1.0f];
        }];
    }
}

-(IBAction)textFiledReturnEditing:(id)sender {
    if (sender == tradePswdTextField)
    {
        [tradePswdAgainTextField becomeFirstResponder];
        [tradePswdTextField resignFirstResponder];
    }
    else [tradePswdAgainTextField resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [tradePswdTextField resignFirstResponder];
    [tradePswdAgainTextField resignFirstResponder];
}

- (IBAction)buttonEnableListener:(id)sender
{
    if ((tradePswdTextField.text.length > 0) && (tradePswdAgainTextField.text.length > 0))
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
