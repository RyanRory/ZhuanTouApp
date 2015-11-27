//
//  NoticeDetailViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/26.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "WebDetailViewController.h"

@interface WebDetailViewController ()

@end

@implementation WebDetailViewController

@synthesize webView, reloadButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if ([self.title isEqualToString:@"稳盈宝"])
    {
        [self.navigationController.navigationBar setBarTintColor:ZTLIGHTRED];
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
        backItem.tintColor = [UIColor whiteColor];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
    }
    else if ([self.title isEqualToString:@"专投宝"])
    {
        [self.navigationController.navigationBar setBarTintColor:ZTRED];
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
        backItem.tintColor = [UIColor whiteColor];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
    }
    else if ([self.title isEqualToString:@"分红宝"] || [self.title isEqualToString:@"新手专享三重礼"])
    {
        [self.navigationController.navigationBar setBarTintColor:ZTBLUE];
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
        backItem.tintColor = [UIColor whiteColor];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
    }
    else
    {
        [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
        backItem.tintColor = ZTBLUE;
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
    }
    
    reloadButton.hidden = YES;
    [reloadButton addTarget:self action:@selector(reloadWebView:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self loadWebView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setURL:(NSString *)str
{
    url = str;
}

- (void)backToParent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadWebView
{
    NSURL *URL = [NSURL URLWithString:url];
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
    timer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(webViewStopLaoding) userInfo:nil repeats:NO];
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
