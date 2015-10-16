//
//  SetpasswordViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/14.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "SetpasswordViewController.h"

@interface SetpasswordViewController ()

@end

@implementation SetpasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
    self.navigationItem.leftBarButtonItem = backItem;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    
    
    
    AliPayViews *alipay = [[AliPayViews alloc] initWithFrame:self.view.bounds];
    if ([self.string isEqualToString:@"验证密码"]) {
        alipay.imageName = @"";
        alipay.gestureModel = ValidatePwdModel;
    } else if ([self.string isEqualToString:@"修改密码"]) {
        alipay.gestureModel = AlertPwdModel;
    } else if ([self.string isEqualToString:@"重置密码"]) {
        alipay.gestureModel = SetPwdModel;
    } else {
        alipay.gestureModel = NoneModel;
    }
    alipay.block = ^(NSString *pswString) {
        NSLog(@"设置密码成功-----你的密码为 = 【%@】\n\n", pswString);
        RegisterSuccessViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"RegisterSuccessVC"];
        [[self navigationController]pushViewController:vc animated:YES];
    };
    
    [self.view addSubview:alipay];

}

- (void)backToParent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
