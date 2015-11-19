//
//  ForgottenViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/29.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "ForgottenViewController.h"

@interface ForgottenViewController ()

@end

@implementation ForgottenViewController

@synthesize phoneView, vcodeImageView, phoneTextField, vcodeTextField, vcodeView, nextButton, changeButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
    backItem.tintColor = ZTBLUE;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    
    phoneView.layer.cornerRadius = 3;
    vcodeView.layer.cornerRadius = 3;
    nextButton.layer.cornerRadius = 3;
    [nextButton setUserInteractionEnabled:NO];
    [nextButton setAlpha:0.6f];
    
    [nextButton addTarget:self action:@selector(toNextPage:) forControlEvents:UIControlEventTouchUpInside];
    [changeButton addTarget:self action:@selector(changeVcode:) forControlEvents:UIControlEventTouchUpInside];
    [vcodeImageView addTarget:self action:@selector(changeVcode:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated
{
    [NSThread detachNewThreadSelector:@selector(getVcode) toTarget:self withObject:nil];
    vcodeTextField.text =@"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backToParent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)toNextPage:(id)sender
{
    [phoneTextField resignFirstResponder];
    [vcodeTextField resignFirstResponder];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [self.navigationController.view addSubview:hud];
    if (![[NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0-9]{11}$"] evaluateWithObject:phoneTextField.text])
    {
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"请检查手机号码是否正确";
        [hud hide:YES afterDelay:1.5f];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [phoneTextField becomeFirstResponder];
        });
    }
    else
    {
        [nextButton setUserInteractionEnabled:NO];
        [nextButton setAlpha:0.6f];
        
        hud.mode = MBProgressHUDModeIndeterminate;
        [hud show:YES];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *URL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"api/account/checkVCode/%@",vcodeTextField.text]];
        [manager POST:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
            NSLog(@"%@", responseObject);
            NSString *str = [responseObject objectForKey:@"isSuccess"];
            int f1 = str.intValue;
            if (f1 == 0)
            {
                hud.mode = MBProgressHUDModeCustomView;
                hud.labelText = [responseObject objectForKey:@"errorMessage"];
                [hud hide:YES afterDelay:1.5f];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [vcodeTextField becomeFirstResponder];
                });
            }
            else
            {
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                NSString *URL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"api/account/checkMobile/%@",phoneTextField.text]];
                [manager POST:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject2) {
                    NSLog(@"%@", responseObject2);
                    NSString *str = [responseObject2 objectForKey:@"isSuccess"];
                    int f2 = str.intValue;
                    if (f2 == 1)
                    {
                        hud.mode = MBProgressHUDModeCustomView;
                        hud.labelText = @"该手机号尚未注册";
                        [hud hide:YES afterDelay:1.5f];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [phoneTextField becomeFirstResponder];
                        });
                    }
                    else
                    {
                        [hud hide:YES];
                        NSUserDefaults *userDefauts = [NSUserDefaults standardUserDefaults];
                        [userDefauts setObject:phoneTextField.text forKey:PHONENUM];
                        [userDefauts setObject:vcodeTextField.text forKey:VCODE];
                        [userDefauts synchronize];
                        
                        PhoneVcodeViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"PhoneVcodeViewController"];
                        [vc setStyle:style];
                        [[self navigationController]pushViewController:vc animated:YES];
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"当前网络状况不佳，请重试";
                    [hud hide:YES afterDelay:1.5f];
                }];
                
            }
            
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

- (void)setStyle:(NSString *)str
{
    style = str;
}

- (void)changeVcode:(id)sender
{
    [self getVcode];
}

- (void)getVcode
{
    NSString *URL = [BASEURL stringByAppendingString:@"Account/GetValidateCode"];
    imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:URL]];
    [vcodeImageView setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
    
}
-(IBAction)textFiledReturnEditing:(id)sender {
    if (sender == phoneTextField)
    {
        [phoneTextField resignFirstResponder];
    }
    else [vcodeTextField resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [phoneTextField resignFirstResponder];
    [vcodeTextField resignFirstResponder];
}

- (IBAction)buttonEnableListener:(id)sender
{
    if ((phoneTextField.text.length > 0) && (vcodeTextField.text.length > 0))
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
