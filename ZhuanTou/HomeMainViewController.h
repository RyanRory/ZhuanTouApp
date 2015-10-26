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

@interface HomeMainViewController : UIViewController<UIScrollViewDelegate>
{
    UIImageView *leftImage, *midImage, *rightImage;
    NSArray *images, *notices;
    int currentImage, currentNotice;
    NSTimer *timer, *noticeTimer;
    NoticeView *topView, *midView, *bottomView;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIScrollView *noticeScrollView;
@property (strong, nonatomic) IBOutlet UIButton *noticeButton;

@end
