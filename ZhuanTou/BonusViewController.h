//
//  BonusViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/25.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BonusTableViewCell.h"

@interface BonusViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    int bonusNum;
    NSMutableArray *datas;
}

@property (strong, nonatomic) IBOutlet UITableView *tView;

@end
