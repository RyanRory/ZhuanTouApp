//
//  LoadingView.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/9/30.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.rotateImageView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width/2-25, frame.size.height/2-25, 50, 50)];
        
        self.rotateImageView.image = [UIImage imageNamed:@"loginSpinner.png"];
        
        [self addSubview:self.rotateImageView];
        
        //self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6f];
        self.layer.cornerRadius = 10;
    }
    return self;
}

- (void)startAnimation
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 0.8;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    [self.rotateImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stopAnimation
{
    [self.rotateImageView.layer removeAnimationForKey:@"rotationAnimation"];
    self.hidden = YES;
    [self removeFromSuperview];
}


@end
