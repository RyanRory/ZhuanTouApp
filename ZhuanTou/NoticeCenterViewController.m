//
//  NoticeCenterViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/26.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "NoticeCenterViewController.h"

@interface NoticeCenterViewController ()

@end

@implementation NoticeCenterViewController

@synthesize tView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
    backItem.tintColor = ZTBLUE;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
    notices = [[NSMutableArray alloc]init];
    tView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageNum = 1;
        [self setupData];
    }];
    [tView.mj_header beginRefreshing];
    tView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self setupData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)setupData
{
    if (pageNum == 1)
    {
        [notices removeAllObjects];
        [tView.mj_footer resetNoMoreData];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"api/article/byCategory4M/0/%d", pageNum]];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        [notices addObjectsFromArray:[responseObject objectForKey:@"dataList"]];
        noticesNum = (int)notices.count;
        pageNum++;
        if (pageNum == 2)
        {
            [tView reloadData];
            [tView.mj_header endRefreshing];
        }
        else
        {
            [tView reloadData];
            [tView.mj_footer endRefreshing];
        }
        if ([NSArray arrayWithArray:[responseObject objectForKey:@"dataList"]].count == 0)
        {
            [tView.mj_footer endRefreshingWithNoMoreData];
        }
        
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
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return noticesNum;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id notice = [notices objectAtIndex:indexPath.row];
    static NSString *identifier = @"NoticeCenterTableViewCell";
    NoticeCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[NoticeCenterTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.titleLabel.text = [notice objectForKey:@"title"];
    cell.timeLabel.text = [notice objectForKey:@"createOn"];
    if (![[notice objectForKey:@"comments"] isKindOfClass:[NSNull class]])
    {
        cell.descriptionLabel.text = [notice objectForKey:@"comments"];
    }
    else
    {
        cell.descriptionLabel.text = [notice objectForKey:@"title"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WebDetailViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"WebDetailViewController"];
    vc.title = @"公告详情";
    [vc setURL:[NSString stringWithFormat:@"%@Wap/WebView/MobileNews/%@", BASEURL, [[notices objectAtIndex:indexPath.row] objectForKey:@"id"]]];
    [[self navigationController]pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
