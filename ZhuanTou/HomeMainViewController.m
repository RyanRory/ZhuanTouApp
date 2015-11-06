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
@synthesize wenjianButton, zongheButton, huoqiButton, zhaiquanButton, newerButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [noticeButton addTarget:self action:@selector(toNotice:) forControlEvents:UIControlEventTouchUpInside];
    
    images = [NSArray arrayWithObjects:[UIImage imageNamed:@"banner1.png"],[UIImage imageNamed:@"banner1.png"],[UIImage imageNamed:@"banner1.png"], nil];
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
    midView = [[NoticeView alloc]initWithFrame:CGRectMake(0, noticeScrollView.frame.size.height, SCREEN_WIDTH, noticeScrollView.frame.size.height)];
    bottomView = [[NoticeView alloc]initWithFrame:CGRectMake(0, noticeScrollView.frame.size.height * 2, SCREEN_WIDTH, noticeScrollView.frame.size.height)];
    
    [noticeScrollView addSubview:topView];
    [noticeScrollView addSubview:midView];
    [noticeScrollView addSubview:bottomView];
    [noticeScrollView setContentOffset:CGPointMake(0, noticeScrollView.frame.size.height) animated:NO];
    
    [wenjianButton addTarget:self action:@selector(toWenjian:) forControlEvents:UIControlEventTouchUpInside];
    [zongheButton addTarget:self action:@selector(toZonghe:) forControlEvents:UIControlEventTouchUpInside];
    [huoqiButton addTarget:self action:@selector(toHuoqi:) forControlEvents:UIControlEventTouchUpInside];
    [zhaiquanButton addTarget:self action:@selector(toZhaiquan:) forControlEvents:UIControlEventTouchUpInside];
    [newerButton addTarget:self action:@selector(toNewer:) forControlEvents:UIControlEventTouchUpInside];
    
    flag = false;
    [self setupData];

}

- (void)setupData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:@"api/article/getTopShowArticles"];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
        NSLog(@"%@", responseObject);
        notices = [NSArray arrayWithArray:responseObject];
        topView.label.text = [[notices objectAtIndex:notices.count-1] objectForKey:@"title"];
        midView.label.text = [[notices objectAtIndex:0] objectForKey:@"title"];
        bottomView.label.text = [[notices objectAtIndex:1] objectForKey:@"title"];
        flag = true;
        noticeTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scrollToNextNotice:) userInfo:nil repeats:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"当前网络状况不佳";
        [hud hide:YES afterDelay:1.5f];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[self navigationController]setNavigationBarHidden:YES animated:YES];
    timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(scrollToNextPage:) userInfo:nil repeats:YES];
    if (flag)
    {
        noticeTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scrollToNextNotice:) userInfo:nil repeats:YES];
    }
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
//    WebDetailViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"WebDetailViewController"];
//    vc.title = @"呵呵哒";
//    [vc setURL:@"http://debug.pujintianxia.com/Mobile/Home/Questions"];
//    [[self navigationController]pushViewController:vc animated:YES];
}

- (void)toWenjian:(id)sender
{
    ZTTabBarViewController *tabBarVC = (ZTTabBarViewController*)[self tabBarController];
    [tabBarVC setStyle:WENJIAN];
    [tabBarVC setSelectedIndex:1];
}

- (void)toZonghe:(id)sender
{
    ZTTabBarViewController *tabBarVC = (ZTTabBarViewController*)[self tabBarController];
    [tabBarVC setStyle:ZONGHE];
    [tabBarVC setSelectedIndex:1];
}

- (void)toHuoqi:(id)sender
{
    ZTTabBarViewController *tabBarVC = (ZTTabBarViewController*)[self tabBarController];
    [tabBarVC setStyle:HUOQI];
    [tabBarVC setSelectedIndex:1];
}

- (void)toZhaiquan:(id)sender
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"建设中...";
    hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"inbuilding.png"]];
    [hud hide:YES afterDelay:1.5f];
}

- (void)toNewer:(id)sender
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"建设中...";
    hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"inbuilding.png"]];
    [hud hide:YES afterDelay:1.5f];
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
    
    midView.label.text = [[notices objectAtIndex:currentNotice] objectForKey:@"title"];
    topView.label.text = [[notices objectAtIndex:topNoticeIndex] objectForKey:@"title"];
    bottomView.label.text = [[notices objectAtIndex:bottomNoticeIndex] objectForKey:@"title"];
}

@end
