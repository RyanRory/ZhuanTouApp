//
//  HuoqiViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/18.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "HuoqiViewController.h"

@interface HuoqiViewController ()

@end

@implementation HuoqiViewController

@synthesize yesterdayProfitLabel, myPortionLabel, totalProfitLabel, buyButton, drawButton, profitPercentLabel;
@synthesize lineChartView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
    backItem.tintColor = ZTBLUE;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
    
    buyButton.layer.cornerRadius = 3;
    drawButton.layer.cornerRadius = 3;
    
    yesterdayProfitLabel.format = @"%.2f";
    
    [buyButton addTarget:self action:@selector(toBuyHuoqi:) forControlEvents:UIControlEventTouchUpInside];
    [drawButton addTarget:self action:@selector(toDrawHuoqi:) forControlEvents:UIControlEventTouchUpInside];
    
    lineChartView.delegate = self;
    lineChartView.descriptionText = @"";
    
    lineChartView.dragEnabled = NO;
    [lineChartView setUserInteractionEnabled:NO];
    [lineChartView setScaleEnabled:NO];
    lineChartView.drawGridBackgroundEnabled = NO;
    lineChartView.pinchZoomEnabled = YES;
    
    lineChartView.backgroundColor = [UIColor clearColor];
    
    lineChartView.legend.enabled = NO;

    ChartXAxis *xAxis = lineChartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.labelFont = [UIFont systemFontOfSize:10.f];
    xAxis.labelTextColor = ZTCHARTSGRAY;
    xAxis.gridColor = ZTCHARTSGRAY;
    xAxis.drawGridLinesEnabled = YES;
    xAxis.spaceBetweenLabels = 0.0;
    xAxis.axisLineColor = ZTCHARTSGRAY;
    
    ChartYAxis *leftAxis = lineChartView.leftAxis;
    leftAxis.labelTextColor = ZTCHARTSGRAY;
    leftAxis.customAxisMax = 8.00;
    leftAxis.customAxisMin = 4.00;
    leftAxis.startAtZeroEnabled = NO;
    leftAxis.gridColor = ZTCHARTSGRAY;
    leftAxis.drawLimitLinesBehindDataEnabled = YES;
    leftAxis.labelPosition = YAxisLabelPositionInsideChart;
    leftAxis.axisLineColor = ZTCHARTSGRAY;
    
    lineChartView.rightAxis.enabled = NO;
    lineChartView.noDataText = @"";
    
    
    [self setupData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backToParent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:@"api/account/yesterdayZtb"];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        [yesterdayProfitLabel countFromZeroTo:((NSString*)[responseObject objectForKey:@"interestAmount"]).floatValue withDuration:0.8f];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
        [formatter setPositiveFormat:@"###,##0.00"];
        myPortionLabel.text = [NSString stringWithString:[formatter stringFromNumber:[NSNumber numberWithDouble:((NSString*)[responseObject objectForKey:@"ztbBalance"]).doubleValue]]];
        totalProfitLabel.text = [NSString stringWithString:[formatter stringFromNumber:[NSNumber numberWithDouble:((NSString*)[responseObject objectForKey:@"sumReturnAmount"]).doubleValue]]];
        profitPercentLabel.text = [NSString stringWithFormat:@"%@%%",[responseObject objectForKey:@"last5DaysReturn"]];
        datas = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"last7DaysCurv"]];
        [self setDataCount:7 range:8.00];
        [lineChartView animateWithXAxisDuration:0.8];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"当前网络状况不佳，请重试";
        [hud hide:YES afterDelay:1.5f];
    }];
}

- (void)setDataCount:(int)count range:(double)range
{
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        [xVals addObject:(NSString*)[datas[i] objectForKey:@"date"]];
    }
    
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        [yVals addObject:[[ChartDataEntry alloc] initWithValue:((NSString*)[datas[i] objectForKey:@"date"]).doubleValue xIndex:i]];
    }
    
    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithYVals:yVals label:@"DataSet 1"];
    set1.axisDependency = AxisDependencyLeft;
    [set1 setColor:ZTRED];
    [set1 setCircleColor:ZTRED];
    set1.lineWidth = 3.0;
    set1.circleRadius = 1.5;
    set1.fillAlpha = 1.0f;
    set1.fillColor = ZTRED;
    set1.drawCircleHoleEnabled = NO;
    set1.drawValuesEnabled = NO;
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    LineChartData *data = [[LineChartData alloc] initWithXVals:xVals dataSets:dataSets];
    [data setValueTextColor:UIColor.whiteColor];
    [data setValueFont:[UIFont systemFontOfSize:9.f]];

    
    lineChartView.data = data;
}

- (void)toBuyHuoqi:(id)sender
{
    ProductBuyViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"ProductBuyViewController"];
    vc.style = HUOQI;
    [[self navigationController]pushViewController:vc animated:YES];
}

- (void)toDrawHuoqi:(id)sender
{
    DrawZtbViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"DrawZtbViewController"];
    vc.balance = myPortionLabel.text;
    [[self navigationController]pushViewController:vc animated:YES];
}

@end
