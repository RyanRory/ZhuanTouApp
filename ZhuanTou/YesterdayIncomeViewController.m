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
    
    datas = [[NSMutableArray alloc]init];
    buffer = [[NSMutableArray alloc]init];
    
    tView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self setupData];
    }];
    
    [tView.mj_header beginRefreshing];
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
    [buffer removeAllObjects];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:@"api/account/yesterdayGain"];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        buffer = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"items"]];
        datas = [NSMutableArray arrayWithArray:buffer];
        dataNum = (int)datas.count;
        [tView.mj_header endRefreshing];
        [tView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [tView.mj_header endRefreshing];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"当前网络状况不佳，请重试";
        [hud hide:YES afterDelay:1.5f];
    }];
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
    return dataNum;
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
    id data = [datas objectAtIndex:indexPath.section];
    static NSString *identifier = @"YesterdayIncomeTableViewCell";
    YesterdayIncomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[YesterdayIncomeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.titleLabel.text = [NSString stringWithFormat:@"%@", [data objectForKey:@"productName"]];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    [formatter setPositiveFormat:@"###,##0.00"];
    cell.amountLabel.text = [formatter stringFromNumber:[NSNumber numberWithDouble:[NSString stringWithFormat:@"%@", [data objectForKey:@"investAmount"]].doubleValue]];
    cell.profitLabel.text = [formatter stringFromNumber:[NSNumber numberWithDouble:[NSString stringWithFormat:@"%@", [data objectForKey:@"profitAmount"]].doubleValue]];
    if ([[data objectForKey:@"productType"] isEqualToString:@"浮动收益"])
    {
        cell.bgView.backgroundColor = ZTBLUE;
    }
    else if ([[data objectForKey:@"productType"] isEqualToString:@"专投宝"])
    {
        cell.amountTitleLabel.text = @"当前份额(元)";
        cell.bgView.backgroundColor = ZTRED;
        cell.statusLabel.hidden = YES;
    }
    else
    {
        cell.bgView.backgroundColor = ZTLIGHTRED;
    }
    
    if (![NSString stringWithFormat:@"%@",[data objectForKey:@"isRaising"]].boolValue)
    {
        cell.statusLabel.text = @"活动中";
    }
    else
    {
        cell.statusLabel.text = @"募集期";
    }
    
    return cell;
}


@end
