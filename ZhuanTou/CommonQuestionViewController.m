//
//  CommonQuestionViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/23.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "CommonQuestionViewController.h"

@interface CommonQuestionViewController ()

@end

@implementation CommonQuestionViewController

@synthesize webView, reloadButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
    backItem.tintColor = ZTBLUE;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
    
    reloadButton.hidden = YES;
    [reloadButton addTarget:self action:@selector(reloadWebView:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self loadWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backToParent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadWebView
{
    NSURL *URL = [NSURL URLWithString:@"http://debug.pujintianxia.com/Mobile/Home/Questions"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    [webView loadRequest:request];
}

- (void)reloadWebView:(id)sender
{
    [self loadWebView];
}

- (void)webViewStopLaoding
{
    [webView stopLoading];
    [timer invalidate];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"当前网络状况不佳";
    [hud hide:YES afterDelay:1.5f];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        reloadButton.hidden = NO;
    });
}

#pragma WebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    reloadButton.hidden = YES;
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(webViewStopLaoding) userInfo:nil repeats:NO];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [hud hide:YES];
    [timer invalidate];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [timer invalidate];
    reloadButton.hidden = NO;
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"当前网络状况不佳";
    [hud hide:YES afterDelay:1.5f];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        reloadButton.hidden = NO;
    });
}


@end
