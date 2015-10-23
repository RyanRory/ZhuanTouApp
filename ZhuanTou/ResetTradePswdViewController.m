//
//  ResetTradePswdViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/22.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "ResetTradePswdViewController.h"

@interface ResetTradePswdViewController ()

@end

@implementation ResetTradePswdViewController

@synthesize oldPswdTextField, nPswdAgainTextField, nPswdTextTextField, confirmButton, forgetButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
    backItem.tintColor = ZTBLUE;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
    
    [confirmButton setUserInteractionEnabled:NO];
    [confirmButton setAlpha:0.6f];
    confirmButton.layer.cornerRadius = 3;
    [confirmButton addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    [forgetButton addTarget:self action:@selector(toForgotten:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([style isEqualToString:RESETLOGINPSWD])
    {
        self.title = @"修改登录密码";
        oldPswdTextField.placeholder = @"输入原登录密码";
        nPswdAgainTextField.placeholder = @"确认新登录密码";
        nPswdTextTextField.placeholder = @"输入新登录密码";
    }
    else
    {
        self.title = @"修改交易密码";
        oldPswdTextField.placeholder = @"输入原交易密码";
        nPswdAgainTextField.placeholder = @"确认新交易密码";
        nPswdTextTextField.placeholder = @"输入新交易密码";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backToParent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)confirm:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)toForgotten:(id)sender
{
    
}

- (void)setStyle:(NSString *)str
{
    style = str;
}

-(IBAction)textFiledReturnEditing:(id)sender {
    if (sender == oldPswdTextField)
    {
        [nPswdTextTextField becomeFirstResponder];
        [oldPswdTextField resignFirstResponder];
    }
    else if (sender == nPswdTextTextField)
    {
        [nPswdAgainTextField becomeFirstResponder];
        [nPswdTextTextField resignFirstResponder];
    }
    else [nPswdAgainTextField resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [oldPswdTextField resignFirstResponder];
    [nPswdTextTextField resignFirstResponder];
    [nPswdAgainTextField resignFirstResponder];
}

- (IBAction)buttonEnableListener:(id)sender
{
    if ((oldPswdTextField.text.length > 0) && (nPswdTextTextField.text.length > 0) && (nPswdAgainTextField.text.length > 0))
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
