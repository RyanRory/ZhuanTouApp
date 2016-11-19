//
//  RenZhengViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 16/10/18.
//  Copyright © 2016年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "RenZhengViewController.h"

@interface RenZhengViewController()

@end

@implementation RenZhengViewController

@synthesize webView;
@synthesize backButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadWebView];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setURL:(NSString *)str
{
    NSLog(@"%@",str);
    url =  str;
}
- (void)loadWebView
{
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    [webView loadRequest:request];
}

@end
