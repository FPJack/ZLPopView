//
//  UITabBar+EX.m
//  ZLPopView_Example
//
//  Created by admin on 2025/12/25.
//  Copyright © 2025 fanpeng. All rights reserved.
//

#import "UITabBar+EX.h"
#import <objc/runtime.h>
#import <ZLPopView/ZLPopView.h>
@implementation UITabBar (EX)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self __zl_hook_swizzleInstanceMethod:@selector(layoutSubviews) with: @selector(__tab_hook_layoutSubviews)];
        [self __zl_hook_swizzleInstanceMethod:@selector(hitTest:withEvent:) with: @selector(__hook_hitTest:withEvent:)];
    });
}
+ (BOOL)__zl_hook_swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel {
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (!originalMethod || !newMethod) return NO;
    class_addMethod(self,
                    originalSel,
                    class_getMethodImplementation(self, originalSel),
                    method_getTypeEncoding(originalMethod));
    class_addMethod(self,
                    newSel,
                    class_getMethodImplementation(self, newSel),
                    method_getTypeEncoding(newMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(self, originalSel),
                                   class_getInstanceMethod(self, newSel));
    return YES;
}


- (void)__tab_hook_layoutSubviews {
    [self __tab_hook_layoutSubviews];
    NSMutableArray <UIView *> *subviews = self.subviews.mutableCopy;
    [subviews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:UIControl.class]) {
            [subviews removeObjectAtIndex:idx];
        }
    }];
    NSLog(@"%@",subviews);

    NSArray *sortedSubviews = [subviews sortedArrayUsingComparator:^NSComparisonResult(UIView * formerView, UIView * latterView) {
        CGFloat formerViewX = formerView.frame.origin.x;
        CGFloat latterViewX = latterView.frame.origin.x;
        return  (formerViewX > latterViewX) ? NSOrderedDescending : NSOrderedAscending;
    }];

    CGFloat width = self.bounds.size.width / subviews.count;
    [sortedSubviews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 2) {
            obj.layer.cornerRadius = width / 2.0;
            obj.frame = CGRectMake(width * idx, -width/2.0 + 10, width, width);
        }else {
            obj.frame = CGRectMake(width * idx, 0, width, CGRectGetHeight(obj.frame));
        }
    }];
}

- (UIView *)__hook_hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    __block UIView *view = nil;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectContainsPoint(obj.frame, point)) {
            view = obj;
        }
    }];
    UITabBarController *tabBarController = (UITabBarController *)self.delegate;
    
    if (view) return view;
    return [super hitTest:point withEvent:event];
}
@end
