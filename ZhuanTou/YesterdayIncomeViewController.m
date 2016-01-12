//
//  YesterdayIncomeViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 16/1/12.
//  Copyright © 2016年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "YesterdayIncomeViewController.h"

@interface YesterdayIncomeViewController ()

@end

@implementation YesterdayIncomeViewController

@synthesize tView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
    backItem.tintColor = ZTBLUE;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
    
    data = [[NSMutableArray alloc]init];
    
    tView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self setupData];
    }];
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
    [tView reloadData];
    [tView.mj_header endRefreshing];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"YesterdayIncomeTableViewCell";
    YesterdayIncomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[YesterdayIncomeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.bgView.backgroundColor = ZTRED;
    cell.titleLabel.text = @"稳盈宝  160108";
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    [formatter setPositiveFormat:@"###,##0.00"];
    cell.amountLabel.text = [formatter stringFromNumber:[NSNumber numberWithDouble:3000.21]];
    cell.profitLabel.text = [formatter stringFromNumber:[NSNumber numberWithDouble:123.21]];
    
    return cell;
}


@end
