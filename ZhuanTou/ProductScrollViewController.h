//
//  ProductScrollViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/11/12.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductBuyViewController.h"
#import "ProductsBeforeViewController.h"

@interface ProductScrollViewController : UIViewController<UIGestureRecognizerDelegate, UIScrollViewDelegate>
{
    CGRect frame;
    CGPoint bgPoint;
    CGPoint point;
    NSString *style;
    NSString *wenjianStartTime, *zongheStartTime;
    NSDictionary *wenjianData, *zongheData, *huoqiData;
    BOOL flag;
}

@property (strong, nonatomic) IBOutlet UIButton *wenjianButton;
@property (strong, nonatomic) IBOutlet UIButton *huoqiButton;
@property (strong, nonatomic) IBOutlet UIButton *zongheButton;

@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewHeight;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIView *wenjianView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wenjianViewWidth;
@property (strong, nonatomic) IBOutlet UIImageView *wenjianBgImageView;
@property (strong, nonatomic) IBOutlet UILabel *wenjianMonthLabel;
@property (strong, nonatomic) IBOutlet UILabel *wenjianMOYLabel;
@property (strong, nonatomic) IBOutlet UILabel *wenjianRateLabel;
@property (strong, nonatomic) IBOutlet UIButton *wenjianDetailButton;
@property (strong, nonatomic) IBOutlet UIButton *wenjianBuyButton;
@property (strong, nonatomic) IBOutlet UILabel *wenjianTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *wenjianAmountLabel;

@property (strong, nonatomic) IBOutlet UIView *zongheView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zongheViewWidth;
@property (strong, nonatomic) IBOutlet UIImageView *zongheBgImageView;
@property (strong, nonatomic) IBOutlet UILabel *zongheMonthLabel;
@property (strong, nonatomic) IBOutlet UILabel *zongheMOYLabel;
@property (strong, nonatomic) IBOutlet UILabel *zongheBigRateLabel;
@property (strong, nonatomic) IBOutlet UIButton *productsBeforeButton;
@property (strong, nonatomic) IBOutlet UIButton *zongheDetailButton;
@property (strong, nonatomic) IBOutlet UILabel *zongheSmallRateLabel;
@property (strong, nonatomic) IBOutlet UIButton *zongheBuyButton;
@property (strong, nonatomic) IBOutlet UILabel *zongheAmountLabel;
@property (strong, nonatomic) IBOutlet UILabel *zongheTimeLabel;

@property (strong, nonatomic) IBOutlet UIView *huoqiView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *huoqiViewWidth;
@property (strong, nonatomic) IBOutlet UIImageView *huoqiBgImageView1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *x1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *y1;
@property (strong, nonatomic) IBOutlet UIImageView *huoqiBgImageView2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *x2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *y2;
@property (strong, nonatomic) IBOutlet UILabel *huoqiRateLabel;
@property (strong, nonatomic) IBOutlet UIButton *huoqiDetailButton;
@property (strong, nonatomic) IBOutlet UIButton *huoqiBuyButton;
@property (strong, nonatomic) IBOutlet UILabel *huoqiAmountLabel;

@end
