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

@synthesize dingqiButton, huoqiButton, inAndOutButton, allButton, tView, headView, noRecordLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
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
    
    noRecordLabel.hidden = YES;
    dingqiPageNum = 0;
    huoqiPageNum = 0;
    inAndOutPageNum = 0;
    allPageNum = 0;
    dingqiDatas = [[NSMutableArray alloc]init];
    huoqiDatas = [[NSMutableArray alloc]init];
    inAndOutDatas = [[NSMutableArray alloc]init];
    allDatas = [[NSMutableArray alloc]init];
    datas = [[NSMutableArray alloc]init];
    buttonTag = 0;
    tView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        switch (buttonTag) {
            case 0:
                dingqiPageNum = 1;
                [dingqiDatas removeAllObjects];
                [self setupDingqi];
                break;
                
            case 1:
                huoqiPageNum = 1;
                [huoqiDatas removeAllObjects];
                [self setupHuoqi];
                break;
            
            case 2:
                inAndOutPageNum = 1;
                [inAndOutDatas removeAllObjects];
                [self setupInAndOut];
                break;
                
            case 3:
                allPageNum = 1;
                [allDatas removeAllObjects];
                [self setupAll];
                break;
                
            default:
                break;
        }
        [tView.mj_footer resetNoMoreData];
        
    }];
    [tView.mj_header beginRefreshing];
    tView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        switch (buttonTag) {
            case 0:
                [self setupDingqi];
                break;
                
            case 1:
                [self setupHuoqi];
                break;
                
            case 2:
                [self setupInAndOut];
                break;
                
            case 3:
                [self setupAll];
                break;
                
            default:
                break;
        }
    }];

    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backToParent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)Dingqi:(id)sender
{
    noRecordLabel.hidden = YES;
    buttonTag = 0;
    [tView.mj_header beginRefreshing];
    dingqiButton.tintColor = ZTBLUE;
    [dingqiButton setUserInteractionEnabled:NO];
    huoqiButton.tintColor = ZTGRAY;
    inAndOutButton.tintColor = ZTGRAY;
    allButton.tintColor = ZTGRAY;
    [huoqiButton setUserInteractionEnabled:YES];
    [inAndOutButton setUserInteractionEnabled:YES];
    [allButton setUserInteractionEnabled:YES];
    
}

- (void)Huoqi:(id)sender
{
    noRecordLabel.hidden = YES;
    buttonTag = 1;
    [tView.mj_header beginRefreshing];
    huoqiButton.tintColor = ZTBLUE;
    [huoqiButton setUserInteractionEnabled:NO];
    dingqiButton.tintColor = ZTGRAY;
    inAndOutButton.tintColor = ZTGRAY;
    allButton.tintColor = ZTGRAY;
    [dingqiButton setUserInteractionEnabled:YES];
    [inAndOutButton setUserInteractionEnabled:YES];
    [allButton setUserInteractionEnabled:YES];
}

- (void)InAndOut:(id)sender
{
    noRecordLabel.hidden = YES;
    buttonTag = 2;
    [tView.mj_header beginRefreshing];
    inAndOutButton.tintColor = ZTBLUE;
    [inAndOutButton setUserInteractionEnabled:NO];
    dingqiButton.tintColor = ZTGRAY;
    huoqiButton.tintColor = ZTGRAY;
    allButton.tintColor = ZTGRAY;
    [dingqiButton setUserInteractionEnabled:YES];
    [huoqiButton setUserInteractionEnabled:YES];
    [allButton setUserInteractionEnabled:YES];
}

- (void)All:(id)sender
{
    noRecordLabel.hidden = YES;
    buttonTag = 3;
    [tView.mj_header beginRefreshing];
    allButton.tintColor = ZTBLUE;
    [allButton setUserInteractionEnabled:NO];
    dingqiButton.tintColor = ZTGRAY;
    inAndOutButton.tintColor = ZTGRAY;
    huoqiButton.tintColor = ZTGRAY;
    [dingqiButton setUserInteractionEnabled:YES];
    [inAndOutButton setUserInteractionEnabled:YES];
    [huoqiButton setUserInteractionEnabled:YES];
}

- (void)setupDingqi
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"api/account/catetoryTransaction4M/4/%d",dingqiPageNum]];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
        NSLog(@"%@", responseObject);
        [dingqiDatas addObjectsFromArray:responseObject];
        datas = [NSMutableArray arrayWithArray:dingqiDatas];
        detailNum = (int)datas.count;
        dingqiPageNum++;
        if (datas.count > 0)
        {
            noRecordLabel.hidden = YES;
        }
        else
        {
            noRecordLabel.hidden = NO;
        }
        if (dingqiPageNum == 2)
        {
            [tView reloadData];
            [tView.mj_header endRefreshing];
        }
        else
        {
            [tView reloadData];
            [tView.mj_footer endRefreshing];
        }
        if (responseObject.count == 0)
        {
            [tView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [tView.mj_header endRefreshing];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        if (error.code == 100003)
        {
            hud.labelText = @"登录信息已过期，请重新登录";
            SetpasswordViewController *setpass = [[self storyboard]instantiateViewControllerWithIdentifier:@"SetpasswordViewController"];
            setpass.string = @"验证密码";
            [[self tabBarController] presentViewController:setpass animated:NO completion:nil];
        }
        else
        {
            hud.labelText = @"当前网络状况不佳，请重试";
        }
        [hud hide:YES afterDelay:1.5f];
    }];
}

- (void)setupHuoqi
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"api/account/catetoryTransaction4M/5/%d",huoqiPageNum]];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
        NSLog(@"%@", responseObject);
        [huoqiDatas addObjectsFromArray:responseObject];
        datas = [NSMutableArray arrayWithArray:huoqiDatas];
        detailNum = (int)datas.count;
        huoqiPageNum++;
        if (datas.count > 0)
        {
            noRecordLabel.hidden = YES;
        }
        else
        {
            noRecordLabel.hidden = NO;
        }
        if (huoqiPageNum == 2)
        {
            [tView reloadData];
            [tView.mj_header endRefreshing];
        }
        else
        {
            [tView reloadData];
            [tView.mj_footer endRefreshing];
        }
        if (responseObject.count == 0)
        {
            [tView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [tView.mj_header endRefreshing];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        if (error.code == 100003)
        {
            hud.labelText = @"登录信息已过期，请重新登录";
            SetpasswordViewController *setpass = [[self storyboard]instantiateViewControllerWithIdentifier:@"SetpasswordViewController"];
            setpass.string = @"验证密码";
            [[self tabBarController] presentViewController:setpass animated:NO completion:nil];
        }
        else
        {
            hud.labelText = @"当前网络状况不佳，请重试";
        }
        [hud hide:YES afterDelay:1.5f];
    }];
}

- (void)setupInAndOut
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"api/account/catetoryTransaction4M/1/%d",inAndOutPageNum]];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
        NSLog(@"%@", responseObject);
        [inAndOutDatas addObjectsFromArray:responseObject];
        datas = [NSMutableArray arrayWithArray:inAndOutDatas];
        detailNum = (int)datas.count;
        inAndOutPageNum++;
        if (datas.count > 0)
        {
            noRecordLabel.hidden = YES;
        }
        else
        {
            noRecordLabel.hidden = NO;
        }
        if (inAndOutPageNum == 2)
        {
            [tView reloadData];
            [tView.mj_header endRefreshing];
        }
        else
        {
            [tView reloadData];
            [tView.mj_footer endRefreshing];
        }
        if (responseObject.count == 0)
        {
            [tView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [tView.mj_header endRefreshing];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        if (error.code == 100003)
        {
            hud.labelText = @"登录信息已过期，请重新登录";
            SetpasswordViewController *setpass = [[self storyboard]instantiateViewControllerWithIdentifier:@"SetpasswordViewController"];
            setpass.string = @"验证密码";
            [[self tabBarController] presentViewController:setpass animated:NO completion:nil];
        }
        else
        {
            hud.labelText = @"当前网络状况不佳，请重试";
        }
        [hud hide:YES afterDelay:1.5f];
    }];
}

- (void)setupAll
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"api/account/transactions4M/%d",allPageNum]];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
        NSLog(@"%@", responseObject);
        [allDatas addObjectsFromArray:responseObject];
        datas = [NSMutableArray arrayWithArray:allDatas];
        detailNum = (int)datas.count;
        allPageNum++;
        if (datas.count > 0)
        {
            noRecordLabel.hidden = YES;
        }
        else
        {
            noRecordLabel.hidden = NO;
        }
        if (allPageNum == 2)
        {
            [tView reloadData];
            [tView.mj_header endRefreshing];
        }
        else
        {
            [tView reloadData];
            [tView.mj_footer endRefreshing];
        }
        if (responseObject.count == 0)
        {
            [tView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [tView.mj_header endRefreshing];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        if (error.code == 100003)
        {
            hud.labelText = @"登录信息已过期，请重新登录";
            SetpasswordViewController *setpass = [[self storyboard]instantiateViewControllerWithIdentifier:@"SetpasswordViewController"];
            setpass.string = @"验证密码";
            [[self tabBarController] presentViewController:setpass animated:NO completion:nil];
        }
        else
        {
            hud.labelText = @"当前网络状况不佳，请重试";
        }
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
    
    cell.statusLabel.hidden = YES;
    
    cell.titleLabel.text = [data objectForKey:@"type"];
    cell.timeLabel.text = [data objectForKey:@"createdOn"];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    [formatter setPositiveFormat:@"###,##0.00"];
    if ([[data objectForKey:@"itemType"] isEqualToString:@"收入"])
    {
        cell.numLabel.text = [NSString stringWithFormat:@"+%@元",[formatter stringFromNumber:[NSNumber numberWithDouble:((NSString*)[data objectForKey:@"money"]).doubleValue]]];
    }
    else if ([[data objectForKey:@"itemType"] isEqualToString:@"支出"])
    {
        cell.numLabel.text = [NSString stringWithFormat:@"-%@元",[formatter stringFromNumber:[NSNumber numberWithDouble:((NSString*)[data objectForKey:@"money"]).doubleValue]]];
    }
    else
    {
        cell.numLabel.text = [NSString stringWithFormat:@"%@元",[formatter stringFromNumber:[NSNumber numberWithDouble:((NSString*)[data objectForKey:@"money"]).doubleValue]]];
    }
    return cell;
}


@end
