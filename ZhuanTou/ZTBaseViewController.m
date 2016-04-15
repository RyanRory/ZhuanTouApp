//
//  ZTBaseViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 16/4/12.
//  Copyright © 2016年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "ZTBaseViewController.h"

@interface ZTBaseViewController ()

@end

@implementation ZTBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceivePush:) name:@"RECEIVEPUSH" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didReceivePush:(id)sender
{
    [[self navigationController] popToRootViewControllerAnimated:NO];
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (app.userInfo.count > 0)
    {
        NSString *afterOpen = [app.userInfo objectForKey:@"after_open"];
        if ([afterOpen isEqualToString:@"go_activity"])
        {
            NSString *activity = [app.userInfo objectForKey:@"activity"];
            if ([activity isEqualToString:@"endedDq"])
            {
                [[self tabBarController] setSelectedIndex:2];
            }
            else
            {
                [[self tabBarController] setSelectedIndex:1];
            }
        }
        else if ([afterOpen isEqualToString:@"go_url"])
        {
            NSString *url = [app.userInfo objectForKey:@"url"];
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            WebDetailViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"WebDetailViewController"];
            [vc setURL:url];
            vc.title = [app.userInfo objectForKey:@"title"];
            [[self navigationController]pushViewController:vc animated:YES];
        }
    }

}


@end
