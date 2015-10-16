//
//  ProductBonusView.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/16.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductBonusView : UIView
{
    NSString *bonusID;
    UILabel *contentLabel;
    UIButton *checkboxButton;
}

- (NSString*)getBonusID;
- (void)setBonusID:(NSString*)str;

- (void)setContentLabelText:(NSString*)str;

@end
