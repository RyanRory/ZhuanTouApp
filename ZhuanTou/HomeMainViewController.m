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

@synthesize scrollView, noticeScrollView, noticeButton, pageControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [noticeButton addTarget:self action:@selector(toNotice:) forControlEvents:UIControlEventTouchUpInside];
    
    images = [NSArray arrayWithObjects:[UIImage imageNamed:@"banner1.png"],[UIImage imageNamed:@"banner1.png"],[UIImage imageNamed:@"banner1.png"],[UIImage imageNamed:@"banner1.png"],[UIImage imageNamed:@"banner1.png"],[UIImage imageNamed:@"banner1.png"], nil];
    notices = [NSArray arrayWithObjects:@"专投网APP上线啦！",@"专投网APP上线啦，哈哈哈！",@"专投网APP上线啦，嘿嘿嘿！",@"专投网APP上线啦，啦啦啦！",@"专投网APP上线啦，哈哈哈哈！",@"专投网APP上线啦，嘿嘿嘿嘿！", nil];
    currentImage = 0;
    
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    
    noticeScrollView.delegate = self;
    noticeScrollView.showsHorizontalScrollIndicator = NO;
    noticeScrollView.showsVerticalScrollIndicator = NO;
    noticeScrollView.pagingEnabled = YES;
    noticeScrollView.bounces = NO;
    
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, 0);
    
    leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*11/15)];
    leftImage.image = [images objectAtIndex:images.count-1];
    
    midImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_WIDTH*11/15)];
    midImage.image = [images objectAtIndex:0];
    
    midImageButton = [[UIButton alloc]initWithFrame:midImage.frame];
    midImageButton.titleLabel.text = @"";
    [midImageButton addTarget:self action:@selector(toImageDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, SCREEN_WIDTH*11/15)];
    rightImage.image = [images objectAtIndex:1];
    
    [scrollView addSubview:leftImage];
    [scrollView addSubview:midImage];
    [scrollView addSubview:midImageButton];
    [scrollView addSubview:rightImage];
    [scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
    
    [pageControl setNumberOfPages:images.count];
    [pageControl setCurrentPage:currentImage];
    
    noticeScrollView.contentSize = CGSizeMake(0, noticeScrollView.frame.size.height * 3);
    
    topView = [[NoticeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, noticeScrollView.frame.size.height)];
    topView.label.text = [notices objectAtIndex:notices.count-1];
    
    midView = [[NoticeView alloc]initWithFrame:CGRectMake(0, noticeScrollView.frame.size.height, SCREEN_WIDTH, noticeScrollView.frame.size.height)];
    midView.label.text = [notices objectAtIndex:0];
    
    bottomView = [[NoticeView alloc]initWithFrame:CGRectMake(0, noticeScrollView.frame.size.height * 2, SCREEN_WIDTH, noticeScrollView.frame.size.height)];
    bottomView.label.text = [notices objectAtIndex:1];
    
    [noticeScrollView addSubview:topView];
    [noticeScrollView addSubview:midView];
    [noticeScrollView addSubview:bottomView];
    [noticeScrollView setContentOffset:CGPointMake(0, noticeScrollView.frame.size.height) animated:NO];

}

- (void)viewWillAppear:(BOOL)animated
{
    [[self navigationController]setNavigationBarHidden:YES animated:YES];
    timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(scrollToNextPage:) userInfo:nil repeats:YES];
    noticeTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scrollToNextNotice:) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [timer invalidate];
    [noticeTimer invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollToNextPage:(id)sender
{
    [scrollView setContentOffset:CGPointMake(scrollView.frame.size.width * 2, 0) animated:YES];
}

- (void)scrollToNextNotice:(id)sender
{
    [noticeScrollView setContentOffset:CGPointMake(0, noticeScrollView.frame.size.height * 2) animated:YES];
}

- (void)toNotice:(id)sender
{
    NoticeCenterViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"NoticeCenterViewController"];
    [[self navigationController]pushViewController:vc animated:YES];
}

- (void)toImageDetail:(id)sender
{
    WebDetailViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"WebDetailViewController"];
    vc.title = @"呵呵哒";
    [vc setURL:@"http://debug.pujintianxia.com/Mobile/Home/Questions"];
    [[self navigationController]pushViewController:vc animated:YES];
}

#pragma mark ScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [timer invalidate];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(scrollToNextPage:) userInfo:nil repeats:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrView
{
    if (scrView == scrollView)
    {
        [self reloadImage];
        [scrView setContentOffset:CGPointMake(scrollView.frame.size.width, 0) animated:NO];
        [noticeScrollView setContentOffset:CGPointMake(0, noticeScrollView.frame.size.height) animated:NO];
        pageControl.currentPage=currentImage;
    }
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrView
{
    if (scrView == scrollView)
    {
        [self reloadImage];
        [scrView setContentOffset:CGPointMake(scrollView.frame.size.width, 0) animated:NO];
        pageControl.currentPage=currentImage;
    }
    else
    {
        [self reloadNotice];
        [noticeScrollView setContentOffset:CGPointMake(0, noticeScrollView.frame.size.height) animated:NO];
    }
}

- (void)reloadImage
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

- (void)reloadNotice
{
    int topNoticeIndex, bottomNoticeIndex;
    currentNotice = (currentNotice+1)%notices.count;
    topNoticeIndex = (currentNotice-1)%notices.count;
    bottomNoticeIndex = (currentNotice+1)%notices.count;
    
    midView.label.text = [notices objectAtIndex:currentNotice];
    topView.label.text = [notices objectAtIndex:topNoticeIndex];
    bottomView.label.text = [notices objectAtIndex:bottomNoticeIndex];
}

@end
