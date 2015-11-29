//
//  SecurityViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/22.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "SecurityViewController.h"

@interface SecurityViewController ()

@end

@implementation SecurityViewController

@synthesize pointerImageView, levelLabel;
@synthesize realNameStatusLabel, realNameButton, tradePswdButton, tradePswdStatusLabel, loginPswdButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
    backItem.tintColor = ZTBLUE;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
    
    [realNameButton addTarget:self action:@selector(toRealName:) forControlEvents:UIControlEventTouchUpInside];
    [tradePswdButton addTarget:self action:@selector(toTradePswd:) forControlEvents:UIControlEventTouchUpInside];
    [loginPswdButton addTarget:self action:@selector(toLoginPswd:) forControlEvents:UIControlEventTouchUpInside];
    
    levelLabel.text = @"低";
    levelLabel.textColor = ZTSECURITYRED;
    
    pointerImageView.transform = CGAffineTransformMakeRotation(-M_PI/4);
    
}

- (void)viewDidAppear:(BOOL)animated
{
    pointerImageView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    //pointerImageView.layer.transform = CATransform3DMakeRotation(M_PI,0,0,1);
    [self setupData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)becomeForeground
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setupData];
    });
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)backToParent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setupData
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:@"api/account/getUserSecurityStatus"];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        NSString *str = [responseObject objectForKey:@"isSuccess"];
        int f1 = str.intValue;
        if (f1 == 1)
        {
            if (((NSString*)[responseObject objectForKey:@"isIdentified"]).intValue == 0)
            {
                realNameStatusLabel.text = @"未认证";
            }
            else
            {
                realNameStatusLabel.text = @"已认证";
            }
            if (((NSString*)[responseObject objectForKey:@"isTradePwSetted"]).intValue == 0)
            {
                tradePswdStatusLabel.text = @"未设置";
            }
            else
            {
                tradePswdStatusLabel.text = @"修改";
            }
            
            if ([[responseObject objectForKey:@"securityLevelStr"] isEqualToString:@"低"])
            {
                levelLabel.text = @"低";
                levelLabel.textColor = ZTSECURITYRED;
                [self rotateAnimation:0 start:0];
            }
            else if ([[responseObject objectForKey:@"securityLevelStr"] isEqualToString:@"中"])
            {
                if ([levelLabel.text isEqualToString:@"低"])
                {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        levelLabel.text = @"中";
                        levelLabel.textColor = ZTSECURITYYELLOW;
                    });
                    [self rotateAnimation:1 start:0];
                }
            }
            else
            {
                if ([levelLabel.text isEqualToString:@"低"])
                {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        levelLabel.text = @"中";
                        levelLabel.textColor = ZTSECURITYYELLOW;
                    });
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        levelLabel.text = @"高";
                        levelLabel.textColor = ZTSECURITYGREEN;
                    });
                    [self rotateAnimation:2 start:0];
                }
                else if ([levelLabel.text isEqualToString:@"中"])
                {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        levelLabel.text = @"高";
                        levelLabel.textColor = ZTSECURITYGREEN;
                    });
                    [self rotateAnimation:1 start:M_PI/2];
                }
                
            }
        }
        else
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = [responseObject objectForKey:@"errorMessage"];
            [hud hide:YES afterDelay:1.5f];
            if ([[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"errorMessage"]] isEqualToString:@"100003"])
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    UINavigationController *nav = [[self storyboard]instantiateViewControllerWithIdentifier:@"LoginNav"];
                    [[self tabBarController] presentViewController:nav animated:YES completion:nil];
                    
                });
            }
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        if (error.code == 100003)
        {
            hud.labelText = @"当前用户未被授权执行当前操作";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UINavigationController *nav = [[self storyboard]instantiateViewControllerWithIdentifier:@"LoginNav"];
                [[self tabBarController] presentViewController:nav animated:YES completion:nil];
            });
        }
        else
        {
            hud.labelText = @"当前网络状况不佳，请重试";
        }
        [hud hide:YES afterDelay:1.5f];
    }];
    
}

- (void)rotateAnimation:(int)angle start:(CGFloat)start
{
    CAKeyframeAnimation *anim=[CAKeyframeAnimation animationWithKeyPath:@"transform"];
    NSMutableArray *values=[NSMutableArray array];
    anim.duration = 0.3*(angle+1);
    anim.autoreverses = NO;
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion= NO;
    
    CGFloat distance = M_PI/20;
    
    int j = -4;
    for(;j<=(10*angle);j++){
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, start+distance*j, 0, 0, 1)]];
    }
    
    //添加缓动效果
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, start+distance*j, 0, 0, 1)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, start+distance*(j+1), 0, 0, 1)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, start+distance*j, 0, 0, 1)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, start+distance*(j-1), 0, 0, 1)]];
    
    anim.values=values; ;
    [pointerImageView.layer addAnimation:anim forKey:@"cubeIn"];
}

- (void)toRealName:(id)sender
{
    if ([realNameStatusLabel.text isEqualToString:@"未认证"])
    {
        RealNameViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"RealNameViewController"];
        [[self navigationController]pushViewController:vc animated:YES];
    }
    else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"您已认证，不可更改";
        [hud hide:YES afterDelay:1.5f];
    }
}

- (void)toTradePswd:(id)sender
{
    if ([tradePswdStatusLabel.text isEqualToString:@"未设置"])
    {
        SetTradePswdViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"SetTradePswdViewController"];
        [[self navigationController]pushViewController:vc animated:YES];
    }
    else
    {
        ResetTradePswdViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"ResetTradePswdViewController"];
        [vc setStyle:RESETTRADEPSWD];
        [[self navigationController]pushViewController:vc animated:YES];
    }
}

- (void)toLoginPswd:(id)sender
{
    ResetTradePswdViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"ResetTradePswdViewController"];
    [vc setStyle:RESETLOGINPSWD];
    [[self navigationController]pushViewController:vc animated:YES];
}

@end
