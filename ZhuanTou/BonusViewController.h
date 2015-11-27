//
//  BonusViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/25.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BonusTableViewCell.h"
#import "ZTTabBarViewController.h"

@interface BonusViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    int bonusNum;
    NSMutableArray *datas, *canDatas, *cannotDatas;
}

@property (strong, nonatomic) IBOutlet UITableView *tView;
@property (strong, nonatomic) IBOutlet UIButton *canUseButton;
@property (strong, nonatomic) IBOutlet UIButton *cannotUseButton;
@property (strong, nonatomic) IBOutlet UILabel *noBonusLabel;

@end
