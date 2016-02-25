//
//  ChooseBonusViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 16/1/21.
//  Copyright © 2016年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseBonusTableViewCell.h"
#import "ChooseCouponsTableViewCell.h"
#import "ProductBuyNewViewController.h"

@interface ChooseBonusViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    int dataNum;
    BOOL didSelect;
}

@property (strong, nonatomic) IBOutlet UITableView *tView;

@property (readwrite, nonatomic) NSString *style;
@property (readwrite, nonatomic) NSMutableArray *datas;
@property (readwrite, nonatomic) id choosen;
@property (readwrite, nonatomic) int amount;
@property (readwrite, nonatomic) BOOL chooseFlag;

@end
