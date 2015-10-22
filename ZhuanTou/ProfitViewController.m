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

@synthesize dingqiPercentLabel, huoqiPercentLabel, balancePercentLabel, frozenPercentLabel, bonusPercentLabel;
@synthesize dingqiNumLabel, huoqiNumLabel, balanceNumLabel, frozenNumLabel, bonusNumLabel;
@synthesize contentView, pieChartView, totalNumLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
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
    dingqiPercentLabel.text = [NSString stringWithFormat:@"%0.2f%%",25.00];
    huoqiPercentLabel.text = [NSString stringWithFormat:@"%0.2f%%",25.00];
    balancePercentLabel.text = [NSString stringWithFormat:@"%0.2f%%",25.00];
    frozenPercentLabel.text = [NSString stringWithFormat:@"%0.2f%%",25.00];
    bonusPercentLabel.text = [NSString stringWithFormat:@"%0.2f%%",25.00];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    [formatter setPositiveFormat:@"###,##0.00元"];
    dingqiNumLabel.text = [NSString stringWithString:[formatter stringFromNumber:[NSNumber numberWithDouble:10000.00]]];
    huoqiNumLabel.text = [NSString stringWithString:[formatter stringFromNumber:[NSNumber numberWithDouble:10000.00]]];
    balanceNumLabel.text = [NSString stringWithString:[formatter stringFromNumber:[NSNumber numberWithDouble:10000.00]]];
    frozenNumLabel.text = [NSString stringWithString:[formatter stringFromNumber:[NSNumber numberWithDouble:10000.00]]];
    bonusNumLabel.text = [NSString stringWithString:[formatter stringFromNumber:[NSNumber numberWithDouble:10000.00]]];
    totalNumLabel.text = [NSString stringWithString:[formatter stringFromNumber:[NSNumber numberWithDouble:40000.00]]];
    
    [self setDataCount:5 range:100];
    [pieChartView animateWithXAxisDuration:1.5 yAxisDuration:1.5 easingOption:ChartEasingOptionEaseOutBack];
}

- (void)setDataCount:(int)count range:(double)range
{
    double mult = range;
    
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    
    // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
    for (int i = 0; i < count; i++)
    {
        [yVals1 addObject:[[BarChartDataEntry alloc] initWithValue:(arc4random_uniform(mult) + mult / 5) xIndex:i]];
    }
    
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
    [colors addObject:ZTPIECHARTGREEN];
    [colors addObject:ZTPIECHARTYELLOW];
    [colors addObject:ZTPIECHARTPURPLE];
    [colors addObject:ZTPIECHARTBLUE];
    [colors addObject:ZTPIECHARTRED];
    
    dataSet.colors = colors;
    
    PieChartData *data = [[PieChartData alloc] initWithXVals:xVals dataSet:dataSet];
    
    pieChartView.data = data;
    [pieChartView highlightValues:nil];
}


@end
