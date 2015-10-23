//
//  DetailViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/23.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize dingqiButton, huoqiButton, inAndOutButton, allButton, tView, headView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
    backItem.tintColor = ZTBLUE;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
    
    [headView.layer setBorderWidth:1];
    [headView.layer setBorderColor:ZTBLUE.CGColor];
    
    tView.showsHorizontalScrollIndicator = NO;
    tView.showsVerticalScrollIndicator = NO;
    
    [dingqiButton addTarget:self action:@selector(Dingqi:) forControlEvents:UIControlEventTouchUpInside];
    [huoqiButton addTarget:self action:@selector(Huoqi:) forControlEvents:UIControlEventTouchUpInside];
    [inAndOutButton addTarget:self action:@selector(InAndOut:) forControlEvents:UIControlEventTouchUpInside];
    [allButton addTarget:self action:@selector(All:) forControlEvents:UIControlEventTouchUpInside];
    
    [dingqiButton setUserInteractionEnabled:NO];
    dingqiButton.tintColor = ZTBLUE;
    huoqiButton.tintColor = ZTGRAY;
    inAndOutButton.tintColor = ZTGRAY;
    allButton.tintColor = ZTGRAY;
    [self setupDingqi];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backToParent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)Dingqi:(id)sender
{
    dingqiButton.tintColor = ZTBLUE;
    [dingqiButton setUserInteractionEnabled:NO];
    [self setupDingqi];
    huoqiButton.tintColor = ZTGRAY;
    inAndOutButton.tintColor = ZTGRAY;
    allButton.tintColor = ZTGRAY;
    [huoqiButton setUserInteractionEnabled:YES];
    [inAndOutButton setUserInteractionEnabled:YES];
    [allButton setUserInteractionEnabled:YES];
    
}

- (void)Huoqi:(id)sender
{
    huoqiButton.tintColor = ZTBLUE;
    [huoqiButton setUserInteractionEnabled:NO];
    [self setupHuoqi];
    dingqiButton.tintColor = ZTGRAY;
    inAndOutButton.tintColor = ZTGRAY;
    allButton.tintColor = ZTGRAY;
    [dingqiButton setUserInteractionEnabled:YES];
    [inAndOutButton setUserInteractionEnabled:YES];
    [allButton setUserInteractionEnabled:YES];
}

- (void)InAndOut:(id)sender
{
    inAndOutButton.tintColor = ZTBLUE;
    [inAndOutButton setUserInteractionEnabled:NO];
    [self setupInAndOut];
    dingqiButton.tintColor = ZTGRAY;
    huoqiButton.tintColor = ZTGRAY;
    allButton.tintColor = ZTGRAY;
    [dingqiButton setUserInteractionEnabled:YES];
    [huoqiButton setUserInteractionEnabled:YES];
    [allButton setUserInteractionEnabled:YES];
}

- (void)All:(id)sender
{
    allButton.tintColor = ZTBLUE;
    [allButton setUserInteractionEnabled:NO];
    [self setupAll];
    dingqiButton.tintColor = ZTGRAY;
    inAndOutButton.tintColor = ZTGRAY;
    huoqiButton.tintColor = ZTGRAY;
    [dingqiButton setUserInteractionEnabled:YES];
    [inAndOutButton setUserInteractionEnabled:YES];
    [huoqiButton setUserInteractionEnabled:YES];
}

- (void)setupDingqi
{
    datas = [[NSMutableArray alloc]init];
    
    for (int i=0; i<10; i++)
    {
        [datas addObject:@{@"TYPE":@"稳健型",
                           @"AMOUNT":@"10000.12",
                           @"STATUS":@(i%3),
                           @"TIME":@"2015-12-25   11:11:11"}];
        
        [datas addObject:@{@"TYPE":@"综合型",
                           @"AMOUNT":@"10000.12",
                           @"STATUS":@(i%3),
                           @"TIME":@"2015-12-25   11:11:11"}];
    }
    
    detailNum = (int)datas.count;
    [tView reloadData];
    [tView setContentOffset:CGPointMake(0, 0) animated:NO];
}

- (void)setupHuoqi
{
    datas = [[NSMutableArray alloc]init];
    
    for (int i=0; i<20; i++)
    {
        [datas addObject:@{@"TYPE":@"专投宝",
                           @"AMOUNT":@"10000.12",
                           @"STATUS":@(i%3),
                           @"TIME":@"2015-12-25   11:11:11"}];
    }
    
    detailNum = (int)datas.count;
    [tView reloadData];
    [tView setContentOffset:CGPointMake(0, 0) animated:NO];
}

- (void)setupInAndOut
{
    datas = [[NSMutableArray alloc]init];
    
    for (int i=0; i<10; i++)
    {
        [datas addObject:@{@"TYPE":@"充值",
                           @"AMOUNT":@"10000.12",
                           @"STATUS":@(i%3),
                           @"TIME":@"2015-12-25   11:11:11"}];
        
        [datas addObject:@{@"TYPE":@"提现",
                           @"AMOUNT":@"10000.12",
                           @"STATUS":@(i%3),
                           @"TIME":@"2015-12-25   11:11:11"}];
    }
    
    detailNum = (int)datas.count;
    [tView reloadData];
    [tView setContentOffset:CGPointMake(0, 0) animated:NO];
}

- (void)setupAll
{
    datas = [[NSMutableArray alloc]init];
    
    for (int i=0; i<10; i++)
    {
        [datas addObject:@{@"TYPE":@"充值",
                           @"AMOUNT":@"10000.12",
                           @"STATUS":@(i%3),
                           @"TIME":@"2015-12-25   11:11:11"}];
        
        [datas addObject:@{@"TYPE":@"提现",
                           @"AMOUNT":@"10000.12",
                           @"STATUS":@(i%3),
                           @"TIME":@"2015-12-25   11:11:11"}];
        
        [datas addObject:@{@"TYPE":@"稳健型",
                           @"AMOUNT":@"10000.12",
                           @"STATUS":@(i%3),
                           @"TIME":@"2015-12-25   11:11:11"}];
        
        [datas addObject:@{@"TYPE":@"综合型",
                           @"AMOUNT":@"10000.12",
                           @"STATUS":@(i%3),
                           @"TIME":@"2015-12-25   11:11:11"}];
    }
    
    detailNum = (int)datas.count;
    [tView reloadData];
    [tView setContentOffset:CGPointMake(0, 0) animated:NO];
}

#pragma TableViewDelegates

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return detailNum;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id data = datas[indexPath.row];
    static NSString *identifier = @"DetailTableViewCell";
    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[DetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if ([(NSNumber*)[data valueForKey:@"STATUS"] integerValue] == 0)
    {
        cell.statusLabel.text = @"√";
    }
    else if ([(NSNumber*)[data valueForKey:@"STATUS"] integerValue] == 1)
    {
        cell.statusLabel.text = @"×";
    }
    else
    {
        cell.statusLabel.text = @"?";
    }
    
    cell.titleLabel.text = [data valueForKey:@"TYPE"];
    cell.timeLabel.text = [data valueForKey:@"TIME"];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    [formatter setPositiveFormat:@"###,##0.00"];
    cell.numLabel.text = [NSString stringWithFormat:@"%@元",[formatter stringFromNumber:[NSNumber numberWithDouble:((NSString*)[data valueForKey:@"AMOUNT"]).doubleValue]]];
    
    return cell;
}


@end
