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

@end
