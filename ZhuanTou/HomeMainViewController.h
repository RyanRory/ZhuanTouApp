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
#import "ZTTabBarViewController.h"

@interface HomeMainViewController : UIViewController<UIScrollViewDelegate, UIGestureRecognizerDelegate>
{
    UIImageView *leftImage, *midImage, *rightImage;
    NSArray *images, *notices;
    int currentImage, currentNotice;
    NSTimer *timer, *noticeTimer;
    NoticeView *topView, *midView, *bottomView;
    UIButton *midImageButton;
    BOOL flag;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIScrollView *noticeScrollView;
@property (strong, nonatomic) IBOutlet UIButton *noticeButton;
@property (strong, nonatomic) IBOutlet UIButton *wenjianButton;
@property (strong, nonatomic) IBOutlet UIButton *huoqiButton;
@property (strong, nonatomic) IBOutlet UIButton *zongheButton;
@property (strong, nonatomic) IBOutlet UIButton *newerButton;
@property (strong, nonatomic) IBOutlet UIButton *zhaiquanButton;

@end
