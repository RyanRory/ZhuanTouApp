//
//  NoticeView.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/26.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "NoticeView.h"

@implementation NoticeView

@synthesize imageView, label;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 7, 20, 20)];
        imageView.image = [UIImage imageNamed:@""];
        label  = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, frame.size.width-45, frame.size.height)];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textColor = ZTGRAY;
        
        [self addSubview:imageView];
        [self addSubview:label];
    }
    return self;
}

@end
