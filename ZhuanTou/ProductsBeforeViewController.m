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
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
    backItem.tintColor = ZTBLUE;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
    
    tView.showsHorizontalScrollIndicator = NO;
    tView.showsVerticalScrollIndicator = NO;
    tView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    
    for (int i=10; i>=0; i--)
    {
        [datas addObject:@{@"STATUS":@"0",
                           @"ID":[NSString stringWithFormat:@"1510%02d",i],
                           @"PERCENT":@"15.00"}];
    }
    
    
    productsNum = (int)datas.count;
    [tView reloadData];
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
    cell.idLabel.text = [data objectForKey:@"ID"];
    cell.percentNumLabel.text = [NSString stringWithFormat:@"%@%%",[data objectForKey:@"PERCENT"]];
    if (((NSString*)[data objectForKey:@"STATUS"]).boolValue)
    {
        cell.headView.backgroundColor = ZTBLUE;
        cell.percentNumLabel.textColor = ZTLIGHTRED;
        cell.percentTitleLabel.text = @"预期年化收益率";
        cell.statusLabel.text = @"运行中";
    }
    else
    {
        cell.headView.backgroundColor = ZTGRAY;
        cell.percentNumLabel.textColor = ZTGRAY;
        cell.percentTitleLabel.text = @"年化收益率";
        cell.statusLabel.text = @"已到期";
    }
    
    return cell;
}

@end
