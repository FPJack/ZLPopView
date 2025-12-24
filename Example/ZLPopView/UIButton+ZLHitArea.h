//
//  UIButton+ZLHitArea.h
//  ZLPopView_Example
//
//  Created by Qiuxia Cui on 2025/12/24.
//  Copyright © 2025 fanpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (ZLHitArea)
/// 扩大点击区域（正数表示向外扩展）
/// 例如 UIEdgeInsetsMake(10, 10, 10, 10)
@property (nonatomic,assign)UIEdgeInsets zl_hitEdgeInsets;
@end

NS_ASSUME_NONNULL_END
