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

@synthesize webView, reloadButton, showInvite, inviteTitle;

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
    else if ([self.title isEqualToString:@"分红宝"] || [self.title isEqualToString:@"新手特权"])
    {
        [self.navigationController.navigationBar setBarTintColor:ZTBLUE];
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
        backItem.tintColor = [UIColor whiteColor];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
    }
//    else if ([self.title isEqualToString:@"活动介绍"])
//    {
//        [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
//        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
//        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
//        backItem.tintColor = [UIColor whiteColor];
//        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
//        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
//    }
    else
    {
        if (self.showInvite == YES){
            UIBarButtonItem *inviteItem = [[UIBarButtonItem alloc]initWithTitle:inviteTitle style:UIBarButtonItemStylePlain target:self action:@selector(toInvite:)];
            inviteItem.tintColor = ZTBLUE;
            self.navigationItem.rightBarButtonItem = inviteItem;
            [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:13], NSFontAttributeName,nil] forState:UIControlStateNormal];
        }

        [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
        backItem.tintColor = ZTBLUE;
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
    }

    reloadButton.hidden = YES;
    [reloadButton addTarget:self action:@selector(reloadWebView:) forControlEvents:UIControlEventTouchUpInside];
    
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:ISPUSHSHOW])
//    {
//        AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        if (app.userInfo.count > 0)
//        {
//            NSString *afterOpen = [app.userInfo objectForKey:@"after_open"];
//            if ([afterOpen isEqualToString:@"go_url"])
//            {
//                NSLog(@"twtwtwtwtw");
//                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ISPUSHSHOW];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//            }
//        }
//    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceivePush:) name:@"RECEIVEPUSH" object:nil];
}

- (void)toInvite:(id)sender
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    BOOL flag = [userDefault boolForKey:ISLOGIN];
    if (!flag)
    {
        UINavigationController *nav = [[self storyboard]instantiateViewControllerWithIdentifier:@"LoginNav"];
        [[self tabBarController] presentViewController:nav animated:YES completion:nil];
    }
    else{
        InvitationViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"InvitationViewController"];
        [[self navigationController]pushViewController:vc animated:YES];
    }

}

- (void)viewDidAppear:(BOOL)animated
{
    [self loadWebView];
    if (self.navigationController.navigationBarHidden)
    {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
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
    NSLog(@"%@",str);
    url =  str;
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
    timer = [NSTimer scheduledTimerWithTimeInterval:30.0f target:self selector:@selector(webViewStopLaoding) userInfo:nil repeats:NO];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [hud hide:YES];
    [timer invalidate];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [timer invalidate];
    NSLog(@"%@",error);
    reloadButton.hidden = NO;
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"当前网络状况不佳";
    [hud hide:YES afterDelay:1.5f];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        reloadButton.hidden = NO;
    });
}

- (void)didReceivePush:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RECEIVEPUSH" object:nil];
    if ([self isCurrentViewControllerVisible:self])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ISLASTPUSHHANDLE];
        AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (app.userInfo.count > 0)
        {
            NSString *afterOpen = [app.userInfo objectForKey:@"after_open"];
            if ([afterOpen isEqualToString:@"go_activity"])
            {
                [self.navigationController popToRootViewControllerAnimated:NO];
                NSString *afterOpen = [app.userInfo objectForKey:@"after_open"];
                if ([afterOpen isEqualToString:@"go_activity"])
                {
                    NSString *activity = [app.userInfo objectForKey:@"activity"];
                    if ([activity isEqualToString:@"endedDq"])
                    {
                        DingqiViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"DingqiViewController"];
                        vc.buttonTag = 1;
                        [[self navigationController]pushViewController:vc animated:YES];
                    }
                    else
                    {
                        [[self tabBarController] setSelectedIndex:1];
                    }
                }
            }
            else if ([afterOpen isEqualToString:@"go_url"])
            {
                if (![[NSUserDefaults standardUserDefaults] boolForKey:ISURLSHOW])
                {
                    NSLog(@"fsfsfsfsfsfsfs");
                    NSString *tempurl = [app.userInfo objectForKey:@"url"];
                    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                    WebDetailViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"WebDetailViewController"];
                    [vc setURL:tempurl];
                    vc.title = @"专投公告";
                    [[self navigationController]pushViewController:vc animated:YES];
                }
            }
        }
    }
}

-(BOOL)isCurrentViewControllerVisible:(UIViewController *)viewController
{
    return (viewController.isViewLoaded && viewController.view.window);
}
@end
