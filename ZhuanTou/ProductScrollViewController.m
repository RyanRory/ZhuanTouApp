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
@synthesize wenjianView, wenjianBgImageView, wenjianDetailButton, wenjianMonthLabel, wenjianMOYLabel, wenjianRateLabel, wenjianViewWidth, wenjianBuyButton, wenjianLabel;
@synthesize zongheView, zongheBgImageView, zongheBigRateLabel, zongheDetailButton, zongheMonthLabel, zongheMOYLabel, zongheSmallRateLabel, zongheViewWidth, productsBeforeButton, zongheBuyButton, zongheLabel;
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
    
    wenjianBuyButton.hidden = YES;
    wenjianLabel.hidden = YES;
    
    huoqiBuyButton.hidden = YES;
    huoqiAmountLabel.hidden = YES;
    huoqiDescriptionLabel.hidden = YES;

    
    [zongheButton setUserInteractionEnabled:NO];
    wenjianButton.tintColor = ZTGRAY;
    zongheButton.tintColor = ZTBLUE;
    huoqiButton.tintColor = ZTGRAY;
    
    style = ZONGHE;
    [scrollView setContentOffset:CGPointMake(screenWidth, 0) animated:NO];
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
    [scrollView setContentOffset:CGPointMake(screenWidth, 0) animated:YES];
}

- (void)clickHuoqi:(id)sender
{
    [scrollView setContentOffset:CGPointMake(screenWidth * 2, 0) animated:YES];
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
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式
        NSDate *startDate = [dateFormat dateFromString:[wenjianData objectForKey:@"startRaisingDateTime"]];
        if ([NSString stringWithFormat:@"%@",[wenjianData objectForKey:@"bidableAmount"]].intValue == 0)
        {
            NSDateFormatter* nextDateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
            [nextDateFormat setDateFormat:@"yyyy年MM月dd日 HH:mm"];//设定时间格式
            NSTimeInterval days = 7*24*60*60;
            NSString *nextDateStr = [nextDateFormat stringFromDate:[startDate dateByAddingTimeInterval:days]];
            wenjianLabel.text = [NSString stringWithFormat:@"下一期：%@ 准时上线",nextDateStr];
            
            [wenjianBuyButton setUserInteractionEnabled:NO];
            [wenjianBuyButton setAlpha:1.0f];
            wenjianBuyButton.backgroundColor = ZTGRAY;
            [wenjianBuyButton setTitle:@"已售罄" forState:UIControlStateNormal];
        }
        else
        {
            NSDate *date = [NSDate date];
            if ([date timeIntervalSinceDate:startDate] < 0.0)
            {
                [self wenjianTimeCountDown];
                wenjianTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(wenjianTimeCountDown) userInfo:nil repeats:YES];
                
                [wenjianBuyButton setUserInteractionEnabled:NO];
                wenjianBuyButton.backgroundColor = ZTLIGHTRED;
                [wenjianBuyButton setAlpha:0.6f];
            }
            else
            {
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
                [formatter setPositiveFormat:@"###,##0"];
                wenjianLabel.text = [NSString stringWithFormat:@"可认购份额：%@元",[formatter stringFromNumber:[NSNumber numberWithInt:[NSString stringWithFormat:@"%@",[wenjianData objectForKey:@"bidableAmount"]].intValue]]];
                
                [wenjianBuyButton setUserInteractionEnabled:YES];
                wenjianBuyButton.backgroundColor = ZTLIGHTRED;
                [wenjianBuyButton setAlpha:1.0f];
            }
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
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式
        NSDate *startDate = [dateFormat dateFromString:[zongheData objectForKey:@"startRaisingDateTime"]];
        if ([NSString stringWithFormat:@"%@",[zongheData objectForKey:@"bidableAmount"]].intValue == 0)
        {
            NSDateFormatter* nextDateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
            [nextDateFormat setDateFormat:@"yyyy年MM月dd日 HH:mm"];//设定时间格式
            NSTimeInterval days = 7*24*60*60;
            NSString *nextDateStr = [nextDateFormat stringFromDate:[startDate dateByAddingTimeInterval:days]];
            zongheLabel.text = [NSString stringWithFormat:@"下一期：%@ 准时上线",nextDateStr];
            
            [zongheBuyButton setUserInteractionEnabled:NO];
            [zongheBuyButton setAlpha:1.0f];
            zongheBuyButton.backgroundColor = ZTGRAY;
            [zongheBuyButton setTitle:@"已售罄" forState:UIControlStateNormal];
        }
        else
        {
            NSDate *date = [NSDate date];
            if ([date timeIntervalSinceDate:startDate] < 0.0)
            {
                [self zongheTimeCountDown];
                zongheTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(zongheTimeCountDown) userInfo:nil repeats:YES];
                
                [zongheBuyButton setUserInteractionEnabled:NO];
                zongheBuyButton.backgroundColor = ZTBLUE;
                [zongheBuyButton setAlpha:0.6f];
            }
            else
            {
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
                [formatter setPositiveFormat:@"###,##0"];
                zongheLabel.text = [NSString stringWithFormat:@"可认购份额：%@元",[formatter stringFromNumber:[NSNumber numberWithInt:[NSString stringWithFormat:@"%@",[zongheData objectForKey:@"bidableAmount"]].intValue]]];
                
                [zongheBuyButton setUserInteractionEnabled:YES];
                zongheBuyButton.backgroundColor = ZTBLUE;
                [zongheBuyButton setAlpha:1.0f];
            }
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
            huoqiRateLabel.font = [UIFont fontWithName:@"EuphemiaUCAS-Bold" size:59.0f];
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
        [formatter setPositiveFormat:@"###,##0.00"];
        huoqiAmountLabel.text = [NSString stringWithFormat:@"可认购份额：%@元",[formatter stringFromNumber:[NSNumber numberWithDouble:[NSString stringWithFormat:@"%@",[huoqiData objectForKey:@"bidableAmount"]].doubleValue]]];
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
}


- (void)wenjianTimeCountDown
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式
    NSDate *startDate = [dateFormat dateFromString:[wenjianData objectForKey:@"startRaisingDateTime"]];
    NSDate *date = [NSDate date];
    if ([startDate timeIntervalSinceDate:date] > 0.0)
    {
        int days = (int)[startDate timeIntervalSinceDate:date]/(24*60*60);
        int hours = ((int)[startDate timeIntervalSinceDate:date] - days*24*60*60)/(60*60);
        int minutes = ((int)[startDate timeIntervalSinceDate:date] - hours*60*60)/60 + 1;
        wenjianLabel.text = [NSString stringWithFormat:@"开售倒计时：%02d天%02d时%02d分",days,hours,minutes];
    }
    else
    {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
        [formatter setPositiveFormat:@"###,##0"];
        wenjianLabel.text = [NSString stringWithFormat:@"可认购份额：%@元",[formatter stringFromNumber:[NSNumber numberWithInt:[NSString stringWithFormat:@"%@",[wenjianData objectForKey:@"bidableAmount"]].intValue]]];
        wenjianLabel.text = @"";
        
        [wenjianBuyButton setUserInteractionEnabled:YES];
        wenjianBuyButton.backgroundColor = ZTLIGHTRED;
        [wenjianBuyButton setAlpha:1.0f];
    }
}

- (void)zongheTimeCountDown
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式
    NSDate *startDate = [dateFormat dateFromString:[zongheData objectForKey:@"startRaisingDateTime"]];
    NSDate *date = [NSDate date];
    if ([startDate timeIntervalSinceDate:date] > 0.0)
    {
        int days = (int)[startDate timeIntervalSinceDate:date]/(24*60*60);
        int hours = ((int)[startDate timeIntervalSinceDate:date] - days*24*60*60)/(60*60);
        int minutes = ((int)[startDate timeIntervalSinceDate:date] - hours*60*60)/60 + 1;
        zongheLabel.text = [NSString stringWithFormat:@"开售倒计时：%02d天%02d时%02d分",days,hours,minutes];
    }
    else
    {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
        [formatter setPositiveFormat:@"###,##0"];
        zongheLabel.text = [NSString stringWithFormat:@"可认购份额：%@元",[formatter stringFromNumber:[NSNumber numberWithInt:[NSString stringWithFormat:@"%@",[zongheData objectForKey:@"bidableAmount"]].intValue]]];
        
        [zongheBuyButton setUserInteractionEnabled:YES];
        zongheBuyButton.backgroundColor = ZTBLUE;
        [zongheBuyButton setAlpha:1.0f];
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
                wenjianLabel.hidden = NO;
                zongheBuyButton.hidden = YES;
                zongheLabel.hidden = YES;
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
                wenjianLabel.hidden = YES;
                zongheLabel.hidden = NO;
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
                wenjianLabel.hidden = YES;
                zongheBuyButton.hidden = YES;
                zongheLabel.hidden = YES;
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
                wenjianLabel.hidden = NO;
                zongheBuyButton.hidden = YES;
                zongheLabel.hidden = YES;
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
                wenjianLabel.hidden = YES;
                zongheLabel.hidden = NO;
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
                wenjianLabel.hidden = YES;
                zongheBuyButton.hidden = YES;
                zongheLabel.hidden = YES;
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

@end
