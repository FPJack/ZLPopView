//
//  UIButton+ZLHitArea.h
//  ZLPopView_Example
//
//  Created by Qiuxia Cui on 2025/12/24.
//  Copyright © 2025 fanpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ZLUIButtonImagePosition) {
    ZLUIButtonImagePositionLeft,
    ZLUIButtonImagePositionRight,
    ZLUIButtonImagePositionTop,
    ZLUIButtonImagePositionBottom
};


@interface UIButton (ZLHitArea)
/// 扩大点击区域（正数表示向外扩展）
/// 例如 UIEdgeInsetsMake(10, 10, 10, 10)
@property (nonatomic,assign)UIEdgeInsets zl_hitEdgeInsets;
/// 防止按钮被频繁点击，单位秒，默认0不限制
@property (nonatomic, assign) NSTimeInterval zl_acceptEventInterval;

@property (nonatomic,assign)ZLUIButtonImagePosition zl_imagePosition;



@end

NS_ASSUME_NONNULL_END
