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
    backItem.tintColor = ZTBLUE;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    
    [getVcodeButton.layer setBorderWidth:1];
    [getVcodeButton.layer setBorderColor:[UIColor colorWithRed:56.0/255.0 green:148.0/255.0 blue:238.0/255.0 alpha:100].CGColor];
    getVcodeButton.layer.cornerRadius = 3;
    textView.layer.cornerRadius = 3;
    nextButton.layer.cornerRadius = 3;
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
    [phoneVcodeTextField resignFirstResponder];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [self.navigationController.view addSubview:hud];
    if (![[NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0-9]{6}$"] evaluateWithObject:phoneVcodeTextField.text])
    {
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"验证码错误";
        [hud hide:YES afterDelay:1.5f];
        [phoneVcodeTextField becomeFirstResponder];
    }
    else
    {
        [nextButton setUserInteractionEnabled:NO];
        [nextButton setAlpha:0.6f];
        
        hud.mode = MBProgressHUDModeIndeterminate;
        [hud show:YES];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *URL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"api/account/validateRegisterSmsCode/%@", phoneVcodeTextField.text]];
        [manager POST:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
            NSLog(@"%@", responseObject);
            NSString *str = [responseObject objectForKey:@"isSuccess"];
            int f = str.intValue;
            if (f == 0)
            {
                hud.mode = MBProgressHUDModeCustomView;
                hud.labelText = [responseObject objectForKey:@"errorMessage"];
                [hud hide:YES afterDelay:1.5f];
                [phoneVcodeTextField becomeFirstResponder];
            }
            else
            {
                [hud hide:YES];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:phoneVcodeTextField.text forKey:SMSCODE];
                [userDefaults synchronize];
                
                InformationViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"InformationViewController"];
                [[self navigationController]pushViewController:vc animated:YES];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"当前网络状况不佳，请重试";
            [hud hide:YES afterDelay:1.5f];
        }];
    }
}

- (void)getVcode:(id)sender
{
    [self getVcode];
}

- (void)getVcode
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"api/account/registerSmsCode/%@/%@",phoneNum,vCode]];
    [manager POST:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        NSString *str = [responseObject objectForKey:@"isSuccess"];
        int f = str.intValue;
        if (f == 0)
        {
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = [responseObject objectForKey:@"errorMessage"];
            [hud hide:YES afterDelay:1.5f];
        }
        else
        {
            [hud hide:YES];
            secondsCountDown = 60;
            countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
            [getVcodeButton setUserInteractionEnabled:NO];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"获取短信验证码失败，请重试";
        [hud hide:YES afterDelay:1.5f];
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
