//
//  ProductsBeforeViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/29.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "ProductsBeforeViewController.h"

@interface ProductsBeforeViewController ()

@end

@implementation ProductsBeforeViewController

@synthesize tView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.view.clipsToBounds = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
    backItem.tintColor = ZTBLUE;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
    
    datas = [[NSMutableArray alloc]init];
    buffer = [[NSMutableArray alloc]init];
    
    tView.showsHorizontalScrollIndicator = NO;
    tView.showsVerticalScrollIndicator = NO;
    tView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self setupData];
    }];
    [tView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)becomeForeground
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tView.mj_header beginRefreshing];
    });
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)backToParent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupData
{
    [buffer removeAllObjects];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:@"api/fofProd/PreviousProducts"];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
        NSLog(@"%@", responseObject);
        buffer = [NSMutableArray arrayWithArray:responseObject];
        datas = [NSMutableArray arrayWithArray:buffer];
        productsNum = (int)datas.count;
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

#pragma TableViewDelegates

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return productsNum;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 143;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id data = [datas objectAtIndex:indexPath.row];
    static NSString *identifier = @"ProductsBeforeTableViewCell";
    ProductsBeforeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[ProductsBeforeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.idLabel.text = [NSString stringWithFormat:@"%@",[data objectForKey:@"time"]];
    if ([NSString stringWithFormat:@"%@",[data objectForKey:@"profit"]].doubleValue < 0)
    {
        cell.percentNumLabel.text = @"暂不计算";
    }
    else
    {
        cell.percentNumLabel.text = [NSString stringWithFormat:@"%.2f%%",[NSString stringWithFormat:@"%@",[data objectForKey:@"profit"]].doubleValue];
    }
    cell.statusLabel.text = [data objectForKey:@"status"];
    if ([cell.statusLabel.text isEqualToString:@"操盘中"])
    {
        cell.headView.backgroundColor = ZTBLUE;
        cell.percentNumLabel.textColor = ZTLIGHTRED;
        cell.percentTitleLabel.text = @"预期年化收益率";
    }
    else
    {
        cell.headView.backgroundColor = ZTGRAY;
        cell.percentNumLabel.textColor = ZTGRAY;
        cell.percentTitleLabel.text = @"年化收益";
    }
    
    return cell;
}

@end
