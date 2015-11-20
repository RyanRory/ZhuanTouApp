//
//  ProductScrollViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/11/12.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "ProductScrollViewController.h"

@interface ProductScrollViewController ()

@end

@implementation ProductScrollViewController

@synthesize wenjianButton, zongheButton, huoqiButton;
@synthesize mainScrollView, mainView, mainViewHeight;
@synthesize scrollView;
@synthesize wenjianView, wenjianBgImageView, wenjianDetailButton, wenjianMonthLabel, wenjianMOYLabel, wenjianRateLabel, wenjianViewWidth, wenjianAmountLabel, wenjianBuyButton, wenjianTimeLabel;
@synthesize zongheView, zongheBgImageView, zongheBigRateLabel, zongheDetailButton, zongheMonthLabel, zongheMOYLabel, zongheSmallRateLabel, zongheViewWidth, productsBeforeButton, zongheAmountLabel, zongheBuyButton, zongheTimeLabel;
@synthesize huoqiView, huoqiBgImageView1, huoqiBgImageView2, huoqiDetailButton, huoqiRateLabel, huoqiViewWidth, huoqiAmountLabel, huoqiBuyButton, x1, y1, x2, y2;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController]setNavigationBarHidden:NO animated:YES];
    self.view.clipsToBounds = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    wenjianView.clipsToBounds = YES;
    zongheView.clipsToBounds = YES;
    huoqiView.clipsToBounds = YES;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    
    [wenjianButton addTarget:self action:@selector(clickWenjianButton:) forControlEvents:UIControlEventTouchUpInside];
    [zongheButton addTarget:self action:@selector(clickZongheButton:) forControlEvents:UIControlEventTouchUpInside];
    [huoqiButton addTarget:self action:@selector(clickHuoqi:) forControlEvents:UIControlEventTouchUpInside];
    
    [wenjianDetailButton addTarget:self action:@selector(goToDetail:) forControlEvents:UIControlEventTouchUpInside];
    [zongheDetailButton addTarget:self action:@selector(goToDetail:) forControlEvents:UIControlEventTouchUpInside];
    [huoqiDetailButton addTarget:self action:@selector(goToDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    [productsBeforeButton setTitle:[NSString stringWithFormat:@"查看\n往期收益"] forState:UIControlStateNormal];
    productsBeforeButton.titleLabel.numberOfLines = 0;
    productsBeforeButton.titleLabel.textAlignment = 1;
    [productsBeforeButton addTarget:self action:@selector(goToProductsBefore:) forControlEvents:UIControlEventTouchUpInside];
    
    wenjianBuyButton.layer.cornerRadius = 3;
    [wenjianBuyButton addTarget:self action:@selector(buyNow:) forControlEvents:UIControlEventTouchUpInside];
    zongheBuyButton.layer.cornerRadius = 3;
    [zongheBuyButton addTarget:self action:@selector(buyNow:) forControlEvents:UIControlEventTouchUpInside];
    huoqiBuyButton.layer.cornerRadius = 3;
    [huoqiBuyButton addTarget:self action:@selector(buyNow:) forControlEvents:UIControlEventTouchUpInside];
    
    wenjianBuyButton.hidden = YES;
    wenjianTimeLabel.hidden = YES;
    wenjianAmountLabel.hidden = YES;
    
    huoqiBuyButton.hidden = YES;
    huoqiAmountLabel.hidden = YES;

    
    [zongheButton setUserInteractionEnabled:NO];
    wenjianButton.tintColor = ZTGRAY;
    zongheButton.tintColor = ZTBLUE;
    huoqiButton.tintColor = ZTGRAY;
    
    style = ZONGHE;
    [scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
    productsBeforeButton.tintColor = ZTBLUE;
    
    [self setupHuoqi];
    [self setupWenjian];
    [self setupZonghe];

    mainScrollView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if ([style isEqualToString:WENJIAN])
        {
            [self setupWenjian];
        }
        else if ([style isEqualToString:ZONGHE])
        {
            [self setupZonghe];
        }
        else
        {
            [self setupHuoqi];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    flag = false;
    if (frame.origin.x == 0) frame = huoqiBgImageView1.frame;
    if (bgPoint.x == 0) bgPoint = CGPointMake(wenjianBgImageView.frame.origin.x + wenjianBgImageView.frame.size.width/2+10, wenjianBgImageView.frame.origin.y+wenjianBgImageView.frame.size.height/2);
    if (point.x == 0) point = CGPointMake(wenjianBgImageView.frame.origin.x - frame.origin.x + 20, wenjianBgImageView.frame.origin.y - frame.origin.y + 5);
    if ([style isEqualToString:WENJIAN])
    {
        [self bgCircleAnimation:wenjianBgImageView];
    }
    else if ([style isEqualToString:ZONGHE])
    {
        [self bgCircleAnimation:zongheBgImageView];
    }
    else
    {
        //动画效果
        [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
        [UIView setAnimationDuration:0.8f];
        [huoqiBgImageView1 setFrame:CGRectMake(frame.origin.x + point.x, frame.origin.y + point.y, frame.size.width, frame.size.height)];
        [huoqiBgImageView2 setFrame:CGRectMake(frame.origin.x - point.x, frame.origin.y - point.y, frame.size.width, frame.size.height)];
        [UIView commitAnimations];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)becomeForeground
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [mainScrollView.header beginRefreshing];
    });
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (!flag)
    {
        [huoqiBgImageView1 setFrame:frame];
        [huoqiBgImageView2 setFrame:frame];
    }
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    mainViewHeight.constant = CGRectGetHeight(self.view.frame)-35;
    wenjianViewWidth.constant = SCREEN_WIDTH;
    zongheViewWidth.constant = SCREEN_WIDTH;
    huoqiViewWidth.constant = SCREEN_WIDTH;
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*3, 0);
    if (flag)
    {
        x1.constant = point.x;
        y1.constant = point.y;
        x2.constant = -point.x;
        y2.constant = -point.y;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goToProductsBefore:(id)sender
{
    ProductsBeforeViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"ProductsBeforeViewController"];
    [[self navigationController]pushViewController:vc animated:YES];
}

- (void)goToDetail:(id)sender
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"建设中...";
    hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"inbuilding.png"]];
    [hud hide:YES afterDelay:1.5f];
}

- (void)bgCircleAnimation:(UIImageView*)bg
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
    [bg.layer addAnimation:pathAnimation forKey:@"moveTheCircleOne"];
}

- (void)clickWenjianButton:(id)sender
{
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)clickZongheButton:(id)sender
{
    [scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
}

- (void)clickHuoqi:(id)sender
{
    [scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * 2, 0) animated:YES];
}

- (void)setupWenjian
{
    [wenjianBuyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    [wenjianBuyButton setUserInteractionEnabled:NO];
    [wenjianBuyButton setAlpha:0.6f];

    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:@"api/fofProd/0"];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        wenjianData = [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *numStr = [NSString stringWithFormat:@"%@",[wenjianData objectForKey:@"interestRate"]];
        if ([numStr rangeOfString:@"."].location != NSNotFound)
        {
            wenjianRateLabel.font = [UIFont fontWithName:@"EuphemiaUCAS-Bold" size:38.0f];
            wenjianRateLabel.text = numStr;
        }
        else
        {
            wenjianRateLabel.font = [UIFont fontWithName:@"EuphemiaUCAS-Bold" size:65.0f];
            wenjianRateLabel.text = numStr;
        }
        wenjianMonthLabel.text = [NSString stringWithFormat:@"%d",(int)round((((NSString*)[wenjianData objectForKey:@"noOfDays"]).doubleValue / 30))];
        if ([mainScrollView.header isRefreshing])
        {
            [mainScrollView.header endRefreshing];
            [self bgCircleAnimation:wenjianBgImageView];
        }
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
        [formatter setPositiveFormat:@"###,##0"];
        wenjianAmountLabel.text = [NSString stringWithFormat:@"产品规模：%@万元",[formatter stringFromNumber:[NSNumber numberWithInt:[NSString stringWithFormat:@"%@",[wenjianData objectForKey:@"targetPurchaseAmount"]].intValue/10000]]];
        wenjianTimeLabel.text = [NSString stringWithFormat:@"%@开始抢购",[wenjianData objectForKey:@"startRaisingDate"]];
        NSDate *date = [NSDate date];
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式
        if (((NSString*)[wenjianData objectForKey:@"bidableAmount"]).intValue > 0)
        {
            NSDate *startDate = [dateFormat dateFromString:[wenjianData objectForKey:@"startRaisingDateTime"]];
            if ([date timeIntervalSinceDate:startDate] < 0.0)
            {
                [wenjianBuyButton setUserInteractionEnabled:NO];
                [wenjianBuyButton setAlpha:0.6f];
            }
            else
            {
                [wenjianBuyButton setUserInteractionEnabled:YES];
                [wenjianBuyButton setAlpha:1.0f];
            }
        }
        else
        {
            [wenjianBuyButton setUserInteractionEnabled:NO];
            [wenjianBuyButton setAlpha:1.0f];
            wenjianBuyButton.backgroundColor = ZTGRAY;
            [wenjianBuyButton setTitle:@"已售完" forState:UIControlStateNormal];
        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"当前网络状况不佳，请重试";
        [hud hide:YES afterDelay:1.5f];
        if ([scrollView.header isRefreshing])
        {
            [scrollView.header endRefreshing];
        }
    }];
}

- (void)setupZonghe
{
    [zongheBuyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    [zongheBuyButton setUserInteractionEnabled:NO];
    [zongheBuyButton setAlpha:0.6f];
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:@"api/fofProd/1"];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        zongheData = [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *numStr = [NSString stringWithFormat:@"%@",[zongheData objectForKey:@"expectedReturn"]];
        if ([numStr rangeOfString:@"."].location != NSNotFound)
        {
            zongheBigRateLabel.font = [UIFont fontWithName:@"EuphemiaUCAS-Bold" size:38.0f];
            zongheBigRateLabel.text = numStr;
        }
        else
        {
            zongheBigRateLabel.font = [UIFont fontWithName:@"EuphemiaUCAS-Bold" size:65.0f];
            zongheBigRateLabel.text = numStr;
        }
        zongheMonthLabel.text = [NSString stringWithFormat:@"%d",(int)round((((NSString*)[zongheData objectForKey:@"noOfDays"]).doubleValue / 30))];
        if ([mainScrollView.header isRefreshing])
        {
            [mainScrollView.header endRefreshing];
            [self bgCircleAnimation:zongheBgImageView];
        }
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
        [formatter setPositiveFormat:@"###,##0"];
        zongheAmountLabel.text = [NSString stringWithFormat:@"产品规模：%@万元",[formatter stringFromNumber:[NSNumber numberWithInt:[NSString stringWithFormat:@"%@",[zongheData objectForKey:@"targetPurchaseAmount"]].intValue/10000]]];
        zongheTimeLabel.text = [NSString stringWithFormat:@"%@开始抢购",[zongheData objectForKey:@"startRaisingDate"]];
        zongheSmallRateLabel.text = [NSString stringWithFormat:@"%@",[zongheData objectForKey:@"interestRate"]];
        NSDate *date = [NSDate date];
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式
        if (((NSString*)[zongheData objectForKey:@"bidableAmount"]).intValue > 0)
        {
            NSDate *startDate = [dateFormat dateFromString:[zongheData objectForKey:@"startRaisingDateTime"]];
            if ([date timeIntervalSinceDate:startDate] < 0.0)
            {
                [zongheBuyButton setUserInteractionEnabled:NO];
                [zongheBuyButton setAlpha:0.6f];
            }
            else
            {
                [zongheBuyButton setUserInteractionEnabled:YES];
                [zongheBuyButton setAlpha:1.0f];
            }
        }
        else
        {
            [zongheBuyButton setUserInteractionEnabled:NO];
            [zongheBuyButton setAlpha:1.0f];
            zongheBuyButton.backgroundColor = ZTGRAY;
            [zongheBuyButton setTitle:@"已售完" forState:UIControlStateNormal];
        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"当前网络状况不佳，请重试";
        [hud hide:YES afterDelay:1.5f];
        if ([scrollView.header isRefreshing])
        {
            [scrollView.header endRefreshing];
        }
    }];

}

- (void)setupHuoqi
{
    [huoqiBuyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    [huoqiBuyButton setUserInteractionEnabled:NO];
    [huoqiBuyButton setAlpha:0.6f];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:@"api/stat/ztbDesc4M"];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        huoqiData = [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *numStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"interestRate"]];
        if ([numStr rangeOfString:@"."].location != NSNotFound)
        {
            huoqiRateLabel.font = [UIFont fontWithName:@"EuphemiaUCAS-Bold" size:38.0f];
            huoqiRateLabel.text = numStr;
        }
        else
        {
            huoqiRateLabel.font = [UIFont fontWithName:@"EuphemiaUCAS-Bold" size:65.0f];
            huoqiRateLabel.text = numStr;
        }
        if ([mainScrollView.header isRefreshing])
        {
            [mainScrollView.header endRefreshing];
        }
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
        [formatter setPositiveFormat:@"###,##0"];
        huoqiAmountLabel.text = [NSString stringWithFormat:@"产品规模：%@万元",[formatter stringFromNumber:[NSNumber numberWithInt:[NSString stringWithFormat:@"%@",[huoqiData objectForKey:@"totalAmount"]].intValue/10000]]];
        if (((NSString*)[huoqiData objectForKey:@"bidableAmount"]).intValue > 0)
        {
            [huoqiBuyButton setUserInteractionEnabled:YES];
            [huoqiBuyButton setAlpha:1.0f];
        }
        else
        {
            [huoqiBuyButton setUserInteractionEnabled:NO];
            [huoqiBuyButton setAlpha:1.0f];
            huoqiBuyButton.backgroundColor = ZTGRAY;
            [huoqiBuyButton setTitle:@"已售完" forState:UIControlStateNormal];
        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"当前网络状况不佳，请重试";
        [hud hide:YES afterDelay:1.5f];
        if ([scrollView.header isRefreshing])
        {
            [scrollView.header endRefreshing];
        }

    }];
    
    
}

- (void)buyNow:(id)sender
{
    ProductBuyViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"ProductBuyViewController"];
    vc.style = style;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    [formatter setPositiveFormat:@"###,##0.00"];
    if ([style isEqualToString:WENJIAN])
    {
        vc.productInfo = wenjianData;
        vc.idOrCode = [wenjianData objectForKey:@"id"];
        vc.bidableAmount = [NSString stringWithString:[formatter stringFromNumber:[wenjianData objectForKey:@"bidableAmount"]]];
    }
    else if ([style isEqualToString:ZONGHE])
    {
        vc.productInfo = zongheData;
        vc.idOrCode = [zongheData objectForKey:@"id"];
        vc.bidableAmount = [NSString stringWithString:[formatter stringFromNumber:[zongheData objectForKey:@"bidableAmount"]]];
    }
    else
    {
        flag = true;
        vc.productInfo = huoqiData;
        vc.bidableAmount = [NSString stringWithString:[formatter stringFromNumber:[huoqiData objectForKey:@"bidableAmount"]]];
    }
    [[self navigationController]pushViewController:vc animated:YES];
}

#pragma mark ScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrView
{
    if (scrView == scrollView)
    {
        if (scrView.contentOffset.x == 0)
        {
            if (![style isEqualToString:WENJIAN])
            {
                style = WENJIAN;
                wenjianButton.tintColor = ZTLIGHTRED;
                [wenjianButton setUserInteractionEnabled:NO];
                [zongheButton setUserInteractionEnabled:YES];
                [huoqiButton setUserInteractionEnabled:YES];
                zongheButton.tintColor = ZTGRAY;
                huoqiButton.tintColor = ZTGRAY;
                [self bgCircleAnimation:wenjianBgImageView];
                [huoqiBgImageView1 setFrame:frame];
                [huoqiBgImageView2 setFrame:frame];
                wenjianBuyButton.hidden = NO;
                wenjianTimeLabel.hidden = NO;
                wenjianAmountLabel.hidden = NO;
                zongheBuyButton.hidden = YES;
                zongheTimeLabel.hidden = YES;
                zongheAmountLabel.hidden = YES;
                huoqiBuyButton.hidden = YES;
                huoqiAmountLabel.hidden = YES;
            }
        }
        else if (scrView.contentOffset.x == SCREEN_WIDTH)
        {
            if (![style isEqualToString:ZONGHE])
            {
                style = ZONGHE;
                zongheButton.tintColor = ZTBLUE;
                [zongheButton setUserInteractionEnabled:NO];
                [wenjianButton setUserInteractionEnabled:YES];
                [huoqiButton setUserInteractionEnabled:YES];
                wenjianButton.tintColor = ZTGRAY;
                huoqiButton.tintColor = ZTGRAY;
                [self bgCircleAnimation:zongheBgImageView];
                [huoqiBgImageView1 setFrame:frame];
                [huoqiBgImageView2 setFrame:frame];
                wenjianBuyButton.hidden = YES;
                wenjianTimeLabel.hidden = YES;
                wenjianAmountLabel.hidden = YES;
                zongheBuyButton.hidden = NO;
                zongheTimeLabel.hidden = NO;
                zongheAmountLabel.hidden = NO;
                huoqiBuyButton.hidden = YES;
                huoqiAmountLabel.hidden = YES;
            }
        }
        else
        {
            if (![style isEqualToString:HUOQI])
            {
                style = HUOQI;
                huoqiButton.tintColor = ZTRED;
                [huoqiButton setUserInteractionEnabled:NO];
                [wenjianButton setUserInteractionEnabled:YES];
                [zongheButton setUserInteractionEnabled:YES];
                wenjianButton.tintColor = ZTGRAY;
                zongheButton.tintColor = ZTGRAY;
                wenjianBuyButton.hidden = YES;
                wenjianTimeLabel.hidden = YES;
                wenjianAmountLabel.hidden = YES;
                zongheBuyButton.hidden = YES;
                zongheTimeLabel.hidden = YES;
                zongheAmountLabel.hidden = YES;
                huoqiBuyButton.hidden = NO;
                huoqiAmountLabel.hidden = NO;
                //动画效果
                [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
                [UIView setAnimationDuration:0.8f];
                [huoqiBgImageView1 setFrame:CGRectMake(frame.origin.x + point.x, frame.origin.y + point.y, frame.size.width, frame.size.height)];
                [huoqiBgImageView2 setFrame:CGRectMake(frame.origin.x - point.x, frame.origin.y - point.y, frame.size.width, frame.size.height)];
                [UIView commitAnimations];
            }
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrView
{
    if (scrView == scrollView)
    {
        if (scrView.contentOffset.x == wenjianView.frame.origin.x)
        {
            if (![style isEqualToString:WENJIAN])
            {
                style = WENJIAN;
                wenjianButton.tintColor = ZTLIGHTRED;
                [wenjianButton setUserInteractionEnabled:NO];
                [zongheButton setUserInteractionEnabled:YES];
                [huoqiButton setUserInteractionEnabled:YES];
                zongheButton.tintColor = ZTGRAY;
                huoqiButton.tintColor = ZTGRAY;
                [self bgCircleAnimation:wenjianBgImageView];
                [huoqiBgImageView1 setFrame:frame];
                [huoqiBgImageView2 setFrame:frame];
                wenjianBuyButton.hidden = NO;
                wenjianTimeLabel.hidden = NO;
                wenjianAmountLabel.hidden = NO;
                zongheBuyButton.hidden = YES;
                zongheTimeLabel.hidden = YES;
                zongheAmountLabel.hidden = YES;
                huoqiBuyButton.hidden = YES;
                huoqiAmountLabel.hidden = YES;
            }
        }
        else if (scrView.contentOffset.x == zongheView.frame.origin.x)
        {
            if (![style isEqualToString:ZONGHE])
            {
                style = ZONGHE;
                zongheButton.tintColor = ZTBLUE;
                [zongheButton setUserInteractionEnabled:NO];
                [wenjianButton setUserInteractionEnabled:YES];
                [huoqiButton setUserInteractionEnabled:YES];
                wenjianButton.tintColor = ZTGRAY;
                huoqiButton.tintColor = ZTGRAY;
                [self bgCircleAnimation:zongheBgImageView];
                [huoqiBgImageView1 setFrame:frame];
                [huoqiBgImageView2 setFrame:frame];
                wenjianBuyButton.hidden = YES;
                wenjianTimeLabel.hidden = YES;
                wenjianAmountLabel.hidden = YES;
                zongheBuyButton.hidden = NO;
                zongheTimeLabel.hidden = NO;
                zongheAmountLabel.hidden = NO;
                huoqiBuyButton.hidden = YES;
                huoqiAmountLabel.hidden = YES;
            }
        }
        else
        {
            if (![style isEqualToString:HUOQI])
            {
                style = HUOQI;
                huoqiButton.tintColor = ZTRED;
                [huoqiButton setUserInteractionEnabled:NO];
                [wenjianButton setUserInteractionEnabled:YES];
                [zongheButton setUserInteractionEnabled:YES];
                wenjianButton.tintColor = ZTGRAY;
                zongheButton.tintColor = ZTGRAY;
                wenjianBuyButton.hidden = YES;
                wenjianTimeLabel.hidden = YES;
                wenjianAmountLabel.hidden = YES;
                zongheBuyButton.hidden = YES;
                zongheTimeLabel.hidden = YES;
                zongheAmountLabel.hidden = YES;
                huoqiBuyButton.hidden = NO;
                huoqiAmountLabel.hidden = NO;
                //动画效果
                [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
                [UIView setAnimationDuration:0.8f];
                [huoqiBgImageView1 setFrame:CGRectMake(frame.origin.x + point.x, frame.origin.y + point.y, frame.size.width, frame.size.height)];
                [huoqiBgImageView2 setFrame:CGRectMake(frame.origin.x - point.x, frame.origin.y - point.y, frame.size.width, frame.size.height)];
                [UIView commitAnimations];
            }
        }
    }
}

@end
