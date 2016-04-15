//
//  YesterdayIncomeViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 16/1/12.
//  Copyright © 2016年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YesterdayIncomeTableViewCell.h"

@interface YesterdayIncomeViewController : ZTBaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *datas, *buffer;
    int dataNum;
}

@property (strong, nonatomic) IBOutlet UITableView *tView;

@end
