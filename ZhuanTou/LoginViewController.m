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
    if ([self.style isEqualToString:@"FORGOTTEN"])
    {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:13], NSFontAttributeName,nil] forState:UIControlStateNormal];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
    backItem.tintColor = ZTBLUE;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    loginButton.layer.cornerRadius = 3;
    textView.layer.cornerRadius = 3;
    
    [loginButton addTarget:self action:@selector(Login:) forControlEvents:UIControlEventTouchUpInside];
    [forgottenButton addTarget:self action:@selector(ToForgotten:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)viewWillAppear:(BOOL)animated
{
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
    [usernameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [self.navigationController.view addSubview:hud];
    NSString *PasswordReg = @"(?=.*[0-9])(?=.*[a-zA-Z]).{6,30}";
    NSPredicate *regextestpassword = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PasswordReg];
    if(![regextestpassword evaluateWithObject: passwordTextField.text])
    {
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"密码至少6位，包括数字和字母";
        [hud hide:YES afterDelay:1.5f];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [passwordTextField becomeFirstResponder];
        });
    }
    else
    {
        [loginButton setUserInteractionEnabled:NO];
        [loginButton setAlpha:0.6f];
        hud.mode = MBProgressHUDModeIndeterminate;
        [hud show:YES];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = @{@"login":usernameTextField.text,
                                     @"password":passwordTextField.text};
        NSString *URL = [BASEURL stringByAppendingString:@"api/auth/signIn"];
        [manager POST:URL parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
            NSLog(@"%@", responseObject);
            NSString *str = [responseObject objectForKey:@"isAuthenticated"];
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
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                [userDefault setBool:YES forKey:ISLOGIN];
                [userDefault setObject:usernameTextField.text forKey:USERNAME];
                [userDefault setObject:passwordTextField.text forKey:PASSWORD];
                [userDefault synchronize];
                [KeychainData forgotPsw];
                SetpasswordViewController *setpass = [[self storyboard]instantiateViewControllerWithIdentifier:@"SetpasswordViewController"];
                setpass.string = @"重置密码";
                setpass.style = self.style;
                [[self navigationController]pushViewController:setpass animated:YES];
            }
            
            [loginButton setUserInteractionEnabled:YES];
            [loginButton setAlpha:1.0f];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"当前网络状况不佳，请重试";
            [hud hide:YES afterDelay:1.5f];
            
            [loginButton setUserInteractionEnabled:YES];
            [loginButton setAlpha:1.0f];
        }];
    }

}


- (void)ToForgotten:(id)sender
{
    ForgottenViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"ForgottenViewController"];
    [vc setStyle:RESETLOGINPSWD];
    [[self navigationController]pushViewController:vc animated:YES];
}

- (void)backToParent:(id)sender
{
    [usernameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    if (![self.style isEqualToString:@"FORGOTTEN"])
    {
        ZTTabBarViewController *vc = (ZTTabBarViewController*)[self presentingViewController];
        [vc setSelectedIndex:vc.lastSelectedIndex];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        ZTTabBarViewController *tabvc = [[self storyboard]instantiateViewControllerWithIdentifier:@"ZTTabBarViewController"];
        [self presentViewController:tabvc animated:YES completion:nil];
    }
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
