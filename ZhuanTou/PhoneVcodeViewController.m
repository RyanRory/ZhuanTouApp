//
//  PhoneVcodeViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/14.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "PhoneVcodeViewController.h"

@interface PhoneVcodeViewController ()

@end

@implementation PhoneVcodeViewController

@synthesize textView, phoneVcodeTextField, nextButton, getVcodeButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
    self.navigationItem.leftBarButtonItem = backItem;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    
    [getVcodeButton.layer setBorderWidth:1];
    [getVcodeButton.layer setBorderColor:[UIColor colorWithRed:56.0/255.0 green:148.0/255.0 blue:238.0/255.0 alpha:100].CGColor];
    getVcodeButton.layer.cornerRadius = 5;
    textView.layer.cornerRadius = 5;
    nextButton.layer.cornerRadius = 5;
    [nextButton setUserInteractionEnabled:NO];
    [nextButton setAlpha:0.6f];
    
    [nextButton addTarget:self action:@selector(toNextPage:) forControlEvents:UIControlEventTouchUpInside];
    [getVcodeButton addTarget:self action:@selector(getVcode:) forControlEvents:UIControlEventTouchUpInside];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    phoneNum = [userDefaults objectForKey:PHONENUM];
    vCode = [userDefaults objectForKey:VCODE];
    [self getVcode];
}

- (void)backToParent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)toNextPage:(id)sender
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"api/account/validateRegisterSmsCode/%@", phoneVcodeTextField.text]];
    [manager POST:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        NSString *str = [responseObject objectForKey:@"isSuccess"];
        int f = str.intValue;
        if (f == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[responseObject objectForKey:@"errorMessage"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:phoneVcodeTextField.text forKey:SMSCODE];
            [userDefaults synchronize];
            
            InformationViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"InformationViewController"];
            [[self navigationController]pushViewController:vc animated:YES];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"验证失败，请重试！" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];

    
    
    
}

- (void)getVcode:(id)sender
{
    [self getVcode];
}

- (void)getVcode
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"api/account/registerSmsCode/%@/%@",phoneNum,vCode]];
    [manager POST:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        NSString *str = [responseObject objectForKey:@"isSuccess"];
        int f = str.intValue;
        if (f == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[responseObject objectForKey:@"errorMessage"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            secondsCountDown = 60;
            countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
            [getVcodeButton setUserInteractionEnabled:NO];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"获取短信验证码失败，请重试！" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
}

- (void)timeFireMethod
{
    secondsCountDown--;
    if (secondsCountDown == 0)
    {
        getVcodeButton.titleLabel.text = @"获取验证码";
        [getVcodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [getVcodeButton setUserInteractionEnabled:YES];
        [countDownTimer invalidate];
    }
    else
    {
        getVcodeButton.titleLabel.text = [NSString stringWithFormat:@"(%d)秒后重新获取",secondsCountDown];
        [getVcodeButton setTitle:[NSString stringWithFormat:@"(%d)秒后重新获取",secondsCountDown] forState:UIControlStateNormal];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)textFiledReturnEditing:(id)sender {
    
    [phoneVcodeTextField resignFirstResponder];

}

- (IBAction)backgroundTap:(id)sender {
    [phoneVcodeTextField resignFirstResponder];
}

- (IBAction)buttonEnableListener:(id)sender
{
    if (phoneVcodeTextField.text.length > 0)
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
