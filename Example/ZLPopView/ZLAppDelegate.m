//
//  ZLAppDelegate.m
//  ZLPopView
//
//  Created by fanpeng on 11/25/2025.
//  Copyright (c) 2025 fanpeng. All rights reserved.
//

#import "ZLAppDelegate.h"
#import "ZLPopViewController.h"
#import "ZLLayoutViewController.h"
#import "ZLConvenienceViewController.h"
#import "ZLNavigationController.h"
#import "ZLPopOverViewController.h"
#import "ZLPopOverViewController.h"

@implementation ZLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

        // 创建 TabBarController
        UITabBarController *tabBarController = [[UITabBarController alloc] init];

        // 创建 4 个控制器
    ZLLayoutViewController *homeVC = [[ZLLayoutViewController alloc] init];
    ZLConvenienceViewController *discoverVC = [[ZLConvenienceViewController alloc] init];
    ZLPopViewController *messageVC = [[ZLPopViewController alloc] init];
    ZLPopOverViewController *popOverVC = [[ZLPopOverViewController alloc] init];

        // 设置标题
        homeVC.title = @"常用布局";
        discoverVC.title = @"便捷方法";
        messageVC.title = @"通用弹窗";
        popOverVC.title = @"Popover弹窗";

    // 设置 TabBarItem（图标可以换成你项目的图片）
    homeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页"
                                                      image:[UIImage imageNamed:@"tab_home"]
                                              selectedImage:[UIImage imageNamed:@"tab_home_sel"]];

    discoverVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"发现"
                                                          image:[UIImage imageNamed:@"tab_discover"]
                                                  selectedImage:[UIImage imageNamed:@"tab_discover_sel"]];

    messageVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"消息"
                                                         image:[UIImage imageNamed:@"tab_message"]
                                                 selectedImage:[UIImage imageNamed:@"tab_message_sel"]];
    popOverVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"popover弹窗"
                                                         image:[UIImage imageNamed:@"tab_message"]
                                                 selectedImage:[UIImage imageNamed:@"tab_message_sel"]];

        // 每个 VC 放入导航控制器（可选）
        UINavigationController *nav1 = [[ZLNavigationController alloc] initWithRootViewController:homeVC];
        UINavigationController *nav2 = [[ZLNavigationController alloc] initWithRootViewController:discoverVC];
        UINavigationController *nav3 = [[ZLNavigationController alloc] initWithRootViewController:messageVC];
        UINavigationController *nav4 = [[ZLNavigationController alloc] initWithRootViewController:popOverVC];
      
        // 添加到 TabBarController
        tabBarController.viewControllers = @[nav1, nav2, nav3,nav4];

        self.window.rootViewController = tabBarController;
        [self.window makeKeyAndVisible];

        return YES;
}


@end
