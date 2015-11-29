//
//  DingqiViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/18.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "DingqiViewController.h"

@interface DingqiViewController ()

@end

@implementation DingqiViewController

@synthesize noneProductView, findProductButton, tView, ingButton, endedButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
    backItem.tintColor = ZTBLUE;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
    
    findProductButton.layer.cornerRadius = 3;
    ingButton.tintColor = ZTBLUE;
    endedButton.tintColor = ZTGRAY;
    [ingButton setUserInteractionEnabled:NO];
    
    tView.showsHorizontalScrollIndicator = NO;
    tView.showsVerticalScrollIndicator = NO;
    tView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [ingButton addTarget:self action:@selector(loadIngTableViewData:) forControlEvents:UIControlEventTouchUpInside];
    [endedButton addTarget:self action:@selector(loadEndedTableViewData:) forControlEvents:UIControlEventTouchUpInside];
    [findProductButton addTarget:self action:@selector(toProducts:) forControlEvents:UIControlEventTouchUpInside];
    
    noneProductView.hidden = YES;
    findProductButton.hidden = YES;
    
    buttonTag = 0;
    
    datas = [[NSMutableArray alloc]init];
    
    tView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        switch (buttonTag) {
            case 0:
                [self loadIngTableViewData];
                break;
                
            case 1:
                [self loadEndedTableViewData];
                break;
                
            default:
                break;
        }
    }];
    [tView.mj_header beginRefreshing];
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
}

- (void)toProducts:(id)sender
{
    [[self tabBarController] setSelectedIndex:1];
}

- (void)loadIngTableViewData:(id)sender
{
    buttonTag = 0;
    [tView.mj_header beginRefreshing];
    ingButton.tintColor = ZTBLUE;
    endedButton.tintColor = ZTGRAY;
    [ingButton setUserInteractionEnabled:NO];
    [endedButton setUserInteractionEnabled:YES];
}

- (void)loadIngTableViewData
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:@"api/product/myInvestsLite/0"];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
        NSLog(@"%@", responseObject);
        [datas removeAllObjects];
        for (int i = 0; i < responseObject.count; i++)
        {
            if ([[responseObject[i] objectForKey:@"productStyle"] isEqualToString:@"稳健分红"])
            {
                [datas addObject:responseObject[i]];
            }
        }
        productsNum = (int)datas.count;
        if (productsNum == 0)
        {
            [noneProductView setHidden:NO];
            [findProductButton setHidden:NO];
            [tView setContentOffset:CGPointMake(0, 0) animated:NO];
        }
        else
        {
            [noneProductView setHidden:YES];
            [findProductButton setHidden:YES];
        }
        [tView reloadData];
        [tView.mj_header endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        if (error.code == 100003)
        {
            hud.labelText = @"当前用户未被授权执行当前操作";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UINavigationController *nav = [[self storyboard]instantiateViewControllerWithIdentifier:@"LoginNav"];
                [[self tabBarController] presentViewController:nav animated:YES completion:nil];
            });
        }
        else
        {
            hud.labelText = @"当前网络状况不佳，请重试";
        }
        [hud hide:YES afterDelay:1.5f];
        [tView.mj_header endRefreshing];
    }];
}

- (void)loadEndedTableViewData:(id)sender
{
    buttonTag = 1;
    [tView.mj_header beginRefreshing];
    endedButton.tintColor = ZTBLUE;
    ingButton.tintColor = ZTGRAY;
    [endedButton setUserInteractionEnabled:NO];
    [ingButton setUserInteractionEnabled:YES];
}

- (void)loadEndedTableViewData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URL = [BASEURL stringByAppendingString:@"api/product/myInvestsLite/4"];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
        NSLog(@"%@", responseObject);
        [datas removeAllObjects];
        for (int i = 0; i < responseObject.count; i++)
        {
            if ([[responseObject[i] objectForKey:@"productStyle"] isEqualToString:@"稳健分红"])
            {
                [datas addObject:responseObject[i]];
            }
        }
        productsNum = (int)datas.count;
        if (productsNum == 0)
        {
            [noneProductView setHidden:NO];
            [tView setContentOffset:CGPointMake(0, 0) animated:NO];
        }
        else
        {
            [noneProductView setHidden:YES];
            [tView setHidden:NO];
        }
        [tView reloadData];
        [tView.mj_header endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        if (error.code == 100003)
        {
            hud.labelText = @"当前用户未被授权执行当前操作";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UINavigationController *nav = [[self storyboard]instantiateViewControllerWithIdentifier:@"LoginNav"];
                [[self tabBarController] presentViewController:nav animated:YES completion:nil];
            });
        }
        else
        {
            hud.labelText = @"当前网络状况不佳，请重试";
        }
        [hud hide:YES afterDelay:1.5f];
        [tView.mj_header endRefreshing];
    }];
    [findProductButton setHidden:YES];
}

#pragma TableViewDelegates

//- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UILabel *footer = [[UILabel alloc]init];
//    footer.text = @"更多信息请查看zhuantouwang.com";
//    footer.font = [UIFont systemFontOfSize:12.0f];
//    footer.textColor = [UIColor darkGrayColor];
//    footer.textAlignment = 1;
//    
//    return footer;
//}

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
    id data = datas[indexPath.row];
    NSString *str = [data valueForKey:@"productType"];
    if (ingButton.userInteractionEnabled)
    {
        if ([str isEqualToString:@"固定收益"])
        {
            return 143;
        }
        else
        {
            return 184;
        }
    }
    else
    {
        if ([str isEqualToString:@"固定收益"])
        {
            return 184;
        }
        else
        {
            return 225;
        }

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id data = datas[indexPath.row];
    NSString *str = [data valueForKey:@"productType"];
    if (ingButton.userInteractionEnabled)
    {
        if ([str isEqualToString:@"固定收益"])
        {
            NSString *identifier = @"WenjianEndedTableViewCell";
            WenjianEndedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                cell = [[WenjianEndedTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            cell.idLabel.text = [((NSString*)[data objectForKey:@"productName"]) substringFromIndex:3];
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
            [formatter setPositiveFormat:@"###,##0.00"];
            cell.amountLabel.text = [NSString stringWithFormat:@"%@元",[formatter stringFromNumber:[NSNumber numberWithDouble:((NSString*)[data valueForKey:@"amount"]).doubleValue]]];
            cell.profitLabel.text = [NSString stringWithFormat:@"%@元",[formatter stringFromNumber:[NSNumber numberWithDouble:((NSString*)[data valueForKey:@"totalInterestAmount"]).doubleValue]]];

            return cell;
        }
        else
        {
            NSString *identifier = @"ZongheEndedTableViewCell";
            ZongheEndedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                cell = [[ZongheEndedTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            cell.idLabel.text =[((NSString*)[data objectForKey:@"productName"]) substringFromIndex:3];
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
            [formatter setPositiveFormat:@"###,##0.00"];
            cell.amountLabel.text = [NSString stringWithFormat:@"%@元",[formatter stringFromNumber:[NSNumber numberWithDouble:((NSString*)[data valueForKey:@"amount"]).doubleValue]]];
            cell.guideProfitLabel.text = [NSString stringWithFormat:@"%@元",[formatter stringFromNumber:[NSNumber numberWithDouble:((NSString*)[data valueForKey:@"totalInterestAmount"]).doubleValue]]];
            cell.floatProfitLabel.text = [NSString stringWithFormat:@"%@元",[formatter stringFromNumber:[NSNumber numberWithDouble:((NSString*)[data valueForKey:@"paidSharePl"]).doubleValue]]];
            
            return cell;
        }

    }
    else
    {
        if ([str isEqualToString:@"固定收益"])
        {
            NSString *identifier = @"WenjianIngTableViewCell";
            WenjianIngTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                cell = [[WenjianIngTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            cell.idLabel.text = [((NSString*)[data objectForKey:@"productName"]) substringFromIndex:3];
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
            [formatter setPositiveFormat:@"###,##0.00"];
            cell.amountLabel.text = [NSString stringWithFormat:@"%@元",[formatter stringFromNumber:[NSNumber numberWithDouble:((NSString*)[data valueForKey:@"amount"]).doubleValue]]];
            cell.profitLabel.text = [NSString stringWithFormat:@"%@元",[formatter stringFromNumber:[NSNumber numberWithDouble:((NSString*)[data valueForKey:@"totalInterestAmount"]).doubleValue]]];
            cell.timeLabel.text = [data valueForKey:@"endDate"];
            
            return cell;
        }
        else
        {
            NSString *identifier = @"ZongheIngTableViewCell";
            ZongheIngTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                cell = [[ZongheIngTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            cell.idLabel.text = [((NSString*)[data objectForKey:@"productName"]) substringFromIndex:3];
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
            [formatter setPositiveFormat:@"###,##0.00"];
            cell.amountLabel.text = [NSString stringWithFormat:@"%@元",[formatter stringFromNumber:[NSNumber numberWithDouble:((NSString*)[data valueForKey:@"amount"]).doubleValue]]];
            cell.guideProfitLabel.text = [NSString stringWithFormat:@"%@元",[formatter stringFromNumber:[NSNumber numberWithDouble:((NSString*)[data valueForKey:@"totalInterestAmount"]).doubleValue]]];
            cell.floatProfitLabel.text = [NSString stringWithFormat:@"%@元",[formatter stringFromNumber:[NSNumber numberWithDouble:((NSString*)[data valueForKey:@"floatingSharePl"]).doubleValue]]];
            cell.timeLabel.text = [data valueForKey:@"endDate"];
            
            return cell;
        }

    }
}



@end
