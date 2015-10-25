//
//  HomeMainViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/25.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "HomeMainViewController.h"

@interface HomeMainViewController ()

@end

@implementation HomeMainViewController

@synthesize scrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    
    images = [NSArray arrayWithObjects:[UIImage imageNamed:@"testPage1"],[UIImage imageNamed:@"testPage2"],[UIImage imageNamed:@"testPage3"],[UIImage imageNamed:@"testPage1"],[UIImage imageNamed:@"testPage2"],[UIImage imageNamed:@"testPage3"], nil];
    currentImage = 0;
    
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    
}

- (void)viewDidLayoutSubviews
{
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 3, scrollView.frame.size.height);
    
    leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
    leftImage.image = [images objectAtIndex:images.count-1];
    
    midImage = [[UIImageView alloc]initWithFrame:CGRectMake(scrollView.frame.size.width * 1, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
    midImage.image = [images objectAtIndex:0];
    
    rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(scrollView.frame.size.width * 2, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
    rightImage.image = [images objectAtIndex:1];
    
    [scrollView addSubview:leftImage];
    [scrollView addSubview:midImage];
    [scrollView addSubview:rightImage];
    [scrollView setContentOffset:CGPointMake(scrollView.frame.size.width, 0) animated:NO];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 滚动停止事件
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrView
{
    if (scrView == scrollView)
    {
        [self reloadImage];
        [scrView setContentOffset:CGPointMake(scrollView.frame.size.width, 0) animated:NO];
    }
}

-(void)reloadImage
{
    int leftImageIndex, rightImageIndex;
    CGPoint offset=[scrollView contentOffset];
    if (offset.x>scrollView.frame.size.width)
    { //向右滑动
        currentImage=(currentImage+1)%images.count;
    }
    else if(offset.x<scrollView.frame.size.width)
    {//向左滑动
        if (currentImage == 0)
            currentImage = (int)images.count -1;
        else
            currentImage=(currentImage-1)%images.count;
    }
    
    midImage.image=[images objectAtIndex:currentImage];
    
    //重新设置左右图片
    leftImageIndex = (currentImage-1)%images.count;
    rightImageIndex = (currentImage+1)%images.count;
    leftImage.image = [images objectAtIndex:leftImageIndex];
    rightImage.image = [images objectAtIndex:rightImageIndex];
}

@end
