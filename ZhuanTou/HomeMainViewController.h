//
//  HomeMainViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/25.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeMainViewController : UIViewController<UIScrollViewDelegate>
{
    UIImageView *leftImage, *midImage, *rightImage;
    NSArray *images;
    int currentImage;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end
