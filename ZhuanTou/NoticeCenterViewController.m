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
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
    backItem.tintColor = ZTBLUE;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
}

- (void)viewWillAppear:(BOOL)animated
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
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)setupData
{
    notices = [[NSMutableArray alloc]init];
    
    for (int i=0; i<10; i++)
    {
        [notices addObject:@{@"TITLE":@"专投网APP正式上线啦！",
                             @"DESCRIPTION":@"专投网APP正式上线啦！专投网APP正式上线啦！专投网APP正式上线啦！专投网APP正式上线啦！专投网APP正式上线啦！专投网APP正式上线啦！专投网APP正式上线啦！",
                             @"TIME":@"2015-12-25   11:11:11",
                             @"URL":@"www.baidu.com"}];
    }
    
    noticesNum = (int)notices.count;
    [tView reloadData];
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
    cell.titleLabel.text = [notice objectForKey:@"TITLE"];
    cell.timeLabel.text = [notice objectForKey:@"TIME"];
    cell.descriptionLabel.text = [notice objectForKey:@"DESCRIPTION"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoticeDetailViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"NoticeDetailViewController"];
    [vc setURL:[[notices objectAtIndex:indexPath.row] objectForKey:@"URL"]];
    [[self navigationController]pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
