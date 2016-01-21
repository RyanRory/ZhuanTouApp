//
//  ChooseBonusViewController.m
//  ZhuanTou
//
//  Created by 赵润声 on 16/1/21.
//  Copyright © 2016年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "ChooseBonusViewController.h"

@interface ChooseBonusViewController ()

@end

@implementation ChooseBonusViewController

@synthesize tView, style, datas, choosen;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName,nil]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToParent:)];
    backItem.tintColor = ZTBLUE;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, item, nil];
    
    dataNum = (int)datas.count;
    
    if ([self.style isEqualToString:BONUS])
    {
        self.title = @"选择红包";
    }
    else
    {
        self.title = @"选择加息券";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backToParent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    ProductBuyNewViewController *vc = (ProductBuyNewViewController*)self.navigationController.viewControllers[self.navigationController.viewControllers.count-1];
    if ([self.style isEqualToString:BONUS])
    {
        vc.coupon = [choosen objectForKey:@"couponCode"];
        vc.biggestBonus = choosen;
    }
    else if ([self.style isEqualToString:COUPONS])
    {
        vc.vouchers = [vc.vouchers stringByReplacingOccurrencesOfString:[vc.biggestCoupons objectForKey:@"voucherCode"] withString:[choosen objectForKey:@"voucherCode"]];
        vc.biggestCoupons = choosen;
    }
    else
    {
        vc.vouchers = [vc.vouchers stringByReplacingOccurrencesOfString:[vc.biggestCoupons objectForKey:@"voucherCode"] withString:[choosen objectForKey:@"voucherCode"]];
        vc.biggestStandingCoupons = choosen;
    }
}

#pragma TabelViewDelegate

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
    return dataNum;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 137;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id data = [datas objectAtIndex:indexPath.row];
    if ([style isEqualToString:BONUS])
    {
        ChooseBonusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChooseBonusTableViewCell"];
        if (!cell)
        {
            cell = [[ChooseBonusTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChooseBonusTableViewCell"];
        }
        cell.amountLabel.text = [data objectForKey:@"money"];
        
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式
        NSDate *startDate = [dateFormat dateFromString:[data objectForKey:@"expireTime"]];
        NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:startDate];
        
        long year = [components year];
        long month = [components month];
        long day = [components day];
        
        cell.DDLLabel.text = [NSString stringWithFormat:@"%ld年%ld月%ld日过期",year,month,day];
        
        cell.limitLabel.text = [NSString stringWithFormat:@"使用规则：投资满%@元可抵%@元现金",[data objectForKey:@"thresholdValue"],[data objectForKey:@"money"]];
        if (choosen && ([[choosen objectForKey:@"couponCode"] isEqualToString:[data objectForKey:@"couponCode"]]))
        {
            
        }
            
        
        return cell;
    }
    else
    {
        ChooseCouponsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChooseCouponsTableViewCell"];
        if (!cell)
        {
            cell = [[ChooseCouponsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChooseCouponsTableViewCell"];
        }
        cell.amountLabel.text = [NSString stringWithFormat:@"%d",[NSString stringWithFormat:@"%@",[data objectForKey:@"raiseRate"]].intValue];
        
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式
        NSDate *startDate = [dateFormat dateFromString:[data objectForKey:@"expireTime"]];
        NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:startDate];
        
        long year = [components year];
        long month = [components month];
        long day = [components day];
        
        cell.DDLLabel.text = [NSString stringWithFormat:@"%ld年%ld月%ld日过期",year,month,day];

        if ([[NSString stringWithFormat:@"%@",[data objectForKey:@"type"]] isEqualToString:@"定期加息券"])
        {
            cell.limitLabel.text = [NSString stringWithFormat:@"使用规则：对%d万元以下投资增加%d%%固定年化收益",[NSString stringWithFormat:@"%@",[data objectForKey:@"principalLimit"]].intValue/10000,[NSString stringWithFormat:@"%@",[data objectForKey:@"raiseRate"]].intValue];
        }
        else
        {
            cell.limitLabel.text = [NSString stringWithFormat:@"使用规则：对%d万元以下投资增加%d%%募集期年化收益",[NSString stringWithFormat:@"%@",[data objectForKey:@"principalLimit"]].intValue/10000,[NSString stringWithFormat:@"%@",[data objectForKey:@"raiseRate"]].intValue];
        }
        
        if (choosen && ([[choosen objectForKey:@"voucherCode"] isEqualToString:[data objectForKey:@"voucherCode"]]))
        {
            
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    choosen = [datas objectAtIndex:indexPath.row];
    [self backToParent:nil];
}


@end
