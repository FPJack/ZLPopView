//
//  ZLAppDelegate.h
//  ZLPopView
//
//  Created by fanpeng on 11/25/2025.
//  Copyright (c) 2025 fanpeng. All rights reserved.
//

@import UIKit;

@interface ZLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/// 构建 App 的根控制器（AppDelegate 与 SceneDelegate 共用）
+ (UIViewController *)makeRootViewController;

@end
