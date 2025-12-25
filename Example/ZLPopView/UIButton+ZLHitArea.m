//
//  UIButton+ZLHitArea.m
//  ZLPopView_Example
//
//  Created by Qiuxia Cui on 2025/12/24.
//  Copyright © 2025 fanpeng. All rights reserved.
//

#import "UIButton+ZLHitArea.h"
#import <objc/runtime.h>
@implementation UIButton (ZLHitArea)
- (UIEdgeInsets)zl_hitEdgeInsets {
    NSValue *value = objc_getAssociatedObject(self, _cmd);
       if (value) {
           return [value UIEdgeInsetsValue];
       }
       return UIEdgeInsetsZero;
}
- (void)setZl_hitEdgeInsets:(UIEdgeInsets)zl_hitEdgeInsets {
    NSValue *value = [NSValue valueWithUIEdgeInsets:zl_hitEdgeInsets];
    objc_setAssociatedObject(self, @selector(zl_hitEdgeInsets), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    UIEdgeInsets insets = self.zl_hitEdgeInsets;
    if (UIEdgeInsetsEqualToEdgeInsets(insets, UIEdgeInsetsZero) ||
        !self.userInteractionEnabled ||
        !self.enabled ||
        self.hidden ||
        self.alpha < 0.01) {
        return [super pointInside:point withEvent:event];
    }
    CGRect hitFrame = UIEdgeInsetsInsetRect(self.bounds,
                                            UIEdgeInsetsMake(-insets.top,
                                                             -insets.left,
                                                             -insets.bottom,
                                                             -insets.right));
    return CGRectContainsPoint(hitFrame, point);
}
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self __zl_hook_swizzleInstanceMethod:@selector(sendAction:to:forEvent:) with: @selector(zl_hook_sendAction:to:forEvent:)];
        [self __zl_hook_swizzleInstanceMethod:@selector(layoutSubviews) with: @selector(__zl_hook_layoutSubviews)];
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
- (void)zl_hook_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if (!self.isUserInteractionEnabled) return;
    if (!self.enabled) return;
    if (self.alpha < 0.01) return;
    if (self.hidden) return;
    if (self.zl_acceptEventInterval > 0) {
        self.userInteractionEnabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                       (int64_t)(self.zl_acceptEventInterval * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
            self.userInteractionEnabled = YES;
        });
    }
    [self zl_hook_sendAction:action to:target forEvent:event];
}
- (void)setZl_acceptEventInterval:(NSTimeInterval)interval {
    objc_setAssociatedObject(self, @selector(zl_acceptEventInterval),
                             @(interval),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSTimeInterval)zl_acceptEventInterval {
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}
- (void)setZl_imagePosition:(ZLUIButtonImagePosition )zl_imagePosition {
    objc_setAssociatedObject(self, @selector(zl_imagePosition), @(zl_imagePosition), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (ZLUIButtonImagePosition )zl_imagePosition {
    NSNumber *p = objc_getAssociatedObject(self, _cmd);
    return p.integerValue;
}
- (void)__zl_hook_layoutSubviews {
    [self __zl_hook_layoutSubviews];
    CGFloat imageW = self.imageView.frame.size.width;
    CGFloat imageH = self.imageView.frame.size.height;
    CGFloat labelW = self.titleLabel.intrinsicContentSize.width;
    CGFloat labelH = self.titleLabel.intrinsicContentSize.height;

    UIEdgeInsets imageInsets = UIEdgeInsetsZero;
    UIEdgeInsets titleInsets = UIEdgeInsetsZero;
    ZLUIButtonImagePosition position = self.zl_imagePosition;
    CGFloat spacing = 0;
    switch (position) {
        case ZLUIButtonImagePositionTop:
            imageInsets = UIEdgeInsetsMake(-labelH-spacing/2, 0, 0, -labelW);
            titleInsets = UIEdgeInsetsMake(0, -imageW, -imageH-spacing/2, 0);
            break;
        case ZLUIButtonImagePositionBottom:
            imageInsets = UIEdgeInsetsMake(0, 0, -labelH-spacing/2, -labelW);
            titleInsets = UIEdgeInsetsMake(-imageH-spacing/2, -imageW, 0, 0);
            break;
        case ZLUIButtonImagePositionRight:
            imageInsets = UIEdgeInsetsMake(0, labelW+spacing/2, 0, -labelW-spacing/2);
            titleInsets = UIEdgeInsetsMake(0, -imageW-spacing/2, 0, imageW+spacing/2);
            break;
        default:
            break;
    }
    self.imageEdgeInsets = imageInsets;
    self.titleEdgeInsets = titleInsets;
}
@end
