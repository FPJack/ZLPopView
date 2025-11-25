//
//  ZLConfigure.m
//  ZLPopView_Example
//
//  Created by admin on 2025/11/25.
//  Copyright © 2025 fanpeng. All rights reserved.
//

#import "ZLConfigure.h"
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

@implementation ZLConfigure
+ (void)initializeConfigure{
    BOOL isDark = NO;

//    ZLPopViewBuilder.defaultConfigureBK = ^(ZLBuildConfigObj * _Nonnull configure) {
//        //        configure.inset = UIEdgeInsetsMake(20, 0, 20, 0);
//        // configure.marge = UIEdgeInsetsMake(50, 50, 50, 50);
//        configure.shadowColor = UIColor.blackColor;
//        configure.shadowOpacity = 0.2;
//        configure.cornerRadius = 10;
//        configure.corners = UIRectCornerAllCorners;
//        configure.tapMaskDismiss = YES;
//        configure.enableDragDismiss = YES;
//        configure.backgroundColor = isDark ? DARK_BG_COLOR : LIGHT_BG_COLOR;
//    };
//    
//    
//    
//    ZLPopViewBuilder.defaultSeparatorColor = isDark ? DARK_LINE_COLOR : LIGHT_LINE_COLOR;
//    ZLPopViewBuilder.defaultSeparatorThickness = 0.5;
//    
//    ZLPopViewBuilder.defaultTitleLabelBK = ^UILabel * _Nullable(ZLPopViewBuilder * _Nonnull builder, NSString * _Nonnull text) {
//        return kTitleStyleLabel(text).kfc.textColor(isDark ? DARK_TITLE_COLOR : LIGHT_TITLE_COLOR).margeHorizontal(10).view;
//    };
//    
//    GMCustomPopViewBuilder.defaultTitleLabelBK = ^UILabel * _Nullable(ZLPopViewBuilder * _Nonnull builder, NSString * _Nonnull text) {
//        return kTitleStyleLabel(text).kfc.textColor(isDark ? DARK_TITLE_COLOR : LIGHT_TITLE_COLOR).margeHorizontal(10).view;
//    };
//    ZLPopViewBuilder.defaultMessageLabelBK = ^UILabel * _Nullable(ZLPopViewBuilder * _Nonnull builder, NSString * _Nonnull text) {
//        return kSubTitleStyleLabel(text).kfc.textColor(isDark ? DARK_SUBTITLE_COLOR : LIGHT_SUBTITLE_COLOR).margeHorizontal(10).view;
//    };
//    ZLPopViewBuilder.defaultAttributedViewBK = ^(ZLPopViewBuilder *builder, NSAttributedString *attributedString){
//        return UILabel.new.kfc
//            .multipleLines
//            .spacing(32)
//            .frontSpacing(10)
//            .margeHorizontal(10)
//            .attributedText(attributedString)
//            .view;
//    };
//    
//    ZLPopViewBuilder.defaultTextFieldViewBK = ^UITextField * _Nullable(ZLPopViewBuilder * _Nonnull builder, NSString * _Nonnull placeholder) {
//        return UITextField.new.kfc
//            .leftPadding(10)
//            .placeholder(placeholder)
////            .frontSpacing(20)
//            .spacing(15)
//            .clearButtonMode(UITextFieldViewModeWhileEditing)
//            .returnKeyType(UIReturnKeyDone)
//            .keyboardType(UIKeyboardTypeDefault)
//            .borderWidth(0.5)
//            .borderColor(UIColor.lightGrayColor)
//            .cornerRadius(5)
//            .margeHorizontal(15)
//            .height(40)
//            .view;
//    };
//    
//    ZLPopViewBuilder.defaultDeleteViewBK = ^UIView * _Nullable(ZLPopViewBuilder * _Nonnull builder, NSString * _Nonnull text) {
//        UIColor *color = isDark ? DARK_DESTRUCTIVE_COLOR : LIGHT_DESTRUCTIVE_COLOR;
//        return kDeleteStyleBtn.kfc.title(text).titleColor(color).defaultHighlightBgColor.view;
//    };
//    ZLPopViewBuilder.defaultConfirmViewBK = ^UIView * _Nullable(ZLPopViewBuilder * _Nonnull builder, NSString * _Nonnull text) {
//        UIColor *color = isDark ? DARK_BUTTON_COLOR : LIGHT_BUTTON_COLOR;
//        return kConfirmStyleBtn.kfc
//            .title(text)
//            .titleColor(color)
//            .defaultHighlightBgColor
//            .view;
//    };
//    ZLPopViewBuilder.defaultButtonViewBK = ^UIView * _Nullable(ZLPopViewBuilder * _Nonnull builder, NSString * _Nonnull text) {
//        UIColor *color = isDark ? DARK_BUTTON_COLOR : LIGHT_BUTTON_COLOR;
//        return kConfirmStyleBtn.kfc.title(text).titleColor(color).defaultHighlightBgColor.view;
//    };
//    ZLPopViewBuilder.defaultCancelViewBK = ^UIView * _Nullable(ZLPopViewBuilder * _Nonnull builder, NSString * _Nonnull text) {
//        UIColor *color = isDark ? DARK_CANCEL_COLOR : LIGHT_CANCEL_COLOR;
//        return kCancelStyleBtn.kfc
//            .title(text)
//            .titleColor(color)
//            .defaultHighlightBgColor
//            .view;
//    };
    
}
@end
