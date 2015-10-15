//
//  RegisterViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/14.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

@synthesize phoneView, phoneTextField, vcodeView, vcodeImageView, vcodeTextField, changeButton, checkboxButton, nextButton, agreementButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    phoneView.layer.cornerRadius = 5;
    vcodeView.layer.cornerRadius = 5;
    nextButton.layer.cornerRadius = 5;
    [nextButton setUserInteractionEnabled:NO];
    [nextButton setAlpha:0.6f];
    checkboxButton.selected = YES;
    
    [nextButton addTarget:self action:@selector(toNextPage:) forControlEvents:UIControlEventTouchUpInside];
    [agreementButton addTarget:self action:@selector(toAgreemet:) forControlEvents:UIControlEventTouchUpInside];
    [checkboxButton addTarget:self action:@selector(checkboxEnsure:) forControlEvents:UIControlEventTouchUpInside];
    [changeButton addTarget:self action:@selector(changeVcode:) forControlEvents:UIControlEventTouchUpInside];
    
    [self getVcode];
    
    
   
}

- (void)backToParent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)toNextPage:(id)sender
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"api/account/checkMobile/%@",phoneTextField.text]];
    [manager POST:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
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
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSString *URL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"api/account/checkVCode/%@",vcodeTextField.text]];
            [manager POST:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject2) {
                NSLog(@"%@", responseObject2);
                NSString *str = [responseObject2 objectForKey:@"isSuccess"];
                int f2 = str.intValue;
                if (f2 == 0)
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[responseObject2 objectForKey:@"errorMessage"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
                else
                {
                    NSUserDefaults *userDefauts = [NSUserDefaults standardUserDefaults];
                    [userDefauts setObject:phoneTextField.text forKey:PHONENUM];
                    [userDefauts setObject:vcodeTextField.text forKey:VCODE];
                    [userDefauts synchronize];
                    
                    PhoneVcodeViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"PhoneVcodeViewController"];
                    [[self navigationController]pushViewController:vc animated:YES];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"验证失败，请重试！" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }];

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"验证失败，请重试！" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
    
    
}

- (void)toAgreemet:(id)sender
{
    
}

- (void)checkboxEnsure:(UIButton*)btn
{
    btn.selected = !btn.selected;
    if (btn.selected)
    {
        [btn setImage:[UIImage imageNamed:@"checkIconActive.png"] forState:UIControlStateNormal];
        if ((phoneTextField.text.length > 0) && (vcodeTextField.text.length > 0))
        {
            [nextButton setUserInteractionEnabled:YES];
            [nextButton setAlpha:1.0f];
        }
    }
    else
    {
        [btn setImage:[UIImage imageNamed:@"checkIcon.png"] forState:UIControlStateNormal];
        [nextButton setUserInteractionEnabled:NO];
        [nextButton setAlpha:0.6f];
    }

}

- (void)changeVcode:(id)sender
{
    [self getVcode];
}

- (void)getVcode
{
    NSString *URL = [BASEURL stringByAppendingString:@"Account/GetValidateCode"];
    imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:URL]];
    vcodeImageView.image = [UIImage imageWithData:imageData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    if ((phoneTextField.text.length > 0) && (vcodeTextField.text.length > 0) && checkboxButton.selected)
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
