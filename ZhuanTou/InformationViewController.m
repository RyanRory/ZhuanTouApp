//
//  InformationViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/14.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "InformationViewController.h"

@interface InformationViewController ()

@end

@implementation InformationViewController

@synthesize usernameTextField, passwordTextField, pswdAgainTextFiled, nextButton, textView, recommendTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
    backItem.tintColor = ZTBLUE;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    
    textView.layer.cornerRadius = 3;
    nextButton.layer.cornerRadius = 3;
    [nextButton setUserInteractionEnabled:NO];
    [nextButton setAlpha:0.6f];
    
    [nextButton addTarget:self action:@selector(toNextPage:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backToParent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)toNextPage:(id)sender
{
    [usernameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [pswdAgainTextFiled resignFirstResponder];
    [recommendTextField resignFirstResponder];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [self.navigationController.view addSubview:hud];
    NSString *PasswordReg = @"(?=.*[0-9])(?=.*[a-zA-Z]).{6,30}";
    NSPredicate *regextestpassword = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PasswordReg];
    if(![passwordTextField.text isEqualToString: pswdAgainTextFiled.text])
    {
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"两次输入的密码不一致";
        [hud hide:YES afterDelay:1.5f];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [pswdAgainTextFiled becomeFirstResponder];
        });
    }
    else if(![regextestpassword evaluateWithObject: passwordTextField.text])
    {
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"密码至少6位，包括数字和字母";
        [hud hide:YES afterDelay:1.5f];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [passwordTextField becomeFirstResponder];
        });
    }
    else if (!((recommendTextField.text.length == 0) || [[NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0-9]{11}$"] evaluateWithObject:recommendTextField.text]))
    {
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"请检查推荐人手机号码是否正确";
        [hud hide:YES afterDelay:1.5f];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [recommendTextField becomeFirstResponder];
        });
    }
    else
    {
        [nextButton setUserInteractionEnabled:NO];
        [nextButton setAlpha:0.6f];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        smsCode = [userDefaults objectForKey:SMSCODE];
        phoneNum = [userDefaults objectForKey:PHONENUM];
        
        hud.mode = MBProgressHUDModeIndeterminate;
        [hud show:YES];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = @{@"username":usernameTextField.text,
                                     @"mobile":phoneNum,
                                     @"password":passwordTextField.text,
                                     @"confirmPassword":pswdAgainTextFiled.text,
                                     @"smsCode":smsCode,
                                     @"referrerCode":recommendTextField.text};
        NSLog(@"%@", parameters);
        NSString *URL = [BASEURL stringByAppendingString:@"api/account/register"];
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
                hud.labelText = @"注册成功";
                [hud hide:YES afterDelay:1.5f];
                [userDefaults setObject:usernameTextField.text forKey:USERNAME];
                [userDefaults setObject:passwordTextField.text forKey:PASSWORD];
                [userDefaults setBool:YES forKey:ISLOGIN];
                [userDefaults synchronize];
                
                [KeychainData forgotPsw];
                SetpasswordViewController *setpass = [[self storyboard]instantiateViewControllerWithIdentifier:@"SetpasswordViewController"];
                setpass.string = @"重置密码";
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[self navigationController]pushViewController:setpass animated:YES];
                });
            }
            [nextButton setUserInteractionEnabled:YES];
            [nextButton setAlpha:1.0f];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"当前网络状况不佳，请重试";
            [hud hide:YES afterDelay:1.5f];
            [nextButton setUserInteractionEnabled:YES];
            [nextButton setAlpha:1.0f];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)textFiledReturnEditing:(id)sender {
    if (sender == usernameTextField)
    {
        [passwordTextField becomeFirstResponder];
        [usernameTextField resignFirstResponder];
    }
    else if (sender == passwordTextField)
    {
        [passwordTextField resignFirstResponder];
        [pswdAgainTextFiled becomeFirstResponder];
    }
    else if (sender == pswdAgainTextFiled)
    {
        [pswdAgainTextFiled resignFirstResponder];
        [recommendTextField becomeFirstResponder];
    }
    else
    {
        [recommendTextField resignFirstResponder];
    }
}

- (IBAction)backgroundTap:(id)sender {
    [usernameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [pswdAgainTextFiled resignFirstResponder];
    [recommendTextField resignFirstResponder];
}

- (IBAction)buttonEnableListener:(id)sender
{
    if ((usernameTextField.text.length > 0) && (passwordTextField.text.length > 0) && (pswdAgainTextFiled.text.length > 0))
    {
        [nextButton setUserInteractionEnabled:YES];
        [nextButton setAlpha:1.0f];
    }
    else
    {
        [nextButton setUserInteractionEnabled:NO];
        [nextButton setAlpha:0.6f];
    }
}

@end
