//
//  ProductVoucherTableViewCell.h
//  ZhuanTou
//
//  Created by 赵润声 on 16/1/22.
//  Copyright © 2016年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductVoucherTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *couponsBgView;
@property (strong, nonatomic) IBOutlet UILabel *couponsNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *couponsLimitLabel;
@property (strong, nonatomic) IBOutlet UILabel *couponsDDLLabel;
@property (strong, nonatomic) IBOutlet UIButton *couponsButton;
@property (strong, nonatomic) IBOutlet UIButton *couponsMoreButton;
@property (strong, nonatomic) IBOutlet UILabel *couponsTitleLabel;

@end