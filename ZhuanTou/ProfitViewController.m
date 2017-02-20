//
//  ProfitViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/20.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "ProfitViewController.h"

@interface ProfitViewController ()

@end

@implementation ProfitViewController

@synthesize fenhongPercentLabel, wenyingPercentLabel, huoqiPercentLabel, balancePercentLabel, frozenPercentLabel;
@synthesize fenhongNumLabel, wenyingNumLabel, huoqiNumLabel, balanceNumLabel, frozenNumLabel;
@synthesize contentView, pieChartView, totalNumLabel;
@synthesize scrollView, viewHeight;
@synthesize chargeButton, drawButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
    backItem.tintColor = ZTBLUE;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
    
    contentView.layer.cornerRadius = 3;
    
    pieChartView.delegate = self;
    
    pieChartView.usePercentValuesEnabled = YES;
//    pieChartView.holeTransparent = YES;
//    pieChartView.centertTextFont = [UIFont systemFontOfSize:14];
    pieChartView.holeRadiusPercent = 0.65;
    pieChartView.transparentCircleRadiusPercent = 0.65;
    pieChartView.descriptionText = @"";
    pieChartView.drawCenterTextEnabled = NO;
    pieChartView.drawHoleEnabled = YES;
    pieChartView.rotationAngle = 0.0;
    pieChartView.rotationEnabled = YES;
    pieChartView.legend.enabled = NO;
    [pieChartView setUserInteractionEnabled:NO];
    pieChartView.noDataText = @"";
    pieChartView.holeColor = [UIColor clearColor];
    
    [self setupData];
    
    scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self setupData];
    }];
    
    [drawButton.layer setBorderColor:ZTBLUE.CGColor];
    [drawButton.layer setBorderWidth:1.0f];
    [chargeButton addTarget:self action:@selector(toCharge:) forControlEvents:UIControlEventTouchUpInside];
    [drawButton addTarget:self action:@selector(toDraw:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    viewHeight.constant = CGRectGetHeight(self.view.frame);
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.navigationController.navigationBarHidden)
    {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)becomeForeground
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [scrollView.mj_header beginRefreshing];
    });
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backToParent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)setupData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:@"api/account/getUserInfoInAPP"];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        NSString *str = [responseObject objectForKey:@"isSuccess"];
        int f1 = str.intValue;
        if (f1 == 1)
        {
            fenhong = ((NSString*)[responseObject objectForKey:@"activeFenhongAmount"]).doubleValue;
            wenying = ((NSString*)[responseObject objectForKey:@"activeWenyingAmount"]).doubleValue;
            huoqi = ((NSString*)[responseObject objectForKey:@"ztbBalance"]).doubleValue;
            balance = ((NSString*)[responseObject objectForKey:@"fundsAvailable"]).doubleValue;
            frozen = ((NSString*)[responseObject objectForKey:@"frozenAmount"]).doubleValue;
            total = ((NSString*)[responseObject objectForKey:@"totalAsset"]).doubleValue;
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
            [formatter setPositiveFormat:@"###,##0.00元"];
            fenhongNumLabel.text = [NSString stringWithString:[formatter stringFromNumber:[NSNumber numberWithDouble:fenhong]]];
            wenyingNumLabel.text = [NSString stringWithString:[formatter stringFromNumber:[NSNumber numberWithDouble:wenying]]];
            huoqiNumLabel.text = [NSString stringWithString:[formatter stringFromNumber:[NSNumber numberWithDouble:huoqi]]];
            balanceNumLabel.text = [NSString stringWithString:[formatter stringFromNumber:[NSNumber numberWithDouble:balance]]];
            totalNumLabel.text = [NSString stringWithString:[formatter stringFromNumber:[NSNumber numberWithDouble:total]]];
            frozenNumLabel.text = [NSString stringWithString:[formatter stringFromNumber:[NSNumber numberWithDouble:frozen]]];
            
            if (total == 0)
            {
                fenhongPercentLabel.text = @"0.00%";
                wenyingPercentLabel.text = @"0.00%";
                huoqiPercentLabel.text = @"0.00%";
                balancePercentLabel.text = @"0.00%";
                frozenPercentLabel.text = @"0.00%";
            }
            else
            {
                fenhongPercentLabel.text = [NSString stringWithFormat:@"%0.2f%%",fenhong*100/total];
                wenyingPercentLabel.text = [NSString stringWithFormat:@"%0.2f%%",wenying*100/total];
                huoqiPercentLabel.text = [NSString stringWithFormat:@"%0.2f%%",huoqi*100/total];
                balancePercentLabel.text = [NSString stringWithFormat:@"%0.2f%%",balance*100/total];
                frozenPercentLabel.text = [NSString stringWithFormat:@"%0.2f%%",frozen*100/total];
            }
            
            [self setDataCount:5 range:100];
            [pieChartView animateWithXAxisDuration:1.5 yAxisDuration:1.5 easingOption:ChartEasingOptionEaseOutBack];
        }
        else
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            [hud hide:YES afterDelay:1.5f];
            if ([[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"errorCode"]] isEqualToString:@"100003"])
            {
                hud.labelText = @"登录信息已过期，请重新登录";
                SetpasswordViewController *setpass = [[self storyboard]instantiateViewControllerWithIdentifier:@"SetpasswordViewController"];
                setpass.string = @"验证密码";
                [[self tabBarController] presentViewController:setpass animated:NO completion:nil];
            }
            else
            {
                hud.labelText = [responseObject objectForKey:@"errorMessage"];
            }
        }
        if ([scrollView.mj_header isRefreshing])
        {
            [scrollView.mj_header endRefreshing];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"当前网络状况不佳，请重试";
        [hud hide:YES afterDelay:1.5f];
        if ([scrollView.mj_header isRefreshing])
        {
            [scrollView.mj_header endRefreshing];
        }
    }];
}

- (void)toCharge:(id)sender
{
    ChargeViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"ChargeViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)toDraw:(id)sender
{
    DrawViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"DrawViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setDataCount:(int)count range:(double)range
{
    
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    
    // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
    [yVals1 addObject:[[BarChartDataEntry alloc] initWithValue:fenhong/total xIndex:0]];
    [yVals1 addObject:[[BarChartDataEntry alloc] initWithValue:wenying/total xIndex:1]];
    [yVals1 addObject:[[BarChartDataEntry alloc] initWithValue:huoqi/total xIndex:2]];
    [yVals1 addObject:[[BarChartDataEntry alloc] initWithValue:balance/total xIndex:3]];
    [yVals1 addObject:[[BarChartDataEntry alloc] initWithValue:frozen/total xIndex:4]];
    
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        [xVals addObject:[NSNumber numberWithInt:i]];
    }
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithYVals:yVals1 label:@"Election Results"];
    dataSet.sliceSpace = 3.0;
    dataSet.drawValuesEnabled = NO;
    
    // add a lot of colors
    
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    
    [colors addObject:ZTPIECHARTBLUE];
    [colors addObject:ZTPIECHARTORANGE];
    [colors addObject:ZTPIECHARTRED];
    [colors addObject:ZTPIECHARTPURPLE];
    [colors addObject:ZTPIECHARTGRAY];
    
    dataSet.colors = colors;
    
    PieChartData *data = [[PieChartData alloc] initWithXVals:xVals dataSet:dataSet];
    
    pieChartView.data = data;
    [pieChartView highlightValues:nil];
}


@end
