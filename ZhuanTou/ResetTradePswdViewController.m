//
//  ResetTradePswdViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/22.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "ResetTradePswdViewController.h"

@interface ResetTradePswdViewController ()

@end

@implementation ResetTradePswdViewController

@synthesize oldPswdTextField, nPswdAgainTextField, nPswdTextTextField, confirmButton, forgetButton, icon1, icon2, icon3;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
    backItem.tintColor = ZTBLUE;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
    
    [confirmButton setUserInteractionEnabled:NO];
    [confirmButton setAlpha:0.6f];
    confirmButton.layer.cornerRadius = 3;
    [confirmButton addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    [forgetButton addTarget:self action:@selector(toForgotten:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([style isEqualToString:RESETLOGINPSWD])
    {
        self.title = @"修改登录密码";
        oldPswdTextField.placeholder = @"输入原登录密码";
        nPswdAgainTextField.placeholder = @"确认新登录密码";
        nPswdTextTextField.placeholder = @"输入新登录密码";
        UIImage *image = [UIImage imageNamed:@"loginPwIcon.png"];
        icon1.image = image;
        icon2.image = image;
        icon3.image = image;
        oldPswdTextField.keyboardType = UIKeyboardTypeDefault;
        nPswdTextTextField.keyboardType = UIKeyboardTypeDefault;
        nPswdAgainTextField.keyboardType = UIKeyboardTypeDefault;
    }
    else
    {
        self.title = @"修改交易密码";
        oldPswdTextField.placeholder = @"输入原交易密码";
        nPswdAgainTextField.placeholder = @"确认新交易密码";
        nPswdTextTextField.placeholder = @"输入新交易密码";
        UIImage *image = [UIImage imageNamed:@"tradePwIcon.png"];
        icon1.image = image;
        icon2.image = image;
        icon3.image = image;
        oldPswdTextField.keyboardType = UIKeyboardTypeDecimalPad;
        nPswdTextTextField.keyboardType = UIKeyboardTypeDecimalPad;
        nPswdAgainTextField.keyboardType = UIKeyboardTypeDecimalPad;
    }
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
    [oldPswdTextField resignFirstResponder];
    [nPswdTextTextField resignFirstResponder];
    [nPswdAgainTextField resignFirstResponder];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [self.navigationController.view addSubview:hud];
    NSString *PasswordReg;
    if ([style isEqualToString:RESETLOGINPSWD])
    {
        PasswordReg = @"^(?=.*[0-9])(?=.*[a-zA-Z!@#$%^&*()_+|]).{6,30}$";
    }
    else
    {
        PasswordReg = @"^[0-9]{6}$";
    }
    NSPredicate *regextestpassword = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PasswordReg];
    if (![regextestpassword evaluateWithObject: oldPswdTextField.text])
    {
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"请输入正确的原始密码";
        [hud hide:YES afterDelay:1.5f];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [oldPswdTextField becomeFirstResponder];
        });

    }
    else if(![nPswdAgainTextField.text isEqualToString: nPswdTextTextField.text])
    {
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"两次输入的密码不一致";
        [hud hide:YES afterDelay:1.5f];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [nPswdAgainTextField becomeFirstResponder];
        });
    }
    else if(![regextestpassword evaluateWithObject: nPswdAgainTextField.text])
    {
        hud.mode = MBProgressHUDModeCustomView;
        if ([style isEqualToString:RESETLOGINPSWD])
        {
            hud.labelText = @"密码至少6位，包括数字和字母";
        }
        else
        {
            hud.labelText = @"密码必须为6位数字";
        }
        [hud hide:YES afterDelay:1.5f];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [nPswdAgainTextField becomeFirstResponder];
        });
    }
    else
    {
        [confirmButton setUserInteractionEnabled:NO];
        [confirmButton setAlpha:0.6f];
        hud.mode = MBProgressHUDModeIndeterminate;
        [hud show:YES];

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters;
        NSString *URL;
        
        if ([style isEqualToString:RESETLOGINPSWD])
        {
            parameters = @{@"password":oldPswdTextField.text,
                           @"newPassword":nPswdTextTextField.text};
            URL = [BASEURL stringByAppendingString:@"api/account/resetPassword"];
        }
        else
        {
            parameters = @{@"tradePassword":oldPswdTextField.text,
                           @"newTradePassword":nPswdTextTextField.text};
            URL = [BASEURL stringByAppendingString:@"api/account/changeTradePassword"];
        }
        
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
                
                if ([style isEqualToString:RESETLOGINPSWD])
                {
                    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                    [userDefault removeObjectForKey:PASSWORD];
                    [userDefault setBool:NO forKey:ISLOGIN];
                    [userDefault synchronize];
                    [hud hide:YES];
                    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"您已重置密码，请重新登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }];
                    [alertVC addAction:confirm];
                    [self presentViewController:alertVC animated:YES completion:nil];
                }
                else
                {
                    hud.mode = MBProgressHUDModeCustomView;
                    hud.labelText = @"重置成功";
                    [hud hide:YES afterDelay:1.5f];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }
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

- (void)toForgotten:(id)sender
{
    ForgottenViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"ForgottenViewController"];
    [vc setStyle:style];
    [[self navigationController]pushViewController:vc animated:YES];
}

- (void)setStyle:(NSString *)str
{
    style = str;
}

-(IBAction)textFiledReturnEditing:(id)sender {
    if (sender == oldPswdTextField)
    {
        [nPswdTextTextField becomeFirstResponder];
        [oldPswdTextField resignFirstResponder];
    }
    else if (sender == nPswdTextTextField)
    {
        [nPswdAgainTextField becomeFirstResponder];
        [nPswdTextTextField resignFirstResponder];
    }
    else [nPswdAgainTextField resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [oldPswdTextField resignFirstResponder];
    [nPswdTextTextField resignFirstResponder];
    [nPswdAgainTextField resignFirstResponder];
}

- (IBAction)buttonEnableListener:(id)sender
{
    if ((oldPswdTextField.text.length > 0) && (nPswdTextTextField.text.length > 0) && (nPswdAgainTextField.text.length > 0))
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
