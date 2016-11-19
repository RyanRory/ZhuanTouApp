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
@synthesize wenjianView, wenjianBgImageView, wenjianDetailButton, wenjianMonthLabel, wenjianMOYLabel, wenjianRateLabel, wenjianViewWidth, wenjianBuyButton;
@synthesize wenjianTimeView, wenjianProgressView, startBuyLabel, startBuyLine, startBuyPointImageView, startBuyTimeLabel, startTradePointImageView, startTradeLabel, startTradeLine, startTradeTimeLabel, endLabel, endLine, endPointImageView, endTimeLabel, buyingLabel, tradingLabel;
@synthesize zongheView, zongheBgImageView, zongheBigRateLabel, zongheDetailButton, zongheMonthLabel, zongheMOYLabel, zongheSmallRateLabel, zongheViewWidth, productsBeforeButton, zongheBuyButton;
@synthesize zongheTimeView, zongheProgressView, zongheBuyingLabel, zongheEndedLabel, zongheEndLabel, zongheEndLine, zongheEndPoint, zongheEndTimeLabel, zongheStartBuyLabel, zongheStartBuyLine, zongheStartBuyPoint, zongheStartBuyTimeLabel, zongheStartTradeLabel, zongheStartTradeLine, zongheStartTradePoint, zongheStartTradeTimeLabel, zongheTradingLabel;
@synthesize huoqiView, huoqiBgImageView1, huoqiBgImageView2, huoqiDetailButton, huoqiRateLabel, huoqiViewWidth, huoqiAmountLabel, huoqiDescriptionLabel, huoqiBuyButton, x1, y1, x2, y2;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController]setNavigationBarHidden:NO animated:YES];
    self.view.clipsToBounds = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    if (SCREEN_WIDTH > 400)
    {
        screenWidth = SCREEN_WIDTH-8;
    }
    else
    {
        screenWidth = SCREEN_WIDTH;
    }
    
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
    
    huoqiBuyButton.hidden = YES;
    huoqiAmountLabel.hidden = YES;
    huoqiDescriptionLabel.hidden = YES;
    
    wenjianBuyButton.hidden = YES;
    wenjianTimeView.hidden = YES;
    [zongheButton setUserInteractionEnabled:NO];
    wenjianButton.tintColor = ZTGRAY;
    zongheButton.tintColor = ZTBLUE;
    huoqiButton.tintColor = ZTGRAY;
    
    style = ZONGHE;
    [scrollView setContentOffset:CGPointMake(screenWidth, 0) animated:NO];
    productsBeforeButton.tintColor = ZTBLUE;

    mainScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceivePush:) name:@"RECEIVEPUSH" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:ISPUSHSHOW])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ISPUSHSHOW];
        [[NSUserDefaults standardUserDefaults] synchronize];
        AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (app.userInfo.count > 0)
        {
            NSString *afterOpen = [app.userInfo objectForKey:@"after_open"];
            if ([afterOpen isEqualToString:@"go_activity"])
            {
                NSString *activity = [app.userInfo objectForKey:@"activity"];
                if ([activity isEqualToString:@"wyb"] || [activity isEqualToString:@"buywyb"])
                {
                    zongheBuyButton.hidden = YES;
                    zongheTimeView.hidden = YES;
                    [wenjianButton setUserInteractionEnabled:NO];
                    wenjianButton.tintColor = ZTLIGHTRED;
                    zongheButton.tintColor = ZTGRAY;
                    huoqiButton.tintColor = ZTGRAY;
                    wenjianBuyButton.hidden = NO;
                    wenjianTimeView.hidden = NO;
                    
                    style = WENJIAN;
                    [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
                }
                else if ([activity isEqualToString:@"fhb"] || [activity isEqualToString:@"buyfhb"])
                {
                    wenjianBuyButton.hidden = YES;
                    wenjianTimeView.hidden = YES;
                    [zongheButton setUserInteractionEnabled:NO];
                    wenjianButton.tintColor = ZTGRAY;
                    zongheButton.tintColor = ZTBLUE;
                    huoqiButton.tintColor = ZTGRAY;
                    zongheBuyButton.hidden = NO;
                    zongheTimeView.hidden = NO;
                    
                    style = ZONGHE;
                    [scrollView setContentOffset:CGPointMake(screenWidth, 0) animated:NO];
                    productsBeforeButton.tintColor = ZTBLUE;
                }
            }
            else
            {
                wenjianBuyButton.hidden = YES;
                wenjianTimeView.hidden = YES;
                [zongheButton setUserInteractionEnabled:NO];
                wenjianButton.tintColor = ZTGRAY;
                zongheButton.tintColor = ZTBLUE;
                huoqiButton.tintColor = ZTGRAY;
                zongheBuyButton.hidden = NO;
                zongheTimeView.hidden = NO;
                
                style = ZONGHE;
                [scrollView setContentOffset:CGPointMake(screenWidth, 0) animated:NO];
                productsBeforeButton.tintColor = ZTBLUE;
            }
        }
        else
        {
            wenjianBuyButton.hidden = YES;
            wenjianTimeView.hidden = YES;
            [zongheButton setUserInteractionEnabled:NO];
            wenjianButton.tintColor = ZTGRAY;
            zongheButton.tintColor = ZTBLUE;
            huoqiButton.tintColor = ZTGRAY;
            
            style = ZONGHE;
            [scrollView setContentOffset:CGPointMake(screenWidth, 0) animated:NO];
            productsBeforeButton.tintColor = ZTBLUE;
        }
    }
    [self setupHuoqi];
    [self setupWenjian];
    [self setupZonghe];
}

- (void)viewDidAppear:(BOOL)animated
{
    flag = false;
    if (frame.origin.x == 0) {frame = huoqiBgImageView1.frame;NSLog(@"ttttttt");}
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
    if ((wenjianData.count > 0) && (((NSString*)[wenjianData objectForKey:@"bidableAmount"]).intValue > 0))
    {
        wenjianTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(wenjianTimeCountDown) userInfo:nil repeats:YES];
    }
    if ((zongheData.count > 0) && (((NSString*)[zongheData objectForKey:@"bidableAmount"]).intValue > 0))
    {
        zongheTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(zongheTimeCountDown) userInfo:nil repeats:YES];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
}

- (void)becomeForeground
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [mainScrollView.mj_header beginRefreshing];
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

- (void)viewWillDisappear:(BOOL)animated
{
    [wenjianTimer invalidate];
    [zongheTimer invalidate];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    mainViewHeight.constant = CGRectGetHeight(self.view.frame)-35;
    wenjianViewWidth.constant = screenWidth;
    zongheViewWidth.constant = screenWidth;
    huoqiViewWidth.constant = screenWidth;
    scrollView.contentSize = CGSizeMake(screenWidth*3, 0);
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
    if ([style isEqualToString:WENJIAN])
    {
        WebDetailViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"WebDetailViewController"];
        vc.title = @"稳盈宝";
        [vc setURL:[BASEURL stringByAppendingString:@"Wap/WebView/WenDesc"]];
        [[self navigationController]pushViewController:vc animated:YES];
    }
    else if ([style isEqualToString:ZONGHE])
    {
        WebDetailViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"WebDetailViewController"];
        vc.title = @"分红宝";
        [vc setURL:[BASEURL stringByAppendingString:@"Wap/WebView/FenDesc"]];
        [[self navigationController]pushViewController:vc animated:YES];
    }
    else
    {
        flag = true;
        WebDetailViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"WebDetailViewController"];
        vc.title = @"专投宝";
        [vc setURL:[BASEURL stringByAppendingString:@"Wap/WebView/ZhuanDesc"]];
        [[self navigationController]pushViewController:vc animated:YES];
    }
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
    wenjianButton.tintColor = ZTLIGHTRED;
    [wenjianButton setUserInteractionEnabled:NO];
    [zongheButton setUserInteractionEnabled:YES];
    [huoqiButton setUserInteractionEnabled:YES];
    zongheButton.tintColor = ZTGRAY;
    huoqiButton.tintColor = ZTGRAY;
}

- (void)clickZongheButton:(id)sender
{
    [scrollView setContentOffset:CGPointMake(screenWidth, 0) animated:YES];
    zongheButton.tintColor = ZTBLUE;
    [zongheButton setUserInteractionEnabled:NO];
    [wenjianButton setUserInteractionEnabled:YES];
    [huoqiButton setUserInteractionEnabled:YES];
    wenjianButton.tintColor = ZTGRAY;
    huoqiButton.tintColor = ZTGRAY;
}

- (void)clickHuoqi:(id)sender
{
    [scrollView setContentOffset:CGPointMake(screenWidth * 2, 0) animated:YES];
    huoqiButton.tintColor = ZTRED;
    [huoqiButton setUserInteractionEnabled:NO];
    [wenjianButton setUserInteractionEnabled:YES];
    [zongheButton setUserInteractionEnabled:YES];
    wenjianButton.tintColor = ZTGRAY;
    zongheButton.tintColor = ZTGRAY;
}

- (void)setupWenjian
{
    [wenjianTimer invalidate];
    [wenjianBuyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    [wenjianBuyButton setUserInteractionEnabled:NO];
    [wenjianBuyButton setAlpha:0.6f];
    wenjianBuyButton.backgroundColor = ZTLIGHTRED;

    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:@"api/fofProd/0"];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        wenjianData = [NSMutableDictionary dictionaryWithDictionary:responseObject];
        NSString *numStr = [NSString stringWithFormat:@"%@",[wenjianData objectForKey:@"expectedReturn"]];
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
        tradingLabel.text = [NSString stringWithFormat:@"年化%@%%收益\n每日派息",[wenjianData objectForKey:@"interestRate"]];
        
        if ([mainScrollView.mj_header isRefreshing])
        {
            [mainScrollView.mj_header endRefreshing];
            [self bgCircleAnimation:wenjianBgImageView];
        }
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式
        NSDate *startDate = [dateFormat dateFromString:[wenjianData objectForKey:@"startRaisingDateTime"]];
        NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:startDate];
        
        long year = [components year];
        long month = [components month];
        long day = [components day];
        
        startBuyTimeLabel.text = [NSString stringWithFormat:@"%4ld-%02ld-%02ld" ,year,month,day];
        
        [dateFormat setDateFormat:@"yyyy年MM月dd日"];//设定时间格式
        NSDate *beginDate = [dateFormat dateFromString:[wenjianData objectForKey:@"beginDate"]];
        components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:beginDate];
        year = [components year];
        month = [components month];
        day = [components day];
        startTradeTimeLabel.text = [NSString stringWithFormat:@"%4ld-%02ld-%02ld",year,month,day];
        [wenjianData setValue:[NSString stringWithFormat:@"%4ld-%02ld-%02ld 09:00:00",year,month,day] forKey:@"beginDateTime"];
        
        NSDate *endDate = [dateFormat dateFromString:[wenjianData objectForKey:@"endDate"]];
        components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:endDate];
        year = [components year];
        month = [components month];
        day = [components day];
        endTimeLabel.text = [NSString stringWithFormat:@"%4ld-%02ld-%02ld",year,month,day];
        [wenjianData setValue:[NSString stringWithFormat:@"%4ld-%02ld-%02ld 15:30:00",year,month,day] forKey:@"endDateTime"];
        
        [self wenjianTimeCountDown];
        wenjianTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(wenjianTimeCountDown) userInfo:nil repeats:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"当前网络状况不佳，请重试";
        [hud hide:YES afterDelay:1.5f];
        if ([mainScrollView.mj_header isRefreshing])
        {
            [mainScrollView.mj_header endRefreshing];
        }
    }];
}

- (void)setupZonghe
{
    [zongheTimer invalidate];
    [zongheBuyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    [zongheBuyButton setUserInteractionEnabled:NO];
    [zongheBuyButton setAlpha:0.6f];
    zongheBuyButton.backgroundColor = ZTBLUE;
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:@"api/fofProd/1"];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        zongheData = [NSMutableDictionary dictionaryWithDictionary:responseObject];
        NSString *numStr = [NSString stringWithFormat:@"%.1f",[NSString stringWithFormat:@"%@",[zongheData objectForKey:@"recentReturn"]].doubleValue];
        //NSString *numStr = @"10.2";
        if ([numStr rangeOfString:@"."].location != NSNotFound)
        {
            zongheBigRateLabel.font = [UIFont fontWithName:@"EuphemiaUCAS-Bold" size:57.0f];
            zongheBigRateLabel.text = numStr;
        }
        else
        {
            zongheBigRateLabel.font = [UIFont fontWithName:@"EuphemiaUCAS-Bold" size:65.0f];
            zongheBigRateLabel.text = numStr;
        }
        zongheMonthLabel.text = [NSString stringWithFormat:@"%d",(int)round((((NSString*)[zongheData objectForKey:@"noOfDays"]).doubleValue / 30))];
        if ([mainScrollView.mj_header isRefreshing])
        {
            [mainScrollView.mj_header endRefreshing];
            [self bgCircleAnimation:zongheBgImageView];
        }
        zongheSmallRateLabel.text = [NSString stringWithFormat:@"%@", [zongheData objectForKey:@"interestRate"]];
        zongheTradingLabel.text = [NSString stringWithFormat:@"年化%@%%收益\n每日派息",[zongheData objectForKey:@"interestRate"]];
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式
        NSDate *startDate = [dateFormat dateFromString:[zongheData objectForKey:@"startRaisingDateTime"]];
        NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:startDate];
        
        long year = [components year];
        long month = [components month];
        long day = [components day];
        
        zongheStartBuyTimeLabel.text = [NSString stringWithFormat:@"%4ld-%02ld-%02ld",year,month,day];
        
        [dateFormat setDateFormat:@"yyyy年MM月dd日"];//设定时间格式
        NSDate *beginDate = [dateFormat dateFromString:[zongheData objectForKey:@"beginDate"]];
        components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:beginDate];
        year = [components year];
        month = [components month];
        day = [components day];
        zongheStartTradeTimeLabel.text = [NSString stringWithFormat:@"%4ld-%02ld-%02ld",year,month,day];
        [zongheData setValue:[NSString stringWithFormat:@"%4ld-%02ld-%02ld 09:00:00",year,month,day] forKey:@"beginDateTime"];
        
        NSDate *endDate = [dateFormat dateFromString:[zongheData objectForKey:@"endDate"]];
        components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:endDate];
        year = [components year];
        month = [components month];
        day = [components day];
        zongheEndTimeLabel.text = [NSString stringWithFormat:@"%4ld-%02ld-%02ld",year,month,day];
        [zongheData setValue:[NSString stringWithFormat:@"%4ld-%02ld-%02ld 15:30:00",year,month,day] forKey:@"endDateTime"];
        
        [self zongheTimeCountDown];
        zongheTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(zongheTimeCountDown) userInfo:nil repeats:YES];
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"当前网络状况不佳，请重试";
        [hud hide:YES afterDelay:1.5f];
        if ([mainScrollView.mj_header isRefreshing])
        {
            [mainScrollView.mj_header endRefreshing];
        }
    }];

}

- (void)setupHuoqi
{
    [huoqiBuyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    [huoqiBuyButton setUserInteractionEnabled:NO];
    [huoqiBuyButton setAlpha:0.6f];
    huoqiBuyButton.backgroundColor = ZTRED;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:@"api/stat/ztbDesc4M"];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        huoqiData = [NSMutableDictionary dictionaryWithDictionary:responseObject];
        NSString *numStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"interestRate"]];
        if ([numStr rangeOfString:@"."].location != NSNotFound)
        {
            huoqiRateLabel.font = [UIFont fontWithName:@"EuphemiaUCAS-Bold" size:59.0f];
            huoqiRateLabel.text = numStr;
        }
        else
        {
            huoqiRateLabel.font = [UIFont fontWithName:@"EuphemiaUCAS-Bold" size:65.0f];
            huoqiRateLabel.text = numStr;
        }
        if ([mainScrollView.mj_header isRefreshing])
        {
            [mainScrollView.mj_header endRefreshing];
        }
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
        [formatter setPositiveFormat:@"###,##0"];
        huoqiAmountLabel.text = [NSString stringWithFormat:@"剩余可认购份额：%@万元",[formatter stringFromNumber:[NSNumber numberWithDouble:[NSString stringWithFormat:@"%@",[huoqiData objectForKey:@"bidableAmount"]].intValue/10000]]];
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
            [huoqiBuyButton setTitle:@"已售罄" forState:UIControlStateNormal];
        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"当前网络状况不佳，请重试";
        [hud hide:YES afterDelay:1.5f];
        if ([mainScrollView.mj_header isRefreshing])
        {
            [mainScrollView.mj_header endRefreshing];
        }

    }];
    
    
}

- (void)buyNow:(id)sender
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
        vc.style = style;
        vc.isFromNewer = false;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
        [formatter setPositiveFormat:@"###,##0.00"];
        if ([style isEqualToString:WENJIAN])
        {
            vc.productInfo = wenjianData;
            vc.idOrCode = [wenjianData objectForKey:@"id"];
            vc.bidableAmount = [wenjianData objectForKey:@"bidableAmount"];
            vc.productName = [wenjianData objectForKey:@"name"];
        }
        else if ([style isEqualToString:ZONGHE])
        {
            vc.productInfo = zongheData;
            vc.idOrCode = [zongheData objectForKey:@"id"];
            vc.bidableAmount = [zongheData objectForKey:@"bidableAmount"];
            vc.productName = [zongheData objectForKey:@"name"];
        }
        else
        {
            flag = true;
            vc.productInfo = huoqiData;
            vc.bidableAmount = [huoqiData objectForKey:@"bidableAmount"];
        }
        [[self navigationController]pushViewController:vc animated:YES];
    }
}


- (void)wenjianTimeCountDown
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式
    NSDate *startDate = [dateFormat dateFromString:[wenjianData objectForKey:@"startRaisingDateTime"]];
    NSDate *beginDate = [dateFormat dateFromString:[wenjianData objectForKey:@"beginDateTime"]];
    NSDate *endDate = [dateFormat dateFromString:[wenjianData objectForKey:@"endDateTime"]];
    NSDate *date = [NSDate date];
    if ([startDate timeIntervalSinceDate:date] > 0.0)
    {
        startBuyLabel.textColor = ZTLIGHTGRAY;
        startBuyLine.backgroundColor = ZTLIGHTGRAY;
        startBuyPointImageView.image = [UIImage imageNamed:@"GrayTimePoint.png"];
        startBuyTimeLabel.textColor = ZTLIGHTGRAY;
        buyingLabel.textColor = ZTLIGHTGRAY;
        [wenjianProgressView setProgress:0];
    }
    else
    {
        startBuyLabel.textColor = ZTLIGHTRED;
        startBuyLine.backgroundColor = ZTLIGHTRED;
        startBuyPointImageView.image = [UIImage imageNamed:@"StableTimePoint.png"];
        startBuyTimeLabel.textColor = ZTLIGHTRED;
        buyingLabel.textColor = ZTLIGHTRED;
        [wenjianProgressView setProgress:0.3];
        
        if ([date timeIntervalSinceDate:beginDate] > 0.0)
        {
            startTradeTimeLabel.textColor = ZTLIGHTRED;
            startTradeLine.backgroundColor = ZTLIGHTRED;
            startTradeLabel.textColor = ZTLIGHTRED;
            startTradePointImageView.image = [UIImage imageNamed:@"StableTimePoint.png"];
            tradingLabel.textColor = ZTLIGHTRED;
            [wenjianProgressView setProgress:0.6];
            
            if ([date timeIntervalSinceDate:endDate] > 0.0)
            {
                endLabel.textColor = ZTLIGHTRED;
                endLine.backgroundColor = ZTLIGHTRED;
                endTimeLabel.textColor = ZTLIGHTRED;
                endPointImageView.image = [UIImage imageNamed:@"StableTimePoint.png"];;
                [wenjianProgressView setProgress:1.0];
            }
        }
        
        if ([NSString stringWithFormat:@"%@",[wenjianData objectForKey:@"bidableAmount"]].intValue == 0)
        {
            [wenjianBuyButton setUserInteractionEnabled:NO];
            [wenjianBuyButton setAlpha:1.0f];
            wenjianBuyButton.backgroundColor = ZTGRAY;
            [wenjianBuyButton setTitle:@"已售罄" forState:UIControlStateNormal];
        }
        else
        {
            [wenjianBuyButton setUserInteractionEnabled:YES];
            wenjianBuyButton.backgroundColor = ZTLIGHTRED;
            [wenjianBuyButton setAlpha:1.0f];
        }

    }
}

- (void)zongheTimeCountDown
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式
    NSDate *startDate = [dateFormat dateFromString:[zongheData objectForKey:@"startRaisingDateTime"]];
    NSDate *beginDate = [dateFormat dateFromString:[zongheData objectForKey:@"beginDateTime"]];
    NSDate *endDate = [dateFormat dateFromString:[zongheData objectForKey:@"endDateTime"]];
    NSDate *date = [NSDate date];
    if ([startDate timeIntervalSinceDate:date] > 0.0)
    {
        zongheStartBuyLabel.textColor = ZTLIGHTGRAY;
        zongheStartBuyLine.backgroundColor = ZTLIGHTGRAY;
        zongheStartBuyPoint.image = [UIImage imageNamed:@"GrayTimePoint.png"];
        zongheStartBuyTimeLabel.textColor = ZTLIGHTGRAY;
        zongheBuyingLabel.textColor = ZTLIGHTGRAY;
        [zongheProgressView setProgress:0];
    }
    else
    {
        zongheStartBuyLabel.textColor = ZTBLUE;
        zongheStartBuyLine.backgroundColor = ZTBLUE;
        zongheStartBuyPoint.image = [UIImage imageNamed:@"FloatTimePoint.png"];
        zongheStartBuyTimeLabel.textColor = ZTBLUE;
        zongheBuyingLabel.textColor = ZTBLUE;
        [zongheProgressView setProgress:0.3];
        
        if ([date timeIntervalSinceDate:beginDate] > 0.0)
        {
            zongheStartTradeTimeLabel.textColor = ZTBLUE;
            zongheStartTradeLine.backgroundColor = ZTBLUE;
            zongheStartTradeLabel.textColor = ZTBLUE;
            zongheStartTradePoint.image = [UIImage imageNamed:@"FloatTimePoint.png"];
            zongheTradingLabel.textColor = ZTBLUE;
            [zongheProgressView setProgress:0.6];
            
            if ([date timeIntervalSinceDate:endDate] > 0.0)
            {
                zongheEndedLabel.textColor = ZTBLUE;
                zongheEndLabel.textColor = ZTBLUE;
                zongheEndLine.backgroundColor = ZTBLUE;
                zongheEndTimeLabel.textColor = ZTBLUE;
                zongheEndPoint.image = [UIImage imageNamed:@"FloatTimePoint.png"];
                [zongheProgressView setProgress:1.0];
            }
        }
        
        if ([NSString stringWithFormat:@"%@",[zongheData objectForKey:@"bidableAmount"]].intValue == 0)
        {
            [zongheBuyButton setUserInteractionEnabled:NO];
            [zongheBuyButton setAlpha:1.0f];
            zongheBuyButton.backgroundColor = ZTGRAY;
            [zongheBuyButton setTitle:@"已售罄" forState:UIControlStateNormal];
        }
        else
        {
            [zongheBuyButton setUserInteractionEnabled:YES];
            zongheBuyButton.backgroundColor = ZTBLUE;
            [zongheBuyButton setAlpha:1.0f];
        }
    }
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
                wenjianTimeView.hidden = NO;
                zongheBuyButton.hidden = YES;
                zongheTimeView.hidden = YES;
                huoqiBuyButton.hidden = YES;
                huoqiAmountLabel.hidden = YES;
                huoqiDescriptionLabel.hidden = YES;
            }
        }
        else if (scrView.contentOffset.x == screenWidth)
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
                wenjianTimeView.hidden = YES;
                zongheTimeView.hidden = NO;
                zongheBuyButton.hidden = NO;
                huoqiBuyButton.hidden = YES;
                huoqiAmountLabel.hidden = YES;
                huoqiDescriptionLabel.hidden = YES;
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
                wenjianTimeView.hidden = YES;
                zongheBuyButton.hidden = YES;
                zongheTimeView.hidden = YES;
                huoqiBuyButton.hidden = NO;
                huoqiAmountLabel.hidden = NO;
                huoqiDescriptionLabel.hidden = NO;
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
        if (scrView.contentOffset.x == 0)
        {
            if (![style isEqualToString:WENJIAN])
            {
                style = WENJIAN;
                [self bgCircleAnimation:wenjianBgImageView];
                [huoqiBgImageView1 setFrame:frame];
                [huoqiBgImageView2 setFrame:frame];
                wenjianBuyButton.hidden = NO;
                wenjianTimeView.hidden = NO;
                zongheBuyButton.hidden = YES;
                zongheTimeView.hidden = YES;
                huoqiBuyButton.hidden = YES;
                huoqiAmountLabel.hidden = YES;
                huoqiDescriptionLabel.hidden = YES;
            }
        }
        else if (scrView.contentOffset.x == screenWidth)
        {
            if (![style isEqualToString:ZONGHE])
            {
                style = ZONGHE;
                [self bgCircleAnimation:zongheBgImageView];
                [huoqiBgImageView1 setFrame:frame];
                [huoqiBgImageView2 setFrame:frame];
                wenjianBuyButton.hidden = YES;
                wenjianTimeView.hidden = YES;
                zongheTimeView.hidden = NO;
                zongheBuyButton.hidden = NO;
                huoqiBuyButton.hidden = YES;
                huoqiAmountLabel.hidden = YES;
                huoqiDescriptionLabel.hidden = YES;
            }
        }
        else
        {
            if (![style isEqualToString:HUOQI])
            {
                style = HUOQI;
                wenjianBuyButton.hidden = YES;
                wenjianTimeView.hidden = YES;
                zongheBuyButton.hidden = YES;
                zongheTimeView.hidden = YES;
                huoqiBuyButton.hidden = NO;
                huoqiAmountLabel.hidden = NO;
                huoqiDescriptionLabel.hidden = NO;
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
                NSString *afterOpen = [app.userInfo objectForKey:@"after_open"];
                if ([afterOpen isEqualToString:@"go_activity"])
                {
                    NSString *activity = [app.userInfo objectForKey:@"activity"];
                    if ([activity isEqualToString:@"endedDq"])
                    {
                        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                        DingqiViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"DingqiViewController"];
                        vc.buttonTag = 1;
                        [[self navigationController]pushViewController:vc animated:YES];
                    }
                    else
                    {
                        if ([activity isEqualToString:@"fhb"])
                        {
                            [self clickZongheButton:zongheButton];
                        }
                        else
                        {
                            [self clickWenjianButton:wenjianButton];
                        }
                    }

                }
            }
            else if ([afterOpen isEqualToString:@"go_url"])
            {
                NSLog(@"fsfsfsfsfsfsfs");
                NSString *url = [app.userInfo objectForKey:@"url"];
                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                WebDetailViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"WebDetailViewController"];
                [vc setURL:url];
                vc.title = @"专投公告";
                [[self navigationController]pushViewController:vc animated:YES];
            }
        }
    }
}

-(BOOL)isCurrentViewControllerVisible:(UIViewController *)viewController
{
    return (viewController.isViewLoaded && viewController.view.window);
}

@end
