//
//  GMCustomPopViewBuilder.m
//  GMPopView_Example
//
//  Created by admin on 2025/9/28.
//  Copyright © 2025 fanpeng. All rights reserved.
//

#import "ZLCustomPopViewBuilder.h"
#import "GMCommonPopViews.h"
@implementation ZLPopViewBuilder (custom)
- (ZLPopViewBuilder * _Nonnull (^)(void (^ _Nonnull)(UIView * _Nonnull)))ca_addDeleteBtnAction {
    return ^ZLPopViewBuilder *(void (^ _Nonnull block)(UIView * _Nonnull)) {
        self.addDeleteViewStyleActionText(@"删除", block);
        return self;
    };
}
- (ZLPopViewBuilder * _Nonnull (^)(void (^ _Nonnull)(UIView * _Nonnull)))ca_addConfirmBtnAction{
    return ^ZLPopViewBuilder *(void (^ _Nonnull block)(UIView * _Nonnull)) {
        self.addConfirmViewStyleActionText(@"确认", block);
        return self;
    };
}
- (ZLPopViewBuilder * _Nonnull (^)(void (^ _Nonnull)(UIView * _Nonnull)))ca_addCancelBtnAction {
    return ^ZLPopViewBuilder *(void (^ _Nonnull block)(UIView * _Nonnull)) {
        self.addCancelViewStyleActionText(@"取消", block);
        return self;
    };
}
+ (ZLActionViewsBK)ca_actionViewsBK {
    return ^UIView * _Nullable(NSArray<UIView *> * _Nonnull actionViews, ZLBaseStackViewBuilder * _Nonnull builder) {
        return ZLStackViewBuilder
            .rowFillEqually
            .space(10)
            .paddingLeading(10)
            .paddingTrailing(10)
            .paddingBottom(10)
            .alignmentFill
            .separatorColor(UIColor.blackColor)
            .addViews(actionViews)
            .buildStackView;
    };
}
+ (ZLActionViewsBK)ca_actionViewsColumnBK {
    return ^UIView * _Nullable(NSArray<UIView *> * _Nonnull actionViews, ZLBaseStackViewBuilder * _Nonnull builder) {
        return ZLStackViewBuilder
            .column
            .space(10)
            .paddingLeading(10)
            .paddingTrailing(10)
            .paddingBottom(10)
            .alignmentFill
            .separatorColor(UIColor.blackColor)
            .addViews(actionViews)
            .buildStackView;
    };
}
@end

@implementation ZLCustomPopViewBuilder

@end
