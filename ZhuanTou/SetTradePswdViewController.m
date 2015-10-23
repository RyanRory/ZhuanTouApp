//
//  SetTradePswdViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/22.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "SetTradePswdViewController.h"

@interface SetTradePswdViewController ()

@end

@implementation SetTradePswdViewController

@synthesize tradePswdTextField, tradePswdAgainTextField, confirmButton;

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

-(IBAction)textFiledReturnEditing:(id)sender {
    if (sender == tradePswdTextField)
    {
        [tradePswdAgainTextField becomeFirstResponder];
        [tradePswdTextField resignFirstResponder];
    }
    else [tradePswdAgainTextField resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [tradePswdTextField resignFirstResponder];
    [tradePswdAgainTextField resignFirstResponder];
}

- (IBAction)buttonEnableListener:(id)sender
{
    if ((tradePswdTextField.text.length > 0) && (tradePswdAgainTextField.text.length > 0))
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
