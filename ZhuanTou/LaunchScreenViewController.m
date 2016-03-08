//
//  LaunchScreenViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/19.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "LaunchScreenViewController.h"

@interface LaunchScreenViewController ()

@end

@implementation LaunchScreenViewController

@synthesize centerImageView, bgView, titleLabel, discriptionLabel, remainImageView, launchImageView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    
    bgView.layer.cornerRadius = 20;
    
    [centerImageView setAlpha:0.0f];
    [titleLabel setAlpha:0.0f];
    [discriptionLabel setAlpha:0.0f];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault boolForKey:LAUNCHIMAGE])
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"launchImage.jpg"]];   // 保存文件的名称
        launchImageView.image = [UIImage imageWithContentsOfFile:filePath];
        bgView.hidden = YES;
        centerImageView.hidden = YES;
        titleLabel.hidden = YES;
        discriptionLabel.hidden = YES;
    }
    else
    {
        launchImageView.hidden = YES;
    }
    
    [self loadImage];

}

- (void)loadImage
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:@"api/article/appEntryPic"];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
        NSLog(@"%@", responseObject);
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        if (responseObject.count > 0)
        {
            id data = [responseObject objectAtIndex:0];
            UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[data objectForKey:@"imgUrl"]]]];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"launchImage.jpg"]];   // 保存文件的名称
            BOOL result = [UIImagePNGRepresentation(img)writeToFile: filePath    atomically:YES]; // 保存成功会返回YES
            if (result)
            {
                [userDefault setBool:YES forKey:LAUNCHIMAGE];
            }
        }
        else
        {
            NSFileManager* fileManager=[NSFileManager defaultManager];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            //文件名
            NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"launchImage.jpg"]];
            BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
            if (blDele)
            {
                [userDefault setBool:NO forKey:LAUNCHIMAGE];
            }
        }
        [userDefault synchronize];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self loadImage];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [bgView startAnimation];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
//        [UIView setAnimationDuration:1.0f];
//        [remainImageView setImage:[UIImage imageNamed:@"remain2sec.png"]];
//        [UIView commitAnimations];
//    });
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
//        [UIView setAnimationDuration:1.0f];
//        [remainImageView setImage:[UIImage imageNamed:@"remain1sec.png"]];
//        [UIView commitAnimations];
//    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
        [UIView setAnimationDuration:1.2f];
        [centerImageView setAlpha:1.0f];
        [UIView commitAnimations];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
        [UIView setAnimationDuration:1.0f];
        [titleLabel setAlpha:1.0f];
        [discriptionLabel setAlpha:1.0f];
        [UIView commitAnimations];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式
        NSDate *lastDate = [dateFormat dateFromString:[userDefault objectForKey:LASTLOGINDATE]];
        NSDate *date = [NSDate date];
        if ([date timeIntervalSinceDate:lastDate] > 7*24*60*60)
        {
            [userDefault removeObjectForKey:PASSWORD];
            [userDefault synchronize];
        }
        NSString *password = [userDefault objectForKey:PASSWORD];
        if (password.length > 0)
        {
            SetpasswordViewController *setpass = [[self storyboard]instantiateViewControllerWithIdentifier:@"SetpasswordViewController"];
            setpass.string = @"验证密码";
            [[self navigationController]pushViewController:setpass animated:NO];
        }
        else
        {
            ZTTabBarViewController *tabvc = [[self storyboard]instantiateViewControllerWithIdentifier:@"ZTTabBarViewController"];
            [self presentViewController:tabvc animated:NO completion:nil];
        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
