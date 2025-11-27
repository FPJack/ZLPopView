//
//  GMCommonPopViews.m
//  GMPopView_Example
//
//  Created by admin on 2025/8/21.
//  Copyright © 2025 fanpeng. All rights reserved.
//

#import "GMCommonPopViews.h"

@implementation GMCommonPopViews
+ (ZLStackViewBuilder *)equalWidthStackViewBuilder {
    return ZLStackViewBuilder.row.distribution(ZLMainAxisAlignmentFillEqually);
}
+ (ZLStackViewBuilder *)equalButtonsStackViewBuilder {
    return [self equalWidthStackViewBuilder].space(1);
}
+ (UIButton *)confirmStyleBtn {
    return UIButton.customTypeButton.kfc 
        .title(@"确定")
        .titleFont([UIFont systemFontOfSize:14 weight:UIFontWeightMedium])
        .titleColor(UIColor.blueColor)
        .height(50)
        .view;
}
+ (UIButton *)cancelStyleBtn {
    return UIButton.customTypeButton.kfc 
        .title(@"取消")
        .titleFont([UIFont systemFontOfSize:14 weight:UIFontWeightMedium])
        .titleColor(UIColor.redColor)
        .dismissPopViewWhenTap
        .height(50)
        .view;
}
+ (UIButton *)deleteStyleBtn {
    return UIButton.customTypeButton.kfc
        .title(@"删除")
        .titleFont([UIFont systemFontOfSize:14 weight:UIFontWeightMedium])
        .titleColor(UIColor.redColor)
        .dismissPopViewWhenTap
        .height(50)
        .view;
}
+ (UIButton *)defaultStyleBtn {
    return UIButton.customTypeButton.kfc
        .title(@"默认")
        .titleFont([UIFont systemFontOfSize:14 weight:UIFontWeightMedium])
        .titleColor(UIColor.blackColor)
        .height(50)
        .view;
}
+ (UILabel *)titleStyleLabel {
    return UILabel.new.kfc 
        .font([UIFont systemFontOfSize:18 weight:UIFontWeightMedium])
        .textColor(UIColor.orangeColor)
        .textAlignment(NSTextAlignmentCenter)
        .numberOfLines(0)
        .spacing(16)
        .view;
}

+ (UILabel *)subTitleStyleLabel {
    return UILabel.new.kfc 
        .font([UIFont systemFontOfSize:14 weight:UIFontWeightRegular])
        .textColor([UIColor.blackColor colorWithAlphaComponent:0.5])
        .textAlignment(NSTextAlignmentCenter)
        .numberOfLines(0)
        .spacing(32)
        .view;
}
+ (UIView *)lineView {
    return  UIView.new.kfc.backgroundColor(kSeparatorColor).view;
}
+ (UIView *)horizontalLineView {
    return self.lineView.kfc.height(kSeparatorHeight).view;
}
+ (UIView *)verticalLineView {
    return self.lineView.kfc.width(kSeparatorWidth).view;
}

@end
