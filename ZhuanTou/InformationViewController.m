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
    self.navigationItem.leftBarButtonItem = backItem;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    
    textView.layer.cornerRadius = 5;
    nextButton.layer.cornerRadius = 5;
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
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    smsCode = [userDefaults objectForKey:SMSCODE];
    phoneNum = [userDefaults objectForKey:PHONENUM];
    
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
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[responseObject objectForKey:@"errorMessage"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            [userDefaults setObject:usernameTextField.text forKey:USERNAME];
            [userDefaults setObject:passwordTextField.text forKey:PASSWORD];
            [userDefaults synchronize];
            
            [KeychainData forgotPsw];
            SetpasswordViewController *setpass = [[SetpasswordViewController alloc] init];
            setpass.string = @"重置密码";
            [[self navigationController]pushViewController:setpass animated:YES];
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"注册失败，请重试！" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
    
//    [KeychainData forgotPsw];
//    SetpasswordViewController *setpass = [[SetpasswordViewController alloc] init];
//    setpass.string = @"重置密码";
//    [[self navigationController]pushViewController:setpass animated:YES];


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
