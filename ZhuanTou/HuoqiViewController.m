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
    leftAxis.customAxisMax = 10.00;
    leftAxis.customAxisMin = 0.00;
    leftAxis.startAtZeroEnabled = NO;
    leftAxis.gridColor = ZTCHARTSGRAY;
    leftAxis.drawLimitLinesBehindDataEnabled = YES;
    leftAxis.labelPosition = YAxisLabelPositionInsideChart;
    leftAxis.axisLineColor = ZTCHARTSGRAY;
    
    lineChartView.rightAxis.enabled = NO;
    
    
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
    [yesterdayProfitLabel countFromZeroTo:5.00 withDuration:0.8f];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    [formatter setPositiveFormat:@"###,##0.00"];
    myPortionLabel.text = [NSString stringWithString:[formatter stringFromNumber:[NSNumber numberWithDouble:1111001.11]]];
    totalProfitLabel.text = [NSString stringWithString:[formatter stringFromNumber:[NSNumber numberWithDouble:1001.11]]];
    profitPercentLabel.text = @"6.832%";

    [self setDataCount:10 range:8.00];
    [lineChartView animateWithXAxisDuration:0.8];
}

- (void)setDataCount:(int)count range:(double)range
{
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        [xVals addObject:[@(i) stringValue]];
    }
    
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        double mult = range;
        double val = (double) (arc4random_uniform(mult)) +2;
        [yVals addObject:[[ChartDataEntry alloc] initWithValue:val xIndex:i]];
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
    
}

- (void)toDrawHuoqi:(id)sender
{
    
}

@end
