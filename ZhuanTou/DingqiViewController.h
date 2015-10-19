//
//  DingqiViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/18.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WenjianIngTableViewCell.h"
#import "WenjianEndedTableViewCell.h"
#import "ZongheEndedTableViewCell.h"
#import "ZongheIngTableViewCell.h"

@interface DingqiViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    int productsNum;
    NSMutableArray *datas;
}

@property (strong, nonatomic) IBOutlet UIView *noneProductView;
@property (strong, nonatomic) IBOutlet UIButton *findProductButton;
@property (strong, nonatomic) IBOutlet UITableView *tView;
@property (strong, nonatomic) IBOutlet UIButton *ingButton;
@property (strong, nonatomic) IBOutlet UIButton *endedButton;


@end
