//
//  ZLPopViewController.m
//  ZLPopView_Example
//
//  Created by admin on 2025/11/26.
//  Copyright © 2025 fanpeng. All rights reserved.
//

#import "ZLPopViewController.h"
#import <ZLPopView/ZLPopView.h>
#import "GMCommonPopViews.h"
#import "TableView.h"

@interface ZLPopViewController ()<ZLPopViewDelegate>

@end

@implementation ZLPopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.orangeColor;
    self.edgesForExtendedLayout = UIRectEdgeNone;

    ZLPopViewBuilder.defaultConfigureBK = ^(ZLBuildConfigObj * _Nonnull configure) {
        configure.tapMaskDismiss = YES;
        configure.enableDragDismiss = YES;
        configure.shadowColor = UIColor.blackColor;
        configure.shadowOpacity = 0.2;
        configure.cornerRadius = 10;
        configure.corners = UIRectCornerAllCorners;
        configure.tapMaskDismiss = YES;
        configure.enableDragDismiss = YES;
    };
    
    
    kStackViewColumnBuilder
    .distributionCenter
    .space(20)
    .addView(UILabel.kfc.text(@"顶部弹出").tapAction(^(__kindof UIView * _Nonnull view) {
        self.showTopBuilder.showTopPopView();
    }))
    .addView(UILabel.kfc.text(@"设置顶部间距150弹出").tapAction(^(__kindof UIView * _Nonnull view) {
        self.showTopBuilder.popViewMargeTop(150).showTopPopView();
    }))
    .addView(UILabel.kfc.text(@"中心弹出").tapAction(^(__kindof UIView * _Nonnull view) {
        self.showTopBuilder.showCenterPopView();
    }))
    .addView(UILabel.kfc.text(@"底部弹出").tapAction(^(__kindof UIView * _Nonnull view) {
        self.showTopBuilder.showBottomPopView();
    }))
    .addView(UILabel.kfc.text(@"左边弹出").tapAction(^(__kindof UIView * _Nonnull view) {
        self.showTopBuilder.showLeftPopView();
    }))
    .addView(UILabel.kfc.text(@"右边弹出").tapAction(^(__kindof UIView * _Nonnull view) {
        self.showTopBuilder.showRightPopView();
    }))
    .addView(UILabel.kfc.text(@"自定义动画").tapAction(^(__kindof UIView * _Nonnull view) {
        [self customAnimate];
    }))
    .addView(UILabel.kfc.text(@"输入框底部自动避开键盘(设置间距20)").tapAction(^(__kindof UIView * _Nonnull view) {
        self.showBottomTextInput1
            .avoidKeyboardFirstResponderBottom
            .bottomOffsetToKeyboardTop(10)
            .showBottomPopView();
    }))
    .addView(UILabel.kfc.text(@"弹窗底部自动避开键盘(设置间距0)").tapAction(^(__kindof UIView * _Nonnull view) {
        self.showBottomTextInput1
            .avoidKeyboardPopViewBottom
            .bottomOffsetToKeyboardTop(0)
            .showBottomPopView();
    }))
    .addView(UILabel.kfc.text(@"设置最大高度200（超出不可滑动）").tapAction(^(__kindof UIView * _Nonnull view) {
        [self showCenterMax200Builder];
    }))
    .addView(UILabel.kfc.text(@"设置最大高度200（超出可滑动）").tapAction(^(__kindof UIView * _Nonnull view) {
        [self showCenterMax200ScrollView];
    }))
    .addView(UILabel.kfc.text(@"顶部通知栏消息").tapAction(^(__kindof UIView * _Nonnull view) {
        ZLPopBaseView *popView = self.notificationMessageBuilder.buildTopPopView;
        [popView show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [popView dismiss];
        });
    }))
    .addView(UILabel.kfc.text(@"底部通知栏消息").tapAction(^(__kindof UIView * _Nonnull view) {
        ZLPopBaseView *popView = self.notificationMessageBuilder.buildBottomPopView;
        [popView show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [popView dismiss];
        });
    }))
    .addView(UILabel.kfc.text(@"右下角底部弹出").tapAction(^(__kindof UIView * _Nonnull view) {
        [self showRightBottomPopView];
    }))
    .addView(UILabel.kfc.text(@"loading").tapAction(^(__kindof UIView * _Nonnull view) {
        [self showLoading];
    }))
    .addView(UILabel.kfc.text(@"toast 文本提示").tapAction(^(__kindof UIView * _Nonnull view) {
        [self showToastText];
    }))
    .addView(UILabel.kfc.text(@"嵌套tableView处理手势冲突拖拽").tapAction(^(__kindof UIView * _Nonnull view) {
        [self showBottomTableViewPopView];
    }))
    .addView(UILabel.kfc.text(@"tableView拖拽悬浮").tapAction(^(__kindof UIView * _Nonnull view) {
        [self showTableViewBottomFloat];
    }))
    .buildScrollViewToSuperView(self.view);
    
}
- (ZLPopViewBuilder *)showTopBuilder {
    ZLPopViewBuilder *builder = ZLPopViewBuilder.column
        .alertWidth270
        .title(@"提示框")
        .message(@"这是一个简单的提示。")
        .addView(kConfirmStyleBtn)
        .addView(kDeleteStyleBtn)
        .addView(kCancelStyleBtn)
    ;
    return builder;
}
- (void )showCenterMax200Builder {
    ZLPopViewBuilder.column
        .alertWidth270
        .maxHeight(200)
        .wrapScrollView
        .title(@"提示框")
        .message(@"这是一个简单的提示。")
        .addView(kConfirmStyleBtn)
        .addView(kDeleteStyleBtn)
        .addView(kCancelStyleBtn)
        .addView(kConfirmStyleBtn)
        .addView(kDeleteStyleBtn)
        .addView(kCancelStyleBtn)
        .showCenterPopView();
}
- (void )showCenterMax200ScrollView {
    ZLPopViewBuilder.column
        .alertWidth270
        .maxHeight(200)
        .wrapScrollView
        .enableScrollWhenOutBounds
        .title(@"提示框")
        .message(@"这是一个简单的提示。")
        .addView(kConfirmStyleBtn)
        .addView(kDeleteStyleBtn)
        .addView(kCancelStyleBtn)
        .addView(kConfirmStyleBtn)
        .addView(kDeleteStyleBtn)
        .addView(kCancelStyleBtn)
        .showCenterPopView();
}
- (ZLPopViewBuilder *)showBottomTextInput1 {
    ZLPopViewBuilder *builder = kPopViewColumnBuilder
        .marge(0,0,0,0)
        .insetVertical(20,self.view.safeAreaInsets.bottom)
        .tapMaskDismiss
        .avoidKeyboardFirstResponderBottom
        .bottomOffsetToKeyboardTop(20)
        .topCorners(10);
   
    builder
        .title(@"提示框")
        .message(@"这是一个简单的提示框，您可以在这里添加更多内容。")
        .addTextField(^(UITextField * _Nonnull textField) {
            textField.placeholder = @"输入框";
            [textField.kfc becomeFirstResponderWhenPopViewAppear];
        })
        .addCancelViewStyleAction(^(UIView * _Nonnull view) {
            
        })
        .addConfirmViewStyleActionText(@"确认", nil);
        
    return builder;
    
}
- (ZLPopViewBuilder *)notificationMessageBuilder {
    NSString *text = @"这是一个通知消息这是一个通知消息这是一个通知消息这是一个通知消息这是一个通知消息";
    return kPopViewRowBuilder
        //底部可点击
        .touchPenetrate
        .distributionStart
        .alignmentStart
        .marge(50, 20, 50, 20)
        .inset(10, 10, 10, 10)
        .space(10)
        .addView(UIImageView.kfc.image(@"infor_popshare_weixin_nor").size(44))
        .addView(UILabel.kfc.text(text).multipleLines);
}
- (void)showRightBottomPopView {
    ZLPopRightView *popView =  kPopViewColumnBuilder
        .insetAll(0)
        .touchPenetrate
        .marge(0, 0, self.view.safeAreaInsets.bottom, 20)
        .addView(UIImageView.kfc.image(@"infor_popshare_weixin_nor").size(44))
        //构建右边弹出
        .buildRightPopView;
    
        popView
        //右边弹出，再设置垂直方向的偏移量
        .setCenterYOffset(self.view.bounds.size.height/2.0 - 50)
        .showPopView();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [popView dismiss];
    });
}
- (void)showLoading {
    UIActivityIndicatorView *indicatorView;
    if (@available(iOS 13.0, *)) {
        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
        indicatorView.color = UIColor.whiteColor;
    } else {
        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    [indicatorView startAnimating];
    
    ZLPopBaseView *popView =  kPopViewColumnBuilder
        .tapMaskDismiss
        .space(10)
        .horizontalLayoutConstraintCenter
        .alignmentCenter
        .avoidKeyboardAlwaysCenter
        .insetAll(15)
        .backgroundColor(UIColor.blackColor)
        .cornerRadius(10)
        .addView(indicatorView)
        .addView(UILabel.kfc.text(@"加载中...").systemFontSize(12)
                 .textColor(UIColor.whiteColor)
                 .textAlignmentCenter)
        .buildCenterPopView;
    [popView show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [popView dismiss];
    });
}
- (NSString *)text {
    NSUInteger length = arc4random_uniform(50) + 1; // 1~1000
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    for (NSUInteger i = 0; i < length; i++) {
        u_int32_t index = arc4random_uniform((u_int32_t)[letters length]);
        unichar c = [letters characterAtIndex:index];
        [randomString appendFormat:@"%C", c];
    }
    return randomString;
}
- (void)showToastText {
    
    ZLPopBaseView *view =
    kPopViewColumnBuilder
        .touchPenetrate
        .avoidKeyboardAlwaysCenter
        .maxWidthMultiplier(0.7)
        .maxHeightMultiplier(0.5)
        .enableScrollWhenOutBounds
        .alignmentFill
        .distributionFill
        .horizontalLayoutConstraintCenter
        .insetAll(10)
        .backgroundColor(UIColor.blackColor)
        .cornerRadius(5)
        .addView(UILabel.kfc
                 .text([self text])
                 .systemFontSize(12)
                 .textColor(UIColor.whiteColor)
                 .textAlignmentCenter
                 .numberOfLines(0))
        .buildCenterPopView
        .initStateBK(^(ZLPopBaseView * _Nonnull popView) {
            
        })
        .didShowBK(^(ZLPopBaseView * _Nonnull popView) {
            
        })
        .didHiddenBK(^(ZLPopBaseView * _Nonnull popView) {
            
        })
        .deallocBK(^(ZLPopBaseView * _Nonnull popView) {
            
        });
    [view show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [view dismiss];
    });
}
- (void)showBottomTableViewPopView {
    UILabel *label = UILabel.new.kfc
        .text(@"列表嵌套滑动")
        .textAlignment(NSTextAlignmentCenter)
        .view;
    kPopViewColumnBuilder
        .addView(label)
        .addView(TableView.new.kfc.height(400).view)
        .margeAll(0)
        .showBottomPopView();
}
- (void)showTableViewBottomFloat {
    
    kPopViewColumnBuilder
        .addDragGesture
        .addView(UILabel.kfc.text(@"列表嵌套滑动").textAlignmentCenter)
        .addView(TableView.kfc.height(400))
        .margeAll(0)
        .buildBottomPopFloatView
        .setFloatHeight(200)
        .showExpand;
}

- (void)customAnimate {
    ZLPopViewBuilder *builder = ZLPopViewBuilder.column
        .animateIn(0)
        .animateOut(0)
        .alertWidth270
        .insetTop(20);
    
    ZLPopCenterView *centerView = builder
        .addView(kTitleStyleLabel(@"提示框"))
        .addView(kSubTitleStyleLabel(@"这是一个自定义弹性放大缩小动画"))
        .addCancelViewStyleActionText(@"取消", nil)
        .addConfirmViewStyleActionText(@"确认", nil)
        .buildCenterPopView.delegate(self);
    centerView.tag = 988;
    [centerView show];
}
#pragma mark - ZLPopViewDelegate
- (void)popViewWillShow:(ZLPopBaseView *)popView {
    NSLog(@"popViewWillShow");
}
- (void)popViewDidShow:(ZLPopBaseView *)popView {
    NSLog(@"popViewDidShow");
    popView.containerView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    popView.containerView.hidden = NO;
    [UIView animateWithDuration:1
                          delay:0.0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.8
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        popView.containerView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        NSLog(@"弹性动画完成");
    }];
}
- (void)popViewWillHidden:(ZLPopBaseView *)popView {
    NSLog(@"popViewWillHidden");
    [UIView animateWithDuration:0.5 animations:^{
        popView.containerView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        //自定义动画完成后需要手动移除popView
        [popView removeFromSuperview];
    }];
    
}
- (void)popViewDidHidden:(ZLPopBaseView *)popView {
    NSLog(@"popViewDidHidden");
    
}
- (BOOL)popViewShouldRemoveFromSuperView:(ZLPopBaseView *)popView {
    //自定义动画告诉内部不需要自动移除popView，外部自行控制
    return popView.tag == 988 ? NO : YES;
}
@end
