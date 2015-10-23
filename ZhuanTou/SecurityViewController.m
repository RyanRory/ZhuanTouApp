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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backToParent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupData
{
    realNameStatusLabel.text = @"未认证";
    tradePswdStatusLabel.text = @"未设置";
    
    int i = rand()%3;
    
    if (i == 0)
    {
        levelLabel.text = @"低";
        levelLabel.textColor = ZTSECURITYRED;
        [self rotateAnimation:0];
    }
    else if (i == 1)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            levelLabel.text = @"中";
            levelLabel.textColor = ZTSECURITYYELLOW;
        });
        [self rotateAnimation:1];
    }
    else
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            levelLabel.text = @"中";
            levelLabel.textColor = ZTSECURITYYELLOW;
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            levelLabel.text = @"高";
            levelLabel.textColor = ZTSECURITYGREEN;
        });
        
        [self rotateAnimation:2];
    }
}

- (void)rotateAnimation:(int)angle
{
    CAKeyframeAnimation *anim=[CAKeyframeAnimation animationWithKeyPath:@"transform"];
    NSMutableArray *values=[NSMutableArray array];
    anim.duration = 0.3*(angle+1);
    anim.autoreverses = NO;
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion= NO;
    
    CGFloat distance = M_PI/20;
    
    int i = -4;
    for(;i<=(10*angle);i++){
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, distance*i, 0, 0, 1)]];
    }
    
    //添加缓动效果
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, distance*i, 0, 0, 1)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, distance*(i+1), 0, 0, 1)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, distance*i, 0, 0, 1)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, distance*(i-1), 0, 0, 1)]];
    
    anim.values=values; ;
    [pointerImageView.layer addAnimation:anim forKey:@"cubeIn"];
}

- (void)toRealName:(id)sender
{
    RealNameViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"RealNameViewController"];
    [[self navigationController]pushViewController:vc animated:YES];
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
