//
//  AllIncomeViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 16/1/11.
//  Copyright © 2016年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "AllIncomeViewController.h"

@interface AllIncomeViewController ()

@end

@implementation AllIncomeViewController

@synthesize pieChartView, viewHeight;
@synthesize contentView, scrollView;
@synthesize totalNumLabel, fhbPercentLabel, fhbNumLabel, wybPercentLabel, wybNumLabel, ztbNumLabel, ztbPercentLabel, otherNumLabel, otherPercentLabel;

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
    pieChartView.holeTransparent = YES;
    pieChartView.centerTextFont = [UIFont systemFontOfSize:14];
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
    NSString *URL = [BASEURL stringByAppendingString:@"api/account/cumpldist"];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);

        fhb = ((NSString*)[responseObject objectForKey:@"fenhongBao"]).doubleValue;
        wyb = ((NSString*)[responseObject objectForKey:@"wenyingBao"]).doubleValue;
        ztb = ((NSString*)[responseObject objectForKey:@"zhuantouBao"]).doubleValue;
        other = ((NSString*)[responseObject objectForKey:@"others"]).doubleValue;
        total = ((NSString*)[responseObject objectForKey:@"totalReturnAmount"]).doubleValue;
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
        [formatter setPositiveFormat:@"###,##0.00元"];
        fhbNumLabel.text = [NSString stringWithString:[formatter stringFromNumber:[NSNumber numberWithDouble:fhb]]];
        wybNumLabel.text = [NSString stringWithString:[formatter stringFromNumber:[NSNumber numberWithDouble:wyb]]];
        ztbNumLabel.text = [NSString stringWithString:[formatter stringFromNumber:[NSNumber numberWithDouble:ztb]]];
        totalNumLabel.text = [NSString stringWithString:[formatter stringFromNumber:[NSNumber numberWithDouble:total]]];
        otherNumLabel.text = [NSString stringWithString:[formatter stringFromNumber:[NSNumber numberWithDouble:other]]];
        
        if (total == 0)
        {
            fhbPercentLabel.text = @"0.00%";
            wybPercentLabel.text = @"0.00%";
            ztbPercentLabel.text = @"0.00%";
            otherPercentLabel.text = @"0.00%";
        }
        else
        {
            fhbPercentLabel.text = [NSString stringWithFormat:@"%0.2f%%",fhb*100/total];
            wybPercentLabel.text = [NSString stringWithFormat:@"%0.2f%%",wyb*100/total];
            ztbPercentLabel.text = [NSString stringWithFormat:@"%0.2f%%",ztb*100/total];
            otherPercentLabel.text = [NSString stringWithFormat:@"%0.2f%%",other*100/total];
        }
        
        [self setDataCount:4 range:100];
        [pieChartView animateWithXAxisDuration:1.5 yAxisDuration:1.5 easingOption:ChartEasingOptionEaseOutBack];
        
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

- (void)setDataCount:(int)count range:(double)range
{
    
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    
    // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
    [yVals1 addObject:[[BarChartDataEntry alloc] initWithValue:fhb/total xIndex:0]];
    [yVals1 addObject:[[BarChartDataEntry alloc] initWithValue:wyb/total xIndex:1]];
    [yVals1 addObject:[[BarChartDataEntry alloc] initWithValue:ztb/total xIndex:2]];
    [yVals1 addObject:[[BarChartDataEntry alloc] initWithValue:other/total xIndex:3]];
    
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
    [colors addObject:ZTPIECHARTYELLOW];
    [colors addObject:ZTPIECHARTRED];
    [colors addObject:ZTPIECHARTPURPLE];
    
    dataSet.colors = colors;
    
    PieChartData *data = [[PieChartData alloc] initWithXVals:xVals dataSet:dataSet];
    
    pieChartView.data = data;
    [pieChartView highlightValues:nil];
}

@end
