//
//  PropertyTableViewCell.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/12/24.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PropertyTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *propertyLabel;
@property (strong, nonatomic) IBOutlet UILabel *balanceLabel;
@property (strong, nonatomic) IBOutlet UIButton *chargeButton;
@property (strong, nonatomic) IBOutlet UIButton *toProfitButton;
@property (strong, nonatomic) IBOutlet UIButton *drawButton;
@property (strong, nonatomic) IBOutlet UILabel *yesterdayProfitLabel;
@property (strong, nonatomic) IBOutlet UILabel *allProfitLabel;
@property (strong, nonatomic) IBOutlet UIButton *toYesterdayButton;
@property (strong, nonatomic) IBOutlet UIButton *toAllButon;

@end
