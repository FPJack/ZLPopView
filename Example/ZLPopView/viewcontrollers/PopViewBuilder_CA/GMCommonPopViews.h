//
//  GMCommonPopViews.h
//  GMPopView_Example
//
//  Created by admin on 2025/8/21.
//  Copyright © 2025 fanpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ZLPopView/ZLPopView.h>
NS_ASSUME_NONNULL_BEGIN
//常用间距定义
//标题Label下边距
#define kPopTitleLabelAfterMarge  36
//确认取消按钮之间的间距
#define kPopBetweenButtonsSpace  27

//快捷Builder
#define kStackViewColumnBuilder [ZLStackViewBuilder column]
#define kStackViewRowBuilder [ZLStackViewBuilder row]

#define kPopViewColumnBuilder [ZLPopViewBuilder column]
#define kPopViewRowBuilder [ZLPopViewBuilder row]

//常用按钮样式
#define kConfirmStyleBtn [GMCommonPopViews confirmStyleBtn]
#define kCancelStyleBtn [GMCommonPopViews cancelStyleBtn]
#define kDeleteStyleBtn [GMCommonPopViews deleteStyleBtn]
#define kDefaultStyleBtn [GMCommonPopViews defaultStyleBtn]

//常用Label样式
#define kTitleStyleLabel(x) [GMCommonPopViews titleStyleLabel].kfc.text(x).view
#define kSubTitleStyleLabel(x) [GMCommonPopViews subTitleStyleLabel].kfc.text(x).view
#define kTextLabel(x) UILabel.new.kfc.text(x).view
#define kTextButton(x) UIButton.customTypeButton.kfc.title(x).view
//常用分割线
#define kLineView [GMCommonPopViews lineView]
#define kHorizontalLineView [GMCommonPopViews horizontalLineView]
#define kVerticalLineView [GMCommonPopViews verticalLineView]
#define kSeparatorColor [UIColor.lightGrayColor colorWithAlphaComponent:0.2]
#define kSeparatorHeight 0.7
#define kSeparatorWidth 0.7 

//常用Builder配置
#define kButtonsEqualWidthBuilder [GMCommonPopViews equalButtonsStackViewBuilder]
#define kViewsEqualWidthBuilder [GMCommonPopViews equalWidthStackViewBuilder]
@interface GMCommonPopViews : NSObject
/// view 宽度相等
+ (ZLStackViewBuilder *)equalWidthStackViewBuilder;

/// 按钮宽度相等 间距为kPopBetweenButtonsSpace
+ (ZLStackViewBuilder *)equalButtonsStackViewBuilder;

/// 确认样式按钮
+ (UIButton *)confirmStyleBtn;

/// 取消样式按钮
+ (UIButton *)cancelStyleBtn;

+ (UIButton *)deleteStyleBtn;

+ (UIButton *)defaultStyleBtn;


/// 大标题样式Label
+ (UILabel *)titleStyleLabel;

/// 子标题样式Label
+ (UILabel *)subTitleStyleLabel;
+ (UIView *)lineView;
+ (UIView *)horizontalLineView;
+ (UIView *)verticalLineView;
@end

NS_ASSUME_NONNULL_END
