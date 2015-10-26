//
//  BonusViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/25.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "BonusViewController.h"

@interface BonusViewController ()

@end

@implementation BonusViewController

@synthesize tView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
    backItem.tintColor = ZTBLUE;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
    
    tView.showsHorizontalScrollIndicator = NO;
    tView.showsVerticalScrollIndicator = NO;
    
    [self setupData];
}

- (void)viewDidAppear:(BOOL)animated
{
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
    datas = [[NSMutableArray alloc]init];
    for (int i=0; i<10; i++)
    {
        [datas addObject:@{@"RULE":@"新手投标可用",
                           @"AMOUNT":@"1000",
                           @"STATUS":@"可使用",
                           @"DEADLINE":@"2015年12月12日"}];
        
        [datas addObject:@{@"RULE":@"新手投标可用",
                           @"AMOUNT":@"100",
                           @"STATUS":@"已失效",
                           @"DEADLINE":@"2015年10月12日"}];
    }
    
    bonusNum = datas.count;
    
    [tView reloadData];
}

#pragma TableViewDelegates

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 142;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return bonusNum;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id data = [datas objectAtIndex:indexPath.row];
    static NSString *identifier = @"BonusTableViewCell";
    BonusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[BonusTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.amountLabel.text = [data objectForKey:@"AMOUNT"];
    cell.statusLabel.text = [data objectForKey:@"STATUS"];
    cell.ddlLabel.text = [data objectForKey:@"DEADLINE"];
    cell.ruleLabel.text = [data objectForKey:@"RULE"];
    if ([cell.statusLabel.text isEqualToString:@"可使用"])
    {
        cell.bgImageView.image = [UIImage imageNamed:@"bonusActive.png"];
    }
    else
    {
        cell.bgImageView.image = [UIImage imageNamed:@"bonus.png"];
    }
    
    return cell;
}



@end
