//
//  ProductMainViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/15.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICountingLabel.h"
#import "ProductBuyViewController.h"
#import "ZTTabBarViewController.h"
#import "ProductsBeforeViewController.h"

@interface ProductMainViewController : UIViewController<UIGestureRecognizerDelegate>
{
    CGRect frame;
    CGPoint bgPoint;
    CGPoint point;
    NSString *style;
}
@property (strong, nonatomic) IBOutlet UIButton *wenjianButton;
@property (strong, nonatomic) IBOutlet UIButton *zongheButton;
@property (strong, nonatomic) IBOutlet UIButton *huoqiButton;
@property (strong, nonatomic) IBOutlet UICountingLabel *bigRateLabel;
@property (strong, nonatomic) IBOutlet UILabel *monthNumLabel;
@property (strong, nonatomic) IBOutlet UIView *rightView;
@property (strong, nonatomic) IBOutlet UILabel *smallRateLabel;
@property (strong, nonatomic) IBOutlet UIButton *buyButton;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *percentLabel;
@property (strong, nonatomic) IBOutlet UILabel *rateContentLabel;
@property (strong, nonatomic) IBOutlet UIButton *productsBeforeButton;
@property (strong, nonatomic) IBOutlet UIImageView *bgCircleImageView;
@property (strong, nonatomic) IBOutlet UIButton *featureButton1;
@property (strong, nonatomic) IBOutlet UIButton *featureButton2;
@property (strong, nonatomic) IBOutlet UIButton *featureButton3;
@property (strong, nonatomic) IBOutlet UIButton *detailButton;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIImageView *triangleImageView;
@property (strong, nonatomic) IBOutlet UIImageView *circleImageView;
@property (strong, nonatomic) IBOutlet UILabel *moryLabel;
@property (strong, nonatomic) IBOutlet UIImageView *huoqiBgImageView1;
@property (strong, nonatomic) IBOutlet UIImageView *huoqiBgImageView2;

@end
