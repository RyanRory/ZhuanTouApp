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

@synthesize forgottenButton, toRegisterButton, loginButton, usernameTextField, passwordTextField, backButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    loginButton.layer.masksToBounds = YES;
    loginButton.layer.cornerRadius = 5;
    
    [loginButton addTarget:self action:@selector(Login:) forControlEvents:UIControlEventTouchUpInside];
    [toRegisterButton addTarget:self action:@selector(ToRegister:) forControlEvents:UIControlEventTouchUpInside];
    [forgottenButton addTarget:self action:@selector(ToForgotten:) forControlEvents:UIControlEventTouchUpInside];
    [backButton addTarget:self action:@selector(BackToParent:) forControlEvents:UIControlEventTouchUpInside];
    
    [loginButton setUserInteractionEnabled:NO];
    
}

- (void)Login:(id)sender
{
    LoadingView *view = [[LoadingView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, SCREEN_HEIGHT/2-50, 100, 100)];
    [self.view addSubview:view];
    [view startAnimation];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"login":usernameTextField.text,
                                 @"password":passwordTextField.text};
    NSString *URL = [BASEURL stringByAppendingString:@"api/auth/signIn"];
    [manager POST:URL parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        
        [view stopAnimation];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[responseObject objectForKey:@"errorMessage"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        [view stopAnimation];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录失败，请重试！" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];

}

- (void)ToRegister:(id)sender
{
    
}

- (void)ToForgotten:(id)sender
{
    
}

- (void)BackToParent:(id)sender
{
    
}

-(IBAction)textFiledReturnEditing:(id)sender {
    if (sender == usernameTextField)
    {
        [passwordTextField becomeFirstResponder];
        [usernameTextField resignFirstResponder];
    }
    else [passwordTextField resignFirstResponder];
    
    if ((usernameTextField.text.length > 0) && (passwordTextField.text.length > 0))
    {
        [loginButton setUserInteractionEnabled:YES];
        [loginButton setAlpha:1.0f];
    }
}

- (IBAction)backgroundTap:(id)sender {
    [usernameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
