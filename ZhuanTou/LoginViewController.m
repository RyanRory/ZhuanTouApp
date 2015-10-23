//
//  LoginViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/9/29.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize forgottenButton, loginButton, usernameTextField, passwordTextField, textView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:13], NSFontAttributeName,nil] forState:UIControlStateNormal];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
    backItem.tintColor = ZTBLUE;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
    
    loginButton.layer.cornerRadius = 3;
    textView.layer.cornerRadius = 3;
    
    [loginButton addTarget:self action:@selector(Login:) forControlEvents:UIControlEventTouchUpInside];
    [forgottenButton addTarget:self action:@selector(ToForgotten:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    usernameTextField.text = [userDefaults objectForKey:USERNAME];
    passwordTextField.text = [userDefaults objectForKey:PASSWORD];
    if ((usernameTextField.text.length == 0) || (passwordTextField.text.length == 0))
    {
        [loginButton setUserInteractionEnabled:NO];
        [loginButton setAlpha:0.6f];
    }
}

- (void)Login:(id)sender
{
    NSString *PasswordReg = @"(?=.*[0-9])(?=.*[a-zA-Z]).{6,30}";
    NSPredicate *regextestpassword = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PasswordReg];
    if(![regextestpassword evaluateWithObject: passwordTextField.text])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"密码至少6位，包括数字和字母" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        [loginButton setUserInteractionEnabled:NO];
        [loginButton setAlpha:0.6f];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = @{@"login":usernameTextField.text,
                                     @"password":passwordTextField.text};
        NSString *URL = [BASEURL stringByAppendingString:@"api/auth/signIn"];
        [manager POST:URL parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
            NSLog(@"%@", responseObject);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *str = [responseObject objectForKey:@"isAuthenticated"];
            int f1 = str.intValue;
            if (f1 == 0)
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[responseObject objectForKey:@"errorMessage"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录成功！" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                [userDefault setBool:YES forKey:ISLOGIN];
                [userDefault synchronize];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
            [loginButton setUserInteractionEnabled:YES];
            [loginButton setAlpha:1.0f];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录失败，请重试！" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
            [loginButton setUserInteractionEnabled:YES];
            [loginButton setAlpha:1.0f];
        }];
    }

}


- (void)ToForgotten:(id)sender
{
    
}

- (void)backToParent:(id)sender
{
    ZTTabBarViewController *vc = (ZTTabBarViewController*)[self presentingViewController];
    [vc setSelectedIndex:vc.lastSelectedIndex];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)textFiledReturnEditing:(id)sender {
    if (sender == usernameTextField)
    {
        [passwordTextField becomeFirstResponder];
        [usernameTextField resignFirstResponder];
    }
    else [passwordTextField resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [usernameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
}

- (IBAction)buttonEnableListener:(id)sender
{
    if ((usernameTextField.text.length > 0) && (passwordTextField.text.length > 0))
    {
        [loginButton setUserInteractionEnabled:YES];
        [loginButton setAlpha:1.0f];
    }
    else
    {
        [loginButton setUserInteractionEnabled:NO];
        [loginButton setAlpha:0.6f];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
