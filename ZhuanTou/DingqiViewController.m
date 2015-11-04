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
    
    tView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
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
    [tView.header beginRefreshing];
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
    
}

- (void)loadIngTableViewData:(id)sender
{
    buttonTag = 0;
    [tView.header beginRefreshing];
    ingButton.tintColor = ZTBLUE;
    endedButton.tintColor = ZTGRAY;
    [ingButton setUserInteractionEnabled:NO];
    [endedButton setUserInteractionEnabled:YES];
}

- (void)loadIngTableViewData
{
    datas = [[NSMutableArray alloc]init];
    
    for (int i=0; i<5; i++)
    {
        [datas addObject:@{@"TYPE":WENJIAN,
                           @"ID":[NSString stringWithFormat:@"1510%02d",i],
                           @"AMOUNT":@"10000.12",
                           @"PROFIT":@"34.12",
                           @"TIME":@"2015年12月25日"}];
        
        [datas addObject:@{@"TYPE":ZONGHE,
                           @"ID":[NSString stringWithFormat:@"1510%02d",i],
                           @"AMOUNT":@"10000.12",
                           @"GUIDE":@"34.12",
                           @"FLOAT":@"2762.11",
                           @"TIME":@"2015年12月25日"}];
    }
    
    productsNum = (int)datas.count;
    if (productsNum == 0)
    {
        [noneProductView setHidden:NO];
        [findProductButton setHidden:NO];
        [tView setHidden:YES];
    }
    else
    {
        [noneProductView setHidden:YES];
        [findProductButton setHidden:YES];
        [tView setHidden:NO];
    }
    [tView reloadData];
    [tView setContentOffset:CGPointMake(0, 0) animated:NO];
    [tView.header endRefreshing];
}

- (void)loadEndedTableViewData:(id)sender
{
    buttonTag = 1;
    [tView.header beginRefreshing];
    endedButton.tintColor = ZTBLUE;
    ingButton.tintColor = ZTGRAY;
    [endedButton setUserInteractionEnabled:NO];
    [ingButton setUserInteractionEnabled:YES];
}

- (void)loadEndedTableViewData
{
    NSLog(@"%d",buttonTag);
    datas = [[NSMutableArray alloc]init];
    
    for (int i=0; i<5; i++)
    {
        [datas addObject:@{@"TYPE":WENJIAN,
                           @"ID":[NSString stringWithFormat:@"1510%02d",i],
                           @"AMOUNT":@"10000.12",
                           @"PROFIT":@"34.12"}];
        
        [datas addObject:@{@"TYPE":ZONGHE,
                           @"ID":[NSString stringWithFormat:@"1510%02d",i],
                           @"AMOUNT":@"10000.12",
                           @"GUIDE":@"34.12",
                           @"FLOAT":@"2762.11"}];
    }
    
    productsNum = (int)datas.count;
    
    if (productsNum == 0)
    {
        [noneProductView setHidden:NO];
        [tView setHidden:YES];
    }
    else
    {
        [noneProductView setHidden:YES];
        [tView setHidden:NO];
    }
    [findProductButton setHidden:YES];
    [tView reloadData];
    [tView setContentOffset:CGPointMake(0, 0) animated:NO];
    [tView.header endRefreshing];
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
    id data = datas[indexPath.row];
    NSString *str = [data valueForKey:@"TYPE"];
    if (ingButton.userInteractionEnabled)
    {
        if ([str isEqualToString:WENJIAN])
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
        if ([str isEqualToString:WENJIAN])
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
    NSString *str = [data valueForKey:@"TYPE"];
    if (ingButton.userInteractionEnabled)
    {
        if ([str isEqualToString:WENJIAN])
        {
            NSString *identifier = @"WenjianEndedTableViewCell";
            WenjianEndedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                cell = [[WenjianEndedTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            cell.idLabel.text = [NSString stringWithFormat:@"%@期",[data valueForKey:@"ID"]];
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
            [formatter setPositiveFormat:@"###,##0.00"];
            cell.amountLabel.text = [NSString stringWithFormat:@"%@元",[formatter stringFromNumber:[NSNumber numberWithDouble:((NSString*)[data valueForKey:@"AMOUNT"]).doubleValue]]];
            cell.profitLabel.text = [NSString stringWithFormat:@"%@元",[formatter stringFromNumber:[NSNumber numberWithDouble:((NSString*)[data valueForKey:@"PROFIT"]).doubleValue]]];

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
            
            cell.idLabel.text = [NSString stringWithFormat:@"%@期",[data valueForKey:@"ID"]];
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
            [formatter setPositiveFormat:@"###,##0.00"];
            cell.amountLabel.text = [NSString stringWithFormat:@"%@元",[formatter stringFromNumber:[NSNumber numberWithDouble:((NSString*)[data valueForKey:@"AMOUNT"]).doubleValue]]];
            cell.guideProfitLabel.text = [NSString stringWithFormat:@"%@元",[formatter stringFromNumber:[NSNumber numberWithDouble:((NSString*)[data valueForKey:@"GUIDE"]).doubleValue]]];
            cell.floatProfitLabel.text = [NSString stringWithFormat:@"%@元",[formatter stringFromNumber:[NSNumber numberWithDouble:((NSString*)[data valueForKey:@"FLOAT"]).doubleValue]]];
            
            return cell;
        }

    }
    else
    {
        if ([str isEqualToString:WENJIAN])
        {
            NSString *identifier = @"WenjianIngTableViewCell";
            WenjianIngTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                cell = [[WenjianIngTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            cell.idLabel.text = [NSString stringWithFormat:@"%@期",[data valueForKey:@"ID"]];
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
            [formatter setPositiveFormat:@"###,##0.00"];
            cell.amountLabel.text = [NSString stringWithFormat:@"%@元",[formatter stringFromNumber:[NSNumber numberWithDouble:((NSString*)[data valueForKey:@"AMOUNT"]).doubleValue]]];
            cell.profitLabel.text = [NSString stringWithFormat:@"%@元",[formatter stringFromNumber:[NSNumber numberWithDouble:((NSString*)[data valueForKey:@"PROFIT"]).doubleValue]]];
            cell.timeLabel.text = [data valueForKey:@"TIME"];
            
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
            
            cell.idLabel.text = [NSString stringWithFormat:@"%@期",[data valueForKey:@"ID"]];
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
            [formatter setPositiveFormat:@"###,##0.00"];
            cell.amountLabel.text = [NSString stringWithFormat:@"%@元",[formatter stringFromNumber:[NSNumber numberWithDouble:((NSString*)[data valueForKey:@"AMOUNT"]).doubleValue]]];
            cell.guideProfitLabel.text = [NSString stringWithFormat:@"%@元",[formatter stringFromNumber:[NSNumber numberWithDouble:((NSString*)[data valueForKey:@"GUIDE"]).doubleValue]]];
            cell.floatProfitLabel.text = [NSString stringWithFormat:@"%@元",[formatter stringFromNumber:[NSNumber numberWithDouble:((NSString*)[data valueForKey:@"FLOAT"]).doubleValue]]];
            cell.timeLabel.text = [data valueForKey:@"TIME"];
            
            return cell;
        }

    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
