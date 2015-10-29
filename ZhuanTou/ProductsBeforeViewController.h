//
//  ProductsBeforeViewController.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/29.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductsBeforeTableViewCell.h"

@interface ProductsBeforeViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    int productsNum;
    NSMutableArray *datas;
}

@property (strong, nonatomic) IBOutlet UITableView *tView;

@end
