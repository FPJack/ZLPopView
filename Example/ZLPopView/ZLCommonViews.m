//
//  ZLCommonViews.m
//  ZLPopView_Example
//
//  Created by admin on 2025/11/25.
//  Copyright © 2025 fanpeng. All rights reserved.
//

#import "ZLCommonViews.h"

@implementation ZLCommonViews
+ (ZLStackViewBuilder *)equalWidthStackViewBuilder {
    return ZLStackViewBuilder.row.distribution(ZLMainAxisAlignmentFillEqually);
}
+ (ZLStackViewBuilder *)equalButtonsStackViewBuilder {
    return [self equalWidthStackViewBuilder].space(1);
}
+ (UIButton *)confirmStyleBtn {
    return  UIButton.kfc
            .title(@"确定")
            .titleFont([UIFont systemFontOfSize:14 weight:UIFontWeightMedium])
            .titleColor(UIColor.blueColor)
            .height(50)
            .view;
}
+ (UIButton *)cancelStyleBtn {
    return UIButton.kfc
        .title(@"取消")
        .titleFont([UIFont systemFontOfSize:14 weight:UIFontWeightMedium])
        .titleColor(UIColor.redColor)
        .dismissPopViewWhenTap
        .height(50)
        .view;
}
+ (UIButton *)deleteStyleBtn {
    return UIButton.kfc
        .title(@"删除")
        .titleFont([UIFont systemFontOfSize:14 weight:UIFontWeightMedium])
        .titleColor(UIColor.redColor)
        .dismissPopViewWhenTap
        .height(50)
        .view;
}
+ (UIButton *)defaultStyleBtn {
    return UIButton.kfc
        .title(@"默认")
        .titleFont([UIFont systemFontOfSize:14 weight:UIFontWeightMedium])
        .titleColor(UIColor.blackColor)
        .height(50)
        .view;
}
+ (UILabel *)titleStyleLabel {
    return UILabel.kfc
        .font([UIFont systemFontOfSize:18 weight:UIFontWeightMedium])
        .textColor(UIColor.orangeColor)
        .textAlignment(NSTextAlignmentCenter)
        .numberOfLines(0)
        .spacing(16)
        .view;
}

+ (UILabel *)subTitleStyleLabel {
    return UILabel.kfc
        .font([UIFont systemFontOfSize:14 weight:UIFontWeightRegular])
        .textColor([UIColor.blackColor colorWithAlphaComponent:0.5])
        .textAlignment(NSTextAlignmentCenter)
        .numberOfLines(0)
        .spacing(32)
        .view;
}
+ (UIView *)lineView {
    return  UIView.kfc.backgroundColor(kSeparatorColor).view;
}
+ (UIView *)horizontalLineView {
    return self.lineView.kfc.height(kSeparatorHeight).view;
}
+ (UIView *)verticalLineView {
    return self.lineView.kfc.width(kSeparatorWidth).view;
}
@end
