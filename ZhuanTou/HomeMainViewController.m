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
@synthesize bgImageView, productBeforeButton, buyButton, profitPercentLabel, monthNumLabel, moryLabel, timeLabel, newerButton, detailButton;
@synthesize outterScrollView, outterViewHeight;
@synthesize innerScrollView, innerViewHeight;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [noticeButton addTarget:self action:@selector(toNotice:) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    float screenWidth = SCREEN_WIDTH;
    if (SCREEN_WIDTH > 400)
    {
        screenWidth = screenWidth - 8;
    }
    
    scrollView.contentSize = CGSizeMake(screenWidth * 3, 0);
    
    leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenWidth*16/25)];
    
    midImage = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth, 0, screenWidth, screenWidth*16/25)];
    
    midImageButton = [[UIButton alloc]initWithFrame:midImage.frame];
    midImageButton.titleLabel.text = @"";
    [midImageButton addTarget:self action:@selector(toImageDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth * 2, 0, screenWidth, screenWidth*16/25)];
    
    [scrollView addSubview:leftImage];
    [scrollView addSubview:midImage];
    [scrollView addSubview:midImageButton];
    [scrollView addSubview:rightImage];
    [scrollView setContentOffset:CGPointMake(screenWidth, 0) animated:NO];
    [scrollView setUserInteractionEnabled:NO];
    
    pageControl.hidden = YES;
    
    noticeScrollView.contentSize = CGSizeMake(0, noticeScrollView.frame.size.height * 3);
    
    topView = [[NoticeView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, noticeScrollView.frame.size.height)];
    midView = [[NoticeView alloc]initWithFrame:CGRectMake(0, noticeScrollView.frame.size.height, screenWidth, noticeScrollView.frame.size.height)];
    bottomView = [[NoticeView alloc]initWithFrame:CGRectMake(0, noticeScrollView.frame.size.height * 2, screenWidth, noticeScrollView.frame.size.height)];
    
    [noticeScrollView addSubview:topView];
    [noticeScrollView addSubview:midView];
    [noticeScrollView addSubview:bottomView];
    [noticeScrollView setContentOffset:CGPointMake(0, noticeScrollView.frame.size.height) animated:NO];
    
    buyButton.layer.cornerRadius = 3;
    [buyButton addTarget:self action:@selector(toBuy:) forControlEvents:UIControlEventTouchUpInside];
    [buyButton setUserInteractionEnabled:NO];
    [buyButton setAlpha:0.6f];
    
    
    [productBeforeButton setTitle:[NSString stringWithFormat:@"查看\n往期收益"] forState:UIControlStateNormal];
    [productBeforeButton addTarget:self action:@selector(toProductsBefore:) forControlEvents:UIControlEventTouchUpInside];
    productBeforeButton.titleLabel.numberOfLines = 0;
    productBeforeButton.titleLabel.textAlignment = 1;
    
    outterScrollView.delegate = self;
    innerScrollView.delegate = self;
    innerScrollView.clipsToBounds = NO;
    innerScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self setupProduct];
    }];

    [newerButton addTarget:self action:@selector(toNewer:) forControlEvents:UIControlEventTouchUpInside];
    [detailButton addTarget:self action:@selector(toDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    flag = false;
    setupDataFlag = 3;
    [self setupData];
    [self setupProduct];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    if (SCREEN_WIDTH > 400)
    {
        outterViewHeight.constant = (SCREEN_WIDTH-8)*16/25+34;
    }
    else
    {
        outterViewHeight.constant = SCREEN_WIDTH*16/25+34;
    }
    innerViewHeight.constant = CGRectGetHeight(self.view.frame)-outterViewHeight.constant;
}

- (void)viewDidAppear:(BOOL)animated
{
    if (setupDataFlag < 2)
    {
        setupDataFlag = 0;
        [self setupData];
    }

    if (bgPoint.x == 0) bgPoint = CGPointMake(bgImageView.frame.origin.x + bgImageView.frame.size.width/2+10, bgImageView.frame.origin.y+bgImageView.frame.size.height/2);
    [self bgCircleAnimation];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [timer invalidate];
    [noticeTimer invalidate];
}

- (void)becomeForeground
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setupData];
        [innerScrollView.mj_header beginRefreshing];
    });
}

- (void)bgCircleAnimation
{
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.duration = 1.5f;
    pathAnimation.repeatCount = 1;
    //设置运转动画的路径
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathAddArc(curvedPath, NULL, bgPoint.x, bgPoint.y, 10, M_PI, 3 * M_PI, 0);
    pathAnimation.path = curvedPath;
    [bgImageView.layer addAnimation:pathAnimation forKey:@"moveTheCircleOne"];
}

- (void)setupData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:@"api/article/getTopShowArticles"];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
        NSLog(@"%@", responseObject);
        notices = [NSMutableArray arrayWithArray:responseObject];
        if (notices.count == 0)
        {
            [notices addObject:@{@"title":@"暂无公告"}];
        }
        if (notices.count < 2)
        {
            [notices addObject:notices[0]];
        }
        topView.label.text = [[notices objectAtIndex:(currentNotice-1)%notices.count] objectForKey:@"title"];
        midView.label.text = [[notices objectAtIndex:currentNotice] objectForKey:@"title"];
        bottomView.label.text = [[notices objectAtIndex:(currentNotice+1)%notices.count] objectForKey:@"title"];
        flag = true;
        [noticeTimer invalidate];
        noticeTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scrollToNextNotice:) userInfo:nil repeats:YES];
        setupDataFlag++;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"当前网络状况不佳";
        [hud hide:YES afterDelay:1.5f];
        setupDataFlag = 0;
    }];
    
    AFHTTPRequestOperationManager *manager2 = [AFHTTPRequestOperationManager manager];
    NSString *URL2 = [BASEURL stringByAppendingString:@"api/article/getAppBannerInfo"];
    [manager2 GET:URL2 parameters:nil success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
        NSLog(@"%@", responseObject);
        bannerInfo = [NSArray arrayWithArray:responseObject];
        [NSThread detachNewThreadSelector:@selector(setImages) toTarget:self withObject:nil];
        setupDataFlag++;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"当前网络状况不佳";
        [hud hide:YES afterDelay:1.5f];
        setupDataFlag = 0;
    }];
}

- (void)setupProduct
{
    AFHTTPRequestOperationManager *manager1 = [AFHTTPRequestOperationManager manager];
    NSString *URL1 = [BASEURL stringByAppendingString:@"api/fofProd/1"];
    [manager1 GET:URL1 parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        idCode = [responseObject objectForKey:@"id"];
        NSString *numStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"expectedReturn"]];
        if ([numStr rangeOfString:@"."].location != NSNotFound)
        {
            profitPercentLabel.font = [UIFont fontWithName:@"EuphemiaUCAS-Bold" size:24.0f];
        }
        else
        {
            profitPercentLabel.font = [UIFont fontWithName:@"EuphemiaUCAS-Bold" size:43.0f];
        }
        profitPercentLabel.text = numStr;
        monthNumLabel.text = [NSString stringWithFormat:@"%d",(int)round((((NSString*)[responseObject objectForKey:@"noOfDays"]).doubleValue / 30))];
        timeLabel.text = [NSString stringWithFormat:@"%@开始抢购",[responseObject objectForKey:@"startRaisingDate"]];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
        [formatter setPositiveFormat:@"###,##0"];
        bidableAmount = [responseObject objectForKey:@"bidableAmount"];
        productInfo = [NSDictionary dictionaryWithDictionary:responseObject];
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式
        NSDate *startDate = [dateFormat dateFromString:[productInfo objectForKey:@"startRaisingDateTime"]];
        if (((NSString*)[responseObject objectForKey:@"bidableAmount"]).intValue == 0)
        {
            timeLabel.text = @"";
            
            [buyButton setUserInteractionEnabled:NO];
            [buyButton setAlpha:1.0f];
            [buyButton setTitle:@"已售罄" forState:UIControlStateNormal];
            buyButton.backgroundColor = ZTGRAY;
            
        }
        else
        {
            buyButton.backgroundColor = ZTBLUE;
            [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
            NSDate *date = [NSDate date];
            if ([date timeIntervalSinceDate:startDate] < 0.0)
            {
                [self zongheTimeCountDown];
                zongheTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(zongheTimeCountDown) userInfo:nil repeats:YES];
                
                [buyButton setUserInteractionEnabled:NO];
                [buyButton setAlpha:0.6f];
            }
            else
            {
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
                [formatter setPositiveFormat:@"###,##0"];
                timeLabel.text = @"";
                
                [buyButton setUserInteractionEnabled:YES];
                [buyButton setAlpha:1.0f];
            }
        }

        if ([innerScrollView.mj_header isRefreshing])
        {
            [innerScrollView.mj_header endRefreshing];
            [self bgCircleAnimation];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"当前网络状况不佳，请重试";
        [hud hide:YES afterDelay:1.5f];
        if ([innerScrollView.mj_header isRefreshing])
        {
            [innerScrollView.mj_header endRefreshing];
        }
    }];

}

- (void)setImages
{
    NSMutableArray *bufferImages = [[NSMutableArray alloc]init];
    for (int i = 0; i < bannerInfo.count; i++)
    {
        UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[bannerInfo[i] objectForKey:@"imgUrl"]]]];
        if (img)
        {
            [bufferImages addObject:img];
        }
        else
        {
            i--;
        }
    }
    images = [NSMutableArray arrayWithArray:bufferImages];
    leftImage.image = [images objectAtIndex:(currentImage-1)%images.count];
    midImage.image = [images objectAtIndex:currentImage];
    rightImage.image = [images objectAtIndex:(currentImage+1)%images.count];
    imageFlag = true;
    [self performSelectorOnMainThread:@selector(setupTimer) withObject:nil waitUntilDone:YES];
    pageControl.hidden = NO;
    [pageControl setNumberOfPages:images.count];
    [pageControl setCurrentPage:currentImage];
    [scrollView setUserInteractionEnabled:YES];

}

- (void)setupTimer
{
    [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(scrollToNextPage:) userInfo:nil repeats:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[self navigationController]setNavigationBarHidden:YES animated:YES];
    if (flag)
    {
        [noticeTimer invalidate];
        noticeTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scrollToNextNotice:) userInfo:nil repeats:YES];
    }
    if (imageFlag)
    {
        [timer invalidate];
        timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(scrollToNextPage:) userInfo:nil repeats:YES];
    }
    ZTTabBarViewController *tabVC = (ZTTabBarViewController*)[self tabBarController];
    if (tabVC.isRegister == 1)
    {
        [self performSelector:@selector(toNewer:) withObject:nil afterDelay:0];
        tabVC.isRegister = 0;
    }
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *username = [userDefault objectForKey:USERNAME];
    NSString *password = [userDefault objectForKey:PASSWORD];
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式
    NSDate *lastDate = [dateFormat dateFromString:[userDefault objectForKey:LASTLOGINDATE]];
    NSDate *date = [NSDate date];
    if ((username.length > 0) && (password.length == 0) && ([date timeIntervalSinceDate:lastDate] > 7*24*60*60))
    {
        UINavigationController *nav = [[self storyboard]instantiateViewControllerWithIdentifier:@"LoginNav"];
        [[self tabBarController] presentViewController:nav animated:YES completion:nil];
    }
}

- (void)toNewer:(id)sender
{
    WebDetailViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"WebDetailViewController"];
    vc.title = @"新手特权";
    [vc setURL:[BASEURL stringByAppendingString:@"Wap/WebView/Newer"]];
    [[self navigationController]pushViewController:vc animated:YES];
}

- (void)toDetail:(id)sender
{
    WebDetailViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"WebDetailViewController"];
    vc.title = @"分红宝";
    [vc setURL:[BASEURL stringByAppendingString:@"Wap/WebView/FenDesc"]];
    [[self navigationController]pushViewController:vc animated:YES];
}

- (void)zongheTimeCountDown
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式
    NSDate *startDate = [dateFormat dateFromString:[productInfo objectForKey:@"startRaisingDateTime"]];
    NSDate *date = [NSDate date];
    if ([startDate timeIntervalSinceDate:date] > 0.0)
    {
        int days = (int)[startDate timeIntervalSinceDate:date]/(24*60*60);
        int hours = ((int)[startDate timeIntervalSinceDate:date] - days*24*60*60)/(60*60);
        int minutes = ((int)[startDate timeIntervalSinceDate:date] - days*24*60*60 - hours*60*60)/60;
        int seconds = (int)[startDate timeIntervalSinceDate:date] - days*24*60*60 - hours*60*60 - minutes*60;
        if (days > 0)
        {
            timeLabel.text = [NSString stringWithFormat:@"开售倒计时：%d天%d小时",days,hours];
        }
        else if (hours > 0)
        {
            if (minutes+1 == 60)
            {
                hours = hours+1;
                minutes = -1;
            }
            timeLabel.text = [NSString stringWithFormat:@"开售倒计时：%d小时%d分",hours,minutes+1];
        }
        else
        {
            timeLabel.text = [NSString stringWithFormat:@"开售倒计时：%d分%d秒",minutes,seconds];
        }
    }
    else
    {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
        [formatter setPositiveFormat:@"###,##0"];
        timeLabel.text = @"";
        
        [buyButton setUserInteractionEnabled:YES];
        buyButton.backgroundColor = ZTBLUE;
        [buyButton setAlpha:1.0f];
    }
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
    vc.title = [bannerInfo[currentImage] objectForKey:@"title"];
    vc.inviteTitle = [bannerInfo[currentImage] objectForKey:@"subTitle"];
    vc.showInvite = [[bannerInfo[currentImage] objectForKey:@"showInvite"] boolValue];
    [vc setURL:[bannerInfo[currentImage] objectForKey:@"linkUrl"]];
    [[self navigationController]pushViewController:vc animated:YES];
}

- (void)toProductsBefore:(id)sender
{
    ProductsBeforeViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"ProductsBeforeViewController"];
    [[self navigationController]pushViewController:vc animated:YES];
}

- (void)toBuy:(id)sender
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (![userDefault boolForKey:ISLOGIN])
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您尚未登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *gotoLogin = [UIAlertAction actionWithTitle:@"去登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            UINavigationController *nav = [[self storyboard]instantiateViewControllerWithIdentifier:@"LoginNav"];
            [[self tabBarController] presentViewController:nav animated:YES completion:nil];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:gotoLogin];
        [alertController addAction:cancel];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        ProductBuyNewViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"ProductBuyNewViewController"];
        vc.style = ZONGHE;
        vc.idOrCode = idCode;
        vc.bidableAmount = bidableAmount;
        vc.productInfo = productInfo;
        [[self navigationController]pushViewController:vc animated:YES];
    }
}


#pragma mark ScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrView
{
    if (scrView == innerScrollView)
    {
        if (scrView.contentOffset.y >= 0)
        {
            [outterScrollView setContentOffset:scrView.contentOffset animated:NO];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrView
{
    if (scrView == scrollView)
    {
        [timer invalidate];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrView willDecelerate:(BOOL)decelerate
{
    if (scrView == scrollView)
    {
        timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(scrollToNextPage:) userInfo:nil repeats:YES];
    }
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
