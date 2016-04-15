//
//  ForgottonResetViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/29.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "ForgottonResetViewController.h"

@interface ForgottonResetViewController ()

@end

@implementation ForgottonResetViewController

@synthesize passwordTextField, pswdAgainTextField, confirmButton, icon1, icon2;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
    backItem.tintColor = ZTBLUE;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    
    [confirmButton setUserInteractionEnabled:NO];
    [confirmButton setAlpha:0.6f];
    [confirmButton addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([style isEqualToString:RESETLOGINPSWD])
    {
        self.title = @"找回登录密码";
        UIImage *image = [UIImage imageNamed:@"loginPwIcon.png"];
        icon1.image = image;
        icon2.image = image;
        passwordTextField.placeholder = @"输入新登录密码";
        pswdAgainTextField.placeholder = @"确认新登录密码";
        

    }
    else
    {
        self.title = @"找回交易密码";
        UIImage *image = [UIImage imageNamed:@"tradePwIcon.png"];
        icon1.image = image;
        icon2.image = image;
        passwordTextField.placeholder = @"输入新交易密码";
        pswdAgainTextField.placeholder = @"确认新交易密码";
    }
    
    [passwordTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setStyle:(NSString *)str
{
    style = str;
}

- (void)confirm:(id)sender
{
    [passwordTextField resignFirstResponder];
    [pswdAgainTextField resignFirstResponder];
    
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
    if(![passwordTextField.text isEqualToString: pswdAgainTextField.text])
    {
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"两次输入的密码不一致";
        [hud hide:YES afterDelay:1.5f];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [pswdAgainTextField becomeFirstResponder];
        });
    }
    else if(![regextestpassword evaluateWithObject: passwordTextField.text])
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
            [passwordTextField becomeFirstResponder];
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
        NSDictionary *parameters;
        NSString *URL;
        if ([style isEqualToString:RESETLOGINPSWD])
        {
            parameters = @{@"password":passwordTextField.text,
                           @"smsCode":[userDefault objectForKey:SMSCODE]};
            URL = [BASEURL stringByAppendingString:@"api/account/forgetPassword"];
        }
        else
        {
            parameters = @{@"tradePassword":passwordTextField.text,
                           @"smsCode":[userDefault objectForKey:SMSCODE]};
            URL = [BASEURL stringByAppendingString:@"api/account/setTradePassword"];
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
                hud.mode = MBProgressHUDModeCustomView;
                hud.labelText = @"设置成功";
                if ([style isEqualToString:RESETLOGINPSWD])
                {
                    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                    [userDefault removeObjectForKey:PASSWORD];
                    [userDefault setBool:NO forKey:ISLOGIN];
                    [userDefault synchronize];
                }
                [hud hide:YES afterDelay:1.5f];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
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

- (void)backToParent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)textFiledReturnEditing:(id)sender {
    if (sender == passwordTextField)
    {
        [pswdAgainTextField becomeFirstResponder];
        [passwordTextField resignFirstResponder];
    }
    else [pswdAgainTextField resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [passwordTextField resignFirstResponder];
    [pswdAgainTextField resignFirstResponder];
}

- (IBAction)buttonEnableListener:(id)sender
{
    if ((passwordTextField.text.length > 0) && (pswdAgainTextField.text.length > 0))
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
