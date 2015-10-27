//
//  FeedbackViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/23.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

@synthesize feedbackTextField, tellUsButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
    backItem.tintColor = ZTBLUE;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
    
    [tellUsButton setUserInteractionEnabled:NO];
    [tellUsButton setAlpha:0.6f];
    tellUsButton.layer.cornerRadius = 3;
    [tellUsButton addTarget:self action:@selector(tellUs:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backToParent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tellUs:(id)sender
{
    [feedbackTextField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)textFiledReturnEditing:(id)sender {
    [feedbackTextField resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [feedbackTextField resignFirstResponder];
}

- (IBAction)buttonEnableListener:(id)sender
{
    if (feedbackTextField.text.length > 0)
    {
        [tellUsButton setUserInteractionEnabled:YES];
        [tellUsButton setAlpha:1.0f];
    }
    else
    {
        [tellUsButton setUserInteractionEnabled:NO];
        [tellUsButton setAlpha:0.6f];
    }
}


@end
