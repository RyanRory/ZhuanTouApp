//
//  HomeMainViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/25.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeView.h"
#import "NoticeCenterViewController.h"
#import "WebDetailViewController.h"
#import "ProductsBeforeViewController.h"
#import "ProductBuyViewController.h"

@interface HomeMainViewController : UIViewController<UIScrollViewDelegate, UIGestureRecognizerDelegate>
{
    UIImageView *leftImage, *midImage, *rightImage;
    NSArray *images, *notices;
    int currentImage, currentNotice;
    NSTimer *timer, *noticeTimer;
    NoticeView *topView, *midView, *bottomView;
    UIButton *midImageButton;
    BOOL flag, animationFlag;
    CGPoint bgPoint;
    NSString *idCode, *bidableAmount;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIScrollView *noticeScrollView;
@property (strong, nonatomic) IBOutlet UIButton *noticeButton;
@property (strong, nonatomic) IBOutlet UIButton *buyButton;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIButton *productBeforeButton;
@property (strong, nonatomic) IBOutlet UIImageView *bgImageView;
@property (strong, nonatomic) IBOutlet UILabel *profitPercentLabel;
@property (strong, nonatomic) IBOutlet UILabel *monthNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *moryLabel;
@property (strong, nonatomic) IBOutlet UIButton *newerButton;

@end
