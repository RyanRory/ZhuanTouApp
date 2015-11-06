//
//  Header.h
//  AliPayDemo
//
//  Created by pg on 15/7/10.
//  Copyright (c) 2015年 pg. All rights reserved.
//

#ifndef AliPayDemo_Header_h
#define AliPayDemo_Header_h


#endif


















/******************* ITEM *********************/

#define ITEMRADIUS_OUTTER    60  //item的外圆直径
#define ITEMRADIUS_INNER     20  //item的内圆直径
#define ITEMRADIUS_LINEWIDTH 1   //item的线宽
#define ITEMWH               60  //item的宽高
#define ITEM_TOTAL_POSITION  170  // 整个item的顶点位置









/*********************** subItem *************************/

#define SUBITEMTOTALWH 50 // 整个subitem的大小
#define SUBITEMWH      12  //单个subitem的大小
#define SUBITEM_TOP    30 //整个的subitem的顶点位置(y点)








/*********************** 颜色 *************************/

//背景色
#define BACKGROUNDCOLOR [UIColor colorWithRed:56.0/255.0 green:148.0/255.0 blue:238.0/255.0 alpha:100]

//选中颜色
#define SELECTCOLOR [UIColor whiteColor]


//选错的颜色  红色
#define WRONGCOLOR ([UIColor colorWithRed:231.0/255.0 green:76.0/255.0 blue:60.0/255.0 alpha:1.0f])

//文字错误提示颜色   浅红色
#define LABELWRONGCOLOR ([UIColor colorWithRed:231.0/255.0 green:76.0/255.0 blue:60.0/255.0 alpha:1.0f])








/*********************** 文字提示语 *************************/
#define SETPSWSTRING          @"请滑动设置密码"
#define RESETPSWSTRING        @"请再次滑动确认密码"
#define PSWSUCCESSSTRING      @"设置密码成功"
#define PSWFAILTSTRING        [NSString stringWithFormat:@"密码错误，还可以再输入%d次",reTryTimes]
#define PSW_WRONG_NUMSTRING   @"请至少设置4个点"
#define INPUT_OLD_PSWSTRING   @"请输入原始密码"
#define INPUT_NEW_PSWSTRING   @"请输入新密码"






