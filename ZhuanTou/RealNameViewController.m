//
//  RealNameViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/22.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "RealNameViewController.h"

@interface RealNameViewController ()

@end

@implementation RealNameViewController

@synthesize realNameTextField, idNumTextField, confirmButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
    
    [confirmButton addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    
    [confirmButton setUserInteractionEnabled:NO];
    [confirmButton setAlpha:0.6f];
    confirmButton.layer.cornerRadius = 3;
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
    
}

-(IBAction)textFiledReturnEditing:(id)sender {
    if (sender == realNameTextField)
    {
        [idNumTextField becomeFirstResponder];
        [realNameTextField resignFirstResponder];
    }
    else [idNumTextField resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [realNameTextField resignFirstResponder];
    [idNumTextField resignFirstResponder];
}

- (IBAction)buttonEnableListener:(id)sender
{
    if ((realNameTextField.text.length > 0) && (idNumTextField.text.length > 0))
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
