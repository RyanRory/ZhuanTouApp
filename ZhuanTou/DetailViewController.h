//
//  DetailViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/23.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailTableViewCell.h"
#import "SetpasswordViewController.h"

@interface DetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    int detailNum, dingqiPageNum, huoqiPageNum, inAndOutPageNum, allPageNum;
    NSMutableArray *dingqiDatas, *huoqiDatas, *inAndOutDatas, *allDatas;
    NSMutableArray *datas;
    int buttonTag;
}
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (strong, nonatomic) IBOutlet UIButton *dingqiButton;
@property (strong, nonatomic) IBOutlet UIButton *huoqiButton;
@property (strong, nonatomic) IBOutlet UIButton *inAndOutButton;
@property (strong, nonatomic) IBOutlet UIButton *allButton;
@property (strong, nonatomic) IBOutlet UITableView *tView;
@property (strong, nonatomic) IBOutlet UILabel *noRecordLabel;

@end
