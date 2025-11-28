//
//  ZLConvenienceViewController.m
//  ZLPopView_Example
//
//  Created by admin on 2025/11/26.
//  Copyright © 2025 fanpeng. All rights reserved.
//

#import "ZLConvenienceViewController.h"
#import "ZLLayoutViewController.h"
#import <ZLPopView/ZLPopView.h>
#import "ZLCustomPopViewBuilder.h"
#import "GMCommonPopViews.h"
// 明亮模式主题色
#define LIGHT_BG_COLOR [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]
#define LIGHT_TITLE_COLOR [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0]
#define LIGHT_SUBTITLE_COLOR [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0]
#define LIGHT_LINE_COLOR [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0]
#define LIGHT_BUTTON_COLOR [UIColor colorWithRed:0.0 green:0.48 blue:1.0 alpha:1.0]
#define LIGHT_CANCEL_COLOR [UIColor colorWithRed:1.0 green:0.23 blue:0.19 alpha:1.0]
#define LIGHT_DESTRUCTIVE_COLOR [UIColor colorWithRed:1.0 green:0.23 blue:0.19 alpha:1.0]

// 暗黑模式主题色
#define DARK_BG_COLOR [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0]
#define DARK_TITLE_COLOR [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0]
#define DARK_SUBTITLE_COLOR [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0]
#define DARK_LINE_COLOR [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0]
#define DARK_BUTTON_COLOR [UIColor colorWithRed:0.0 green:0.48 blue:1.0 alpha:1.0]
#define DARK_CANCEL_COLOR [UIColor colorWithRed:1.0 green:0.27 blue:0.23 alpha:1.0]
#define DARK_DESTRUCTIVE_COLOR [UIColor colorWithRed:1.0 green:0.27 blue:0.23 alpha:1.0]
@interface ZLConvenienceViewController ()
@property (nonatomic,assign)BOOL isDark;
@end

@implementation ZLConvenienceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self refreshDefaultConfigure];
    kStackViewColumnBuilder
    .distributionCenter
    .space(20)
    .addViewBK(^ViewKFCType  _Nonnull{
        return kStackViewRowBuilder
            .addView(UILabel.kfc.text(@"开启黑暗模式"))
            .addView(UISwitch.kfc.valueChanged(^(UISwitch * _Nonnull sw) {
                self.isDark = sw.isOn;
                [self refreshDefaultConfigure];
            }))
            .buildStackView;
           
    })
    .addViewBK(^ViewKFCType  _Nonnull{
            return UILabel.kfc.text(@"").tapAction(^(__kindof UIView * _Nonnull view) {
                [self showAlert];
            });
    })
    .addViewBK(^ViewKFCType  _Nonnull{
            return UILabel.kfc.text(@"简单Alert弹窗").tapAction(^(__kindof UIView * _Nonnull view) {
                [self showAlert];
            });
    })
    .addViewBK(^ViewKFCType  _Nonnull{
            return UILabel.kfc.text(@"ActionSheet弹窗").tapAction(^(__kindof UIView * _Nonnull view) {
                [self showActionSheet];
            });
    })
    .addViewBK(^ViewKFCType  _Nonnull{
            return UILabel.kfc.text(@"微信弹窗").tapAction(^(__kindof UIView * _Nonnull view) {
                [self showWXSheet];
            });
    })
    .addViewBK(^ViewKFCType  _Nonnull{
            return UILabel.kfc.text(@"自定义按钮布局快捷弹窗1").tapAction(^(__kindof UIView * _Nonnull view) {
                [self showCustomActionViews];
            });
    })
    .addViewBK(^ViewKFCType  _Nonnull{
            return UILabel.kfc.text(@"自定义按钮布局快捷弹窗2").tapAction(^(__kindof UIView * _Nonnull view) {
                [self showCustomActionViews1];
            });
    })
    .addViewBK(^ViewKFCType  _Nonnull{
            return UILabel.kfc.text(@"自定义按钮布局快捷弹窗3").tapAction(^(__kindof UIView * _Nonnull view) {
                [self showCustomActionViews3];
            });
    })
    .addViewBK(^ViewKFCType  _Nonnull{
            return UILabel.kfc.text(@"自定义按钮布局快捷弹窗4").tapAction(^(__kindof UIView * _Nonnull view) {
                [self showCustomActionViews4];
            });
    })
    .buildStackViewToSuperView(self.view);
}
/// 刷新覆盖默认配置
- (void)refreshDefaultConfigure {
    
    BOOL isDark = self.isDark;
    ZLPopViewBuilder.defaultConfigureBK = ^(ZLBuildConfigObj * _Nonnull configure) {
        configure.tapMaskDismiss = YES;
        configure.enableDragDismiss = YES;
        configure.shadowColor = UIColor.blackColor;
        configure.shadowOpacity = 0.2;
        configure.cornerRadius = 10;
        configure.corners = UIRectCornerAllCorners;
        configure.tapMaskDismiss = YES;
        configure.enableDragDismiss = YES;
        configure.backgroundColor = isDark ? DARK_BG_COLOR : LIGHT_BG_COLOR;
    };
    
    ZLPopViewBuilder.defaultSeparatorColor = isDark ? DARK_LINE_COLOR : LIGHT_LINE_COLOR;
    ZLPopViewBuilder.defaultSeparatorThickness = 0.5;
    
    ZLPopViewBuilder.defaultTitleLabelBK = ^UILabel * _Nullable(ZLPopViewBuilder * _Nonnull builder, NSString * _Nonnull text) {
        return kTitleStyleLabel(text).kfc.textColor(isDark ? DARK_TITLE_COLOR : LIGHT_TITLE_COLOR).margeHorizontal(10).view;
    };
    ZLPopViewBuilder.defaultMessageLabelBK = ^UILabel * _Nullable(ZLPopViewBuilder * _Nonnull builder, NSString * _Nonnull text) {
        return kSubTitleStyleLabel(text).kfc.textColor(isDark ? DARK_SUBTITLE_COLOR : LIGHT_SUBTITLE_COLOR).margeHorizontal(10).view;
    };
    ZLPopViewBuilder.defaultAttributedViewBK = ^(ZLPopViewBuilder *builder, NSAttributedString *attributedString){
        return UILabel.new.kfc
            .multipleLines
            .spacing(32)
            .frontSpacing(10)
            .margeHorizontal(10)
            .attributedText(attributedString)
            .view;
    };
    
    ZLPopViewBuilder.defaultTextFieldViewBK = ^UITextField * _Nullable(ZLPopViewBuilder * _Nonnull builder, NSString * _Nonnull placeholder) {
        return UITextField.new.kfc
            .leftPadding(10)
            .placeholder(placeholder)
            .spacing(15)
            .clearButtonMode(UITextFieldViewModeWhileEditing)
            .returnKeyType(UIReturnKeyDone)
            .keyboardType(UIKeyboardTypeDefault)
            .borderWidth(0.5)
            .borderColor(UIColor.lightGrayColor)
            .cornerRadius(5)
            .margeHorizontal(15)
            .height(40)
            .view;
    };
    UIColor *highlightBgColor = isDark ? [UIColor.darkGrayColor colorWithAlphaComponent:0.5] : [UIColor.lightGrayColor colorWithAlphaComponent:0.1];
    ZLPopViewBuilder.defaultDeleteViewBK = ^UIView * _Nullable(ZLPopViewBuilder * _Nonnull builder, NSString * _Nonnull text) {
        UIColor *color = isDark ? DARK_DESTRUCTIVE_COLOR : LIGHT_DESTRUCTIVE_COLOR;
        return kDeleteStyleBtn.kfc.title(text)
            .titleColor(color)
            .highlightBgColor(highlightBgColor)
            .view;
    };
    ZLPopViewBuilder.defaultConfirmViewBK = ^UIView * _Nullable(ZLPopViewBuilder * _Nonnull builder, NSString * _Nonnull text) {
        UIColor *color = isDark ? DARK_BUTTON_COLOR : LIGHT_BUTTON_COLOR;
        return kConfirmStyleBtn.kfc
            .title(text)
            .titleColor(color)
            .highlightBgColor(highlightBgColor)
            .view;
    };
    ZLPopViewBuilder.defaultButtonViewBK = ^UIView * _Nullable(ZLPopViewBuilder * _Nonnull builder, NSString * _Nonnull text) {
        UIColor *color = isDark ? DARK_BUTTON_COLOR : LIGHT_BUTTON_COLOR;
        return kConfirmStyleBtn.kfc.title(text)
            .titleColor(color)
            .highlightBgColor(highlightBgColor)
            .view;
    };
    ZLPopViewBuilder.defaultCancelViewBK = ^UIView * _Nullable(ZLPopViewBuilder * _Nonnull builder, NSString * _Nonnull text) {
        UIColor *color = isDark ? DARK_CANCEL_COLOR : LIGHT_CANCEL_COLOR;
        return kCancelStyleBtn.kfc
            .title(text)
            .titleColor(color)
            .highlightBgColor(highlightBgColor)
            .view;
    };
    
}
- (void)showAlert {
        ZLPopViewBuilder.column
        .title(@"提示框")
        .message(@"这是一个简单的提示。")
        .avoidKeyboardAlwaysCenter
        .addTextField(^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入内容";
        })
        .addCancelViewStyleActionText(@"取消", ^(UIView * _Nonnull view) {
            
        })
        .addButtonViewStyleActionText(@"按钮", ^(UIView * _Nonnull view) {
            
        })
        .showAlert();
}
- (NSAttributedString *)textAttr {
    NSAttributedString *attrMessage = [[NSAttributedString alloc] initWithString:@"这是一个简单的提示。" attributes:@{NSForegroundColorAttributeName:UIColor.redColor,NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    
    // 创建段落样式
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter; // 居中对齐:cite[3]
    
    // 创建属性字典
    NSDictionary *attributes = @{
        NSParagraphStyleAttributeName: paragraphStyle,
        NSFontAttributeName: [UIFont systemFontOfSize:16],
        NSForegroundColorAttributeName: self.isDark ? DARK_SUBTITLE_COLOR : LIGHT_SUBTITLE_COLOR
    };
    
    // 创建富文本
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                   initWithString:@"你的文本内容"
                                                   attributes:attributes];
    [attributedString appendAttributedString:attrMessage];
    return attributedString;
}
- (void)showActionSheet {
        ZLPopViewBuilder.column
        .title(@"提示框")
        .message(@"这是一个简单的提示。")
        .attributedMsgText([self textAttr])
        .addDeleteViewStyleActionText(@"删除", ^(UIView * _Nonnull view) {
            
        })
        .addCancelViewStyleActionText(@"取消", nil)
    
        .showActionSheet();
}
- (void)showWXSheet {
        ZLPopViewBuilder.column
        .title(@"提示框")
        .message(@"这是一个简单的提示。")
        .addButtonViewStyleActionText(@"相册", ^(UIView * _Nonnull view) {
            
        })
        .addButtonViewStyleActionText(@"相机", ^(UIView * _Nonnull view) {
            
        })
        .addCancelViewStyleActionText(@"取消", ^(UIView * _Nonnull view) {
            
        })
        .showWXActionSheet();
}


- (void)showCustomActionViews {
    ZLPopViewBuilder *builder = ZLPopViewBuilder.column
        .alertWidth270
        .title(@"提示框")
        .message(@"这是一个简单的提示。")
        .addActionViewsContainerBK(kBottomActionViewsBK);
    
    builder.addCustomViewAction(kDefaultStyleBtn.kfc.roundCorner.backgroundColor(UIColor.redColor).view, ^(UIView * _Nonnull view) {
    })
    .addCustomViewAction(kDefaultStyleBtn.kfc.roundCorner.backgroundColor(UIColor.blueColor).view, ^(UIView * _Nonnull view) {
    })
    .addCustomViewAction(kDefaultStyleBtn.kfc.roundCorner.backgroundColor(UIColor.orangeColor).view, ^(UIView * _Nonnull view) {
    })
    .showCenterPopView();
}
- (void)showCustomActionViews1 {
    ZLCustomPopViewBuilder *builder = (ZLCustomPopViewBuilder *)ZLCustomPopViewBuilder.column
        .alertWidth270
        .title(@"提示框")
        .message(@"这是一个简单的提示。")
        .addActionViewsContainerBK(kBottomActionViewsColumnBK);
    
    builder.addCustomViewAction(kDefaultStyleBtn.kfc.roundCorner.backgroundColor(UIColor.redColor).view, ^(UIView * _Nonnull view) {
    })
    .addCustomViewAction(kDefaultStyleBtn.kfc.roundCorner.backgroundColor(UIColor.blueColor).view, ^(UIView * _Nonnull view) {
    })
    .addCustomViewAction(kDefaultStyleBtn.kfc.roundCorner.backgroundColor(UIColor.orangeColor).view, ^(UIView * _Nonnull view) {
    })
    .showCenterPopView();
}
- (void)showCustomActionViews3 {
    ZLPopViewBuilder *builder = ZLPopViewBuilder.column
        .alertWidth270
        .title(@"提示框")
        .message(@"这是一个简单的提示。")
        .addActionViewsContainerBK(kBottomActionViewsColumnBK);
    
    builder.addCustomViewAction(kDefaultStyleBtn.kfc.roundCorner.backgroundColor(UIColor.redColor).view, ^(UIView * _Nonnull view) {
    })
    .addCustomViewAction(kDefaultStyleBtn.kfc.roundCorner.backgroundColor(UIColor.blueColor).view, ^(UIView * _Nonnull view) {
    })
    .addCustomViewAction(kDefaultStyleBtn.kfc.roundCorner.backgroundColor(UIColor.orangeColor).view, ^(UIView * _Nonnull view) {
    })
    .showBottomPopView();
}
- (void)showCustomActionViews4 {
    ZLPopViewBuilder *builder =ZLPopViewBuilder.column
        .paddingBottom(20)
        .alertWidth270
        .title(@"提示框")
        .message(@"这是一个简单的提示。")
        .addActionViewsContainerBK(kBottomActionViewsBK);
    
    builder.addCustomViewAction(kDefaultStyleBtn.kfc.roundCorner.backgroundColor(UIColor.redColor).view, ^(UIView * _Nonnull view) {
    })
    .addCustomViewAction(kDefaultStyleBtn.kfc.roundCorner.backgroundColor(UIColor.blueColor).view, ^(UIView * _Nonnull view) {
    })
    .showBottomPopView();
}
@end
